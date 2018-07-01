// check yaro2 with size 120 and SORTED (it seems broken there - don't know why 
// |it seems it's not a SO, more an inf loop or OOB access|)
// INVESTIGATE!
// confirmed, others work with same params!!
// haven't pushed anything since, so there must be a bug in the impl. (mine or the ref one)
// weird thing is it works ok with different/other sizes (than 120)

// UPDATE: it's a SO, just I wasn't reporting stackdepth properly

import haxe.Timer;
import QuickSort;
import haxe.ds.ArraySort;
import hxGeomAlgo.Heap;


@:expose
class TestSort {

  static var kth = 0;
  static var startTime = Timer.stamp();
  static var SIZE = 40;
  static var t0 = Timer.stamp();
  
  static var sortersClass:Array<Class<Dynamic>> = [];
  static var totalTimesBySorter:Array<Float> = [];
  static var sorters:Array<SortFn<Int>> = [];
  
  static var allMetrics:Array<Metrics> = [];
  static var totalDiffTime:Float = 0;
  
  
  inline static function nativeSort<T>(a:Array<T>, cmp:T->T->Int) {
    return a.sort(cmp);
  }
  
  inline static function randomColor() {
    return (Std.random(256) << 24) | (Std.random(256) << 16) | (Std.random(256) << 8) | Std.random(256);
  }
  
  static function initSorters() {
    sortersClass.push(Array);             sorters.push(nativeSort);
    
    sortersClass.push(MergeSort);         sorters.push(MergeSort.sort);
    sortersClass.push(QSort3Med);         sorters.push(QSort3Med.sort);
    sortersClass.push(YaroDualPivot);     sorters.push(YaroDualPivot.sort);
    sortersClass.push(YaroOriginal);      sorters.push(YaroOriginal.sort);
    sortersClass.push(YaroOriginalPart);  sorters.push(YaroOriginalPart.sortpart);
    sortersClass.push(YaroOriginalSwap);  sorters.push(YaroOriginalSwap.sort);
    
    //sortersClass.push(InsertionSort);   sorters.push(InsertionSort.sort);
    
    //sortersClass.push(HeapSort);        sorters.push(HeapSort.sort);
    //sortersClass.push(HeapSort);        sorters.push(HeapSort.sort2);
    
    
    function merge<T>(a:Array<T>, cmp:T -> T -> Int):Void 
    {
      //if (hi - lo + 1 == a.length) {
      //  sort(a, cmp);
      //  return;
      //}
      var lo = 0, hi = a.length - 1;
      var scratch = [for (i in lo...hi+1) a[i]]; // scratch[0] = a[i], ... , scratch[hi-lo] = a[hi], so it might be smaller than a
      
      // this works obviously!
      MergeSort.sort(scratch, cmp);
      for (i in 0...hi - lo + 1) a[lo + i] = scratch[i]; // copy back
    }
    
    //sortersClass.push(MergeSort);       sorters.push(MergeSort.sort3);
    //sortersClass.push(MergeSort);       sorters.push(merge);
    //sortersClass.push(MergeSort);       sorters.push(MergeSort.sort2);
    
    //sortersClass.push(QSort3);          sorters.push(QSort3.sort);
    
/*    sortersClass.push(QSort3Med);  sorters.push(function(a, cmp) {
      QSort3Med.select(a, cmp, kth);
      var sorted = a.copy();
      sorted.sort(cmp);
      if (cmp(a[kth], sorted[kth]) != 0) {
        trace("not kth");
        throw "not kth";
      }
      //trace(sorted.toString());
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [kth], '^'));
    });
*/    
    /*
    sortersClass.push(QuickSort);  sorters.push(function(a, cmp) {
      QuickSort.select(a, cmp, kth);
      //var sorted = a.copy();
      ////sorted.sort(cmp);
      //QuickSort.sort(sorted, cmp);
      //if (cmp(a[kth], sorted[kth]) != 0) {
      //  trace('not $kth-kth');
      //  trace(sorted.toString());
      //  trace(a.toString());
      //  trace(Util.highlightIndices(a, [kth], '^'));
      //  throw "not kth";
      //}
    });
    */
    
    //sortersClass.push(Yaro2);           sorters.push(Yaro2.sort);
    //sortersClass.push(YaroOriginalPart);  sorters.push(YaroOriginalPart.sort);
    
/*    sortersClass.push(YaroOriginalPart);  sorters.push(function(a, cmp) {
      YaroOriginalPart.select(a, cmp, kth);
      var sorted = a.copy();
      sorted.sort(cmp);
      if (cmp(a[kth], sorted[kth]) != 0) {
        trace("not kth");
        throw "not kth";
      }
      //trace(sorted.toString());
      //trace(a.toString());
      //trace(Util.highlightIndices(a, [kth], '^'));
    });
*/    
    
    
    //sortersClass.push(YaroOriginalSwap);sorters.push(YaroOriginalSwap.sort);
    
    //sortersClass.push(Bentley3Way);     sorters.push(Bentley3Way.sort);
    //sortersClass.push(QuickSort);       sorters.push(QuickSort.sort);
    //sortersClass.push(QuickX);          sorters.push(QuickX.sort);
    
    function argsort<T>(a:Array<T>, cmp):Void {
      var copy = a.copy();
      var indices = ArrayArgSort.argsort(a, cmp);
      for (i in 0...indices.length) {
        a[i] = copy[indices[i]];
      }
    };
    function argsort2<T>(a:Array<T>, cmp):Void {
      var indices = ArrayArgSort.argsort(a, cmp);
      for (i in 1...indices.length) {
        var idx = indices[i-1];  
      }
    };
    //sortersClass.push(ArrayArgSort);    sorters.push(argsort2);
    
    //sortersClass.push(ArraySort);       sorters.push(ArraySort.sort);
    
    //sortersClass.push(MidSort);       sorters.push(MidSort.sort);
  }
  
  static public function main()
  {
  #if (debug && cpp)
    Sys.stderr().writeString("PRESS PLAY ON TAPE");
    //Sys.stdin().readLine();
  #end
  
    initSorters();
    
    var SORT_BY = "time";
    var window = generateSequence(SequenceType.SAME, SIZE * SIZE);
    
    var windowClone = [];
    var mid = (SIZE * SIZE) >> 1;
    
    clock();
    trace("CUTOFF     : " + QuickSort.M);
    trace("Yaro CUTOFF: " + YaroDualPivot.CUT_OFF);
    trace("YaroHCUTOFF: " + YaroDualPivot.HALF_CUT_OFF);
    
    for (i in 0...sorters.length) {
      totalTimesBySorter.push(0.0); // init times
    }
    
    var seqTypes = Macros.getValues(SequenceType);
    
    //seqTypes = [SequenceType.SMALL_RANDOM/*, SequenceType.REV_ORGAN_PIPE, SequenceType.SORTED*/];
    //seqTypes = [SequenceType.ALMOST_REV_SORTED];
    
    for (tt in 0...seqTypes.length) {
      var seqType = seqTypes[tt];
      window = generateSequence(seqType, SIZE * SIZE);
      kth = Std.random(window.length);
      
      //var shuffleT0 = Timer.stamp();
      //Util.shuffle(window);
      //trace("shuffleTime: " + (Timer.stamp() - shuffleT0));
      //window = [44, 6, 56, 17, 26, 59, 41, 18, 11, 57, 62, 38, 17, 35, 42, 15, 0, 29, 33, 18, 43, 9, 20, 48, 36];
      
      //trace('[$tt] -------------------------------------');
      var seqInfo = " - SequenceType: " + (seqType:String) + "   LEN: " + (window.length);
      //trace(seqInfo);
      
      if (window.length < 20) {
        trace(window.toString());
      }
      trace("\n");
      
      var sorted = window.copy();
      sorted.sort(icmp.bind());
      var runs = 5;
      for (i in 0...sorters.length) {
        //if (i != 0) continue;
        
        windowClone = window.copy();
        var metrics = runSort(windowClone, sortersClass[i], sorters[i], icmp);
        for (run in 0...runs) {
          windowClone = window.copy();
          var currMetrics = runSort(windowClone, sortersClass[i], sorters[i], icmp);
          metrics.calls += currMetrics.calls;
          metrics.cmpCount += currMetrics.cmpCount;
          metrics.stackDepth += currMetrics.stackDepth;
          metrics.swapCount += currMetrics.swapCount;
          metrics.time += currMetrics.time;
        }
        metrics.calls = Std.int(metrics.calls / runs);
        metrics.cmpCount = Std.int(metrics.cmpCount / runs);
        metrics.stackDepth = Std.int(metrics.stackDepth / runs);
        metrics.swapCount = Std.int(metrics.swapCount / runs);
        metrics.time = (metrics.time / runs);
        
        //try {
          isSorted(sorted, windowClone, icmp, Type.getClassName(sortersClass[i]) + " " + sorters[i] + " on " + seqType);
        //} catch (err:Dynamic)
        //{
        //  trace(sortersClass[i], sorters[i]);
        //  throw err;
        //}
        if (windowClone.length < 30) {
          trace(windowClone.toString());
        }
        
        allMetrics[i] = metrics;
        totalTimesBySorter[i] += metrics.time;
      }
      
    
      trace('[$tt] -----------[METRICS(avg of $runs)]---------- ' + seqInfo);
      
      // a bit harder to follow but
      // don't change `allMetrics` order, just return sorted indices
      // and use them
      var sortedMetricsIndices = ArrayArgSort.argsort(allMetrics, Metrics.cmpBy.bind(SORT_BY));
      var diffTime = allMetrics[sortedMetricsIndices[allMetrics.length - 1]].time - allMetrics[sortedMetricsIndices[0]].time; // diff between slowest and fastest algo
      
      // sort using indices
      var sortedMetrics = [for (i in 0...allMetrics.length) allMetrics[sortedMetricsIndices[i]]];
      
      totalDiffTime += diffTime;
      
      for (m in 0...sortedMetrics.length) {
        var metrics = sortedMetrics[m];
        var pos = StringTools.lpad(Std.string(m), " ", 2);
        trace('$pos. $metrics');
      }
      
      //sortedMetrics[seqType] = allMetrics;
      allMetrics = [];
    }
    
    trace("\n");
    var topListIdx = ArrayArgSort.argsort(totalTimesBySorter, function(a, b) { return a < b ? -1 : a > b ? 1 : 0; });
    for (i in 0...topListIdx.length) {
      var idx = topListIdx[i];
      var pos = StringTools.lpad(Std.string(i), " ", 2);
      trace(pos + ". " + Type.getClassName(sortersClass[idx]), sorters[idx], totalTimesBySorter[idx]);
    }
    
    var totalSortTime = {
      var sum = 0.0;
      for (t in totalTimesBySorter) sum += t;
      sum;
    };
    
    trace("\n");
    trace("Total SORT time   : " + totalSortTime);
    trace("Total ELAPSED time: " + (Timer.stamp() - startTime));
    
    //trace(window.toString());
    //MidSort.sort(window, icmp);
    window = generateSequence(SequenceType.SMALL_RANDOM, 20);
    var lo = 0, hi = window.length - 1;
    trace('unsorted ' + window.toString());
    trace('         ' + Util.highlightIndices(window, [lo, hi], ['L', 'H']));
  #if js
    untyped __js__('debugger');
  #end
    trace('lo $lo hi $hi');
    //MergeSort.sortRange(window, icmp, lo, hi);
    //YaroDualPivot.sort(window, icmp);
    
    
    //trace('sorted ' + window.toString());
    //trace('       ' + Util.highlightIndices(window, [lo, hi], ['L', 'H']));
    //for (i in lo...hi) {
    //  if (icmp(window[i], window[i + 1]) > 0) throw '$i ${i+1} $lo $hi';
    //}
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
  
  //NOTE: for C# to work it needs to be compiled with -D erase-generics
  inline static function runSort<T>(a:Array<T>, cls:Class<Dynamic>, sort:SortFn<T>, cmp:CmpFn<T>) {
    
    t0 = Timer.stamp();
    resetMetrics();
    sort(a, cmp.bind());
    
    //trace(cls, sort);
    
    var metrics:Metrics = {
      time:(haxe.Timer.stamp() - t0),
      cls: Type.getClassName(cls),
    #if js
      sort: untyped __js__("sort.name"),
    #else
      sort: Std.string(sort),
    #end
      cmpCount: cmpCount,
      swapCount: Util.swapCount,
      stackDepth: QuickSort.stackDepth,
      calls: QuickSort.calls,
    };
    
    return metrics;
  }
  
  static public function isSorted<T:Int>(guaranteedSorted:Array<T>, sorted:Array<T>, cmp:T->T->Int, msg)
  {
    var errorMsg = '';
    if (guaranteedSorted.length != sorted.length) {
      errorMsg += 'diff. len: expected:${guaranteedSorted.length} vs actual: ${sorted.length}\n';
    }
    
    if (errorMsg.length == 0) {
      var pair = new Array<T>();
      for (ii in 1...sorted.length) if (cmp(sorted[ii - 1], sorted[ii]) > 0) {
        if (sorted.length < 30) {
          trace(sorted.toString());
          trace(Util.highlightIndices(sorted, [ii - 1, ii], '^^'));
        }
        pair = sorted.slice(ii - 1, ii + 1);
        trace(ii, pair.toString());
        trace([for (j in pair) '0x' + StringTools.hex(j, 8)]);
        errorMsg += "wrong " + msg + "\n";
        break;
      }

      for (ii in 0...guaranteedSorted.length) {
        if (cmp(guaranteedSorted[ii], sorted[ii]) != 0) {
          if (sorted.length < 30) {
            trace(guaranteedSorted.toString());
            trace(Util.highlightIndices(guaranteedSorted, [ii - 1, ii], '^^'));
            trace(sorted.toString());
            trace(Util.highlightIndices(sorted, [ii - 1, ii], '^^'));
          }
          errorMsg += 'diff elements at $ii\n';
          break;
        }
      }
    }
      
    if (errorMsg.length > 0) {
      throw errorMsg;
      return false;
    }
    return true;
  }
  
  public static function toFixed(number:Float, ?precision=2): Float
  {
    number *= Math.pow(10, precision);
    return Math.round(number) / Math.pow(10, precision);
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
      case SMALL_RANDOM:
        arr = [for (i in 0...length) randomColor() & 0x3F];
      case RANDOM:
        arr = [for (i in 0...length) randomColor()];
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
        arr = [for (i in 0...length) length - i - 1];
      case ALMOST_SORTED:
        arr = [for (i in 0...length) i];
        arr[4] = arr[arr.length - 1];
      case ALMOST_REV_SORTED:
        arr = [for (i in 0...length) length - i - 1];
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
  var SMALL_RANDOM = "SMALL_RANDOM";
  var RANDOM = "RANDOM";
  var SAME = "SAME";
  var ORGAN_PIPE = "ORGAN_PIPE";
  var REV_ORGAN_PIPE = "REV_ORGAN_PIPE";
  var ALTERNATE = "ALTERNATE";
  var SORTED = "SORTED";
  var REV_SORTED = "REV_SORTED";
  var ALMOST_SORTED = "ALMOST_SORTED";
  var ALMOST_REV_SORTED = "ALMOST_REV_SORTED";
  var SAW_TOOTH = "SAW_TOOTH";
  var FEW_UNIQUE = "FEW_UNIQUE";
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
    var lengths = [38, 21, 20, 20, 20, 20, 20];
    
    var arr = [
      cls + "," + sort, 
      "ELAPSED: " + TestSort.toFixed((time), 5) + "s", 
      "icmpCount: " + cmpCount,
      "swapCount: " + swapCount, 
      "callCount: " + calls, 
      "stackDepth: " + stackDepth 
    ];
    var str = "";
    for (i in 0...arr.length) {
      var field = Std.string(arr[i]);
      field = StringTools.rpad(field, " ", lengths[i]);
      str += field;
    }
    return str;
  }
}