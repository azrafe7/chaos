
class MidSort 
{

  static public function assert(cond:Bool, msg = "error")
  {
    if (!cond) throw msg;
  }
  
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    //Util.shuffle(a); // check if needed to make it more stable/predictable, or can be removed
    var ij = [0,0];
    partition(a, cmp, 0, a.length - 1, ij);
    trace(a.toString());
    trace(Util.highlightIndices(a, ij, ['i','j']));
    //msort(a, cmp, 0, a.length - 1);
  }
  
  // quicksort the subarray a[lo .. hi] using Bentley-McIlroy 3-way partitioning
  static public function msort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
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
      var pivot = a[j + 1];
      //trace("pivotValue: " + pivot);
      
      var firstPivotIdx = j + 1;
      var lastPivotIdx = i; // exclusive
      
      var firstLtIdx = lo;
      var lastLtIdx = firstPivotIdx; // exclusive
      
      var firstGtIdx = lastPivotIdx;
      var lastGtIdx = hi; // exclusive
      
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
      //  assert(cmp(val, pivot) < 0, 'LT error a[${ii}] = $val vs $pivot');
      //  ii++;
      //}
      //
      //// test greater than pivot
      //ii = firstGtIdx;
      //while (ii < lastGtIdx) {
      //  val = a[ii];
      //  assert(cmp(val, pivot) > 0, 'GT error a[${ii}] = $val vs $pivot');
      //  ii++;
      //}
      //
      //// test equal to pivot
      //ii = firstPivotIdx;
      //while (ii < lastPivotIdx) {
      //  val = a[ii];
      //  assert(cmp(val, pivot) == 0, 'EQ error a[${ii}] = $val vs $pivot');
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
        //trace("qsort left");
        msort(a, cmp, lo, j, level + 1);
        lo = i;
      } else {
        //trace("qsort right");
        msort(a, cmp, i, hi, level + 1);
        hi = j;
      }
    }
  }
  
  // 3-way partition array `a` into [lo...out_ij[1]] < pivot | [out_ij[1]+1...out_ij[0]) == pivot | [out_ij[0]...hi] > pivot
  static public function partition<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, out_ij:Array<Int>):Void
  {
    var m = lo + ((hi - lo + 1) >> 1);
    
    var p = m - 1;
    var q = m + 1;
    var i = p;
    var j = q;
    
    Util.iclamp(p, lo, hi);
    Util.iclamp(q, lo, hi);
    
    var loValue = a[lo];
    var hiValue = a[hi];
    var pivotValue = medianOfThree(a, cmp, lo, m, hi);
    
    
    trace(a.toString());
    trace(Util.highlightIndices(a, [lo,m,hi], ['L', '^', 'H']));
    
    if (hi - lo <= 2) { // already sorted by med3
      out_ij[0] = hi;
      out_ij[1] = lo;
      return;
    }
    
    var leftDist = 0;
    var rightDist = 0;
    
    
    var pEqPivot = 0;
    var pLtLo = 0;
    var qEqPivot = 0;
    var qGtHi = 0;
    
    var cnt = 8;
    while (cnt-- > 0)
    {
      trace(a.toString());
      trace(Util.highlightIndices(a, [i,j], ['i','j']));
      trace(Util.highlightIndices(a, [p,q], ['p','q']));
      
      // left
      trace('left');
      var prevDiff = -1;
      while (p > lo) {
        trace(Util.highlightIndices(a, [i,j], ['i','j']));
        trace(Util.highlightIndices(a, [p,q], ['p','q']));
        var pValue = a[p];
        var diff = cmp(pValue, pivotValue);
        if (diff > 0) break;
        else {
          if (diff == 0) i--;
        }
        p--;
        prevDiff = diff;
      }
      trace(a.toString());
      trace(Util.highlightIndices(a, [i,j], ['i','j']));
      trace(Util.highlightIndices(a, [p,q], ['p','q']));
      
      // right
      trace('right');
      var prevDiff = 1;
      while (q < hi) {
        trace(a.toString());
        trace(Util.highlightIndices(a, [i,j], ['i','j']));
        trace(Util.highlightIndices(a, [p,q], ['p','q']));
        var qValue = a[q];
        var diff = cmp(qValue, pivotValue);
        if (diff < 0) break;
        else {
          if (diff == 0) {
            Util.swap(a, j, q);
            p--;
            i--;
            j++;
          }
        }
        q++;
        prevDiff = diff;
      }
      trace(a.toString());
      trace(Util.highlightIndices(a, [i,j], ['i','j']));
      trace(Util.highlightIndices(a, [p,q], ['p','q']));

      trace('swap');
      Util.swap(a, p, q);
    }
    
    if (i > lo) Util.swap(a, i, lo);
    
    out_ij[0] = i;
    out_ij[1] = j;
  }
  
  // make sure a[lo] <= a[mid] <= a[hi], and return mid
  static public function medianOfThree<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, mid:Int, hi:Int):T {
    if (Util.compare(a, cmp, lo, mid) > 0) Util.swap(a, lo, mid);
    if (Util.compare(a, cmp, lo, hi) > 0) Util.swap(a, lo, hi);
    if (Util.compare(a, cmp, mid, hi) > 0) Util.swap(a, mid, hi);
    
    return a[mid];
  }
}
