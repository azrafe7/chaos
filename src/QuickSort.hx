

class QuickSort {
  
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    qsort(a, cmp, 0, a.length - 1);
  }
  
  static public function select<T>(a:Array<T>, cmp:T -> T -> Int, kth:Int):T
  {
    return qselect(a, cmp, 0, a.length - 1, kth);
  }
  
  static public var stackDepth = 0;
  static public var calls = 0;
  static inline var M = 0;
  static public function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    stackDepth = level > stackDepth ? level : stackDepth;
    calls++;
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
      pivotIdx = partition2(a, cmp, lo, hi, pivotIdx);
      
      qsort(a, cmp, lo, pivotIdx, level+1);
      qsort(a, cmp, pivotIdx + 1, hi, level+1);
    }
  }
  
  static public function qsort3way<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    stackDepth = level > stackDepth ? level : stackDepth;
    calls++;
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
      var pivotsIndices = [pivotIdx, 0];
      partition3(a, cmp, lo, hi, pivotsIndices);
      
      qsort3way(a, cmp, lo, pivotsIndices[0]);
      qsort3way(a, cmp, pivotsIndices[1], hi);
    }
  }
  
  static function qselect<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, kth:Int):T
  {
    while (true) {
      if (lo == hi) break;
      var pivotIdx = partition2(a, cmp, lo, hi, medianOfThree(a, cmp, lo, hi));
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
  
  static function partition2<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotIdx:Int):Int
  {
    var pivotValue = a[pivotIdx];
    var i = lo;
    var j = hi;
    
    while (true) {
      while (cmp(a[++i], pivotValue) < 0) {};
      while (cmp(pivotValue, a[--j]) < 0) {
        if (j == lo) break;
      }
      if (i >= j) break;
      Util.swap(a, i, j);
    }
    Util.swap(a, i, hi);
    return i - 1;
  }
  
  static function partition3<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotsIndices:Array<Int>):Void
  {
    var pivotValue = a[pivotsIndices[0]];
    var i = lo;
    var j = hi;
    var p = lo;
    var q = pivotsIndices[0];
    
    while (true) {
      while (cmp(a[++i], pivotValue) < 0) {};
      while (cmp(pivotValue, a[--j]) < 0) {
        if (j == lo) break;
      }
      if (i >= j) break;
      Util.swap(a, i, j);
      
      if (cmp(a[i], pivotValue) == 0) {
        p++;
        Util.swap(a, p, i);
      }
      if (cmp(pivotValue, a[j]) == 0) {
        q--;
        Util.swap(a, q, j);
      }
    }
    Util.swap(a, i, hi);
    
    j = i - 1;
    i = i + 1;
    var k = lo;
    while (k < p) {
      Util.swap(a, k, j);
      k++;
      j--;
    }
    k = hi - 1;
    while (k > q) {
      Util.swap(a, i, k);
      k--;
      i++;
    }
    
    pivotsIndices[0] = i;
    pivotsIndices[1] = j;
  }
  
  static public function medianOfThree<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Int {
    var mid = lo + ((hi - lo) >> 1);
    if (Util.compare(a, cmp, lo, mid) > 0) Util.swap(a, lo, mid);
    if (Util.compare(a, cmp, lo, hi) > 0) Util.swap(a, lo, hi);
    if (Util.compare(a, cmp, mid, hi) > 0) Util.swap(a, mid, hi);
    
    return mid;
  }
}