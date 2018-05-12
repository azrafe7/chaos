// https://en.wikipedia.org/wiki/Merge_sort
  
class MergeSort 
{
  
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void 
  {
    var scratch = a.copy();
    topDownSplitMerge(scratch, cmp, 0, a.length, a);
  }

  static public function sort2<T>(a:Array<T>, cmp:T -> T -> Int):Void 
  {
    var scratch = a.copy();
    bottomUpMergeSort(a, cmp, scratch, a.length);
  }
  
  inline static public function sort3<T>(a:Array<T>, cmp:T -> T -> Int):Void 
  {
    sortRange(a, cmp, 0, a.length - 1);
  }
  
  // both lo and hi inclusive
  static public function sortRange<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int):Void 
  {
    //if (hi - lo + 1 == a.length) {
    //  sort(a, cmp);
    //  return;
    //}
    
    var scratch = [for (i in lo...hi+1) a[i]]; // scratch[0] = a[i], ... , scratch[hi-lo] = a[hi], so it might be smaller than a
    //
    //// this works obviously!
    //sort(scratch, cmp);
    //for (i in 0...hi - lo + 1) a[lo + i] = scratch[i]; // copy back
    
    //trace("S" + scratch.length);
    topDownSplitMergeRange(scratch, cmp, lo, lo + scratch.length, a, lo);
    //trace("S" + scratch.toString());
    //trace(a.toString());
  }

  
  static function topDownSplitMerge<T>(b:Array<T>, cmp:T -> T -> Int, start:Int, end:Int, a:Array<T>, level=0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    if (end - start < 2) return;
    
    var middle = (start + end) >> 1;
    topDownSplitMerge(a, cmp, start, middle, b, level + 1);
    topDownSplitMerge(a, cmp, middle, end, b, level + 1);
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
  
  
  
  static function topDownSplitMergeRange<T>(b:Array<T>, cmp:T -> T -> Int, start:Int, end:Int, a:Array<T>, offset:Int, level=0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    if (end - start < 2) return;

    var middle = (start + end) >> 1;
    topDownSplitMergeRange(a, cmp, start, middle, b, -offset, level + 1);  // flip offset to signal swapping scratch and a for work
    topDownSplitMergeRange(a, cmp, middle, end, b, -offset, level + 1);    // flip offset to signal swapping scratch and a for work
    //trace('LEV $level');
    topDownMergeRange(b, cmp, start, middle, end, a, offset);
  }
  
  static function topDownMergeRange<T>(a:Array<T>, cmp:T -> T -> Int, start:Int, middle:Int, end:Int, b:Array<T>, offset:Int):Void
  {
    var i = start;
    var j = middle;
    
    //trace('A_len:${a.length} B_len:${b.length} offset:$offset s:$start');
    //trace(offset > 0 ? 'A is scratch' : 'B is scratch');
    
    // adjust offsets
    var a_offset = 0;
    var b_offset = offset;
    if (offset > 0) {
      a_offset = -offset;
      b_offset = 0;
    }
    //trace('A_offset:$a_offset B_offset:$b_offset');
    
    for (k in start...end) {
      //if (i-offset < 0 || i-offset >= a.length) throw 'oob offset i $i/${a.length}';
      //if (j-offset < 0 || j-offset >= a.length) throw 'oob offset j $j/${a.length}';
      //if (i < 0 || i >= a.length) throw 'oob i $i/${a.length}';
      //if (j < 0 || j >= a.length) throw 'oob j $j/${a.length}';
      
      if (i < middle && (j >= end || cmp(a[i + a_offset], a[j + a_offset]) <= 0)) {
        b[k + b_offset] = a[i + a_offset];
        i++;
      } else {
        b[k + b_offset] = a[j + a_offset];
        j++;
      }
    }
  }
}