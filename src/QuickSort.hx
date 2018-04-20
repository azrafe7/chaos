

class QuickSort {
  
  static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    qsort(a, cmp, 0, a.length - 1);
  }
  
  static function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Void
  {
    if (lo < hi) {
      var p = partition(a, cmp, lo, hi);
      qsort(a, cmp, lo, p);
      qsort(a, cmp, p + 1, hi);
    }
  }
  
  static function partition<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int)
  {
    var pivot = a[lo];
    var i = lo - 1;
    var j = hi + 1;
    while (true) {
      do {
        i++;
      } while (cmp(a[i], pivot) < 0);
      do {
        j--;
      } while (cmp(a[j], pivot) > 0);
      
      if (i >= j) break;
      
      Util.swap(a, i, j);
    }
    return j;
  }  
}