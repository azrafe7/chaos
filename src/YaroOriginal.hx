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
    
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, hi], ['L', 'H']));
    
    if (len < TINY_SIZE) { // insertion sort on tiny array
      //trace('(use ins_sort');
      for (i in lo + 1...hi + 1) {
        var j = i;
        while (j > lo && cmp(a[j], a[j - 1]) < 0) {
          x = a[j - 1];
          a[j - 1] = a[j];
          a[j] = x;
          
          j--;
        }
      }
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [lo, hi], ['L', 'H']));
      //trace('useD ins_sort)');
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
    //trace('<5-elms');
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [m1, m2, m3, m4, m5], '12345'));
    if (cmp(a[m1], a[m2]) > 0) { x = a[m1]; a[m1] = a[m2]; a[m2] = x; }
    if (cmp(a[m4], a[m5]) > 0) { x = a[m4]; a[m4] = a[m5]; a[m5] = x; }
    if (cmp(a[m1], a[m3]) > 0) { x = a[m1]; a[m1] = a[m3]; a[m3] = x; }
    if (cmp(a[m2], a[m3]) > 0) { x = a[m2]; a[m2] = a[m3]; a[m3] = x; }
    if (cmp(a[m1], a[m4]) > 0) { x = a[m1]; a[m1] = a[m4]; a[m4] = x; }
    if (cmp(a[m3], a[m4]) > 0) { x = a[m3]; a[m3] = a[m4]; a[m4] = x; }
    if (cmp(a[m2], a[m5]) > 0) { x = a[m2]; a[m2] = a[m5]; a[m5] = x; }
    if (cmp(a[m2], a[m3]) > 0) { x = a[m2]; a[m2] = a[m3]; a[m3] = x; }
    if (cmp(a[m4], a[m5]) > 0) { x = a[m4]; a[m4] = a[m5]; a[m5] = x; }
    
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [m1, m2, m3, m4, m5], '12345'));
    //trace('5-elms>');
    
    // pivots: [ < pivot1 | pivot1 <= && <= pivot2 | > pivot2 ]
    var pivot1 = a[m2];
    var pivot2 = a[m4];
    var diffPivots:Bool = (cmp(pivot1, pivot2) != 0);
    a[m2] = a[lo];
    a[m4] = a[hi];
    
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, m2, m4, hi], 'LpqH'));
    
    // center part pointers
    var less = lo + 1;
    var great = hi - 1;
    //trace(Util.highlightIndices(a, [less, great], '<>'));
    
    // sorting
    //trace('sort');
    var k = -1;
    if (diffPivots) {
      k = less;
      while (k <= great) {
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [less, k, great], 'lkg'));
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
        
        k++;
      }
    }
    else {
      k = less;
      while (k <= great) {
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [less, k, great], 'lkg'));
        x = a[k];
        if (cmp(x, pivot1) == 0) {
          k++;
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
        
        k++;
      }
    }
    
    // swap
    //trace('<swap');
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, less-1, hi, great+1], 'LlHg'));
    a[lo] = a[less - 1];
    a[less - 1] = pivot1;
    a[hi] = a[great + 1];
    a[great + 1] = pivot2;
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, less-1, hi, great+1], 'LlHg'));
    //trace('swap>');
    
    // left and right parts
    dualsort(a, cmp, lo, less - 2, level + 1);
    dualsort(a, cmp, great + 2, hi, level + 1);
    
    // equal elements
    if ((great - less > len - DIST_SIZE) && diffPivots) {
      k = less;
      while (k <= great) {
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
        
        k++;
      }
    }
    
    // center part
    //trace('center');
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [less, great], 'cC'));
    if (diffPivots) {
      dualsort(a, cmp, less, great, level + 1);
    }
  }
}