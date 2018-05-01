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
      
      // test invariants
      trace(a.toString());
      trace(Util.highlightIndices(a, [j+1], ['^']));
      trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
      trace(Util.highlightIndices(a, [i, j], ['i','j']));
      
      var pivot = a[j + 1];
      trace("pivotValue: " + pivot);
      
      var ii = lo + 1;
      while (ii < j)
      {
        var val = a[ii - 1];
        assert(cmp(val, pivot) < 0, 'LT error a[${ii-1}] = $val vs $pivot');
        ii++;
      }
      
      ii = i + 1;
      while (ii <= hi + 1) {
        var val = a[ii - 1];
        assert(cmp(val, pivot) > 0, 'GT error a[${ii-1}] = $val vs $pivot');
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
    trace(a.toString());
    trace(Util.highlightIndices(a, [hi], null));
    
    while (true)
    {
      trace(Util.highlightIndices(a, [i,j], ['i','j']));
      while (cmp(a[++i], pivot) < 0) {
        trace(Util.highlightIndices(a, [i], ['i']));
      };
      while (cmp(pivot, a[--j]) < 0) {
        trace(Util.highlightIndices(a, [j], ['j']));
        if (j == lo) break;
      }
      trace(a.toString());
      trace(Util.highlightIndices(a, [i,j], ['i','j']));
      if (i >= j) break;
      Util.swap(a, i, j);
      trace(a.toString());
      trace(Util.highlightIndices(a, [i,j], ['i','j']));
      
      if (cmp(a[i], pivot) == 0) {
        p++; 
        Util.swap(a, p, i); 
      }
      trace(a.toString());
      trace(Util.highlightIndices(a, [p,q], ['p','q']));
      if (cmp(pivot, a[j]) == 0) {
        q--; 
        Util.swap(a, j, q); 
      }
      trace(a.toString());
      trace(Util.highlightIndices(a, [p,q], ['p','q']));
    }
    Util.swap(a, i, hi); 
    trace(a.toString());
    trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
    trace(Util.highlightIndices(a, [i, j], ['i','j']));
    trace(Util.highlightIndices(a, [p, q], ['p','q']));
    j = i - 1;
    i = i + 1;
    
    var k = lo;
    trace(a.toString());
    trace(Util.highlightIndices(a, [k, j, p], ['k','j', 'p']));
    while (k < p) {
      trace(a.toString());
      trace(Util.highlightIndices(a, [k, j, p], ['k','j', 'p']));
      Util.swap(a, k, j);
      k++;
      j--;
    }
    k = hi - 1;
    trace(Util.highlightIndices(a, [k, i, q], ['k','i', 'q']));
    while (k >= q) {
      trace(a.toString());
      trace(Util.highlightIndices(a, [k, i, q], ['k','i', 'q']));
      Util.swap(a, i, k);
      k--;
      i++;
    }
    trace('pivot in place $pivot');
    trace(a.toString());
    trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
    
    out_ij[0] = i;
    out_ij[1] = j;
  }
}
