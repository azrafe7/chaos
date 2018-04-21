

class QuickSort {
  
  static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    qsort(a, cmp, 0, a.length - 1);
  }
  
  static public function select<T>(a:Array<T>, cmp:T -> T -> Int, kth:Int):T
  {
    return qselect(a, cmp, 0, a.length - 1, kth);
  }
  
  static inline var M = 32;
  static function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Void
  {
    while (lo < hi) {
      
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
      
      var p = partition(a, cmp, lo, hi, medianOfThree(a, cmp, lo, hi));
      
      // sort shorter sequence first
      if (p - lo < hi - p) {
        qsort(a, cmp, lo, p);
        lo = p + 1;
      } else {
        qsort(a, cmp, p + 1, hi);
        hi = p;
      }
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
  
  static function medianOfThree<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Int {
    var mid = lo + ((hi - lo) >> 1);
    var left = a[lo], middle = a[mid], right = a[hi];
    if (cmp(left, middle) > 0) Util.swap(a, lo, mid);
    if (cmp(left, right) > 0) Util.swap(a, lo, hi);
    if (cmp(middle, right) > 0) Util.swap(a, mid, hi);
    return mid;
  }
}