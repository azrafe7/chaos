// http://codeblab.com/wp-content/uploads/2009/09/DualPivotQuicksort.pdf


// a bit too underperformant for organ_pipe inputs (otherwise better than most of others in all situations)
class YaroDualPivot 
{
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    //Util.shuffle(a); // check if needed to make it more stable/predictable, or can be removed
    //trace(Util.sortInfo(a, cmp));
    //Util.shuffle(a);
    dualsort(a, cmp, 0, a.length - 1, 3);
  }

  inline static public var CUT_OFF = 27;
  inline static public var HALF_CUT_OFF = CUT_OFF >> 1;
  
  static public function dualsort<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, div:Int, level = 0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    //while (hi - lo >= 1) {
    //if (hi - lo >= 1) {
    {
      //trace("useless");
      
      var len = hi - lo;
      //trace('len : $len  level: $level');
      //trace(a.toString());
      
    #if js
      //untyped __js__("debugger");
    #end
    
      if (len < CUT_OFF) { // insertion sort for tiny array
        
        //trace("INS_SORT ", len);
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
        
        //for (int i = lo + 1; i <= hi; i++) {
        //trace('$len $lo $hi');
        
        InsertionSort.insertionSort(a, cmp, lo, hi - lo + 1);
        //MergeSort.sortRange(a, cmp, lo, hi);
        
        //for (i in lo...hi) {
        //  if (cmp(a[i], a[i + 1]) > 0) throw '$i ${i+1} $lo $hi';
        //}
        
        //for (i in lo + 1...hi + 1) {
        //  //trace(a.toString());
        //  
        //  //for (int j = i; j > lo && a[j] < a[j - 1]; j--) {
        //  var j = i;
        //  //trace(Util.highlightIndices(a, [i, j], ['i','j']));
        //  while (j > lo && cmp(a[j], a[j - 1]) < 0) {
        //    Util.swap(a, j, j - 1);
        //    j--;
        //  }
        //}
        
        return;
      }
      
      //if (QuickSort.stackDepth > 8) {
      //  MergeSort.sortRange(a, cmp, lo, hi);
      //  return;
      //}
      
      var third = Std.int(len / div);
      
      // "medians"
      var m1 = lo + third;
      var m2 = hi - third;
      
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [m1, m2], ['m','M']));
      
      if (m1 <= lo) {
        m1 = lo + 1;
      }
      if (m2 >= hi) {
        m2 = hi - 1;
      }
      //trace(Util.highlightIndices(a, [m1, m2], ['m','M']));
      
      if (cmp(a[m1], a[m2]) < 0) {
        Util.swap(a, m1, lo);
        Util.swap(a, m2, hi);
      }
      else {
        Util.swap(a, m1, hi);
        Util.swap(a, m2, lo);
      }
      
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [m1, m2], ['m','M']));
      
      // pivots
      var pivot1 = a[lo];
      var pivot2 = a[hi];
      
      // pointers
      var less = lo + 1;
      var great = hi - 1;
      
      //trace(pivot1, pivot2);
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
      //trace(Util.highlightIndices(a, [less, great], ['<','>']));
      
      // sorting
      //for (int k = less; k <= great; k++) {
      var k = less;
      while (k <= great) {
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [k], ['k']));
        //trace(Util.highlightIndices(a, [less, great], ['<','>']));
        
        if (cmp(a[k], pivot1) < 0) {
          Util.swap(a, k, less++);
        } else if (cmp(a[k], pivot2) > 0) {
          while (k < great && cmp(a[great], pivot2) > 0) {
            //trace(Util.highlightIndices(a, [great], ['>']));
            great--;
          }
          //trace(Util.highlightIndices(a, [k, great], ['k', '>']));
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
      //trace(dist);
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [less-1, lo], ['l', 'L']));
      //trace(Util.highlightIndices(a, [great+1, hi], ['g', 'H']));
      Util.swap(a, less - 1, lo);
      Util.swap(a, great + 1, hi);
      
      // subarrays
      //if ((less - 2) - lo > hi - (great + 2)) {
        dualsort(a, cmp, lo, less - 2, div, level + 1);
      //  lo = great + 2;
      //} else {
        dualsort(a, cmp, great + 2, hi, div, level + 1);
      //  hi = less - 2;
      //}

      // equal elements
      //if (dist > len - 13 && pivot1 != pivot2) {
      if (dist > len - HALF_CUT_OFF && pivot1 != pivot2) {
        //for (int k = less; k <= great; k++) {
        k = less;
        
        //if (k < lo) throw '$k $lo';
        
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
}