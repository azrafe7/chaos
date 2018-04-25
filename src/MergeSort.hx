// https://en.wikipedia.org/wiki/Merge_sort
  
class MergeSort 
{
  
  static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void 
  {
    var scratch = a.copy();
    topDownSplitMerge(scratch, cmp, 0, a.length, a);
  }

  static public function sort2<T>(a:Array<T>, cmp:T -> T -> Int):Void 
  {
    var scratch = a.copy();
    bottomUpMergeSort(a, cmp, scratch, a.length);
  }
  
  static function topDownSplitMerge<T>(b:Array<T>, cmp:T -> T -> Int, start:Int, end:Int, a:Array<T>):Void
  {
    if (end - start < 2) return;
    
    var middle = (start + end) >> 1;
    topDownSplitMerge(a, cmp, start, middle, b);
    topDownSplitMerge(a, cmp, middle, end, b);
    topDownMerge(b, cmp, start, middle, end, a);
  }
  
  static function topDownMerge<T>(a:Array<T>, cmp:T -> T -> Int, start:Int, middle:Int, end:Int, b:Array<T>):Void
  {
    var i = start;
    var j = middle;
    
    for (k in start...end) {
      if (i < middle && (j >= end || cmp(a[i], a[j]) <= 0)) {
        b[k] = a[i];
        i++;
      } else {
        b[k] = a[j];
        j++;
      }
    }
  }
  
  inline static function min(a:Int, b:Int):Int {
    return a < b ? a : b < a ? b : a;
  }
  
  static function bottomUpMergeSort<T>(a:Array<T>, cmp:T -> T -> Int, b:Array<T>, n:Int):Void
  {
    var width = 1;
    while (width < n) {
      var i = 0;
      while (i < n) {
        bottomUpMerge(a, cmp, i, min(i + width, n), min(i + 2 * width, n), b);
        i = i + 2 * width;
      }
      Util.copy(b, a, n);
      width *= 2;
    }
  }
  
  static function bottomUpMerge<T>(a:Array<T>, cmp:T -> T -> Int, left:Int, right:Int, end:Int, b:Array<T>):Void
  {
    var i = left;
    var j = right;
    
    for (k in left...end) {
      if (i < right && (j >= end || cmp(a[i], a[j]) <= 0)) {
        b[k] = a[i];
        i++;
      } else {
        b[k] = a[j];
        j++;
      }
    }
  }
}