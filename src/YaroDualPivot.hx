// http://codeblab.com/wp-content/uploads/2009/09/DualPivotQuicksort.pdf


class YaroDualPivot 
{
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    //Util.shuffle(a); // check if needed to make it more stable/predictable, or can be removed
    dualsort(a, cmp, 0, a.length - 1, 3);
  }

  inline static var CUT_OFF = 27;
  inline static var HALF_CUT_OFF = 13;
  
  static public function dualsort<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, div:Int, level = 0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    var len = hi - lo;
    
    if (len < CUT_OFF) { // insertion sort for tiny array
      
      //for (int i = lo + 1; i <= hi; i++) {
      for (i in lo + 1...hi + 1) {
        //for (int j = i; j > lo && a[j] < a[j - 1]; j--) {
        var j = i;
        while (j > lo && cmp(a[j], a[j - 1]) < 0) {
          Util.swap(a, j, j - 1);
          j--;
        }
      }
      return;
    }
    
    var third = Std.int(len / div); // watch out for this div (might need flooring)
    
    // "medians"
    var m1 = lo + third;
    var m2 = hi - third;
    if (m1 <= lo) {
      m1 = lo + 1;
    }
    if (m2 >= hi) {
      m2 = hi - 1;
    }
    if (cmp(a[m1], a[m2]) < 0) {
      Util.swap(a, m1, lo);
      Util.swap(a, m2, hi);
    }
    else {
      Util.swap(a, m1, hi);
      Util.swap(a, m2, lo);
    }
    
    // pivots
    var pivot1 = a[lo];
    var pivot2 = a[hi];
    
    // pointers
    var less = lo + 1;
    var great = hi - 1;
    
    // sorting
    //for (int k = less; k <= great; k++) {
    var k = less;
    while (k <= great) {
      if (cmp(a[k], pivot1) < 0) {
        Util.swap(a, k, less++);
      } else if (cmp(a[k], pivot2) > 0) {
        while (k < great && cmp(a[great], pivot2) > 0) {
          great--;
        }
        Util.swap(a, k, great--);
        if (cmp(a[k], pivot1) < 0) {
          Util.swap(a, k, less++);
        }
      }
      k++;
    }
    
    // swaps
    var dist = great - less;
    if (dist < HALF_CUT_OFF) {
      div++;
    }
    Util.swap(a, less - 1, lo);
    Util.swap(a, great + 1, hi);
    
    // subarrays
    dualsort(a, cmp, lo, less - 2, div, level + 1);
    dualsort(a, cmp, great + 2, hi, div, level + 1);

    // equal elements
    //if (dist > len - 13 && pivot1 != pivot2) {
    //  for (int k = less; k <= great; k++) {
    if (dist > len - HALF_CUT_OFF && pivot1 != pivot2) {
      //for (int k = less; k <= great; k++) {
      k = less;
      while (k <= great) {
        if (cmp(a[k], pivot1) == 0) {
          Util.swap(a, k, less++);
        } else if (cmp(a[k], pivot2) == 0) {
          Util.swap(a, k, great--);
          if (cmp(a[k], pivot1) == 0) {
            Util.swap(a, k, less++);
          }
        }
        k++;
      }
    }
    
    // subarray
    if (cmp(pivot1, pivot2) < 0) {
      dualsort(a, cmp, less, great, div, level + 1);
    }
  }
}