

class QuickSort {
  
  static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    qsort(a, cmp, 0, a.length - 1);
  }
  
  static public function select<T>(a:Array<T>, cmp:T -> T -> Int, kth:Int):T
  {
    return qselect(a, cmp, 0, a.length - 1, kth);
  }
  
  static function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Void
  {
    if (lo < hi) {
      var p = partition(a, cmp, lo, hi, lo + Std.random(hi - lo + 1));
      qsort(a, cmp, lo, p);
      qsort(a, cmp, p + 1, hi);
    }
  }
  
  static function qselect<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, kth:Int):T
  {
    while (true) {
      if (lo == hi) break;
      var pivotIdx = lo + Std.random(hi - lo + 1);
      pivotIdx = partition(a, cmp, lo, hi, pivotIdx);
      if (kth == pivotIdx) {
        return a[kth];
      } else if (kth < pivotIdx) {
        hi = pivotIdx - 1;
      } else {
        lo = pivotIdx + 1;
      }
    }
    return a[lo];
  }
  
  static function partition<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotIdx:Int):Int
  {
    var pivot = a[pivotIdx];
    Util.swap(a, pivotIdx, hi); // move pivot to end
    var storeIdx = lo;
    for (i in lo...hi) {
      if (cmp(a[i], pivot) < 0) {
        Util.swap(a, storeIdx, i);
        storeIdx++;
      }
    }
    Util.swap(a, hi, storeIdx); // move pivot to its final place
    return storeIdx;
  }  
}