// https://www.cs.princeton.edu/~rs/talks/QuicksortIsOptimal.pdf
// Bentley-McIlroy 3-way partitioning


class QSort3 
{
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    Util.shuffle(a);
    qsort(a, cmp, 0, a.length - 1);
  }
  
  // quicksort the subarray a[lo .. hi] using Bentley-McIlroy 3-way partitioning
  static public function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    while (lo < hi) {
      
      var i = lo - 1, j = hi, p = lo - 1, q = hi; 
      var pivot = a[hi];
      
      while (true)
      {
        while (cmp(a[++i], pivot) < 0) {};
        while (cmp(pivot, a[--j]) < 0) {
          if (j == lo) break;
        }
        if (i >= j) break;
        Util.swap(a, i, j);
        
        if (cmp(a[i], pivot) == 0) {
          p++; 
          Util.swap(a, p, i); 
        }
        if (cmp(pivot, a[j]) == 0) {
          q--; 
          Util.swap(a, j, q); 
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
      
      // OPT: sort smaller sequence first and update the bounds afterwards.
      //      Helps in keeping stack depth to a minimum, avoids creating unnecessary stackframes while recursing.
      if (j - lo < hi - i) {
        qsort(a, cmp, lo, j, level + 1);
        lo = i;
      } else {
        qsort(a, cmp, i, hi, level + 1);
        hi = j;
      }
    }
  }
}
