// original impl of Yaroslavskiy's Dual-Pivot Quicksort
// https://web.archive.org/web/20151002230717/http://iaroslavski.narod.ru/quicksort/DualPivotQuicksort.pdf

/**
 * @author Vladimir Yaroslavskiy
 * @version 2009.09.17 m765.817
 */
class YaroOriginalPart
{

/*  static public var sorted = [];
  static public var inplace = [];
  
  static public var sortedPart = [];
  static public var inplacePart = [];
  
  static public var sortedSel = [];
  static public var inplaceSel = [];
*/  
  // to ensure correctness, don't go below 6 (insertion sort IS needed). Default is 17
  static inline var TINY_SIZE = 17; 

  static inline var DIST_SIZE = 13;
  
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
  #if js
    untyped __js__('debugger');
  #end
    //sorted = a.copy();
    //sorted.sort(cmp);
    //inplace = [for (i in a) cast -1];
    dualsort(a, cmp, 0, a.length - 1);
    //trace(sorted.toString());
    //trace(inplace.toString());
    //for (i in 0...a.length) { 
    //  if (cmp(cast sorted[i], cast inplace[i]) != 0) //trace('not in place $i');
    //}
  }
  
  static public function dualsort<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, level = 0, kth = -1):Void
  {
    if (kth < 0) {
      kth = Std.random(a.length);
      //trace('kth:$kth');
    }
    
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    var len = hi - lo;
    var x:T;
    
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, hi], ['L', 'H']));
    
    if (len < TINY_SIZE) { // insertion sort on tiny array
      //trace('<use ins_sort');
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
      //trace('inplace?');
      //for (i in lo...hi + 1) {
      //  inplace[i] = a[i];
      //}
      //if (kth >= lo && kth <= hi) {
      //  //trace('$kth-kth found: ${inplace[kth]}'); 
      //}
      //trace(sorted.toString());
      //trace(inplace.toString());
      //trace(Util.highlightIndices(inplace, [lo, hi], ['[', ']']));
      //trace('useD ins_sort>');
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
    //trace('pivot1:$pivot1 pivot2:$pivot2');
    var k:Int;
    if (diffPivots) {
      k = less;
      //trace(a.toString());
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
            //trace(Util.highlightIndices(a, [less, k, great], 'lkg'));
            great--;
          }
          //trace(a.toString());
          //trace(Util.highlightIndices(a, [less, k, great], 'lkg'));
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
    //trace(Util.highlightIndices(a, [lo, less, hi, great], 'LlHg'));
    a[lo] = a[less - 1];
    a[less - 1] = pivot1;
    a[hi] = a[great + 1];
    a[great + 1] = pivot2;
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, less, hi, great], 'LlHg'));
    //trace('swap>');
    
    // left and right parts
    //trace('sure kth ${less - 1} ${great + 1}');
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [less - 1, great + 1], '^^'));
    //inplace[less - 1] = pivot1;
    //inplace[great + 1] = pivot2;
    //if (kth == less - 1 || kth == great + 1) {
    //  //trace('$kth-kth found: ${inplace[kth]}'); 
    //}
    //trace(sorted.toString());
    //trace(inplace.toString());
    dualsort(a, cmp, lo, less - 2, level + 1, kth);
    dualsort(a, cmp, great + 2, hi, level + 1, kth);
    
    // equal elements
    //trace('<equal');
    var _k = less;
    //trace(sorted.toString());
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [less, great], 'lg'));
    if ((great - less > len - DIST_SIZE) && diffPivots) {
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [k, great], 'LlHg'));
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
    //trace(sorted.toString());
    //trace(a.toString());
    //trace(inplace.toString());
    //trace(Util.highlightIndices(a, [less,great,k], 'lgk'));
    //trace('equal>');
    
    // center part
    //trace('center');
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [less, great], 'cC'));
    if (diffPivots) {
      dualsort(a, cmp, less, great, level + 1, kth);
    }
  }

 
  
  inline static public function sortpart<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
  #if js
    untyped __js__('debugger');
  #end
    //sortedPart = a.copy();
    //sortedPart.sort(cmp);
    //inplacePart = [for (i in a) cast -1];
    _sortpart(a, cmp, 0, a.length - 1);
    //trace(sortedPart.toString());
    //trace(inplacePart.toString());
    //for (i in 0...a.length) {
    //  if (cmp(cast sortedPart[i], cast inplacePart[i]) != 0) //trace('not in place $i');
    //}
  }
  
  
  static public function _sortpart<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, level = 0):Void
  {
    
    //QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    //QuickSort.calls++;
    
    var out_pivots = [0, 0];
    
    if (lo < hi)
    {
      
      var len = hi - lo;
      var x:T;
      
      if (len < TINY_SIZE) { // insertion sort on tiny array
        //trace('<use ins_sort');
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
        //trace('inplace?');
        //for (i in lo...hi + 1) {
        //  inplacePart[i] = a[i];
        //}
        //trace(sortedPart.toString());
        //trace(inplacePart.toString());
        //trace(Util.highlightIndices(inplace, [lo, hi], ['[', ']']));
        //trace('useD ins_sort>');
        return;
      }
    
      var diffPivots = partition(a, cmp, lo, hi, out_pivots);
      var i = out_pivots[0];
      var j = out_pivots[1];
      var pivot1 = a[i];
      var pivot2 = a[j];
      
      //trace(sortedPart.toString());
      //trace(inplace.toString());
      var less = i + 1;
      var great = j - 1;
      _sortpart(a, cmp, lo, less - 2, level + 1);
      _sortpart(a, cmp, great + 2, hi, level + 1);
      
      // equal elements
      //trace('<equal');
      //trace(sortedPart.toString());
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [less, great], 'lg'));
      var k:Int = -1;
      if ((great - less > len - DIST_SIZE) && diffPivots) {
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [k, great], 'LlHg'));
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
      //trace(sortedPart.toString());
      //trace(a.toString());
      //trace(inplace.toString());
      //trace(Util.highlightIndices(a, [less,great,k], 'lgk'));
      //trace('equal>');
      
      // center part
      //trace('center');
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [less, great], 'cC'));
      if (diffPivots) {
        _sortpart(a, cmp, less, great, level + 1);
      }
    }
  }
  
  static public function partition<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, out_pivots:Array<Int>):Bool
  {
    
    var len = hi - lo;
    var x:T;
    
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, hi], ['L', 'H']));
    
    
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
    //trace('pivot1:$pivot1 pivot2:$pivot2');
    var k:Int;
    if (diffPivots) {
      k = less;
      //trace(a.toString());
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
            //trace(Util.highlightIndices(a, [less, k, great], 'lkg'));
            great--;
          }
          //trace(a.toString());
          //trace(Util.highlightIndices(a, [less, k, great], 'lkg'));
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
    //trace(Util.highlightIndices(a, [lo, less, hi, great], 'LlHg'));
    a[lo] = a[less - 1];
    a[less - 1] = pivot1;
    a[hi] = a[great + 1];
    a[great + 1] = pivot2;
    
    out_pivots[0] = less - 1;
    out_pivots[1] = great + 1;
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [lo, less, hi, great], 'LlHg'));
    //trace('swap>');
    
    // left and right parts
    //trace('sure kth ${less - 1} ${great + 1}');
    //trace(a.toString());
    //trace(Util.highlightIndices(a, [less - 1, great + 1], '^^'));
    //inplace[less - 1] = pivot1;
    //inplace[great + 1] = pivot2;
    
    return diffPivots;
  }  

  
  inline static public function select<T>(a:Array<T>, cmp:T->T->Int, kth:Int):T
  {
    #if js
    untyped __js__('debugger');
    #end
    return _select(a, cmp, 0, a.length - 1, kth);
  }
  
  static public function _select<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, kth:Int, level = 0):T
  {
    
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    var out_pivots = [0, 0];
    
    if (lo < hi) {
      
      var len = hi - lo;
      var x:T;
      
      if (len < TINY_SIZE) { // insertion sort on tiny array
        //trace('<use ins_sort');
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
        //trace('inplace?');
        //for (i in lo...hi + 1) {
        //  inplaceSel[i] = a[i];
        //}
        //trace(sortedSel.toString());
        //trace(inplace.toString());
        //trace(Util.highlightIndices(inplace, [lo, hi], ['[', ']']));
        //trace('useD ins_sort>');
        //trace('ins_sort');
        return a[kth];
        //return _select(a, cmp, kth, kth - 1, kth, level + 1);
      }
    
      var diffPivots = partition(a, cmp, lo, hi, out_pivots);
      var i = out_pivots[0];
      var j = out_pivots[1];
      var pivot1 = a[i];
      var pivot2 = a[j];
      
      //trace(sortedSel.toString());
      //trace(inplace.toString());
      var less = i + 1;
      var great = j - 1;
      
      var c = Util.sign(kth - i) + Util.sign(kth - j);
      switch (c) 
      {
        case -2: return _select(a, cmp, lo, less - 1, kth, level + 1);
        case -1: return a[i];
        case  0: {};
        case  1: return a[j];
        case  2: return _select(a, cmp, great + 1, hi, kth, level + 1);
        
        default:
          throw "can't be here!";
      }
      
      // equal elements
      //trace('<equal');
      //trace(sortedSel.toString());
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [less, great], 'lg'));
      var k:Int = -1;
      if ((great - less > len - DIST_SIZE) && diffPivots) {
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [k, great], 'LlHg'));
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
      //trace(sortedSel.toString());
      //trace(a.toString());
      //trace(inplace.toString());
      //trace(Util.highlightIndices(a, [less,great,k], 'lgk'));
      //trace('equal>');
      
      // center Sel
      //trace('center');
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [less, great], 'cC'));
      if (diffPivots) {
        return _select(a, cmp, less, great, kth, level + 1);
      }
    }
    
    return a[kth];
  }
  
}