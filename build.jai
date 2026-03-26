#import "Compiler";
#import "File";
#import "File_Utilities";
#import "Basic";

// config
BUILD_FOLDER      :: "build";
OUTPUT_EXE_NAME   :: "main";

#run {
   assert(OS == .LINUX, "only linux supported, cause i dont have dlls for windows");

   set_build_options_dc(.{ do_output = false });
   set_working_directory(#filepath);

   rootOptions := get_build_options();

   w := compiler_create_workspace("Target Program (main)");
   make_directory_if_it_does_not_exist(BUILD_FOLDER);

   options := get_build_options(w);
   copy_commonly_propagated_fields(rootOptions, *options);
   options.output_executable_name = OUTPUT_EXE_NAME;
   options.output_path = BUILD_FOLDER;
   set_build_options(options, w);

   // compile
   {
      compiler_begin_intercept(w);
      defer compiler_end_intercept(w);

      add_build_file("main.jai", w);

      while true {
         message := compiler_wait_for_message();
         if message.kind == {
            case .COMPLETE; {
               mc := cast(*Message_Complete) message;
               if mc.error_code != .NONE {
                  compiler_set_workspace_status(.FAILED, w);
                  exit(69);
               }
               break;
            }
         }
      }
   }

   // copy sos
   copy_file("modules/Vulkan_Memory_Allocator/linux/libvma.so", tprint("%/libvma.so", BUILD_FOLDER));
}
