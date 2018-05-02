// https://www.cs.princeton.edu/~rs/talks/QuicksortIsOptimal.pdf
// Port of Bentley-McIlroy 3-way partitioning from above paper 
//
// (care has been taken to make the port as direct as possible.
//  No speculative optimizations. Only some profiling stuff and renaming.)
//


class Bentley3Way 
{

  static public function assert(cond:Bool, msg = "error")
  {
    if (!cond) throw msg;
  }
  
  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    //Util.shuffle(a); // check if needed to make it more stable/predictable, or can be removed
    qsort(a, cmp, 0, a.length - 1);
  }
  
  // quicksort the subarray a[lo .. hi] using Bentley-McIlroy 3-way partitioning
  static public function qsort<T>(a:Array<T>, cmp:T -> T -> Int, lo:Int, hi:Int, level=0):Void
  {
    QuickSort.stackDepth = level > QuickSort.stackDepth ? level : QuickSort.stackDepth;
    QuickSort.calls++;
    //trace("Level: " + level);
    
    if (lo < hi) {
      
      //trace(a.toString());
      
      // ----------------------------
      // partitioning code
      var i = lo - 1, j = hi, p = lo - 1, q = hi;
      var pivot = a[hi];
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [lo,hi], ['L', '^']));
      
      while (true)
      {
        //trace(Util.highlightIndices(a, [i,j], ['i','j']));
        while (cmp(a[++i], pivot) < 0) {
          //trace(Util.highlightIndices(a, [i], ['i']));
        };
        while (cmp(pivot, a[--j]) < 0) {
          //trace(Util.highlightIndices(a, [j], ['j']));
          if (j == lo) break;
        }
      #if js
        if (a[lo] == pivot) {
          //trace("lo == pivot");
          untyped __js__("debugger");
        }
      #end
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [i,j], ['i','j']));
        //trace(Util.highlightIndices(a, [p,q], ['p','q']));
        if (i >= j) {
          break;
        }
        Util.swap(a, i, j);
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [i,j], ['i','j']));
        //trace(Util.highlightIndices(a, [p,q], ['p','q']));
        
        if (cmp(a[i], pivot) == 0) {
          p++; 
          Util.swap(a, p, i); 
        }
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [p,q], ['p','q']));
        if (cmp(pivot, a[j]) == 0) {
          q--; 
          Util.swap(a, j, q); 
        }
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [p,q], ['p','q']));
      }
      Util.swap(a, i, hi);
      
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [lo, hi], ['L','H']));
      //trace(Util.highlightIndices(a, [i, j], ['i','j']));
      //trace(Util.highlightIndices(a, [p, q], ['p','q']));
      j = i - 1;
      i = i + 1;
      //trace(Util.highlightIndices(a, [i, j], ['i','j']));
      
      var k = lo;
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [k, j, p], ['k','j', 'p']));
      while (k < p /*&& k != j*/) {
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [k, j, p], ['k','j', 'p']));
        Util.swap(a, k, j);
        k++;
        j--;
      }
      
      k = hi - 1;
      //trace(Util.highlightIndices(a, [k, i, q], ['k','i', 'q']));
      while (k > q/* && k != i*/) {
        //trace(a.toString());
        //trace(Util.highlightIndices(a, [k, i, q], ['k','i', 'q']));
        Util.swap(a, i, k);
        k--;
        i++;
      }
      //trace('pivot in place $pivot');
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [i, j], ['i', 'j']));
      
      
      // end of partitioning code
      // ----------------------------
      
      
      qsort(a, cmp, lo, j, level + 1);
      qsort(a, cmp, i, hi, level + 1);
    }
  }
}
