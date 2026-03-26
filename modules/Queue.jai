#import "Basic";

Queue :: struct (T: Type) {
	array:    [] T;
	head:     int;
	tail:     int;
	count:    int;
	version:  int;
}

Enqueue :: (using q: *Queue, item: q.T) {
   if (count == array.count) {
      Grow(q, count + 1);
   }

   array[tail] = item;
   MoveNext(q, *tail);
   count += 1;
   version += 1;
}

Dequeue :: (using q: *Queue) -> success: bool, item: q.T {
   if (count == 0) {
      return false, xx void;
   }

   removed := array[head];
   array[head] = xx void;
   MoveNext(q, *head);
   count -= 1;
   version += 1;
   return true, removed;
}

Clear :: (using q: *Queue) {
   count = 0;
   head = 0;
   tail = 0;
   version += 1;
}

Peek :: (using q: *Queue) -> bool, q.T {
   if (count == 0) {
      return false, xx void;
   }

   return true, array[head];
}

#scope_module
MINIMUM_GROW   :: 4;
GROW_FACTOR    :: 2;

SetCapacity :: (using q: *Queue, capacity: int) {
   newArray := NewArray(capacity, q.T);
   if (count > 0) {
      if (head < tail) {
         memcpy(newArray.data, array.data + head, count * size_of(q.T));
      } else {
         memcpy(newArray.data, array.data + head, (array.count - head) * size_of(q.T));
         memcpy(newArray.data + array.count - head, array.data, tail * size_of(q.T));
      }
   }

   free(array.data);
   array = newArray;
   head = 0;
   tail = ifx count == capacity then 0 else count;
   version += 1;
}

Grow :: (using q: *Queue, capacity: int) {
   assert(array.count < capacity);

   newCapacity := array.count * GROW_FACTOR;
   if (newCapacity < array.count + MINIMUM_GROW) {
      newCapacity = array.count + MINIMUM_GROW;
   }

   if (newCapacity < capacity) {
      newCapacity = capacity;
   }

   SetCapacity(q, newCapacity);
}

MoveNext :: (using q: *Queue, index: *int) {
   tmp := index.* + 1;
   if (tmp == array.count) {
      tmp = 0;
   }
   index.* = tmp;
}
