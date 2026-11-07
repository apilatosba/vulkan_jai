//
// the metaprogram side of VulkanJai (METAPROGRAM = true): finds the calls of the Create...Pipeline overloads that take shaders and of BakeShader (baking.jai)
// in the program, compiles their shaders with ApilaSpirv when everything is typechecked, and fills the #placeholder __GetBakedSpirv with the spirv.
//
// it keeps its state in globals like ApilaSpirv does, so it can build one workspace.
//

#import "Basic";
#import "Compiler";
#import "String";
#import "File";
#import "Process";
#import "Hash_Table";

BuildOptions :: struct {
   optimize:            bool;    // runs spirv-opt on every shader (ApilaSpirv.Optimize)
   validate:            bool;    // runs spirv-val on every shader, the build fails if one is invalid
   spirvOutputFolder:   string;  // if it is set every baked shader is also written there, to look at it with spirv-dis
   spirvOptPath:        string = "spirv-opt";
   spirvValPath:        string = "spirv-val";
}

GetBuildOptions :: (w: Workspace) -> BuildOptions {
   options, newlyAdded := find_or_add(*workspaceToBuildOptions, w);
   if (newlyAdded)  options.* = .{};
   return options.*;
}

SetBuildOptions :: (options: BuildOptions, w: Workspace) {
   table_set(*workspaceToBuildOptions, w, options);
}

// give every message of the workspace to this
ProcessMessage :: (message: *Message) {
   // ApilaSpirv collects what it needs from the program (the structs, the constants, its own variables...) from these.
   // its COMPLETE compiles the entry points that have the @compute, @mesh... notes, that is not used here: the shaders are found from the calls.
   if (message.kind == .TYPECHECKED)  ApilaSpirv.ProcessMessage(message);

   if message.kind == {
      case .IMPORT; {
         mi := cast(*Message_Import) message;
         if (mi.module_name == MODULE_NAME && moduleImport == null)  moduleImport = mi;
      }

      case .TYPECHECKED; {
         FindCalls(cast(*Message_Typechecked) message);
      }

      // the shaders are typechecked by now. the program waits for __GetBakedSpirv, so this is the first time it is TYPECHECKED_ALL_WE_CAN
      case .PHASE; {
         mp := cast(*Message_Phase) message;
         if (mp.phase == .TYPECHECKED_ALL_WE_CAN && !baked) {
            baked = true;
            Bake(message.workspace);
         }
      }
   }
}

#scope_module

ApilaSpirv :: #import "ApilaSpirv"(METAPROGRAM = true);

MODULE_NAME :: "VulkanJai";

// the procedures of baking.jai that take shaders. the Create...Pipeline functions that take spirv have the same names, these are the polymorphic ones
SHADER_PROCEDURES :: string.["CreateComputePipeline", "CreateMeshletPipeline", "BakeShader"];

workspaceToBuildOptions: Table(Workspace, BuildOptions);
moduleImport:            *Message_Import; // the module scope of the program's VulkanJai, where __GetBakedSpirv is
baked:                   bool;
calls:                   [..] PipelineCall;

PipelineCall :: struct {
   call:       *Code_Procedure_Call;
   location:   Source_Code_Location; // the key of its spirv, it is the #caller_location of the call
   shaders:    [..] Shader;
}

// what ApilaSpirv.CompileEntryPoint takes
Shader :: struct {
   header:          *Code_Procedure_Header;
   stage:           ApilaSpirv.ShaderType;
   workgroupSize:   [3] u32 = .[1, 1, 1];                       // compute, task and mesh
   maxVertices:     u32;                                        // mesh
   maxPrimitives:   u32;                                        // mesh
   topology:        ApilaSpirv.PrimitiveTopology = .Triangles;  // mesh
   name:            string;  // for the file names of spirvOutputFolder: the name the call gives (SHADERS.MyShader is MyShader), "literal" for a procedure literal
   spirvIndex:      int;
}

Error :: (node: *Code_Node, format: string, arguments: .. Any) {
   compiler_report(tprint("VulkanJai: %", tprint(format, ..arguments)), make_location(node));
}

FindCalls :: (message: *Message_Typechecked) {
   for body: message.procedure_bodies {
      for body.subexpressions {
         if (it.kind == .PROCEDURE_CALL)  CheckCall(cast(*Code_Procedure_Call) it, inStructLiteral = false);

         // the members of a struct literal are not in the subexpressions: .{ closestHit = BakeShader(...) }
         if (it.kind == .LITERAL && (cast(*Code_Literal) it).value_type == .STRUCT)  VisitStructLiteralMembers(it);
      }
   }
}

VisitStructLiteralMembers :: (node: *Code_Node) {
   if (node == null) return;

   if node.kind == {
      case .PROCEDURE_CALL; {
         call := cast(*Code_Procedure_Call) node;
         CheckCall(call, inStructLiteral = true);
         for call.arguments_unsorted  VisitStructLiteralMembers(it.expression);
      }

      case .LITERAL; {
         literal := cast(*Code_Literal) node;
         if (literal.value_type == .STRUCT && literal.struct_literal_info)  for literal.struct_literal_info.arguments  VisitStructLiteralMembers(it);
         if (literal.value_type == .ARRAY && literal.array_literal_info)    for literal.array_literal_info.array_members  VisitStructLiteralMembers(it);
      }

      case .BINARY_OPERATOR; {
         binary := cast(*Code_Binary_Operator) node;
         VisitStructLiteralMembers(binary.left);
         VisitStructLiteralMembers(binary.right);
      }

      case .UNARY_OPERATOR;  VisitStructLiteralMembers((cast(*Code_Unary_Operator) node).subexpression);
   }
}

CheckCall :: (call: *Code_Procedure_Call, inStructLiteral: bool) {
   callee := call.resolved_procedure_expression;

   // the metaprogram gets a call in an untyped struct literal in an array literal (.[.{ closestHit = BakeShader(...) }]) untyped, nothing in it is resolved.
   // the typechecked call the program runs is somewhere the messages dont show. so it is found by its name, and it cant be baked.
   // only BakeShader is checked: CreateComputePipeline and CreateMeshletPipeline have overloads that take spirv, an unresolved call can be one of those.
   // (the calls in the body of a polymorphic procedure that is not instantiated are not resolved either, those are fine, the instances are)
   if (callee == null) {
      if (inStructLiteral && GetCalledName(call.procedure_expression) == "BakeShader") {
         Error(call, "BakeShader cant be called in an untyped struct literal in an array literal (.[.{ closestHit = BakeShader(...) }]), the metaprogram doesnt get the typechecked call (so it doesnt know the shader). write the type of the struct literal (.[RayHitGroup.{ closestHit = BakeShader(...) }]) or put the result in a variable first.");
      }
      return;
   }

   if (callee.kind != .PROCEDURE_HEADER) return;

   // the overloads that take shaders are polymorphic ($shader), so the call is of an instance of them
   source := (cast(*Code_Procedure_Header) callee).polymorph_source_header;
   if (source == null || !IsModuleProcedure(source)) return;
   if (!array_find(SHADER_PROCEDURES, source.name)) return;

   if (baked) {
      Error(call, "this call is typechecked after the shaders are baked, its shaders cant be baked anymore. is it in code that waits for a #placeholder of your metaprogram?");
      return;
   }

   AddCall(call, source);
}

// Foo or Module.Foo -> "Foo"
GetCalledName :: (node: *Code_Node) -> string {
   if (node == null) return "";
   if (node.kind == .BINARY_OPERATOR && (cast(*Code_Binary_Operator) node).operator_type == #char ".")  node = (cast(*Code_Binary_Operator) node).right;
   if (node.kind != .IDENT) return "";
   return (cast(*Code_Ident) node).name;
}

IsModuleProcedure :: (header: *Code_Procedure_Header) -> bool {
   load := header.enclosing_load;
   return load != null && load.enclosing_import != null && load.enclosing_import.module_name == MODULE_NAME;
}

AddCall :: (call: *Code_Procedure_Call, source: *Code_Procedure_Header) {
   pipelineCall: PipelineCall;
   pipelineCall.call = call;
   pipelineCall.location = make_location(call);

   ok := true;

   // the shader given to the parameter named shaderArgument. the optional ones that are not given (null) are not added
   Add :: (shaderArgument: string, shader: Shader) #expand {
      header, isNull := ResolveShader(GetArgument(`call, `source, shaderArgument));
      if (isNull) return;
      if (header == null) {
         Error(`call, "couldnt find what the % shader (%) is. it has to be a procedure or a procedure literal.", shader.stage, shaderArgument);
         `ok = false;
         return;
      }

      result := shader;
      result.header = header;
      result.name = GetCalledName(GetArgument(`call, `source, shaderArgument));
      if (!result.name)  result.name = "literal";
      array_add(*`pipelineCall.shaders, result);
   }

   // a $ parameter that is a count, it has to be greater than zero
   Count :: (name: string) -> u32 #expand {
      value, isInt := EvaluateInt(GetArgument(`call, `source, name));
      if (!isInt || value <= 0 || value > 0xFFFF_FFFF) {
         Error(`call, "% has to be an integer constant greater than zero", name);
         `ok = false;
         return 0;
      }
      return xx value;
   }

   Enum :: (name: string, $T: Type) -> T #expand {
      value, found := EvaluateEnum(GetArgument(`call, `source, name), T);
      if (!found) {
         Error(`call, "% has to be a constant", name);
         `ok = false;
      }
      return value;
   }

   if source.name == {
      case "CreateComputePipeline"; {
         Add("shader", .{ stage = .Compute, workgroupSize = .[Count("LOCAL_SIZE_X"), Count("LOCAL_SIZE_Y"), Count("LOCAL_SIZE_Z")] });
      }

      case "CreateMeshletPipeline"; {
         mesh: Shader;
         mesh.stage         = .Mesh;
         mesh.workgroupSize = .[Count("MESH_LOCAL_SIZE_X"), Count("MESH_LOCAL_SIZE_Y"), Count("MESH_LOCAL_SIZE_Z")];
         mesh.maxVertices   = Count("MAX_VERTICES");
         mesh.maxPrimitives = Count("MAX_PRIMITIVES");
         mesh.topology      = Enum("TOPOLOGY", ApilaSpirv.PrimitiveTopology);

         Add("task", .{ stage = .Task, workgroupSize = .[Count("TASK_LOCAL_SIZE_X"), Count("TASK_LOCAL_SIZE_Y"), Count("TASK_LOCAL_SIZE_Z")] });
         Add("mesh", mesh);
         Add("fragment", .{ stage = .Fragment });
      }

      case "BakeShader"; {
         shader: Shader;
         shader.stage = Enum("STAGE", ApilaSpirv.ShaderType);
         if (!ok) return;

         hasWorkgroup := shader.stage == .Compute || shader.stage == .Task || shader.stage == .Mesh;
         isMesh       := shader.stage == .Mesh;

         // the parameters of another stage are not ignored silently
         for name: string.["LOCAL_SIZE_X", "LOCAL_SIZE_Y", "LOCAL_SIZE_Z", "MAX_VERTICES", "MAX_PRIMITIVES", "TOPOLOGY"] {
            isOfStage := ifx begins_with(name, "LOCAL_SIZE") then hasWorkgroup else isMesh;
            if (!isOfStage && IsGiven(call, source, name)) {
               Error(call, "% is not a parameter of a % shader", name, shader.stage);
               ok = false;
            }
         }
         if (!ok) return;

         if (hasWorkgroup)  shader.workgroupSize = .[Count("LOCAL_SIZE_X"), Count("LOCAL_SIZE_Y"), Count("LOCAL_SIZE_Z")];

         if (isMesh) {
            shader.maxVertices   = Count("MAX_VERTICES");
            shader.maxPrimitives = Count("MAX_PRIMITIVES");
            shader.topology      = Enum("TOPOLOGY", ApilaSpirv.PrimitiveTopology);
         }

         Add("shader", shader);
      }
   }

   if (!ok || pipelineCall.shaders.count == 0) return;

   // the same call can be typechecked more than once (it is in a polymorphic procedure that is instantiated more than once). it has the same shaders then, unless
   // the shaders depend on the polymorph, that cant be baked since the spirv is found by the location of the call.
   for calls {
      if (!IsSameLocation(it.location, pipelineCall.location)) continue;

      if (!IsSameShaders(it.shaders, pipelineCall.shaders)) {
         Error(call, "this call has different shaders each time it is compiled (it is in a polymorphic procedure or a macro?). the spirv is found by the location of the call, so they cant be baked.");
      }
      return;
   }

   array_add(*calls, pipelineCall);
}

// the call gives the parameter (it is not the default value)
IsGiven :: (call: *Code_Procedure_Call, source: *Code_Procedure_Header, name: string) -> bool {
   for call.arguments_unsorted {
      if (it.name != null && it.name.name == name) return true;
      if (it.name == null && it_index < source.arguments.count && source.arguments[it_index].name == name) return true;
   }
   return false;
}

// the expression the call gives to the parameter, or its default value
GetArgument :: (call: *Code_Procedure_Call, source: *Code_Procedure_Header, name: string) -> *Code_Node {
   for call.arguments_unsorted {
      argumentName := "";
      if (it.name != null)                         argumentName = it.name.name;
      else if (it_index < source.arguments.count)  argumentName = source.arguments[it_index].name;

      if (argumentName == name) return it.expression;
   }

   for source.arguments {
      if (it.name == name) return it.expression;
   }

   return null;
}

// MyShader, SHADERS.MyShader, ALIAS :: MyShader, or a procedure literal. isNull is for the optional shaders that arent given (the default is null)
ResolveShader :: (node: *Code_Node) -> *Code_Procedure_Header, isNull: bool {
   if (node == null) return null, true;

   if node.kind == {
      case .PROCEDURE_HEADER; return cast(*Code_Procedure_Header) node, false;

      case .IDENT; {
         declaration := (cast(*Code_Ident) node).resolved_declaration;
         if (declaration == null || declaration.expression == null) return null, false;
         header, isNull := ResolveShader(declaration.expression);
         return header, isNull;
      }

      case .BINARY_OPERATOR; {
         binary := cast(*Code_Binary_Operator) node;
         if (binary.operator_type != #char ".") return null, false;
         header, isNull := ResolveShader(binary.right);
         return header, isNull;
      }

      case .LITERAL; {
         literal := cast(*Code_Literal) node;
         return null, literal.value_type == .POINTER; // null
      }
   }

   return null, false;
}

EvaluateInt :: (node: *Code_Node) -> int, bool {
   if (node == null) return 0, false;

   if node.kind == {
      case .LITERAL; {
         literal := cast(*Code_Literal) node;
         if (literal.value_type != .NUMBER || (literal.value_flags & .FLOAT)) return 0, false;
         return literal._s64, true;
      }

      case .IDENT; {
         declaration := (cast(*Code_Ident) node).resolved_declaration;
         if (declaration == null || !(declaration.flags & .IS_CONSTANT)) return 0, false;
         value, ok := EvaluateInt(declaration.expression);
         return value, ok;
      }

      case .UNARY_OPERATOR; {
         unary := cast(*Code_Unary_Operator) node;
         value, ok := EvaluateInt(unary.subexpression);
         if (unary.operator_type == #char "-") return -value, ok;
      }

      case .BINARY_OPERATOR; {
         binary := cast(*Code_Binary_Operator) node;
         if (binary.operator_type == #char ".") {
            value, ok := EvaluateInt(binary.right); // SOME_MODULE.CONSTANT
            return value, ok;
         }

         left, leftOk := EvaluateInt(binary.left);
         right, rightOk := EvaluateInt(binary.right);
         if (!leftOk || !rightOk) return 0, false;

         if binary.operator_type == {
            case #char "+"; return left + right, true;
            case #char "-"; return left - right, true;
            case #char "*"; return left * right, true;
            case #char "/"; if (right != 0) return left / right, true;
         }
      }
   }

   return 0, false;
}

// .Triangles, PrimitiveTopology.Triangles, or a constant that is one of them
EvaluateEnum :: (node: *Code_Node, $T: Type) -> T, bool {
   info := type_info(T);

   name := GetEnumValueName(node, info.names);
   for info.names  if (it == name) return cast(T) info.values[it_index], true;

   // a constant can be typechecked into its value
   value, ok := EvaluateInt(node);
   if (ok)  for info.values  if (it == value) return cast(T) value, true;

   return cast(T) 0, false;
}

GetEnumValueName :: (node: *Code_Node, names: [] string) -> string {
   if (node == null) return "";

   if node.kind == {
      case .IDENT; {
         ident := cast(*Code_Ident) node;
         if (array_find(names, ident.name)) return ident.name;

         declaration := ident.resolved_declaration;
         if (declaration == null || !(declaration.flags & .IS_CONSTANT)) return "";
         return GetEnumValueName(declaration.expression, names);
      }

      case .UNARY_OPERATOR;   return GetEnumValueName((cast(*Code_Unary_Operator) node).subexpression, names);

      case .BINARY_OPERATOR; {
         binary := cast(*Code_Binary_Operator) node;
         if (binary.operator_type == #char ".") return GetEnumValueName(binary.right, names);
      }
   }

   return "";
}

IsSameLocation :: (a: Source_Code_Location, b: Source_Code_Location) -> bool {
   return a.line_number == b.line_number && a.character_number == b.character_number && a.fully_pathed_filename == b.fully_pathed_filename;
}

IsSameShaders :: (a: [] Shader, b: [] Shader) -> bool {
   if (a.count != b.count) return false;
   for a  if (ShaderKey(it) != ShaderKey(b[it_index])) return false;
   return true;
}

// the shader and the parameters it is compiled with
ShaderKey :: (using shader: Shader) -> string {
   return tprint("% % % % % % % %", cast(u64) header, stage, workgroupSize[0], workgroupSize[1], workgroupSize[2], maxVertices, maxPrimitives, topology);
}

Bake :: (w: Workspace) {
   // the program doesnt import VulkanJai
   if (moduleImport == null) return;

   options := GetBuildOptions(w);

   spirvs: [..] [] u8;
   compiled: Table(string, int); // ShaderKey -> index in spirvs. the same shader of more than one call is compiled once

   for * call: calls {
      for * shader: call.shaders {
         if (shader.header.body_or_null == null) {
            Error(call.call, "the body of the % shader % is not typechecked", shader.stage, shader.header.name);
            continue;
         }

         key := ShaderKey(shader);
         found, index := table_find(*compiled, key);
         if (found) {
            shader.spirvIndex = index;
            continue;
         }

         spirv := ApilaSpirv.CompileEntryPoint(shader.header, shader.stage, shader.workgroupSize, shader.maxVertices, shader.maxPrimitives, shader.topology);
         spirv = PostProcess(spirv, options, call, shader, w);

         shader.spirvIndex = spirvs.count;
         table_add(*compiled, key, spirvs.count);
         array_add(*spirvs, spirv);
      }
   }

   add_build_string(GenerateBakedSpirv(spirvs), w, moduleImport);
}

// optimizes, validates and writes the spirv to spirvOutputFolder, the ones of these that are set in the options.
PostProcess :: (input: [] u8, options: BuildOptions, call: *PipelineCall, shader: *Shader, w: Workspace) -> [] u8 {
   spirv := input;
   if (!options.optimize && !options.validate && !options.spirvOutputFolder) return spirv;

   name := tprint("%_%_%_%.spv", path_strip_extension(path_filename(call.location.fully_pathed_filename)), call.location.line_number, to_lower_copy(tprint("%", shader.stage)), shader.name);
   folder := options.spirvOutputFolder;
   if (!folder)  folder = tprint("%/vulkanjai2", get_build_options(w).intermediate_path);
   make_directory_if_it_does_not_exist(folder, recursive = true);
   path := tprint("%/%", folder, name);

   ok := write_entire_file(path, spirv.data, spirv.count);
   assert(ok, "couldnt write %", path);

   if (options.optimize) {
      spirvOptions := ApilaSpirv.GetBuildOptions(w);
      spirvOptions.spirvOptPath = options.spirvOptPath;
      ApilaSpirv.Optimize(spirvOptions, path);

      optimized, ok := read_entire_file(path);
      assert(ok, "couldnt read %", path);
      spirv = xx optimized;
   }

   if (options.validate) {
      result, output, errors := run_command(
         options.spirvValPath,
         "--relax-block-layout",
         "--allow-localsizeid",
         "--target-env",
         "vulkan1.4",
         "--scalar-block-layout",
         path,
         capture_and_return_output = true,
      );

      if (result.type == .FAILED_TO_LAUNCH) {
         Error(call.call, "couldnt run spirv-val (\"%\"). install it, or set spirvValPath in the BuildOptions to where it is.", options.spirvValPath);
      } else if (result.type != .EXITED || result.exit_code != 0) {
         Error(call.call, "the % shader % is not valid spirv (%):\n%\n%", shader.stage, shader.header.name, path, output, errors);
      }
   }

   return spirv;
}

GenerateBakedSpirv :: (spirvs: [] [] u8) -> string {
   builder: String_Builder;

   append(*builder, "#scope_module\n\n");
   append(*builder, "__GetBakedSpirv :: (file: string, line: s32, column: s32, stage: s32) -> [] u8 {\n");
   for call: calls {
      for call.shaders {
         print_to_builder(*builder, "   if line == % && column == % && stage == % && file == \"%\"  return .{ __bakedSpirv%.count * 4, cast(*u8) __bakedSpirv%.data };\n",
            call.location.line_number, call.location.character_number, cast(s32) it.stage, EscapeString(call.location.fully_pathed_filename), it.spirvIndex, it.spirvIndex);
      }
   }
   append(*builder, "   return .[];\n}\n\n");

   for spirv, spirvIndex: spirvs {
      assert(spirv.count % 4 == 0, "spirv.count: %", spirv.count);
      words: [] u32 = .{ spirv.count / 4, cast(*u32) spirv.data };

      print_to_builder(*builder, "__bakedSpirv%: [%] u32 = .[", spirvIndex, words.count);
      for words {
         if (it_index % 8 == 0) append(*builder, "\n  ");
         print_to_builder(*builder, " 0x%,", formatInt(it, base = 16));
      }
      append(*builder, "\n];\n\n");
   }

   return builder_to_string(*builder);
}

EscapeString :: (s: string) -> string {
   result := replace(s, "\\", "\\\\");
   return replace(result, "\"", "\\\"");
}
