//
// builds the baker (baker.jai) as a native library. the metaprogram (metaprogram.jai) runs this in a jai of its own:
//
//    jai build_baker.jai - <output folder> <name> <import path>...
//
// the x64 backend, not optimized: it compiles in a fraction of a second and the code is still about 20 times faster than the bytecode
// interpreter. LLVM would take longer to compile it than the interpreter takes to run it.
//

#import "Basic";
#import "Compiler";

#run {
   set_build_options_dc(.{ do_output = false });

   args := get_build_options().compile_time_command_line;
   assert(args.count >= 2, "jai build_baker.jai - <output folder> <name> <import path>...");

   w := compiler_create_workspace("VulkanJai baker");
   options := get_build_options(w);
   options.output_type             = .DYNAMIC_LIBRARY;
   options.output_path             = args[0];
   options.intermediate_path       = args[0];
   options.output_executable_name  = args[1];
   options.backend                 = .X64;
   options.text_output_flags       = 0;
   options.import_path             = array_view(args, 2);
   set_build_options(options, w);

   add_build_file(tprint("%baker.jai", #filepath), w);
}
