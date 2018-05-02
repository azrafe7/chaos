// https://algs4.cs.princeton.edu/23quicksort/QuickX.java.html

class QuickX 
{
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    //Util.shuffle(a); // check if needed to make it more stable/predictable, or can be removed
    qsort(a, cmp, 0, a.length - 1);
  }
  
  // quicksort the subarray a[lo .. hi] using Bentley-McIlroy 3-way partitioning as implemented by Sedgewick
  static public function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;

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
      
      var j = partitionMedian3(a, cmp, lo, hi);
      
      if (j - lo < hi - j) {
        qsort(a, cmp, lo, j - 1, level + 1);
        lo = j + 1;
      } else {
        qsort(a, cmp, j + 1, hi, level + 1);
        hi = j - 1;
      }
    }
  }

  // partition the subarray a[lo..hi] so that a[lo..j-1] <= a[j] <= a[j+1..hi]
  // and return the index j.
  static public function partitionMedian3<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Int {
    var n:Int = hi - lo + 1;
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo,hi], ['L', 'H']));

    var m = median3(a, cmp, lo, lo + (n >> 1), hi);
    //trace(Util.highlightIndices(a, [m], ['m']));
    Util.swap(a, m, lo);

    var i = lo;
    var j = hi + 1;
    var v = a[lo];

    //trace(a.toString());
    //trace(Util.highlightIndices(a, [i,j], ['^', 'j']));
    
    // a[lo] is unique largest element
    while (cmp(a[++i], v) < 0) {
      if (i == hi) { Util.swap(a, lo, hi); return hi; }
    }
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [i,j], ['i', 'j']));
    

    // a[lo] is unique smallest element
    while (cmp(v, a[--j]) < 0) {
      if (j == lo + 1) return lo;
    }
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [i,j], ['i', 'j']));

    // the main loop
    while (i < j) { 
      Util.swap(a, i, j);
      while (cmp(a[++i], v) < 0) {};
      while (cmp(v, a[--j]) < 0) {};
    }
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [i,j], ['i', 'j']));

    // put partitioning item v at a[j]
    Util.swap(a, lo, j);

    // now, a[lo .. j-1] <= a[j] <= a[j+1 .. hi]
    return j;
  }
  
  // return the index of the median element among a[i], a[j], and a[k]
  static function median3<T>(a:Array<T>, cmp:T->T->Int, i:Int, j:Int, k:Int):Int {
    return (cmp(a[i], a[j]) < 0 ?
           (cmp(a[j], a[k]) < 0 ? j : cmp(a[i], a[k]) < 0 ? k : i) :
           (cmp(a[k], a[j]) < 0 ? j : cmp(a[k], a[i]) < 0 ? k : i));
    }
}