#import,dir "..";
#import "Basic";
#import "Thread";

// demo that you can use context.thread_index.
// it is not demoed here but you can use context.thread_index to index into TLS (thread local storages)
// even if your function doesnt take an explicit argument of type *Thread
main :: () {
   InitializeThreads();

   workCount := 100;

   for 0..workCount - 1 {
      DispatchFunction(PrintThreadIndex);
   }

   while workCount > 0 {
      completedWorks := GetCompletedWorks();
      workCount -= completedWorks.count;
   }

   print("\n\nDone!\n");
}

PrintThreadIndex :: (thread: *Thread) {
   assert(thread.index == context.thread_index);

   messageFormat := #string HERE
--------------------------------------
thread.index:          %
context.thread_index:  %
HERE
;
   print(messageFormat, thread.index, context.thread_index);
}
