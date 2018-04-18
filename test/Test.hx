import ArrayArgSort;


class Test {
  static public function main()
  {
    var sortedIndices = [];
    var nums = [5, 3, 1, 2, 0, 1, 17, 5, 4, 3, 2, 1, -6, -666];
    var original = IntID.fromIntArray(nums);
    var copy = IntID.fromIntArray(nums);
    trace('LEN      : ' + original.length);
    trace('ORIGINAL : ' + original);
    trace('COPY     : ' + copy);
    
    original.sort(IntID.compare);
    
    ArrayArgSort.argsort(copy, IntID.compare, sortedIndices);
    trace('INDICES  : ' + sortedIndices);
    trace('COPY     : ' + copy);
    trace('ARRAYSORT: ' + original);
    trace('ARGSORT  : ' + [for (idx in sortedIndices) copy[idx]]);
    trace('ARGSORT2 : ' + [for (idx in ArrayArgSort.argsort(copy, IntID.compare)) copy[idx]]);
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
  static public function compare(a:IntID, b:IntID):Int {
    return a.x - b.x;
  }
  
  static public function fromIntArray(arr:Array<Int>) {
    ID = 0;
    return [for (i in arr) new IntID(i)];
  }
}

