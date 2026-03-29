#import "Compiler";
#import "POSIX";
#import "Basic";
#import "Math";
#import "Thread";
#import "Hash_Table";
#import "ApilaDispatch";


MyStruct :: struct {
   x: int = 69;
   y: int = 420;
}

#run {
   set_build_options_dc(.{ do_output = false });
   InitializeThreads();

   ms: MyStruct = .{
      y = 12,
   };
   print("ms: %\n", ms);
}
