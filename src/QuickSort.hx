

class QuickSort {
  
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    qsort(a, cmp, 0, a.length - 1);
  }
  
  static public function select<T>(a:Array<T>, cmp:T -> T -> Int, kth:Int):T
  {
    return qselect(a, cmp, 0, a.length - 1, kth);
  }
  
  static inline var M = 12;
  static function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Void
  {
    if (lo < hi) {
      
      // use insertion sort for small sequences
      if (hi - lo < M) {
        for (i in (lo + 1)...hi + 1) {
          var j = i;
          while (j > lo) {
            if (cmp(a[j], a[j - 1]) < 0)
              Util.swap(a, j - 1, j);
            else
              break;
            j--;
          }
        }
        return;
      }
      
      var pivotIdx = medianOfThree(a, cmp, lo, hi);
      pivotIdx = partition(a, cmp, lo, hi, pivotIdx);
      
      qsort(a, cmp, lo, pivotIdx);
      qsort(a, cmp, pivotIdx + 1, hi);
    }
  }
  
  static function qselect<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, kth:Int):T
  {
    while (true) {
      if (lo == hi) break;
      var pivotIdx = partition(a, cmp, lo, hi, medianOfThree(a, cmp, lo, hi));
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
  
  static public function medianOfThree<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Int {
    var mid = lo + ((hi - lo) >> 1);
    if (Util.compare(a, cmp, lo, mid) > 0) Util.swap(a, lo, mid);
    if (Util.compare(a, cmp, lo, hi) > 0) Util.swap(a, lo, hi);
    if (Util.compare(a, cmp, mid, hi) > 0) Util.swap(a, mid, hi);
    
    return mid;
  }
}