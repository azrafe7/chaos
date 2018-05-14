// original impl of Yaroslavskiy's Dual-Pivot Quicksort
// https://web.archive.org/web/20151002230717/http://iaroslavski.narod.ru/quicksort/DualPivotQuicksort.pdf

/**
 * @author Vladimir Yaroslavskiy
 * @version 2009.09.17 m765.817
 */
class YaroOriginal
{
 
  static inline var DIST_SIZE = 13;
  static inline var TINY_SIZE = 17;

  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    dualsort(a, cmp, 0, a.length - 1);
  }
  
  static public function dualsort<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, level = 0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    var len = hi - lo;
    var x:T;
    
    if (len < TINY_SIZE) { // insertion sort on tiny array
      for (i in lo + 1...hi + 1) {
        var j = i;
        while (j > lo && cmp(a[j], a[j - 1]) < 0) {
          x = a[j - 1];
          a[j - 1] = a[j];
          a[j] = x;
          
          j--;
        }
      }
      return;
    }
    
    // median indexes
    var sixth = Std.int(len / 6);
    var m1 = lo + sixth;
    var m2 = m1 + sixth;
    var m3 = m2 + sixth;
    var m4 = m3 + sixth;
    var m5 = m4 + sixth;
    
    // 5-element sorting network
    if (cmp(a[m1], a[m2]) > 0) { x = a[m1]; a[m1] = a[m2]; a[m2] = x; }
    if (cmp(a[m4], a[m5]) > 0) { x = a[m4]; a[m4] = a[m5]; a[m5] = x; }
    if (cmp(a[m1], a[m3]) > 0) { x = a[m1]; a[m1] = a[m3]; a[m3] = x; }
    if (cmp(a[m2], a[m3]) > 0) { x = a[m2]; a[m2] = a[m3]; a[m3] = x; }
    if (cmp(a[m1], a[m4]) > 0) { x = a[m1]; a[m1] = a[m4]; a[m4] = x; }
    if (cmp(a[m3], a[m4]) > 0) { x = a[m3]; a[m3] = a[m4]; a[m4] = x; }
    if (cmp(a[m2], a[m5]) > 0) { x = a[m2]; a[m2] = a[m5]; a[m5] = x; }
    if (cmp(a[m2], a[m3]) > 0) { x = a[m2]; a[m2] = a[m3]; a[m3] = x; }
    if (cmp(a[m4], a[m5]) > 0) { x = a[m4]; a[m4] = a[m5]; a[m5] = x; }
    
    // pivots: [ < pivot1 | pivot1 <= && <= pivot2 | > pivot2 ]
    var pivot1 = a[m2];
    var pivot2 = a[m4];
    var diffPivots:Bool = pivot1 != pivot2;
    a[m2] = a[lo];
    a[m4] = a[hi];
    
    // center part pointers
    var less = lo + 1;
    var great = hi - 1;
    
    // sorting
    if (diffPivots) {
      for (k in less...great + 1) {
        x = a[k];
        if (cmp(x, pivot1) < 0) {
          a[k] = a[less];
          a[less++] = x;
        } 
        else if (cmp(x, pivot2) > 0) {
          while (cmp(a[great], pivot2) > 0 && k < great) {
            great--;
          }
          a[k] = a[great];
          a[great--] = x;
          x = a[k];
          if (cmp(x, pivot1) < 0) {
            a[k] = a[less];
            a[less++] = x;
          }
        }
      }
    }
    else {
      for (k in less...great + 1) {
        x = a[k];
        if (cmp(x, pivot1) == 0) {
          continue;
        }
        if (cmp(x, pivot1) < 0) {
          a[k] = a[less];
          a[less++] = x;
        }
        else {
          while (cmp(a[great], pivot2) > 0 && k < great) {
            great--;
          }
          a[k] = a[great];
          a[great--] = x;
          x = a[k];
          if (cmp(x, pivot1) < 0) {
            a[k] = a[less];
            a[less++] = x;
          }
        }
      }
    }
    
    // swap
    a[lo] = a[less - 1];
    a[less - 1] = pivot1;
    a[hi] = a[great + 1];
    a[great + 1] = pivot2;
    
    // left and right parts
    dualsort(a, cmp, lo, less - 2, level + 1);
    dualsort(a, cmp, great + 2, hi, level + 1);
    
    // equal elements
    if (great - less > len - DIST_SIZE && diffPivots) {
      for (k in less...great + 1) {
        x = a[k];
        if (cmp(x, pivot1) == 0) {
          a[k] = a[less];
          a[less++] = x;
        }
        else if (cmp(x, pivot2) == 0) {
          a[k] = a[great];
          a[great--] = x;
          x = a[k];
          if (cmp(x, pivot1) == 0) {
            a[k] = a[less];
            a[less++] = x;
          }
        }
      }
    }
    
    // center part
    if (diffPivots) {
      dualsort(a, cmp, less, great, level + 1);
    }
  }
}