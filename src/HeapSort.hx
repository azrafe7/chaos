// https://en.wikipedia.org/wiki/Heapsort#Pseudocode 

class HeapSort 
{

  static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    heapsort(a, cmp);
  }
  
  static function heapsort<T>(a:Array<T>, cmp:T -> T -> Int):Void {
    var count = a.length;
    heapify(a, cmp, count);
    
    var end = count - 1;
    while (end > 0) {
      Util.swap(a, end, 0);
      end--;
      siftDown(a, cmp, 0, end);
    }
  }
  
  static function heapify<T>(a:Array<T>, cmp:T -> T -> Int, count:Int):Void {
    var start = parentOf(count - 1);
    
    while (start >= 0) {
      siftDown(a, cmp, start, count - 1);
      start--;
    }
  }
  
  static function siftDown<T>(a:Array<T>, cmp:T -> T -> Int, start:Int, end:Int):Void {
    var root = start;
    
    while (leftOf(root) <= end) {
      var child = leftOf(root);
      var swap = root;
      
      if (cmp(a[swap], a[child]) < 0) 
        swap = child;
      if (child + 1 <= end && cmp(a[swap], a[child + 1]) < 0) 
        swap = child + 1;
      
      if (swap == root) {
        return;
      } else {
        Util.swap(a, root, swap);
        root = swap;
      }
    }
  }
  
  static public function sort2<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    heapsort2(a, cmp);
  }
  
  static function heapsort2<T>(a:Array<T>, cmp:T -> T -> Int):Void {
    var count = a.length;
    heapify2(a, cmp, count);
    
    var end = count - 1;
    while (end > 0) {
      Util.swap(a, end, 0);
      end--;
      siftDown(a, cmp, 0, end);
    }
  }
  
  static function heapify2<T>(a:Array<T>, cmp:T -> T -> Int, count:Int):Void {
    var end = 1;
    
    while (end < count) {
      siftUp(a, cmp, 0, end);
      end++;
    }
  }
  
  static function siftUp<T>(a:Array<T>, cmp:T -> T -> Int, start:Int, end:Int):Void {
    var child = end;
    
    while (child > start) {
      var parent = parentOf(child);
      if (cmp(a[parent], a[child]) < 0) {
        Util.swap(a, parent, child);
        child = parent;
      } else {
        return;
      }
    }
  }
  
  inline static function leftOf(i:Int):Int
  {
    return (2 * i) + 1;
  }
  
  inline static function rightOf(i:Int):Int
  {
    return (2 * i) + 2;
  }
  
  inline static function parentOf(i:Int):Int
  {
    return (i - 1) >> 1;
  }
}