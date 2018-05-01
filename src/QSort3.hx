// https://www.cs.princeton.edu/~rs/talks/QuicksortIsOptimal.pdf
// Bentley-McIlroy 3-way partitioning


class QSort3 
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
    trace("Level: " + level);
    var out_ij = [0, 0];
    
    if (lo < hi) {
      
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
      
      trace(a.toString());
      partition(a, cmp, lo, hi, out_ij);
      var i = out_ij[0];
      var j = out_ij[1];
      
      trace(a.toString());
      trace(Util.highlightIndices(a, [j+1], ['^']));
      trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
      trace(Util.highlightIndices(a, [i, j], ['i','j']));
      
      // test invariants
      var pivot = a[j + 1];
      trace("pivotValue: " + pivot);
      
      var firstLtIdx = Util.iclamp(Util.imin(lo, j), lo, hi);
      var lastLtIdx = Util.iclamp(Util.imin(i, j+1), lo, hi);
      
      var firstPivotIdx = Util.imin(lastLtIdx+1, j+1);
      var lastPivotIdx = Util.imax(i, j-1);
      
      var firstGtIdx = lastPivotIdx;
      var lastGtIdx = hi;
      
      // nothing can be said about a[hi] (might equal pivot!)
      trace("INVARIANTS " + pivot);
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [j+1], ['^']));
      //trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
      //trace(Util.highlightIndices(a, [i, j], ['i','j']));
      
      trace(a.toString());
      trace(Util.highlightIndices(a, [lo, hi], ['[',']']));
      trace(Util.highlightIndices(a, [j+1], ['^']));
      trace(Util.highlightIndices(a, [firstLtIdx], ['A']));
      trace(Util.highlightIndices(a, [lastLtIdx], [')']));
      trace(a.toString());
      trace(Util.highlightIndices(a, [firstPivotIdx], ['M']));
      trace(Util.highlightIndices(a, [lastPivotIdx], [')']));
      trace(a.toString());
      trace(Util.highlightIndices(a, [firstGtIdx], ['V']));
      trace(Util.highlightIndices(a, [lastGtIdx], [')']));
      
      // test smaller than pivot
      var val;
      var ii = firstLtIdx + 1;
      while (ii < lastLtIdx)
      {
        val = a[ii - 1];
        assert(cmp(val, pivot) < 0, 'LT error a[${ii-1}] = $val vs $pivot');
        ii++;
      }
      
      // test greater than pivot
      ii = firstGtIdx + 1;
      while (ii < lastGtIdx) {
        val = a[ii - 1];
        assert(cmp(val, pivot) > 0, 'GT error a[${ii-1}] = $val vs $pivot');
        ii++;
      }
      
      // test equal to pivot
      ii = firstPivotIdx + 1;
      while (ii < lastPivotIdx) {
        val = a[ii - 1];
        assert(cmp(val, pivot) == 0, 'EQ error a[${ii-1}] = $val vs $pivot');
        ii++;
      }
      
      // OPT: sort smaller sequence first and update the bounds afterwards.
      //      Helps in keeping stack depth to a minimum by not creating unnecessary stackframes while recursing.
      //if (j - lo < hi - i) {
        trace("qsort left");
        qsort(a, cmp, lo, j, level + 1);
      //  lo = i;
      //} else {
        trace("qsort right");
        qsort(a, cmp, i, hi, level + 1);
      //  hi = j;
      //}
    }
  }
  
  // 3-way partition array `a` into [lo...out_ij[1]] < pivot | [out_ij[1]+1...out_ij[0]) == pivot | [out_ij[0]...hi] > pivot
  static public function partition<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, out_ij:Array<Int>):Void
  {
    var i = lo - 1, j = hi, p = lo - 1, q = hi;
    var pivot = a[hi];
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [hi], null));
    
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
        if (i == lo) {
          //trace('maybe we have a pivot both at $i and $hi: ', a[i], a[hi]);
          //while (cmp(a[j], pivot) == 0) {
          //  q--;
          //  //i++;
          //  //j++;
          //}
        }
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
    while (k < p) {
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [k, j, p], ['k','j', 'p']));
      Util.swap(a, k, j);
      k++;
      j--;
    }
    
    k = hi - 1;
    //trace(Util.highlightIndices(a, [k, i, q], ['k','i', 'q']));
    while (k >= q) {
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
}
