#import "Bindings_Generator";
#import "Compiler";
#import "Basic";
#import "File";
#import "File_Utilities";

#run {
   assert(OS == .LINUX);
   set_build_options_dc(.{ do_output = false });

   using options: Generate_Bindings_Options;
   array_add(*source_files, "source/include/GLFW/glfw3.h");
   visitor_with_data = GlfwVisitor;
   array_add(*extra_clang_arguments, "-x", "c");
   array_add(*libraries, .{ filename = "libglfw" });
   array_add(*library_search_paths, "source/build/src");
   outputFilename := "bindings.jai";
   ok := generate_bindings(options, outputFilename);
   if (!ok) {
      compiler_set_workspace_status(.FAILED);
   }

   make_directory_if_it_does_not_exist("linux");

   // copy sos
   copy_file("source/build/src/libglfw.so", "linux/libglfw.so");
   copy_file("source/build/src/libglfw.so.3", "linux/libglfw.so.3");
   copy_file("source/build/src/libglfw.so.3.5", "linux/libglfw.so.3.5");
}

GlfwVisitor :: (decl: *Declaration, parent_decl: *Declaration, user_data: *void) -> Declaration_Visit_Result {
   return .RECURSE;
}
