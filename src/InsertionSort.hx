
class InsertionSort 
{

  inline static public function sort<T>(a:Array<T>, cmp:T -> T -> Int):Void
  {
    insertionSort(a, cmp, 0, a.length);
  }
  
  inline static public function insertionSort<T>(a:Array<T>, cmp:T -> T -> Int, start:Int, count:Int):Void
  {
    if (count < 1) return;
    var j = start;
    for (i in start + 1...start + count) {
      j = i;
      while (j > start) {
        if (cmp(a[j], a[j - 1]) < 0)
          Util.swap(a, j - 1, j);
        else
          break;
        j--;
      }
    }
  }  
}