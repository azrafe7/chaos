import ArrayArgSort;
import haxe.ds.BalancedTree;


class Test {
  static public function main()
  {
    var sortedIndices = [];
    var nums = [5, 3, 1, 2, 0, 1, 17, 5, 4, 3, 2, 1, 0x80000000, 0x80000001, -6];
    var original = IntID.fromIntArray(nums);
    var copy = IntID.fromIntArray(nums);
    trace('LEN      : ' + original.length);
    trace('NUMS     : ' + nums);
    trace('ORIGINAL : ' + original);
    trace('COPY     : ' + copy);
    
    original.sort(IntID.compare);
    
    ArrayArgSort.argsort(copy, IntID.compare, sortedIndices);
    trace('INDICES  : ' + sortedIndices);
    trace('COPY     : ' + copy);
    trace('ARRAYSORT: ' + original);
    trace('ARGSORT  : ' + [for (idx in sortedIndices) copy[idx]]);
    trace('ARGSORT2 : ' + [for (idx in ArrayArgSort.argsort(copy, IntID.compare)) copy[idx]]);
    QuickSort.qsort(copy, IntID.compare, 0, copy.length-1);
    trace('QUICKSORT: ' + copy);
    for (i in 0...copy.length) {
      var arr = IntID.fromIntArray(nums);
      trace(i + 'th: ' + QuickSort.select(arr, IntID.compare, i)); 
    }
    var arr = IntID.fromIntArray(nums);
    var i = nums.length - 1;
    trace(i + 'th: ' + QuickSort.select(arr, IntID.compare, i)); 
    trace('QUICKSEL : ' + arr);
    arr = IntID.fromIntArray(nums);
    InsertionSort.sort(arr, IntID.compare);
    trace('INSSORT : ' + arr);
    
    arr = IntID.fromIntArray(nums);
    HeapSort.sort(arr, IntID.compare);
    trace('HEAPSORT: ' + arr);
    
    arr = IntID.fromIntArray(nums);
    HeapSort.sort2(arr, IntID.compare);
    trace('HEAPSORT: ' + arr);
    
    arr = IntID.fromIntArray(nums);
    MergeSort.sort(arr, IntID.compare);
    trace('MERGESORT: ' + arr);
    
    arr = IntID.fromIntArray(nums);
    MergeSort.sort2(arr, IntID.compare);
    trace('MERGESORT: ' + arr);
    
    arr = IntID.fromIntArray(nums);
    var tree = new IntIDTree();
    for (i in arr) tree.set(i, false);
    var sortedKeys = [for (k in tree.keys()) tree.get(k)];
    trace(sortedKeys);
    
    arr = IntID.fromIntArray(nums);
    var k = 5;
    var ksorted = new IntIDKth(arr.length-1);
    for (i in 0...arr.length) ksorted.push(arr[i]);
    trace(ksorted.data);
  }  
}


class IntID {
  static var ID:Int = 0;
  
  public var id:Int;
  public var x:Int;
  
  public function new(x:Int) {
    this.id = ID++;
    this.x = x;
  }
  
  public function toString()
  {
    return '${x}_$id';
  }
  
  // compare only the `x` field (and not `id`), so we can check that argsort is stable
  inline static function boolToInt(b:Bool):Int {
    return b ? 1 : 0;
  }
  static public function compare(a:IntID, b:IntID):Int {
    //return a.x - b.x;
    return a.x < b.x ? -1 : a.x > b.x ? 1 : 0;
  }
  
  static public function fromIntArray(arr:Array<Int>) {
    ID = 0;
    return [for (i in arr) new IntID(i)];
  }
}

class IntIDTree extends BalancedTree<IntID, Bool> {
  override function compare(a:IntID, b:IntID):Int {
    return IntID.compare(a, b);
  }
}

class KthSortedArray<T> {
  public var get(get,null):Null<T>;
  
  public var data:Array<T>;
  public var sorted:Bool = false;
  public var kth(default, null):Int;
  
  inline public function new(kth:Int) {
    data = [];
    this.kth = kth;
  }
  
  public function compare(a:T, b:T) {
    return Reflect.compare(a, b);
  }
  
  public function push(t:T) {
    if (data.length == 0) {
      data.push(t);
    }
    // add and re-sort only if new value is smaller than last value
    if (compare(t, data[data.length - 1]) < 0) {
      data.push(t);
      InsertionSort.sort(data, compare);
    }
  }
  
  function get_get():Null<T> {
    if (data.length > 0) return data[0];
    else return null;
  }
}

class IntIDKth extends KthSortedArray<IntID> {
  override public function compare(a:IntID, b:IntID) {
    return IntID.compare(a, b);
  }  
}