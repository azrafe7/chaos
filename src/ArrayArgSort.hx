/*
 * Copyright (C)2005-2017 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */


/**
  ArrayArgSort provides a stable implementation of merge sort through its `argsort`
  method. It should be used in cases where the order of equal elements has to be 
  retained on all targets.
**/
class ArrayArgSort {

  /**
    Returns an array of indices that can be used to sort the Array `a` according 
    to the comparison function `cmp`, where `cmp(x,y)` returns 0 if `x == y`, 
    a positive Int if `x > y` and a negative Int if `x < y`.

    This operation modifies Array `sortedIndices` in place (if passed as argument).

    This operation is stable: The order of equal elements is preserved.

    If `a` or `cmp` are null, the result is unspecified.

    Example:
    ```
      function icmp(a:Int, b:Int) return a - b;
      
      var array = [5,8,1,13,2,1,3];
      var sortedIndices = ArrayArgSort.argsort(array, icmp);
      trace(sortedIndices.map(function(idx) return array[idx])); // [1,1,2,3,5,8,13]
    ```
  **/
  static public function argsort<T>(a:Array<T>, cmp:T -> T -> Int, ?sortedIndices:Array<Int>):Array<Int> {
    var len = a.length;
    if (sortedIndices == null) sortedIndices = [];
    for (i in 0...len) sortedIndices[i] = i;
    return rec(a, cmp, 0, len, sortedIndices);
  }

  static function rec<T>(a:Array<T>, cmp, from, to, indices:Array<Int>):Array<Int> {
    var middle = (from + to) >> 1;
    if (to - from < 12) {
      if (to <= from) return indices;
      for (i in (from + 1)...to) {
        var j = i;
        while (j > from) {
          if (Util.indirectCompare(a, cmp, j, j - 1, indices) < 0)
            Util.swap(indices, j - 1, j);
          else
            break;
          j--;
        }
      }
      return indices;
    }
    rec(a, cmp, from, middle, indices);
    rec(a, cmp, middle, to, indices);
    return doMerge(a, cmp, from, middle, to, middle - from, to - middle, indices);
  }

  static function doMerge<T>(a:Array<T>, cmp, from, pivot, to, len1, len2, indices:Array<Int>) {
    var first_cut, second_cut, len11, len22, new_mid;
    if (len1 == 0 || len2 == 0)
      return indices;
    if (len1 + len2 == 2) {
      if (Util.indirectCompare(a, cmp, pivot, from, indices) < 0)
        Util.swap(indices, pivot, from);
      return indices;
    }
    if (len1 > len2) {
      len11 = len1 >> 1;
      first_cut = from + len11;
      second_cut = lower(a, cmp, pivot, to, first_cut, indices);
      len22 = second_cut - pivot;
    } else {
      len22 = len2 >> 1;
      second_cut = pivot + len22;
      first_cut = upper(a, cmp, from, pivot, second_cut, indices);
      len11 = first_cut - from;
    }
    rotateIndices(indices, first_cut, pivot, second_cut);
    new_mid = first_cut + len22;
    doMerge(a, cmp, from, first_cut, new_mid, len11, len22, indices);
    doMerge(a, cmp, new_mid, second_cut, to, len1 - len11, len2 - len22, indices);
    return indices;
  }

  static function rotateIndices(indices:Array<Int>, from, mid, to) {
    var n;
    if (from == mid || mid == to) return;
    n = gcd(to - from, mid - from);
    while (n-- != 0) {
      var val = indices[from + n];
      var shift = mid - from;
      var p1 = from + n, p2 = from + n + shift;
      while (p2 != from + n) {
        indices[p1] = indices[p2];
        p1 = p2;
        if (to - p2 > shift) p2 += shift;
        else p2 = from + (shift - (to - p2));
      }
      indices[p1] = val;
    }
  }

  static function gcd(m, n) {
    while (n != 0) {
      var t = m % n;
      m = n;
      n = t;
    }
    return m;
  }

  static function upper<T>(a:Array<T>, cmp, from, to, val, indices:Array<Int>) {
    var len = to - from, half, mid;
    while (len > 0) {
      half = len >> 1;
      mid = from + half;
      if (Util.indirectCompare(a, cmp, val, mid, indices) < 0)
        len = half;
      else {
        from = mid + 1;
        len = len - half - 1;
      }
    }
    return from;
  }

  static function lower<T>(a:Array<T>, cmp, from, to, val, indices:Array<Int>) {
    var len = to - from, half, mid;
    while (len > 0) {
      half = len >> 1;
      mid = from + half;
      if (Util.indirectCompare(a, cmp, mid, val, indices) < 0) {
        from = mid + 1;
        len = len - half - 1;
      } else
        len = half;
    }
    return from;
  }
}