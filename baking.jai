//
// the shaders baked into the executable.
//
// the Create...Pipeline functions of vulkan.jai take spirv. these overloads take the shader procedures instead (written with ApilaSpirv, see its readme for
// what the parameters of each stage are), and BakeShader gives the spirv of a shader for the functions that dont have an overload (CreateRayTracingPipeline).
//
// the metaprogram (ProcessMessage in metaprogram.jai) finds the calls of these and compiles their shaders, so the shader has to be known at the call:
// a procedure (MyShader, SHADERS.MyShader) or a procedure literal, and the $ parameters are constants (jai enforces both).
//
// the spirv of a call is found by the location of the call (loc, dont pass it yourself). so:
//    - a procedure of yours that takes the shader as a $ parameter and calls one of these with it works if it is always given the same shader, since every instance of it
//      has the same call. if it is given different shaders the metaprogram tells you.
//    - the call cant be in an untyped struct literal in an array literal (.[.{ closestHit = BakeShader(...) }]), the metaprogram gets that call untyped.
//      write the type of the struct literal (.[RayHitGroup.{ closestHit = BakeShader(...) }]) or put the result in a variable first. it tells you.
//    - the call cant be in code that is compiled after the shaders are baked (code that waits for a #placeholder of your own metaprogram for example). it tells you.
//

//    CreateComputePipeline(SHADERS.MyShader, 64);
//    CreateComputePipeline((data: *ComputeData) {
//       ...
//    }, 8, 8);
CreateComputePipeline :: ($shader: $T, $LOCAL_SIZE_X: int, $LOCAL_SIZE_Y := 1, $LOCAL_SIZE_Z := 1, debugName := "", loc := #caller_location) -> ComputePipeline {
   return CreateComputePipeline(GetBakedSpirv(loc, .Compute), debugName);
}

// the task shader is optional:
//    CreateMeshletPipeline(SHADERS.MeshShader, SHADERS.FragmentShader, 32, MAX_VERTICES = 64, MAX_PRIMITIVES = 124);
//    CreateMeshletPipeline(SHADERS.MeshShader, SHADERS.FragmentShader, 32, MAX_VERTICES = 64, MAX_PRIMITIVES = 124, task = SHADERS.TaskShader, TASK_LOCAL_SIZE_X = 32);
CreateMeshletPipeline :: ($mesh: $M,
                          $fragment: $F,
                          $MESH_LOCAL_SIZE_X: int,
                          $MAX_VERTICES: int,
                          $MAX_PRIMITIVES: int,
                          $TOPOLOGY := ApilaSpirv.PrimitiveTopology.Triangles,
                          $MESH_LOCAL_SIZE_Y := 1,
                          $MESH_LOCAL_SIZE_Z := 1,
                          $task: $TT = null,
                          $TASK_LOCAL_SIZE_X := 1,
                          $TASK_LOCAL_SIZE_Y := 1,
                          $TASK_LOCAL_SIZE_Z := 1,
                          debugName := "",
                          loc := #caller_location) -> MeshletPipeline {
   taskSpirv     := GetBakedSpirv(loc, .Task, optional = true);
   meshSpirv     := GetBakedSpirv(loc, .Mesh);
   fragmentSpirv := GetBakedSpirv(loc, .Fragment);
   return CreateMeshletPipeline(taskSpirv, meshSpirv, fragmentSpirv, debugName);
}

// the spirv of a shader:
//    rt := CreateRayTracingPipeline(
//       raygens   = .[BakeShader(SHADERS.Rgen, .Rgen)],
//       misses    = .[BakeShader(SHADERS.Rmiss, .Rmiss)],
//       hitGroups = .[RayHitGroup.{ closestHit = BakeShader(SHADERS.Rchit, .Rchit) }],
//       maxRecursionDepth = 1,
//    );
// LOCAL_SIZE is for the compute, task and mesh shaders, MAX_VERTICES, MAX_PRIMITIVES and TOPOLOGY for the mesh shaders. giving them to another stage is an error.
BakeShader :: ($shader: $T,
               $STAGE: ApilaSpirv.ShaderType,
               $LOCAL_SIZE_X := 1,
               $LOCAL_SIZE_Y := 1,
               $LOCAL_SIZE_Z := 1,
               $MAX_VERTICES := 0,
               $MAX_PRIMITIVES := 0,
               $TOPOLOGY := ApilaSpirv.PrimitiveTopology.Triangles,
               loc := #caller_location) -> [] u8 {
   return GetBakedSpirv(loc, STAGE);
}

#scope_module

// for ShaderType and PrimitiveTopology. it is not visible to the program, so the names of ApilaSpirv dont end up in it
ApilaSpirv :: #import "ApilaSpirv";

GetBakedSpirv :: (loc: Source_Code_Location, stage: ApilaSpirv.ShaderType, optional := false) -> [] u8 {
   spirv := __GetBakedSpirv(loc.fully_pathed_filename, xx loc.line_number, xx loc.character_number, xx stage);
   assert(optional || spirv.count > 0, "VulkanJai: there is no baked % shader for the call at %:%:%. if the call is in an untyped struct literal in an array literal, write the type of the struct literal.", stage, loc.fully_pathed_filename, loc.line_number, loc.character_number);
   return spirv;
}

// the metaprogram fills it with the spirv it baked:
//    __GetBakedSpirv :: (file: string, line: s32, column: s32, stage: s32) -> [] u8
// if the compiler says this is never filled, the build script doesnt give the messages of the workspace to VulkanJai.ProcessMessage (VulkanJai(METAPROGRAM = true)).
#placeholder __GetBakedSpirv;
