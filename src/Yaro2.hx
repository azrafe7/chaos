// https://cs.stackexchange.com/questions/24092/dual-pivot-quicksort-reference-implementation

// qselect on dualpivot ref impl.
// http://wwwagak.informatik.uni-kl.de/downloads/papers/Analysis_of_Quickselect_under_Yaroslavskiys_Dual-Pivoting_Algorithm.pdf

class Yaro2 
{

  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    dualsort(a, cmp, 0, a.length - 1);
  }
  
  static public function dualsort<T>(a:Array<T>, cmp:T->T->Int, lo:Int, hi:Int, level = 0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    
    //trace('yaro2 lev:$level');
    
    var stack:Array<Int> = [lo, hi, level];
    
  while (stack.length > 0) {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    lo = stack.shift();
    hi = stack.shift();
    level = stack.shift();

    //while (hi > lo) 
    if (hi > lo) 
    {
      
      // OPT: use insertion sort for small sequences
      if (hi - lo < QuickSort.M) {
        for (i in (lo + 1)...hi + 1) {
          var j = i;
          while (j > lo) {
            if (cmp(a[j], a[j - 1]) < 0)
              Util.swap(a, j - 1, j);
            else
              break;
            j--;
          }
        }
        //return;
      } else {
      
      // Choose outermost elements as pivots
      if (cmp(a[lo], a[hi]) > 0) Util.swap(a, lo, hi);
      var p = a[lo], q = a[hi];

      // Partition a according to invariant below
      var l = lo + 1, g = hi - 1, k = l;
      while (k <= g) {
        if (cmp(a[k], p) < 0) {
          Util.swap(a, k, l);
          ++l;
        } else if (cmp(a[k], q) >= 0) {
          while (cmp(a[g], q) > 0 && k < g) --g;
          Util.swap(a, k, g);
          --g;
          if (cmp(a[k], p) < 0) {
            Util.swap(a, k, l);
            ++l;
          }
        }
        ++k;
      }
      --l; ++g;

      // Swap pivots to final place
      Util.swap(a, lo, l); 
      Util.swap(a, hi, g);

      // Recursively sort partitions
        //dualsort(a, cmp, lo, l - 1, level + 1);
        stack.push(lo); stack.push(l - 1); stack.push(level + 1);
        //dualsort(a, cmp, l + 1, g - 1, level + 1);
        stack.push(l + 1); stack.push(g - 1); stack.push(level + 1);
        //dualsort(a, cmp, g + 1, hi, level + 1);
        stack.push(g + 1); stack.push(hi); stack.push(level + 1);
    }
    }
  }
  }  
}