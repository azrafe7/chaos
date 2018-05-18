// https://www.cs.princeton.edu/~rs/talks/QuicksortIsOptimal.pdf
// Bentley-McIlroy 3-way partitioning (with median-of-three pivot selection)


class QSort3Med 
{

  static public function assert(cond:Bool, msg = "error")
  {
    if (!cond) throw msg;
  }
  
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    //Util.shuffle(a); // check if needed to make it more stable/predictable, or can be removed
    qsort(a, cmp, 0, a.length - 1);
  }
  
  // quicksort the subarray a[lo .. hi] using Bentley-McIlroy 3-way partitioning
  static public function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    //trace("Level: " + level);
    var out_ij = [0, 0];
    
    while (lo < hi) {
    //if (lo < hi) {
      
      // OPT: use insertion sort for small sequences
      if (hi - lo < QuickSort.M) {
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
      
      //trace(a.toString());
      partition(a, cmp, lo, hi, out_ij);
      var i = out_ij[0];
      var j = out_ij[1];
      
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [j+1], ['^']));
      //trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
      //trace(Util.highlightIndices(a, [i, j], ['i','j']));
      
      // test invariants
      //var pivot = a[j + 1];
      //trace("pivotValue: " + pivot);
      
      //var firstPivotIdx = j + 1;
      //var lastPivotIdx = i; // exclusive
      
      //var firstLtIdx = lo;
      //var lastLtIdx = firstPivotIdx; // exclusive
      
      //var firstGtIdx = lastPivotIdx;
      //var lastGtIdx = hi; // exclusive
      
      // nothing can be said about a[hi] (might equal pivot!)
      //trace("INVARIANTS " + pivot);
      ////trace(a.toString());
      ////trace(Util.highlightIndices(a, [j+1], ['^']));
      ////trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
      ////trace(Util.highlightIndices(a, [i, j], ['i','j']));
      
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [lo, hi], ['[',']']));
      //trace(Util.highlightIndices(a, [j+1], ['^']));
      //trace(Util.highlightIndices(a, [firstLtIdx], ['A']));
      //trace(Util.highlightIndices(a, [lastLtIdx], [')']));
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [firstPivotIdx], ['M']));
      //trace(Util.highlightIndices(a, [lastPivotIdx], [')']));
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [firstGtIdx], ['V']));
      //trace(Util.highlightIndices(a, [lastGtIdx], [')']));
      
      // test smaller than pivot
      //var val;
      //var ii = firstLtIdx;
      //while (ii < lastLtIdx)
      //{
      //  val = a[ii];
      //  //assert(cmp(val, pivot) < 0, 'LT error a[${ii}] = $val vs $pivot');
      //  ii++;
      //}
      ////
      ////// test greater than pivot
      //ii = firstGtIdx;
      //while (ii < lastGtIdx) {
      //  val = a[ii];
      //  //assert(cmp(val, pivot) > 0, 'GT error a[${ii}] = $val vs $pivot');
      //  ii++;
      //}
      ////
      ////// test equal to pivot
      //ii = firstPivotIdx;
      //while (ii < lastPivotIdx) {
      //  val = a[ii];
      //  //assert(cmp(val, pivot) == 0, 'EQ error a[${ii}] = $val vs $pivot');
      //  ii++;
      //}
      //
      //// test left branch already sorted
      //ii = lo;
      //while (ii < firstLtIdx) {
      //  assert(cmp(a[ii], a[ii + 1]) <= 0, 'Not sorted $ii ${a[ii]} vs ${a[ii+1]}');
      //  ii++;
      //}
      
      // OPT: sort smaller sequence first and update the bounds afterwards.
      //      Helps in keeping stack depth to a minimum by not creating unnecessary stackframes while recursing.
      if (j - lo < hi - i) {
        //if (j <= lo) //trace("useless lo");
        //trace("qsort left");
        if (j > lo) // avoid a call (but add an if)
          qsort(a, cmp, lo, j, level + 1);
        lo = i;
      } else {
        //if (i >= hi) //trace("useless hi");
        //trace("qsort right");
        if (i < hi) // avoid a call (but add an if)
          qsort(a, cmp, i, hi, level + 1);
        hi = j;
      }
    }
  }
  
  // 3-way partition array `a` into [lo...out_ij[1]] < pivot | [out_ij[1]+1...out_ij[0]) == pivot | [out_ij[0]...hi] > pivot
  static public function partition<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, out_ij:Array<Int>):Void
  {
    var i = lo - 1, j = hi, p = lo - 1, q = hi;
    var m = median3(a, cmp, lo, lo + ((hi - lo + 1) >> 1), hi);
    Util.swap(a, m, hi); // move pivot to hi
    var pivot = a[hi];
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo,hi], ['L', '^']));
    
    while (true)
    {
      //trace(Util.highlightIndices(a, [i,j], ['i','j']));
      while (cmp(a[++i], pivot) < 0) {
        //trace(Util.highlightIndices(a, [i], ['i']));
      };
      while (cmp(pivot, a[--j]) < 0) {
        //trace(Util.highlightIndices(a, [j], ['j']));
        if (j == lo) break;
      }
      
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [i,j], ['i','j']));
      //trace(Util.highlightIndices(a, [p,q], ['p','q']));
      if (i >= j) {
        break;
      }
      Util.swap(a, i, j);
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [i,j], ['i','j']));
      //trace(Util.highlightIndices(a, [p,q], ['p','q']));
      
      if (cmp(a[i], pivot) == 0) {
        p++; 
        Util.swap(a, p, i); 
      }
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [p,q], ['p','q']));
      if (cmp(pivot, a[j]) == 0) {
        q--; 
        Util.swap(a, j, q); 
      }
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [p,q], ['p','q']));
    }
    Util.swap(a, i, hi);
    
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
    //trace(Util.highlightIndices(a, [i, j], ['i','j']));
    //trace(Util.highlightIndices(a, [p, q], ['p','q']));
    j = i - 1;
    i = i + 1;
    //trace(Util.highlightIndices(a, [i, j], ['i','j']));
    
    var k = lo;
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [k, j, p], ['k','j', 'p']));
    while (k <= p /*&& k != j*/) {
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [k, j, p], ['k','j', 'p']));
      Util.swap(a, k, j);
      k++;
      j--;
    }
    
    k = hi - 1;
    //trace(Util.highlightIndices(a, [k, i, q], ['k','i', 'q']));
    while (k >= q/* && k != i*/) {
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [k, i, q], ['k','i', 'q']));
      Util.swap(a, i, k);
      k--;
      i++;
    }
    //trace('pivot in place $pivot');
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
    
    out_ij[0] = i;
    out_ij[1] = j;
  }
  
  static public function select<T>(a:Array<T>, cmp:T -> T -> Int, kth:Int):T
  {
    return qselect(a, cmp, 0, a.length - 1, kth);
  }
  
  static function qselect<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, kth:Int):T
  {
    var out_ij = [0, 0];
    while (true) {
      if (lo == hi) break;
      partition(a, cmp, lo, hi, out_ij);
      var pivotIdx = out_ij[1] + 1;
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
  
  // return the index of the median element among a[i], a[j], and a[k]
  static function median3<T>(a:Array<T>, cmp:T->T->Int, i:Int, j:Int, k:Int):Int {
    //return {
    //  if (cmp(a[i], a[j]) < 0) {
    //    if (cmp(a[j], a[k]) < 0) j;
    //    else if (cmp(a[i], a[k]) < 0) k;
    //    else i;
    //  } else {
    //    if (cmp(a[k], a[j]) < 0) j;
    //    else if (cmp(a[k], a[i]) < 0) k;
    //    else i;
    //  } 
    //}
    return (cmp(a[i], a[j]) < 0 ?
           (cmp(a[j], a[k]) < 0 ? j : cmp(a[i], a[k]) < 0 ? k : i) :
           (cmp(a[k], a[j]) < 0 ? j : cmp(a[k], a[i]) < 0 ? k : i));
  }
}
