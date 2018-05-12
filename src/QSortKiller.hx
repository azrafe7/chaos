// http://igoro.com/archive/quicksort-killer/
// http://www.cs.dartmouth.edu/~doug/mdmspe.pdf

typedef CmpFn = Int->Int->Int;
typedef SortFn = Array<Int>->CmpFn->Void;

class QSortKiller 
{

  var keys:Map<Int,Int> = new Map();
  var candidate:Int = 0;
  
  var cmp:CmpFn;
  
  public function new(cmp:CmpFn) 
  {
    this.cmp = cmp;
  }
  
  function compare(a:Int, b:Int):Int {
    if (!keys.exists(a) && !keys.exists(b)) {
      var count = Lambda.count(keys);
      if (a == candidate) keys[a] = count;
      else keys[b] = count;
    }
    
    if (!keys.exists(a)) { candidate = a; return -1; }
    if (!keys.exists(b)) { candidate = b; return 1; }
    return cmp(keys[a], keys[b]);
  }
  
  static public function makeBadArray(sort:SortFn, cmp:CmpFn, length:Int):Array<Int>
  {
    var arr = [for (i in 0...length) i];
    var killer = new QSortKiller(cmp);
    sort(arr, killer.compare);
    
    var res = [];
    for (i in 0...length) {
      res[arr[i]] = i;
    }
    
    QuickSort.calls = 0;
    QuickSort.stackDepth = 0;
    Util.swapCount = 0;
    TestSort.cmpCount = 0;
    
    return res;
  }
}