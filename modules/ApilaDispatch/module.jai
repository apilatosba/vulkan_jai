//
// the *void start returned by DispatchFunction or GetCompletedWorks is just a handle
// DO NOT DEREFENCE that pointer. only do equality checks to decide if your work is done
//       - apila, 25/03/26
//

//
// use like this:
// main :: () {
//    InitializeThreads();
//    handle := DispatchFunction(MyFunction, p1, p2, ...); // where p1, p2 ... are parameters to MyFunction
//    completedWorks := GetCompletedWorks();
//    ...
// }
//
// if you provide one or two arguments less to DispatchFunction and your function takes arguments of type
// *Thread_Group and/or *Thread then those parameters will be filled by this library. if you want to use them you can
//

//
// I want to add these two functions:
//    IsWorkDone(work: *void) -> bool;
//    WaitForWork(work: *void, timeout: int = -1);
// but this functionality is not exposed in Thread_Group so i cant implement it. i need to modify Thread_Group first
//

//
// Thread.index starts from 1. so if you want to index into an array using the Thread.index
// you can use the 0th index for your main thread.
// for that purpose you can also use context.thread_index
//
// actually idk how stable Thread.index is. maybe it doesnt always start from 1.
// maybe it is safer to use Table rather than arrays for TLS
//

#import "Thread";
#import "Basic";
#import "System";

// globals
threads:       Thread_Group;
threadCount:   s32 = -69;  // Thread_Group.init expects an s32 not an int.
                           // by default -69 so if you accidentally use it before you initialize
                           // you will notice early

// any work you define should has this as its first field
WorkHeader :: struct {
   // parameter work is to be casted to work type defined by the user
   execute:          #type (threadGroup: *Thread_Group, thread: *Thread, work: *WorkHeader);
   isManuallyAdded:  bool;
}

InitializeThreads :: () {
   WorkDispatcherProc :: (group: *Thread_Group, thread: *Thread, work: *void) -> Thread_Continue_Status {
      header: *WorkHeader = cast(*WorkHeader) work;
      header.execute(group, thread, header);
      return .CONTINUE;
   }

   numCpus := get_number_of_processors();
   threadCount = max(numCpus - 1, 2);
   init(*threads, threadCount, WorkDispatcherProc);

   threads.name = "Apila Engine Thread Group";
   threads.logging = false;
   start(*threads);
}

// you can call this too if you want to define the work struct yourself
// maybe you want to do it because you want to do something with the pointer returned by the
// GetCompletedWorks.
// if you are calling this function manually then you need to make sure that you set WorkHeader fields properly that is:
//    isManuallyAdded must be true
//    execute function in must be properly set
// i know i can make two versions of these the internally used one wouldnt set isManuallyAdded to true
// and exported one would set it automatically but i dont think i will ever use this function. so, bleah, who cares.
AddWork :: (work: *$T) #modify {
   // reject if the first field of T is not of type WorkHeader
   ti := cast(*Type_Info) T;
   if (ti.type != .STRUCT) return false;

   tis := cast(*Type_Info_Struct) T;
   if (tis.members.count < 1) return false;

   firstMember := tis.members[0];
   assert(firstMember.offset_in_bytes == 0);
   if (firstMember.type.type != .STRUCT) return false;
   firstMemberTis := cast(*Type_Info_Struct) firstMember.type;
   if (firstMemberTis.name == WorkHeader.(*Type_Info_Struct).name) return true;

   return false;
} {
   header := cast(*WorkHeader) work;
   add_work(*threads, work);
}

GetCompletedWorks :: () -> [] *void {
   completedWorks := get_completed_work(*threads);

   for completedWorks {
      header := cast(*WorkHeader) it;
      if (!header.isManuallyAdded) {
         free(it);
      }
   }

   return completedWorks;
}

// generate DispatchFunction overloads
#insert #run () -> string {
   //
   // writing and reading from a file didnt help the compile time being slow
   //

   // #import "File";
   // #import "File_Utilities";

   // ADDED_STRINGS_FILE_NAME :: "DispatchFunctionAddedStrings.jai";
   // addedStringsFilePath := sprint("%%", #filepath, ADDED_STRINGS_FILE_NAME);

   // if (file_exists(addedStringsFilePath)) {
   //    contents, success := read_entire_file(addedStringsFilePath);
   //    assert(success);
   //    return contents;
   // }

   builder: String_Builder;
   for 0..9 {
      s: string;

      s = GenerateDispatchFunctionWithoutThreadGroupAndThread(it);
      print_to_builder(*builder, s);

      s = GenerateDispatchFunctionWithThreadGroup(it);
      print_to_builder(*builder, s);

      s = GenerateDispatchFunctionWithThread(it);
      print_to_builder(*builder, s);

      s = GenerateDispatchFunctionWithThreadGroupAndThread(it);
      print_to_builder(*builder, s);

      s = GenerateDispatchFunctionNoParameterMissing(it);
      print_to_builder(*builder, s);

      if (it >= 1) {
         s = GenerateDispatchFunctionOneParameterMissing(it);
         print_to_builder(*builder, s);
      }

      if (it >= 2) {
         s = GenerateDispatchFunctionTwoParametersMissing(it);
         print_to_builder(*builder, s);
      }
   }

   generated := builder_to_string(*builder);
   // write_entire_file(addedStringsFilePath, generated);
   return generated;
}();



#scope_module

GenerateDispatchFunctionNoParameterMissing :: (parameterCount: int) -> string {
   b: String_Builder;

   print_to_builder(*b, "DispatchFunction :: (function: #type (");

   if (parameterCount > 0) {
      for 0..parameterCount - 2 {
         print_to_builder(*b, "_: $T%, ", it);
      }
      print_to_builder(*b, "_: $T%", parameterCount - 1);
   }

   print_to_builder(*b, ") -> ()");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", p%1: T%1", it);
   }

   print_to_builder(*b, ") -> *void {\n");

   print_to_builder(*b, "   return DispatchFunctionWithoutThreadGroupAndThread(function");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", p%", it);
   }
   print_to_builder(*b, ");\n");

   print_to_builder(*b, "}\n");

   return builder_to_string(*b);
}


GenerateDispatchFunctionOneParameterMissing :: (parameterCount: int) -> string {
   assert(parameterCount >= 1, "if there is no parameter, it cant be missing");

   b: String_Builder;

   print_to_builder(*b, "DispatchFunction :: (function: #type (");

   if (parameterCount > 0) {
      for 0..parameterCount - 2 {
         print_to_builder(*b, "_: $T%, ", it);
      }
      print_to_builder(*b, "_: $T%", parameterCount - 1);
   }

   print_to_builder(*b, ") -> ()");

   // starts from 1 instead of 0 (one parameter missing as requested)
   for 1..parameterCount - 1 {
      print_to_builder(*b, ", p%1: T%1", it);
   }

   print_to_builder(*b, ") -> *void {\n");

   print_to_builder(*b, "   USE_THREAD_GROUP :: T0 == *Thread_Group;\n");
   print_to_builder(*b, "   USE_THREAD :: T0 == *Thread;\n");

   print_to_builder(*b, "   #assert USE_THREAD_GROUP == true || USE_THREAD == true \"one parameter was not provided and your function doesnt take neither *Thread nor *Thread_Group. Maybe you forgot to provide an argument?\";\n");


   print_to_builder(*b, "   #if USE_THREAD_GROUP {\n");
   print_to_builder(*b, "      return DispatchFunctionWithThreadGroup(function");

   for 1..parameterCount - 1 {
      print_to_builder(*b, ", p%", it);
   }
   print_to_builder(*b, ");\n");

   print_to_builder(*b, "   } else #if USE_THREAD {\n");
   print_to_builder(*b, "      return DispatchFunctionWithThread(function");

   for 1..parameterCount - 1 {
      print_to_builder(*b, ", p%", it);
   }
   print_to_builder(*b, ");\n");

   print_to_builder(*b, "   }\n");
   print_to_builder(*b, "}\n");

   return builder_to_string(*b);
}

GenerateDispatchFunctionTwoParametersMissing :: (parameterCount: int) -> string {
   assert(parameterCount >= 2, "if parameter count is less than two, there cant be two parameters missing.");

   b: String_Builder;

   print_to_builder(*b, "DispatchFunction :: (function: #type (");

   if (parameterCount > 0) {
      for 0..parameterCount - 2 {
         print_to_builder(*b, "_: $T%, ", it);
      }
      print_to_builder(*b, "_: $T%", parameterCount - 1);
   }

   print_to_builder(*b, ") -> ()");

   // starts from 2 instead of 0 (two parameters missing as requested)
   for 2..parameterCount - 1 {
      print_to_builder(*b, ", p%1: T%1", it);
   }

   print_to_builder(*b, ") -> *void {\n");

   print_to_builder(*b, "   USE_THREAD_GROUP :: T0 == *Thread_Group;\n");
   print_to_builder(*b, "   USE_THREAD :: T0 == *Thread;\n");

   print_to_builder(*b, "   #assert USE_THREAD_GROUP == true && USE_THREAD == true \"two parameters were not provided and your function doesnt take both of *Thread and *Thread_Group. Maybe you forgot to provide one or two arguments?\";\n");


   print_to_builder(*b, "   return DispatchFunctionWithThreadGroup(function");

   for 2..parameterCount - 1 {
      print_to_builder(*b, ", p%", it);
   }
   print_to_builder(*b, ");\n");

   print_to_builder(*b, "}\n");

   return builder_to_string(*b);
}

GenerateDispatchFunctionWithThread :: (parameterCount: int) -> string {
   b: String_Builder;
   print_to_builder(*b, "DispatchFunctionWithThread :: (function: #type (thread: *Thread");

   for 0.. parameterCount - 1 {
      print_to_builder(*b, ", _: $T%", it);
   }

   print_to_builder(*b, ") -> ()");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", p%1: T%1", it);
   }

   print_to_builder(*b, ") -> *void {\n");

   print_to_builder(*b,"   Work :: struct {\n");
   print_to_builder(*b,"      header: WorkHeader;\n");
   print_to_builder(*b,"      function: #type (*Thread");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", T%", it);
   }

   print_to_builder(*b, ") -> ();\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "      f%1: T%1;\n", it);
   }

   print_to_builder(*b, "\n");
   print_to_builder(*b, "      WorkExecuteFunction :: (group: *Thread_Group, thread: *Thread, header: *WorkHeader) {\n");
   print_to_builder(*b, "         work := cast(*Work) header;\n");
   print_to_builder(*b, "         work.function(thread");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", work.f%", it);
   }

   print_to_builder(*b, ");\n");
   print_to_builder(*b, "      };\n");
   print_to_builder(*b, "      header.execute = WorkExecuteFunction;\n");
   print_to_builder(*b, "   }\n\n"); // Work struct done


   print_to_builder(*b, "   work := New(Work);\n");
   print_to_builder(*b, "   work.function = function;\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "   work.f%1 = p%1;\n", it);
   }

   print_to_builder(*b, "   AddWork(work);\n");
   print_to_builder(*b, "   return work;\n");
   print_to_builder(*b, "}\n");

   return builder_to_string(*b);
}

GenerateDispatchFunctionWithThreadGroup :: (parameterCount: int) -> string {
   b: String_Builder;
   print_to_builder(*b, "DispatchFunctionWithThreadGroup :: (function: #type (group: *Thread_Group");

   for 0.. parameterCount - 1 {
      print_to_builder(*b, ", _: $T%", it);
   }

   print_to_builder(*b, ") -> ()");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", p%1: T%1", it);
   }

   print_to_builder(*b, ") -> *void {\n");

   print_to_builder(*b,"   Work :: struct {\n");
   print_to_builder(*b,"      header: WorkHeader;\n");
   print_to_builder(*b,"      function: #type (*Thread_Group");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", T%", it);
   }

   print_to_builder(*b, ") -> ();\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "      f%1: T%1;\n", it);
   }

   print_to_builder(*b, "\n");
   print_to_builder(*b, "      WorkExecuteFunction :: (group: *Thread_Group, thread: *Thread, header: *WorkHeader) {\n");
   print_to_builder(*b, "         work := cast(*Work) header;\n");
   print_to_builder(*b, "         work.function(group");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", work.f%", it);
   }

   print_to_builder(*b, ");\n");
   print_to_builder(*b, "      };\n");
   print_to_builder(*b, "      header.execute = WorkExecuteFunction;\n");
   print_to_builder(*b, "   }\n\n"); // Work struct done


   print_to_builder(*b, "   work := New(Work);\n");
   print_to_builder(*b, "   work.function = function;\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "   work.f%1 = p%1;\n", it);
   }

   print_to_builder(*b, "   AddWork(work);\n");
   print_to_builder(*b, "   return work;\n");
   print_to_builder(*b, "}\n");

   return builder_to_string(*b);
}

GenerateDispatchFunctionWithThreadGroupAndThread :: (parameterCount: int) -> string {
   b: String_Builder;
   print_to_builder(*b, "DispatchFunctionWithThreadGroupAndThread :: (function: #type (group: *Thread_Group, thread: *Thread");

   for 0.. parameterCount - 1 {
      print_to_builder(*b, ", _: $T%", it);
   }

   print_to_builder(*b, ") -> ()");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", p%1: T%1", it);
   }

   print_to_builder(*b, ") -> *void {\n");

   print_to_builder(*b,"   Work :: struct {\n");
   print_to_builder(*b,"      header: WorkHeader;\n");
   print_to_builder(*b,"      function: #type (*Thread_Group, *Thread");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", T%", it);
   }

   print_to_builder(*b, ") -> ();\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "      f%1: T%1;\n", it);
   }

   print_to_builder(*b, "\n");
   print_to_builder(*b, "      WorkExecuteFunction :: (group: *Thread_Group, thread: *Thread, header: *WorkHeader) {\n");
   print_to_builder(*b, "         work := cast(*Work) header;\n");
   print_to_builder(*b, "         work.function(group, thread");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", work.f%", it);
   }

   print_to_builder(*b, ");\n");
   print_to_builder(*b, "      };\n");
   print_to_builder(*b, "      header.execute = WorkExecuteFunction;\n");
   print_to_builder(*b, "   }\n\n"); // Work struct done


   print_to_builder(*b, "   work := New(Work);\n");
   print_to_builder(*b, "   work.function = function;\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "   work.f%1 = p%1;\n", it);
   }

   print_to_builder(*b, "   AddWork(work);\n");
   print_to_builder(*b, "   return work;\n");
   print_to_builder(*b, "}\n");

   return builder_to_string(*b);
}

GenerateDispatchFunctionWithoutThreadGroupAndThread :: (parameterCount: int) -> string {
   b: String_Builder;
   print_to_builder(*b, "DispatchFunctionWithoutThreadGroupAndThread :: (function: #type (");

   if (parameterCount > 0) {
      for 0..parameterCount - 2 {
         print_to_builder(*b, "_: $T%, ", it);
      }
      print_to_builder(*b, "_: $T%", parameterCount - 1);
   }

   print_to_builder(*b, ") -> ()");

   for 0..parameterCount - 1 {
      print_to_builder(*b, ", p%1: T%1", it);
   }

   print_to_builder(*b, ") -> *void {\n");

   print_to_builder(*b,"   Work :: struct {\n");
   print_to_builder(*b,"      header: WorkHeader;\n");
   print_to_builder(*b,"      function: #type (");

   if (parameterCount > 0) {
      for 0..parameterCount - 2 {
         print_to_builder(*b, "T%, ", it);
      }
      print_to_builder(*b, "T%", parameterCount - 1);
   }

   print_to_builder(*b, ") -> ();\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "      f%1: T%1;\n", it);
   }

   print_to_builder(*b, "\n");
   print_to_builder(*b, "      WorkExecuteFunction :: (group: *Thread_Group, thread: *Thread, header: *WorkHeader) {\n");
   print_to_builder(*b, "         work := cast(*Work) header;\n");
   print_to_builder(*b, "         work.function(");

   if (parameterCount > 0) {
      for 0..parameterCount - 2 {
         print_to_builder(*b, "work.f%, ", it);
      }
      print_to_builder(*b, "work.f%", parameterCount - 1);
   }

   print_to_builder(*b, ");\n");
   print_to_builder(*b, "      };\n");
   print_to_builder(*b, "      header.execute = WorkExecuteFunction;\n");
   print_to_builder(*b, "   }\n\n"); // Work struct done

   print_to_builder(*b, "   work := New(Work);\n");
   print_to_builder(*b, "   work.function = function;\n");

   for 0..parameterCount - 1 {
      print_to_builder(*b, "   work.f%1 = p%1;\n", it);
   }

   print_to_builder(*b, "   AddWork(work);\n");
   print_to_builder(*b, "   return work;\n");
   print_to_builder(*b, "}\n");

   return builder_to_string(*b);
}
