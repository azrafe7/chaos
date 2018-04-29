// https://algs4.cs.princeton.edu/23quicksort/Quick3way.java.html

class Quick3way 
{

  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    Util.shuffle(a);
    qsort(a, cmp, 0, a.length - 1);
  }
  
  // quicksort the subarray a[lo .. hi] using 3-way partitioning
  static public function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    if (hi <= lo) return;
    
    var lt_gt = [lo, hi];
    partition(a, cmp, lo, hi, lt_gt);
    
    // a[lo..lt-1] < pivot = a[lt..gt] < a[gt+1..hi]. 
    qsort(a, cmp, lo, lt_gt[0] - 1, level + 1);
    qsort(a, cmp, lt_gt[1] + 1, hi, level + 1);
  }
  
  static public function partition<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, lt_gt:Array<Int>):Void
  {
    var lt = lo, gt = hi;
    var pivot = a[lo];
    var i = lo + 1;
    while (i <= gt) {
      var diff = cmp(a[i], pivot);
      if      (diff < 0) Util.swap(a, lt++, i++);
      else if (diff > 0) Util.swap(a, i, gt--);
      else               i++;
    }
    
    lt_gt[0] = lt;
    lt_gt[1] = gt;
  }
}