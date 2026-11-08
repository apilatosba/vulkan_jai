//
// the metaprogram side of VulkanJai (METAPROGRAM = true). the baking itself is in baker.jai: it finds the calls of the Create...Pipeline overloads
// that take shaders and of BakeShader (baking.jai), compiles their shaders with ApilaSpirv and fills the #placeholder __GetBakedSpirv with the spirv.
//
// a metaprogram runs in the bytecode interpreter, which is about 20 times slower than native code, and compiling the shaders was most of the
// build time. so the baker is a native library: the first message builds it (build_baker.jai, in a jai of its own) and loads it, and every
// message is given to it. what only compile time code can do (compiler_report, add_build_string, get_build_options) it calls back in here for.
//

#import "Basic";
#import "Compiler";
#import "Hash_Table";
#import "Process";
#import "File";
POSIX :: #import "POSIX";

#load "build_options.jai";

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
   if (!baker.loaded)  LoadBaker(message.workspace);
   baker.processMessage(message);
}

#scope_module

#assert OS == .LINUX "the baker is loaded with dlopen, only linux is done";

BAKER_NAME :: "vulkanjai_baker";

workspaceToBuildOptions: Table(Workspace, BuildOptions);

baker: struct {
   loaded:           bool;
   processMessage:   (message: *Message) #c_call;
   callerContext:    #Context;   // the context the callbacks run in
};

// builds the baker into the intermediate folder of the workspace and loads it
LoadBaker :: (w: Workspace) {
   folder := get_build_options(w).intermediate_path;
   if (!folder)  folder = ".build";
   make_directory_if_it_does_not_exist(folder, recursive = true);

   // the jai that is running this, and the import paths this metaprogram found VulkanJai (and ApilaSpirv) with
   arguments: [..] string;
   array_add(*arguments, tprint("%/bin/jai-linux", compiler_get_base_path()), tprint("%build_baker.jai", #filepath), "-quiet", "-", folder, BAKER_NAME);
   for get_build_options().import_path  array_add(*arguments, it);

   result, output, errors := run_command(..arguments, capture_and_return_output = true);
   if (result.type != .EXITED || result.exit_code != 0) {
      compiler_report(tprint("VulkanJai: couldnt build the baker (%):\n%\n%", arguments, output, errors));
      exit(1);
   }

   path := tprint("%/%.so", folder, BAKER_NAME);
   library := POSIX.dlopen(temp_c_string(path), POSIX.RTLD_NOW);
   if (library == null) {
      compiler_report(tprint("VulkanJai: couldnt load the baker %: %", path, to_string(POSIX.dlerror())));
      exit(1);
   }

   init := cast(#type (report: ReportProc, addBuildString: AddBuildStringProc, getBuildOptions: GetBuildOptionsProc) #c_call) POSIX.dlsym(library, "VulkanJaiBakerInit");
   baker.processMessage = cast(type_of(baker.processMessage)) POSIX.dlsym(library, "VulkanJaiBakerProcessMessage");
   assert(init != null && baker.processMessage != null, "VulkanJai: the baker % doesnt export VulkanJaiBakerInit and VulkanJaiBakerProcessMessage", path);

   baker.callerContext = context;
   init(Report, AddBuildString, GetBakerBuildOptions);   // the callbacks have to be arguments (see ReportProc in baker.jai)
   baker.loaded = true;
}

// the callbacks of the baker, the same types as in baker.jai

ReportProc          :: #type (message: *string, location: *Source_Code_Location) #c_call;
AddBuildStringProc  :: #type (code: *string, w: Workspace, scope: *Message) #c_call;
GetBuildOptionsProc :: #type (w: Workspace, options: *BuildOptions, intermediatePath: *string) #c_call;

Report :: (message: *string, location: *Source_Code_Location) #c_call {
   push_context baker.callerContext {
      compiler_report(message.*, location.*);
   }
}

AddBuildString :: (code: *string, w: Workspace, scope: *Message) #c_call {
   push_context baker.callerContext {
      add_build_string(code.*, w, scope);
   }
}

GetBakerBuildOptions :: (w: Workspace, options: *BuildOptions, intermediatePath: *string) #c_call {
   push_context baker.callerContext {
      options.* = GetBuildOptions(w);
      intermediatePath.* = get_build_options(w).intermediate_path;
   }
}
