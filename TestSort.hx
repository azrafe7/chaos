import haxe.Constraints.Function;
import haxe.EnumTools;
import haxe.Timer;
import QuickSort;
import haxe.ds.ArraySort;
import hxGeomAlgo.Heap;


@:expose
class TestSort {
  
  static var t0 = Timer.stamp();
  
  static var sortersClass:Array<Class<Dynamic>> = [];
  static var sorters:Array<SortFn<Int>> = [];
  
  static var metrics:Array<Metrics> = [];
  
  
  inline static function nativeSort<T>(a:Array<T>, cmp:T->T->Int) {
    return a.sort(cmp);
  }
  
  inline static function randomColor() {
    return (Std.random(256) << 24) | (Std.random(256) << 16) | (Std.random(256) << 8) | Std.random(256);
  }
  
  static function initSorters() {
    sortersClass.push(Array);           sorters.push(nativeSort);
    
    sortersClass.push(HeapSort);        sorters.push(HeapSort.sort);
    sortersClass.push(HeapSort);        sorters.push(HeapSort.sort2);
    
    sortersClass.push(QSort3);          sorters.push(QSort3.sort);
    sortersClass.push(QSort3Med);       sorters.push(QSort3Med.sort);
    
    sortersClass.push(YaroDualPivot);   sorters.push(YaroDualPivot.sort);
  }
  
  static public function main()
  {
    initSorters();
    
    var SIZE = 114;
    var window = generateSequence(SequenceType.SAME, SIZE * SIZE);
    
    var windowClone = [];
    var mid = (SIZE * SIZE) >> 1;
    
    clock();
    
    var seqTypes = Macros.getValues(SequenceType);
    for (tt in 0...seqTypes.length) {
      var seqType = seqTypes[tt];
      window = generateSequence(seqType, SIZE * SIZE);
      
      //trace('[$tt] -------------------------------------');
      //trace("SequenceType: " + (seqType:String).toUpperCase() + "   LEN: " + (window.length));
      
      if (window.length < 20) {
        trace(window.toString());
      }
      trace("\n");
      
      for (i in 0...sorters.length) {
        //if (i != 0) continue;
        
        windowClone = window.copy();
        runSort(windowClone, sortersClass[i], sorters[i], icmp);
        var sorted = isSorted(windowClone, icmp);
        
        //if (sorted) trace("OK!\n");
        //else trace("\n\n  WRONG!!!\n");
      }
      
    
      trace('[$tt] ------[SORTED METRICS]------');
      trace("SequenceType: " + (seqType:String).toUpperCase() + "   LEN: " + (window.length));
      metrics.sort(Metrics.cmpBy.bind("time"));
      trace(metrics);
      metrics = [];
    }
  }

  static function storeMetrics(m:Metrics)
  {
    metrics.push(m);
  }
  
  static public function printMetrics()
  {
    trace("icmp COUNT: " + cmpCount);
    trace("swap COUNT: " + Util.swapCount);
    trace("call COUNT: " + QuickSort.calls);
    trace("stackDepth: " + QuickSort.stackDepth);
    trace("ELAPSED  : " + (haxe.Timer.stamp() - t0) + "s");
  }
  
  static function clock()
  {
    trace("clock " + (Timer.stamp() - t0) + "\n");
    t0 = Timer.stamp();
  }
  
  static public function resetMetrics()
  {
    cmpCount = 0;
    QuickSort.stackDepth = 0;
    QuickSort.calls = 0;
    Util.swapCount = 0;
  }
  
  inline static function runSort<T>(a:Array<T>, cls:Class<Dynamic>, sort:SortFn<T>, cmp:CmpFn<T>) {
    t0 = Timer.stamp();
    resetMetrics();
    sort(a, cmp.bind());
    
    //trace(cls, sort);
    
    var metrics:Metrics = {
      time:(haxe.Timer.stamp() - t0),
      cls: Std.string(cls),
      sort: Std.string(sort),
      cmpCount: cmpCount,
      swapCount: Util.swapCount,
      stackDepth: QuickSort.stackDepth,
      calls: QuickSort.calls,
    };
    storeMetrics(metrics);
    //printMetrics();
  }
  
  static public function isSorted<T:Int>(window:Array<T>, cmp:T->T->Int)
  {
    for (ii in 1...window.length) if (cmp(window[ii - 1], window[ii]) > 0) {
      window = window.splice(ii - 1, 2);
      trace(ii, window);
      trace([for (j in window) '0x' + StringTools.hex(j, 8)]);
      throw "wrong";
      return false;
    }
    if (window.length < 20) {
      trace(window.toString());
    }
    return true;
  }
  
  inline function sign(x) {
    return x < 0 ? -1 : x > 0 ? 1 : 0;
  }
  
  inline static function boolToInt(b:Bool):Int {
    return b ? 1 : 0;
  }
  
  static public var cmpCount = 0;
  inline static public function icmp(a:Int, b:Int):Int {
    cmpCount++;
    //return a - b; // this may not work correctly (see https://stackoverflow.com/questions/10996418/efficient-integer-compare-function)
    return a < b ? -1 : a > b ? 1 : 0;
    //return (a < b) ? -1 : boolToInt(a > b);
  }
  
  static function generateSequence(type:SequenceType, length:Int) {
    var mid = length >> 1;
    var arr = [];
    switch (type) 
    {
      case RANDOM:
        arr = [for (i in 0...length) randomColor()];
      case SMALL_RANDOM:
        arr = [for (i in 0...length) randomColor() & 0x3F];
      case SAME:
        arr = [for (i in 0...length) 1];
      case ORGAN_PIPE:
        arr = [for (i in 0...length) -Std.int(Math.abs(mid - i))];
      case REV_ORGAN_PIPE:
        arr = [for (i in 0...length) Std.int(Math.abs(i - mid))];
      case ALTERNATE:
        arr = [for (i in 0...length) i % 2];
      case SORTED:
        arr = [for (i in 0...length) i];
      case REV_SORTED:
        arr = [for (i in 0...length) -i];
      case ALMOST_SORTED:
        arr = [for (i in 0...length) i];
        arr[4] = arr[arr.length - 1];
      case ALMOST_REV_SORTED:
        arr = [for (i in 0...length) -i];
        arr[4] = arr[arr.length - 1];
      case SAW_TOOTH:
        arr = [for (i in 0...length) i % 5];
      case FEW_UNIQUE:
        arr = [for (i in 0...length) i % 5];
        Util.shuffle(arr);
      default:
        throw "unsopported";
    }
    return arr;
  }
}


class HeapablePixel implements Heapable<HeapablePixel> {
  public var position:Int;
  
  public var px:Int;
  
  inline public function new(px:Int) {
    this.px = px;
  }
  
  public function compare(other:HeapablePixel):Int
  {
    return -1 * TestSort.icmp(this.px, other.px);
  }
  
  static public function getKth(a:Array<Int>, kth:Int) {
    var heap = new Heap<HeapablePixel>();
    for (i in 0...kth+1) heap.push(new HeapablePixel(a[i]));
    //for (i in 0...kth-1) heap.pop();
    for (i in kth+1...a.length) {
      var tmp = new HeapablePixel(a[i]);
      if (tmp.compare(heap.top()) > 0) {
        heap.pop();
        heap.push(tmp);
      }
    }
    return heap.top().px;
  }
}

typedef CmpFn<T> = T->T->Int;
typedef SortFn<T> = Array<T>->CmpFn<T>->Void;

@:enum abstract SequenceType(String) to String {
  var RANDOM = "random";
  var SMALL_RANDOM = "small random";
  var SAME = "same";
  var ORGAN_PIPE = "organ pipe";
  var REV_ORGAN_PIPE = "rev organ pipe";
  var ALTERNATE = "alternate";
  var SORTED = "sorted";
  var REV_SORTED = "rev sorted";
  var ALMOST_SORTED = "almost sorted";
  var ALMOST_REV_SORTED = "almost rev sorted";
  var SAW_TOOTH = "saw tooth";
  var FEW_UNIQUE = "few unique";
}


@:structInit
@:publicFields
class Metrics {
  var time:Float;
  var cls:String;
  var sort:String;
  var cmpCount:Int;
  var swapCount:Int;
  var stackDepth:Int;
  var calls:Int;
  
  
  public function new(time, cls, sort, cmpCount, swapCount, stackDepth, calls)
  {
    this.time = time;
    this.cls = cls;
    this.sort = sort;
    this.cmpCount = cmpCount;
    this.swapCount = swapCount;
    this.stackDepth = stackDepth;
    this.calls = calls;
  }
  
  static public function cmpBy(fieldName:String, a:Metrics, b:Metrics) {
    return Reflect.compare(Reflect.field(a, fieldName), Reflect.field(b, fieldName));
  }
  
  public function toString():String {
    var lengths = [20, 35, 25, 22, 18, 18, 25];
    
    var arr = [
      cls + "," + sort, 
      "ELAPSED: " + (time) + "s", 
      "icmpCount: " + cmpCount,
      "swapCount: " + swapCount, 
      "callCount: " + calls, 
      "stackDepth: " + stackDepth 
    ];
    var str = "\n";
    for (i in 0...arr.length) {
      var field = Std.string(arr[i]);
      field = StringTools.rpad(field, " ", lengths[i]);
      str += field;
    }
    return str;
  }
}