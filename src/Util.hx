package;

class Util 
{
  static public var swapCount = 0;
	inline static public function swap<T>(a:Array<T>, i:Int, j:Int):Void {
		swapCount++;
    var tmp = a[i];
		a[i] = a[j];
		a[j] = tmp;
	}
  
  inline static public function copy<T>(src:Array<T>, dest:Array<T>, count:Int):Void {
    for (i in 0...count) dest[i] = src[i];
  }
  
  inline static public function compare<T>(a:Array<T>, cmp:T -> T -> Int, i:Int, j:Int):Int {
    return cmp(a[i], a[j]);
  }
  
  inline static public function indirectCompare<T>(a:Array<T>, cmp:T -> T -> Int, i:Int, j:Int, indices:Array<Int>):Int {
    return cmp(a[indices[i]], a[indices[j]]);
  }
}