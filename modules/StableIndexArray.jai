#import "Basic";

// TODO(apila, 23/03/26) do generation thingy only in debug mode
//    StableIndexArrayHandle would be just an int.
//    StableIndexArrayElement wouldnt be needed

StableIndexArray :: struct (T: Type) {
   array:         [..] StableIndexArrayElement(T);
   freedIndices:  [..] int;
}

StableIndexArrayElement :: struct (T: Type) {
   using #as element:   T;
   __generation:        int; // i put double underscore so i hope it is less likely to have a name collsion with something in element
}

StableIndexArrayHandle :: struct {
   index:         int;
   generation:    int;
}

Add :: (using sia: *StableIndexArray, element: sia.T) -> StableIndexArrayHandle {
   if (freedIndices.count != 0) {
      index := pop(*freedIndices);
      array[index].element = element;
      return .{ index, array[index].__generation };
   }

   generation := 0;
   array_add(*array, .{ element, generation });
   return .{ array.count - 1, generation };
}

Remove :: (using sia: *StableIndexArray, handle: StableIndexArrayHandle) {
   assert(array[handle].__generation == handle.generation, "removing the same thing twice! index: %, old generation: %, new generation: %", handle.index, handle.generation, array[handle.index].__generation);

   array[handle].__generation += 1;
   array_add(*freedIndices, handle.index);
}

Get :: (using sia: *StableIndexArray, handle: StableIndexArrayHandle) -> *sia.T {
   assert(array[handle.index].__generation == handle.generation, "use after remove! index: %, old generation: %, new generation: %", handle.index, handle.generation, array[handle.index].__generation);

   return *array[handle.index].element;
}

// i cant use this. jai says handle has to be an int
operator *[] :: (using sia: *StableIndexArray, handle: StableIndexArrayHandle) -> *sia.T {
   return Get(sia, handle);
}
