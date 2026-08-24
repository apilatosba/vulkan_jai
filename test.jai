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

   a :: int;
   b :: #type int;
   assert(a == b);

   print("%\n", a);
   print("%\n", b);
}
