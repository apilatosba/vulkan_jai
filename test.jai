#import "Compiler";
#import "POSIX";
#import "Basic";
#import "Math";
#import "Thread";
#import "Hash_Table";
#import "ApilaDispatch";

Maybe :: struct (T: Type) {
   #as data:      T;
   isValid:       bool;
}

#run {
   set_build_options_dc(.{ do_output = false });
   InitializeThreads();
   x := 69;
   F(x);
}

F :: (m: Maybe(int)) {
   print("m: %\n", m);
}
