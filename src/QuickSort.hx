

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
  static public inline var M = 10;
  static public function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    stackDepth = level > stackDepth ? level : stackDepth;
    calls++;
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
      
      var pivotIdx = medianOfThree(a, cmp, lo, hi);
      //trace(a);
      //trace(Util.highlightIndices(a, [pivotIdx], null));
      pivotIdx = partitionMed3(a, cmp, lo, hi, pivotIdx);
      //trace("\n");
      
      if (pivotIdx - lo < hi - pivotIdx) {
        qsort(a, cmp, lo, pivotIdx - 1, level + 1);
        lo = pivotIdx + 1;
      } else {
        qsort(a, cmp, pivotIdx + 1, hi, level + 1);
        hi = pivotIdx - 1;
      }
    }
  }
  
  static public function qsortMed3<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    stackDepth = level > stackDepth ? level : stackDepth;
    calls++;
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
      
      var pivotIdx = medianOfThree(a, cmp, lo, hi);
      //trace(a);
      //trace(Util.highlightIndices(a, [pivotIdx], null));
      pivotIdx = partitionMed3(a, cmp, lo, hi, pivotIdx);
      //trace("\n");
      
      if (pivotIdx - lo < hi - pivotIdx) {
        qsort(a, cmp, lo, pivotIdx - 1, level + 1);
        lo = pivotIdx + 1;
      } else {
        qsort(a, cmp, pivotIdx + 1, hi, level + 1);
        hi = pivotIdx - 1;
      }
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
      trace(a);
      var pivotsIndices = [pivotIdx, 0];
      partition3(a, cmp, lo, hi, pivotsIndices);
      trace("\n");
      trace(a);
      
      qsort3way(a, cmp, lo, pivotsIndices[0]);
      qsort3way(a, cmp, pivotsIndices[1], hi);
    }
  }
  
  static function qselect<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, kth:Int):T
  {
    #if js
    untyped __js__('debugger');
    #end
    while (true) {
      if (lo == hi) break;
      
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
        return a[kth];
      }
      
      //trace(a.toString());
      var mid = medianOfThree(a, cmp, lo, hi);
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [mid, lo, hi], 'MLH'));
      var pivotIdx = partitionMed3(a, cmp, lo, hi, mid);
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [pivotIdx, lo, hi], '^LH'));
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
  
  // Lomuto
  static public function partition<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotIdx:Int):Int
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
    //trace(a);
    //trace(Util.highlightIndices(a, [storeIdx], null));
    return storeIdx;
  }
  
  static public function partitionMed3<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotIdx:Int):Int
  {
    if (hi - lo <= 2) return pivotIdx; // elements already sorted by med3
    var pivot = a[pivotIdx];
    Util.swap(a, pivotIdx, hi-1); // move pivot to end - 1
    var storeIdx = lo+1;
    for (i in lo+1...hi-1) {
      if (cmp(a[i], pivot) < 0) {
        Util.swap(a, storeIdx, i);
        storeIdx++;
      }
    }
    Util.swap(a, hi-1, storeIdx); // move pivot to its final place
    //trace(a);
    //trace(Util.highlightIndices(a, [storeIdx], null));
    return storeIdx;
  }

  // Hoare more or less
  static public function partitionX<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotIdx:Int):Int
  {
    var pivot = a[pivotIdx];
    Util.swap(a, pivotIdx, hi); // move pivot to end
    var i = lo;
    var j = hi;
    var q = j;
    while (true) {
      trace('a[i] >= $pivot && a[j] <= $pivot');
      trace(a);
      
      // From left, find the first element greater than
      // or equal to v. This loop will definitely terminate
      // as v is last element
      while (cmp(a[i], pivot) < 0) { i++; };
      
      // From right, find the first element smaller than or
      // equal to v
      while (cmp(a[j], pivot) > 0) {
        trace('j');
        trace(a);
        trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
        if (j <= lo) break; // out to the left
        j--;
      }
      
      trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
      if (i >= j) break; // exit when the pointers meet (or cross each other)
      
      // here a[lo...i) < pivot && a[j...hi) >= pivot, while a[i] >= pivot >= a[j] so we can safely swap i, j
      trace("can swap");
      trace(a);
      trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
      Util.swap(a, i, j);
      trace(a);
    }
    // here first half: a[lo...i) < pivot, second half: a[i...hi) >= pivot, a[hi] == pivot
    // so we move all the values from second half where v > pivot to the end
    
    trace(a);
    trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
    
    return pivotIdx;
  }
  
  static public function partition2<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotIdx:Int):Int
  {
    var pivotValue = a[pivotIdx];
    var i = lo;
    var j = hi;
    
    Util.swap(a, pivotIdx, hi);
    while (true) {
      trace(a.toString());
      trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
      while (cmp(a[++i], pivotValue) < 0) {};
      while (cmp(pivotValue, a[--j]) < 0) {
        if (j == lo) break;
      }
      if (i >= j) break;
      Util.swap(a, i, j);
    }
    Util.swap(a, i, hi);
    trace(a.toString());
    trace(Util.highlightIndices(a, [i], null));
    return i;
  }
  
  static public function partition3<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, pivotsIndices:Array<Int>):Void
  {
    var pivotValue = a[pivotsIndices[0]];
    var i = lo;
    var j = hi;
    var p = lo;
    var q = hi;
    
    trace(a.toString());
    trace(Util.highlightIndices(a, [pivotsIndices[0]], ['^']));
    while (true) {
      trace(a.toString());
      trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
      while (cmp(a[++i], pivotValue) < 0) {
        trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
      };
      trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
      while (cmp(pivotValue, a[--j]) < 0) {
        trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
        if (j == lo) break;
      }
      trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
      if (i >= j) break;
      Util.swap(a, i, j);
      
      trace(a.toString());
      trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
      if (cmp(a[i], pivotValue) == 0) {
        p++;
        Util.swap(a, p, i);
        trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
      }
      if (cmp(pivotValue, a[j]) == 0) {
        q--;
        Util.swap(a, q, j);
        trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
      }
    }
    Util.swap(a, i, hi);
    trace(pivotValue);
    trace(a.toString());
    trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
    
    j = i - 1;
    i = i + 1;
    var k = lo;
    while (k < p) {
      Util.swap(a, k, j);
      k++;
      j--;
    }
    k = hi;
    while (k > q) {
      Util.swap(a, i, k);
      k--;
      i++;
    }
    
    trace(a.toString());
    trace(Util.highlightIndices(a, [i,j,p,q], ['i','j','p','q']));
    
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