#import "Bindings_Generator";
#import "Compiler";
#import "Basic";
#import "File";
#import "File_Utilities";

#run {
   assert(OS == .LINUX);

   set_build_options_dc(.{ do_output = false });

   // copy sos
   copy_file("source/build/source/libSPIRV-Tools-shared.so", "linux/libSPIRV-Tools-shared.so");

   using options: Generate_Bindings_Options;
   array_add(*source_files, "source/include/spirv-tools/libspirv.h");
   visitor_with_data = SpirvToolsVisitor;
   array_add(*extra_clang_arguments, "-x", "c");
   array_add(*libraries, .{ filename = "libSPIRV-Tools-shared" });
   array_add(*library_search_paths, "linux");
   outputFilename := "bindings.jai";
   ok := generate_bindings(options, outputFilename);
   if (!ok) {
      compiler_set_workspace_status(.FAILED);
   }

   make_directory_if_it_does_not_exist("linux");

}

SpirvToolsVisitor :: (decl: *Declaration, parent_decl: *Declaration, user_data: *void) -> Declaration_Visit_Result {
   return .RECURSE;
}
