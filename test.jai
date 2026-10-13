#import "Compiler";
#import "POSIX";
#import "Basic";
#import "Math";
#import "Thread";
#import "Hash_Table";
#import "ApilaDispatch";

#run {
   set_build_options_dc(.{ do_output = false });

   a: u32 = U32_MAX;
   b: u64 = 10;

   c := a + b;

   print("type: %, value: %\n", type_of(c), c);
}
