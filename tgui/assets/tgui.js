require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function (global){
(function (global){
"use strict";

require("core-js/shim");

require("babel-regenerator-runtime");

if (global._babelPolyfill) {
  throw new Error("only one instance of babel-polyfill is allowed");
}
global._babelPolyfill = true;
}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"babel-regenerator-runtime":189,"core-js/shim":188}],2:[function(require,module,exports){
module.exports = function(it){
  if(typeof it != 'function')throw TypeError(it + ' is not a function!');
  return it;
};
},{}],3:[function(require,module,exports){
// 22.1.3.31 Array.prototype[@@unscopables]
var UNSCOPABLES = require('./$.wks')('unscopables')
  , ArrayProto  = Array.prototype;
if(ArrayProto[UNSCOPABLES] == undefined)require('./$.hide')(ArrayProto, UNSCOPABLES, {});
module.exports = function(key){
  ArrayProto[UNSCOPABLES][key] = true;
};
},{"./$.hide":31,"./$.wks":83}],4:[function(require,module,exports){
var isObject = require('./$.is-object');
module.exports = function(it){
  if(!isObject(it))throw TypeError(it + ' is not an object!');
  return it;
};
},{"./$.is-object":38}],5:[function(require,module,exports){
// 22.1.3.3 Array.prototype.copyWithin(target, start, end = this.length)
'use strict';
var toObject = require('./$.to-object')
  , toIndex  = require('./$.to-index')
  , toLength = require('./$.to-length');

module.exports = [].copyWithin || function copyWithin(target/*= 0*/, start/*= 0, end = @length*/){
  var O     = toObject(this)
    , len   = toLength(O.length)
    , to    = toIndex(target, len)
    , from  = toIndex(start, len)
    , $$    = arguments
    , end   = $$.length > 2 ? $$[2] : undefined
    , count = Math.min((end === undefined ? len : toIndex(end, len)) - from, len - to)
    , inc   = 1;
  if(from < to && to < from + count){
    inc  = -1;
    from += count - 1;
    to   += count - 1;
  }
  while(count-- > 0){
    if(from in O)O[to] = O[from];
    else delete O[to];
    to   += inc;
    from += inc;
  } return O;
};
},{"./$.to-index":76,"./$.to-length":79,"./$.to-object":80}],6:[function(require,module,exports){
// 22.1.3.6 Array.prototype.fill(value, start = 0, end = this.length)
'use strict';
var toObject = require('./$.to-object')
  , toIndex  = require('./$.to-index')
  , toLength = require('./$.to-length');
module.exports = [].fill || function fill(value /*, start = 0, end = @length */){
  var O      = toObject(this)
    , length = toLength(O.length)
    , $$     = arguments
    , $$len  = $$.length
    , index  = toIndex($$len > 1 ? $$[1] : undefined, length)
    , end    = $$len > 2 ? $$[2] : undefined
    , endPos = end === undefined ? length : toIndex(end, length);
  while(endPos > index)O[index++] = value;
  return O;
};
},{"./$.to-index":76,"./$.to-length":79,"./$.to-object":80}],7:[function(require,module,exports){
// false -> Array#indexOf
// true  -> Array#includes
var toIObject = require('./$.to-iobject')
  , toLength  = require('./$.to-length')
  , toIndex   = require('./$.to-index');
module.exports = function(IS_INCLUDES){
  return function($this, el, fromIndex){
    var O      = toIObject($this)
      , length = toLength(O.length)
      , index  = toIndex(fromIndex, length)
      , value;
    // Array#includes uses SameValueZero equality algorithm
    if(IS_INCLUDES && el != el)while(length > index){
      value = O[index++];
      if(value != value)return true;
    // Array#toIndex ignores holes, Array#includes - not
    } else for(;length > index; index++)if(IS_INCLUDES || index in O){
      if(O[index] === el)return IS_INCLUDES || index;
    } return !IS_INCLUDES && -1;
  };
};
},{"./$.to-index":76,"./$.to-iobject":78,"./$.to-length":79}],8:[function(require,module,exports){
// 0 -> Array#forEach
// 1 -> Array#map
// 2 -> Array#filter
// 3 -> Array#some
// 4 -> Array#every
// 5 -> Array#find
// 6 -> Array#findIndex
var ctx      = require('./$.ctx')
  , IObject  = require('./$.iobject')
  , toObject = require('./$.to-object')
  , toLength = require('./$.to-length')
  , asc      = require('./$.array-species-create');
module.exports = function(TYPE){
  var IS_MAP        = TYPE == 1
    , IS_FILTER     = TYPE == 2
    , IS_SOME       = TYPE == 3
    , IS_EVERY      = TYPE == 4
    , IS_FIND_INDEX = TYPE == 6
    , NO_HOLES      = TYPE == 5 || IS_FIND_INDEX;
  return function($this, callbackfn, that){
    var O      = toObject($this)
      , self   = IObject(O)
      , f      = ctx(callbackfn, that, 3)
      , length = toLength(self.length)
      , index  = 0
      , result = IS_MAP ? asc($this, length) : IS_FILTER ? asc($this, 0) : undefined
      , val, res;
    for(;length > index; index++)if(NO_HOLES || index in self){
      val = self[index];
      res = f(val, index, O);
      if(TYPE){
        if(IS_MAP)result[index] = res;            // map
        else if(res)switch(TYPE){
          case 3: return true;                    // some
          case 5: return val;                     // find
          case 6: return index;                   // findIndex
          case 2: result.push(val);               // filter
        } else if(IS_EVERY)return false;          // every
      }
    }
    return IS_FIND_INDEX ? -1 : IS_SOME || IS_EVERY ? IS_EVERY : result;
  };
};
},{"./$.array-species-create":9,"./$.ctx":17,"./$.iobject":34,"./$.to-length":79,"./$.to-object":80}],9:[function(require,module,exports){
// 9.4.2.3 ArraySpeciesCreate(originalArray, length)
var isObject = require('./$.is-object')
  , isArray  = require('./$.is-array')
  , SPECIES  = require('./$.wks')('species');
module.exports = function(original, length){
  var C;
  if(isArray(original)){
    C = original.constructor;
    // cross-realm fallback
    if(typeof C == 'function' && (C === Array || isArray(C.prototype)))C = undefined;
    if(isObject(C)){
      C = C[SPECIES];
      if(C === null)C = undefined;
    }
  } return new (C === undefined ? Array : C)(length);
};
},{"./$.is-array":36,"./$.is-object":38,"./$.wks":83}],10:[function(require,module,exports){
// getting tag from 19.1.3.6 Object.prototype.toString()
var cof = require('./$.cof')
  , TAG = require('./$.wks')('toStringTag')
  // ES3 wrong here
  , ARG = cof(function(){ return arguments; }()) == 'Arguments';

module.exports = function(it){
  var O, T, B;
  return it === undefined ? 'Undefined' : it === null ? 'Null'
    // @@toStringTag case
    : typeof (T = (O = Object(it))[TAG]) == 'string' ? T
    // builtinTag case
    : ARG ? cof(O)
    // ES3 arguments fallback
    : (B = cof(O)) == 'Object' && typeof O.callee == 'function' ? 'Arguments' : B;
};
},{"./$.cof":11,"./$.wks":83}],11:[function(require,module,exports){
var toString = {}.toString;

module.exports = function(it){
  return toString.call(it).slice(8, -1);
};
},{}],12:[function(require,module,exports){
'use strict';
var $            = require('./$')
  , hide         = require('./$.hide')
  , redefineAll  = require('./$.redefine-all')
  , ctx          = require('./$.ctx')
  , strictNew    = require('./$.strict-new')
  , defined      = require('./$.defined')
  , forOf        = require('./$.for-of')
  , $iterDefine  = require('./$.iter-define')
  , step         = require('./$.iter-step')
  , ID           = require('./$.uid')('id')
  , $has         = require('./$.has')
  , isObject     = require('./$.is-object')
  , setSpecies   = require('./$.set-species')
  , DESCRIPTORS  = require('./$.descriptors')
  , isExtensible = Object.isExtensible || isObject
  , SIZE         = DESCRIPTORS ? '_s' : 'size'
  , id           = 0;

var fastKey = function(it, create){
  // return primitive with prefix
  if(!isObject(it))return typeof it == 'symbol' ? it : (typeof it == 'string' ? 'S' : 'P') + it;
  if(!$has(it, ID)){
    // can't set id to frozen object
    if(!isExtensible(it))return 'F';
    // not necessary to add id
    if(!create)return 'E';
    // add missing object id
    hide(it, ID, ++id);
  // return object id with prefix
  } return 'O' + it[ID];
};

var getEntry = function(that, key){
  // fast case
  var index = fastKey(key), entry;
  if(index !== 'F')return that._i[index];
  // frozen object case
  for(entry = that._f; entry; entry = entry.n){
    if(entry.k == key)return entry;
  }
};

module.exports = {
  getConstructor: function(wrapper, NAME, IS_MAP, ADDER){
    var C = wrapper(function(that, iterable){
      strictNew(that, C, NAME);
      that._i = $.create(null); // index
      that._f = undefined;      // first entry
      that._l = undefined;      // last entry
      that[SIZE] = 0;           // size
      if(iterable != undefined)forOf(iterable, IS_MAP, that[ADDER], that);
    });
    redefineAll(C.prototype, {
      // 23.1.3.1 Map.prototype.clear()
      // 23.2.3.2 Set.prototype.clear()
      clear: function clear(){
        for(var that = this, data = that._i, entry = that._f; entry; entry = entry.n){
          entry.r = true;
          if(entry.p)entry.p = entry.p.n = undefined;
          delete data[entry.i];
        }
        that._f = that._l = undefined;
        that[SIZE] = 0;
      },
      // 23.1.3.3 Map.prototype.delete(key)
      // 23.2.3.4 Set.prototype.delete(value)
      'delete': function(key){
        var that  = this
          , entry = getEntry(that, key);
        if(entry){
          var next = entry.n
            , prev = entry.p;
          delete that._i[entry.i];
          entry.r = true;
          if(prev)prev.n = next;
          if(next)next.p = prev;
          if(that._f == entry)that._f = next;
          if(that._l == entry)that._l = prev;
          that[SIZE]--;
        } return !!entry;
      },
      // 23.2.3.6 Set.prototype.forEach(callbackfn, thisArg = undefined)
      // 23.1.3.5 Map.prototype.forEach(callbackfn, thisArg = undefined)
      forEach: function forEach(callbackfn /*, that = undefined */){
        var f = ctx(callbackfn, arguments.length > 1 ? arguments[1] : undefined, 3)
          , entry;
        while(entry = entry ? entry.n : this._f){
          f(entry.v, entry.k, this);
          // revert to the last existing entry
          while(entry && entry.r)entry = entry.p;
        }
      },
      // 23.1.3.7 Map.prototype.has(key)
      // 23.2.3.7 Set.prototype.has(value)
      has: function has(key){
        return !!getEntry(this, key);
      }
    });
    if(DESCRIPTORS)$.setDesc(C.prototype, 'size', {
      get: function(){
        return defined(this[SIZE]);
      }
    });
    return C;
  },
  def: function(that, key, value){
    var entry = getEntry(that, key)
      , prev, index;
    // change existing entry
    if(entry){
      entry.v = value;
    // create new entry
    } else {
      that._l = entry = {
        i: index = fastKey(key, true), // <- index
        k: key,                        // <- key
        v: value,                      // <- value
        p: prev = that._l,             // <- previous entry
        n: undefined,                  // <- next entry
        r: false                       // <- removed
      };
      if(!that._f)that._f = entry;
      if(prev)prev.n = entry;
      that[SIZE]++;
      // add to index
      if(index !== 'F')that._i[index] = entry;
    } return that;
  },
  getEntry: getEntry,
  setStrong: function(C, NAME, IS_MAP){
    // add .keys, .values, .entries, [@@iterator]
    // 23.1.3.4, 23.1.3.8, 23.1.3.11, 23.1.3.12, 23.2.3.5, 23.2.3.8, 23.2.3.10, 23.2.3.11
    $iterDefine(C, NAME, function(iterated, kind){
      this._t = iterated;  // target
      this._k = kind;      // kind
      this._l = undefined; // previous
    }, function(){
      var that  = this
        , kind  = that._k
        , entry = that._l;
      // revert to the last existing entry
      while(entry && entry.r)entry = entry.p;
      // get next entry
      if(!that._t || !(that._l = entry = entry ? entry.n : that._t._f)){
        // or finish the iteration
        that._t = undefined;
        return step(1);
      }
      // return step by kind
      if(kind == 'keys'  )return step(0, entry.k);
      if(kind == 'values')return step(0, entry.v);
      return step(0, [entry.k, entry.v]);
    }, IS_MAP ? 'entries' : 'values' , !IS_MAP, true);

    // add [@@species], 23.1.2.2, 23.2.2.2
    setSpecies(NAME);
  }
};
},{"./$":46,"./$.ctx":17,"./$.defined":18,"./$.descriptors":19,"./$.for-of":27,"./$.has":30,"./$.hide":31,"./$.is-object":38,"./$.iter-define":42,"./$.iter-step":44,"./$.redefine-all":60,"./$.set-species":65,"./$.strict-new":69,"./$.uid":82}],13:[function(require,module,exports){
// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var forOf   = require('./$.for-of')
  , classof = require('./$.classof');
module.exports = function(NAME){
  return function toJSON(){
    if(classof(this) != NAME)throw TypeError(NAME + "#toJSON isn't generic");
    var arr = [];
    forOf(this, false, arr.push, arr);
    return arr;
  };
};
},{"./$.classof":10,"./$.for-of":27}],14:[function(require,module,exports){
'use strict';
var hide              = require('./$.hide')
  , redefineAll       = require('./$.redefine-all')
  , anObject          = require('./$.an-object')
  , isObject          = require('./$.is-object')
  , strictNew         = require('./$.strict-new')
  , forOf             = require('./$.for-of')
  , createArrayMethod = require('./$.array-methods')
  , $has              = require('./$.has')
  , WEAK              = require('./$.uid')('weak')
  , isExtensible      = Object.isExtensible || isObject
  , arrayFind         = createArrayMethod(5)
  , arrayFindIndex    = createArrayMethod(6)
  , id                = 0;

// fallback for frozen keys
var frozenStore = function(that){
  return that._l || (that._l = new FrozenStore);
};
var FrozenStore = function(){
  this.a = [];
};
var findFrozen = function(store, key){
  return arrayFind(store.a, function(it){
    return it[0] === key;
  });
};
FrozenStore.prototype = {
  get: function(key){
    var entry = findFrozen(this, key);
    if(entry)return entry[1];
  },
  has: function(key){
    return !!findFrozen(this, key);
  },
  set: function(key, value){
    var entry = findFrozen(this, key);
    if(entry)entry[1] = value;
    else this.a.push([key, value]);
  },
  'delete': function(key){
    var index = arrayFindIndex(this.a, function(it){
      return it[0] === key;
    });
    if(~index)this.a.splice(index, 1);
    return !!~index;
  }
};

module.exports = {
  getConstructor: function(wrapper, NAME, IS_MAP, ADDER){
    var C = wrapper(function(that, iterable){
      strictNew(that, C, NAME);
      that._i = id++;      // collection id
      that._l = undefined; // leak store for frozen objects
      if(iterable != undefined)forOf(iterable, IS_MAP, that[ADDER], that);
    });
    redefineAll(C.prototype, {
      // 23.3.3.2 WeakMap.prototype.delete(key)
      // 23.4.3.3 WeakSet.prototype.delete(value)
      'delete': function(key){
        if(!isObject(key))return false;
        if(!isExtensible(key))return frozenStore(this)['delete'](key);
        return $has(key, WEAK) && $has(key[WEAK], this._i) && delete key[WEAK][this._i];
      },
      // 23.3.3.4 WeakMap.prototype.has(key)
      // 23.4.3.4 WeakSet.prototype.has(value)
      has: function has(key){
        if(!isObject(key))return false;
        if(!isExtensible(key))return frozenStore(this).has(key);
        return $has(key, WEAK) && $has(key[WEAK], this._i);
      }
    });
    return C;
  },
  def: function(that, key, value){
    if(!isExtensible(anObject(key))){
      frozenStore(that).set(key, value);
    } else {
      $has(key, WEAK) || hide(key, WEAK, {});
      key[WEAK][that._i] = value;
    } return that;
  },
  frozenStore: frozenStore,
  WEAK: WEAK
};
},{"./$.an-object":4,"./$.array-methods":8,"./$.for-of":27,"./$.has":30,"./$.hide":31,"./$.is-object":38,"./$.redefine-all":60,"./$.strict-new":69,"./$.uid":82}],15:[function(require,module,exports){
'use strict';
var global         = require('./$.global')
  , $export        = require('./$.export')
  , redefine       = require('./$.redefine')
  , redefineAll    = require('./$.redefine-all')
  , forOf          = require('./$.for-of')
  , strictNew      = require('./$.strict-new')
  , isObject       = require('./$.is-object')
  , fails          = require('./$.fails')
  , $iterDetect    = require('./$.iter-detect')
  , setToStringTag = require('./$.set-to-string-tag');

module.exports = function(NAME, wrapper, methods, common, IS_MAP, IS_WEAK){
  var Base  = global[NAME]
    , C     = Base
    , ADDER = IS_MAP ? 'set' : 'add'
    , proto = C && C.prototype
    , O     = {};
  var fixMethod = function(KEY){
    var fn = proto[KEY];
    redefine(proto, KEY,
      KEY == 'delete' ? function(a){
        return IS_WEAK && !isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
      } : KEY == 'has' ? function has(a){
        return IS_WEAK && !isObject(a) ? false : fn.call(this, a === 0 ? 0 : a);
      } : KEY == 'get' ? function get(a){
        return IS_WEAK && !isObject(a) ? undefined : fn.call(this, a === 0 ? 0 : a);
      } : KEY == 'add' ? function add(a){ fn.call(this, a === 0 ? 0 : a); return this; }
        : function set(a, b){ fn.call(this, a === 0 ? 0 : a, b); return this; }
    );
  };
  if(typeof C != 'function' || !(IS_WEAK || proto.forEach && !fails(function(){
    new C().entries().next();
  }))){
    // create collection constructor
    C = common.getConstructor(wrapper, NAME, IS_MAP, ADDER);
    redefineAll(C.prototype, methods);
  } else {
    var instance             = new C
      // early implementations not supports chaining
      , HASNT_CHAINING       = instance[ADDER](IS_WEAK ? {} : -0, 1) != instance
      // V8 ~  Chromium 40- weak-collections throws on primitives, but should return false
      , THROWS_ON_PRIMITIVES = fails(function(){ instance.has(1); })
      // most early implementations doesn't supports iterables, most modern - not close it correctly
      , ACCEPT_ITERABLES     = $iterDetect(function(iter){ new C(iter); }) // eslint-disable-line no-new
      // for early implementations -0 and +0 not the same
      , BUGGY_ZERO;
    if(!ACCEPT_ITERABLES){ 
      C = wrapper(function(target, iterable){
        strictNew(target, C, NAME);
        var that = new Base;
        if(iterable != undefined)forOf(iterable, IS_MAP, that[ADDER], that);
        return that;
      });
      C.prototype = proto;
      proto.constructor = C;
    }
    IS_WEAK || instance.forEach(function(val, key){
      BUGGY_ZERO = 1 / key === -Infinity;
    });
    if(THROWS_ON_PRIMITIVES || BUGGY_ZERO){
      fixMethod('delete');
      fixMethod('has');
      IS_MAP && fixMethod('get');
    }
    if(BUGGY_ZERO || HASNT_CHAINING)fixMethod(ADDER);
    // weak collections should not contains .clear method
    if(IS_WEAK && proto.clear)delete proto.clear;
  }

  setToStringTag(C, NAME);

  O[NAME] = C;
  $export($export.G + $export.W + $export.F * (C != Base), O);

  if(!IS_WEAK)common.setStrong(C, NAME, IS_MAP);

  return C;
};
},{"./$.export":22,"./$.fails":24,"./$.for-of":27,"./$.global":29,"./$.is-object":38,"./$.iter-detect":43,"./$.redefine":61,"./$.redefine-all":60,"./$.set-to-string-tag":66,"./$.strict-new":69}],16:[function(require,module,exports){
var core = module.exports = {version: '1.2.6'};
if(typeof __e == 'number')__e = core; // eslint-disable-line no-undef
},{}],17:[function(require,module,exports){
// optional / simple context binding
var aFunction = require('./$.a-function');
module.exports = function(fn, that, length){
  aFunction(fn);
  if(that === undefined)return fn;
  switch(length){
    case 1: return function(a){
      return fn.call(that, a);
    };
    case 2: return function(a, b){
      return fn.call(that, a, b);
    };
    case 3: return function(a, b, c){
      return fn.call(that, a, b, c);
    };
  }
  return function(/* ...args */){
    return fn.apply(that, arguments);
  };
};
},{"./$.a-function":2}],18:[function(require,module,exports){
// 7.2.1 RequireObjectCoercible(argument)
module.exports = function(it){
  if(it == undefined)throw TypeError("Can't call method on  " + it);
  return it;
};
},{}],19:[function(require,module,exports){
// Thank's IE8 for his funny defineProperty
module.exports = !require('./$.fails')(function(){
  return Object.defineProperty({}, 'a', {get: function(){ return 7; }}).a != 7;
});
},{"./$.fails":24}],20:[function(require,module,exports){
var isObject = require('./$.is-object')
  , document = require('./$.global').document
  // in old IE typeof document.createElement is 'object'
  , is = isObject(document) && isObject(document.createElement);
module.exports = function(it){
  return is ? document.createElement(it) : {};
};
},{"./$.global":29,"./$.is-object":38}],21:[function(require,module,exports){
// all enumerable object keys, includes symbols
var $ = require('./$');
module.exports = function(it){
  var keys       = $.getKeys(it)
    , getSymbols = $.getSymbols;
  if(getSymbols){
    var symbols = getSymbols(it)
      , isEnum  = $.isEnum
      , i       = 0
      , key;
    while(symbols.length > i)if(isEnum.call(it, key = symbols[i++]))keys.push(key);
  }
  return keys;
};
},{"./$":46}],22:[function(require,module,exports){
var global    = require('./$.global')
  , core      = require('./$.core')
  , hide      = require('./$.hide')
  , redefine  = require('./$.redefine')
  , ctx       = require('./$.ctx')
  , PROTOTYPE = 'prototype';

var $export = function(type, name, source){
  var IS_FORCED = type & $export.F
    , IS_GLOBAL = type & $export.G
    , IS_STATIC = type & $export.S
    , IS_PROTO  = type & $export.P
    , IS_BIND   = type & $export.B
    , target    = IS_GLOBAL ? global : IS_STATIC ? global[name] || (global[name] = {}) : (global[name] || {})[PROTOTYPE]
    , exports   = IS_GLOBAL ? core : core[name] || (core[name] = {})
    , expProto  = exports[PROTOTYPE] || (exports[PROTOTYPE] = {})
    , key, own, out, exp;
  if(IS_GLOBAL)source = name;
  for(key in source){
    // contains in native
    own = !IS_FORCED && target && key in target;
    // export native or passed
    out = (own ? target : source)[key];
    // bind timers to global for call from export context
    exp = IS_BIND && own ? ctx(out, global) : IS_PROTO && typeof out == 'function' ? ctx(Function.call, out) : out;
    // extend global
    if(target && !own)redefine(target, key, out);
    // export
    if(exports[key] != out)hide(exports, key, exp);
    if(IS_PROTO && expProto[key] != out)expProto[key] = out;
  }
};
global.core = core;
// type bitmap
$export.F = 1;  // forced
$export.G = 2;  // global
$export.S = 4;  // static
$export.P = 8;  // proto
$export.B = 16; // bind
$export.W = 32; // wrap
module.exports = $export;
},{"./$.core":16,"./$.ctx":17,"./$.global":29,"./$.hide":31,"./$.redefine":61}],23:[function(require,module,exports){
var MATCH = require('./$.wks')('match');
module.exports = function(KEY){
  var re = /./;
  try {
    '/./'[KEY](re);
  } catch(e){
    try {
      re[MATCH] = false;
      return !'/./'[KEY](re);
    } catch(f){ /* empty */ }
  } return true;
};
},{"./$.wks":83}],24:[function(require,module,exports){
module.exports = function(exec){
  try {
    return !!exec();
  } catch(e){
    return true;
  }
};
},{}],25:[function(require,module,exports){
'use strict';
var hide     = require('./$.hide')
  , redefine = require('./$.redefine')
  , fails    = require('./$.fails')
  , defined  = require('./$.defined')
  , wks      = require('./$.wks');

module.exports = function(KEY, length, exec){
  var SYMBOL   = wks(KEY)
    , original = ''[KEY];
  if(fails(function(){
    var O = {};
    O[SYMBOL] = function(){ return 7; };
    return ''[KEY](O) != 7;
  })){
    redefine(String.prototype, KEY, exec(defined, SYMBOL, original));
    hide(RegExp.prototype, SYMBOL, length == 2
      // 21.2.5.8 RegExp.prototype[@@replace](string, replaceValue)
      // 21.2.5.11 RegExp.prototype[@@split](string, limit)
      ? function(string, arg){ return original.call(string, this, arg); }
      // 21.2.5.6 RegExp.prototype[@@match](string)
      // 21.2.5.9 RegExp.prototype[@@search](string)
      : function(string){ return original.call(string, this); }
    );
  }
};
},{"./$.defined":18,"./$.fails":24,"./$.hide":31,"./$.redefine":61,"./$.wks":83}],26:[function(require,module,exports){
'use strict';
// 21.2.5.3 get RegExp.prototype.flags
var anObject = require('./$.an-object');
module.exports = function(){
  var that   = anObject(this)
    , result = '';
  if(that.global)     result += 'g';
  if(that.ignoreCase) result += 'i';
  if(that.multiline)  result += 'm';
  if(that.unicode)    result += 'u';
  if(that.sticky)     result += 'y';
  return result;
};
},{"./$.an-object":4}],27:[function(require,module,exports){
var ctx         = require('./$.ctx')
  , call        = require('./$.iter-call')
  , isArrayIter = require('./$.is-array-iter')
  , anObject    = require('./$.an-object')
  , toLength    = require('./$.to-length')
  , getIterFn   = require('./core.get-iterator-method');
module.exports = function(iterable, entries, fn, that){
  var iterFn = getIterFn(iterable)
    , f      = ctx(fn, that, entries ? 2 : 1)
    , index  = 0
    , length, step, iterator;
  if(typeof iterFn != 'function')throw TypeError(iterable + ' is not iterable!');
  // fast case for arrays with default iterator
  if(isArrayIter(iterFn))for(length = toLength(iterable.length); length > index; index++){
    entries ? f(anObject(step = iterable[index])[0], step[1]) : f(iterable[index]);
  } else for(iterator = iterFn.call(iterable); !(step = iterator.next()).done; ){
    call(iterator, f, step.value, entries);
  }
};
},{"./$.an-object":4,"./$.ctx":17,"./$.is-array-iter":35,"./$.iter-call":40,"./$.to-length":79,"./core.get-iterator-method":84}],28:[function(require,module,exports){
// fallback for IE11 buggy Object.getOwnPropertyNames with iframe and window
var toIObject = require('./$.to-iobject')
  , getNames  = require('./$').getNames
  , toString  = {}.toString;

var windowNames = typeof window == 'object' && Object.getOwnPropertyNames
  ? Object.getOwnPropertyNames(window) : [];

var getWindowNames = function(it){
  try {
    return getNames(it);
  } catch(e){
    return windowNames.slice();
  }
};

module.exports.get = function getOwnPropertyNames(it){
  if(windowNames && toString.call(it) == '[object Window]')return getWindowNames(it);
  return getNames(toIObject(it));
};
},{"./$":46,"./$.to-iobject":78}],29:[function(require,module,exports){
// https://github.com/zloirock/core-js/issues/86#issuecomment-115759028
var global = module.exports = typeof window != 'undefined' && window.Math == Math
  ? window : typeof self != 'undefined' && self.Math == Math ? self : Function('return this')();
if(typeof __g == 'number')__g = global; // eslint-disable-line no-undef
},{}],30:[function(require,module,exports){
var hasOwnProperty = {}.hasOwnProperty;
module.exports = function(it, key){
  return hasOwnProperty.call(it, key);
};
},{}],31:[function(require,module,exports){
var $          = require('./$')
  , createDesc = require('./$.property-desc');
module.exports = require('./$.descriptors') ? function(object, key, value){
  return $.setDesc(object, key, createDesc(1, value));
} : function(object, key, value){
  object[key] = value;
  return object;
};
},{"./$":46,"./$.descriptors":19,"./$.property-desc":59}],32:[function(require,module,exports){
module.exports = require('./$.global').document && document.documentElement;
},{"./$.global":29}],33:[function(require,module,exports){
// fast apply, http://jsperf.lnkit.com/fast-apply/5
module.exports = function(fn, args, that){
  var un = that === undefined;
  switch(args.length){
    case 0: return un ? fn()
                      : fn.call(that);
    case 1: return un ? fn(args[0])
                      : fn.call(that, args[0]);
    case 2: return un ? fn(args[0], args[1])
                      : fn.call(that, args[0], args[1]);
    case 3: return un ? fn(args[0], args[1], args[2])
                      : fn.call(that, args[0], args[1], args[2]);
    case 4: return un ? fn(args[0], args[1], args[2], args[3])
                      : fn.call(that, args[0], args[1], args[2], args[3]);
  } return              fn.apply(that, args);
};
},{}],34:[function(require,module,exports){
// fallback for non-array-like ES3 and non-enumerable old V8 strings
var cof = require('./$.cof');
module.exports = Object('z').propertyIsEnumerable(0) ? Object : function(it){
  return cof(it) == 'String' ? it.split('') : Object(it);
};
},{"./$.cof":11}],35:[function(require,module,exports){
// check on default Array iterator
var Iterators  = require('./$.iterators')
  , ITERATOR   = require('./$.wks')('iterator')
  , ArrayProto = Array.prototype;

module.exports = function(it){
  return it !== undefined && (Iterators.Array === it || ArrayProto[ITERATOR] === it);
};
},{"./$.iterators":45,"./$.wks":83}],36:[function(require,module,exports){
// 7.2.2 IsArray(argument)
var cof = require('./$.cof');
module.exports = Array.isArray || function(arg){
  return cof(arg) == 'Array';
};
},{"./$.cof":11}],37:[function(require,module,exports){
// 20.1.2.3 Number.isInteger(number)
var isObject = require('./$.is-object')
  , floor    = Math.floor;
module.exports = function isInteger(it){
  return !isObject(it) && isFinite(it) && floor(it) === it;
};
},{"./$.is-object":38}],38:[function(require,module,exports){
module.exports = function(it){
  return typeof it === 'object' ? it !== null : typeof it === 'function';
};
},{}],39:[function(require,module,exports){
// 7.2.8 IsRegExp(argument)
var isObject = require('./$.is-object')
  , cof      = require('./$.cof')
  , MATCH    = require('./$.wks')('match');
module.exports = function(it){
  var isRegExp;
  return isObject(it) && ((isRegExp = it[MATCH]) !== undefined ? !!isRegExp : cof(it) == 'RegExp');
};
},{"./$.cof":11,"./$.is-object":38,"./$.wks":83}],40:[function(require,module,exports){
// call something on iterator step with safe closing on error
var anObject = require('./$.an-object');
module.exports = function(iterator, fn, value, entries){
  try {
    return entries ? fn(anObject(value)[0], value[1]) : fn(value);
  // 7.4.6 IteratorClose(iterator, completion)
  } catch(e){
    var ret = iterator['return'];
    if(ret !== undefined)anObject(ret.call(iterator));
    throw e;
  }
};
},{"./$.an-object":4}],41:[function(require,module,exports){
'use strict';
var $              = require('./$')
  , descriptor     = require('./$.property-desc')
  , setToStringTag = require('./$.set-to-string-tag')
  , IteratorPrototype = {};

// 25.1.2.1.1 %IteratorPrototype%[@@iterator]()
require('./$.hide')(IteratorPrototype, require('./$.wks')('iterator'), function(){ return this; });

module.exports = function(Constructor, NAME, next){
  Constructor.prototype = $.create(IteratorPrototype, {next: descriptor(1, next)});
  setToStringTag(Constructor, NAME + ' Iterator');
};
},{"./$":46,"./$.hide":31,"./$.property-desc":59,"./$.set-to-string-tag":66,"./$.wks":83}],42:[function(require,module,exports){
'use strict';
var LIBRARY        = require('./$.library')
  , $export        = require('./$.export')
  , redefine       = require('./$.redefine')
  , hide           = require('./$.hide')
  , has            = require('./$.has')
  , Iterators      = require('./$.iterators')
  , $iterCreate    = require('./$.iter-create')
  , setToStringTag = require('./$.set-to-string-tag')
  , getProto       = require('./$').getProto
  , ITERATOR       = require('./$.wks')('iterator')
  , BUGGY          = !([].keys && 'next' in [].keys()) // Safari has buggy iterators w/o `next`
  , FF_ITERATOR    = '@@iterator'
  , KEYS           = 'keys'
  , VALUES         = 'values';

var returnThis = function(){ return this; };

module.exports = function(Base, NAME, Constructor, next, DEFAULT, IS_SET, FORCED){
  $iterCreate(Constructor, NAME, next);
  var getMethod = function(kind){
    if(!BUGGY && kind in proto)return proto[kind];
    switch(kind){
      case KEYS: return function keys(){ return new Constructor(this, kind); };
      case VALUES: return function values(){ return new Constructor(this, kind); };
    } return function entries(){ return new Constructor(this, kind); };
  };
  var TAG        = NAME + ' Iterator'
    , DEF_VALUES = DEFAULT == VALUES
    , VALUES_BUG = false
    , proto      = Base.prototype
    , $native    = proto[ITERATOR] || proto[FF_ITERATOR] || DEFAULT && proto[DEFAULT]
    , $default   = $native || getMethod(DEFAULT)
    , methods, key;
  // Fix native
  if($native){
    var IteratorPrototype = getProto($default.call(new Base));
    // Set @@toStringTag to native iterators
    setToStringTag(IteratorPrototype, TAG, true);
    // FF fix
    if(!LIBRARY && has(proto, FF_ITERATOR))hide(IteratorPrototype, ITERATOR, returnThis);
    // fix Array#{values, @@iterator}.name in V8 / FF
    if(DEF_VALUES && $native.name !== VALUES){
      VALUES_BUG = true;
      $default = function values(){ return $native.call(this); };
    }
  }
  // Define iterator
  if((!LIBRARY || FORCED) && (BUGGY || VALUES_BUG || !proto[ITERATOR])){
    hide(proto, ITERATOR, $default);
  }
  // Plug for library
  Iterators[NAME] = $default;
  Iterators[TAG]  = returnThis;
  if(DEFAULT){
    methods = {
      values:  DEF_VALUES  ? $default : getMethod(VALUES),
      keys:    IS_SET      ? $default : getMethod(KEYS),
      entries: !DEF_VALUES ? $default : getMethod('entries')
    };
    if(FORCED)for(key in methods){
      if(!(key in proto))redefine(proto, key, methods[key]);
    } else $export($export.P + $export.F * (BUGGY || VALUES_BUG), NAME, methods);
  }
  return methods;
};
},{"./$":46,"./$.export":22,"./$.has":30,"./$.hide":31,"./$.iter-create":41,"./$.iterators":45,"./$.library":48,"./$.redefine":61,"./$.set-to-string-tag":66,"./$.wks":83}],43:[function(require,module,exports){
var ITERATOR     = require('./$.wks')('iterator')
  , SAFE_CLOSING = false;

try {
  var riter = [7][ITERATOR]();
  riter['return'] = function(){ SAFE_CLOSING = true; };
  Array.from(riter, function(){ throw 2; });
} catch(e){ /* empty */ }

module.exports = function(exec, skipClosing){
  if(!skipClosing && !SAFE_CLOSING)return false;
  var safe = false;
  try {
    var arr  = [7]
      , iter = arr[ITERATOR]();
    iter.next = function(){ return {done: safe = true}; };
    arr[ITERATOR] = function(){ return iter; };
    exec(arr);
  } catch(e){ /* empty */ }
  return safe;
};
},{"./$.wks":83}],44:[function(require,module,exports){
module.exports = function(done, value){
  return {value: value, done: !!done};
};
},{}],45:[function(require,module,exports){
module.exports = {};
},{}],46:[function(require,module,exports){
var $Object = Object;
module.exports = {
  create:     $Object.create,
  getProto:   $Object.getPrototypeOf,
  isEnum:     {}.propertyIsEnumerable,
  getDesc:    $Object.getOwnPropertyDescriptor,
  setDesc:    $Object.defineProperty,
  setDescs:   $Object.defineProperties,
  getKeys:    $Object.keys,
  getNames:   $Object.getOwnPropertyNames,
  getSymbols: $Object.getOwnPropertySymbols,
  each:       [].forEach
};
},{}],47:[function(require,module,exports){
var $         = require('./$')
  , toIObject = require('./$.to-iobject');
module.exports = function(object, el){
  var O      = toIObject(object)
    , keys   = $.getKeys(O)
    , length = keys.length
    , index  = 0
    , key;
  while(length > index)if(O[key = keys[index++]] === el)return key;
};
},{"./$":46,"./$.to-iobject":78}],48:[function(require,module,exports){
module.exports = false;
},{}],49:[function(require,module,exports){
// 20.2.2.14 Math.expm1(x)
module.exports = Math.expm1 || function expm1(x){
  return (x = +x) == 0 ? x : x > -1e-6 && x < 1e-6 ? x + x * x / 2 : Math.exp(x) - 1;
};
},{}],50:[function(require,module,exports){
// 20.2.2.20 Math.log1p(x)
module.exports = Math.log1p || function log1p(x){
  return (x = +x) > -1e-8 && x < 1e-8 ? x - x * x / 2 : Math.log(1 + x);
};
},{}],51:[function(require,module,exports){
// 20.2.2.28 Math.sign(x)
module.exports = Math.sign || function sign(x){
  return (x = +x) == 0 || x != x ? x : x < 0 ? -1 : 1;
};
},{}],52:[function(require,module,exports){
var global    = require('./$.global')
  , macrotask = require('./$.task').set
  , Observer  = global.MutationObserver || global.WebKitMutationObserver
  , process   = global.process
  , Promise   = global.Promise
  , isNode    = require('./$.cof')(process) == 'process'
  , head, last, notify;

var flush = function(){
  var parent, domain, fn;
  if(isNode && (parent = process.domain)){
    process.domain = null;
    parent.exit();
  }
  while(head){
    domain = head.domain;
    fn     = head.fn;
    if(domain)domain.enter();
    fn(); // <- currently we use it only for Promise - try / catch not required
    if(domain)domain.exit();
    head = head.next;
  } last = undefined;
  if(parent)parent.enter();
};

// Node.js
if(isNode){
  notify = function(){
    process.nextTick(flush);
  };
// browsers with MutationObserver
} else if(Observer){
  var toggle = 1
    , node   = document.createTextNode('');
  new Observer(flush).observe(node, {characterData: true}); // eslint-disable-line no-new
  notify = function(){
    node.data = toggle = -toggle;
  };
// environments with maybe non-completely correct, but existent Promise
} else if(Promise && Promise.resolve){
  notify = function(){
    Promise.resolve().then(flush);
  };
// for other environments - macrotask based on:
// - setImmediate
// - MessageChannel
// - window.postMessag
// - onreadystatechange
// - setTimeout
} else {
  notify = function(){
    // strange IE + webpack dev server bug - use .call(global)
    macrotask.call(global, flush);
  };
}

module.exports = function asap(fn){
  var task = {fn: fn, next: undefined, domain: isNode && process.domain};
  if(last)last.next = task;
  if(!head){
    head = task;
    notify();
  } last = task;
};
},{"./$.cof":11,"./$.global":29,"./$.task":75}],53:[function(require,module,exports){
// 19.1.2.1 Object.assign(target, source, ...)
var $        = require('./$')
  , toObject = require('./$.to-object')
  , IObject  = require('./$.iobject');

// should work with symbols and should have deterministic property order (V8 bug)
module.exports = require('./$.fails')(function(){
  var a = Object.assign
    , A = {}
    , B = {}
    , S = Symbol()
    , K = 'abcdefghijklmnopqrst';
  A[S] = 7;
  K.split('').forEach(function(k){ B[k] = k; });
  return a({}, A)[S] != 7 || Object.keys(a({}, B)).join('') != K;
}) ? function assign(target, source){ // eslint-disable-line no-unused-vars
  var T     = toObject(target)
    , $$    = arguments
    , $$len = $$.length
    , index = 1
    , getKeys    = $.getKeys
    , getSymbols = $.getSymbols
    , isEnum     = $.isEnum;
  while($$len > index){
    var S      = IObject($$[index++])
      , keys   = getSymbols ? getKeys(S).concat(getSymbols(S)) : getKeys(S)
      , length = keys.length
      , j      = 0
      , key;
    while(length > j)if(isEnum.call(S, key = keys[j++]))T[key] = S[key];
  }
  return T;
} : Object.assign;
},{"./$":46,"./$.fails":24,"./$.iobject":34,"./$.to-object":80}],54:[function(require,module,exports){
// most Object methods by ES6 should accept primitives
var $export = require('./$.export')
  , core    = require('./$.core')
  , fails   = require('./$.fails');
module.exports = function(KEY, exec){
  var fn  = (core.Object || {})[KEY] || Object[KEY]
    , exp = {};
  exp[KEY] = exec(fn);
  $export($export.S + $export.F * fails(function(){ fn(1); }), 'Object', exp);
};
},{"./$.core":16,"./$.export":22,"./$.fails":24}],55:[function(require,module,exports){
var $         = require('./$')
  , toIObject = require('./$.to-iobject')
  , isEnum    = $.isEnum;
module.exports = function(isEntries){
  return function(it){
    var O      = toIObject(it)
      , keys   = $.getKeys(O)
      , length = keys.length
      , i      = 0
      , result = []
      , key;
    while(length > i)if(isEnum.call(O, key = keys[i++])){
      result.push(isEntries ? [key, O[key]] : O[key]);
    } return result;
  };
};
},{"./$":46,"./$.to-iobject":78}],56:[function(require,module,exports){
// all object keys, includes non-enumerable and symbols
var $        = require('./$')
  , anObject = require('./$.an-object')
  , Reflect  = require('./$.global').Reflect;
module.exports = Reflect && Reflect.ownKeys || function ownKeys(it){
  var keys       = $.getNames(anObject(it))
    , getSymbols = $.getSymbols;
  return getSymbols ? keys.concat(getSymbols(it)) : keys;
};
},{"./$":46,"./$.an-object":4,"./$.global":29}],57:[function(require,module,exports){
'use strict';
var path      = require('./$.path')
  , invoke    = require('./$.invoke')
  , aFunction = require('./$.a-function');
module.exports = function(/* ...pargs */){
  var fn     = aFunction(this)
    , length = arguments.length
    , pargs  = Array(length)
    , i      = 0
    , _      = path._
    , holder = false;
  while(length > i)if((pargs[i] = arguments[i++]) === _)holder = true;
  return function(/* ...args */){
    var that  = this
      , $$    = arguments
      , $$len = $$.length
      , j = 0, k = 0, args;
    if(!holder && !$$len)return invoke(fn, pargs, that);
    args = pargs.slice();
    if(holder)for(;length > j; j++)if(args[j] === _)args[j] = $$[k++];
    while($$len > k)args.push($$[k++]);
    return invoke(fn, args, that);
  };
};
},{"./$.a-function":2,"./$.invoke":33,"./$.path":58}],58:[function(require,module,exports){
module.exports = require('./$.global');
},{"./$.global":29}],59:[function(require,module,exports){
module.exports = function(bitmap, value){
  return {
    enumerable  : !(bitmap & 1),
    configurable: !(bitmap & 2),
    writable    : !(bitmap & 4),
    value       : value
  };
};
},{}],60:[function(require,module,exports){
var redefine = require('./$.redefine');
module.exports = function(target, src){
  for(var key in src)redefine(target, key, src[key]);
  return target;
};
},{"./$.redefine":61}],61:[function(require,module,exports){
// add fake Function#toString
// for correct work wrapped methods / constructors with methods like LoDash isNative
var global    = require('./$.global')
  , hide      = require('./$.hide')
  , SRC       = require('./$.uid')('src')
  , TO_STRING = 'toString'
  , $toString = Function[TO_STRING]
  , TPL       = ('' + $toString).split(TO_STRING);

require('./$.core').inspectSource = function(it){
  return $toString.call(it);
};

(module.exports = function(O, key, val, safe){
  if(typeof val == 'function'){
    val.hasOwnProperty(SRC) || hide(val, SRC, O[key] ? '' + O[key] : TPL.join(String(key)));
    val.hasOwnProperty('name') || hide(val, 'name', key);
  }
  if(O === global){
    O[key] = val;
  } else {
    if(!safe)delete O[key];
    hide(O, key, val);
  }
})(Function.prototype, TO_STRING, function toString(){
  return typeof this == 'function' && this[SRC] || $toString.call(this);
});
},{"./$.core":16,"./$.global":29,"./$.hide":31,"./$.uid":82}],62:[function(require,module,exports){
module.exports = function(regExp, replace){
  var replacer = replace === Object(replace) ? function(part){
    return replace[part];
  } : replace;
  return function(it){
    return String(it).replace(regExp, replacer);
  };
};
},{}],63:[function(require,module,exports){
// 7.2.9 SameValue(x, y)
module.exports = Object.is || function is(x, y){
  return x === y ? x !== 0 || 1 / x === 1 / y : x != x && y != y;
};
},{}],64:[function(require,module,exports){
// Works with __proto__ only. Old v8 can't work with null proto objects.
/* eslint-disable no-proto */
var getDesc  = require('./$').getDesc
  , isObject = require('./$.is-object')
  , anObject = require('./$.an-object');
var check = function(O, proto){
  anObject(O);
  if(!isObject(proto) && proto !== null)throw TypeError(proto + ": can't set as prototype!");
};
module.exports = {
  set: Object.setPrototypeOf || ('__proto__' in {} ? // eslint-disable-line
    function(test, buggy, set){
      try {
        set = require('./$.ctx')(Function.call, getDesc(Object.prototype, '__proto__').set, 2);
        set(test, []);
        buggy = !(test instanceof Array);
      } catch(e){ buggy = true; }
      return function setPrototypeOf(O, proto){
        check(O, proto);
        if(buggy)O.__proto__ = proto;
        else set(O, proto);
        return O;
      };
    }({}, false) : undefined),
  check: check
};
},{"./$":46,"./$.an-object":4,"./$.ctx":17,"./$.is-object":38}],65:[function(require,module,exports){
'use strict';
var global      = require('./$.global')
  , $           = require('./$')
  , DESCRIPTORS = require('./$.descriptors')
  , SPECIES     = require('./$.wks')('species');

module.exports = function(KEY){
  var C = global[KEY];
  if(DESCRIPTORS && C && !C[SPECIES])$.setDesc(C, SPECIES, {
    configurable: true,
    get: function(){ return this; }
  });
};
},{"./$":46,"./$.descriptors":19,"./$.global":29,"./$.wks":83}],66:[function(require,module,exports){
var def = require('./$').setDesc
  , has = require('./$.has')
  , TAG = require('./$.wks')('toStringTag');

module.exports = function(it, tag, stat){
  if(it && !has(it = stat ? it : it.prototype, TAG))def(it, TAG, {configurable: true, value: tag});
};
},{"./$":46,"./$.has":30,"./$.wks":83}],67:[function(require,module,exports){
var global = require('./$.global')
  , SHARED = '__core-js_shared__'
  , store  = global[SHARED] || (global[SHARED] = {});
module.exports = function(key){
  return store[key] || (store[key] = {});
};
},{"./$.global":29}],68:[function(require,module,exports){
// 7.3.20 SpeciesConstructor(O, defaultConstructor)
var anObject  = require('./$.an-object')
  , aFunction = require('./$.a-function')
  , SPECIES   = require('./$.wks')('species');
module.exports = function(O, D){
  var C = anObject(O).constructor, S;
  return C === undefined || (S = anObject(C)[SPECIES]) == undefined ? D : aFunction(S);
};
},{"./$.a-function":2,"./$.an-object":4,"./$.wks":83}],69:[function(require,module,exports){
module.exports = function(it, Constructor, name){
  if(!(it instanceof Constructor))throw TypeError(name + ": use the 'new' operator!");
  return it;
};
},{}],70:[function(require,module,exports){
var toInteger = require('./$.to-integer')
  , defined   = require('./$.defined');
// true  -> String#at
// false -> String#codePointAt
module.exports = function(TO_STRING){
  return function(that, pos){
    var s = String(defined(that))
      , i = toInteger(pos)
      , l = s.length
      , a, b;
    if(i < 0 || i >= l)return TO_STRING ? '' : undefined;
    a = s.charCodeAt(i);
    return a < 0xd800 || a > 0xdbff || i + 1 === l || (b = s.charCodeAt(i + 1)) < 0xdc00 || b > 0xdfff
      ? TO_STRING ? s.charAt(i) : a
      : TO_STRING ? s.slice(i, i + 2) : (a - 0xd800 << 10) + (b - 0xdc00) + 0x10000;
  };
};
},{"./$.defined":18,"./$.to-integer":77}],71:[function(require,module,exports){
// helper for String#{startsWith, endsWith, includes}
var isRegExp = require('./$.is-regexp')
  , defined  = require('./$.defined');

module.exports = function(that, searchString, NAME){
  if(isRegExp(searchString))throw TypeError('String#' + NAME + " doesn't accept regex!");
  return String(defined(that));
};
},{"./$.defined":18,"./$.is-regexp":39}],72:[function(require,module,exports){
// https://github.com/ljharb/proposal-string-pad-left-right
var toLength = require('./$.to-length')
  , repeat   = require('./$.string-repeat')
  , defined  = require('./$.defined');

module.exports = function(that, maxLength, fillString, left){
  var S            = String(defined(that))
    , stringLength = S.length
    , fillStr      = fillString === undefined ? ' ' : String(fillString)
    , intMaxLength = toLength(maxLength);
  if(intMaxLength <= stringLength)return S;
  if(fillStr == '')fillStr = ' ';
  var fillLen = intMaxLength - stringLength
    , stringFiller = repeat.call(fillStr, Math.ceil(fillLen / fillStr.length));
  if(stringFiller.length > fillLen)stringFiller = stringFiller.slice(0, fillLen);
  return left ? stringFiller + S : S + stringFiller;
};
},{"./$.defined":18,"./$.string-repeat":73,"./$.to-length":79}],73:[function(require,module,exports){
'use strict';
var toInteger = require('./$.to-integer')
  , defined   = require('./$.defined');

module.exports = function repeat(count){
  var str = String(defined(this))
    , res = ''
    , n   = toInteger(count);
  if(n < 0 || n == Infinity)throw RangeError("Count can't be negative");
  for(;n > 0; (n >>>= 1) && (str += str))if(n & 1)res += str;
  return res;
};
},{"./$.defined":18,"./$.to-integer":77}],74:[function(require,module,exports){
var $export = require('./$.export')
  , defined = require('./$.defined')
  , fails   = require('./$.fails')
  , spaces  = '\x09\x0A\x0B\x0C\x0D\x20\xA0\u1680\u180E\u2000\u2001\u2002\u2003' +
      '\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u2028\u2029\uFEFF'
  , space   = '[' + spaces + ']'
  , non     = '\u200b\u0085'
  , ltrim   = RegExp('^' + space + space + '*')
  , rtrim   = RegExp(space + space + '*$');

var exporter = function(KEY, exec){
  var exp  = {};
  exp[KEY] = exec(trim);
  $export($export.P + $export.F * fails(function(){
    return !!spaces[KEY]() || non[KEY]() != non;
  }), 'String', exp);
};

// 1 -> String#trimLeft
// 2 -> String#trimRight
// 3 -> String#trim
var trim = exporter.trim = function(string, TYPE){
  string = String(defined(string));
  if(TYPE & 1)string = string.replace(ltrim, '');
  if(TYPE & 2)string = string.replace(rtrim, '');
  return string;
};

module.exports = exporter;
},{"./$.defined":18,"./$.export":22,"./$.fails":24}],75:[function(require,module,exports){
var ctx                = require('./$.ctx')
  , invoke             = require('./$.invoke')
  , html               = require('./$.html')
  , cel                = require('./$.dom-create')
  , global             = require('./$.global')
  , process            = global.process
  , setTask            = global.setImmediate
  , clearTask          = global.clearImmediate
  , MessageChannel     = global.MessageChannel
  , counter            = 0
  , queue              = {}
  , ONREADYSTATECHANGE = 'onreadystatechange'
  , defer, channel, port;
var run = function(){
  var id = +this;
  if(queue.hasOwnProperty(id)){
    var fn = queue[id];
    delete queue[id];
    fn();
  }
};
var listner = function(event){
  run.call(event.data);
};
// Node.js 0.9+ & IE10+ has setImmediate, otherwise:
if(!setTask || !clearTask){
  setTask = function setImmediate(fn){
    var args = [], i = 1;
    while(arguments.length > i)args.push(arguments[i++]);
    queue[++counter] = function(){
      invoke(typeof fn == 'function' ? fn : Function(fn), args);
    };
    defer(counter);
    return counter;
  };
  clearTask = function clearImmediate(id){
    delete queue[id];
  };
  // Node.js 0.8-
  if(require('./$.cof')(process) == 'process'){
    defer = function(id){
      process.nextTick(ctx(run, id, 1));
    };
  // Browsers with MessageChannel, includes WebWorkers
  } else if(MessageChannel){
    channel = new MessageChannel;
    port    = channel.port2;
    channel.port1.onmessage = listner;
    defer = ctx(port.postMessage, port, 1);
  // Browsers with postMessage, skip WebWorkers
  // IE8 has postMessage, but it's sync & typeof its postMessage is 'object'
  } else if(global.addEventListener && typeof postMessage == 'function' && !global.importScripts){
    defer = function(id){
      global.postMessage(id + '', '*');
    };
    global.addEventListener('message', listner, false);
  // IE8-
  } else if(ONREADYSTATECHANGE in cel('script')){
    defer = function(id){
      html.appendChild(cel('script'))[ONREADYSTATECHANGE] = function(){
        html.removeChild(this);
        run.call(id);
      };
    };
  // Rest old browsers
  } else {
    defer = function(id){
      setTimeout(ctx(run, id, 1), 0);
    };
  }
}
module.exports = {
  set:   setTask,
  clear: clearTask
};
},{"./$.cof":11,"./$.ctx":17,"./$.dom-create":20,"./$.global":29,"./$.html":32,"./$.invoke":33}],76:[function(require,module,exports){
var toInteger = require('./$.to-integer')
  , max       = Math.max
  , min       = Math.min;
module.exports = function(index, length){
  index = toInteger(index);
  return index < 0 ? max(index + length, 0) : min(index, length);
};
},{"./$.to-integer":77}],77:[function(require,module,exports){
// 7.1.4 ToInteger
var ceil  = Math.ceil
  , floor = Math.floor;
module.exports = function(it){
  return isNaN(it = +it) ? 0 : (it > 0 ? floor : ceil)(it);
};
},{}],78:[function(require,module,exports){
// to indexed object, toObject with fallback for non-array-like ES3 strings
var IObject = require('./$.iobject')
  , defined = require('./$.defined');
module.exports = function(it){
  return IObject(defined(it));
};
},{"./$.defined":18,"./$.iobject":34}],79:[function(require,module,exports){
// 7.1.15 ToLength
var toInteger = require('./$.to-integer')
  , min       = Math.min;
module.exports = function(it){
  return it > 0 ? min(toInteger(it), 0x1fffffffffffff) : 0; // pow(2, 53) - 1 == 9007199254740991
};
},{"./$.to-integer":77}],80:[function(require,module,exports){
// 7.1.13 ToObject(argument)
var defined = require('./$.defined');
module.exports = function(it){
  return Object(defined(it));
};
},{"./$.defined":18}],81:[function(require,module,exports){
// 7.1.1 ToPrimitive(input [, PreferredType])
var isObject = require('./$.is-object');
// instead of the ES6 spec version, we didn't implement @@toPrimitive case
// and the second argument - flag - preferred type is a string
module.exports = function(it, S){
  if(!isObject(it))return it;
  var fn, val;
  if(S && typeof (fn = it.toString) == 'function' && !isObject(val = fn.call(it)))return val;
  if(typeof (fn = it.valueOf) == 'function' && !isObject(val = fn.call(it)))return val;
  if(!S && typeof (fn = it.toString) == 'function' && !isObject(val = fn.call(it)))return val;
  throw TypeError("Can't convert object to primitive value");
};
},{"./$.is-object":38}],82:[function(require,module,exports){
var id = 0
  , px = Math.random();
module.exports = function(key){
  return 'Symbol('.concat(key === undefined ? '' : key, ')_', (++id + px).toString(36));
};
},{}],83:[function(require,module,exports){
var store  = require('./$.shared')('wks')
  , uid    = require('./$.uid')
  , Symbol = require('./$.global').Symbol;
module.exports = function(name){
  return store[name] || (store[name] =
    Symbol && Symbol[name] || (Symbol || uid)('Symbol.' + name));
};
},{"./$.global":29,"./$.shared":67,"./$.uid":82}],84:[function(require,module,exports){
var classof   = require('./$.classof')
  , ITERATOR  = require('./$.wks')('iterator')
  , Iterators = require('./$.iterators');
module.exports = require('./$.core').getIteratorMethod = function(it){
  if(it != undefined)return it[ITERATOR]
    || it['@@iterator']
    || Iterators[classof(it)];
};
},{"./$.classof":10,"./$.core":16,"./$.iterators":45,"./$.wks":83}],85:[function(require,module,exports){
'use strict';
var $                 = require('./$')
  , $export           = require('./$.export')
  , DESCRIPTORS       = require('./$.descriptors')
  , createDesc        = require('./$.property-desc')
  , html              = require('./$.html')
  , cel               = require('./$.dom-create')
  , has               = require('./$.has')
  , cof               = require('./$.cof')
  , invoke            = require('./$.invoke')
  , fails             = require('./$.fails')
  , anObject          = require('./$.an-object')
  , aFunction         = require('./$.a-function')
  , isObject          = require('./$.is-object')
  , toObject          = require('./$.to-object')
  , toIObject         = require('./$.to-iobject')
  , toInteger         = require('./$.to-integer')
  , toIndex           = require('./$.to-index')
  , toLength          = require('./$.to-length')
  , IObject           = require('./$.iobject')
  , IE_PROTO          = require('./$.uid')('__proto__')
  , createArrayMethod = require('./$.array-methods')
  , arrayIndexOf      = require('./$.array-includes')(false)
  , ObjectProto       = Object.prototype
  , ArrayProto        = Array.prototype
  , arraySlice        = ArrayProto.slice
  , arrayJoin         = ArrayProto.join
  , defineProperty    = $.setDesc
  , getOwnDescriptor  = $.getDesc
  , defineProperties  = $.setDescs
  , factories         = {}
  , IE8_DOM_DEFINE;

if(!DESCRIPTORS){
  IE8_DOM_DEFINE = !fails(function(){
    return defineProperty(cel('div'), 'a', {get: function(){ return 7; }}).a != 7;
  });
  $.setDesc = function(O, P, Attributes){
    if(IE8_DOM_DEFINE)try {
      return defineProperty(O, P, Attributes);
    } catch(e){ /* empty */ }
    if('get' in Attributes || 'set' in Attributes)throw TypeError('Accessors not supported!');
    if('value' in Attributes)anObject(O)[P] = Attributes.value;
    return O;
  };
  $.getDesc = function(O, P){
    if(IE8_DOM_DEFINE)try {
      return getOwnDescriptor(O, P);
    } catch(e){ /* empty */ }
    if(has(O, P))return createDesc(!ObjectProto.propertyIsEnumerable.call(O, P), O[P]);
  };
  $.setDescs = defineProperties = function(O, Properties){
    anObject(O);
    var keys   = $.getKeys(Properties)
      , length = keys.length
      , i = 0
      , P;
    while(length > i)$.setDesc(O, P = keys[i++], Properties[P]);
    return O;
  };
}
$export($export.S + $export.F * !DESCRIPTORS, 'Object', {
  // 19.1.2.6 / 15.2.3.3 Object.getOwnPropertyDescriptor(O, P)
  getOwnPropertyDescriptor: $.getDesc,
  // 19.1.2.4 / 15.2.3.6 Object.defineProperty(O, P, Attributes)
  defineProperty: $.setDesc,
  // 19.1.2.3 / 15.2.3.7 Object.defineProperties(O, Properties)
  defineProperties: defineProperties
});

  // IE 8- don't enum bug keys
var keys1 = ('constructor,hasOwnProperty,isPrototypeOf,propertyIsEnumerable,' +
            'toLocaleString,toString,valueOf').split(',')
  // Additional keys for getOwnPropertyNames
  , keys2 = keys1.concat('length', 'prototype')
  , keysLen1 = keys1.length;

// Create object with `null` prototype: use iframe Object with cleared prototype
var createDict = function(){
  // Thrash, waste and sodomy: IE GC bug
  var iframe = cel('iframe')
    , i      = keysLen1
    , gt     = '>'
    , iframeDocument;
  iframe.style.display = 'none';
  html.appendChild(iframe);
  iframe.src = 'javascript:'; // eslint-disable-line no-script-url
  // createDict = iframe.contentWindow.Object;
  // html.removeChild(iframe);
  iframeDocument = iframe.contentWindow.document;
  iframeDocument.open();
  iframeDocument.write('<script>document.F=Object</script' + gt);
  iframeDocument.close();
  createDict = iframeDocument.F;
  while(i--)delete createDict.prototype[keys1[i]];
  return createDict();
};
var createGetKeys = function(names, length){
  return function(object){
    var O      = toIObject(object)
      , i      = 0
      , result = []
      , key;
    for(key in O)if(key != IE_PROTO)has(O, key) && result.push(key);
    // Don't enum bug & hidden keys
    while(length > i)if(has(O, key = names[i++])){
      ~arrayIndexOf(result, key) || result.push(key);
    }
    return result;
  };
};
var Empty = function(){};
$export($export.S, 'Object', {
  // 19.1.2.9 / 15.2.3.2 Object.getPrototypeOf(O)
  getPrototypeOf: $.getProto = $.getProto || function(O){
    O = toObject(O);
    if(has(O, IE_PROTO))return O[IE_PROTO];
    if(typeof O.constructor == 'function' && O instanceof O.constructor){
      return O.constructor.prototype;
    } return O instanceof Object ? ObjectProto : null;
  },
  // 19.1.2.7 / 15.2.3.4 Object.getOwnPropertyNames(O)
  getOwnPropertyNames: $.getNames = $.getNames || createGetKeys(keys2, keys2.length, true),
  // 19.1.2.2 / 15.2.3.5 Object.create(O [, Properties])
  create: $.create = $.create || function(O, /*?*/Properties){
    var result;
    if(O !== null){
      Empty.prototype = anObject(O);
      result = new Empty();
      Empty.prototype = null;
      // add "__proto__" for Object.getPrototypeOf shim
      result[IE_PROTO] = O;
    } else result = createDict();
    return Properties === undefined ? result : defineProperties(result, Properties);
  },
  // 19.1.2.14 / 15.2.3.14 Object.keys(O)
  keys: $.getKeys = $.getKeys || createGetKeys(keys1, keysLen1, false)
});

var construct = function(F, len, args){
  if(!(len in factories)){
    for(var n = [], i = 0; i < len; i++)n[i] = 'a[' + i + ']';
    factories[len] = Function('F,a', 'return new F(' + n.join(',') + ')');
  }
  return factories[len](F, args);
};

// 19.2.3.2 / 15.3.4.5 Function.prototype.bind(thisArg, args...)
$export($export.P, 'Function', {
  bind: function bind(that /*, args... */){
    var fn       = aFunction(this)
      , partArgs = arraySlice.call(arguments, 1);
    var bound = function(/* args... */){
      var args = partArgs.concat(arraySlice.call(arguments));
      return this instanceof bound ? construct(fn, args.length, args) : invoke(fn, args, that);
    };
    if(isObject(fn.prototype))bound.prototype = fn.prototype;
    return bound;
  }
});

// fallback for not array-like ES3 strings and DOM objects
$export($export.P + $export.F * fails(function(){
  if(html)arraySlice.call(html);
}), 'Array', {
  slice: function(begin, end){
    var len   = toLength(this.length)
      , klass = cof(this);
    end = end === undefined ? len : end;
    if(klass == 'Array')return arraySlice.call(this, begin, end);
    var start  = toIndex(begin, len)
      , upTo   = toIndex(end, len)
      , size   = toLength(upTo - start)
      , cloned = Array(size)
      , i      = 0;
    for(; i < size; i++)cloned[i] = klass == 'String'
      ? this.charAt(start + i)
      : this[start + i];
    return cloned;
  }
});
$export($export.P + $export.F * (IObject != Object), 'Array', {
  join: function join(separator){
    return arrayJoin.call(IObject(this), separator === undefined ? ',' : separator);
  }
});

// 22.1.2.2 / 15.4.3.2 Array.isArray(arg)
$export($export.S, 'Array', {isArray: require('./$.is-array')});

var createArrayReduce = function(isRight){
  return function(callbackfn, memo){
    aFunction(callbackfn);
    var O      = IObject(this)
      , length = toLength(O.length)
      , index  = isRight ? length - 1 : 0
      , i      = isRight ? -1 : 1;
    if(arguments.length < 2)for(;;){
      if(index in O){
        memo = O[index];
        index += i;
        break;
      }
      index += i;
      if(isRight ? index < 0 : length <= index){
        throw TypeError('Reduce of empty array with no initial value');
      }
    }
    for(;isRight ? index >= 0 : length > index; index += i)if(index in O){
      memo = callbackfn(memo, O[index], index, this);
    }
    return memo;
  };
};

var methodize = function($fn){
  return function(arg1/*, arg2 = undefined */){
    return $fn(this, arg1, arguments[1]);
  };
};

$export($export.P, 'Array', {
  // 22.1.3.10 / 15.4.4.18 Array.prototype.forEach(callbackfn [, thisArg])
  forEach: $.each = $.each || methodize(createArrayMethod(0)),
  // 22.1.3.15 / 15.4.4.19 Array.prototype.map(callbackfn [, thisArg])
  map: methodize(createArrayMethod(1)),
  // 22.1.3.7 / 15.4.4.20 Array.prototype.filter(callbackfn [, thisArg])
  filter: methodize(createArrayMethod(2)),
  // 22.1.3.23 / 15.4.4.17 Array.prototype.some(callbackfn [, thisArg])
  some: methodize(createArrayMethod(3)),
  // 22.1.3.5 / 15.4.4.16 Array.prototype.every(callbackfn [, thisArg])
  every: methodize(createArrayMethod(4)),
  // 22.1.3.18 / 15.4.4.21 Array.prototype.reduce(callbackfn [, initialValue])
  reduce: createArrayReduce(false),
  // 22.1.3.19 / 15.4.4.22 Array.prototype.reduceRight(callbackfn [, initialValue])
  reduceRight: createArrayReduce(true),
  // 22.1.3.11 / 15.4.4.14 Array.prototype.indexOf(searchElement [, fromIndex])
  indexOf: methodize(arrayIndexOf),
  // 22.1.3.14 / 15.4.4.15 Array.prototype.lastIndexOf(searchElement [, fromIndex])
  lastIndexOf: function(el, fromIndex /* = @[*-1] */){
    var O      = toIObject(this)
      , length = toLength(O.length)
      , index  = length - 1;
    if(arguments.length > 1)index = Math.min(index, toInteger(fromIndex));
    if(index < 0)index = toLength(length + index);
    for(;index >= 0; index--)if(index in O)if(O[index] === el)return index;
    return -1;
  }
});

// 20.3.3.1 / 15.9.4.4 Date.now()
$export($export.S, 'Date', {now: function(){ return +new Date; }});

var lz = function(num){
  return num > 9 ? num : '0' + num;
};

// 20.3.4.36 / 15.9.5.43 Date.prototype.toISOString()
// PhantomJS / old WebKit has a broken implementations
$export($export.P + $export.F * (fails(function(){
  return new Date(-5e13 - 1).toISOString() != '0385-07-25T07:06:39.999Z';
}) || !fails(function(){
  new Date(NaN).toISOString();
})), 'Date', {
  toISOString: function toISOString(){
    if(!isFinite(this))throw RangeError('Invalid time value');
    var d = this
      , y = d.getUTCFullYear()
      , m = d.getUTCMilliseconds()
      , s = y < 0 ? '-' : y > 9999 ? '+' : '';
    return s + ('00000' + Math.abs(y)).slice(s ? -6 : -4) +
      '-' + lz(d.getUTCMonth() + 1) + '-' + lz(d.getUTCDate()) +
      'T' + lz(d.getUTCHours()) + ':' + lz(d.getUTCMinutes()) +
      ':' + lz(d.getUTCSeconds()) + '.' + (m > 99 ? m : '0' + lz(m)) + 'Z';
  }
});
},{"./$":46,"./$.a-function":2,"./$.an-object":4,"./$.array-includes":7,"./$.array-methods":8,"./$.cof":11,"./$.descriptors":19,"./$.dom-create":20,"./$.export":22,"./$.fails":24,"./$.has":30,"./$.html":32,"./$.invoke":33,"./$.iobject":34,"./$.is-array":36,"./$.is-object":38,"./$.property-desc":59,"./$.to-index":76,"./$.to-integer":77,"./$.to-iobject":78,"./$.to-length":79,"./$.to-object":80,"./$.uid":82}],86:[function(require,module,exports){
// 22.1.3.3 Array.prototype.copyWithin(target, start, end = this.length)
var $export = require('./$.export');

$export($export.P, 'Array', {copyWithin: require('./$.array-copy-within')});

require('./$.add-to-unscopables')('copyWithin');
},{"./$.add-to-unscopables":3,"./$.array-copy-within":5,"./$.export":22}],87:[function(require,module,exports){
// 22.1.3.6 Array.prototype.fill(value, start = 0, end = this.length)
var $export = require('./$.export');

$export($export.P, 'Array', {fill: require('./$.array-fill')});

require('./$.add-to-unscopables')('fill');
},{"./$.add-to-unscopables":3,"./$.array-fill":6,"./$.export":22}],88:[function(require,module,exports){
'use strict';
// 22.1.3.9 Array.prototype.findIndex(predicate, thisArg = undefined)
var $export = require('./$.export')
  , $find   = require('./$.array-methods')(6)
  , KEY     = 'findIndex'
  , forced  = true;
// Shouldn't skip holes
if(KEY in [])Array(1)[KEY](function(){ forced = false; });
$export($export.P + $export.F * forced, 'Array', {
  findIndex: function findIndex(callbackfn/*, that = undefined */){
    return $find(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});
require('./$.add-to-unscopables')(KEY);
},{"./$.add-to-unscopables":3,"./$.array-methods":8,"./$.export":22}],89:[function(require,module,exports){
'use strict';
// 22.1.3.8 Array.prototype.find(predicate, thisArg = undefined)
var $export = require('./$.export')
  , $find   = require('./$.array-methods')(5)
  , KEY     = 'find'
  , forced  = true;
// Shouldn't skip holes
if(KEY in [])Array(1)[KEY](function(){ forced = false; });
$export($export.P + $export.F * forced, 'Array', {
  find: function find(callbackfn/*, that = undefined */){
    return $find(this, callbackfn, arguments.length > 1 ? arguments[1] : undefined);
  }
});
require('./$.add-to-unscopables')(KEY);
},{"./$.add-to-unscopables":3,"./$.array-methods":8,"./$.export":22}],90:[function(require,module,exports){
'use strict';
var ctx         = require('./$.ctx')
  , $export     = require('./$.export')
  , toObject    = require('./$.to-object')
  , call        = require('./$.iter-call')
  , isArrayIter = require('./$.is-array-iter')
  , toLength    = require('./$.to-length')
  , getIterFn   = require('./core.get-iterator-method');
$export($export.S + $export.F * !require('./$.iter-detect')(function(iter){ Array.from(iter); }), 'Array', {
  // 22.1.2.1 Array.from(arrayLike, mapfn = undefined, thisArg = undefined)
  from: function from(arrayLike/*, mapfn = undefined, thisArg = undefined*/){
    var O       = toObject(arrayLike)
      , C       = typeof this == 'function' ? this : Array
      , $$      = arguments
      , $$len   = $$.length
      , mapfn   = $$len > 1 ? $$[1] : undefined
      , mapping = mapfn !== undefined
      , index   = 0
      , iterFn  = getIterFn(O)
      , length, result, step, iterator;
    if(mapping)mapfn = ctx(mapfn, $$len > 2 ? $$[2] : undefined, 2);
    // if object isn't iterable or it's array with default iterator - use simple case
    if(iterFn != undefined && !(C == Array && isArrayIter(iterFn))){
      for(iterator = iterFn.call(O), result = new C; !(step = iterator.next()).done; index++){
        result[index] = mapping ? call(iterator, mapfn, [step.value, index], true) : step.value;
      }
    } else {
      length = toLength(O.length);
      for(result = new C(length); length > index; index++){
        result[index] = mapping ? mapfn(O[index], index) : O[index];
      }
    }
    result.length = index;
    return result;
  }
});

},{"./$.ctx":17,"./$.export":22,"./$.is-array-iter":35,"./$.iter-call":40,"./$.iter-detect":43,"./$.to-length":79,"./$.to-object":80,"./core.get-iterator-method":84}],91:[function(require,module,exports){
'use strict';
var addToUnscopables = require('./$.add-to-unscopables')
  , step             = require('./$.iter-step')
  , Iterators        = require('./$.iterators')
  , toIObject        = require('./$.to-iobject');

// 22.1.3.4 Array.prototype.entries()
// 22.1.3.13 Array.prototype.keys()
// 22.1.3.29 Array.prototype.values()
// 22.1.3.30 Array.prototype[@@iterator]()
module.exports = require('./$.iter-define')(Array, 'Array', function(iterated, kind){
  this._t = toIObject(iterated); // target
  this._i = 0;                   // next index
  this._k = kind;                // kind
// 22.1.5.2.1 %ArrayIteratorPrototype%.next()
}, function(){
  var O     = this._t
    , kind  = this._k
    , index = this._i++;
  if(!O || index >= O.length){
    this._t = undefined;
    return step(1);
  }
  if(kind == 'keys'  )return step(0, index);
  if(kind == 'values')return step(0, O[index]);
  return step(0, [index, O[index]]);
}, 'values');

// argumentsList[@@iterator] is %ArrayProto_values% (9.4.4.6, 9.4.4.7)
Iterators.Arguments = Iterators.Array;

addToUnscopables('keys');
addToUnscopables('values');
addToUnscopables('entries');
},{"./$.add-to-unscopables":3,"./$.iter-define":42,"./$.iter-step":44,"./$.iterators":45,"./$.to-iobject":78}],92:[function(require,module,exports){
'use strict';
var $export = require('./$.export');

// WebKit Array.of isn't generic
$export($export.S + $export.F * require('./$.fails')(function(){
  function F(){}
  return !(Array.of.call(F) instanceof F);
}), 'Array', {
  // 22.1.2.3 Array.of( ...items)
  of: function of(/* ...args */){
    var index  = 0
      , $$     = arguments
      , $$len  = $$.length
      , result = new (typeof this == 'function' ? this : Array)($$len);
    while($$len > index)result[index] = $$[index++];
    result.length = $$len;
    return result;
  }
});
},{"./$.export":22,"./$.fails":24}],93:[function(require,module,exports){
require('./$.set-species')('Array');
},{"./$.set-species":65}],94:[function(require,module,exports){
'use strict';
var $             = require('./$')
  , isObject      = require('./$.is-object')
  , HAS_INSTANCE  = require('./$.wks')('hasInstance')
  , FunctionProto = Function.prototype;
// 19.2.3.6 Function.prototype[@@hasInstance](V)
if(!(HAS_INSTANCE in FunctionProto))$.setDesc(FunctionProto, HAS_INSTANCE, {value: function(O){
  if(typeof this != 'function' || !isObject(O))return false;
  if(!isObject(this.prototype))return O instanceof this;
  // for environment w/o native `@@hasInstance` logic enough `instanceof`, but add this:
  while(O = $.getProto(O))if(this.prototype === O)return true;
  return false;
}});
},{"./$":46,"./$.is-object":38,"./$.wks":83}],95:[function(require,module,exports){
var setDesc    = require('./$').setDesc
  , createDesc = require('./$.property-desc')
  , has        = require('./$.has')
  , FProto     = Function.prototype
  , nameRE     = /^\s*function ([^ (]*)/
  , NAME       = 'name';
// 19.2.4.2 name
NAME in FProto || require('./$.descriptors') && setDesc(FProto, NAME, {
  configurable: true,
  get: function(){
    var match = ('' + this).match(nameRE)
      , name  = match ? match[1] : '';
    has(this, NAME) || setDesc(this, NAME, createDesc(5, name));
    return name;
  }
});
},{"./$":46,"./$.descriptors":19,"./$.has":30,"./$.property-desc":59}],96:[function(require,module,exports){
'use strict';
var strong = require('./$.collection-strong');

// 23.1 Map Objects
require('./$.collection')('Map', function(get){
  return function Map(){ return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.1.3.6 Map.prototype.get(key)
  get: function get(key){
    var entry = strong.getEntry(this, key);
    return entry && entry.v;
  },
  // 23.1.3.9 Map.prototype.set(key, value)
  set: function set(key, value){
    return strong.def(this, key === 0 ? 0 : key, value);
  }
}, strong, true);
},{"./$.collection":15,"./$.collection-strong":12}],97:[function(require,module,exports){
// 20.2.2.3 Math.acosh(x)
var $export = require('./$.export')
  , log1p   = require('./$.math-log1p')
  , sqrt    = Math.sqrt
  , $acosh  = Math.acosh;

// V8 bug https://code.google.com/p/v8/issues/detail?id=3509
$export($export.S + $export.F * !($acosh && Math.floor($acosh(Number.MAX_VALUE)) == 710), 'Math', {
  acosh: function acosh(x){
    return (x = +x) < 1 ? NaN : x > 94906265.62425156
      ? Math.log(x) + Math.LN2
      : log1p(x - 1 + sqrt(x - 1) * sqrt(x + 1));
  }
});
},{"./$.export":22,"./$.math-log1p":50}],98:[function(require,module,exports){
// 20.2.2.5 Math.asinh(x)
var $export = require('./$.export');

function asinh(x){
  return !isFinite(x = +x) || x == 0 ? x : x < 0 ? -asinh(-x) : Math.log(x + Math.sqrt(x * x + 1));
}

$export($export.S, 'Math', {asinh: asinh});
},{"./$.export":22}],99:[function(require,module,exports){
// 20.2.2.7 Math.atanh(x)
var $export = require('./$.export');

$export($export.S, 'Math', {
  atanh: function atanh(x){
    return (x = +x) == 0 ? x : Math.log((1 + x) / (1 - x)) / 2;
  }
});
},{"./$.export":22}],100:[function(require,module,exports){
// 20.2.2.9 Math.cbrt(x)
var $export = require('./$.export')
  , sign    = require('./$.math-sign');

$export($export.S, 'Math', {
  cbrt: function cbrt(x){
    return sign(x = +x) * Math.pow(Math.abs(x), 1 / 3);
  }
});
},{"./$.export":22,"./$.math-sign":51}],101:[function(require,module,exports){
// 20.2.2.11 Math.clz32(x)
var $export = require('./$.export');

$export($export.S, 'Math', {
  clz32: function clz32(x){
    return (x >>>= 0) ? 31 - Math.floor(Math.log(x + 0.5) * Math.LOG2E) : 32;
  }
});
},{"./$.export":22}],102:[function(require,module,exports){
// 20.2.2.12 Math.cosh(x)
var $export = require('./$.export')
  , exp     = Math.exp;

$export($export.S, 'Math', {
  cosh: function cosh(x){
    return (exp(x = +x) + exp(-x)) / 2;
  }
});
},{"./$.export":22}],103:[function(require,module,exports){
// 20.2.2.14 Math.expm1(x)
var $export = require('./$.export');

$export($export.S, 'Math', {expm1: require('./$.math-expm1')});
},{"./$.export":22,"./$.math-expm1":49}],104:[function(require,module,exports){
// 20.2.2.16 Math.fround(x)
var $export   = require('./$.export')
  , sign      = require('./$.math-sign')
  , pow       = Math.pow
  , EPSILON   = pow(2, -52)
  , EPSILON32 = pow(2, -23)
  , MAX32     = pow(2, 127) * (2 - EPSILON32)
  , MIN32     = pow(2, -126);

var roundTiesToEven = function(n){
  return n + 1 / EPSILON - 1 / EPSILON;
};


$export($export.S, 'Math', {
  fround: function fround(x){
    var $abs  = Math.abs(x)
      , $sign = sign(x)
      , a, result;
    if($abs < MIN32)return $sign * roundTiesToEven($abs / MIN32 / EPSILON32) * MIN32 * EPSILON32;
    a = (1 + EPSILON32 / EPSILON) * $abs;
    result = a - (a - $abs);
    if(result > MAX32 || result != result)return $sign * Infinity;
    return $sign * result;
  }
});
},{"./$.export":22,"./$.math-sign":51}],105:[function(require,module,exports){
// 20.2.2.17 Math.hypot([value1[, value2[, … ]]])
var $export = require('./$.export')
  , abs     = Math.abs;

$export($export.S, 'Math', {
  hypot: function hypot(value1, value2){ // eslint-disable-line no-unused-vars
    var sum   = 0
      , i     = 0
      , $$    = arguments
      , $$len = $$.length
      , larg  = 0
      , arg, div;
    while(i < $$len){
      arg = abs($$[i++]);
      if(larg < arg){
        div  = larg / arg;
        sum  = sum * div * div + 1;
        larg = arg;
      } else if(arg > 0){
        div  = arg / larg;
        sum += div * div;
      } else sum += arg;
    }
    return larg === Infinity ? Infinity : larg * Math.sqrt(sum);
  }
});
},{"./$.export":22}],106:[function(require,module,exports){
// 20.2.2.18 Math.imul(x, y)
var $export = require('./$.export')
  , $imul   = Math.imul;

// some WebKit versions fails with big numbers, some has wrong arity
$export($export.S + $export.F * require('./$.fails')(function(){
  return $imul(0xffffffff, 5) != -5 || $imul.length != 2;
}), 'Math', {
  imul: function imul(x, y){
    var UINT16 = 0xffff
      , xn = +x
      , yn = +y
      , xl = UINT16 & xn
      , yl = UINT16 & yn;
    return 0 | xl * yl + ((UINT16 & xn >>> 16) * yl + xl * (UINT16 & yn >>> 16) << 16 >>> 0);
  }
});
},{"./$.export":22,"./$.fails":24}],107:[function(require,module,exports){
// 20.2.2.21 Math.log10(x)
var $export = require('./$.export');

$export($export.S, 'Math', {
  log10: function log10(x){
    return Math.log(x) / Math.LN10;
  }
});
},{"./$.export":22}],108:[function(require,module,exports){
// 20.2.2.20 Math.log1p(x)
var $export = require('./$.export');

$export($export.S, 'Math', {log1p: require('./$.math-log1p')});
},{"./$.export":22,"./$.math-log1p":50}],109:[function(require,module,exports){
// 20.2.2.22 Math.log2(x)
var $export = require('./$.export');

$export($export.S, 'Math', {
  log2: function log2(x){
    return Math.log(x) / Math.LN2;
  }
});
},{"./$.export":22}],110:[function(require,module,exports){
// 20.2.2.28 Math.sign(x)
var $export = require('./$.export');

$export($export.S, 'Math', {sign: require('./$.math-sign')});
},{"./$.export":22,"./$.math-sign":51}],111:[function(require,module,exports){
// 20.2.2.30 Math.sinh(x)
var $export = require('./$.export')
  , expm1   = require('./$.math-expm1')
  , exp     = Math.exp;

// V8 near Chromium 38 has a problem with very small numbers
$export($export.S + $export.F * require('./$.fails')(function(){
  return !Math.sinh(-2e-17) != -2e-17;
}), 'Math', {
  sinh: function sinh(x){
    return Math.abs(x = +x) < 1
      ? (expm1(x) - expm1(-x)) / 2
      : (exp(x - 1) - exp(-x - 1)) * (Math.E / 2);
  }
});
},{"./$.export":22,"./$.fails":24,"./$.math-expm1":49}],112:[function(require,module,exports){
// 20.2.2.33 Math.tanh(x)
var $export = require('./$.export')
  , expm1   = require('./$.math-expm1')
  , exp     = Math.exp;

$export($export.S, 'Math', {
  tanh: function tanh(x){
    var a = expm1(x = +x)
      , b = expm1(-x);
    return a == Infinity ? 1 : b == Infinity ? -1 : (a - b) / (exp(x) + exp(-x));
  }
});
},{"./$.export":22,"./$.math-expm1":49}],113:[function(require,module,exports){
// 20.2.2.34 Math.trunc(x)
var $export = require('./$.export');

$export($export.S, 'Math', {
  trunc: function trunc(it){
    return (it > 0 ? Math.floor : Math.ceil)(it);
  }
});
},{"./$.export":22}],114:[function(require,module,exports){
'use strict';
var $           = require('./$')
  , global      = require('./$.global')
  , has         = require('./$.has')
  , cof         = require('./$.cof')
  , toPrimitive = require('./$.to-primitive')
  , fails       = require('./$.fails')
  , $trim       = require('./$.string-trim').trim
  , NUMBER      = 'Number'
  , $Number     = global[NUMBER]
  , Base        = $Number
  , proto       = $Number.prototype
  // Opera ~12 has broken Object#toString
  , BROKEN_COF  = cof($.create(proto)) == NUMBER
  , TRIM        = 'trim' in String.prototype;

// 7.1.3 ToNumber(argument)
var toNumber = function(argument){
  var it = toPrimitive(argument, false);
  if(typeof it == 'string' && it.length > 2){
    it = TRIM ? it.trim() : $trim(it, 3);
    var first = it.charCodeAt(0)
      , third, radix, maxCode;
    if(first === 43 || first === 45){
      third = it.charCodeAt(2);
      if(third === 88 || third === 120)return NaN; // Number('+0x1') should be NaN, old V8 fix
    } else if(first === 48){
      switch(it.charCodeAt(1)){
        case 66 : case 98  : radix = 2; maxCode = 49; break; // fast equal /^0b[01]+$/i
        case 79 : case 111 : radix = 8; maxCode = 55; break; // fast equal /^0o[0-7]+$/i
        default : return +it;
      }
      for(var digits = it.slice(2), i = 0, l = digits.length, code; i < l; i++){
        code = digits.charCodeAt(i);
        // parseInt parses a string to a first unavailable symbol
        // but ToNumber should return NaN if a string contains unavailable symbols
        if(code < 48 || code > maxCode)return NaN;
      } return parseInt(digits, radix);
    }
  } return +it;
};

if(!$Number(' 0o1') || !$Number('0b1') || $Number('+0x1')){
  $Number = function Number(value){
    var it = arguments.length < 1 ? 0 : value
      , that = this;
    return that instanceof $Number
      // check on 1..constructor(foo) case
      && (BROKEN_COF ? fails(function(){ proto.valueOf.call(that); }) : cof(that) != NUMBER)
        ? new Base(toNumber(it)) : toNumber(it);
  };
  $.each.call(require('./$.descriptors') ? $.getNames(Base) : (
    // ES3:
    'MAX_VALUE,MIN_VALUE,NaN,NEGATIVE_INFINITY,POSITIVE_INFINITY,' +
    // ES6 (in case, if modules with ES6 Number statics required before):
    'EPSILON,isFinite,isInteger,isNaN,isSafeInteger,MAX_SAFE_INTEGER,' +
    'MIN_SAFE_INTEGER,parseFloat,parseInt,isInteger'
  ).split(','), function(key){
    if(has(Base, key) && !has($Number, key)){
      $.setDesc($Number, key, $.getDesc(Base, key));
    }
  });
  $Number.prototype = proto;
  proto.constructor = $Number;
  require('./$.redefine')(global, NUMBER, $Number);
}
},{"./$":46,"./$.cof":11,"./$.descriptors":19,"./$.fails":24,"./$.global":29,"./$.has":30,"./$.redefine":61,"./$.string-trim":74,"./$.to-primitive":81}],115:[function(require,module,exports){
// 20.1.2.1 Number.EPSILON
var $export = require('./$.export');

$export($export.S, 'Number', {EPSILON: Math.pow(2, -52)});
},{"./$.export":22}],116:[function(require,module,exports){
// 20.1.2.2 Number.isFinite(number)
var $export   = require('./$.export')
  , _isFinite = require('./$.global').isFinite;

$export($export.S, 'Number', {
  isFinite: function isFinite(it){
    return typeof it == 'number' && _isFinite(it);
  }
});
},{"./$.export":22,"./$.global":29}],117:[function(require,module,exports){
// 20.1.2.3 Number.isInteger(number)
var $export = require('./$.export');

$export($export.S, 'Number', {isInteger: require('./$.is-integer')});
},{"./$.export":22,"./$.is-integer":37}],118:[function(require,module,exports){
// 20.1.2.4 Number.isNaN(number)
var $export = require('./$.export');

$export($export.S, 'Number', {
  isNaN: function isNaN(number){
    return number != number;
  }
});
},{"./$.export":22}],119:[function(require,module,exports){
// 20.1.2.5 Number.isSafeInteger(number)
var $export   = require('./$.export')
  , isInteger = require('./$.is-integer')
  , abs       = Math.abs;

$export($export.S, 'Number', {
  isSafeInteger: function isSafeInteger(number){
    return isInteger(number) && abs(number) <= 0x1fffffffffffff;
  }
});
},{"./$.export":22,"./$.is-integer":37}],120:[function(require,module,exports){
// 20.1.2.6 Number.MAX_SAFE_INTEGER
var $export = require('./$.export');

$export($export.S, 'Number', {MAX_SAFE_INTEGER: 0x1fffffffffffff});
},{"./$.export":22}],121:[function(require,module,exports){
// 20.1.2.10 Number.MIN_SAFE_INTEGER
var $export = require('./$.export');

$export($export.S, 'Number', {MIN_SAFE_INTEGER: -0x1fffffffffffff});
},{"./$.export":22}],122:[function(require,module,exports){
// 20.1.2.12 Number.parseFloat(string)
var $export = require('./$.export');

$export($export.S, 'Number', {parseFloat: parseFloat});
},{"./$.export":22}],123:[function(require,module,exports){
// 20.1.2.13 Number.parseInt(string, radix)
var $export = require('./$.export');

$export($export.S, 'Number', {parseInt: parseInt});
},{"./$.export":22}],124:[function(require,module,exports){
// 19.1.3.1 Object.assign(target, source)
var $export = require('./$.export');

$export($export.S + $export.F, 'Object', {assign: require('./$.object-assign')});
},{"./$.export":22,"./$.object-assign":53}],125:[function(require,module,exports){
// 19.1.2.5 Object.freeze(O)
var isObject = require('./$.is-object');

require('./$.object-sap')('freeze', function($freeze){
  return function freeze(it){
    return $freeze && isObject(it) ? $freeze(it) : it;
  };
});
},{"./$.is-object":38,"./$.object-sap":54}],126:[function(require,module,exports){
// 19.1.2.6 Object.getOwnPropertyDescriptor(O, P)
var toIObject = require('./$.to-iobject');

require('./$.object-sap')('getOwnPropertyDescriptor', function($getOwnPropertyDescriptor){
  return function getOwnPropertyDescriptor(it, key){
    return $getOwnPropertyDescriptor(toIObject(it), key);
  };
});
},{"./$.object-sap":54,"./$.to-iobject":78}],127:[function(require,module,exports){
// 19.1.2.7 Object.getOwnPropertyNames(O)
require('./$.object-sap')('getOwnPropertyNames', function(){
  return require('./$.get-names').get;
});
},{"./$.get-names":28,"./$.object-sap":54}],128:[function(require,module,exports){
// 19.1.2.9 Object.getPrototypeOf(O)
var toObject = require('./$.to-object');

require('./$.object-sap')('getPrototypeOf', function($getPrototypeOf){
  return function getPrototypeOf(it){
    return $getPrototypeOf(toObject(it));
  };
});
},{"./$.object-sap":54,"./$.to-object":80}],129:[function(require,module,exports){
// 19.1.2.11 Object.isExtensible(O)
var isObject = require('./$.is-object');

require('./$.object-sap')('isExtensible', function($isExtensible){
  return function isExtensible(it){
    return isObject(it) ? $isExtensible ? $isExtensible(it) : true : false;
  };
});
},{"./$.is-object":38,"./$.object-sap":54}],130:[function(require,module,exports){
// 19.1.2.12 Object.isFrozen(O)
var isObject = require('./$.is-object');

require('./$.object-sap')('isFrozen', function($isFrozen){
  return function isFrozen(it){
    return isObject(it) ? $isFrozen ? $isFrozen(it) : false : true;
  };
});
},{"./$.is-object":38,"./$.object-sap":54}],131:[function(require,module,exports){
// 19.1.2.13 Object.isSealed(O)
var isObject = require('./$.is-object');

require('./$.object-sap')('isSealed', function($isSealed){
  return function isSealed(it){
    return isObject(it) ? $isSealed ? $isSealed(it) : false : true;
  };
});
},{"./$.is-object":38,"./$.object-sap":54}],132:[function(require,module,exports){
// 19.1.3.10 Object.is(value1, value2)
var $export = require('./$.export');
$export($export.S, 'Object', {is: require('./$.same-value')});
},{"./$.export":22,"./$.same-value":63}],133:[function(require,module,exports){
// 19.1.2.14 Object.keys(O)
var toObject = require('./$.to-object');

require('./$.object-sap')('keys', function($keys){
  return function keys(it){
    return $keys(toObject(it));
  };
});
},{"./$.object-sap":54,"./$.to-object":80}],134:[function(require,module,exports){
// 19.1.2.15 Object.preventExtensions(O)
var isObject = require('./$.is-object');

require('./$.object-sap')('preventExtensions', function($preventExtensions){
  return function preventExtensions(it){
    return $preventExtensions && isObject(it) ? $preventExtensions(it) : it;
  };
});
},{"./$.is-object":38,"./$.object-sap":54}],135:[function(require,module,exports){
// 19.1.2.17 Object.seal(O)
var isObject = require('./$.is-object');

require('./$.object-sap')('seal', function($seal){
  return function seal(it){
    return $seal && isObject(it) ? $seal(it) : it;
  };
});
},{"./$.is-object":38,"./$.object-sap":54}],136:[function(require,module,exports){
// 19.1.3.19 Object.setPrototypeOf(O, proto)
var $export = require('./$.export');
$export($export.S, 'Object', {setPrototypeOf: require('./$.set-proto').set});
},{"./$.export":22,"./$.set-proto":64}],137:[function(require,module,exports){
'use strict';
// 19.1.3.6 Object.prototype.toString()
var classof = require('./$.classof')
  , test    = {};
test[require('./$.wks')('toStringTag')] = 'z';
if(test + '' != '[object z]'){
  require('./$.redefine')(Object.prototype, 'toString', function toString(){
    return '[object ' + classof(this) + ']';
  }, true);
}
},{"./$.classof":10,"./$.redefine":61,"./$.wks":83}],138:[function(require,module,exports){
'use strict';
var $          = require('./$')
  , LIBRARY    = require('./$.library')
  , global     = require('./$.global')
  , ctx        = require('./$.ctx')
  , classof    = require('./$.classof')
  , $export    = require('./$.export')
  , isObject   = require('./$.is-object')
  , anObject   = require('./$.an-object')
  , aFunction  = require('./$.a-function')
  , strictNew  = require('./$.strict-new')
  , forOf      = require('./$.for-of')
  , setProto   = require('./$.set-proto').set
  , same       = require('./$.same-value')
  , SPECIES    = require('./$.wks')('species')
  , speciesConstructor = require('./$.species-constructor')
  , asap       = require('./$.microtask')
  , PROMISE    = 'Promise'
  , process    = global.process
  , isNode     = classof(process) == 'process'
  , P          = global[PROMISE]
  , empty      = function(){ /* empty */ }
  , Wrapper;

var testResolve = function(sub){
  var test = new P(empty), promise;
  if(sub)test.constructor = function(exec){
    exec(empty, empty);
  };
  (promise = P.resolve(test))['catch'](empty);
  return promise === test;
};

var USE_NATIVE = function(){
  var works = false;
  function P2(x){
    var self = new P(x);
    setProto(self, P2.prototype);
    return self;
  }
  try {
    works = P && P.resolve && testResolve();
    setProto(P2, P);
    P2.prototype = $.create(P.prototype, {constructor: {value: P2}});
    // actual Firefox has broken subclass support, test that
    if(!(P2.resolve(5).then(function(){}) instanceof P2)){
      works = false;
    }
    // actual V8 bug, https://code.google.com/p/v8/issues/detail?id=4162
    if(works && require('./$.descriptors')){
      var thenableThenGotten = false;
      P.resolve($.setDesc({}, 'then', {
        get: function(){ thenableThenGotten = true; }
      }));
      works = thenableThenGotten;
    }
  } catch(e){ works = false; }
  return works;
}();

// helpers
var sameConstructor = function(a, b){
  // library wrapper special case
  if(LIBRARY && a === P && b === Wrapper)return true;
  return same(a, b);
};
var getConstructor = function(C){
  var S = anObject(C)[SPECIES];
  return S != undefined ? S : C;
};
var isThenable = function(it){
  var then;
  return isObject(it) && typeof (then = it.then) == 'function' ? then : false;
};
var PromiseCapability = function(C){
  var resolve, reject;
  this.promise = new C(function($$resolve, $$reject){
    if(resolve !== undefined || reject !== undefined)throw TypeError('Bad Promise constructor');
    resolve = $$resolve;
    reject  = $$reject;
  });
  this.resolve = aFunction(resolve),
  this.reject  = aFunction(reject)
};
var perform = function(exec){
  try {
    exec();
  } catch(e){
    return {error: e};
  }
};
var notify = function(record, isReject){
  if(record.n)return;
  record.n = true;
  var chain = record.c;
  asap(function(){
    var value = record.v
      , ok    = record.s == 1
      , i     = 0;
    var run = function(reaction){
      var handler = ok ? reaction.ok : reaction.fail
        , resolve = reaction.resolve
        , reject  = reaction.reject
        , result, then;
      try {
        if(handler){
          if(!ok)record.h = true;
          result = handler === true ? value : handler(value);
          if(result === reaction.promise){
            reject(TypeError('Promise-chain cycle'));
          } else if(then = isThenable(result)){
            then.call(result, resolve, reject);
          } else resolve(result);
        } else reject(value);
      } catch(e){
        reject(e);
      }
    };
    while(chain.length > i)run(chain[i++]); // variable length - can't use forEach
    chain.length = 0;
    record.n = false;
    if(isReject)setTimeout(function(){
      var promise = record.p
        , handler, console;
      if(isUnhandled(promise)){
        if(isNode){
          process.emit('unhandledRejection', value, promise);
        } else if(handler = global.onunhandledrejection){
          handler({promise: promise, reason: value});
        } else if((console = global.console) && console.error){
          console.error('Unhandled promise rejection', value);
        }
      } record.a = undefined;
    }, 1);
  });
};
var isUnhandled = function(promise){
  var record = promise._d
    , chain  = record.a || record.c
    , i      = 0
    , reaction;
  if(record.h)return false;
  while(chain.length > i){
    reaction = chain[i++];
    if(reaction.fail || !isUnhandled(reaction.promise))return false;
  } return true;
};
var $reject = function(value){
  var record = this;
  if(record.d)return;
  record.d = true;
  record = record.r || record; // unwrap
  record.v = value;
  record.s = 2;
  record.a = record.c.slice();
  notify(record, true);
};
var $resolve = function(value){
  var record = this
    , then;
  if(record.d)return;
  record.d = true;
  record = record.r || record; // unwrap
  try {
    if(record.p === value)throw TypeError("Promise can't be resolved itself");
    if(then = isThenable(value)){
      asap(function(){
        var wrapper = {r: record, d: false}; // wrap
        try {
          then.call(value, ctx($resolve, wrapper, 1), ctx($reject, wrapper, 1));
        } catch(e){
          $reject.call(wrapper, e);
        }
      });
    } else {
      record.v = value;
      record.s = 1;
      notify(record, false);
    }
  } catch(e){
    $reject.call({r: record, d: false}, e); // wrap
  }
};

// constructor polyfill
if(!USE_NATIVE){
  // 25.4.3.1 Promise(executor)
  P = function Promise(executor){
    aFunction(executor);
    var record = this._d = {
      p: strictNew(this, P, PROMISE),         // <- promise
      c: [],                                  // <- awaiting reactions
      a: undefined,                           // <- checked in isUnhandled reactions
      s: 0,                                   // <- state
      d: false,                               // <- done
      v: undefined,                           // <- value
      h: false,                               // <- handled rejection
      n: false                                // <- notify
    };
    try {
      executor(ctx($resolve, record, 1), ctx($reject, record, 1));
    } catch(err){
      $reject.call(record, err);
    }
  };
  require('./$.redefine-all')(P.prototype, {
    // 25.4.5.3 Promise.prototype.then(onFulfilled, onRejected)
    then: function then(onFulfilled, onRejected){
      var reaction = new PromiseCapability(speciesConstructor(this, P))
        , promise  = reaction.promise
        , record   = this._d;
      reaction.ok   = typeof onFulfilled == 'function' ? onFulfilled : true;
      reaction.fail = typeof onRejected == 'function' && onRejected;
      record.c.push(reaction);
      if(record.a)record.a.push(reaction);
      if(record.s)notify(record, false);
      return promise;
    },
    // 25.4.5.1 Promise.prototype.catch(onRejected)
    'catch': function(onRejected){
      return this.then(undefined, onRejected);
    }
  });
}

$export($export.G + $export.W + $export.F * !USE_NATIVE, {Promise: P});
require('./$.set-to-string-tag')(P, PROMISE);
require('./$.set-species')(PROMISE);
Wrapper = require('./$.core')[PROMISE];

// statics
$export($export.S + $export.F * !USE_NATIVE, PROMISE, {
  // 25.4.4.5 Promise.reject(r)
  reject: function reject(r){
    var capability = new PromiseCapability(this)
      , $$reject   = capability.reject;
    $$reject(r);
    return capability.promise;
  }
});
$export($export.S + $export.F * (!USE_NATIVE || testResolve(true)), PROMISE, {
  // 25.4.4.6 Promise.resolve(x)
  resolve: function resolve(x){
    // instanceof instead of internal slot check because we should fix it without replacement native Promise core
    if(x instanceof P && sameConstructor(x.constructor, this))return x;
    var capability = new PromiseCapability(this)
      , $$resolve  = capability.resolve;
    $$resolve(x);
    return capability.promise;
  }
});
$export($export.S + $export.F * !(USE_NATIVE && require('./$.iter-detect')(function(iter){
  P.all(iter)['catch'](function(){});
})), PROMISE, {
  // 25.4.4.1 Promise.all(iterable)
  all: function all(iterable){
    var C          = getConstructor(this)
      , capability = new PromiseCapability(C)
      , resolve    = capability.resolve
      , reject     = capability.reject
      , values     = [];
    var abrupt = perform(function(){
      forOf(iterable, false, values.push, values);
      var remaining = values.length
        , results   = Array(remaining);
      if(remaining)$.each.call(values, function(promise, index){
        var alreadyCalled = false;
        C.resolve(promise).then(function(value){
          if(alreadyCalled)return;
          alreadyCalled = true;
          results[index] = value;
          --remaining || resolve(results);
        }, reject);
      });
      else resolve(results);
    });
    if(abrupt)reject(abrupt.error);
    return capability.promise;
  },
  // 25.4.4.4 Promise.race(iterable)
  race: function race(iterable){
    var C          = getConstructor(this)
      , capability = new PromiseCapability(C)
      , reject     = capability.reject;
    var abrupt = perform(function(){
      forOf(iterable, false, function(promise){
        C.resolve(promise).then(capability.resolve, reject);
      });
    });
    if(abrupt)reject(abrupt.error);
    return capability.promise;
  }
});
},{"./$":46,"./$.a-function":2,"./$.an-object":4,"./$.classof":10,"./$.core":16,"./$.ctx":17,"./$.descriptors":19,"./$.export":22,"./$.for-of":27,"./$.global":29,"./$.is-object":38,"./$.iter-detect":43,"./$.library":48,"./$.microtask":52,"./$.redefine-all":60,"./$.same-value":63,"./$.set-proto":64,"./$.set-species":65,"./$.set-to-string-tag":66,"./$.species-constructor":68,"./$.strict-new":69,"./$.wks":83}],139:[function(require,module,exports){
// 26.1.1 Reflect.apply(target, thisArgument, argumentsList)
var $export  = require('./$.export')
  , _apply   = Function.apply
  , anObject = require('./$.an-object');

$export($export.S, 'Reflect', {
  apply: function apply(target, thisArgument, argumentsList){
    return _apply.call(target, thisArgument, anObject(argumentsList));
  }
});
},{"./$.an-object":4,"./$.export":22}],140:[function(require,module,exports){
// 26.1.2 Reflect.construct(target, argumentsList [, newTarget])
var $         = require('./$')
  , $export   = require('./$.export')
  , aFunction = require('./$.a-function')
  , anObject  = require('./$.an-object')
  , isObject  = require('./$.is-object')
  , bind      = Function.bind || require('./$.core').Function.prototype.bind;

// MS Edge supports only 2 arguments
// FF Nightly sets third argument as `new.target`, but does not create `this` from it
$export($export.S + $export.F * require('./$.fails')(function(){
  function F(){}
  return !(Reflect.construct(function(){}, [], F) instanceof F);
}), 'Reflect', {
  construct: function construct(Target, args /*, newTarget*/){
    aFunction(Target);
    anObject(args);
    var newTarget = arguments.length < 3 ? Target : aFunction(arguments[2]);
    if(Target == newTarget){
      // w/o altered newTarget, optimization for 0-4 arguments
      switch(args.length){
        case 0: return new Target;
        case 1: return new Target(args[0]);
        case 2: return new Target(args[0], args[1]);
        case 3: return new Target(args[0], args[1], args[2]);
        case 4: return new Target(args[0], args[1], args[2], args[3]);
      }
      // w/o altered newTarget, lot of arguments case
      var $args = [null];
      $args.push.apply($args, args);
      return new (bind.apply(Target, $args));
    }
    // with altered newTarget, not support built-in constructors
    var proto    = newTarget.prototype
      , instance = $.create(isObject(proto) ? proto : Object.prototype)
      , result   = Function.apply.call(Target, instance, args);
    return isObject(result) ? result : instance;
  }
});
},{"./$":46,"./$.a-function":2,"./$.an-object":4,"./$.core":16,"./$.export":22,"./$.fails":24,"./$.is-object":38}],141:[function(require,module,exports){
// 26.1.3 Reflect.defineProperty(target, propertyKey, attributes)
var $        = require('./$')
  , $export  = require('./$.export')
  , anObject = require('./$.an-object');

// MS Edge has broken Reflect.defineProperty - throwing instead of returning false
$export($export.S + $export.F * require('./$.fails')(function(){
  Reflect.defineProperty($.setDesc({}, 1, {value: 1}), 1, {value: 2});
}), 'Reflect', {
  defineProperty: function defineProperty(target, propertyKey, attributes){
    anObject(target);
    try {
      $.setDesc(target, propertyKey, attributes);
      return true;
    } catch(e){
      return false;
    }
  }
});
},{"./$":46,"./$.an-object":4,"./$.export":22,"./$.fails":24}],142:[function(require,module,exports){
// 26.1.4 Reflect.deleteProperty(target, propertyKey)
var $export  = require('./$.export')
  , getDesc  = require('./$').getDesc
  , anObject = require('./$.an-object');

$export($export.S, 'Reflect', {
  deleteProperty: function deleteProperty(target, propertyKey){
    var desc = getDesc(anObject(target), propertyKey);
    return desc && !desc.configurable ? false : delete target[propertyKey];
  }
});
},{"./$":46,"./$.an-object":4,"./$.export":22}],143:[function(require,module,exports){
'use strict';
// 26.1.5 Reflect.enumerate(target)
var $export  = require('./$.export')
  , anObject = require('./$.an-object');
var Enumerate = function(iterated){
  this._t = anObject(iterated); // target
  this._i = 0;                  // next index
  var keys = this._k = []       // keys
    , key;
  for(key in iterated)keys.push(key);
};
require('./$.iter-create')(Enumerate, 'Object', function(){
  var that = this
    , keys = that._k
    , key;
  do {
    if(that._i >= keys.length)return {value: undefined, done: true};
  } while(!((key = keys[that._i++]) in that._t));
  return {value: key, done: false};
});

$export($export.S, 'Reflect', {
  enumerate: function enumerate(target){
    return new Enumerate(target);
  }
});
},{"./$.an-object":4,"./$.export":22,"./$.iter-create":41}],144:[function(require,module,exports){
// 26.1.7 Reflect.getOwnPropertyDescriptor(target, propertyKey)
var $        = require('./$')
  , $export  = require('./$.export')
  , anObject = require('./$.an-object');

$export($export.S, 'Reflect', {
  getOwnPropertyDescriptor: function getOwnPropertyDescriptor(target, propertyKey){
    return $.getDesc(anObject(target), propertyKey);
  }
});
},{"./$":46,"./$.an-object":4,"./$.export":22}],145:[function(require,module,exports){
// 26.1.8 Reflect.getPrototypeOf(target)
var $export  = require('./$.export')
  , getProto = require('./$').getProto
  , anObject = require('./$.an-object');

$export($export.S, 'Reflect', {
  getPrototypeOf: function getPrototypeOf(target){
    return getProto(anObject(target));
  }
});
},{"./$":46,"./$.an-object":4,"./$.export":22}],146:[function(require,module,exports){
// 26.1.6 Reflect.get(target, propertyKey [, receiver])
var $        = require('./$')
  , has      = require('./$.has')
  , $export  = require('./$.export')
  , isObject = require('./$.is-object')
  , anObject = require('./$.an-object');

function get(target, propertyKey/*, receiver*/){
  var receiver = arguments.length < 3 ? target : arguments[2]
    , desc, proto;
  if(anObject(target) === receiver)return target[propertyKey];
  if(desc = $.getDesc(target, propertyKey))return has(desc, 'value')
    ? desc.value
    : desc.get !== undefined
      ? desc.get.call(receiver)
      : undefined;
  if(isObject(proto = $.getProto(target)))return get(proto, propertyKey, receiver);
}

$export($export.S, 'Reflect', {get: get});
},{"./$":46,"./$.an-object":4,"./$.export":22,"./$.has":30,"./$.is-object":38}],147:[function(require,module,exports){
// 26.1.9 Reflect.has(target, propertyKey)
var $export = require('./$.export');

$export($export.S, 'Reflect', {
  has: function has(target, propertyKey){
    return propertyKey in target;
  }
});
},{"./$.export":22}],148:[function(require,module,exports){
// 26.1.10 Reflect.isExtensible(target)
var $export       = require('./$.export')
  , anObject      = require('./$.an-object')
  , $isExtensible = Object.isExtensible;

$export($export.S, 'Reflect', {
  isExtensible: function isExtensible(target){
    anObject(target);
    return $isExtensible ? $isExtensible(target) : true;
  }
});
},{"./$.an-object":4,"./$.export":22}],149:[function(require,module,exports){
// 26.1.11 Reflect.ownKeys(target)
var $export = require('./$.export');

$export($export.S, 'Reflect', {ownKeys: require('./$.own-keys')});
},{"./$.export":22,"./$.own-keys":56}],150:[function(require,module,exports){
// 26.1.12 Reflect.preventExtensions(target)
var $export            = require('./$.export')
  , anObject           = require('./$.an-object')
  , $preventExtensions = Object.preventExtensions;

$export($export.S, 'Reflect', {
  preventExtensions: function preventExtensions(target){
    anObject(target);
    try {
      if($preventExtensions)$preventExtensions(target);
      return true;
    } catch(e){
      return false;
    }
  }
});
},{"./$.an-object":4,"./$.export":22}],151:[function(require,module,exports){
// 26.1.14 Reflect.setPrototypeOf(target, proto)
var $export  = require('./$.export')
  , setProto = require('./$.set-proto');

if(setProto)$export($export.S, 'Reflect', {
  setPrototypeOf: function setPrototypeOf(target, proto){
    setProto.check(target, proto);
    try {
      setProto.set(target, proto);
      return true;
    } catch(e){
      return false;
    }
  }
});
},{"./$.export":22,"./$.set-proto":64}],152:[function(require,module,exports){
// 26.1.13 Reflect.set(target, propertyKey, V [, receiver])
var $          = require('./$')
  , has        = require('./$.has')
  , $export    = require('./$.export')
  , createDesc = require('./$.property-desc')
  , anObject   = require('./$.an-object')
  , isObject   = require('./$.is-object');

function set(target, propertyKey, V/*, receiver*/){
  var receiver = arguments.length < 4 ? target : arguments[3]
    , ownDesc  = $.getDesc(anObject(target), propertyKey)
    , existingDescriptor, proto;
  if(!ownDesc){
    if(isObject(proto = $.getProto(target))){
      return set(proto, propertyKey, V, receiver);
    }
    ownDesc = createDesc(0);
  }
  if(has(ownDesc, 'value')){
    if(ownDesc.writable === false || !isObject(receiver))return false;
    existingDescriptor = $.getDesc(receiver, propertyKey) || createDesc(0);
    existingDescriptor.value = V;
    $.setDesc(receiver, propertyKey, existingDescriptor);
    return true;
  }
  return ownDesc.set === undefined ? false : (ownDesc.set.call(receiver, V), true);
}

$export($export.S, 'Reflect', {set: set});
},{"./$":46,"./$.an-object":4,"./$.export":22,"./$.has":30,"./$.is-object":38,"./$.property-desc":59}],153:[function(require,module,exports){
var $        = require('./$')
  , global   = require('./$.global')
  , isRegExp = require('./$.is-regexp')
  , $flags   = require('./$.flags')
  , $RegExp  = global.RegExp
  , Base     = $RegExp
  , proto    = $RegExp.prototype
  , re1      = /a/g
  , re2      = /a/g
  // "new" creates a new object, old webkit buggy here
  , CORRECT_NEW = new $RegExp(re1) !== re1;

if(require('./$.descriptors') && (!CORRECT_NEW || require('./$.fails')(function(){
  re2[require('./$.wks')('match')] = false;
  // RegExp constructor can alter flags and IsRegExp works correct with @@match
  return $RegExp(re1) != re1 || $RegExp(re2) == re2 || $RegExp(re1, 'i') != '/a/i';
}))){
  $RegExp = function RegExp(p, f){
    var piRE = isRegExp(p)
      , fiU  = f === undefined;
    return !(this instanceof $RegExp) && piRE && p.constructor === $RegExp && fiU ? p
      : CORRECT_NEW
        ? new Base(piRE && !fiU ? p.source : p, f)
        : Base((piRE = p instanceof $RegExp) ? p.source : p, piRE && fiU ? $flags.call(p) : f);
  };
  $.each.call($.getNames(Base), function(key){
    key in $RegExp || $.setDesc($RegExp, key, {
      configurable: true,
      get: function(){ return Base[key]; },
      set: function(it){ Base[key] = it; }
    });
  });
  proto.constructor = $RegExp;
  $RegExp.prototype = proto;
  require('./$.redefine')(global, 'RegExp', $RegExp);
}

require('./$.set-species')('RegExp');
},{"./$":46,"./$.descriptors":19,"./$.fails":24,"./$.flags":26,"./$.global":29,"./$.is-regexp":39,"./$.redefine":61,"./$.set-species":65,"./$.wks":83}],154:[function(require,module,exports){
// 21.2.5.3 get RegExp.prototype.flags()
var $ = require('./$');
if(require('./$.descriptors') && /./g.flags != 'g')$.setDesc(RegExp.prototype, 'flags', {
  configurable: true,
  get: require('./$.flags')
});
},{"./$":46,"./$.descriptors":19,"./$.flags":26}],155:[function(require,module,exports){
// @@match logic
require('./$.fix-re-wks')('match', 1, function(defined, MATCH){
  // 21.1.3.11 String.prototype.match(regexp)
  return function match(regexp){
    'use strict';
    var O  = defined(this)
      , fn = regexp == undefined ? undefined : regexp[MATCH];
    return fn !== undefined ? fn.call(regexp, O) : new RegExp(regexp)[MATCH](String(O));
  };
});
},{"./$.fix-re-wks":25}],156:[function(require,module,exports){
// @@replace logic
require('./$.fix-re-wks')('replace', 2, function(defined, REPLACE, $replace){
  // 21.1.3.14 String.prototype.replace(searchValue, replaceValue)
  return function replace(searchValue, replaceValue){
    'use strict';
    var O  = defined(this)
      , fn = searchValue == undefined ? undefined : searchValue[REPLACE];
    return fn !== undefined
      ? fn.call(searchValue, O, replaceValue)
      : $replace.call(String(O), searchValue, replaceValue);
  };
});
},{"./$.fix-re-wks":25}],157:[function(require,module,exports){
// @@search logic
require('./$.fix-re-wks')('search', 1, function(defined, SEARCH){
  // 21.1.3.15 String.prototype.search(regexp)
  return function search(regexp){
    'use strict';
    var O  = defined(this)
      , fn = regexp == undefined ? undefined : regexp[SEARCH];
    return fn !== undefined ? fn.call(regexp, O) : new RegExp(regexp)[SEARCH](String(O));
  };
});
},{"./$.fix-re-wks":25}],158:[function(require,module,exports){
// @@split logic
require('./$.fix-re-wks')('split', 2, function(defined, SPLIT, $split){
  // 21.1.3.17 String.prototype.split(separator, limit)
  return function split(separator, limit){
    'use strict';
    var O  = defined(this)
      , fn = separator == undefined ? undefined : separator[SPLIT];
    return fn !== undefined
      ? fn.call(separator, O, limit)
      : $split.call(String(O), separator, limit);
  };
});
},{"./$.fix-re-wks":25}],159:[function(require,module,exports){
'use strict';
var strong = require('./$.collection-strong');

// 23.2 Set Objects
require('./$.collection')('Set', function(get){
  return function Set(){ return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.2.3.1 Set.prototype.add(value)
  add: function add(value){
    return strong.def(this, value = value === 0 ? 0 : value, value);
  }
}, strong);
},{"./$.collection":15,"./$.collection-strong":12}],160:[function(require,module,exports){
'use strict';
var $export = require('./$.export')
  , $at     = require('./$.string-at')(false);
$export($export.P, 'String', {
  // 21.1.3.3 String.prototype.codePointAt(pos)
  codePointAt: function codePointAt(pos){
    return $at(this, pos);
  }
});
},{"./$.export":22,"./$.string-at":70}],161:[function(require,module,exports){
// 21.1.3.6 String.prototype.endsWith(searchString [, endPosition])
'use strict';
var $export   = require('./$.export')
  , toLength  = require('./$.to-length')
  , context   = require('./$.string-context')
  , ENDS_WITH = 'endsWith'
  , $endsWith = ''[ENDS_WITH];

$export($export.P + $export.F * require('./$.fails-is-regexp')(ENDS_WITH), 'String', {
  endsWith: function endsWith(searchString /*, endPosition = @length */){
    var that = context(this, searchString, ENDS_WITH)
      , $$   = arguments
      , endPosition = $$.length > 1 ? $$[1] : undefined
      , len    = toLength(that.length)
      , end    = endPosition === undefined ? len : Math.min(toLength(endPosition), len)
      , search = String(searchString);
    return $endsWith
      ? $endsWith.call(that, search, end)
      : that.slice(end - search.length, end) === search;
  }
});
},{"./$.export":22,"./$.fails-is-regexp":23,"./$.string-context":71,"./$.to-length":79}],162:[function(require,module,exports){
var $export        = require('./$.export')
  , toIndex        = require('./$.to-index')
  , fromCharCode   = String.fromCharCode
  , $fromCodePoint = String.fromCodePoint;

// length should be 1, old FF problem
$export($export.S + $export.F * (!!$fromCodePoint && $fromCodePoint.length != 1), 'String', {
  // 21.1.2.2 String.fromCodePoint(...codePoints)
  fromCodePoint: function fromCodePoint(x){ // eslint-disable-line no-unused-vars
    var res   = []
      , $$    = arguments
      , $$len = $$.length
      , i     = 0
      , code;
    while($$len > i){
      code = +$$[i++];
      if(toIndex(code, 0x10ffff) !== code)throw RangeError(code + ' is not a valid code point');
      res.push(code < 0x10000
        ? fromCharCode(code)
        : fromCharCode(((code -= 0x10000) >> 10) + 0xd800, code % 0x400 + 0xdc00)
      );
    } return res.join('');
  }
});
},{"./$.export":22,"./$.to-index":76}],163:[function(require,module,exports){
// 21.1.3.7 String.prototype.includes(searchString, position = 0)
'use strict';
var $export  = require('./$.export')
  , context  = require('./$.string-context')
  , INCLUDES = 'includes';

$export($export.P + $export.F * require('./$.fails-is-regexp')(INCLUDES), 'String', {
  includes: function includes(searchString /*, position = 0 */){
    return !!~context(this, searchString, INCLUDES)
      .indexOf(searchString, arguments.length > 1 ? arguments[1] : undefined);
  }
});
},{"./$.export":22,"./$.fails-is-regexp":23,"./$.string-context":71}],164:[function(require,module,exports){
'use strict';
var $at  = require('./$.string-at')(true);

// 21.1.3.27 String.prototype[@@iterator]()
require('./$.iter-define')(String, 'String', function(iterated){
  this._t = String(iterated); // target
  this._i = 0;                // next index
// 21.1.5.2.1 %StringIteratorPrototype%.next()
}, function(){
  var O     = this._t
    , index = this._i
    , point;
  if(index >= O.length)return {value: undefined, done: true};
  point = $at(O, index);
  this._i += point.length;
  return {value: point, done: false};
});
},{"./$.iter-define":42,"./$.string-at":70}],165:[function(require,module,exports){
var $export   = require('./$.export')
  , toIObject = require('./$.to-iobject')
  , toLength  = require('./$.to-length');

$export($export.S, 'String', {
  // 21.1.2.4 String.raw(callSite, ...substitutions)
  raw: function raw(callSite){
    var tpl   = toIObject(callSite.raw)
      , len   = toLength(tpl.length)
      , $$    = arguments
      , $$len = $$.length
      , res   = []
      , i     = 0;
    while(len > i){
      res.push(String(tpl[i++]));
      if(i < $$len)res.push(String($$[i]));
    } return res.join('');
  }
});
},{"./$.export":22,"./$.to-iobject":78,"./$.to-length":79}],166:[function(require,module,exports){
var $export = require('./$.export');

$export($export.P, 'String', {
  // 21.1.3.13 String.prototype.repeat(count)
  repeat: require('./$.string-repeat')
});
},{"./$.export":22,"./$.string-repeat":73}],167:[function(require,module,exports){
// 21.1.3.18 String.prototype.startsWith(searchString [, position ])
'use strict';
var $export     = require('./$.export')
  , toLength    = require('./$.to-length')
  , context     = require('./$.string-context')
  , STARTS_WITH = 'startsWith'
  , $startsWith = ''[STARTS_WITH];

$export($export.P + $export.F * require('./$.fails-is-regexp')(STARTS_WITH), 'String', {
  startsWith: function startsWith(searchString /*, position = 0 */){
    var that   = context(this, searchString, STARTS_WITH)
      , $$     = arguments
      , index  = toLength(Math.min($$.length > 1 ? $$[1] : undefined, that.length))
      , search = String(searchString);
    return $startsWith
      ? $startsWith.call(that, search, index)
      : that.slice(index, index + search.length) === search;
  }
});
},{"./$.export":22,"./$.fails-is-regexp":23,"./$.string-context":71,"./$.to-length":79}],168:[function(require,module,exports){
'use strict';
// 21.1.3.25 String.prototype.trim()
require('./$.string-trim')('trim', function($trim){
  return function trim(){
    return $trim(this, 3);
  };
});
},{"./$.string-trim":74}],169:[function(require,module,exports){
'use strict';
// ECMAScript 6 symbols shim
var $              = require('./$')
  , global         = require('./$.global')
  , has            = require('./$.has')
  , DESCRIPTORS    = require('./$.descriptors')
  , $export        = require('./$.export')
  , redefine       = require('./$.redefine')
  , $fails         = require('./$.fails')
  , shared         = require('./$.shared')
  , setToStringTag = require('./$.set-to-string-tag')
  , uid            = require('./$.uid')
  , wks            = require('./$.wks')
  , keyOf          = require('./$.keyof')
  , $names         = require('./$.get-names')
  , enumKeys       = require('./$.enum-keys')
  , isArray        = require('./$.is-array')
  , anObject       = require('./$.an-object')
  , toIObject      = require('./$.to-iobject')
  , createDesc     = require('./$.property-desc')
  , getDesc        = $.getDesc
  , setDesc        = $.setDesc
  , _create        = $.create
  , getNames       = $names.get
  , $Symbol        = global.Symbol
  , $JSON          = global.JSON
  , _stringify     = $JSON && $JSON.stringify
  , setter         = false
  , HIDDEN         = wks('_hidden')
  , isEnum         = $.isEnum
  , SymbolRegistry = shared('symbol-registry')
  , AllSymbols     = shared('symbols')
  , useNative      = typeof $Symbol == 'function'
  , ObjectProto    = Object.prototype;

// fallback for old Android, https://code.google.com/p/v8/issues/detail?id=687
var setSymbolDesc = DESCRIPTORS && $fails(function(){
  return _create(setDesc({}, 'a', {
    get: function(){ return setDesc(this, 'a', {value: 7}).a; }
  })).a != 7;
}) ? function(it, key, D){
  var protoDesc = getDesc(ObjectProto, key);
  if(protoDesc)delete ObjectProto[key];
  setDesc(it, key, D);
  if(protoDesc && it !== ObjectProto)setDesc(ObjectProto, key, protoDesc);
} : setDesc;

var wrap = function(tag){
  var sym = AllSymbols[tag] = _create($Symbol.prototype);
  sym._k = tag;
  DESCRIPTORS && setter && setSymbolDesc(ObjectProto, tag, {
    configurable: true,
    set: function(value){
      if(has(this, HIDDEN) && has(this[HIDDEN], tag))this[HIDDEN][tag] = false;
      setSymbolDesc(this, tag, createDesc(1, value));
    }
  });
  return sym;
};

var isSymbol = function(it){
  return typeof it == 'symbol';
};

var $defineProperty = function defineProperty(it, key, D){
  if(D && has(AllSymbols, key)){
    if(!D.enumerable){
      if(!has(it, HIDDEN))setDesc(it, HIDDEN, createDesc(1, {}));
      it[HIDDEN][key] = true;
    } else {
      if(has(it, HIDDEN) && it[HIDDEN][key])it[HIDDEN][key] = false;
      D = _create(D, {enumerable: createDesc(0, false)});
    } return setSymbolDesc(it, key, D);
  } return setDesc(it, key, D);
};
var $defineProperties = function defineProperties(it, P){
  anObject(it);
  var keys = enumKeys(P = toIObject(P))
    , i    = 0
    , l = keys.length
    , key;
  while(l > i)$defineProperty(it, key = keys[i++], P[key]);
  return it;
};
var $create = function create(it, P){
  return P === undefined ? _create(it) : $defineProperties(_create(it), P);
};
var $propertyIsEnumerable = function propertyIsEnumerable(key){
  var E = isEnum.call(this, key);
  return E || !has(this, key) || !has(AllSymbols, key) || has(this, HIDDEN) && this[HIDDEN][key]
    ? E : true;
};
var $getOwnPropertyDescriptor = function getOwnPropertyDescriptor(it, key){
  var D = getDesc(it = toIObject(it), key);
  if(D && has(AllSymbols, key) && !(has(it, HIDDEN) && it[HIDDEN][key]))D.enumerable = true;
  return D;
};
var $getOwnPropertyNames = function getOwnPropertyNames(it){
  var names  = getNames(toIObject(it))
    , result = []
    , i      = 0
    , key;
  while(names.length > i)if(!has(AllSymbols, key = names[i++]) && key != HIDDEN)result.push(key);
  return result;
};
var $getOwnPropertySymbols = function getOwnPropertySymbols(it){
  var names  = getNames(toIObject(it))
    , result = []
    , i      = 0
    , key;
  while(names.length > i)if(has(AllSymbols, key = names[i++]))result.push(AllSymbols[key]);
  return result;
};
var $stringify = function stringify(it){
  if(it === undefined || isSymbol(it))return; // IE8 returns string on undefined
  var args = [it]
    , i    = 1
    , $$   = arguments
    , replacer, $replacer;
  while($$.length > i)args.push($$[i++]);
  replacer = args[1];
  if(typeof replacer == 'function')$replacer = replacer;
  if($replacer || !isArray(replacer))replacer = function(key, value){
    if($replacer)value = $replacer.call(this, key, value);
    if(!isSymbol(value))return value;
  };
  args[1] = replacer;
  return _stringify.apply($JSON, args);
};
var buggyJSON = $fails(function(){
  var S = $Symbol();
  // MS Edge converts symbol values to JSON as {}
  // WebKit converts symbol values to JSON as null
  // V8 throws on boxed symbols
  return _stringify([S]) != '[null]' || _stringify({a: S}) != '{}' || _stringify(Object(S)) != '{}';
});

// 19.4.1.1 Symbol([description])
if(!useNative){
  $Symbol = function Symbol(){
    if(isSymbol(this))throw TypeError('Symbol is not a constructor');
    return wrap(uid(arguments.length > 0 ? arguments[0] : undefined));
  };
  redefine($Symbol.prototype, 'toString', function toString(){
    return this._k;
  });

  isSymbol = function(it){
    return it instanceof $Symbol;
  };

  $.create     = $create;
  $.isEnum     = $propertyIsEnumerable;
  $.getDesc    = $getOwnPropertyDescriptor;
  $.setDesc    = $defineProperty;
  $.setDescs   = $defineProperties;
  $.getNames   = $names.get = $getOwnPropertyNames;
  $.getSymbols = $getOwnPropertySymbols;

  if(DESCRIPTORS && !require('./$.library')){
    redefine(ObjectProto, 'propertyIsEnumerable', $propertyIsEnumerable, true);
  }
}

var symbolStatics = {
  // 19.4.2.1 Symbol.for(key)
  'for': function(key){
    return has(SymbolRegistry, key += '')
      ? SymbolRegistry[key]
      : SymbolRegistry[key] = $Symbol(key);
  },
  // 19.4.2.5 Symbol.keyFor(sym)
  keyFor: function keyFor(key){
    return keyOf(SymbolRegistry, key);
  },
  useSetter: function(){ setter = true; },
  useSimple: function(){ setter = false; }
};
// 19.4.2.2 Symbol.hasInstance
// 19.4.2.3 Symbol.isConcatSpreadable
// 19.4.2.4 Symbol.iterator
// 19.4.2.6 Symbol.match
// 19.4.2.8 Symbol.replace
// 19.4.2.9 Symbol.search
// 19.4.2.10 Symbol.species
// 19.4.2.11 Symbol.split
// 19.4.2.12 Symbol.toPrimitive
// 19.4.2.13 Symbol.toStringTag
// 19.4.2.14 Symbol.unscopables
$.each.call((
  'hasInstance,isConcatSpreadable,iterator,match,replace,search,' +
  'species,split,toPrimitive,toStringTag,unscopables'
).split(','), function(it){
  var sym = wks(it);
  symbolStatics[it] = useNative ? sym : wrap(sym);
});

setter = true;

$export($export.G + $export.W, {Symbol: $Symbol});

$export($export.S, 'Symbol', symbolStatics);

$export($export.S + $export.F * !useNative, 'Object', {
  // 19.1.2.2 Object.create(O [, Properties])
  create: $create,
  // 19.1.2.4 Object.defineProperty(O, P, Attributes)
  defineProperty: $defineProperty,
  // 19.1.2.3 Object.defineProperties(O, Properties)
  defineProperties: $defineProperties,
  // 19.1.2.6 Object.getOwnPropertyDescriptor(O, P)
  getOwnPropertyDescriptor: $getOwnPropertyDescriptor,
  // 19.1.2.7 Object.getOwnPropertyNames(O)
  getOwnPropertyNames: $getOwnPropertyNames,
  // 19.1.2.8 Object.getOwnPropertySymbols(O)
  getOwnPropertySymbols: $getOwnPropertySymbols
});

// 24.3.2 JSON.stringify(value [, replacer [, space]])
$JSON && $export($export.S + $export.F * (!useNative || buggyJSON), 'JSON', {stringify: $stringify});

// 19.4.3.5 Symbol.prototype[@@toStringTag]
setToStringTag($Symbol, 'Symbol');
// 20.2.1.9 Math[@@toStringTag]
setToStringTag(Math, 'Math', true);
// 24.3.3 JSON[@@toStringTag]
setToStringTag(global.JSON, 'JSON', true);
},{"./$":46,"./$.an-object":4,"./$.descriptors":19,"./$.enum-keys":21,"./$.export":22,"./$.fails":24,"./$.get-names":28,"./$.global":29,"./$.has":30,"./$.is-array":36,"./$.keyof":47,"./$.library":48,"./$.property-desc":59,"./$.redefine":61,"./$.set-to-string-tag":66,"./$.shared":67,"./$.to-iobject":78,"./$.uid":82,"./$.wks":83}],170:[function(require,module,exports){
'use strict';
var $            = require('./$')
  , redefine     = require('./$.redefine')
  , weak         = require('./$.collection-weak')
  , isObject     = require('./$.is-object')
  , has          = require('./$.has')
  , frozenStore  = weak.frozenStore
  , WEAK         = weak.WEAK
  , isExtensible = Object.isExtensible || isObject
  , tmp          = {};

// 23.3 WeakMap Objects
var $WeakMap = require('./$.collection')('WeakMap', function(get){
  return function WeakMap(){ return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.3.3.3 WeakMap.prototype.get(key)
  get: function get(key){
    if(isObject(key)){
      if(!isExtensible(key))return frozenStore(this).get(key);
      if(has(key, WEAK))return key[WEAK][this._i];
    }
  },
  // 23.3.3.5 WeakMap.prototype.set(key, value)
  set: function set(key, value){
    return weak.def(this, key, value);
  }
}, weak, true, true);

// IE11 WeakMap frozen keys fix
if(new $WeakMap().set((Object.freeze || Object)(tmp), 7).get(tmp) != 7){
  $.each.call(['delete', 'has', 'get', 'set'], function(key){
    var proto  = $WeakMap.prototype
      , method = proto[key];
    redefine(proto, key, function(a, b){
      // store frozen objects on leaky map
      if(isObject(a) && !isExtensible(a)){
        var result = frozenStore(this)[key](a, b);
        return key == 'set' ? this : result;
      // store all the rest on native weakmap
      } return method.call(this, a, b);
    });
  });
}
},{"./$":46,"./$.collection":15,"./$.collection-weak":14,"./$.has":30,"./$.is-object":38,"./$.redefine":61}],171:[function(require,module,exports){
'use strict';
var weak = require('./$.collection-weak');

// 23.4 WeakSet Objects
require('./$.collection')('WeakSet', function(get){
  return function WeakSet(){ return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.4.3.1 WeakSet.prototype.add(value)
  add: function add(value){
    return weak.def(this, value, true);
  }
}, weak, false, true);
},{"./$.collection":15,"./$.collection-weak":14}],172:[function(require,module,exports){
'use strict';
var $export   = require('./$.export')
  , $includes = require('./$.array-includes')(true);

$export($export.P, 'Array', {
  // https://github.com/domenic/Array.prototype.includes
  includes: function includes(el /*, fromIndex = 0 */){
    return $includes(this, el, arguments.length > 1 ? arguments[1] : undefined);
  }
});

require('./$.add-to-unscopables')('includes');
},{"./$.add-to-unscopables":3,"./$.array-includes":7,"./$.export":22}],173:[function(require,module,exports){
// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var $export  = require('./$.export');

$export($export.P, 'Map', {toJSON: require('./$.collection-to-json')('Map')});
},{"./$.collection-to-json":13,"./$.export":22}],174:[function(require,module,exports){
// http://goo.gl/XkBrjD
var $export  = require('./$.export')
  , $entries = require('./$.object-to-array')(true);

$export($export.S, 'Object', {
  entries: function entries(it){
    return $entries(it);
  }
});
},{"./$.export":22,"./$.object-to-array":55}],175:[function(require,module,exports){
// https://gist.github.com/WebReflection/9353781
var $          = require('./$')
  , $export    = require('./$.export')
  , ownKeys    = require('./$.own-keys')
  , toIObject  = require('./$.to-iobject')
  , createDesc = require('./$.property-desc');

$export($export.S, 'Object', {
  getOwnPropertyDescriptors: function getOwnPropertyDescriptors(object){
    var O       = toIObject(object)
      , setDesc = $.setDesc
      , getDesc = $.getDesc
      , keys    = ownKeys(O)
      , result  = {}
      , i       = 0
      , key, D;
    while(keys.length > i){
      D = getDesc(O, key = keys[i++]);
      if(key in result)setDesc(result, key, createDesc(0, D));
      else result[key] = D;
    } return result;
  }
});
},{"./$":46,"./$.export":22,"./$.own-keys":56,"./$.property-desc":59,"./$.to-iobject":78}],176:[function(require,module,exports){
// http://goo.gl/XkBrjD
var $export = require('./$.export')
  , $values = require('./$.object-to-array')(false);

$export($export.S, 'Object', {
  values: function values(it){
    return $values(it);
  }
});
},{"./$.export":22,"./$.object-to-array":55}],177:[function(require,module,exports){
// https://github.com/benjamingr/RexExp.escape
var $export = require('./$.export')
  , $re     = require('./$.replacer')(/[\\^$*+?.()|[\]{}]/g, '\\$&');

$export($export.S, 'RegExp', {escape: function escape(it){ return $re(it); }});

},{"./$.export":22,"./$.replacer":62}],178:[function(require,module,exports){
// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var $export  = require('./$.export');

$export($export.P, 'Set', {toJSON: require('./$.collection-to-json')('Set')});
},{"./$.collection-to-json":13,"./$.export":22}],179:[function(require,module,exports){
'use strict';
// https://github.com/mathiasbynens/String.prototype.at
var $export = require('./$.export')
  , $at     = require('./$.string-at')(true);

$export($export.P, 'String', {
  at: function at(pos){
    return $at(this, pos);
  }
});
},{"./$.export":22,"./$.string-at":70}],180:[function(require,module,exports){
'use strict';
var $export = require('./$.export')
  , $pad    = require('./$.string-pad');

$export($export.P, 'String', {
  padLeft: function padLeft(maxLength /*, fillString = ' ' */){
    return $pad(this, maxLength, arguments.length > 1 ? arguments[1] : undefined, true);
  }
});
},{"./$.export":22,"./$.string-pad":72}],181:[function(require,module,exports){
'use strict';
var $export = require('./$.export')
  , $pad    = require('./$.string-pad');

$export($export.P, 'String', {
  padRight: function padRight(maxLength /*, fillString = ' ' */){
    return $pad(this, maxLength, arguments.length > 1 ? arguments[1] : undefined, false);
  }
});
},{"./$.export":22,"./$.string-pad":72}],182:[function(require,module,exports){
'use strict';
// https://github.com/sebmarkbage/ecmascript-string-left-right-trim
require('./$.string-trim')('trimLeft', function($trim){
  return function trimLeft(){
    return $trim(this, 1);
  };
});
},{"./$.string-trim":74}],183:[function(require,module,exports){
'use strict';
// https://github.com/sebmarkbage/ecmascript-string-left-right-trim
require('./$.string-trim')('trimRight', function($trim){
  return function trimRight(){
    return $trim(this, 2);
  };
});
},{"./$.string-trim":74}],184:[function(require,module,exports){
// JavaScript 1.6 / Strawman array statics shim
var $       = require('./$')
  , $export = require('./$.export')
  , $ctx    = require('./$.ctx')
  , $Array  = require('./$.core').Array || Array
  , statics = {};
var setStatics = function(keys, length){
  $.each.call(keys.split(','), function(key){
    if(length == undefined && key in $Array)statics[key] = $Array[key];
    else if(key in [])statics[key] = $ctx(Function.call, [][key], length);
  });
};
setStatics('pop,reverse,shift,keys,values,entries', 1);
setStatics('indexOf,every,some,forEach,map,filter,find,findIndex,includes', 3);
setStatics('join,slice,concat,push,splice,unshift,sort,lastIndexOf,' +
           'reduce,reduceRight,copyWithin,fill');
$export($export.S, 'Array', statics);
},{"./$":46,"./$.core":16,"./$.ctx":17,"./$.export":22}],185:[function(require,module,exports){
require('./es6.array.iterator');
var global      = require('./$.global')
  , hide        = require('./$.hide')
  , Iterators   = require('./$.iterators')
  , ITERATOR    = require('./$.wks')('iterator')
  , NL          = global.NodeList
  , HTC         = global.HTMLCollection
  , NLProto     = NL && NL.prototype
  , HTCProto    = HTC && HTC.prototype
  , ArrayValues = Iterators.NodeList = Iterators.HTMLCollection = Iterators.Array;
if(NLProto && !NLProto[ITERATOR])hide(NLProto, ITERATOR, ArrayValues);
if(HTCProto && !HTCProto[ITERATOR])hide(HTCProto, ITERATOR, ArrayValues);
},{"./$.global":29,"./$.hide":31,"./$.iterators":45,"./$.wks":83,"./es6.array.iterator":91}],186:[function(require,module,exports){
var $export = require('./$.export')
  , $task   = require('./$.task');
$export($export.G + $export.B, {
  setImmediate:   $task.set,
  clearImmediate: $task.clear
});
},{"./$.export":22,"./$.task":75}],187:[function(require,module,exports){
// ie9- setTimeout & setInterval additional parameters fix
var global     = require('./$.global')
  , $export    = require('./$.export')
  , invoke     = require('./$.invoke')
  , partial    = require('./$.partial')
  , navigator  = global.navigator
  , MSIE       = !!navigator && /MSIE .\./.test(navigator.userAgent); // <- dirty ie9- check
var wrap = function(set){
  return MSIE ? function(fn, time /*, ...args */){
    return set(invoke(
      partial,
      [].slice.call(arguments, 2),
      typeof fn == 'function' ? fn : Function(fn)
    ), time);
  } : set;
};
$export($export.G + $export.B + $export.F * MSIE, {
  setTimeout:  wrap(global.setTimeout),
  setInterval: wrap(global.setInterval)
});
},{"./$.export":22,"./$.global":29,"./$.invoke":33,"./$.partial":57}],188:[function(require,module,exports){
require('./modules/es5');
require('./modules/es6.symbol');
require('./modules/es6.object.assign');
require('./modules/es6.object.is');
require('./modules/es6.object.set-prototype-of');
require('./modules/es6.object.to-string');
require('./modules/es6.object.freeze');
require('./modules/es6.object.seal');
require('./modules/es6.object.prevent-extensions');
require('./modules/es6.object.is-frozen');
require('./modules/es6.object.is-sealed');
require('./modules/es6.object.is-extensible');
require('./modules/es6.object.get-own-property-descriptor');
require('./modules/es6.object.get-prototype-of');
require('./modules/es6.object.keys');
require('./modules/es6.object.get-own-property-names');
require('./modules/es6.function.name');
require('./modules/es6.function.has-instance');
require('./modules/es6.number.constructor');
require('./modules/es6.number.epsilon');
require('./modules/es6.number.is-finite');
require('./modules/es6.number.is-integer');
require('./modules/es6.number.is-nan');
require('./modules/es6.number.is-safe-integer');
require('./modules/es6.number.max-safe-integer');
require('./modules/es6.number.min-safe-integer');
require('./modules/es6.number.parse-float');
require('./modules/es6.number.parse-int');
require('./modules/es6.math.acosh');
require('./modules/es6.math.asinh');
require('./modules/es6.math.atanh');
require('./modules/es6.math.cbrt');
require('./modules/es6.math.clz32');
require('./modules/es6.math.cosh');
require('./modules/es6.math.expm1');
require('./modules/es6.math.fround');
require('./modules/es6.math.hypot');
require('./modules/es6.math.imul');
require('./modules/es6.math.log10');
require('./modules/es6.math.log1p');
require('./modules/es6.math.log2');
require('./modules/es6.math.sign');
require('./modules/es6.math.sinh');
require('./modules/es6.math.tanh');
require('./modules/es6.math.trunc');
require('./modules/es6.string.from-code-point');
require('./modules/es6.string.raw');
require('./modules/es6.string.trim');
require('./modules/es6.string.iterator');
require('./modules/es6.string.code-point-at');
require('./modules/es6.string.ends-with');
require('./modules/es6.string.includes');
require('./modules/es6.string.repeat');
require('./modules/es6.string.starts-with');
require('./modules/es6.array.from');
require('./modules/es6.array.of');
require('./modules/es6.array.iterator');
require('./modules/es6.array.species');
require('./modules/es6.array.copy-within');
require('./modules/es6.array.fill');
require('./modules/es6.array.find');
require('./modules/es6.array.find-index');
require('./modules/es6.regexp.constructor');
require('./modules/es6.regexp.flags');
require('./modules/es6.regexp.match');
require('./modules/es6.regexp.replace');
require('./modules/es6.regexp.search');
require('./modules/es6.regexp.split');
require('./modules/es6.promise');
require('./modules/es6.map');
require('./modules/es6.set');
require('./modules/es6.weak-map');
require('./modules/es6.weak-set');
require('./modules/es6.reflect.apply');
require('./modules/es6.reflect.construct');
require('./modules/es6.reflect.define-property');
require('./modules/es6.reflect.delete-property');
require('./modules/es6.reflect.enumerate');
require('./modules/es6.reflect.get');
require('./modules/es6.reflect.get-own-property-descriptor');
require('./modules/es6.reflect.get-prototype-of');
require('./modules/es6.reflect.has');
require('./modules/es6.reflect.is-extensible');
require('./modules/es6.reflect.own-keys');
require('./modules/es6.reflect.prevent-extensions');
require('./modules/es6.reflect.set');
require('./modules/es6.reflect.set-prototype-of');
require('./modules/es7.array.includes');
require('./modules/es7.string.at');
require('./modules/es7.string.pad-left');
require('./modules/es7.string.pad-right');
require('./modules/es7.string.trim-left');
require('./modules/es7.string.trim-right');
require('./modules/es7.regexp.escape');
require('./modules/es7.object.get-own-property-descriptors');
require('./modules/es7.object.values');
require('./modules/es7.object.entries');
require('./modules/es7.map.to-json');
require('./modules/es7.set.to-json');
require('./modules/js.array.statics');
require('./modules/web.timers');
require('./modules/web.immediate');
require('./modules/web.dom.iterable');
module.exports = require('./modules/$.core');
},{"./modules/$.core":16,"./modules/es5":85,"./modules/es6.array.copy-within":86,"./modules/es6.array.fill":87,"./modules/es6.array.find":89,"./modules/es6.array.find-index":88,"./modules/es6.array.from":90,"./modules/es6.array.iterator":91,"./modules/es6.array.of":92,"./modules/es6.array.species":93,"./modules/es6.function.has-instance":94,"./modules/es6.function.name":95,"./modules/es6.map":96,"./modules/es6.math.acosh":97,"./modules/es6.math.asinh":98,"./modules/es6.math.atanh":99,"./modules/es6.math.cbrt":100,"./modules/es6.math.clz32":101,"./modules/es6.math.cosh":102,"./modules/es6.math.expm1":103,"./modules/es6.math.fround":104,"./modules/es6.math.hypot":105,"./modules/es6.math.imul":106,"./modules/es6.math.log10":107,"./modules/es6.math.log1p":108,"./modules/es6.math.log2":109,"./modules/es6.math.sign":110,"./modules/es6.math.sinh":111,"./modules/es6.math.tanh":112,"./modules/es6.math.trunc":113,"./modules/es6.number.constructor":114,"./modules/es6.number.epsilon":115,"./modules/es6.number.is-finite":116,"./modules/es6.number.is-integer":117,"./modules/es6.number.is-nan":118,"./modules/es6.number.is-safe-integer":119,"./modules/es6.number.max-safe-integer":120,"./modules/es6.number.min-safe-integer":121,"./modules/es6.number.parse-float":122,"./modules/es6.number.parse-int":123,"./modules/es6.object.assign":124,"./modules/es6.object.freeze":125,"./modules/es6.object.get-own-property-descriptor":126,"./modules/es6.object.get-own-property-names":127,"./modules/es6.object.get-prototype-of":128,"./modules/es6.object.is":132,"./modules/es6.object.is-extensible":129,"./modules/es6.object.is-frozen":130,"./modules/es6.object.is-sealed":131,"./modules/es6.object.keys":133,"./modules/es6.object.prevent-extensions":134,"./modules/es6.object.seal":135,"./modules/es6.object.set-prototype-of":136,"./modules/es6.object.to-string":137,"./modules/es6.promise":138,"./modules/es6.reflect.apply":139,"./modules/es6.reflect.construct":140,"./modules/es6.reflect.define-property":141,"./modules/es6.reflect.delete-property":142,"./modules/es6.reflect.enumerate":143,"./modules/es6.reflect.get":146,"./modules/es6.reflect.get-own-property-descriptor":144,"./modules/es6.reflect.get-prototype-of":145,"./modules/es6.reflect.has":147,"./modules/es6.reflect.is-extensible":148,"./modules/es6.reflect.own-keys":149,"./modules/es6.reflect.prevent-extensions":150,"./modules/es6.reflect.set":152,"./modules/es6.reflect.set-prototype-of":151,"./modules/es6.regexp.constructor":153,"./modules/es6.regexp.flags":154,"./modules/es6.regexp.match":155,"./modules/es6.regexp.replace":156,"./modules/es6.regexp.search":157,"./modules/es6.regexp.split":158,"./modules/es6.set":159,"./modules/es6.string.code-point-at":160,"./modules/es6.string.ends-with":161,"./modules/es6.string.from-code-point":162,"./modules/es6.string.includes":163,"./modules/es6.string.iterator":164,"./modules/es6.string.raw":165,"./modules/es6.string.repeat":166,"./modules/es6.string.starts-with":167,"./modules/es6.string.trim":168,"./modules/es6.symbol":169,"./modules/es6.weak-map":170,"./modules/es6.weak-set":171,"./modules/es7.array.includes":172,"./modules/es7.map.to-json":173,"./modules/es7.object.entries":174,"./modules/es7.object.get-own-property-descriptors":175,"./modules/es7.object.values":176,"./modules/es7.regexp.escape":177,"./modules/es7.set.to-json":178,"./modules/es7.string.at":179,"./modules/es7.string.pad-left":180,"./modules/es7.string.pad-right":181,"./modules/es7.string.trim-left":182,"./modules/es7.string.trim-right":183,"./modules/js.array.statics":184,"./modules/web.dom.iterable":185,"./modules/web.immediate":186,"./modules/web.timers":187}],189:[function(require,module,exports){
(function (global){
(function (process,global){
/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * https://raw.github.com/facebook/regenerator/master/LICENSE file. An
 * additional grant of patent rights can be found in the PATENTS file in
 * the same directory.
 */

!(function(global) {
  "use strict";

  var hasOwn = Object.prototype.hasOwnProperty;
  var undefined; // More compressible than void 0.
  var iteratorSymbol =
    typeof Symbol === "function" && Symbol.iterator || "@@iterator";

  var inModule = typeof module === "object";
  var runtime = global.regeneratorRuntime;
  if (runtime) {
    if (inModule) {
      // If regeneratorRuntime is defined globally and we're in a module,
      // make the exports object identical to regeneratorRuntime.
      module.exports = runtime;
    }
    // Don't bother evaluating the rest of this file if the runtime was
    // already defined globally.
    return;
  }

  // Define the runtime globally (as expected by generated code) as either
  // module.exports (if we're in a module) or a new, empty object.
  runtime = global.regeneratorRuntime = inModule ? module.exports : {};

  function wrap(innerFn, outerFn, self, tryLocsList) {
    // If outerFn provided, then outerFn.prototype instanceof Generator.
    var generator = Object.create((outerFn || Generator).prototype);
    var context = new Context(tryLocsList || []);

    // The ._invoke method unifies the implementations of the .next,
    // .throw, and .return methods.
    generator._invoke = makeInvokeMethod(innerFn, self, context);

    return generator;
  }
  runtime.wrap = wrap;

  // Try/catch helper to minimize deoptimizations. Returns a completion
  // record like context.tryEntries[i].completion. This interface could
  // have been (and was previously) designed to take a closure to be
  // invoked without arguments, but in all the cases we care about we
  // already have an existing method we want to call, so there's no need
  // to create a new function object. We can even get away with assuming
  // the method takes exactly one argument, since that happens to be true
  // in every case, so we don't have to touch the arguments object. The
  // only additional allocation required is the completion record, which
  // has a stable shape and so hopefully should be cheap to allocate.
  function tryCatch(fn, obj, arg) {
    try {
      return { type: "normal", arg: fn.call(obj, arg) };
    } catch (err) {
      return { type: "throw", arg: err };
    }
  }

  var GenStateSuspendedStart = "suspendedStart";
  var GenStateSuspendedYield = "suspendedYield";
  var GenStateExecuting = "executing";
  var GenStateCompleted = "completed";

  // Returning this object from the innerFn has the same effect as
  // breaking out of the dispatch switch statement.
  var ContinueSentinel = {};

  // Dummy constructor functions that we use as the .constructor and
  // .constructor.prototype properties for functions that return Generator
  // objects. For full spec compliance, you may wish to configure your
  // minifier not to mangle the names of these two functions.
  function Generator() {}
  function GeneratorFunction() {}
  function GeneratorFunctionPrototype() {}

  var Gp = GeneratorFunctionPrototype.prototype = Generator.prototype;
  GeneratorFunction.prototype = Gp.constructor = GeneratorFunctionPrototype;
  GeneratorFunctionPrototype.constructor = GeneratorFunction;
  GeneratorFunction.displayName = "GeneratorFunction";

  // Helper for defining the .next, .throw, and .return methods of the
  // Iterator interface in terms of a single ._invoke method.
  function defineIteratorMethods(prototype) {
    ["next", "throw", "return"].forEach(function(method) {
      prototype[method] = function(arg) {
        return this._invoke(method, arg);
      };
    });
  }

  runtime.isGeneratorFunction = function(genFun) {
    var ctor = typeof genFun === "function" && genFun.constructor;
    return ctor
      ? ctor === GeneratorFunction ||
        // For the native GeneratorFunction constructor, the best we can
        // do is to check its .name property.
        (ctor.displayName || ctor.name) === "GeneratorFunction"
      : false;
  };

  runtime.mark = function(genFun) {
    if (Object.setPrototypeOf) {
      Object.setPrototypeOf(genFun, GeneratorFunctionPrototype);
    } else {
      genFun.__proto__ = GeneratorFunctionPrototype;
    }
    genFun.prototype = Object.create(Gp);
    return genFun;
  };

  // Within the body of any async function, `await x` is transformed to
  // `yield regeneratorRuntime.awrap(x)`, so that the runtime can test
  // `value instanceof AwaitArgument` to determine if the yielded value is
  // meant to be awaited. Some may consider the name of this method too
  // cutesy, but they are curmudgeons.
  runtime.awrap = function(arg) {
    return new AwaitArgument(arg);
  };

  function AwaitArgument(arg) {
    this.arg = arg;
  }

  function AsyncIterator(generator) {
    // This invoke function is written in a style that assumes some
    // calling function (or Promise) will handle exceptions.
    function invoke(method, arg) {
      var result = generator[method](arg);
      var value = result.value;
      return value instanceof AwaitArgument
        ? Promise.resolve(value.arg).then(invokeNext, invokeThrow)
        : Promise.resolve(value).then(function(unwrapped) {
            // When a yielded Promise is resolved, its final value becomes
            // the .value of the Promise<{value,done}> result for the
            // current iteration. If the Promise is rejected, however, the
            // result for this iteration will be rejected with the same
            // reason. Note that rejections of yielded Promises are not
            // thrown back into the generator function, as is the case
            // when an awaited Promise is rejected. This difference in
            // behavior between yield and await is important, because it
            // allows the consumer to decide what to do with the yielded
            // rejection (swallow it and continue, manually .throw it back
            // into the generator, abandon iteration, whatever). With
            // await, by contrast, there is no opportunity to examine the
            // rejection reason outside the generator function, so the
            // only option is to throw it from the await expression, and
            // let the generator function handle the exception.
            result.value = unwrapped;
            return result;
          });
    }

    if (typeof process === "object" && process.domain) {
      invoke = process.domain.bind(invoke);
    }

    var invokeNext = invoke.bind(generator, "next");
    var invokeThrow = invoke.bind(generator, "throw");
    var invokeReturn = invoke.bind(generator, "return");
    var previousPromise;

    function enqueue(method, arg) {
      function callInvokeWithMethodAndArg() {
        return invoke(method, arg);
      }

      return previousPromise =
        // If enqueue has been called before, then we want to wait until
        // all previous Promises have been resolved before calling invoke,
        // so that results are always delivered in the correct order. If
        // enqueue has not been called before, then it is important to
        // call invoke immediately, without waiting on a callback to fire,
        // so that the async generator function has the opportunity to do
        // any necessary setup in a predictable way. This predictability
        // is why the Promise constructor synchronously invokes its
        // executor callback, and why async functions synchronously
        // execute code before the first await. Since we implement simple
        // async functions in terms of async generators, it is especially
        // important to get this right, even though it requires care.
        previousPromise ? previousPromise.then(
          callInvokeWithMethodAndArg,
          // Avoid propagating failures to Promises returned by later
          // invocations of the iterator.
          callInvokeWithMethodAndArg
        ) : new Promise(function (resolve) {
          resolve(callInvokeWithMethodAndArg());
        });
    }

    // Define the unified helper method that is used to implement .next,
    // .throw, and .return (see defineIteratorMethods).
    this._invoke = enqueue;
  }

  defineIteratorMethods(AsyncIterator.prototype);

  // Note that simple async functions are implemented on top of
  // AsyncIterator objects; they just return a Promise for the value of
  // the final result produced by the iterator.
  runtime.async = function(innerFn, outerFn, self, tryLocsList) {
    var iter = new AsyncIterator(
      wrap(innerFn, outerFn, self, tryLocsList)
    );

    return runtime.isGeneratorFunction(outerFn)
      ? iter // If outerFn is a generator, return the full iterator.
      : iter.next().then(function(result) {
          return result.done ? result.value : iter.next();
        });
  };

  function makeInvokeMethod(innerFn, self, context) {
    var state = GenStateSuspendedStart;

    return function invoke(method, arg) {
      if (state === GenStateExecuting) {
        throw new Error("Generator is already running");
      }

      if (state === GenStateCompleted) {
        if (method === "throw") {
          throw arg;
        }

        // Be forgiving, per 25.3.3.3.3 of the spec:
        // https://people.mozilla.org/~jorendorff/es6-draft.html#sec-generatorresume
        return doneResult();
      }

      while (true) {
        var delegate = context.delegate;
        if (delegate) {
          if (method === "return" ||
              (method === "throw" && delegate.iterator[method] === undefined)) {
            // A return or throw (when the delegate iterator has no throw
            // method) always terminates the yield* loop.
            context.delegate = null;

            // If the delegate iterator has a return method, give it a
            // chance to clean up.
            var returnMethod = delegate.iterator["return"];
            if (returnMethod) {
              var record = tryCatch(returnMethod, delegate.iterator, arg);
              if (record.type === "throw") {
                // If the return method threw an exception, let that
                // exception prevail over the original return or throw.
                method = "throw";
                arg = record.arg;
                continue;
              }
            }

            if (method === "return") {
              // Continue with the outer return, now that the delegate
              // iterator has been terminated.
              continue;
            }
          }

          var record = tryCatch(
            delegate.iterator[method],
            delegate.iterator,
            arg
          );

          if (record.type === "throw") {
            context.delegate = null;

            // Like returning generator.throw(uncaught), but without the
            // overhead of an extra function call.
            method = "throw";
            arg = record.arg;
            continue;
          }

          // Delegate generator ran and handled its own exceptions so
          // regardless of what the method was, we continue as if it is
          // "next" with an undefined arg.
          method = "next";
          arg = undefined;

          var info = record.arg;
          if (info.done) {
            context[delegate.resultName] = info.value;
            context.next = delegate.nextLoc;
          } else {
            state = GenStateSuspendedYield;
            return info;
          }

          context.delegate = null;
        }

        if (method === "next") {
          context._sent = arg;

          if (state === GenStateSuspendedYield) {
            context.sent = arg;
          } else {
            context.sent = undefined;
          }
        } else if (method === "throw") {
          if (state === GenStateSuspendedStart) {
            state = GenStateCompleted;
            throw arg;
          }

          if (context.dispatchException(arg)) {
            // If the dispatched exception was caught by a catch block,
            // then let that catch block handle the exception normally.
            method = "next";
            arg = undefined;
          }

        } else if (method === "return") {
          context.abrupt("return", arg);
        }

        state = GenStateExecuting;

        var record = tryCatch(innerFn, self, context);
        if (record.type === "normal") {
          // If an exception is thrown from innerFn, we leave state ===
          // GenStateExecuting and loop back for another invocation.
          state = context.done
            ? GenStateCompleted
            : GenStateSuspendedYield;

          var info = {
            value: record.arg,
            done: context.done
          };

          if (record.arg === ContinueSentinel) {
            if (context.delegate && method === "next") {
              // Deliberately forget the last sent value so that we don't
              // accidentally pass it on to the delegate.
              arg = undefined;
            }
          } else {
            return info;
          }

        } else if (record.type === "throw") {
          state = GenStateCompleted;
          // Dispatch the exception by looping back around to the
          // context.dispatchException(arg) call above.
          method = "throw";
          arg = record.arg;
        }
      }
    };
  }

  // Define Generator.prototype.{next,throw,return} in terms of the
  // unified ._invoke helper method.
  defineIteratorMethods(Gp);

  Gp[iteratorSymbol] = function() {
    return this;
  };

  Gp.toString = function() {
    return "[object Generator]";
  };

  function pushTryEntry(locs) {
    var entry = { tryLoc: locs[0] };

    if (1 in locs) {
      entry.catchLoc = locs[1];
    }

    if (2 in locs) {
      entry.finallyLoc = locs[2];
      entry.afterLoc = locs[3];
    }

    this.tryEntries.push(entry);
  }

  function resetTryEntry(entry) {
    var record = entry.completion || {};
    record.type = "normal";
    delete record.arg;
    entry.completion = record;
  }

  function Context(tryLocsList) {
    // The root entry object (effectively a try statement without a catch
    // or a finally block) gives us a place to store values thrown from
    // locations where there is no enclosing try statement.
    this.tryEntries = [{ tryLoc: "root" }];
    tryLocsList.forEach(pushTryEntry, this);
    this.reset(true);
  }

  runtime.keys = function(object) {
    var keys = [];
    for (var key in object) {
      keys.push(key);
    }
    keys.reverse();

    // Rather than returning an object with a next method, we keep
    // things simple and return the next function itself.
    return function next() {
      while (keys.length) {
        var key = keys.pop();
        if (key in object) {
          next.value = key;
          next.done = false;
          return next;
        }
      }

      // To avoid creating an additional object, we just hang the .value
      // and .done properties off the next function object itself. This
      // also ensures that the minifier will not anonymize the function.
      next.done = true;
      return next;
    };
  };

  function values(iterable) {
    if (iterable) {
      var iteratorMethod = iterable[iteratorSymbol];
      if (iteratorMethod) {
        return iteratorMethod.call(iterable);
      }

      if (typeof iterable.next === "function") {
        return iterable;
      }

      if (!isNaN(iterable.length)) {
        var i = -1, next = function next() {
          while (++i < iterable.length) {
            if (hasOwn.call(iterable, i)) {
              next.value = iterable[i];
              next.done = false;
              return next;
            }
          }

          next.value = undefined;
          next.done = true;

          return next;
        };

        return next.next = next;
      }
    }

    // Return an iterator with no values.
    return { next: doneResult };
  }
  runtime.values = values;

  function doneResult() {
    return { value: undefined, done: true };
  }

  Context.prototype = {
    constructor: Context,

    reset: function(skipTempReset) {
      this.prev = 0;
      this.next = 0;
      this.sent = undefined;
      this.done = false;
      this.delegate = null;

      this.tryEntries.forEach(resetTryEntry);

      if (!skipTempReset) {
        for (var name in this) {
          // Not sure about the optimal order of these conditions:
          if (name.charAt(0) === "t" &&
              hasOwn.call(this, name) &&
              !isNaN(+name.slice(1))) {
            this[name] = undefined;
          }
        }
      }
    },

    stop: function() {
      this.done = true;

      var rootEntry = this.tryEntries[0];
      var rootRecord = rootEntry.completion;
      if (rootRecord.type === "throw") {
        throw rootRecord.arg;
      }

      return this.rval;
    },

    dispatchException: function(exception) {
      if (this.done) {
        throw exception;
      }

      var context = this;
      function handle(loc, caught) {
        record.type = "throw";
        record.arg = exception;
        context.next = loc;
        return !!caught;
      }

      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        var record = entry.completion;

        if (entry.tryLoc === "root") {
          // Exception thrown outside of any try block that could handle
          // it, so set the completion value of the entire function to
          // throw the exception.
          return handle("end");
        }

        if (entry.tryLoc <= this.prev) {
          var hasCatch = hasOwn.call(entry, "catchLoc");
          var hasFinally = hasOwn.call(entry, "finallyLoc");

          if (hasCatch && hasFinally) {
            if (this.prev < entry.catchLoc) {
              return handle(entry.catchLoc, true);
            } else if (this.prev < entry.finallyLoc) {
              return handle(entry.finallyLoc);
            }

          } else if (hasCatch) {
            if (this.prev < entry.catchLoc) {
              return handle(entry.catchLoc, true);
            }

          } else if (hasFinally) {
            if (this.prev < entry.finallyLoc) {
              return handle(entry.finallyLoc);
            }

          } else {
            throw new Error("try statement without catch or finally");
          }
        }
      }
    },

    abrupt: function(type, arg) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.tryLoc <= this.prev &&
            hasOwn.call(entry, "finallyLoc") &&
            this.prev < entry.finallyLoc) {
          var finallyEntry = entry;
          break;
        }
      }

      if (finallyEntry &&
          (type === "break" ||
           type === "continue") &&
          finallyEntry.tryLoc <= arg &&
          arg <= finallyEntry.finallyLoc) {
        // Ignore the finally entry if control is not jumping to a
        // location outside the try/catch block.
        finallyEntry = null;
      }

      var record = finallyEntry ? finallyEntry.completion : {};
      record.type = type;
      record.arg = arg;

      if (finallyEntry) {
        this.next = finallyEntry.finallyLoc;
      } else {
        this.complete(record);
      }

      return ContinueSentinel;
    },

    complete: function(record, afterLoc) {
      if (record.type === "throw") {
        throw record.arg;
      }

      if (record.type === "break" ||
          record.type === "continue") {
        this.next = record.arg;
      } else if (record.type === "return") {
        this.rval = record.arg;
        this.next = "end";
      } else if (record.type === "normal" && afterLoc) {
        this.next = afterLoc;
      }
    },

    finish: function(finallyLoc) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.finallyLoc === finallyLoc) {
          this.complete(entry.completion, entry.afterLoc);
          resetTryEntry(entry);
          return ContinueSentinel;
        }
      }
    },

    "catch": function(tryLoc) {
      for (var i = this.tryEntries.length - 1; i >= 0; --i) {
        var entry = this.tryEntries[i];
        if (entry.tryLoc === tryLoc) {
          var record = entry.completion;
          if (record.type === "throw") {
            var thrown = record.arg;
            resetTryEntry(entry);
          }
          return thrown;
        }
      }

      // The context.catch method must only be called with a location
      // argument that corresponds to a known catch block.
      throw new Error("illegal catch attempt");
    },

    delegateYield: function(iterable, resultName, nextLoc) {
      this.delegate = {
        iterator: values(iterable),
        resultName: resultName,
        nextLoc: nextLoc
      };

      return ContinueSentinel;
    }
  };
})(
  // Among the various tricks for obtaining a reference to the global
  // object, this seems to be the most reliable technique that does not
  // use indirect eval (which violates Content Security Policy).
  typeof global === "object" ? global :
  typeof window === "object" ? window :
  typeof self === "object" ? self : this
);

}).call(this,require("../process/browser.js"),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../process/browser.js":202}],190:[function(require,module,exports){
/*!
Copyright (C) 2013-2015 by Andrea Giammarchi - @WebReflection

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
(function(window){'use strict';
  /* jshint loopfunc: true, noempty: false*/
  // http://www.w3.org/TR/dom/#element

  function createDocumentFragment() {
    return document.createDocumentFragment();
  }

  function createElement(nodeName) {
    return document.createElement(nodeName);
  }

  function mutationMacro(nodes) {
    if (nodes.length === 1) {
      return textNodeIfString(nodes[0]);
    }
    for (var
      fragment = createDocumentFragment(),
      list = slice.call(nodes),
      i = 0; i < nodes.length; i++
    ) {
      fragment.appendChild(textNodeIfString(list[i]));
    }
    return fragment;
  }

  function textNodeIfString(node) {
    return typeof node === 'string' ? document.createTextNode(node) : node;
  }

  for(var
    head,
    property,
    TemporaryPrototype,
    TemporaryTokenList,
    wrapVerifyToken,
    document = window.document,
    defineProperty = Object.defineProperty || function (object, property, descriptor) {
      object.__defineGetter__(property, descriptor.get);
    },
    indexOf = [].indexOf || function indexOf(value){
      var length = this.length;
      while(length--) {
        if (this[length] === value) {
          break;
        }
      }
      return length;
    },
    // http://www.w3.org/TR/domcore/#domtokenlist
    verifyToken = function (token) {
      if (!token) {
        throw 'SyntaxError';
      } else if (spaces.test(token)) {
        throw 'InvalidCharacterError';
      }
      return token;
    },
    DOMTokenList = function (node) {
      var
        className = node.className,
        isSVG = typeof className === 'object',
        value = (isSVG ? className.baseVal : className).replace(trim, '')
      ;
      if (value.length) {
        properties.push.apply(
          this,
          value.split(spaces)
        );
      }
      this._isSVG = isSVG;
      this._ = node;
    },
    classListDescriptor = {
      get: function get() {
        return new DOMTokenList(this);
      },
      set: function(){}
    },
    uid = 'dom4-tmp-'.concat(Math.random() * +new Date()).replace('.','-'),
    trim = /^\s+|\s+$/g,
    spaces = /\s+/,
    SPACE = '\x20',
    CLASS_LIST = 'classList',
    toggle = function toggle(token, force) {
      if (this.contains(token)) {
        if (!force) {
          // force is not true (either false or omitted)
          this.remove(token);
        }
      } else if(force === undefined || force) {
        force = true;
        this.add(token);
      }
      return !!force;
    },
    DocumentFragmentPrototype = window.DocumentFragment && DocumentFragment.prototype,
    Node = window.Node,
    NodePrototype = (Node || Element).prototype,
    CharacterData = window.CharacterData || Node,
    CharacterDataPrototype = CharacterData && CharacterData.prototype,
    DocumentType = window.DocumentType,
    DocumentTypePrototype = DocumentType && DocumentType.prototype,
    ElementPrototype = (window.Element || Node || window.HTMLElement).prototype,
    HTMLSelectElement = window.HTMLSelectElement || createElement('select').constructor,
    selectRemove = HTMLSelectElement.prototype.remove,
    ShadowRoot = window.ShadowRoot,
    SVGElement = window.SVGElement,
    // normalizes multiple ids as CSS query
    idSpaceFinder = / /g,
    idSpaceReplacer = '\\ ',
    createQueryMethod = function (methodName) {
      var createArray = methodName === 'querySelectorAll';
      return function (css) {
        var a, i, id, query, nl, selectors, node = this.parentNode;
        if (node) {
          for (
            id = this.getAttribute('id') || uid,
            query = id === uid ? id : id.replace(idSpaceFinder, idSpaceReplacer),
            selectors = css.split(','),
            i = 0; i < selectors.length; i++
          ) {
            selectors[i] = '#' + query + ' ' + selectors[i];
          }
          css = selectors.join(',');
        }
        if (id === uid) this.setAttribute('id', id);
        nl = (node || this)[methodName](css);
        if (id === uid) this.removeAttribute('id');
        // return a list
        if (createArray) {
          i = nl.length;
          a = new Array(i);
          while (i--) a[i] = nl[i];
        }
        // return node or null
        else {
          a = nl;
        }
        return a;
      };
    },
    addQueryAndAll = function (where) {
      if (!('query' in where)) {
        where.query = ElementPrototype.query;
      }
      if (!('queryAll' in where)) {
        where.queryAll = ElementPrototype.queryAll;
      }
    },
    properties = [
      'matches', (
        ElementPrototype.matchesSelector ||
        ElementPrototype.webkitMatchesSelector ||
        ElementPrototype.khtmlMatchesSelector ||
        ElementPrototype.mozMatchesSelector ||
        ElementPrototype.msMatchesSelector ||
        ElementPrototype.oMatchesSelector ||
        function matches(selector) {
          var parentNode = this.parentNode;
          return !!parentNode && -1 < indexOf.call(
            parentNode.querySelectorAll(selector),
            this
          );
        }
      ),
      'closest', function closest(selector) {
        var parentNode = this, matches;
        while (
          // document has no .matches
          (matches = parentNode && parentNode.matches) &&
          !parentNode.matches(selector)
        ) {
          parentNode = parentNode.parentNode;
        }
        return matches ? parentNode : null;
      },
      'prepend', function prepend() {
        var firstChild = this.firstChild,
            node = mutationMacro(arguments);
        if (firstChild) {
          this.insertBefore(node, firstChild);
        } else {
          this.appendChild(node);
        }
      },
      'append', function append() {
        this.appendChild(mutationMacro(arguments));
      },
      'before', function before() {
        var parentNode = this.parentNode;
        if (parentNode) {
          parentNode.insertBefore(
            mutationMacro(arguments), this
          );
        }
      },
      'after', function after() {
        var parentNode = this.parentNode,
            nextSibling = this.nextSibling,
            node = mutationMacro(arguments);
        if (parentNode) {
          if (nextSibling) {
            parentNode.insertBefore(node, nextSibling);
          } else {
            parentNode.appendChild(node);
          }
        }
      },
      // WARNING - DEPRECATED - use .replaceWith() instead
      'replace', function replace() {
        this.replaceWith.apply(this, arguments);
      },
      'replaceWith', function replaceWith() {
        var parentNode = this.parentNode;
        if (parentNode) {
          parentNode.replaceChild(
            mutationMacro(arguments),
            this
          );
        }
      },
      'remove', function remove() {
        var parentNode = this.parentNode;
        if (parentNode) {
          parentNode.removeChild(this);
        }
      },
      'query', createQueryMethod('querySelector'),
      'queryAll', createQueryMethod('querySelectorAll')
    ],
    slice = properties.slice,
    i = properties.length; i; i -= 2
  ) {
    property = properties[i - 2];
    if (!(property in ElementPrototype)) {
      ElementPrototype[property] = properties[i - 1];
    }
    if (property === 'remove') {
      // see https://github.com/WebReflection/dom4/issues/19
      HTMLSelectElement.prototype[property] = function () {
        return 0 < arguments.length ?
          selectRemove.apply(this, arguments) :
          ElementPrototype.remove.call(this);
      };
    }
    // see https://github.com/WebReflection/dom4/issues/18
    if (/^(?:before|after|replace|replaceWith|remove)$/.test(property)) {
      if (CharacterData && !(property in CharacterDataPrototype)) {
        CharacterDataPrototype[property] = properties[i - 1];
      }
      if (DocumentType && !(property in DocumentTypePrototype)) {
        DocumentTypePrototype[property] = properties[i - 1];
      }
    }
    // see https://github.com/WebReflection/dom4/pull/26
    if (/^(?:append|prepend)$/.test(property)) {
      if (DocumentFragmentPrototype) {
        if (!(property in DocumentFragmentPrototype)) {
          DocumentFragmentPrototype[property] = properties[i - 1];
        }
      } else {
        try {
          createDocumentFragment().constructor.prototype[property] = properties[i - 1];
        } catch(o_O) {}
      }
    }
  }

  // bring query and queryAll to the document too
  addQueryAndAll(document);

  // brings query and queryAll to fragments as well
  if (DocumentFragmentPrototype) {
    addQueryAndAll(DocumentFragmentPrototype);
  } else {
    try {
      addQueryAndAll(createDocumentFragment().constructor.prototype);
    } catch(o_O) {}
  }

  // bring query and queryAll to the ShadowRoot too
  if (ShadowRoot) {
    addQueryAndAll(ShadowRoot.prototype);
  }

  // most likely an IE9 only issue
  // see https://github.com/WebReflection/dom4/issues/6
  if (!createElement('a').matches('a')) {
    ElementPrototype[property] = function(matches){
      return function (selector) {
        return matches.call(
          this.parentNode ?
            this :
            createDocumentFragment().appendChild(this),
          selector
        );
      };
    }(ElementPrototype[property]);
  }

  // used to fix both old webkit and SVG
  DOMTokenList.prototype = {
    length: 0,
    add: function add() {
      for(var j = 0, token; j < arguments.length; j++) {
        token = arguments[j];
        if(!this.contains(token)) {
          properties.push.call(this, property);
        }
      }
      if (this._isSVG) {
        this._.setAttribute('class', '' + this);
      } else {
        this._.className = '' + this;
      }
    },
    contains: (function(indexOf){
      return function contains(token) {
        i = indexOf.call(this, property = verifyToken(token));
        return -1 < i;
      };
    }([].indexOf || function (token) {
      i = this.length;
      while(i-- && this[i] !== token){}
      return i;
    })),
    item: function item(i) {
      return this[i] || null;
    },
    remove: function remove() {
      for(var j = 0, token; j < arguments.length; j++) {
        token = arguments[j];
        if(this.contains(token)) {
          properties.splice.call(this, i, 1);
        }
      }
      if (this._isSVG) {
        this._.setAttribute('class', '' + this);
      } else {
        this._.className = '' + this;
      }
    },
    toggle: toggle,
    toString: function toString() {
      return properties.join.call(this, SPACE);
    }
  };

  if (SVGElement && !(CLASS_LIST in SVGElement.prototype)) {
    defineProperty(SVGElement.prototype, CLASS_LIST, classListDescriptor);
  }

  // http://www.w3.org/TR/dom/#domtokenlist
  // iOS 5.1 has completely screwed this property
  // classList in ElementPrototype is false
  // but it's actually there as getter
  if (!(CLASS_LIST in document.documentElement)) {
    defineProperty(ElementPrototype, CLASS_LIST, classListDescriptor);
  } else {
    // iOS 5.1 and Nokia ASHA do not support multiple add or remove
    // trying to detect and fix that in here
    TemporaryTokenList = createElement('div')[CLASS_LIST];
    TemporaryTokenList.add('a', 'b', 'a');
    if ('a\x20b' != TemporaryTokenList) {
      // no other way to reach original methods in iOS 5.1
      TemporaryPrototype = TemporaryTokenList.constructor.prototype;
      if (!('add' in TemporaryPrototype)) {
        // ASHA double fails in here
        TemporaryPrototype = window.TemporaryTokenList.prototype;
      }
      wrapVerifyToken = function (original) {
        return function () {
          var i = 0;
          while (i < arguments.length) {
            original.call(this, arguments[i++]);
          }
        };
      };
      TemporaryPrototype.add = wrapVerifyToken(TemporaryPrototype.add);
      TemporaryPrototype.remove = wrapVerifyToken(TemporaryPrototype.remove);
      // toggle is broken too ^_^ ... let's fix it
      TemporaryPrototype.toggle = toggle;
    }
  }

  if (!('contains' in NodePrototype)) {
    defineProperty(NodePrototype, 'contains', {
      value: function (el) {
        while (el && el !== this) el = el.parentNode;
        return this === el;
      }
    });
  }

  if (!('head' in document)) {
    defineProperty(document, 'head', {
      get: function () {
        return head || (
          head = document.getElementsByTagName('head')[0]
        );
      }
    });
  }

  // requestAnimationFrame partial polyfill
  (function () {
    for (var
      raf,
      rAF = window.requestAnimationFrame,
      cAF = window.cancelAnimationFrame,
      prefixes = ['o', 'ms', 'moz', 'webkit'],
      i = prefixes.length;
      !cAF && i--;
    ) {
      rAF = rAF || window[prefixes[i] + 'RequestAnimationFrame'];
      cAF = window[prefixes[i] + 'CancelAnimationFrame'] ||
            window[prefixes[i] + 'CancelRequestAnimationFrame'];
    }
    if (!cAF) {
      // some FF apparently implemented rAF but no cAF 
      if (rAF) {
        raf = rAF;
        rAF = function (callback) {
          var goOn = true;
          raf(function () {
            if (goOn) callback.apply(this, arguments);
          });
          return function () {
            goOn = false;
          };
        };
        cAF = function (id) {
          id();
        };
      } else {
        rAF = function (callback) {
          return setTimeout(callback, 15, 15);
        };
        cAF = function (id) {
          clearTimeout(id);
        };
      }
    }
    window.requestAnimationFrame = rAF;
    window.cancelAnimationFrame = cAF;
  }());

  // http://www.w3.org/TR/dom/#customevent
  try{new window.CustomEvent('?');}catch(o_O){
    window.CustomEvent = function(
      eventName,
      defaultInitDict
    ){

      // the infamous substitute
      function CustomEvent(type, eventInitDict) {
        /*jshint eqnull:true */
        var event = document.createEvent(eventName);
        if (typeof type != 'string') {
          throw new Error('An event name must be provided');
        }
        if (eventName == 'Event') {
          event.initCustomEvent = initCustomEvent;
        }
        if (eventInitDict == null) {
          eventInitDict = defaultInitDict;
        }
        event.initCustomEvent(
          type,
          eventInitDict.bubbles,
          eventInitDict.cancelable,
          eventInitDict.detail
        );
        return event;
      }

      // attached at runtime
      function initCustomEvent(
        type, bubbles, cancelable, detail
      ) {
        /*jshint validthis:true*/
        this.initEvent(type, bubbles, cancelable);
        this.detail = detail;
      }

      // that's it
      return CustomEvent;
    }(
      // is this IE9 or IE10 ?
      // where CustomEvent is there
      // but not usable as construtor ?
      window.CustomEvent ?
        // use the CustomEvent interface in such case
        'CustomEvent' : 'Event',
        // otherwise the common compatible one
      {
        bubbles: false,
        cancelable: false,
        detail: null
      }
    );
  }

}(window));
},{}],191:[function(require,module,exports){
(function (global){
(function (global){
/*! loadCSS: load a CSS file asynchronously. [c]2016 @scottjehl, Filament Group, Inc. Licensed MIT */
(function(w){
	"use strict";
	/* exported loadCSS */
	var loadCSS = function( href, before, media ){
		// Arguments explained:
		// `href` [REQUIRED] is the URL for your CSS file.
		// `before` [OPTIONAL] is the element the script should use as a reference for injecting our stylesheet <link> before
			// By default, loadCSS attempts to inject the link after the last stylesheet or script in the DOM. However, you might desire a more specific location in your document.
		// `media` [OPTIONAL] is the media type or query of the stylesheet. By default it will be 'all'
		var doc = w.document;
		var ss = doc.createElement( "link" );
		var newMedia = media || "all";
		var ref;
		if( before ){
			ref = before;
		}
		else {
			var refs = ( doc.body || doc.getElementsByTagName( "head" )[ 0 ] ).childNodes;
			ref = refs[ refs.length - 1];
		}

		var sheets = doc.styleSheets;
		ss.rel = "stylesheet";
		ss.href = href;
		// temporarily set media to something inapplicable to ensure it'll fetch without blocking render
		ss.media = "only x";

		// wait until body is defined before injecting link. This ensures a non-blocking load in IE11.
		function ready( cb ){
			if( doc.body ){
				return cb();
			}
			setTimeout(function(){
				ready( cb );
			});
		}
		// Inject link
			// Note: the ternary preserves the existing behavior of "before" argument, but we could choose to change the argument to "after" in a later release and standardize on ref.nextSibling for all refs
			// Note: `insertBefore` is used instead of `appendChild`, for safety re: http://www.paulirish.com/2011/surefire-dom-element-insertion/
		ready( function(){
			ref.parentNode.insertBefore( ss, ( before ? ref : ref.nextSibling ) );
		});
		// A method (exposed on return object for external use) that mimics onload by polling until document.styleSheets until it includes the new sheet.
		var onloadcssdefined = function( cb ){
			var resolvedHref = ss.href;
			var i = sheets.length;
			while( i-- ){
				if( sheets[ i ].href === resolvedHref ){
					return cb();
				}
			}
			setTimeout(function() {
				onloadcssdefined( cb );
			});
		};

		// once loaded, set link's media back to `all` so that the stylesheet applies once it loads
		if( ss.addEventListener ){
			ss.addEventListener( "load", function(){
				this.media = newMedia;
			});
		}
		ss.onloadcssdefined = onloadcssdefined;
		onloadcssdefined(function() {
			if( ss.media !== newMedia ){
				ss.media = newMedia;
			}
		});
		return ss;
	};
	// commonjs
	if( typeof exports !== "undefined" ){
		exports.loadCSS = loadCSS;
	}
	else {
		w.loadCSS = loadCSS;
	}
}( typeof global !== "undefined" ? global : this ));

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],192:[function(require,module,exports){
(function(){'use strict';var h=!!document.addEventListener;function k(a,b){h?a.addEventListener("scroll",b,!1):a.attachEvent("scroll",b)}function w(a){document.body?a():h?document.addEventListener("DOMContentLoaded",a):document.onreadystatechange=function(){"interactive"==document.readyState&&a()}};function x(a){this.a=document.createElement("div");this.a.setAttribute("aria-hidden","true");this.a.appendChild(document.createTextNode(a));this.b=document.createElement("span");this.c=document.createElement("span");this.h=document.createElement("span");this.f=document.createElement("span");this.g=-1;this.b.style.cssText="display:inline-block;position:absolute;height:100%;width:100%;overflow:scroll;font-size:16px;";this.c.style.cssText="display:inline-block;position:absolute;height:100%;width:100%;overflow:scroll;font-size:16px;";
this.f.style.cssText="display:inline-block;position:absolute;height:100%;width:100%;overflow:scroll;font-size:16px;";this.h.style.cssText="display:inline-block;width:200%;height:200%;font-size:16px;";this.b.appendChild(this.h);this.c.appendChild(this.f);this.a.appendChild(this.b);this.a.appendChild(this.c)}
function y(a,b){a.a.style.cssText="min-width:20px;min-height:20px;display:inline-block;overflow:hidden;position:absolute;width:auto;margin:0;padding:0;top:-999px;left:-999px;white-space:nowrap;font:"+b+";"}function z(a){var b=a.a.offsetWidth,c=b+100;a.f.style.width=c+"px";a.c.scrollLeft=c;a.b.scrollLeft=a.b.scrollWidth+100;return a.g!==b?(a.g=b,!0):!1}function A(a,b){function c(){var a=l;z(a)&&null!==a.a.parentNode&&b(a.g)}var l=a;k(a.b,c);k(a.c,c);z(a)};function B(a,b){var c=b||{};this.family=a;this.style=c.style||"normal";this.weight=c.weight||"normal";this.stretch=c.stretch||"normal"}var C=null,D=null,H=!!window.FontFace;function I(){if(null===D){var a=document.createElement("div");try{a.style.font="condensed 100px sans-serif"}catch(b){}D=""!==a.style.font}return D}function J(a,b){return[a.style,a.weight,I()?a.stretch:"","100px",b].join(" ")}
B.prototype.a=function(a,b){var c=this,l=a||"BESbswy",E=b||3E3,F=(new Date).getTime();return new Promise(function(a,b){if(H){var q=function(){(new Date).getTime()-F>=E?b(c):document.fonts.load(J(c,c.family),l).then(function(b){1<=b.length?a(c):setTimeout(q,25)},function(){b(c)})};q()}else w(function(){function r(){var b;if(b=-1!=e&&-1!=f||-1!=e&&-1!=g||-1!=f&&-1!=g)(b=e!=f&&e!=g&&f!=g)||(null===C&&(b=/AppleWebKit\/([0-9]+)(?:\.([0-9]+))/.exec(window.navigator.userAgent),C=!!b&&(536>parseInt(b[1],
10)||536===parseInt(b[1],10)&&11>=parseInt(b[2],10))),b=C&&(e==t&&f==t&&g==t||e==u&&f==u&&g==u||e==v&&f==v&&g==v)),b=!b;b&&(null!==d.parentNode&&d.parentNode.removeChild(d),clearTimeout(G),a(c))}function q(){if((new Date).getTime()-F>=E)null!==d.parentNode&&d.parentNode.removeChild(d),b(c);else{var a=document.hidden;if(!0===a||void 0===a)e=m.a.offsetWidth,f=n.a.offsetWidth,g=p.a.offsetWidth,r();G=setTimeout(q,50)}}var m=new x(l),n=new x(l),p=new x(l),e=-1,f=-1,g=-1,t=-1,u=-1,v=-1,d=document.createElement("div"),
G=0;d.dir="ltr";y(m,J(c,"sans-serif"));y(n,J(c,"serif"));y(p,J(c,"monospace"));d.appendChild(m.a);d.appendChild(n.a);d.appendChild(p.a);document.body.appendChild(d);t=m.a.offsetWidth;u=n.a.offsetWidth;v=p.a.offsetWidth;q();A(m,function(a){e=a;r()});y(m,J(c,'"'+c.family+'",sans-serif'));A(n,function(a){f=a;r()});y(n,J(c,'"'+c.family+'",serif'));A(p,function(a){g=a;r()});y(p,J(c,'"'+c.family+'",monospace'))})})};window.FontFaceObserver=B;window.FontFaceObserver.prototype.check=B.prototype.a;"undefined"!==typeof module&&(module.exports=window.FontFaceObserver);}());

},{}],193:[function(require,module,exports){
/**
* @preserve HTML5 Shiv 3.7.3 | @afarkas @jdalton @jon_neal @rem | MIT/GPL2 Licensed
*/
;(function(window, document) {
/*jshint evil:true */
  /** version */
  var version = '3.7.3-pre';

  /** Preset options */
  var options = window.html5 || {};

  /** Used to skip problem elements */
  var reSkip = /^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i;

  /** Not all elements can be cloned in IE **/
  var saveClones = /^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i;

  /** Detect whether the browser supports default html5 styles */
  var supportsHtml5Styles;

  /** Name of the expando, to work with multiple documents or to re-shiv one document */
  var expando = '_html5shiv';

  /** The id for the the documents expando */
  var expanID = 0;

  /** Cached data for each document */
  var expandoData = {};

  /** Detect whether the browser supports unknown elements */
  var supportsUnknownElements;

  (function() {
    try {
        var a = document.createElement('a');
        a.innerHTML = '<xyz></xyz>';
        //if the hidden property is implemented we can assume, that the browser supports basic HTML5 Styles
        supportsHtml5Styles = ('hidden' in a);

        supportsUnknownElements = a.childNodes.length == 1 || (function() {
          // assign a false positive if unable to shiv
          (document.createElement)('a');
          var frag = document.createDocumentFragment();
          return (
            typeof frag.cloneNode == 'undefined' ||
            typeof frag.createDocumentFragment == 'undefined' ||
            typeof frag.createElement == 'undefined'
          );
        }());
    } catch(e) {
      // assign a false positive if detection fails => unable to shiv
      supportsHtml5Styles = true;
      supportsUnknownElements = true;
    }

  }());

  /*--------------------------------------------------------------------------*/

  /**
   * Creates a style sheet with the given CSS text and adds it to the document.
   * @private
   * @param {Document} ownerDocument The document.
   * @param {String} cssText The CSS text.
   * @returns {StyleSheet} The style element.
   */
  function addStyleSheet(ownerDocument, cssText) {
    var p = ownerDocument.createElement('p'),
        parent = ownerDocument.getElementsByTagName('head')[0] || ownerDocument.documentElement;

    p.innerHTML = 'x<style>' + cssText + '</style>';
    return parent.insertBefore(p.lastChild, parent.firstChild);
  }

  /**
   * Returns the value of `html5.elements` as an array.
   * @private
   * @returns {Array} An array of shived element node names.
   */
  function getElements() {
    var elements = html5.elements;
    return typeof elements == 'string' ? elements.split(' ') : elements;
  }

  /**
   * Extends the built-in list of html5 elements
   * @memberOf html5
   * @param {String|Array} newElements whitespace separated list or array of new element names to shiv
   * @param {Document} ownerDocument The context document.
   */
  function addElements(newElements, ownerDocument) {
    var elements = html5.elements;
    if(typeof elements != 'string'){
      elements = elements.join(' ');
    }
    if(typeof newElements != 'string'){
      newElements = newElements.join(' ');
    }
    html5.elements = elements +' '+ newElements;
    shivDocument(ownerDocument);
  }

   /**
   * Returns the data associated to the given document
   * @private
   * @param {Document} ownerDocument The document.
   * @returns {Object} An object of data.
   */
  function getExpandoData(ownerDocument) {
    var data = expandoData[ownerDocument[expando]];
    if (!data) {
        data = {};
        expanID++;
        ownerDocument[expando] = expanID;
        expandoData[expanID] = data;
    }
    return data;
  }

  /**
   * returns a shived element for the given nodeName and document
   * @memberOf html5
   * @param {String} nodeName name of the element
   * @param {Document} ownerDocument The context document.
   * @returns {Object} The shived element.
   */
  function createElement(nodeName, ownerDocument, data){
    if (!ownerDocument) {
        ownerDocument = document;
    }
    if(supportsUnknownElements){
        return ownerDocument.createElement(nodeName);
    }
    if (!data) {
        data = getExpandoData(ownerDocument);
    }
    var node;

    if (data.cache[nodeName]) {
        node = data.cache[nodeName].cloneNode();
    } else if (saveClones.test(nodeName)) {
        node = (data.cache[nodeName] = data.createElem(nodeName)).cloneNode();
    } else {
        node = data.createElem(nodeName);
    }

    // Avoid adding some elements to fragments in IE < 9 because
    // * Attributes like `name` or `type` cannot be set/changed once an element
    //   is inserted into a document/fragment
    // * Link elements with `src` attributes that are inaccessible, as with
    //   a 403 response, will cause the tab/window to crash
    // * Script elements appended to fragments will execute when their `src`
    //   or `text` property is set
    return node.canHaveChildren && !reSkip.test(nodeName) && !node.tagUrn ? data.frag.appendChild(node) : node;
  }

  /**
   * returns a shived DocumentFragment for the given document
   * @memberOf html5
   * @param {Document} ownerDocument The context document.
   * @returns {Object} The shived DocumentFragment.
   */
  function createDocumentFragment(ownerDocument, data){
    if (!ownerDocument) {
        ownerDocument = document;
    }
    if(supportsUnknownElements){
        return ownerDocument.createDocumentFragment();
    }
    data = data || getExpandoData(ownerDocument);
    var clone = data.frag.cloneNode(),
        i = 0,
        elems = getElements(),
        l = elems.length;
    for(;i<l;i++){
        clone.createElement(elems[i]);
    }
    return clone;
  }

  /**
   * Shivs the `createElement` and `createDocumentFragment` methods of the document.
   * @private
   * @param {Document|DocumentFragment} ownerDocument The document.
   * @param {Object} data of the document.
   */
  function shivMethods(ownerDocument, data) {
    if (!data.cache) {
        data.cache = {};
        data.createElem = ownerDocument.createElement;
        data.createFrag = ownerDocument.createDocumentFragment;
        data.frag = data.createFrag();
    }


    ownerDocument.createElement = function(nodeName) {
      //abort shiv
      if (!html5.shivMethods) {
          return data.createElem(nodeName);
      }
      return createElement(nodeName, ownerDocument, data);
    };

    ownerDocument.createDocumentFragment = Function('h,f', 'return function(){' +
      'var n=f.cloneNode(),c=n.createElement;' +
      'h.shivMethods&&(' +
        // unroll the `createElement` calls
        getElements().join().replace(/[\w\-:]+/g, function(nodeName) {
          data.createElem(nodeName);
          data.frag.createElement(nodeName);
          return 'c("' + nodeName + '")';
        }) +
      ');return n}'
    )(html5, data.frag);
  }

  /*--------------------------------------------------------------------------*/

  /**
   * Shivs the given document.
   * @memberOf html5
   * @param {Document} ownerDocument The document to shiv.
   * @returns {Document} The shived document.
   */
  function shivDocument(ownerDocument) {
    if (!ownerDocument) {
        ownerDocument = document;
    }
    var data = getExpandoData(ownerDocument);

    if (html5.shivCSS && !supportsHtml5Styles && !data.hasCSS) {
      data.hasCSS = !!addStyleSheet(ownerDocument,
        // corrects block display not defined in IE6/7/8/9
        'article,aside,dialog,figcaption,figure,footer,header,hgroup,main,nav,section{display:block}' +
        // adds styling not present in IE6/7/8/9
        'mark{background:#FF0;color:#000}' +
        // hides non-rendered elements
        'template{display:none}'
      );
    }
    if (!supportsUnknownElements) {
      shivMethods(ownerDocument, data);
    }
    return ownerDocument;
  }

  /*--------------------------------------------------------------------------*/

  /**
   * The `html5` object is exposed so that more elements can be shived and
   * existing shiving can be detected on iframes.
   * @type Object
   * @example
   *
   * // options can be changed before the script is included
   * html5 = { 'elements': 'mark section', 'shivCSS': false, 'shivMethods': false };
   */
  var html5 = {

    /**
     * An array or space separated string of node names of the elements to shiv.
     * @memberOf html5
     * @type Array|String
     */
    'elements': options.elements || 'abbr article aside audio bdi canvas data datalist details dialog figcaption figure footer header hgroup main mark meter nav output picture progress section summary template time video',

    /**
     * current version of html5shiv
     */
    'version': version,

    /**
     * A flag to indicate that the HTML5 style sheet should be inserted.
     * @memberOf html5
     * @type Boolean
     */
    'shivCSS': (options.shivCSS !== false),

    /**
     * Is equal to true if a browser supports creating unknown/HTML5 elements
     * @memberOf html5
     * @type boolean
     */
    'supportsUnknownElements': supportsUnknownElements,

    /**
     * A flag to indicate that the document's `createElement` and `createDocumentFragment`
     * methods should be overwritten.
     * @memberOf html5
     * @type Boolean
     */
    'shivMethods': (options.shivMethods !== false),

    /**
     * A string to describe the type of `html5` object ("default" or "default print").
     * @memberOf html5
     * @type String
     */
    'type': 'default',

    // shivs the document according to the specified `html5` object options
    'shivDocument': shivDocument,

    //creates a shived element
    createElement: createElement,

    //creates a shived documentFragment
    createDocumentFragment: createDocumentFragment,

    //extends list of elements
    addElements: addElements
  };

  /*--------------------------------------------------------------------------*/

  // expose html5
  window.html5 = html5;

  // shiv the document
  shivDocument(document);

  if(typeof module == 'object' && module.exports){
    module.exports = html5;
  }

}(typeof window !== "undefined" ? window : this, document));

},{}],194:[function(require,module,exports){
(function (global){
(function (global){
/*!
Copyright (C) 2013-2015 by WebReflection

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
(function(window){
  /*! (C) WebReflection Mit Style License */
  if (document.createEvent) return;
  var
    DUNNOABOUTDOMLOADED = true,
    READYEVENTDISPATCHED = false,
    ONREADYSTATECHANGE = 'onreadystatechange',
    DOMCONTENTLOADED = 'DOMContentLoaded',
    SECRET = '__IE8__' + Math.random(),
    // Object = window.Object,
    defineProperty = Object.defineProperty ||
    // just in case ...
    function (object, property, descriptor) {
      object[property] = descriptor.value;
    },
    defineProperties = Object.defineProperties ||
    // IE8 implemented defineProperty but not the plural...
    function (object, descriptors) {
      for(var key in descriptors) {
        if (hasOwnProperty.call(descriptors, key)) {
          try {
            defineProperty(object, key, descriptors[key]);
          } catch(o_O) {
            if (window.console) {
              console.log(key + ' failed on object:', object, o_O.message);
            }
          }
        }
      }
    },
    getOwnPropertyDescriptor = Object.getOwnPropertyDescriptor,
    hasOwnProperty = Object.prototype.hasOwnProperty,
    // here IE7 will break like a charm
    ElementPrototype = window.Element.prototype,
    TextPrototype = window.Text.prototype,
    // none of above native constructors exist/are exposed
    possiblyNativeEvent = /^[a-z]+$/,
    // ^ actually could probably be just /^[a-z]+$/
    readyStateOK = /loaded|complete/,
    types = {},
    div = document.createElement('div'),
    html = document.documentElement,
    removeAttribute = html.removeAttribute,
    setAttribute = html.setAttribute
  ;

  function commonEventLoop(currentTarget, e, $handlers, synthetic) {
    for(var
      continuePropagation,
      handlers = $handlers.slice(),
      evt = enrich(e, currentTarget),
      i = 0, length = handlers.length; i < length; i++
    ) {
      handler = handlers[i];
      if (typeof handler === 'object') {
        if (typeof handler.handleEvent === 'function') {
          handler.handleEvent(evt);
        }
      } else {
        handler.call(currentTarget, evt);
      }
      if (evt.stoppedImmediatePropagation) break;
    }
    continuePropagation = !evt.stoppedPropagation;
    /*
    if (continuePropagation && !synthetic && !live(currentTarget)) {
      evt.cancelBubble = true;
    }
    */
    return (
      synthetic &&
      continuePropagation &&
      currentTarget.parentNode
    ) ?
      currentTarget.parentNode.dispatchEvent(evt) :
      !evt.defaultPrevented
    ;
  }

  function commonDescriptor(get, set) {
    return {
      // if you try with enumerable: true
      // IE8 will miserably fail
      configurable: true,
      get: get,
      set: set
    };
  }

  function commonTextContent(protoDest, protoSource, property) {
    var descriptor = getOwnPropertyDescriptor(
      protoSource || protoDest, property
    );
    defineProperty(
      protoDest,
      'textContent',
      commonDescriptor(
        function () {
          return descriptor.get.call(this);
        },
        function (textContent) {
          descriptor.set.call(this, textContent);
        }
      )
    );
  }

  function enrich(e, currentTarget) {
    e.currentTarget = currentTarget;
    e.eventPhase = (
      // AT_TARGET : BUBBLING_PHASE
      e.target === e.currentTarget ? 2 : 3
    );
    return e;
  }

  function find(array, value) {
    var i = array.length;
    while(i-- && array[i] !== value);
    return i;
  }

  function getTextContent() {
    if (this.tagName === 'BR') return '\n';
    var
      textNode = this.firstChild,
      arrayContent = []
    ;
    while(textNode) {
      if (textNode.nodeType !== 8 && textNode.nodeType !== 7) {
        arrayContent.push(textNode.textContent);
      }
      textNode = textNode.nextSibling;
    }
    return arrayContent.join('');
  }

  function live(self) {
    return self.nodeType !== 9 && html.contains(self);
  }

  function onkeyup(e) {
    var evt = document.createEvent('Event');
    evt.initEvent('input', true, true);
    (e.srcElement || e.fromElement || document).dispatchEvent(evt);
  }

  function onReadyState(e) {
    if (!READYEVENTDISPATCHED && readyStateOK.test(
      document.readyState
    )) {
      READYEVENTDISPATCHED = !READYEVENTDISPATCHED;
      document.detachEvent(ONREADYSTATECHANGE, onReadyState);
      e = document.createEvent('Event');
      e.initEvent(DOMCONTENTLOADED, true, true);
      document.dispatchEvent(e);
    }
  }

  function setTextContent(textContent) {
    var node;
    while ((node = this.lastChild)) {
      this.removeChild(node);
    }
    if (textContent != null) {
      this.appendChild(document.createTextNode(textContent));
    }
  }

  function verify(self, e) {
    if (!e) {
      e = window.event;
    }
    if (!e.target) {
      e.target = e.srcElement || e.fromElement || document;
    }
    if (!e.timeStamp) {
      e.timeStamp = (new Date).getTime();
    }
    return e;
  }

  // normalized textContent for:
  //  comment, script, style, text, title
  commonTextContent(
    window.HTMLCommentElement.prototype,
    ElementPrototype,
    'nodeValue'
  );

  commonTextContent(
    window.HTMLScriptElement.prototype,
    null,
    'text'
  );

  commonTextContent(
    TextPrototype,
    null,
    'nodeValue'
  );

  commonTextContent(
    window.HTMLTitleElement.prototype,
    null,
    'text'
  );

  defineProperty(
    window.HTMLStyleElement.prototype,
    'textContent',
    (function(descriptor){
      return commonDescriptor(
        function () {
          return descriptor.get.call(this.styleSheet);
        },
        function (textContent) {
          descriptor.set.call(this.styleSheet, textContent);
        }
      );
    }(getOwnPropertyDescriptor(window.CSSStyleSheet.prototype, 'cssText')))
  );

  defineProperties(
    ElementPrototype,
    {
      // bonus
      textContent: {
        get: getTextContent,
        set: setTextContent
      },
      // http://www.w3.org/TR/ElementTraversal/#interface-elementTraversal
      firstElementChild: {
        get: function () {
          for(var
            childNodes = this.childNodes || [],
            i = 0, length = childNodes.length;
            i < length; i++
          ) {
            if (childNodes[i].nodeType == 1) return childNodes[i];
          }
        }
      },
      lastElementChild: {
        get: function () {
          for(var
            childNodes = this.childNodes || [],
            i = childNodes.length;
            i--;
          ) {
            if (childNodes[i].nodeType == 1) return childNodes[i];
          }
        }
      },
      oninput: {
        get: function () {
          return this._oninput || null;
        },
        set: function (oninput) {
          if (this._oninput) {
            this.removeEventListener('input', this._oninput);
            this._oninput = oninput;
            if (oninput) {
              this.addEventListener('input', oninput);
            }
          }
        }
      },
      previousElementSibling: {
        get: function () {
          var previousElementSibling = this.previousSibling;
          while (previousElementSibling && previousElementSibling.nodeType != 1) {
            previousElementSibling = previousElementSibling.previousSibling;
          }
          return previousElementSibling;
        }
      },
      nextElementSibling: {
        get: function () {
          var nextElementSibling = this.nextSibling;
          while (nextElementSibling && nextElementSibling.nodeType != 1) {
            nextElementSibling = nextElementSibling.nextSibling;
          }
          return nextElementSibling;
        }
      },
      childElementCount: {
        get: function () {
          for(var
            count = 0,
            childNodes = this.childNodes || [],
            i = childNodes.length; i--; count += childNodes[i].nodeType == 1
          );
          return count;
        }
      },
      /*
      // children would be an override
      // IE8 already supports them but with comments too
      // not just nodeType 1
      children: {
        get: function () {
          for(var
            children = [],
            childNodes = this.childNodes || [],
            i = 0, length = childNodes.length;
            i < length; i++
          ) {
            if (childNodes[i].nodeType == 1) {
              children.push(childNodes[i]);
            }
          }
          return children;
        }
      },
      */
      // DOM Level 2 EventTarget methods and events
      addEventListener: {value: function (type, handler, capture) {
        if (typeof handler !== 'function' && typeof handler !== 'object') return;
        var
          self = this,
          ontype = 'on' + type,
          temple =  self[SECRET] ||
                      defineProperty(
                        self, SECRET, {value: {}}
                      )[SECRET],
          currentType = temple[ontype] || (temple[ontype] = {}),
          handlers  = currentType.h || (currentType.h = []),
          e, attr
        ;
        if (!hasOwnProperty.call(currentType, 'w')) {
          currentType.w = function (e) {
            // e[SECRET] is a silent notification needed to avoid
            // fired events during live test
            return e[SECRET] || commonEventLoop(self, verify(self, e), handlers, false);
          };
          // if not detected yet
          if (!hasOwnProperty.call(types, ontype)) {
            // and potentially a native event
            if(possiblyNativeEvent.test(type)) {
              // do this heavy thing
              try {
                // TODO:  should I consider tagName too so that
                //        INPUT[ontype] could be different ?
                e = document.createEventObject();
                // do not clone ever a node
                // specially a document one ...
                // use the secret to ignore them all
                e[SECRET] = true;
                // document a part if a node has never been
                // added to any other node, fireEvent might
                // behave very weirdly (read: trigger unspecified errors)
                if (self.nodeType != 9) {
                  if (self.parentNode == null) {
                    div.appendChild(self);
                  }
                  if (attr = self.getAttribute(ontype)) {
                    removeAttribute.call(self, ontype);
                  }
                }
                self.fireEvent(ontype, e);
                types[ontype] = true;
              } catch(e) {
                types[ontype] = false;
                while (div.hasChildNodes()) {
                  div.removeChild(div.firstChild);
                }
              }
              if (attr != null) {
                setAttribute.call(self, ontype, attr);
              }
            } else {
              // no need to bother since
              // 'x-event' ain't native for sure
              types[ontype] = false;
            }
          }
          if (currentType.n = types[ontype]) {
            self.attachEvent(ontype, currentType.w);
          }
        }
        if (find(handlers, handler) < 0) {
          handlers[capture ? 'unshift' : 'push'](handler);
        }
        if (type === 'input') {
          self.attachEvent('onkeyup', onkeyup);
        }
      }},
      dispatchEvent: {value: function (e) {
        var
          self = this,
          ontype = 'on' + e.type,
          temple =  self[SECRET],
          currentType = temple && temple[ontype],
          valid = !!currentType,
          parentNode
        ;
        if (!e.target) e.target = self;
        return (valid ? (
          currentType.n /* && live(self) */ ?
            self.fireEvent(ontype, e) :
            commonEventLoop(
              self,
              e,
              currentType.h,
              true
            )
        ) : (
          (parentNode = self.parentNode) /* && live(self) */ ?
            parentNode.dispatchEvent(e) :
            true
        )), !e.defaultPrevented;
      }},
      removeEventListener: {value: function (type, handler, capture) {
        if (typeof handler !== 'function' && typeof handler !== 'object') return;
        var
          self = this,
          ontype = 'on' + type,
          temple =  self[SECRET],
          currentType = temple && temple[ontype],
          handlers = currentType && currentType.h,
          i = handlers ? find(handlers, handler) : -1
        ;
        if (-1 < i) handlers.splice(i, 1);
      }}
    }
  );

  /* this is not needed in IE8
  defineProperties(window.HTMLSelectElement.prototype, {
    value: {
      get: function () {
        return this.options[this.selectedIndex].value;
      }
    }
  });
  //*/

  // EventTarget methods for Text nodes too
  defineProperties(TextPrototype, {
    addEventListener: {value: ElementPrototype.addEventListener},
    dispatchEvent: {value: ElementPrototype.dispatchEvent},
    removeEventListener: {value: ElementPrototype.removeEventListener}
  });

  defineProperties(
    window.XMLHttpRequest.prototype,
    {
      addEventListener: {value: function (type, handler, capture) {
        var
          self = this,
          ontype = 'on' + type,
          temple =  self[SECRET] ||
                      defineProperty(
                        self, SECRET, {value: {}}
                      )[SECRET],
          currentType = temple[ontype] || (temple[ontype] = {}),
          handlers  = currentType.h || (currentType.h = [])
        ;
        if (find(handlers, handler) < 0) {
          if (!self[ontype]) {
            self[ontype] = function () {
              var e = document.createEvent('Event');
              e.initEvent(type, true, true);
              self.dispatchEvent(e);
            };
          }
          handlers[capture ? 'unshift' : 'push'](handler);
        }
      }},
      dispatchEvent: {value: function (e) {
        var
          self = this,
          ontype = 'on' + e.type,
          temple =  self[SECRET],
          currentType = temple && temple[ontype],
          valid = !!currentType
        ;
        return valid && (
          currentType.n /* && live(self) */ ?
            self.fireEvent(ontype, e) :
            commonEventLoop(
              self,
              e,
              currentType.h,
              true
            )
        );
      }},
      removeEventListener: {value: ElementPrototype.removeEventListener}
    }
  );

  defineProperties(
    window.Event.prototype,
    {
      bubbles: {value: true, writable: true},
      cancelable: {value: true, writable: true},
      preventDefault: {value: function () {
        if (this.cancelable) {
          this.defaultPrevented = true;
          this.returnValue = false;
        }
      }},
      stopPropagation: {value: function () {
        this.stoppedPropagation = true;
        this.cancelBubble = true;
      }},
      stopImmediatePropagation: {value: function () {
        this.stoppedImmediatePropagation = true;
        this.stopPropagation();
      }},
      initEvent: {value: function(type, bubbles, cancelable){
        this.type = type;
        this.bubbles = !!bubbles;
        this.cancelable = !!cancelable;
        if (!this.bubbles) {
          this.stopPropagation();
        }
      }}
    }
  );

  defineProperties(
    window.HTMLDocument.prototype,
    {
      defaultView: {
        get: function () {
          return this.parentWindow;
        }
      },
      textContent: {
        get: function () {
          return this.nodeType === 11 ? getTextContent.call(this) : null;
        },
        set: function (textContent) {
          if (this.nodeType === 11) {
            setTextContent.call(this, textContent);
          }
        }
      },
      addEventListener: {value: function(type, handler, capture) {
        var self = this;
        ElementPrototype.addEventListener.call(self, type, handler, capture);
        // NOTE:  it won't fire if already loaded, this is NOT a $.ready() shim!
        //        this behaves just like standard browsers
        if (
          DUNNOABOUTDOMLOADED &&
          type === DOMCONTENTLOADED &&
          !readyStateOK.test(
            self.readyState
          )
        ) {
          DUNNOABOUTDOMLOADED = false;
          self.attachEvent(ONREADYSTATECHANGE, onReadyState);
          if (window == top) {
            (function gonna(e){try{
              self.documentElement.doScroll('left');
              onReadyState();
              }catch(o_O){
              setTimeout(gonna, 50);
            }}());
          }
        }
      }},
      dispatchEvent: {value: ElementPrototype.dispatchEvent},
      removeEventListener: {value: ElementPrototype.removeEventListener},
      createEvent: {value: function(Class){
        var e;
        if (Class !== 'Event') throw new Error('unsupported ' + Class);
        e = document.createEventObject();
        e.timeStamp = (new Date).getTime();
        return e;
      }}
    }
  );

  defineProperties(
    window.Window.prototype,
    {
      getComputedStyle: {value: function(){

        var // partially grabbed from jQuery and Dean's hack
          notpixel = /^(?:[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|))(?!px)[a-z%]+$/,
          position = /^(top|right|bottom|left)$/,
          re = /\-([a-z])/g,
          place = function (match, $1) {
            return $1.toUpperCase();
          }
        ;

        function ComputedStyle(_) {
          this._ = _;
        }

        ComputedStyle.prototype.getPropertyValue = function (name) {
          var
            el = this._,
            style = el.style,
            currentStyle = el.currentStyle,
            runtimeStyle = el.runtimeStyle,
            result,
            left,
            rtLeft
          ;
          name = (name === 'float' ? 'style-float' : name).replace(re, place);
          result = currentStyle ? currentStyle[name] : style[name];
          if (notpixel.test(result) && !position.test(name)) {
            left = style.left;
            rtLeft = runtimeStyle && runtimeStyle.left;
            if (rtLeft) {
              runtimeStyle.left = currentStyle.left;
            }
            style.left = name === 'fontSize' ? '1em' : result;
            result = style.pixelLeft + 'px';
            style.left = left;
            if (rtLeft) {
              runtimeStyle.left = rtLeft;
            }
          }
          return result == null ?
            result : ((result + '') || 'auto');
        };

        // unsupported
        function PseudoComputedStyle() {}
        PseudoComputedStyle.prototype.getPropertyValue = function () {
          return null;
        };

        return function (el, pseudo) {
          return pseudo ?
            new PseudoComputedStyle(el) :
            new ComputedStyle(el);
        };

      }()},

      addEventListener: {value: function (type, handler, capture) {
        var
          self = window,
          ontype = 'on' + type,
          handlers
        ;
        if (!self[ontype]) {
          self[ontype] = function(e) {
            return commonEventLoop(self, verify(self, e), handlers, false);
          };
        }
        handlers = self[ontype][SECRET] || (
          self[ontype][SECRET] = []
        );
        if (find(handlers, handler) < 0) {
          handlers[capture ? 'unshift' : 'push'](handler);
        }
      }},
      dispatchEvent: {value: function (e) {
        var method = window['on' + e.type];
        return method ? method.call(window, e) !== false && !e.defaultPrevented : true;
      }},
      removeEventListener: {value: function (type, handler, capture) {
        var
          ontype = 'on' + type,
          handlers = (window[ontype] || Object)[SECRET],
          i = handlers ? find(handlers, handler) : -1
         ;
        if (-1 < i) handlers.splice(i, 1);
      }}
    }
  );

  (function (styleSheets, HTML5Element, i) {
    for (i = 0; i < HTML5Element.length; i++) document.createElement(HTML5Element[i]);
    if (!styleSheets.length) document.createStyleSheet('');
    styleSheets[0].addRule(HTML5Element.join(','), 'display:block;');
  }(document.styleSheets, ['header', 'nav', 'section', 'article', 'aside', 'footer']));
}(this.window || global));
}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],195:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _path = require('./path');

var _path2 = _interopRequireDefault(_path);

var _polygon = require('./polygon');

var _polygon2 = _interopRequireDefault(_polygon);

var _ops = require('./ops');

var reflect = function reflect(p, q) {
  return (0, _ops.minus)((0, _ops.times)(2, p), q);
};

exports['default'] = function (_ref) {
  var _Path;

  var points = _ref.points;
  var tension = _ref.tension;

  tension = tension || 0.3;
  var diffs = [];
  var l = points.length;
  if (l <= 2) {
    return (0, _polygon2['default'])({ points: points });
  }
  for (var i = 1; i <= l - 1; i++) {
    diffs.push((0, _ops.times)(tension, (0, _ops.minus)(points[i], points[i - 1])));
  }
  var controlPoints = [(0, _ops.plus)(points[0], reflect(diffs[0], diffs[1]))];
  for (var i = 1; i <= l - 2; i++) {
    controlPoints.push((0, _ops.minus)(points[i], (0, _ops.average)([diffs[i], diffs[i - 1]])));
  }
  controlPoints.push((0, _ops.minus)(points[l - 1], reflect(diffs[l - 2], diffs[l - 3])));
  var c0 = controlPoints[0];
  var c1 = controlPoints[1];
  var p0 = points[0];
  var p1 = points[1];
  var path = (_Path = (0, _path2['default'])()).moveto.apply(_Path, _toConsumableArray(p0)).curveto(c0[0], c0[1], c1[0], c1[1], p1[0], p1[1]);

  return {
    path: (0, _ops.range)(2, l).reduce(function (pt, i) {
      var c = controlPoints[i];
      var p = points[i];
      return pt.smoothcurveto(c[0], c[1], p[0], p[1]);
    }, path),
    centroid: (0, _ops.average)(points)
  };
};

module.exports = exports['default'];
},{"./ops":198,"./path":199,"./polygon":200}],196:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i['return']) _i['return'](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError('Invalid attempt to destructure non-iterable instance'); } }; })();

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _linear = require('./linear');

var _linear2 = _interopRequireDefault(_linear);

var _ops = require('./ops');

var epsilon = 1e-5;

var box = function box(datum, accessor) {
  var points = datum.map(accessor);
  var sorted = points.sort(function (_ref, _ref3) {
    var _ref2 = _slicedToArray(_ref, 2);

    var a = _ref2[0];
    var b = _ref2[1];

    var _ref32 = _slicedToArray(_ref3, 2);

    var c = _ref32[0];
    var d = _ref32[1];
    return a - c;
  });
  var l = sorted.length;
  var xmin = sorted[0][0];
  var xmax = sorted[l - 1][0];
  var ymin = (0, _ops.minBy)(sorted, function (p) {
    return p[1];
  });
  var ymax = (0, _ops.maxBy)(sorted, function (p) {
    return p[1];
  });
  if (xmin == xmax) {
    xmax += epsilon;
  }
  if (ymin == ymax) {
    ymax += epsilon;
  }

  return {
    points: sorted,
    xmin: xmin,
    xmax: xmax,
    ymin: ymin,
    ymax: ymax
  };
};

exports['default'] = function (_ref4) {
  var data = _ref4.data;
  var xaccessor = _ref4.xaccessor;
  var yaccessor = _ref4.yaccessor;
  var width = _ref4.width;
  var height = _ref4.height;
  var closed = _ref4.closed;
  var min = _ref4.min;
  var max = _ref4.max;

  if (!xaccessor) {
    xaccessor = function (_ref5) {
      var _ref52 = _slicedToArray(_ref5, 2);

      var x = _ref52[0];
      var y = _ref52[1];
      return x;
    };
  }
  if (!yaccessor) {
    yaccessor = function (_ref6) {
      var _ref62 = _slicedToArray(_ref6, 2);

      var x = _ref62[0];
      var y = _ref62[1];
      return y;
    };
  }
  var f = function f(i) {
    return [xaccessor(i), yaccessor(i)];
  };
  var arranged = data.map(function (datum) {
    return box(datum, f);
  });

  var xmin = (0, _ops.minBy)(arranged, function (d) {
    return d.xmin;
  });
  var xmax = (0, _ops.maxBy)(arranged, function (d) {
    return d.xmax;
  });
  var ymin = min == null ? (0, _ops.minBy)(arranged, function (d) {
    return d.ymin;
  }) : min;
  var ymax = max == null ? (0, _ops.maxBy)(arranged, function (d) {
    return d.ymax;
  }) : max;
  if (closed) {
    ymin = Math.min(ymin, 0);
    ymax = Math.max(ymax, 0);
  }
  var base = closed ? 0 : ymin;
  var xscale = (0, _linear2['default'])([xmin, xmax], [0, width]);
  var yscale = (0, _linear2['default'])([ymin, ymax], [height, 0]);
  var scale = function scale(_ref7) {
    var _ref72 = _slicedToArray(_ref7, 2);

    var x = _ref72[0];
    var y = _ref72[1];
    return [xscale(x), yscale(y)];
  };

  return {
    arranged: arranged,
    scale: scale,
    xscale: xscale,
    yscale: yscale,
    base: base
  };
};

module.exports = exports['default'];
},{"./linear":197,"./ops":198}],197:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; })();

var linear = function linear(_ref, _ref3) {
  var _ref2 = _slicedToArray(_ref, 2);

  var a = _ref2[0];
  var b = _ref2[1];

  var _ref32 = _slicedToArray(_ref3, 2);

  var c = _ref32[0];
  var d = _ref32[1];

  var f = function f(x) {
    return c + (d - c) * (x - a) / (b - a);
  };

  f.inverse = function () {
    return linear([c, d], [a, b]);
  };
  return f;
};

exports["default"] = linear;
module.exports = exports["default"];
},{}],198:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; })();

var sum = function sum(xs) {
  return xs.reduce(function (a, b) {
    return a + b;
  }, 0);
};

var min = function min(xs) {
  return xs.reduce(function (a, b) {
    return Math.min(a, b);
  });
};

var max = function max(xs) {
  return xs.reduce(function (a, b) {
    return Math.max(a, b);
  });
};

var sumBy = function sumBy(xs, f) {
  return xs.reduce(function (a, b) {
    return a + f(b);
  }, 0);
};

var minBy = function minBy(xs, f) {
  return xs.reduce(function (a, b) {
    return Math.min(a, f(b));
  }, Infinity);
};

var maxBy = function maxBy(xs, f) {
  return xs.reduce(function (a, b) {
    return Math.max(a, f(b));
  }, -Infinity);
};

var plus = function plus(_ref, _ref3) {
  var _ref2 = _slicedToArray(_ref, 2);

  var a = _ref2[0];
  var b = _ref2[1];

  var _ref32 = _slicedToArray(_ref3, 2);

  var c = _ref32[0];
  var d = _ref32[1];
  return [a + c, b + d];
};

var minus = function minus(_ref4, _ref5) {
  var _ref42 = _slicedToArray(_ref4, 2);

  var a = _ref42[0];
  var b = _ref42[1];

  var _ref52 = _slicedToArray(_ref5, 2);

  var c = _ref52[0];
  var d = _ref52[1];
  return [a - c, b - d];
};

var times = function times(k, _ref6) {
  var _ref62 = _slicedToArray(_ref6, 2);

  var a = _ref62[0];
  var b = _ref62[1];
  return [k * a, k * b];
};

var length = function length(_ref7) {
  var _ref72 = _slicedToArray(_ref7, 2);

  var a = _ref72[0];
  var b = _ref72[1];
  return Math.sqrt(a * a + b * b);
};

var sumVectors = function sumVectors(xs) {
  return xs.reduce(plus, [0, 0]);
};

var average = function average(points) {
  return times(1 / points.length, points.reduce(plus));
};

var onCircle = function onCircle(r, angle) {
  return times(r, [Math.sin(angle), -Math.cos(angle)]);
};

var enhance = function enhance(compute, curve) {
  var obj = compute || {};
  for (var key in obj) {
    var method = obj[key];
    curve[key] = method(curve.index, curve.item, curve.group);
  }
  return curve;
};

var range = function range(a, b, inclusive) {
  var result = [];
  for (var i = a; i < b; i++) {
    result.push(i);
  }
  if (inclusive) {
    result.push(b);
  }
  return result;
};

var mapObject = function mapObject(obj, f) {
  var result = [];
  var _iteratorNormalCompletion = true;
  var _didIteratorError = false;
  var _iteratorError = undefined;

  try {
    for (var _iterator = Object.keys(obj)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
      var k = _step.value;

      var v = obj[k];
      result.push(f(k, v));
    }
  } catch (err) {
    _didIteratorError = true;
    _iteratorError = err;
  } finally {
    try {
      if (!_iteratorNormalCompletion && _iterator["return"]) {
        _iterator["return"]();
      }
    } finally {
      if (_didIteratorError) {
        throw _iteratorError;
      }
    }
  }

  return result;
};

var pairs = function pairs(obj) {
  return mapObject(obj, function (k, v) {
    return [k, v];
  });
};

var id = function id(x) {
  return x;
};

exports.sum = sum;
exports.min = min;
exports.max = max;
exports.sumBy = sumBy;
exports.minBy = minBy;
exports.maxBy = maxBy;
exports.plus = plus;
exports.minus = minus;
exports.times = times;
exports.id = id;
exports.length = length;
exports.sumVectors = sumVectors;
exports.average = average;
exports.onCircle = onCircle;
exports.enhance = enhance;
exports.range = range;
exports.mapObject = mapObject;
exports.pairs = pairs;
exports["default"] = { sum: sum, min: min, max: max, sumBy: sumBy, minBy: minBy, maxBy: maxBy, plus: plus, minus: minus, times: times, id: id,
  length: length, sumVectors: sumVectors, average: average, onCircle: onCircle, enhance: enhance, range: range, mapObject: mapObject, pairs: pairs };
},{}],199:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i['return']) _i['return'](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError('Invalid attempt to destructure non-iterable instance'); } }; })();

var Path = function Path(init) {
  var _instructions = init || [];

  var push = function push(arr, el) {
    var copy = arr.slice(0, arr.length);
    copy.push(el);
    return copy;
  };

  var areEqualPoints = function areEqualPoints(_ref, _ref3) {
    var _ref2 = _slicedToArray(_ref, 2);

    var a1 = _ref2[0];
    var b1 = _ref2[1];

    var _ref32 = _slicedToArray(_ref3, 2);

    var a2 = _ref32[0];
    var b2 = _ref32[1];
    return a1 === a2 && b1 === b2;
  };

  var trimZeros = function trimZeros(string, char) {
    var l = string.length;
    while (string.charAt(l - 1) === '0') {
      l = l - 1;
    }
    if (string.charAt(l - 1) === '.') {
      l = l - 1;
    }
    return string.substr(0, l);
  };

  var round = function round(number, digits) {
    var str = number.toFixed(digits);
    return trimZeros(str);
  };

  var printInstrunction = function printInstrunction(_ref4) {
    var command = _ref4.command;
    var params = _ref4.params;

    var numbers = params.map(function (param) {
      return round(param, 6);
    });
    return command + ' ' + numbers.join(' ');
  };

  var point = function point(_ref5, _ref6) {
    var command = _ref5.command;
    var params = _ref5.params;

    var _ref62 = _slicedToArray(_ref6, 2);

    var prevX = _ref62[0];
    var prevY = _ref62[1];

    switch (command) {
      case 'M':
        return [params[0], params[1]];
      case 'L':
        return [params[0], params[1]];
      case 'H':
        return [params[0], prevY];
      case 'V':
        return [prevX, params[0]];
      case 'Z':
        return null;
      case 'C':
        return [params[4], params[5]];
      case 'S':
        return [params[2], params[3]];
      case 'Q':
        return [params[2], params[3]];
      case 'T':
        return [params[0], params[1]];
      case 'A':
        return [params[5], params[6]];
    }
  };

  var verbosify = function verbosify(keys, f) {
    return function (a) {
      var args = typeof a === 'object' ? keys.map(function (k) {
        return a[k];
      }) : arguments;
      return f.apply(null, args);
    };
  };

  var plus = function plus(instruction) {
    return Path(push(_instructions, instruction));
  };

  return {
    moveto: verbosify(['x', 'y'], function (x, y) {
      return plus({
        command: 'M',
        params: [x, y]
      });
    }),
    lineto: verbosify(['x', 'y'], function (x, y) {
      return plus({
        command: 'L',
        params: [x, y]
      });
    }),
    hlineto: verbosify(['x'], function (x) {
      return plus({
        command: 'H',
        params: [x]
      });
    }),
    vlineto: verbosify(['y'], function (y) {
      return plus({
        command: 'V',
        params: [y]
      });
    }),
    closepath: function closepath() {
      return plus({
        command: 'Z',
        params: []
      });
    },
    curveto: verbosify(['x1', 'y1', 'x2', 'y2', 'x', 'y'], function (x1, y1, x2, y2, x, y) {
      return plus({
        command: 'C',
        params: [x1, y1, x2, y2, x, y]
      });
    }),
    smoothcurveto: verbosify(['x2', 'y2', 'x', 'y'], function (x2, y2, x, y) {
      return plus({
        command: 'S',
        params: [x2, y2, x, y]
      });
    }),
    qcurveto: verbosify(['x1', 'y1', 'x', 'y'], function (x1, y1, x, y) {
      return plus({
        command: 'Q',
        params: [x1, y1, x, y]
      });
    }),
    smoothqcurveto: verbosify(['x', 'y'], function (x, y) {
      return plus({
        command: 'T',
        params: [x, y]
      });
    }),
    arc: verbosify(['rx', 'ry', 'xrot', 'largeArcFlag', 'sweepFlag', 'x', 'y'], function (rx, ry, xrot, largeArcFlag, sweepFlag, x, y) {
      return plus({
        command: 'A',
        params: [rx, ry, xrot, largeArcFlag, sweepFlag, x, y]
      });
    }),
    print: function print() {
      return _instructions.map(printInstrunction).join(' ');
    },
    points: function points() {
      var ps = [];
      var prev = [0, 0];
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = _instructions[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var instruction = _step.value;

          var p = point(instruction, prev);
          prev = p;
          if (p) {
            ps.push(p);
          }
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator['return']) {
            _iterator['return']();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }

      return ps;
    },
    instructions: function instructions() {
      return _instructions.slice(0, _instructions.length);
    },
    connect: function connect(path) {
      var ps = this.points();
      var last = ps[ps.length - 1];
      var first = path.points()[0];
      var newInstructions = path.instructions().slice(1);
      if (!areEqualPoints(last, first)) {
        newInstructions.unshift({
          command: "L",
          params: first
        });
      }
      return Path(this.instructions().concat(newInstructions));
    }
  };
};

exports['default'] = function () {
  return Path();
};

module.exports = exports['default'];
},{}],200:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _path = require('./path');

var _path2 = _interopRequireDefault(_path);

var _ops = require('./ops');

exports['default'] = function (_ref) {
  var _Path;

  var points = _ref.points;
  var closed = _ref.closed;

  var l = points.length;
  var head = points[0];
  var tail = points.slice(1, l + 1);
  var path = tail.reduce(function (pt, p) {
    return pt.lineto.apply(pt, _toConsumableArray(p));
  }, (_Path = (0, _path2['default'])()).moveto.apply(_Path, _toConsumableArray(head)));

  return {
    path: closed ? path.closepath() : path,
    centroid: (0, _ops.average)(points)
  };
};

module.exports = exports['default'];
},{"./ops":198,"./path":199}],201:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _bezier = require('./bezier');

var _bezier2 = _interopRequireDefault(_bezier);

var _lineChartComp = require('./line-chart-comp');

var _lineChartComp2 = _interopRequireDefault(_lineChartComp);

var _ops = require('./ops');

exports['default'] = function (options) {
  var _comp = (0, _lineChartComp2['default'])(options);

  var arranged = _comp.arranged;
  var scale = _comp.scale;
  var xscale = _comp.xscale;
  var yscale = _comp.yscale;
  var base = _comp.base;

  var i = -1;

  var lines = arranged.map(function (_ref) {
    var _line$path$lineto, _line$path;

    var points = _ref.points;
    var xmin = _ref.xmin;
    var xmax = _ref.xmax;

    var scaledPoints = points.map(scale);
    i += 1;
    var line = (0, _bezier2['default'])({ points: scaledPoints });
    var area = {
      path: (_line$path$lineto = (_line$path = line.path).lineto.apply(_line$path, _toConsumableArray(scale([xmax, base])))).lineto.apply(_line$path$lineto, _toConsumableArray(scale([xmin, base]))).closepath(),
      centroid: (0, _ops.average)([line.centroid, scale([xmin, base]), scale([xmax, base])])
    };

    return (0, _ops.enhance)(options.compute, {
      item: options.data[i],
      line: line,
      area: area,
      index: i
    });
  });

  return {
    curves: lines,
    xscale: xscale,
    yscale: yscale
  };
};

module.exports = exports['default'];
},{"./bezier":195,"./line-chart-comp":196,"./ops":198}],202:[function(require,module,exports){
// shim for using process in browser
var process = module.exports = {};

// cached from whatever global is present so that test runners that stub it
// don't break things.  But we need to wrap it in a try catch in case it is
// wrapped in strict mode code which doesn't define any globals.  It's inside a
// function because try/catches deoptimize in certain engines.

var cachedSetTimeout;
var cachedClearTimeout;

function defaultSetTimout() {
    throw new Error('setTimeout has not been defined');
}
function defaultClearTimeout () {
    throw new Error('clearTimeout has not been defined');
}
(function () {
    try {
        if (typeof setTimeout === 'function') {
            cachedSetTimeout = setTimeout;
        } else {
            cachedSetTimeout = defaultSetTimout;
        }
    } catch (e) {
        cachedSetTimeout = defaultSetTimout;
    }
    try {
        if (typeof clearTimeout === 'function') {
            cachedClearTimeout = clearTimeout;
        } else {
            cachedClearTimeout = defaultClearTimeout;
        }
    } catch (e) {
        cachedClearTimeout = defaultClearTimeout;
    }
} ())
function runTimeout(fun) {
    if (cachedSetTimeout === setTimeout) {
        //normal enviroments in sane situations
        return setTimeout(fun, 0);
    }
    // if setTimeout wasn't available but was latter defined
    if ((cachedSetTimeout === defaultSetTimout || !cachedSetTimeout) && setTimeout) {
        cachedSetTimeout = setTimeout;
        return setTimeout(fun, 0);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedSetTimeout(fun, 0);
    } catch(e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't trust the global object when called normally
            return cachedSetTimeout.call(null, fun, 0);
        } catch(e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error
            return cachedSetTimeout.call(this, fun, 0);
        }
    }


}
function runClearTimeout(marker) {
    if (cachedClearTimeout === clearTimeout) {
        //normal enviroments in sane situations
        return clearTimeout(marker);
    }
    // if clearTimeout wasn't available but was latter defined
    if ((cachedClearTimeout === defaultClearTimeout || !cachedClearTimeout) && clearTimeout) {
        cachedClearTimeout = clearTimeout;
        return clearTimeout(marker);
    }
    try {
        // when when somebody has screwed with setTimeout but no I.E. maddness
        return cachedClearTimeout(marker);
    } catch (e){
        try {
            // When we are in I.E. but the script has been evaled so I.E. doesn't  trust the global object when called normally
            return cachedClearTimeout.call(null, marker);
        } catch (e){
            // same as above but when it's a version of I.E. that must have the global object for 'this', hopfully our context correct otherwise it will throw a global error.
            // Some versions of I.E. have different rules for clearTimeout vs setTimeout
            return cachedClearTimeout.call(this, marker);
        }
    }



}
var queue = [];
var draining = false;
var currentQueue;
var queueIndex = -1;

function cleanUpNextTick() {
    if (!draining || !currentQueue) {
        return;
    }
    draining = false;
    if (currentQueue.length) {
        queue = currentQueue.concat(queue);
    } else {
        queueIndex = -1;
    }
    if (queue.length) {
        drainQueue();
    }
}

function drainQueue() {
    if (draining) {
        return;
    }
    var timeout = runTimeout(cleanUpNextTick);
    draining = true;

    var len = queue.length;
    while(len) {
        currentQueue = queue;
        queue = [];
        while (++queueIndex < len) {
            if (currentQueue) {
                currentQueue[queueIndex].run();
            }
        }
        queueIndex = -1;
        len = queue.length;
    }
    currentQueue = null;
    draining = false;
    runClearTimeout(timeout);
}

process.nextTick = function (fun) {
    var args = new Array(arguments.length - 1);
    if (arguments.length > 1) {
        for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
        }
    }
    queue.push(new Item(fun, args));
    if (queue.length === 1 && !draining) {
        runTimeout(drainQueue);
    }
};

// v8 likes predictible objects
function Item(fun, array) {
    this.fun = fun;
    this.array = array;
}
Item.prototype.run = function () {
    this.fun.apply(null, this.array);
};
process.title = 'browser';
process.browser = true;
process.env = {};
process.argv = [];
process.version = ''; // empty string to avoid regexp issues
process.versions = {};

function noop() {}

process.on = noop;
process.addListener = noop;
process.once = noop;
process.off = noop;
process.removeListener = noop;
process.removeAllListeners = noop;
process.emit = noop;

process.binding = function (name) {
    throw new Error('process.binding is not supported');
};

process.cwd = function () { return '/' };
process.chdir = function (dir) {
    throw new Error('process.chdir is not supported');
};
process.umask = function() { return 0; };

},{}],203:[function(require,module,exports){
(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
	typeof define === 'function' && define.amd ? define(['exports'], factory) :
	factory(global.Ractive.events)
}(this, function (exports) { 'use strict';

	// TODO can we just declare the keydowhHandler once? using `this`?
	function makeKeyDefinition(code) {
		return function (node, fire) {
			function keydownHandler(event) {
				var which = event.which || event.keyCode;

				if (which === code) {
					event.preventDefault();

					fire({
						node: node,
						original: event
					});
				}
			}

			node.addEventListener('keydown', keydownHandler, false);

			return {
				teardown: function teardown() {
					node.removeEventListener('keydown', keydownHandler, false);
				}
			};
		};
	}

	var enter = makeKeyDefinition(13);
	var tab = makeKeyDefinition(9);
	var ractive_events_keys__escape = makeKeyDefinition(27);
	var space = makeKeyDefinition(32);

	var leftarrow = makeKeyDefinition(37);
	var rightarrow = makeKeyDefinition(39);
	var downarrow = makeKeyDefinition(40);
	var uparrow = makeKeyDefinition(38);

	exports.enter = enter;
	exports.tab = tab;
	exports.escape = ractive_events_keys__escape;
	exports.space = space;
	exports.leftarrow = leftarrow;
	exports.rightarrow = rightarrow;
	exports.downarrow = downarrow;
	exports.uparrow = uparrow;

}));
},{}],204:[function(require,module,exports){
(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
	typeof define === 'function' && define.amd ? define(factory) :
	global.Ractive.transitions.fade = factory();
}(this, function () { 'use strict';

	var DEFAULTS = {
		delay: 0,
		duration: 300,
		easing: 'linear'
	};

	function fade(t, params) {
		var targetOpacity;

		params = t.processParams(params, DEFAULTS);

		if (t.isIntro) {
			targetOpacity = t.getStyle('opacity');
			t.setStyle('opacity', 0);
		} else {
			targetOpacity = 0;
		}

		t.animateStyle('opacity', targetOpacity, params).then(t.complete);
	}

	return fade;

}));
},{}],205:[function(require,module,exports){
/*
	Ractive.js v0.7.3
	Sat Apr 25 2015 13:52:38 GMT-0400 (EDT) - commit da40f81c660ba2f09c45a09a9c20fdd34ee36d80

	http://ractivejs.org
	http://twitter.com/RactiveJS

	Released under the MIT License.
*/

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  global.Ractive = factory()
}(this, function () { 'use strict';

  var TEMPLATE_VERSION = 3;

  var defaultOptions = {

  	// render placement:
  	el: void 0,
  	append: false,

  	// template:
  	template: { v: TEMPLATE_VERSION, t: [] },

  	// parse:     // TODO static delimiters?
  	preserveWhitespace: false,
  	sanitize: false,
  	stripComments: true,
  	delimiters: ["{{", "}}"],
  	tripleDelimiters: ["{{{", "}}}"],
  	interpolate: false,

  	// data & binding:
  	data: {},
  	computed: {},
  	magic: false,
  	modifyArrays: true,
  	adapt: [],
  	isolated: false,
  	twoway: true,
  	lazy: false,

  	// transitions:
  	noIntro: false,
  	transitionsEnabled: true,
  	complete: void 0,

  	// css:
  	css: null,
  	noCssTransform: false
  };

  var config_defaults = defaultOptions;

  // These are a subset of the easing equations found at
  // https://raw.github.com/danro/easing-js - license info
  // follows:

  // --------------------------------------------------
  // easing.js v0.5.4
  // Generic set of easing functions with AMD support
  // https://github.com/danro/easing-js
  // This code may be freely distributed under the MIT license
  // http://danro.mit-license.org/
  // --------------------------------------------------
  // All functions adapted from Thomas Fuchs & Jeremy Kahn
  // Easing Equations (c) 2003 Robert Penner, BSD license
  // https://raw.github.com/danro/easing-js/master/LICENSE
  // --------------------------------------------------

  // In that library, the functions named easeIn, easeOut, and
  // easeInOut below are named easeInCubic, easeOutCubic, and
  // (you guessed it) easeInOutCubic.
  //
  // You can add additional easing functions to this list, and they
  // will be globally available.

  var static_easing = {
  	linear: function (pos) {
  		return pos;
  	},
  	easeIn: function (pos) {
  		return Math.pow(pos, 3);
  	},
  	easeOut: function (pos) {
  		return Math.pow(pos - 1, 3) + 1;
  	},
  	easeInOut: function (pos) {
  		if ((pos /= 0.5) < 1) {
  			return 0.5 * Math.pow(pos, 3);
  		}
  		return 0.5 * (Math.pow(pos - 2, 3) + 2);
  	}
  };

  /*global console, navigator */
  var isClient, isJsdom, hasConsole, environment__magic, namespaces, svg, vendors;

  isClient = typeof document === "object";

  isJsdom = typeof navigator !== "undefined" && /jsDom/.test(navigator.appName);

  hasConsole = typeof console !== "undefined" && typeof console.warn === "function" && typeof console.warn.apply === "function";

  try {
  	Object.defineProperty({}, "test", { value: 0 });
  	environment__magic = true;
  } catch (e) {
  	environment__magic = false;
  }

  namespaces = {
  	html: "http://www.w3.org/1999/xhtml",
  	mathml: "http://www.w3.org/1998/Math/MathML",
  	svg: "http://www.w3.org/2000/svg",
  	xlink: "http://www.w3.org/1999/xlink",
  	xml: "http://www.w3.org/XML/1998/namespace",
  	xmlns: "http://www.w3.org/2000/xmlns/"
  };

  if (typeof document === "undefined") {
  	svg = false;
  } else {
  	svg = document && document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
  }

  vendors = ["o", "ms", "moz", "webkit"];

  var createElement, matches, dom__div, methodNames, unprefixed, prefixed, dom__i, j, makeFunction;

  // Test for SVG support
  if (!svg) {
  	createElement = function (type, ns) {
  		if (ns && ns !== namespaces.html) {
  			throw "This browser does not support namespaces other than http://www.w3.org/1999/xhtml. The most likely cause of this error is that you're trying to render SVG in an older browser. See http://docs.ractivejs.org/latest/svg-and-older-browsers for more information";
  		}

  		return document.createElement(type);
  	};
  } else {
  	createElement = function (type, ns) {
  		if (!ns || ns === namespaces.html) {
  			return document.createElement(type);
  		}

  		return document.createElementNS(ns, type);
  	};
  }

  function getElement(input) {
  	var output;

  	if (!input || typeof input === "boolean") {
  		return;
  	}

  	if (typeof window === "undefined" || !document || !input) {
  		return null;
  	}

  	// We already have a DOM node - no work to do. (Duck typing alert!)
  	if (input.nodeType) {
  		return input;
  	}

  	// Get node from string
  	if (typeof input === "string") {
  		// try ID first
  		output = document.getElementById(input);

  		// then as selector, if possible
  		if (!output && document.querySelector) {
  			output = document.querySelector(input);
  		}

  		// did it work?
  		if (output && output.nodeType) {
  			return output;
  		}
  	}

  	// If we've been given a collection (jQuery, Zepto etc), extract the first item
  	if (input[0] && input[0].nodeType) {
  		return input[0];
  	}

  	return null;
  }

  if (!isClient) {
  	matches = null;
  } else {
  	dom__div = createElement("div");
  	methodNames = ["matches", "matchesSelector"];

  	makeFunction = function (methodName) {
  		return function (node, selector) {
  			return node[methodName](selector);
  		};
  	};

  	dom__i = methodNames.length;

  	while (dom__i-- && !matches) {
  		unprefixed = methodNames[dom__i];

  		if (dom__div[unprefixed]) {
  			matches = makeFunction(unprefixed);
  		} else {
  			j = vendors.length;
  			while (j--) {
  				prefixed = vendors[dom__i] + unprefixed.substr(0, 1).toUpperCase() + unprefixed.substring(1);

  				if (dom__div[prefixed]) {
  					matches = makeFunction(prefixed);
  					break;
  				}
  			}
  		}
  	}

  	// IE8...
  	if (!matches) {
  		matches = function (node, selector) {
  			var nodes, parentNode, i;

  			parentNode = node.parentNode;

  			if (!parentNode) {
  				// empty dummy <div>
  				dom__div.innerHTML = "";

  				parentNode = dom__div;
  				node = node.cloneNode();

  				dom__div.appendChild(node);
  			}

  			nodes = parentNode.querySelectorAll(selector);

  			i = nodes.length;
  			while (i--) {
  				if (nodes[i] === node) {
  					return true;
  				}
  			}

  			return false;
  		};
  	}
  }

  function detachNode(node) {
  	if (node && typeof node.parentNode !== "unknown" && node.parentNode) {
  		node.parentNode.removeChild(node);
  	}

  	return node;
  }

  function safeToStringValue(value) {
  	return value == null || !value.toString ? "" : value;
  }

  var noop = function () {};

  var win, doc, exportedShims;

  if (typeof window === "undefined") {
  	exportedShims = null;
  } else {
  	win = window;
  	doc = win.document;
  	exportedShims = {};

  	if (!doc) {
  		exportedShims = null;
  	}

  	// Shims for older browsers

  	if (!Date.now) {
  		Date.now = function () {
  			return +new Date();
  		};
  	}

  	if (!String.prototype.trim) {
  		String.prototype.trim = function () {
  			return this.replace(/^\s+/, "").replace(/\s+$/, "");
  		};
  	}

  	// Polyfill for Object.keys
  	// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Object/keys
  	if (!Object.keys) {
  		Object.keys = (function () {
  			var hasOwnProperty = Object.prototype.hasOwnProperty,
  			    hasDontEnumBug = !({ toString: null }).propertyIsEnumerable("toString"),
  			    dontEnums = ["toString", "toLocaleString", "valueOf", "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable", "constructor"],
  			    dontEnumsLength = dontEnums.length;

  			return function (obj) {
  				if (typeof obj !== "object" && typeof obj !== "function" || obj === null) {
  					throw new TypeError("Object.keys called on non-object");
  				}

  				var result = [];

  				for (var prop in obj) {
  					if (hasOwnProperty.call(obj, prop)) {
  						result.push(prop);
  					}
  				}

  				if (hasDontEnumBug) {
  					for (var i = 0; i < dontEnumsLength; i++) {
  						if (hasOwnProperty.call(obj, dontEnums[i])) {
  							result.push(dontEnums[i]);
  						}
  					}
  				}
  				return result;
  			};
  		})();
  	}

  	// TODO: use defineProperty to make these non-enumerable

  	// Array extras
  	if (!Array.prototype.indexOf) {
  		Array.prototype.indexOf = function (needle, i) {
  			var len;

  			if (i === undefined) {
  				i = 0;
  			}

  			if (i < 0) {
  				i += this.length;
  			}

  			if (i < 0) {
  				i = 0;
  			}

  			for (len = this.length; i < len; i++) {
  				if (this.hasOwnProperty(i) && this[i] === needle) {
  					return i;
  				}
  			}

  			return -1;
  		};
  	}

  	if (!Array.prototype.forEach) {
  		Array.prototype.forEach = function (callback, context) {
  			var i, len;

  			for (i = 0, len = this.length; i < len; i += 1) {
  				if (this.hasOwnProperty(i)) {
  					callback.call(context, this[i], i, this);
  				}
  			}
  		};
  	}

  	if (!Array.prototype.map) {
  		Array.prototype.map = function (mapper, context) {
  			var array = this,
  			    i,
  			    len,
  			    mapped = [],
  			    isActuallyString;

  			// incredibly, if you do something like
  			// Array.prototype.map.call( someString, iterator )
  			// then `this` will become an instance of String in IE8.
  			// And in IE8, you then can't do string[i]. Facepalm.
  			if (array instanceof String) {
  				array = array.toString();
  				isActuallyString = true;
  			}

  			for (i = 0, len = array.length; i < len; i += 1) {
  				if (array.hasOwnProperty(i) || isActuallyString) {
  					mapped[i] = mapper.call(context, array[i], i, array);
  				}
  			}

  			return mapped;
  		};
  	}

  	if (typeof Array.prototype.reduce !== "function") {
  		Array.prototype.reduce = function (callback, opt_initialValue) {
  			var i, value, len, valueIsSet;

  			if ("function" !== typeof callback) {
  				throw new TypeError(callback + " is not a function");
  			}

  			len = this.length;
  			valueIsSet = false;

  			if (arguments.length > 1) {
  				value = opt_initialValue;
  				valueIsSet = true;
  			}

  			for (i = 0; i < len; i += 1) {
  				if (this.hasOwnProperty(i)) {
  					if (valueIsSet) {
  						value = callback(value, this[i], i, this);
  					}
  				} else {
  					value = this[i];
  					valueIsSet = true;
  				}
  			}

  			if (!valueIsSet) {
  				throw new TypeError("Reduce of empty array with no initial value");
  			}

  			return value;
  		};
  	}

  	if (!Array.prototype.filter) {
  		Array.prototype.filter = function (filter, context) {
  			var i,
  			    len,
  			    filtered = [];

  			for (i = 0, len = this.length; i < len; i += 1) {
  				if (this.hasOwnProperty(i) && filter.call(context, this[i], i, this)) {
  					filtered[filtered.length] = this[i];
  				}
  			}

  			return filtered;
  		};
  	}

  	if (!Array.prototype.every) {
  		Array.prototype.every = function (iterator, context) {
  			var t, len, i;

  			if (this == null) {
  				throw new TypeError();
  			}

  			t = Object(this);
  			len = t.length >>> 0;

  			if (typeof iterator !== "function") {
  				throw new TypeError();
  			}

  			for (i = 0; i < len; i += 1) {
  				if (i in t && !iterator.call(context, t[i], i, t)) {
  					return false;
  				}
  			}

  			return true;
  		};
  	}

  	/*
   // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find
   if (!Array.prototype.find) {
   	Array.prototype.find = function(predicate) {
   		if (this == null) {
   		throw new TypeError('Array.prototype.find called on null or undefined');
   		}
   		if (typeof predicate !== 'function') {
   		throw new TypeError('predicate must be a function');
   		}
   		var list = Object(this);
   		var length = list.length >>> 0;
   		var thisArg = arguments[1];
   		var value;
   			for (var i = 0; i < length; i++) {
   			if (i in list) {
   				value = list[i];
   				if (predicate.call(thisArg, value, i, list)) {
   				return value;
   				}
   			}
   		}
   		return undefined;
   	}
   }
   */

  	if (typeof Function.prototype.bind !== "function") {
  		Function.prototype.bind = function (context) {
  			var args,
  			    fn,
  			    Empty,
  			    bound,
  			    slice = [].slice;

  			if (typeof this !== "function") {
  				throw new TypeError("Function.prototype.bind called on non-function");
  			}

  			args = slice.call(arguments, 1);
  			fn = this;
  			Empty = function () {};

  			bound = function () {
  				var ctx = this instanceof Empty && context ? this : context;
  				return fn.apply(ctx, args.concat(slice.call(arguments)));
  			};

  			Empty.prototype = this.prototype;
  			bound.prototype = new Empty();

  			return bound;
  		};
  	}

  	// https://gist.github.com/Rich-Harris/6010282 via https://gist.github.com/jonathantneal/2869388
  	// addEventListener polyfill IE6+
  	if (!win.addEventListener) {
  		(function (win, doc) {
  			var Event, addEventListener, removeEventListener, head, style, origCreateElement;

  			// because sometimes inquiring minds want to know
  			win.appearsToBeIELessEqual8 = true;

  			Event = function (e, element) {
  				var property,
  				    instance = this;

  				for (property in e) {
  					instance[property] = e[property];
  				}

  				instance.currentTarget = element;
  				instance.target = e.srcElement || element;
  				instance.timeStamp = +new Date();

  				instance.preventDefault = function () {
  					e.returnValue = false;
  				};

  				instance.stopPropagation = function () {
  					e.cancelBubble = true;
  				};
  			};

  			addEventListener = function (type, listener) {
  				var element = this,
  				    listeners,
  				    i;

  				listeners = element.listeners || (element.listeners = []);
  				i = listeners.length;

  				listeners[i] = [listener, function (e) {
  					listener.call(element, new Event(e, element));
  				}];

  				element.attachEvent("on" + type, listeners[i][1]);
  			};

  			removeEventListener = function (type, listener) {
  				var element = this,
  				    listeners,
  				    i;

  				if (!element.listeners) {
  					return;
  				}

  				listeners = element.listeners;
  				i = listeners.length;

  				while (i--) {
  					if (listeners[i][0] === listener) {
  						element.detachEvent("on" + type, listeners[i][1]);
  					}
  				}
  			};

  			win.addEventListener = doc.addEventListener = addEventListener;
  			win.removeEventListener = doc.removeEventListener = removeEventListener;

  			if ("Element" in win) {
  				win.Element.prototype.addEventListener = addEventListener;
  				win.Element.prototype.removeEventListener = removeEventListener;
  			} else {
  				// First, intercept any calls to document.createElement - this is necessary
  				// because the CSS hack (see below) doesn't come into play until after a
  				// node is added to the DOM, which is too late for a lot of Ractive setup work
  				origCreateElement = doc.createElement;

  				doc.createElement = function (tagName) {
  					var el = origCreateElement(tagName);
  					el.addEventListener = addEventListener;
  					el.removeEventListener = removeEventListener;
  					return el;
  				};

  				// Then, mop up any additional elements that weren't created via
  				// document.createElement (i.e. with innerHTML).
  				head = doc.getElementsByTagName("head")[0];
  				style = doc.createElement("style");

  				head.insertBefore(style, head.firstChild);

  				//style.styleSheet.cssText = '*{-ms-event-prototype:expression(!this.addEventListener&&(this.addEventListener=addEventListener)&&(this.removeEventListener=removeEventListener))}';
  			}
  		})(win, doc);
  	}

  	// The getComputedStyle polyfill interacts badly with jQuery, so we don't attach
  	// it to window. Instead, we export it for other modules to use as needed

  	// https://github.com/jonathantneal/Polyfills-for-IE8/blob/master/getComputedStyle.js
  	if (!win.getComputedStyle) {
  		exportedShims.getComputedStyle = (function () {
  			var borderSizes = {};

  			function getPixelSize(element, style, property, fontSize) {
  				var sizeWithSuffix = style[property],
  				    size = parseFloat(sizeWithSuffix),
  				    suffix = sizeWithSuffix.split(/\d/)[0],
  				    rootSize;

  				if (isNaN(size)) {
  					if (/^thin|medium|thick$/.test(sizeWithSuffix)) {
  						size = getBorderPixelSize(sizeWithSuffix);
  						suffix = "";
  					} else {}
  				}

  				fontSize = fontSize != null ? fontSize : /%|em/.test(suffix) && element.parentElement ? getPixelSize(element.parentElement, element.parentElement.currentStyle, "fontSize", null) : 16;
  				rootSize = property == "fontSize" ? fontSize : /width/i.test(property) ? element.clientWidth : element.clientHeight;

  				return suffix == "em" ? size * fontSize : suffix == "in" ? size * 96 : suffix == "pt" ? size * 96 / 72 : suffix == "%" ? size / 100 * rootSize : size;
  			}

  			function getBorderPixelSize(size) {
  				var div, bcr;

  				// `thin`, `medium` and `thick` vary between browsers. (Don't ever use them.)
  				if (!borderSizes[size]) {
  					div = document.createElement("div");
  					div.style.display = "block";
  					div.style.position = "fixed";
  					div.style.width = div.style.height = "0";
  					div.style.borderRight = size + " solid black";

  					document.getElementsByTagName("body")[0].appendChild(div);
  					bcr = div.getBoundingClientRect();

  					borderSizes[size] = bcr.right - bcr.left;
  				}

  				return borderSizes[size];
  			}

  			function setShortStyleProperty(style, property) {
  				var borderSuffix = property == "border" ? "Width" : "",
  				    t = property + "Top" + borderSuffix,
  				    r = property + "Right" + borderSuffix,
  				    b = property + "Bottom" + borderSuffix,
  				    l = property + "Left" + borderSuffix;

  				style[property] = (style[t] == style[r] == style[b] == style[l] ? [style[t]] : style[t] == style[b] && style[l] == style[r] ? [style[t], style[r]] : style[l] == style[r] ? [style[t], style[r], style[b]] : [style[t], style[r], style[b], style[l]]).join(" ");
  			}

  			var normalProps = {
  				fontWeight: 400,
  				lineHeight: 1.2, // actually varies depending on font-family, but is generally close enough...
  				letterSpacing: 0
  			};

  			function CSSStyleDeclaration(element) {
  				var currentStyle, style, fontSize, property;

  				currentStyle = element.currentStyle;
  				style = this;
  				fontSize = getPixelSize(element, currentStyle, "fontSize", null);

  				// TODO tidy this up, test it, send PR to jonathantneal!
  				for (property in currentStyle) {
  					if (currentStyle[property] === "normal" && normalProps.hasOwnProperty(property)) {
  						style[property] = normalProps[property];
  					} else if (/width|height|margin.|padding.|border.+W/.test(property)) {
  						if (currentStyle[property] === "auto") {
  							if (/^width|height/.test(property)) {
  								// just use clientWidth/clientHeight...
  								style[property] = (property === "width" ? element.clientWidth : element.clientHeight) + "px";
  							} else if (/(?:padding)?Top|Bottom$/.test(property)) {
  								style[property] = "0px";
  							}
  						} else {
  							style[property] = getPixelSize(element, currentStyle, property, fontSize) + "px";
  						}
  					} else if (property === "styleFloat") {
  						style.float = currentStyle[property];
  					} else {
  						style[property] = currentStyle[property];
  					}
  				}

  				setShortStyleProperty(style, "margin");
  				setShortStyleProperty(style, "padding");
  				setShortStyleProperty(style, "border");

  				style.fontSize = fontSize + "px";

  				return style;
  			}

  			CSSStyleDeclaration.prototype = {
  				constructor: CSSStyleDeclaration,
  				getPropertyPriority: noop,
  				getPropertyValue: function (prop) {
  					return this[prop] || "";
  				},
  				item: noop,
  				removeProperty: noop,
  				setProperty: noop,
  				getPropertyCSSValue: noop
  			};

  			function getComputedStyle(element) {
  				return new CSSStyleDeclaration(element);
  			}

  			return getComputedStyle;
  		})();
  	}
  }

  var legacy = exportedShims;

  // TODO...

  var create, defineProperty, defineProperties;

  try {
  	Object.defineProperty({}, "test", { value: 0 });

  	if (isClient) {
  		Object.defineProperty(document.createElement("div"), "test", { value: 0 });
  	}

  	defineProperty = Object.defineProperty;
  } catch (err) {
  	// Object.defineProperty doesn't exist, or we're in IE8 where you can
  	// only use it with DOM objects (what were you smoking, MSFT?)
  	defineProperty = function (obj, prop, desc) {
  		obj[prop] = desc.value;
  	};
  }

  try {
  	try {
  		Object.defineProperties({}, { test: { value: 0 } });
  	} catch (err) {
  		// TODO how do we account for this? noMagic = true;
  		throw err;
  	}

  	if (isClient) {
  		Object.defineProperties(createElement("div"), { test: { value: 0 } });
  	}

  	defineProperties = Object.defineProperties;
  } catch (err) {
  	defineProperties = function (obj, props) {
  		var prop;

  		for (prop in props) {
  			if (props.hasOwnProperty(prop)) {
  				defineProperty(obj, prop, props[prop]);
  			}
  		}
  	};
  }

  try {
  	Object.create(null);

  	create = Object.create;
  } catch (err) {
  	// sigh
  	create = (function () {
  		var F = function () {};

  		return function (proto, props) {
  			var obj;

  			if (proto === null) {
  				return {};
  			}

  			F.prototype = proto;
  			obj = new F();

  			if (props) {
  				Object.defineProperties(obj, props);
  			}

  			return obj;
  		};
  	})();
  }

  function utils_object__extend(target) {
  	for (var _len = arguments.length, sources = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		sources[_key - 1] = arguments[_key];
  	}

  	var prop, source;

  	while (source = sources.shift()) {
  		for (prop in source) {
  			if (hasOwn.call(source, prop)) {
  				target[prop] = source[prop];
  			}
  		}
  	}

  	return target;
  }

  function fillGaps(target) {
  	for (var _len = arguments.length, sources = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		sources[_key - 1] = arguments[_key];
  	}

  	sources.forEach(function (s) {
  		for (var key in s) {
  			if (s.hasOwnProperty(key) && !(key in target)) {
  				target[key] = s[key];
  			}
  		}
  	});

  	return target;
  }

  var hasOwn = Object.prototype.hasOwnProperty;

  // thanks, http://perfectionkills.com/instanceof-considered-harmful-or-how-to-write-a-robust-isarray/
  var is__toString = Object.prototype.toString,
      arrayLikePattern = /^\[object (?:Array|FileList)\]$/;
  function isArray(thing) {
  	return is__toString.call(thing) === "[object Array]";
  }

  function isArrayLike(obj) {
  	return arrayLikePattern.test(is__toString.call(obj));
  }

  function isEqual(a, b) {
  	if (a === null && b === null) {
  		return true;
  	}

  	if (typeof a === "object" || typeof b === "object") {
  		return false;
  	}

  	return a === b;
  }

  function is__isNumeric(thing) {
  	return !isNaN(parseFloat(thing)) && isFinite(thing);
  }

  function isObject(thing) {
  	return thing && is__toString.call(thing) === "[object Object]";
  }

  /* global console */
  var alreadyWarned = {},
      log,
      printWarning,
      welcome;

  if (hasConsole) {
  	(function () {
  		var welcomeIntro = ["%cRactive.js %c0.7.3 %cin debug mode, %cmore...", "color: rgb(114, 157, 52); font-weight: normal;", "color: rgb(85, 85, 85); font-weight: normal;", "color: rgb(85, 85, 85); font-weight: normal;", "color: rgb(82, 140, 224); font-weight: normal; text-decoration: underline;"];
  		var welcomeMessage = "You're running Ractive 0.7.3 in debug mode - messages will be printed to the console to help you fix problems and optimise your application.\n\nTo disable debug mode, add this line at the start of your app:\n  Ractive.DEBUG = false;\n\nTo disable debug mode when your app is minified, add this snippet:\n  Ractive.DEBUG = /unminified/.test(function(){/*unminified*/});\n\nGet help and support:\n  http://docs.ractivejs.org\n  http://stackoverflow.com/questions/tagged/ractivejs\n  http://groups.google.com/forum/#!forum/ractive-js\n  http://twitter.com/ractivejs\n\nFound a bug? Raise an issue:\n  https://github.com/ractivejs/ractive/issues\n\n";

  		welcome = function () {
  			var hasGroup = !!console.groupCollapsed;
  			console[hasGroup ? "groupCollapsed" : "log"].apply(console, welcomeIntro);
  			console.log(welcomeMessage);
  			if (hasGroup) {
  				console.groupEnd(welcomeIntro);
  			}

  			welcome = noop;
  		};

  		printWarning = function (message, args) {
  			welcome();

  			// extract information about the instance this message pertains to, if applicable
  			if (typeof args[args.length - 1] === "object") {
  				var options = args.pop();
  				var ractive = options ? options.ractive : null;

  				if (ractive) {
  					// if this is an instance of a component that we know the name of, add
  					// it to the message
  					var _name = undefined;
  					if (ractive.component && (_name = ractive.component.name)) {
  						message = "<" + _name + "> " + message;
  					}

  					var node = undefined;
  					if (node = options.node || ractive.fragment && ractive.fragment.rendered && ractive.find("*")) {
  						args.push(node);
  					}
  				}
  			}

  			console.warn.apply(console, ["%cRactive.js: %c" + message, "color: rgb(114, 157, 52);", "color: rgb(85, 85, 85);"].concat(args));
  		};

  		log = function () {
  			console.log.apply(console, arguments);
  		};
  	})();
  } else {
  	printWarning = log = welcome = noop;
  }

  function format(message, args) {
  	return message.replace(/%s/g, function () {
  		return args.shift();
  	});
  }

  function fatal(message) {
  	for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		args[_key - 1] = arguments[_key];
  	}

  	message = format(message, args);
  	throw new Error(message);
  }

  function logIfDebug() {
  	if (_Ractive.DEBUG) {
  		log.apply(null, arguments);
  	}
  }

  function warn(message) {
  	for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		args[_key - 1] = arguments[_key];
  	}

  	message = format(message, args);
  	printWarning(message, args);
  }

  function warnOnce(message) {
  	for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  		args[_key - 1] = arguments[_key];
  	}

  	message = format(message, args);

  	if (alreadyWarned[message]) {
  		return;
  	}

  	alreadyWarned[message] = true;
  	printWarning(message, args);
  }

  function warnIfDebug() {
  	if (_Ractive.DEBUG) {
  		warn.apply(null, arguments);
  	}
  }

  function warnOnceIfDebug() {
  	if (_Ractive.DEBUG) {
  		warnOnce.apply(null, arguments);
  	}
  }

  // Error messages that are used (or could be) in multiple places
  var badArguments = "Bad arguments";
  var noRegistryFunctionReturn = "A function was specified for \"%s\" %s, but no %s was returned";
  var missingPlugin = function (name, type) {
    return "Missing \"" + name + "\" " + type + " plugin. You may need to download a plugin via http://docs.ractivejs.org/latest/plugins#" + type + "s";
  };

  function findInViewHierarchy(registryName, ractive, name) {
  	var instance = findInstance(registryName, ractive, name);
  	return instance ? instance[registryName][name] : null;
  }

  function findInstance(registryName, ractive, name) {
  	while (ractive) {
  		if (name in ractive[registryName]) {
  			return ractive;
  		}

  		if (ractive.isolated) {
  			return null;
  		}

  		ractive = ractive.parent;
  	}
  }

  var interpolate = function (from, to, ractive, type) {
  	if (from === to) {
  		return snap(to);
  	}

  	if (type) {

  		var interpol = findInViewHierarchy("interpolators", ractive, type);
  		if (interpol) {
  			return interpol(from, to) || snap(to);
  		}

  		fatal(missingPlugin(type, "interpolator"));
  	}

  	return static_interpolators.number(from, to) || static_interpolators.array(from, to) || static_interpolators.object(from, to) || snap(to);
  };

  var shared_interpolate = interpolate;

  function snap(to) {
  	return function () {
  		return to;
  	};
  }

  var interpolators = {
  	number: function (from, to) {
  		var delta;

  		if (!is__isNumeric(from) || !is__isNumeric(to)) {
  			return null;
  		}

  		from = +from;
  		to = +to;

  		delta = to - from;

  		if (!delta) {
  			return function () {
  				return from;
  			};
  		}

  		return function (t) {
  			return from + t * delta;
  		};
  	},

  	array: function (from, to) {
  		var intermediate, interpolators, len, i;

  		if (!isArray(from) || !isArray(to)) {
  			return null;
  		}

  		intermediate = [];
  		interpolators = [];

  		i = len = Math.min(from.length, to.length);
  		while (i--) {
  			interpolators[i] = shared_interpolate(from[i], to[i]);
  		}

  		// surplus values - don't interpolate, but don't exclude them either
  		for (i = len; i < from.length; i += 1) {
  			intermediate[i] = from[i];
  		}

  		for (i = len; i < to.length; i += 1) {
  			intermediate[i] = to[i];
  		}

  		return function (t) {
  			var i = len;

  			while (i--) {
  				intermediate[i] = interpolators[i](t);
  			}

  			return intermediate;
  		};
  	},

  	object: function (from, to) {
  		var properties, len, interpolators, intermediate, prop;

  		if (!isObject(from) || !isObject(to)) {
  			return null;
  		}

  		properties = [];
  		intermediate = {};
  		interpolators = {};

  		for (prop in from) {
  			if (hasOwn.call(from, prop)) {
  				if (hasOwn.call(to, prop)) {
  					properties.push(prop);
  					interpolators[prop] = shared_interpolate(from[prop], to[prop]);
  				} else {
  					intermediate[prop] = from[prop];
  				}
  			}
  		}

  		for (prop in to) {
  			if (hasOwn.call(to, prop) && !hasOwn.call(from, prop)) {
  				intermediate[prop] = to[prop];
  			}
  		}

  		len = properties.length;

  		return function (t) {
  			var i = len,
  			    prop;

  			while (i--) {
  				prop = properties[i];

  				intermediate[prop] = interpolators[prop](t);
  			}

  			return intermediate;
  		};
  	}
  };

  var static_interpolators = interpolators;

  // This function takes a keypath such as 'foo.bar.baz', and returns
  // all the variants of that keypath that include a wildcard in place
  // of a key, such as 'foo.bar.*', 'foo.*.baz', 'foo.*.*' and so on.
  // These are then checked against the dependants map (ractive.viewmodel.depsMap)
  // to see if any pattern observers are downstream of one or more of
  // these wildcard keypaths (e.g. 'foo.bar.*.status')
  var utils_getPotentialWildcardMatches = getPotentialWildcardMatches;

  var starMaps = {};
  function getPotentialWildcardMatches(keypath) {
  	var keys, starMap, mapper, i, result, wildcardKeypath;

  	keys = keypath.split(".");
  	if (!(starMap = starMaps[keys.length])) {
  		starMap = getStarMap(keys.length);
  	}

  	result = [];

  	mapper = function (star, i) {
  		return star ? "*" : keys[i];
  	};

  	i = starMap.length;
  	while (i--) {
  		wildcardKeypath = starMap[i].map(mapper).join(".");

  		if (!result.hasOwnProperty(wildcardKeypath)) {
  			result.push(wildcardKeypath);
  			result[wildcardKeypath] = true;
  		}
  	}

  	return result;
  }

  // This function returns all the possible true/false combinations for
  // a given number - e.g. for two, the possible combinations are
  // [ true, true ], [ true, false ], [ false, true ], [ false, false ].
  // It does so by getting all the binary values between 0 and e.g. 11
  function getStarMap(num) {
  	var ones = "",
  	    max,
  	    binary,
  	    starMap,
  	    mapper,
  	    i,
  	    j,
  	    l,
  	    map;

  	if (!starMaps[num]) {
  		starMap = [];

  		while (ones.length < num) {
  			ones += 1;
  		}

  		max = parseInt(ones, 2);

  		mapper = function (digit) {
  			return digit === "1";
  		};

  		for (i = 0; i <= max; i += 1) {
  			binary = i.toString(2);
  			while (binary.length < num) {
  				binary = "0" + binary;
  			}

  			map = [];
  			l = binary.length;
  			for (j = 0; j < l; j++) {
  				map.push(mapper(binary[j]));
  			}
  			starMap[i] = map;
  		}

  		starMaps[num] = starMap;
  	}

  	return starMaps[num];
  }

  var refPattern = /\[\s*(\*|[0-9]|[1-9][0-9]+)\s*\]/g;
  var patternPattern = /\*/;
  var keypathCache = {};

  var Keypath = function (str) {
  	var keys = str.split(".");

  	this.str = str;

  	if (str[0] === "@") {
  		this.isSpecial = true;
  		this.value = decodeKeypath(str);
  	}

  	this.firstKey = keys[0];
  	this.lastKey = keys.pop();

  	this.isPattern = patternPattern.test(str);

  	this.parent = str === "" ? null : getKeypath(keys.join("."));
  	this.isRoot = !str;
  };

  Keypath.prototype = {
  	equalsOrStartsWith: function (keypath) {
  		return keypath === this || this.startsWith(keypath);
  	},

  	join: function (str) {
  		return getKeypath(this.isRoot ? String(str) : this.str + "." + str);
  	},

  	replace: function (oldKeypath, newKeypath) {
  		if (this === oldKeypath) {
  			return newKeypath;
  		}

  		if (this.startsWith(oldKeypath)) {
  			return newKeypath === null ? newKeypath : getKeypath(this.str.replace(oldKeypath.str + ".", newKeypath.str + "."));
  		}
  	},

  	startsWith: function (keypath) {
  		if (!keypath) {
  			// TODO under what circumstances does this happen?
  			return false;
  		}

  		return keypath && this.str.substr(0, keypath.str.length + 1) === keypath.str + ".";
  	},

  	toString: function () {
  		throw new Error("Bad coercion");
  	},

  	valueOf: function () {
  		throw new Error("Bad coercion");
  	},

  	wildcardMatches: function () {
  		return this._wildcardMatches || (this._wildcardMatches = utils_getPotentialWildcardMatches(this.str));
  	}
  };
  function assignNewKeypath(target, property, oldKeypath, newKeypath) {
  	var existingKeypath = target[property];

  	if (existingKeypath && (existingKeypath.equalsOrStartsWith(newKeypath) || !existingKeypath.equalsOrStartsWith(oldKeypath))) {
  		return;
  	}

  	target[property] = existingKeypath ? existingKeypath.replace(oldKeypath, newKeypath) : newKeypath;
  	return true;
  }

  function decodeKeypath(keypath) {
  	var value = keypath.slice(2);

  	if (keypath[1] === "i") {
  		return is__isNumeric(value) ? +value : value;
  	} else {
  		return value;
  	}
  }

  function getKeypath(str) {
  	if (str == null) {
  		return str;
  	}

  	// TODO it *may* be worth having two versions of this function - one where
  	// keypathCache inherits from null, and one for IE8. Depends on how
  	// much of an overhead hasOwnProperty is - probably negligible
  	if (!keypathCache.hasOwnProperty(str)) {
  		keypathCache[str] = new Keypath(str);
  	}

  	return keypathCache[str];
  }

  function getMatchingKeypaths(ractive, keypath) {
  	var keys, key, matchingKeypaths;

  	keys = keypath.str.split(".");
  	matchingKeypaths = [rootKeypath];

  	while (key = keys.shift()) {
  		if (key === "*") {
  			// expand to find all valid child keypaths
  			matchingKeypaths = matchingKeypaths.reduce(expand, []);
  		} else {
  			if (matchingKeypaths[0] === rootKeypath) {
  				// first key
  				matchingKeypaths[0] = getKeypath(key);
  			} else {
  				matchingKeypaths = matchingKeypaths.map(concatenate(key));
  			}
  		}
  	}

  	return matchingKeypaths;

  	function expand(matchingKeypaths, keypath) {
  		var wrapper, value, keys;

  		if (keypath.isRoot) {
  			keys = [].concat(Object.keys(ractive.viewmodel.data), Object.keys(ractive.viewmodel.mappings), Object.keys(ractive.viewmodel.computations));
  		} else {
  			wrapper = ractive.viewmodel.wrapped[keypath.str];
  			value = wrapper ? wrapper.get() : ractive.viewmodel.get(keypath);

  			keys = value ? Object.keys(value) : null;
  		}

  		if (keys) {
  			keys.forEach(function (key) {
  				if (key !== "_ractive" || !isArray(value)) {
  					matchingKeypaths.push(keypath.join(key));
  				}
  			});
  		}

  		return matchingKeypaths;
  	}
  }

  function concatenate(key) {
  	return function (keypath) {
  		return keypath.join(key);
  	};
  }
  function normalise(ref) {
  	return ref ? ref.replace(refPattern, ".$1") : "";
  }

  var rootKeypath = getKeypath("");

  var shared_add = add;
  var shared_add__errorMessage = "Cannot add to a non-numeric value";
  function add(root, keypath, d) {
  	if (typeof keypath !== "string" || !is__isNumeric(d)) {
  		throw new Error("Bad arguments");
  	}

  	var value = undefined,
  	    changes = undefined;

  	if (/\*/.test(keypath)) {
  		changes = {};

  		getMatchingKeypaths(root, getKeypath(normalise(keypath))).forEach(function (keypath) {
  			var value = root.viewmodel.get(keypath);

  			if (!is__isNumeric(value)) {
  				throw new Error(shared_add__errorMessage);
  			}

  			changes[keypath.str] = value + d;
  		});

  		return root.set(changes);
  	}

  	value = root.get(keypath);

  	if (!is__isNumeric(value)) {
  		throw new Error(shared_add__errorMessage);
  	}

  	return root.set(keypath, +value + d);
  }

  var prototype_add = Ractive$add;
  function Ractive$add(keypath, d) {
  	return shared_add(this, keypath, d === undefined ? 1 : +d);
  }

  var requestAnimationFrame;

  // If window doesn't exist, we don't need requestAnimationFrame
  if (typeof window === "undefined") {
  	requestAnimationFrame = null;
  } else {
  	// https://gist.github.com/paulirish/1579671
  	(function (vendors, lastTime, window) {

  		var x, setTimeout;

  		if (window.requestAnimationFrame) {
  			return;
  		}

  		for (x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
  			window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"];
  		}

  		if (!window.requestAnimationFrame) {
  			setTimeout = window.setTimeout;

  			window.requestAnimationFrame = function (callback) {
  				var currTime, timeToCall, id;

  				currTime = Date.now();
  				timeToCall = Math.max(0, 16 - (currTime - lastTime));
  				id = setTimeout(function () {
  					callback(currTime + timeToCall);
  				}, timeToCall);

  				lastTime = currTime + timeToCall;
  				return id;
  			};
  		}
  	})(vendors, 0, window);

  	requestAnimationFrame = window.requestAnimationFrame;
  }

  var rAF = requestAnimationFrame;

  var getTime;

  if (typeof window !== "undefined" && window.performance && typeof window.performance.now === "function") {
  	getTime = function () {
  		return window.performance.now();
  	};
  } else {
  	getTime = function () {
  		return Date.now();
  	};
  }

  var utils_getTime = getTime;

  var deprecations = {
  	construct: {
  		deprecated: "beforeInit",
  		replacement: "onconstruct"
  	},
  	render: {
  		deprecated: "init",
  		message: "The \"init\" method has been deprecated " + "and will likely be removed in a future release. " + "You can either use the \"oninit\" method which will fire " + "only once prior to, and regardless of, any eventual ractive " + "instance being rendered, or if you need to access the " + "rendered DOM, use \"onrender\" instead. " + "See http://docs.ractivejs.org/latest/migrating for more information."
  	},
  	complete: {
  		deprecated: "complete",
  		replacement: "oncomplete"
  	}
  };

  function Hook(event) {
  	this.event = event;
  	this.method = "on" + event;
  	this.deprecate = deprecations[event];
  }

  Hook.prototype.fire = function (ractive, arg) {
  	function call(method) {
  		if (ractive[method]) {
  			arg ? ractive[method](arg) : ractive[method]();
  			return true;
  		}
  	}

  	call(this.method);

  	if (!ractive[this.method] && this.deprecate && call(this.deprecate.deprecated)) {
  		if (this.deprecate.message) {
  			warnIfDebug(this.deprecate.message);
  		} else {
  			warnIfDebug("The method \"%s\" has been deprecated in favor of \"%s\" and will likely be removed in a future release. See http://docs.ractivejs.org/latest/migrating for more information.", this.deprecate.deprecated, this.deprecate.replacement);
  		}
  	}

  	arg ? ractive.fire(this.event, arg) : ractive.fire(this.event);
  };

  var hooks_Hook = Hook;

  function addToArray(array, value) {
  	var index = array.indexOf(value);

  	if (index === -1) {
  		array.push(value);
  	}
  }

  function arrayContains(array, value) {
  	for (var i = 0, c = array.length; i < c; i++) {
  		if (array[i] == value) {
  			return true;
  		}
  	}

  	return false;
  }

  function arrayContentsMatch(a, b) {
  	var i;

  	if (!isArray(a) || !isArray(b)) {
  		return false;
  	}

  	if (a.length !== b.length) {
  		return false;
  	}

  	i = a.length;
  	while (i--) {
  		if (a[i] !== b[i]) {
  			return false;
  		}
  	}

  	return true;
  }

  function ensureArray(x) {
  	if (typeof x === "string") {
  		return [x];
  	}

  	if (x === undefined) {
  		return [];
  	}

  	return x;
  }

  function lastItem(array) {
  	return array[array.length - 1];
  }

  function removeFromArray(array, member) {
  	var index = array.indexOf(member);

  	if (index !== -1) {
  		array.splice(index, 1);
  	}
  }

  function toArray(arrayLike) {
  	var array = [],
  	    i = arrayLike.length;
  	while (i--) {
  		array[i] = arrayLike[i];
  	}

  	return array;
  }

  var _Promise,
      PENDING = {},
      FULFILLED = {},
      REJECTED = {};

  if (typeof Promise === "function") {
  	// use native Promise
  	_Promise = Promise;
  } else {
  	_Promise = function (callback) {
  		var fulfilledHandlers = [],
  		    rejectedHandlers = [],
  		    state = PENDING,
  		    result,
  		    dispatchHandlers,
  		    makeResolver,
  		    fulfil,
  		    reject,
  		    promise;

  		makeResolver = function (newState) {
  			return function (value) {
  				if (state !== PENDING) {
  					return;
  				}

  				result = value;
  				state = newState;

  				dispatchHandlers = makeDispatcher(state === FULFILLED ? fulfilledHandlers : rejectedHandlers, result);

  				// dispatch onFulfilled and onRejected handlers asynchronously
  				wait(dispatchHandlers);
  			};
  		};

  		fulfil = makeResolver(FULFILLED);
  		reject = makeResolver(REJECTED);

  		try {
  			callback(fulfil, reject);
  		} catch (err) {
  			reject(err);
  		}

  		promise = {
  			// `then()` returns a Promise - 2.2.7
  			then: function (onFulfilled, onRejected) {
  				var promise2 = new _Promise(function (fulfil, reject) {

  					var processResolutionHandler = function (handler, handlers, forward) {

  						// 2.2.1.1
  						if (typeof handler === "function") {
  							handlers.push(function (p1result) {
  								var x;

  								try {
  									x = handler(p1result);
  									utils_Promise__resolve(promise2, x, fulfil, reject);
  								} catch (err) {
  									reject(err);
  								}
  							});
  						} else {
  							// Forward the result of promise1 to promise2, if resolution handlers
  							// are not given
  							handlers.push(forward);
  						}
  					};

  					// 2.2
  					processResolutionHandler(onFulfilled, fulfilledHandlers, fulfil);
  					processResolutionHandler(onRejected, rejectedHandlers, reject);

  					if (state !== PENDING) {
  						// If the promise has resolved already, dispatch the appropriate handlers asynchronously
  						wait(dispatchHandlers);
  					}
  				});

  				return promise2;
  			}
  		};

  		promise["catch"] = function (onRejected) {
  			return this.then(null, onRejected);
  		};

  		return promise;
  	};

  	_Promise.all = function (promises) {
  		return new _Promise(function (fulfil, reject) {
  			var result = [],
  			    pending,
  			    i,
  			    processPromise;

  			if (!promises.length) {
  				fulfil(result);
  				return;
  			}

  			processPromise = function (promise, i) {
  				if (promise && typeof promise.then === "function") {
  					promise.then(function (value) {
  						result[i] = value;
  						--pending || fulfil(result);
  					}, reject);
  				} else {
  					result[i] = promise;
  					--pending || fulfil(result);
  				}
  			};

  			pending = i = promises.length;
  			while (i--) {
  				processPromise(promises[i], i);
  			}
  		});
  	};

  	_Promise.resolve = function (value) {
  		return new _Promise(function (fulfil) {
  			fulfil(value);
  		});
  	};

  	_Promise.reject = function (reason) {
  		return new _Promise(function (fulfil, reject) {
  			reject(reason);
  		});
  	};
  }

  var utils_Promise = _Promise;

  // TODO use MutationObservers or something to simulate setImmediate
  function wait(callback) {
  	setTimeout(callback, 0);
  }

  function makeDispatcher(handlers, result) {
  	return function () {
  		var handler;

  		while (handler = handlers.shift()) {
  			handler(result);
  		}
  	};
  }

  function utils_Promise__resolve(promise, x, fulfil, reject) {
  	// Promise Resolution Procedure
  	var then;

  	// 2.3.1
  	if (x === promise) {
  		throw new TypeError("A promise's fulfillment handler cannot return the same promise");
  	}

  	// 2.3.2
  	if (x instanceof _Promise) {
  		x.then(fulfil, reject);
  	}

  	// 2.3.3
  	else if (x && (typeof x === "object" || typeof x === "function")) {
  		try {
  			then = x.then; // 2.3.3.1
  		} catch (e) {
  			reject(e); // 2.3.3.2
  			return;
  		}

  		// 2.3.3.3
  		if (typeof then === "function") {
  			var called, resolvePromise, rejectPromise;

  			resolvePromise = function (y) {
  				if (called) {
  					return;
  				}
  				called = true;
  				utils_Promise__resolve(promise, y, fulfil, reject);
  			};

  			rejectPromise = function (r) {
  				if (called) {
  					return;
  				}
  				called = true;
  				reject(r);
  			};

  			try {
  				then.call(x, resolvePromise, rejectPromise);
  			} catch (e) {
  				if (!called) {
  					// 2.3.3.3.4.1
  					reject(e); // 2.3.3.3.4.2
  					called = true;
  					return;
  				}
  			}
  		} else {
  			fulfil(x);
  		}
  	} else {
  		fulfil(x);
  	}
  }

  var getInnerContext = function (fragment) {
  	do {
  		if (fragment.context !== undefined) {
  			return fragment.context;
  		}
  	} while (fragment = fragment.parent);

  	return rootKeypath;
  };

  var shared_resolveRef = resolveRef;

  function resolveRef(ractive, ref, fragment) {
  	var keypath;

  	ref = normalise(ref);

  	// If a reference begins '~/', it's a top-level reference
  	if (ref.substr(0, 2) === "~/") {
  		keypath = getKeypath(ref.substring(2));
  		createMappingIfNecessary(ractive, keypath.firstKey, fragment);
  	}

  	// If a reference begins with '.', it's either a restricted reference or
  	// an ancestor reference...
  	else if (ref[0] === ".") {
  		keypath = resolveAncestorRef(getInnerContext(fragment), ref);

  		if (keypath) {
  			createMappingIfNecessary(ractive, keypath.firstKey, fragment);
  		}
  	}

  	// ...otherwise we need to figure out the keypath based on context
  	else {
  		keypath = resolveAmbiguousReference(ractive, getKeypath(ref), fragment);
  	}

  	return keypath;
  }

  function resolveAncestorRef(baseContext, ref) {
  	var contextKeys;

  	// TODO...
  	if (baseContext != undefined && typeof baseContext !== "string") {
  		baseContext = baseContext.str;
  	}

  	// {{.}} means 'current context'
  	if (ref === ".") return getKeypath(baseContext);

  	contextKeys = baseContext ? baseContext.split(".") : [];

  	// ancestor references (starting "../") go up the tree
  	if (ref.substr(0, 3) === "../") {
  		while (ref.substr(0, 3) === "../") {
  			if (!contextKeys.length) {
  				throw new Error("Could not resolve reference - too many \"../\" prefixes");
  			}

  			contextKeys.pop();
  			ref = ref.substring(3);
  		}

  		contextKeys.push(ref);
  		return getKeypath(contextKeys.join("."));
  	}

  	// not an ancestor reference - must be a restricted reference (prepended with "." or "./")
  	if (!baseContext) {
  		return getKeypath(ref.replace(/^\.\/?/, ""));
  	}

  	return getKeypath(baseContext + ref.replace(/^\.\//, "."));
  }

  function resolveAmbiguousReference(ractive, ref, fragment, isParentLookup) {
  	var context, key, parentValue, hasContextChain, parentKeypath;

  	if (ref.isRoot) {
  		return ref;
  	}

  	key = ref.firstKey;

  	while (fragment) {
  		context = fragment.context;
  		fragment = fragment.parent;

  		if (!context) {
  			continue;
  		}

  		hasContextChain = true;
  		parentValue = ractive.viewmodel.get(context);

  		if (parentValue && (typeof parentValue === "object" || typeof parentValue === "function") && key in parentValue) {
  			return context.join(ref.str);
  		}
  	}

  	// Root/computed/mapped property?
  	if (isRootProperty(ractive.viewmodel, key)) {
  		return ref;
  	}

  	// If this is an inline component, and it's not isolated, we
  	// can try going up the scope chain
  	if (ractive.parent && !ractive.isolated) {
  		hasContextChain = true;
  		fragment = ractive.component.parentFragment;

  		key = getKeypath(key);

  		if (parentKeypath = resolveAmbiguousReference(ractive.parent, key, fragment, true)) {
  			// We need to create an inter-component binding
  			ractive.viewmodel.map(key, {
  				origin: ractive.parent.viewmodel,
  				keypath: parentKeypath
  			});

  			return ref;
  		}
  	}

  	// If there's no context chain, and the instance is either a) isolated or
  	// b) an orphan, then we know that the keypath is identical to the reference
  	if (!isParentLookup && !hasContextChain) {
  		// the data object needs to have a property by this name,
  		// to prevent future failed lookups
  		ractive.viewmodel.set(ref, undefined);
  		return ref;
  	}
  }

  function createMappingIfNecessary(ractive, key) {
  	var parentKeypath;

  	if (!ractive.parent || ractive.isolated || isRootProperty(ractive.viewmodel, key)) {
  		return;
  	}

  	key = getKeypath(key);

  	if (parentKeypath = resolveAmbiguousReference(ractive.parent, key, ractive.component.parentFragment, true)) {
  		ractive.viewmodel.map(key, {
  			origin: ractive.parent.viewmodel,
  			keypath: parentKeypath
  		});
  	}
  }

  function isRootProperty(viewmodel, key) {
  	// special case for reference to root
  	return key === "" || key in viewmodel.data || key in viewmodel.computations || key in viewmodel.mappings;
  }

  function teardown(x) {
    x.teardown();
  }

  function methodCallers__unbind(x) {
    x.unbind();
  }

  function methodCallers__unrender(x) {
    x.unrender();
  }

  function cancel(x) {
    x.cancel();
  }

  var TransitionManager = function (callback, parent) {
  	this.callback = callback;
  	this.parent = parent;

  	this.intros = [];
  	this.outros = [];

  	this.children = [];
  	this.totalChildren = this.outroChildren = 0;

  	this.detachQueue = [];
  	this.decoratorQueue = [];
  	this.outrosComplete = false;

  	if (parent) {
  		parent.addChild(this);
  	}
  };

  TransitionManager.prototype = {
  	addChild: function (child) {
  		this.children.push(child);

  		this.totalChildren += 1;
  		this.outroChildren += 1;
  	},

  	decrementOutros: function () {
  		this.outroChildren -= 1;
  		check(this);
  	},

  	decrementTotal: function () {
  		this.totalChildren -= 1;
  		check(this);
  	},

  	add: function (transition) {
  		var list = transition.isIntro ? this.intros : this.outros;
  		list.push(transition);
  	},

  	addDecorator: function (decorator) {
  		this.decoratorQueue.push(decorator);
  	},

  	remove: function (transition) {
  		var list = transition.isIntro ? this.intros : this.outros;
  		removeFromArray(list, transition);
  		check(this);
  	},

  	init: function () {
  		this.ready = true;
  		check(this);
  	},

  	detachNodes: function () {
  		this.decoratorQueue.forEach(teardown);
  		this.detachQueue.forEach(detach);
  		this.children.forEach(detachNodes);
  	}
  };

  function detach(element) {
  	element.detach();
  }

  function detachNodes(tm) {
  	tm.detachNodes();
  }

  function check(tm) {
  	if (!tm.ready || tm.outros.length || tm.outroChildren) return;

  	// If all outros are complete, and we haven't already done this,
  	// we notify the parent if there is one, otherwise
  	// start detaching nodes
  	if (!tm.outrosComplete) {
  		if (tm.parent) {
  			tm.parent.decrementOutros(tm);
  		} else {
  			tm.detachNodes();
  		}

  		tm.outrosComplete = true;
  	}

  	// Once everything is done, we can notify parent transition
  	// manager and call the callback
  	if (!tm.intros.length && !tm.totalChildren) {
  		if (typeof tm.callback === "function") {
  			tm.callback();
  		}

  		if (tm.parent) {
  			tm.parent.decrementTotal();
  		}
  	}
  }

  var global_TransitionManager = TransitionManager;

  var batch,
      runloop,
      unresolved = [],
      changeHook = new hooks_Hook("change");

  runloop = {
  	start: function (instance, returnPromise) {
  		var promise, fulfilPromise;

  		if (returnPromise) {
  			promise = new utils_Promise(function (f) {
  				return fulfilPromise = f;
  			});
  		}

  		batch = {
  			previousBatch: batch,
  			transitionManager: new global_TransitionManager(fulfilPromise, batch && batch.transitionManager),
  			views: [],
  			tasks: [],
  			ractives: [],
  			instance: instance
  		};

  		if (instance) {
  			batch.ractives.push(instance);
  		}

  		return promise;
  	},

  	end: function () {
  		flushChanges();

  		batch.transitionManager.init();
  		if (!batch.previousBatch && !!batch.instance) batch.instance.viewmodel.changes = [];
  		batch = batch.previousBatch;
  	},

  	addRactive: function (ractive) {
  		if (batch) {
  			addToArray(batch.ractives, ractive);
  		}
  	},

  	registerTransition: function (transition) {
  		transition._manager = batch.transitionManager;
  		batch.transitionManager.add(transition);
  	},

  	registerDecorator: function (decorator) {
  		batch.transitionManager.addDecorator(decorator);
  	},

  	addView: function (view) {
  		batch.views.push(view);
  	},

  	addUnresolved: function (thing) {
  		unresolved.push(thing);
  	},

  	removeUnresolved: function (thing) {
  		removeFromArray(unresolved, thing);
  	},

  	// synchronise node detachments with transition ends
  	detachWhenReady: function (thing) {
  		batch.transitionManager.detachQueue.push(thing);
  	},

  	scheduleTask: function (task, postRender) {
  		var _batch;

  		if (!batch) {
  			task();
  		} else {
  			_batch = batch;
  			while (postRender && _batch.previousBatch) {
  				// this can't happen until the DOM has been fully updated
  				// otherwise in some situations (with components inside elements)
  				// transitions and decorators will initialise prematurely
  				_batch = _batch.previousBatch;
  			}

  			_batch.tasks.push(task);
  		}
  	}
  };

  var global_runloop = runloop;

  function flushChanges() {
  	var i, thing, changeHash;

  	while (batch.ractives.length) {
  		thing = batch.ractives.pop();
  		changeHash = thing.viewmodel.applyChanges();

  		if (changeHash) {
  			changeHook.fire(thing, changeHash);
  		}
  	}

  	attemptKeypathResolution();

  	// Now that changes have been fully propagated, we can update the DOM
  	// and complete other tasks
  	for (i = 0; i < batch.views.length; i += 1) {
  		batch.views[i].update();
  	}
  	batch.views.length = 0;

  	for (i = 0; i < batch.tasks.length; i += 1) {
  		batch.tasks[i]();
  	}
  	batch.tasks.length = 0;

  	// If updating the view caused some model blowback - e.g. a triple
  	// containing <option> elements caused the binding on the <select>
  	// to update - then we start over
  	if (batch.ractives.length) return flushChanges();
  }

  function attemptKeypathResolution() {
  	var i, item, keypath, resolved;

  	i = unresolved.length;

  	// see if we can resolve any unresolved references
  	while (i--) {
  		item = unresolved[i];

  		if (item.keypath) {
  			// it resolved some other way. TODO how? two-way binding? Seems
  			// weird that we'd still end up here
  			unresolved.splice(i, 1);
  			continue; // avoid removing the wrong thing should the next condition be true
  		}

  		if (keypath = shared_resolveRef(item.root, item.ref, item.parentFragment)) {
  			(resolved || (resolved = [])).push({
  				item: item,
  				keypath: keypath
  			});

  			unresolved.splice(i, 1);
  		}
  	}

  	if (resolved) {
  		resolved.forEach(global_runloop__resolve);
  	}
  }

  function global_runloop__resolve(resolved) {
  	resolved.item.resolve(resolved.keypath);
  }

  var queue = [];

  var animations = {
  	tick: function () {
  		var i, animation, now;

  		now = utils_getTime();

  		global_runloop.start();

  		for (i = 0; i < queue.length; i += 1) {
  			animation = queue[i];

  			if (!animation.tick(now)) {
  				// animation is complete, remove it from the stack, and decrement i so we don't miss one
  				queue.splice(i--, 1);
  			}
  		}

  		global_runloop.end();

  		if (queue.length) {
  			rAF(animations.tick);
  		} else {
  			animations.running = false;
  		}
  	},

  	add: function (animation) {
  		queue.push(animation);

  		if (!animations.running) {
  			animations.running = true;
  			rAF(animations.tick);
  		}
  	},

  	// TODO optimise this
  	abort: function (keypath, root) {
  		var i = queue.length,
  		    animation;

  		while (i--) {
  			animation = queue[i];

  			if (animation.root === root && animation.keypath === keypath) {
  				animation.stop();
  			}
  		}
  	}
  };

  var shared_animations = animations;

  var Animation = function (options) {
  	var key;

  	this.startTime = Date.now();

  	// from and to
  	for (key in options) {
  		if (options.hasOwnProperty(key)) {
  			this[key] = options[key];
  		}
  	}

  	this.interpolator = shared_interpolate(this.from, this.to, this.root, this.interpolator);
  	this.running = true;

  	this.tick();
  };

  Animation.prototype = {
  	tick: function () {
  		var elapsed, t, value, timeNow, index, keypath;

  		keypath = this.keypath;

  		if (this.running) {
  			timeNow = Date.now();
  			elapsed = timeNow - this.startTime;

  			if (elapsed >= this.duration) {
  				if (keypath !== null) {
  					global_runloop.start(this.root);
  					this.root.viewmodel.set(keypath, this.to);
  					global_runloop.end();
  				}

  				if (this.step) {
  					this.step(1, this.to);
  				}

  				this.complete(this.to);

  				index = this.root._animations.indexOf(this);

  				// TODO investigate why this happens
  				if (index === -1) {
  					warnIfDebug("Animation was not found");
  				}

  				this.root._animations.splice(index, 1);

  				this.running = false;
  				return false; // remove from the stack
  			}

  			t = this.easing ? this.easing(elapsed / this.duration) : elapsed / this.duration;

  			if (keypath !== null) {
  				value = this.interpolator(t);
  				global_runloop.start(this.root);
  				this.root.viewmodel.set(keypath, value);
  				global_runloop.end();
  			}

  			if (this.step) {
  				this.step(t, value);
  			}

  			return true; // keep in the stack
  		}

  		return false; // remove from the stack
  	},

  	stop: function () {
  		var index;

  		this.running = false;

  		index = this.root._animations.indexOf(this);

  		// TODO investigate why this happens
  		if (index === -1) {
  			warnIfDebug("Animation was not found");
  		}

  		this.root._animations.splice(index, 1);
  	}
  };

  var animate_Animation = Animation;

  var prototype_animate = Ractive$animate;

  var noAnimation = { stop: noop };
  function Ractive$animate(keypath, to, options) {
  	var promise, fulfilPromise, k, animation, animations, easing, duration, step, complete, makeValueCollector, currentValues, collectValue, dummy, dummyOptions;

  	promise = new utils_Promise(function (fulfil) {
  		return fulfilPromise = fulfil;
  	});

  	// animate multiple keypaths
  	if (typeof keypath === "object") {
  		options = to || {};
  		easing = options.easing;
  		duration = options.duration;

  		animations = [];

  		// we don't want to pass the `step` and `complete` handlers, as they will
  		// run for each animation! So instead we'll store the handlers and create
  		// our own...
  		step = options.step;
  		complete = options.complete;

  		if (step || complete) {
  			currentValues = {};

  			options.step = null;
  			options.complete = null;

  			makeValueCollector = function (keypath) {
  				return function (t, value) {
  					currentValues[keypath] = value;
  				};
  			};
  		}

  		for (k in keypath) {
  			if (keypath.hasOwnProperty(k)) {
  				if (step || complete) {
  					collectValue = makeValueCollector(k);
  					options = { easing: easing, duration: duration };

  					if (step) {
  						options.step = collectValue;
  					}
  				}

  				options.complete = complete ? collectValue : noop;
  				animations.push(animate(this, k, keypath[k], options));
  			}
  		}

  		// Create a dummy animation, to facilitate step/complete
  		// callbacks, and Promise fulfilment
  		dummyOptions = { easing: easing, duration: duration };

  		if (step) {
  			dummyOptions.step = function (t) {
  				return step(t, currentValues);
  			};
  		}

  		if (complete) {
  			promise.then(function (t) {
  				return complete(t, currentValues);
  			});
  		}

  		dummyOptions.complete = fulfilPromise;

  		dummy = animate(this, null, null, dummyOptions);
  		animations.push(dummy);

  		promise.stop = function () {
  			var animation;

  			while (animation = animations.pop()) {
  				animation.stop();
  			}

  			if (dummy) {
  				dummy.stop();
  			}
  		};

  		return promise;
  	}

  	// animate a single keypath
  	options = options || {};

  	if (options.complete) {
  		promise.then(options.complete);
  	}

  	options.complete = fulfilPromise;
  	animation = animate(this, keypath, to, options);

  	promise.stop = function () {
  		return animation.stop();
  	};
  	return promise;
  }

  function animate(root, keypath, to, options) {
  	var easing, duration, animation, from;

  	if (keypath) {
  		keypath = getKeypath(normalise(keypath));
  	}

  	if (keypath !== null) {
  		from = root.viewmodel.get(keypath);
  	}

  	// cancel any existing animation
  	// TODO what about upstream/downstream keypaths?
  	shared_animations.abort(keypath, root);

  	// don't bother animating values that stay the same
  	if (isEqual(from, to)) {
  		if (options.complete) {
  			options.complete(options.to);
  		}

  		return noAnimation;
  	}

  	// easing function
  	if (options.easing) {
  		if (typeof options.easing === "function") {
  			easing = options.easing;
  		} else {
  			easing = root.easing[options.easing];
  		}

  		if (typeof easing !== "function") {
  			easing = null;
  		}
  	}

  	// duration
  	duration = options.duration === undefined ? 400 : options.duration;

  	// TODO store keys, use an internal set method
  	animation = new animate_Animation({
  		keypath: keypath,
  		from: from,
  		to: to,
  		root: root,
  		duration: duration,
  		easing: easing,
  		interpolator: options.interpolator,

  		// TODO wrap callbacks if necessary, to use instance as context
  		step: options.step,
  		complete: options.complete
  	});

  	shared_animations.add(animation);
  	root._animations.push(animation);

  	return animation;
  }

  var prototype_detach = Ractive$detach;
  var prototype_detach__detachHook = new hooks_Hook("detach");
  function Ractive$detach() {
  	if (this.detached) {
  		return this.detached;
  	}

  	if (this.el) {
  		removeFromArray(this.el.__ractive_instances__, this);
  	}
  	this.detached = this.fragment.detach();
  	prototype_detach__detachHook.fire(this);
  	return this.detached;
  }

  var prototype_find = Ractive$find;

  function Ractive$find(selector) {
  	if (!this.el) {
  		return null;
  	}

  	return this.fragment.find(selector);
  }

  var test = Query$test;
  function Query$test(item, noDirty) {
  	var itemMatches;

  	if (this._isComponentQuery) {
  		itemMatches = !this.selector || item.name === this.selector;
  	} else {
  		itemMatches = item.node ? matches(item.node, this.selector) : null;
  	}

  	if (itemMatches) {
  		this.push(item.node || item.instance);

  		if (!noDirty) {
  			this._makeDirty();
  		}

  		return true;
  	}
  }

  var makeQuery_cancel = function () {
  	var liveQueries, selector, index;

  	liveQueries = this._root[this._isComponentQuery ? "liveComponentQueries" : "liveQueries"];
  	selector = this.selector;

  	index = liveQueries.indexOf(selector);

  	if (index !== -1) {
  		liveQueries.splice(index, 1);
  		liveQueries[selector] = null;
  	}
  };

  var sortByItemPosition = function (a, b) {
  	var ancestryA, ancestryB, oldestA, oldestB, mutualAncestor, indexA, indexB, fragments, fragmentA, fragmentB;

  	ancestryA = getAncestry(a.component || a._ractive.proxy);
  	ancestryB = getAncestry(b.component || b._ractive.proxy);

  	oldestA = lastItem(ancestryA);
  	oldestB = lastItem(ancestryB);

  	// remove items from the end of both ancestries as long as they are identical
  	// - the final one removed is the closest mutual ancestor
  	while (oldestA && oldestA === oldestB) {
  		ancestryA.pop();
  		ancestryB.pop();

  		mutualAncestor = oldestA;

  		oldestA = lastItem(ancestryA);
  		oldestB = lastItem(ancestryB);
  	}

  	// now that we have the mutual ancestor, we can find which is earliest
  	oldestA = oldestA.component || oldestA;
  	oldestB = oldestB.component || oldestB;

  	fragmentA = oldestA.parentFragment;
  	fragmentB = oldestB.parentFragment;

  	// if both items share a parent fragment, our job is easy
  	if (fragmentA === fragmentB) {
  		indexA = fragmentA.items.indexOf(oldestA);
  		indexB = fragmentB.items.indexOf(oldestB);

  		// if it's the same index, it means one contains the other,
  		// so we see which has the longest ancestry
  		return indexA - indexB || ancestryA.length - ancestryB.length;
  	}

  	// if mutual ancestor is a section, we first test to see which section
  	// fragment comes first
  	if (fragments = mutualAncestor.fragments) {
  		indexA = fragments.indexOf(fragmentA);
  		indexB = fragments.indexOf(fragmentB);

  		return indexA - indexB || ancestryA.length - ancestryB.length;
  	}

  	throw new Error("An unexpected condition was met while comparing the position of two components. Please file an issue at https://github.com/RactiveJS/Ractive/issues - thanks!");
  };

  function getParent(item) {
  	var parentFragment;

  	if (parentFragment = item.parentFragment) {
  		return parentFragment.owner;
  	}

  	if (item.component && (parentFragment = item.component.parentFragment)) {
  		return parentFragment.owner;
  	}
  }

  function getAncestry(item) {
  	var ancestry, ancestor;

  	ancestry = [item];

  	ancestor = getParent(item);

  	while (ancestor) {
  		ancestry.push(ancestor);
  		ancestor = getParent(ancestor);
  	}

  	return ancestry;
  }

  var sortByDocumentPosition = function (node, otherNode) {
  	var bitmask;

  	if (node.compareDocumentPosition) {
  		bitmask = node.compareDocumentPosition(otherNode);
  		return bitmask & 2 ? 1 : -1;
  	}

  	// In old IE, we can piggy back on the mechanism for
  	// comparing component positions
  	return sortByItemPosition(node, otherNode);
  };

  var sort = function () {
  	this.sort(this._isComponentQuery ? sortByItemPosition : sortByDocumentPosition);
  	this._dirty = false;
  };

  var makeQuery_dirty = function () {
  	var _this = this;

  	if (!this._dirty) {
  		this._dirty = true;

  		// Once the DOM has been updated, ensure the query
  		// is correctly ordered
  		global_runloop.scheduleTask(function () {
  			_this._sort();
  		});
  	}
  };

  var remove = function (nodeOrComponent) {
  	var index = this.indexOf(this._isComponentQuery ? nodeOrComponent.instance : nodeOrComponent);

  	if (index !== -1) {
  		this.splice(index, 1);
  	}
  };

  var _makeQuery = makeQuery;
  function makeQuery(ractive, selector, live, isComponentQuery) {
  	var query = [];

  	defineProperties(query, {
  		selector: { value: selector },
  		live: { value: live },

  		_isComponentQuery: { value: isComponentQuery },
  		_test: { value: test }
  	});

  	if (!live) {
  		return query;
  	}

  	defineProperties(query, {
  		cancel: { value: makeQuery_cancel },

  		_root: { value: ractive },
  		_sort: { value: sort },
  		_makeDirty: { value: makeQuery_dirty },
  		_remove: { value: remove },

  		_dirty: { value: false, writable: true }
  	});

  	return query;
  }

  var prototype_findAll = Ractive$findAll;
  function Ractive$findAll(selector, options) {
  	var liveQueries, query;

  	if (!this.el) {
  		return [];
  	}

  	options = options || {};
  	liveQueries = this._liveQueries;

  	// Shortcut: if we're maintaining a live query with this
  	// selector, we don't need to traverse the parallel DOM
  	if (query = liveQueries[selector]) {

  		// Either return the exact same query, or (if not live) a snapshot
  		return options && options.live ? query : query.slice();
  	}

  	query = _makeQuery(this, selector, !!options.live, false);

  	// Add this to the list of live queries Ractive needs to maintain,
  	// if applicable
  	if (query.live) {
  		liveQueries.push(selector);
  		liveQueries["_" + selector] = query;
  	}

  	this.fragment.findAll(selector, query);
  	return query;
  }

  var prototype_findAllComponents = Ractive$findAllComponents;
  function Ractive$findAllComponents(selector, options) {
  	var liveQueries, query;

  	options = options || {};
  	liveQueries = this._liveComponentQueries;

  	// Shortcut: if we're maintaining a live query with this
  	// selector, we don't need to traverse the parallel DOM
  	if (query = liveQueries[selector]) {

  		// Either return the exact same query, or (if not live) a snapshot
  		return options && options.live ? query : query.slice();
  	}

  	query = _makeQuery(this, selector, !!options.live, true);

  	// Add this to the list of live queries Ractive needs to maintain,
  	// if applicable
  	if (query.live) {
  		liveQueries.push(selector);
  		liveQueries["_" + selector] = query;
  	}

  	this.fragment.findAllComponents(selector, query);
  	return query;
  }

  var prototype_findComponent = Ractive$findComponent;

  function Ractive$findComponent(selector) {
  	return this.fragment.findComponent(selector);
  }

  var findContainer = Ractive$findContainer;

  function Ractive$findContainer(selector) {
  	if (this.container) {
  		if (this.container.component && this.container.component.name === selector) {
  			return this.container;
  		} else {
  			return this.container.findContainer(selector);
  		}
  	}

  	return null;
  }

  var findParent = Ractive$findParent;

  function Ractive$findParent(selector) {

  	if (this.parent) {
  		if (this.parent.component && this.parent.component.name === selector) {
  			return this.parent;
  		} else {
  			return this.parent.findParent(selector);
  		}
  	}

  	return null;
  }

  var eventStack = {
  	enqueue: function (ractive, event) {
  		if (ractive.event) {
  			ractive._eventQueue = ractive._eventQueue || [];
  			ractive._eventQueue.push(ractive.event);
  		}
  		ractive.event = event;
  	},
  	dequeue: function (ractive) {
  		if (ractive._eventQueue && ractive._eventQueue.length) {
  			ractive.event = ractive._eventQueue.pop();
  		} else {
  			delete ractive.event;
  		}
  	}
  };

  var shared_eventStack = eventStack;

  var shared_fireEvent = fireEvent;

  function fireEvent(ractive, eventName) {
  	var options = arguments[2] === undefined ? {} : arguments[2];

  	if (!eventName) {
  		return;
  	}

  	if (!options.event) {
  		options.event = {
  			name: eventName,
  			// until event not included as argument default
  			_noArg: true
  		};
  	} else {
  		options.event.name = eventName;
  	}

  	var eventNames = getKeypath(eventName).wildcardMatches();
  	fireEventAs(ractive, eventNames, options.event, options.args, true);
  }

  function fireEventAs(ractive, eventNames, event, args) {
  	var initialFire = arguments[4] === undefined ? false : arguments[4];

  	var subscribers,
  	    i,
  	    bubble = true;

  	shared_eventStack.enqueue(ractive, event);

  	for (i = eventNames.length; i >= 0; i--) {
  		subscribers = ractive._subs[eventNames[i]];

  		if (subscribers) {
  			bubble = notifySubscribers(ractive, subscribers, event, args) && bubble;
  		}
  	}

  	shared_eventStack.dequeue(ractive);

  	if (ractive.parent && bubble) {

  		if (initialFire && ractive.component) {
  			var fullName = ractive.component.name + "." + eventNames[eventNames.length - 1];
  			eventNames = getKeypath(fullName).wildcardMatches();

  			if (event) {
  				event.component = ractive;
  			}
  		}

  		fireEventAs(ractive.parent, eventNames, event, args);
  	}
  }

  function notifySubscribers(ractive, subscribers, event, args) {
  	var originalEvent = null,
  	    stopEvent = false;

  	if (event && !event._noArg) {
  		args = [event].concat(args);
  	}

  	// subscribers can be modified inflight, e.g. "once" functionality
  	// so we need to copy to make sure everyone gets called
  	subscribers = subscribers.slice();

  	for (var i = 0, len = subscribers.length; i < len; i += 1) {
  		if (subscribers[i].apply(ractive, args) === false) {
  			stopEvent = true;
  		}
  	}

  	if (event && !event._noArg && stopEvent && (originalEvent = event.original)) {
  		originalEvent.preventDefault && originalEvent.preventDefault();
  		originalEvent.stopPropagation && originalEvent.stopPropagation();
  	}

  	return !stopEvent;
  }

  var prototype_fire = Ractive$fire;
  function Ractive$fire(eventName) {

  	var options = {
  		args: Array.prototype.slice.call(arguments, 1)
  	};

  	shared_fireEvent(this, eventName, options);
  }

  var prototype_get = Ractive$get;
  var options = {
  	capture: true, // top-level calls should be intercepted
  	noUnwrap: true, // wrapped values should NOT be unwrapped
  	fullRootGet: true // root get should return mappings
  };
  function Ractive$get(keypath) {
  	var value;

  	keypath = getKeypath(normalise(keypath));
  	value = this.viewmodel.get(keypath, options);

  	// Create inter-component binding, if necessary
  	if (value === undefined && this.parent && !this.isolated) {
  		if (shared_resolveRef(this, keypath.str, this.component.parentFragment)) {
  			// creates binding as side-effect, if appropriate
  			value = this.viewmodel.get(keypath);
  		}
  	}

  	return value;
  }

  var insert = Ractive$insert;

  var insertHook = new hooks_Hook("insert");
  function Ractive$insert(target, anchor) {
  	if (!this.fragment.rendered) {
  		// TODO create, and link to, documentation explaining this
  		throw new Error("The API has changed - you must call `ractive.render(target[, anchor])` to render your Ractive instance. Once rendered you can use `ractive.insert()`.");
  	}

  	target = getElement(target);
  	anchor = getElement(anchor) || null;

  	if (!target) {
  		throw new Error("You must specify a valid target to insert into");
  	}

  	target.insertBefore(this.detach(), anchor);
  	this.el = target;

  	(target.__ractive_instances__ || (target.__ractive_instances__ = [])).push(this);
  	this.detached = null;

  	fireInsertHook(this);
  }

  function fireInsertHook(ractive) {
  	insertHook.fire(ractive);

  	ractive.findAllComponents("*").forEach(function (child) {
  		fireInsertHook(child.instance);
  	});
  }

  var prototype_merge = Ractive$merge;
  function Ractive$merge(keypath, array, options) {
  	var currentArray, promise;

  	keypath = getKeypath(normalise(keypath));
  	currentArray = this.viewmodel.get(keypath);

  	// If either the existing value or the new value isn't an
  	// array, just do a regular set
  	if (!isArray(currentArray) || !isArray(array)) {
  		return this.set(keypath, array, options && options.complete);
  	}

  	// Manage transitions
  	promise = global_runloop.start(this, true);
  	this.viewmodel.merge(keypath, currentArray, array, options);
  	global_runloop.end();

  	return promise;
  }

  var Observer = function (ractive, keypath, callback, options) {
  	this.root = ractive;
  	this.keypath = keypath;
  	this.callback = callback;
  	this.defer = options.defer;

  	// default to root as context, but allow it to be overridden
  	this.context = options && options.context ? options.context : ractive;
  };

  Observer.prototype = {
  	init: function (immediate) {
  		this.value = this.root.get(this.keypath.str);

  		if (immediate !== false) {
  			this.update();
  		} else {
  			this.oldValue = this.value;
  		}
  	},

  	setValue: function (value) {
  		var _this = this;

  		if (!isEqual(value, this.value)) {
  			this.value = value;

  			if (this.defer && this.ready) {
  				global_runloop.scheduleTask(function () {
  					return _this.update();
  				});
  			} else {
  				this.update();
  			}
  		}
  	},

  	update: function () {
  		// Prevent infinite loops
  		if (this.updating) {
  			return;
  		}

  		this.updating = true;

  		this.callback.call(this.context, this.value, this.oldValue, this.keypath.str);
  		this.oldValue = this.value;

  		this.updating = false;
  	}
  };

  var observe_Observer = Observer;

  var observe_getPattern = getPattern;
  function getPattern(ractive, pattern) {
  	var matchingKeypaths, values;

  	matchingKeypaths = getMatchingKeypaths(ractive, pattern);

  	values = {};
  	matchingKeypaths.forEach(function (keypath) {
  		values[keypath.str] = ractive.get(keypath.str);
  	});

  	return values;
  }

  var PatternObserver,
      slice = Array.prototype.slice;

  PatternObserver = function (ractive, keypath, callback, options) {
  	this.root = ractive;

  	this.callback = callback;
  	this.defer = options.defer;

  	this.keypath = keypath;
  	this.regex = new RegExp("^" + keypath.str.replace(/\./g, "\\.").replace(/\*/g, "([^\\.]+)") + "$");
  	this.values = {};

  	if (this.defer) {
  		this.proxies = [];
  	}

  	// default to root as context, but allow it to be overridden
  	this.context = options && options.context ? options.context : ractive;
  };

  PatternObserver.prototype = {
  	init: function (immediate) {
  		var values, keypath;

  		values = observe_getPattern(this.root, this.keypath);

  		if (immediate !== false) {
  			for (keypath in values) {
  				if (values.hasOwnProperty(keypath)) {
  					this.update(getKeypath(keypath));
  				}
  			}
  		} else {
  			this.values = values;
  		}
  	},

  	update: function (keypath) {
  		var _this = this;

  		var values;

  		if (keypath.isPattern) {
  			values = observe_getPattern(this.root, keypath);

  			for (keypath in values) {
  				if (values.hasOwnProperty(keypath)) {
  					this.update(getKeypath(keypath));
  				}
  			}

  			return;
  		}

  		// special case - array mutation should not trigger `array.*`
  		// pattern observer with `array.length`
  		if (this.root.viewmodel.implicitChanges[keypath.str]) {
  			return;
  		}

  		if (this.defer && this.ready) {
  			global_runloop.scheduleTask(function () {
  				return _this.getProxy(keypath).update();
  			});
  			return;
  		}

  		this.reallyUpdate(keypath);
  	},

  	reallyUpdate: function (keypath) {
  		var keypathStr, value, keys, args;

  		keypathStr = keypath.str;
  		value = this.root.viewmodel.get(keypath);

  		// Prevent infinite loops
  		if (this.updating) {
  			this.values[keypathStr] = value;
  			return;
  		}

  		this.updating = true;

  		if (!isEqual(value, this.values[keypathStr]) || !this.ready) {
  			keys = slice.call(this.regex.exec(keypathStr), 1);
  			args = [value, this.values[keypathStr], keypathStr].concat(keys);

  			this.values[keypathStr] = value;
  			this.callback.apply(this.context, args);
  		}

  		this.updating = false;
  	},

  	getProxy: function (keypath) {
  		var _this = this;

  		if (!this.proxies[keypath.str]) {
  			this.proxies[keypath.str] = {
  				update: function () {
  					return _this.reallyUpdate(keypath);
  				}
  			};
  		}

  		return this.proxies[keypath.str];
  	}
  };

  var observe_PatternObserver = PatternObserver;

  var observe_getObserverFacade = getObserverFacade;
  var emptyObject = {};
  function getObserverFacade(ractive, keypath, callback, options) {
  	var observer, isPatternObserver, cancelled;

  	keypath = getKeypath(normalise(keypath));
  	options = options || emptyObject;

  	// pattern observers are treated differently
  	if (keypath.isPattern) {
  		observer = new observe_PatternObserver(ractive, keypath, callback, options);
  		ractive.viewmodel.patternObservers.push(observer);
  		isPatternObserver = true;
  	} else {
  		observer = new observe_Observer(ractive, keypath, callback, options);
  	}

  	observer.init(options.init);
  	ractive.viewmodel.register(keypath, observer, isPatternObserver ? "patternObservers" : "observers");

  	// This flag allows observers to initialise even with undefined values
  	observer.ready = true;

  	var facade = {
  		cancel: function () {
  			var index;

  			if (cancelled) {
  				return;
  			}

  			if (isPatternObserver) {
  				index = ractive.viewmodel.patternObservers.indexOf(observer);

  				ractive.viewmodel.patternObservers.splice(index, 1);
  				ractive.viewmodel.unregister(keypath, observer, "patternObservers");
  			} else {
  				ractive.viewmodel.unregister(keypath, observer, "observers");
  			}
  			cancelled = true;
  		}
  	};

  	ractive._observers.push(facade);
  	return facade;
  }

  var observe = Ractive$observe;
  function Ractive$observe(keypath, callback, options) {

  	var observers, map, keypaths, i;

  	// Allow a map of keypaths to handlers
  	if (isObject(keypath)) {
  		options = callback;
  		map = keypath;

  		observers = [];

  		for (keypath in map) {
  			if (map.hasOwnProperty(keypath)) {
  				callback = map[keypath];
  				observers.push(this.observe(keypath, callback, options));
  			}
  		}

  		return {
  			cancel: function () {
  				while (observers.length) {
  					observers.pop().cancel();
  				}
  			}
  		};
  	}

  	// Allow `ractive.observe( callback )` - i.e. observe entire model
  	if (typeof keypath === "function") {
  		options = callback;
  		callback = keypath;
  		keypath = "";

  		return observe_getObserverFacade(this, keypath, callback, options);
  	}

  	keypaths = keypath.split(" ");

  	// Single keypath
  	if (keypaths.length === 1) {
  		return observe_getObserverFacade(this, keypath, callback, options);
  	}

  	// Multiple space-separated keypaths
  	observers = [];

  	i = keypaths.length;
  	while (i--) {
  		keypath = keypaths[i];

  		if (keypath) {
  			observers.push(observe_getObserverFacade(this, keypath, callback, options));
  		}
  	}

  	return {
  		cancel: function () {
  			while (observers.length) {
  				observers.pop().cancel();
  			}
  		}
  	};
  }

  var observeOnce = Ractive$observeOnce;

  function Ractive$observeOnce(property, callback, options) {

  	var observer = this.observe(property, function () {
  		callback.apply(this, arguments);
  		observer.cancel();
  	}, { init: false, defer: options && options.defer });

  	return observer;
  }

  var shared_trim = function (str) {
    return str.trim();
  };

  var notEmptyString = function (str) {
    return str !== "";
  };

  var off = Ractive$off;
  function Ractive$off(eventName, callback) {
  	var _this = this;

  	var eventNames;

  	// if no arguments specified, remove all callbacks
  	if (!eventName) {
  		// TODO use this code instead, once the following issue has been resolved
  		// in PhantomJS (tests are unpassable otherwise!)
  		// https://github.com/ariya/phantomjs/issues/11856
  		// defineProperty( this, '_subs', { value: create( null ), configurable: true });
  		for (eventName in this._subs) {
  			delete this._subs[eventName];
  		}
  	} else {
  		// Handle multiple space-separated event names
  		eventNames = eventName.split(" ").map(shared_trim).filter(notEmptyString);

  		eventNames.forEach(function (eventName) {
  			var subscribers, index;

  			// If we have subscribers for this event...
  			if (subscribers = _this._subs[eventName]) {
  				// ...if a callback was specified, only remove that
  				if (callback) {
  					index = subscribers.indexOf(callback);
  					if (index !== -1) {
  						subscribers.splice(index, 1);
  					}
  				}

  				// ...otherwise remove all callbacks
  				else {
  					_this._subs[eventName] = [];
  				}
  			}
  		});
  	}

  	return this;
  }

  var on = Ractive$on;
  function Ractive$on(eventName, callback) {
  	var _this = this;

  	var listeners, n, eventNames;

  	// allow mutliple listeners to be bound in one go
  	if (typeof eventName === "object") {
  		listeners = [];

  		for (n in eventName) {
  			if (eventName.hasOwnProperty(n)) {
  				listeners.push(this.on(n, eventName[n]));
  			}
  		}

  		return {
  			cancel: function () {
  				var listener;

  				while (listener = listeners.pop()) {
  					listener.cancel();
  				}
  			}
  		};
  	}

  	// Handle multiple space-separated event names
  	eventNames = eventName.split(" ").map(shared_trim).filter(notEmptyString);

  	eventNames.forEach(function (eventName) {
  		(_this._subs[eventName] || (_this._subs[eventName] = [])).push(callback);
  	});

  	return {
  		cancel: function () {
  			return _this.off(eventName, callback);
  		}
  	};
  }

  var once = Ractive$once;

  function Ractive$once(eventName, handler) {

  	var listener = this.on(eventName, function () {
  		handler.apply(this, arguments);
  		listener.cancel();
  	});

  	// so we can still do listener.cancel() manually
  	return listener;
  }

  // This function takes an array, the name of a mutator method, and the
  // arguments to call that mutator method with, and returns an array that
  // maps the old indices to their new indices.

  // So if you had something like this...
  //
  //     array = [ 'a', 'b', 'c', 'd' ];
  //     array.push( 'e' );
  //
  // ...you'd get `[ 0, 1, 2, 3 ]` - in other words, none of the old indices
  // have changed. If you then did this...
  //
  //     array.unshift( 'z' );
  //
  // ...the indices would be `[ 1, 2, 3, 4, 5 ]` - every item has been moved
  // one higher to make room for the 'z'. If you removed an item, the new index
  // would be -1...
  //
  //     array.splice( 2, 2 );
  //
  // ...this would result in [ 0, 1, -1, -1, 2, 3 ].
  //
  // This information is used to enable fast, non-destructive shuffling of list
  // sections when you do e.g. `ractive.splice( 'items', 2, 2 );

  var shared_getNewIndices = getNewIndices;

  function getNewIndices(array, methodName, args) {
  	var spliceArguments,
  	    len,
  	    newIndices = [],
  	    removeStart,
  	    removeEnd,
  	    balance,
  	    i;

  	spliceArguments = getSpliceEquivalent(array, methodName, args);

  	if (!spliceArguments) {
  		return null; // TODO support reverse and sort?
  	}

  	len = array.length;
  	balance = spliceArguments.length - 2 - spliceArguments[1];

  	removeStart = Math.min(len, spliceArguments[0]);
  	removeEnd = removeStart + spliceArguments[1];

  	for (i = 0; i < removeStart; i += 1) {
  		newIndices.push(i);
  	}

  	for (; i < removeEnd; i += 1) {
  		newIndices.push(-1);
  	}

  	for (; i < len; i += 1) {
  		newIndices.push(i + balance);
  	}

  	// there is a net shift for the rest of the array starting with index + balance
  	if (balance !== 0) {
  		newIndices.touchedFrom = spliceArguments[0];
  	} else {
  		newIndices.touchedFrom = array.length;
  	}

  	return newIndices;
  }

  // The pop, push, shift an unshift methods can all be represented
  // as an equivalent splice
  function getSpliceEquivalent(array, methodName, args) {
  	switch (methodName) {
  		case "splice":
  			if (args[0] !== undefined && args[0] < 0) {
  				args[0] = array.length + Math.max(args[0], -array.length);
  			}

  			while (args.length < 2) {
  				args.push(0);
  			}

  			// ensure we only remove elements that exist
  			args[1] = Math.min(args[1], array.length - args[0]);

  			return args;

  		case "sort":
  		case "reverse":
  			return null;

  		case "pop":
  			if (array.length) {
  				return [array.length - 1, 1];
  			}
  			return [0, 0];

  		case "push":
  			return [array.length, 0].concat(args);

  		case "shift":
  			return [0, array.length ? 1 : 0];

  		case "unshift":
  			return [0, 0].concat(args);
  	}
  }

  var arrayProto = Array.prototype;

  var makeArrayMethod = function (methodName) {
  	return function (keypath) {
  		for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
  			args[_key - 1] = arguments[_key];
  		}

  		var array,
  		    newIndices = [],
  		    len,
  		    promise,
  		    result;

  		keypath = getKeypath(normalise(keypath));

  		array = this.viewmodel.get(keypath);
  		len = array.length;

  		if (!isArray(array)) {
  			throw new Error("Called ractive." + methodName + "('" + keypath.str + "'), but '" + keypath.str + "' does not refer to an array");
  		}

  		newIndices = shared_getNewIndices(array, methodName, args);

  		result = arrayProto[methodName].apply(array, args);
  		promise = global_runloop.start(this, true).then(function () {
  			return result;
  		});

  		if (!!newIndices) {
  			this.viewmodel.smartUpdate(keypath, array, newIndices);
  		} else {
  			this.viewmodel.mark(keypath);
  		}

  		global_runloop.end();

  		return promise;
  	};
  };

  var pop = makeArrayMethod("pop");

  var push = makeArrayMethod("push");

  var css,
      update,
      styleElement,
      head,
      styleSheet,
      inDom,
      global_css__prefix = "/* Ractive.js component styles */\n",
      styles = [],
      dirty = false;

  if (!isClient) {
  	// TODO handle encapsulated CSS in server-rendered HTML!
  	css = {
  		add: noop,
  		apply: noop
  	};
  } else {
  	styleElement = document.createElement("style");
  	styleElement.type = "text/css";

  	head = document.getElementsByTagName("head")[0];

  	inDom = false;

  	// Internet Exploder won't let you use styleSheet.innerHTML - we have to
  	// use styleSheet.cssText instead
  	styleSheet = styleElement.styleSheet;

  	update = function () {
  		var css = global_css__prefix + styles.map(function (s) {
  			return "\n/* {" + s.id + "} */\n" + s.styles;
  		}).join("\n");

  		if (styleSheet) {
  			styleSheet.cssText = css;
  		} else {
  			styleElement.innerHTML = css;
  		}

  		if (!inDom) {
  			head.appendChild(styleElement);
  			inDom = true;
  		}
  	};

  	css = {
  		add: function (s) {
  			styles.push(s);
  			dirty = true;
  		},

  		apply: function () {
  			if (dirty) {
  				update();
  				dirty = false;
  			}
  		}
  	};
  }

  var global_css = css;

  var prototype_render = Ractive$render;

  var renderHook = new hooks_Hook("render"),
      completeHook = new hooks_Hook("complete");
  function Ractive$render(target, anchor) {
  	var _this = this;

  	var promise, instances, transitionsEnabled;

  	// if `noIntro` is `true`, temporarily disable transitions
  	transitionsEnabled = this.transitionsEnabled;
  	if (this.noIntro) {
  		this.transitionsEnabled = false;
  	}

  	promise = global_runloop.start(this, true);
  	global_runloop.scheduleTask(function () {
  		return renderHook.fire(_this);
  	}, true);

  	if (this.fragment.rendered) {
  		throw new Error("You cannot call ractive.render() on an already rendered instance! Call ractive.unrender() first");
  	}

  	target = getElement(target) || this.el;
  	anchor = getElement(anchor) || this.anchor;

  	this.el = target;
  	this.anchor = anchor;

  	if (!this.append && target) {
  		// Teardown any existing instances *before* trying to set up the new one -
  		// avoids certain weird bugs
  		var others = target.__ractive_instances__;
  		if (others && others.length) {
  			removeOtherInstances(others);
  		}

  		// make sure we are the only occupants
  		target.innerHTML = ""; // TODO is this quicker than removeChild? Initial research inconclusive
  	}

  	if (this.cssId) {
  		// ensure encapsulated CSS is up-to-date
  		global_css.apply();
  	}

  	if (target) {
  		if (!(instances = target.__ractive_instances__)) {
  			target.__ractive_instances__ = [this];
  		} else {
  			instances.push(this);
  		}

  		if (anchor) {
  			target.insertBefore(this.fragment.render(), anchor);
  		} else {
  			target.appendChild(this.fragment.render());
  		}
  	}

  	global_runloop.end();

  	this.transitionsEnabled = transitionsEnabled;

  	return promise.then(function () {
  		return completeHook.fire(_this);
  	});
  }

  function removeOtherInstances(others) {
  	others.splice(0, others.length).forEach(teardown);
  }

  var adaptConfigurator = {
  	extend: function (Parent, proto, options) {
  		proto.adapt = custom_adapt__combine(proto.adapt, ensureArray(options.adapt));
  	},

  	init: function () {}
  };

  var custom_adapt = adaptConfigurator;

  function custom_adapt__combine(a, b) {
  	var c = a.slice(),
  	    i = b.length;

  	while (i--) {
  		if (! ~c.indexOf(b[i])) {
  			c.push(b[i]);
  		}
  	}

  	return c;
  }

  var transform = transformCss;

  var selectorsPattern = /(?:^|\})?\s*([^\{\}]+)\s*\{/g,
      commentsPattern = /\/\*.*?\*\//g,
      selectorUnitPattern = /((?:(?:\[[^\]+]\])|(?:[^\s\+\>\~:]))+)((?::[^\s\+\>\~\(]+(?:\([^\)]+\))?)?\s*[\s\+\>\~]?)\s*/g,
      mediaQueryPattern = /^@media/,
      dataRvcGuidPattern = /\[data-ractive-css~="\{[a-z0-9-]+\}"]/g;
  function transformCss(css, id) {
  	var transformed, dataAttr, addGuid;

  	dataAttr = "[data-ractive-css~=\"{" + id + "}\"]";

  	addGuid = function (selector) {
  		var selectorUnits,
  		    match,
  		    unit,
  		    base,
  		    prepended,
  		    appended,
  		    i,
  		    transformed = [];

  		selectorUnits = [];

  		while (match = selectorUnitPattern.exec(selector)) {
  			selectorUnits.push({
  				str: match[0],
  				base: match[1],
  				modifiers: match[2]
  			});
  		}

  		// For each simple selector within the selector, we need to create a version
  		// that a) combines with the id, and b) is inside the id
  		base = selectorUnits.map(extractString);

  		i = selectorUnits.length;
  		while (i--) {
  			appended = base.slice();

  			// Pseudo-selectors should go after the attribute selector
  			unit = selectorUnits[i];
  			appended[i] = unit.base + dataAttr + unit.modifiers || "";

  			prepended = base.slice();
  			prepended[i] = dataAttr + " " + prepended[i];

  			transformed.push(appended.join(" "), prepended.join(" "));
  		}

  		return transformed.join(", ");
  	};

  	if (dataRvcGuidPattern.test(css)) {
  		transformed = css.replace(dataRvcGuidPattern, dataAttr);
  	} else {
  		transformed = css.replace(commentsPattern, "").replace(selectorsPattern, function (match, $1) {
  			var selectors, transformed;

  			// don't transform media queries!
  			if (mediaQueryPattern.test($1)) return match;

  			selectors = $1.split(",").map(trim);
  			transformed = selectors.map(addGuid).join(", ") + " ";

  			return match.replace($1, transformed);
  		});
  	}

  	return transformed;
  }

  function trim(str) {
  	if (str.trim) {
  		return str.trim();
  	}

  	return str.replace(/^\s+/, "").replace(/\s+$/, "");
  }

  function extractString(unit) {
  	return unit.str;
  }

  var css_css__uid = 1;

  var cssConfigurator = {
  	name: "css",

  	extend: function (Parent, proto, options) {
  		if (options.css) {
  			var id = css_css__uid++;
  			var styles = options.noCssTransform ? options.css : transform(options.css, id);

  			proto.cssId = id;
  			global_css.add({ id: id, styles: styles });
  		}
  	},

  	init: function () {}
  };

  var css_css = cssConfigurator;

  function validate(data) {
  	// Warn if userOptions.data is a non-POJO
  	if (data && data.constructor !== Object) {
  		if (typeof data === "function") {} else if (typeof data !== "object") {
  			fatal("data option must be an object or a function, `" + data + "` is not valid");
  		} else {
  			warnIfDebug("If supplied, options.data should be a plain JavaScript object - using a non-POJO as the root object may work, but is discouraged");
  		}
  	}
  }

  var dataConfigurator = {
  	name: "data",

  	extend: function (Parent, proto, options) {
  		var key = undefined,
  		    value = undefined;

  		// check for non-primitives, which could cause mutation-related bugs
  		if (options.data && isObject(options.data)) {
  			for (key in options.data) {
  				value = options.data[key];

  				if (value && typeof value === "object") {
  					if (isObject(value) || isArray(value)) {
  						warnIfDebug("Passing a `data` option with object and array properties to Ractive.extend() is discouraged, as mutating them is likely to cause bugs. Consider using a data function instead:\n\n  // this...\n  data: function () {\n    return {\n      myObject: {}\n    };\n  })\n\n  // instead of this:\n  data: {\n    myObject: {}\n  }");
  					}
  				}
  			}
  		}

  		proto.data = custom_data__combine(proto.data, options.data);
  	},

  	init: function (Parent, ractive, options) {
  		var result = custom_data__combine(Parent.prototype.data, options.data);

  		if (typeof result === "function") {
  			result = result.call(ractive);
  		}

  		return result || {};
  	},

  	reset: function (ractive) {
  		var result = this.init(ractive.constructor, ractive, ractive.viewmodel);

  		ractive.viewmodel.reset(result);
  		return true;
  	}
  };

  var custom_data = dataConfigurator;

  function custom_data__combine(parentValue, childValue) {
  	validate(childValue);

  	var parentIsFn = typeof parentValue === "function";
  	var childIsFn = typeof childValue === "function";

  	// Very important, otherwise child instance can become
  	// the default data object on Ractive or a component.
  	// then ractive.set() ends up setting on the prototype!
  	if (!childValue && !parentIsFn) {
  		childValue = {};
  	}

  	// Fast path, where we just need to copy properties from
  	// parent to child
  	if (!parentIsFn && !childIsFn) {
  		return fromProperties(childValue, parentValue);
  	}

  	return function () {
  		var child = childIsFn ? callDataFunction(childValue, this) : childValue;
  		var parent = parentIsFn ? callDataFunction(parentValue, this) : parentValue;

  		return fromProperties(child, parent);
  	};
  }

  function callDataFunction(fn, context) {
  	var data = fn.call(context);

  	if (!data) return;

  	if (typeof data !== "object") {
  		fatal("Data function must return an object");
  	}

  	if (data.constructor !== Object) {
  		warnOnceIfDebug("Data function returned something other than a plain JavaScript object. This might work, but is strongly discouraged");
  	}

  	return data;
  }

  function fromProperties(primary, secondary) {
  	if (primary && secondary) {
  		for (var key in secondary) {
  			if (!(key in primary)) {
  				primary[key] = secondary[key];
  			}
  		}

  		return primary;
  	}

  	return primary || secondary;
  }

  // TODO do we need to support this in the new Ractive() case?

  var parse = null;

  var parseOptions = ["preserveWhitespace", "sanitize", "stripComments", "delimiters", "tripleDelimiters", "interpolate"];

  var parser = {
  	fromId: fromId, isHashedId: isHashedId, isParsed: isParsed, getParseOptions: getParseOptions, createHelper: template_parser__createHelper,
  	parse: doParse
  };

  function template_parser__createHelper(parseOptions) {
  	var helper = create(parser);
  	helper.parse = function (template, options) {
  		return doParse(template, options || parseOptions);
  	};
  	return helper;
  }

  function doParse(template, parseOptions) {
  	if (!parse) {
  		throw new Error("Missing Ractive.parse - cannot parse template. Either preparse or use the version that includes the parser");
  	}

  	return parse(template, parseOptions || this.options);
  }

  function fromId(id, options) {
  	var template;

  	if (!isClient) {
  		if (options && options.noThrow) {
  			return;
  		}
  		throw new Error("Cannot retrieve template #" + id + " as Ractive is not running in a browser.");
  	}

  	if (isHashedId(id)) {
  		id = id.substring(1);
  	}

  	if (!(template = document.getElementById(id))) {
  		if (options && options.noThrow) {
  			return;
  		}
  		throw new Error("Could not find template element with id #" + id);
  	}

  	if (template.tagName.toUpperCase() !== "SCRIPT") {
  		if (options && options.noThrow) {
  			return;
  		}
  		throw new Error("Template element with id #" + id + ", must be a <script> element");
  	}

  	return "textContent" in template ? template.textContent : template.innerHTML;
  }

  function isHashedId(id) {
  	return id && id[0] === "#";
  }

  function isParsed(template) {
  	return !(typeof template === "string");
  }

  function getParseOptions(ractive) {
  	// Could be Ractive or a Component
  	if (ractive.defaults) {
  		ractive = ractive.defaults;
  	}

  	return parseOptions.reduce(function (val, key) {
  		val[key] = ractive[key];
  		return val;
  	}, {});
  }

  var template_parser = parser;

  var templateConfigurator = {
  	name: "template",

  	extend: function extend(Parent, proto, options) {
  		var template;

  		// only assign if exists
  		if ("template" in options) {
  			template = options.template;

  			if (typeof template === "function") {
  				proto.template = template;
  			} else {
  				proto.template = parseIfString(template, proto);
  			}
  		}
  	},

  	init: function init(Parent, ractive, options) {
  		var template, fn;

  		// TODO because of prototypal inheritance, we might just be able to use
  		// ractive.template, and not bother passing through the Parent object.
  		// At present that breaks the test mocks' expectations
  		template = "template" in options ? options.template : Parent.prototype.template;

  		if (typeof template === "function") {
  			fn = template;
  			template = getDynamicTemplate(ractive, fn);

  			ractive._config.template = {
  				fn: fn,
  				result: template
  			};
  		}

  		template = parseIfString(template, ractive);

  		// TODO the naming of this is confusing - ractive.template refers to [...],
  		// but Component.prototype.template refers to {v:1,t:[],p:[]}...
  		// it's unnecessary, because the developer never needs to access
  		// ractive.template
  		ractive.template = template.t;

  		if (template.p) {
  			extendPartials(ractive.partials, template.p);
  		}
  	},

  	reset: function (ractive) {
  		var result = resetValue(ractive),
  		    parsed;

  		if (result) {
  			parsed = parseIfString(result, ractive);

  			ractive.template = parsed.t;
  			extendPartials(ractive.partials, parsed.p, true);

  			return true;
  		}
  	}
  };

  function resetValue(ractive) {
  	var initial = ractive._config.template,
  	    result;

  	// If this isn't a dynamic template, there's nothing to do
  	if (!initial || !initial.fn) {
  		return;
  	}

  	result = getDynamicTemplate(ractive, initial.fn);

  	// TODO deep equality check to prevent unnecessary re-rendering
  	// in the case of already-parsed templates
  	if (result !== initial.result) {
  		initial.result = result;
  		result = parseIfString(result, ractive);
  		return result;
  	}
  }

  function getDynamicTemplate(ractive, fn) {
  	var helper = template_template__createHelper(template_parser.getParseOptions(ractive));
  	return fn.call(ractive, helper);
  }

  function template_template__createHelper(parseOptions) {
  	var helper = create(template_parser);
  	helper.parse = function (template, options) {
  		return template_parser.parse(template, options || parseOptions);
  	};
  	return helper;
  }

  function parseIfString(template, ractive) {
  	if (typeof template === "string") {
  		// ID of an element containing the template?
  		if (template[0] === "#") {
  			template = template_parser.fromId(template);
  		}

  		template = parse(template, template_parser.getParseOptions(ractive));
  	}

  	// Check that the template even exists
  	else if (template == undefined) {
  		throw new Error("The template cannot be " + template + ".");
  	}

  	// Check the parsed template has a version at all
  	else if (typeof template.v !== "number") {
  		throw new Error("The template parser was passed a non-string template, but the template doesn't have a version.  Make sure you're passing in the template you think you are.");
  	}

  	// Check we're using the correct version
  	else if (template.v !== TEMPLATE_VERSION) {
  		throw new Error("Mismatched template version (expected " + TEMPLATE_VERSION + ", got " + template.v + ") Please ensure you are using the latest version of Ractive.js in your build process as well as in your app");
  	}

  	return template;
  }

  function extendPartials(existingPartials, newPartials, overwrite) {
  	if (!newPartials) return;

  	// TODO there's an ambiguity here - we need to overwrite in the `reset()`
  	// case, but not initially...

  	for (var key in newPartials) {
  		if (overwrite || !existingPartials.hasOwnProperty(key)) {
  			existingPartials[key] = newPartials[key];
  		}
  	}
  }

  var template_template = templateConfigurator;

  var config_registries__registryNames, Registry, registries;

  config_registries__registryNames = ["adaptors", "components", "computed", "decorators", "easing", "events", "interpolators", "partials", "transitions"];

  Registry = function (name, useDefaults) {
  	this.name = name;
  	this.useDefaults = useDefaults;
  };

  Registry.prototype = {
  	constructor: Registry,

  	extend: function (Parent, proto, options) {
  		this.configure(this.useDefaults ? Parent.defaults : Parent, this.useDefaults ? proto : proto.constructor, options);
  	},

  	init: function () {},

  	configure: function (Parent, target, options) {
  		var name = this.name,
  		    option = options[name],
  		    registry;

  		registry = create(Parent[name]);

  		for (var key in option) {
  			registry[key] = option[key];
  		}

  		target[name] = registry;
  	},

  	reset: function (ractive) {
  		var registry = ractive[this.name];
  		var changed = false;
  		Object.keys(registry).forEach(function (key) {
  			var item = registry[key];
  			if (item._fn) {
  				if (item._fn.isOwner) {
  					registry[key] = item._fn;
  				} else {
  					delete registry[key];
  				}
  				changed = true;
  			}
  		});
  		return changed;
  	}
  };

  registries = config_registries__registryNames.map(function (name) {
  	return new Registry(name, name === "computed");
  });

  var config_registries = registries;

  /*this.configure(
  	this.useDefaults ? Parent.defaults : Parent,
  	ractive,
  	options );*/

  var wrapPrototype = wrap;

  function wrap(parent, name, method) {
  	if (!/_super/.test(method)) {
  		return method;
  	}

  	var wrapper = function wrapSuper() {
  		var superMethod = getSuperMethod(wrapper._parent, name),
  		    hasSuper = ("_super" in this),
  		    oldSuper = this._super,
  		    result;

  		this._super = superMethod;

  		result = method.apply(this, arguments);

  		if (hasSuper) {
  			this._super = oldSuper;
  		} else {
  			delete this._super;
  		}

  		return result;
  	};

  	wrapper._parent = parent;
  	wrapper._method = method;

  	return wrapper;
  }

  function getSuperMethod(parent, name) {
  	var value, method;

  	if (name in parent) {
  		value = parent[name];

  		if (typeof value === "function") {
  			method = value;
  		} else {
  			method = function returnValue() {
  				return value;
  			};
  		}
  	} else {
  		method = noop;
  	}

  	return method;
  }

  var config_deprecate = deprecate;
  function getMessage(deprecated, correct, isError) {
  	return "options." + deprecated + " has been deprecated in favour of options." + correct + "." + (isError ? " You cannot specify both options, please use options." + correct + "." : "");
  }

  function deprecateOption(options, deprecatedOption, correct) {
  	if (deprecatedOption in options) {
  		if (!(correct in options)) {
  			warnIfDebug(getMessage(deprecatedOption, correct));
  			options[correct] = options[deprecatedOption];
  		} else {
  			throw new Error(getMessage(deprecatedOption, correct, true));
  		}
  	}
  }
  function deprecate(options) {
  	deprecateOption(options, "beforeInit", "onconstruct");
  	deprecateOption(options, "init", "onrender");
  	deprecateOption(options, "complete", "oncomplete");
  	deprecateOption(options, "eventDefinitions", "events");

  	// Using extend with Component instead of options,
  	// like Human.extend( Spider ) means adaptors as a registry
  	// gets copied to options. So we have to check if actually an array
  	if (isArray(options.adaptors)) {
  		deprecateOption(options, "adaptors", "adapt");
  	}
  }

  var config, order, defaultKeys, custom, isBlacklisted, isStandardKey;

  custom = {
  	adapt: custom_adapt,
  	css: css_css,
  	data: custom_data,
  	template: template_template
  };

  defaultKeys = Object.keys(config_defaults);

  isStandardKey = makeObj(defaultKeys.filter(function (key) {
  	return !custom[key];
  }));

  // blacklisted keys that we don't double extend
  isBlacklisted = makeObj(defaultKeys.concat(config_registries.map(function (r) {
  	return r.name;
  })));

  order = [].concat(defaultKeys.filter(function (key) {
  	return !config_registries[key] && !custom[key];
  }), config_registries, custom.data, custom.template, custom.css);

  config = {
  	extend: function (Parent, proto, options) {
  		return configure("extend", Parent, proto, options);
  	},

  	init: function (Parent, ractive, options) {
  		return configure("init", Parent, ractive, options);
  	},

  	reset: function (ractive) {
  		return order.filter(function (c) {
  			return c.reset && c.reset(ractive);
  		}).map(function (c) {
  			return c.name;
  		});
  	},

  	// this defines the order. TODO this isn't used anywhere in the codebase,
  	// only in the test suite - should get rid of it
  	order: order };

  function configure(method, Parent, target, options) {
  	config_deprecate(options);

  	for (var key in options) {
  		if (isStandardKey.hasOwnProperty(key)) {
  			var value = options[key];

  			// warn the developer if they passed a function and ignore its value

  			// NOTE: we allow some functions on "el" because we duck type element lists
  			// and some libraries or ef'ed-up virtual browsers (phantomJS) return a
  			// function object as the result of querySelector methods
  			if (key !== "el" && typeof value === "function") {
  				warnIfDebug("" + key + " is a Ractive option that does not expect a function and will be ignored", method === "init" ? target : null);
  			} else {
  				target[key] = value;
  			}
  		}
  	}

  	config_registries.forEach(function (registry) {
  		registry[method](Parent, target, options);
  	});

  	custom_adapt[method](Parent, target, options);
  	template_template[method](Parent, target, options);
  	css_css[method](Parent, target, options);

  	extendOtherMethods(Parent.prototype, target, options);
  }

  function extendOtherMethods(parent, target, options) {
  	for (var key in options) {
  		if (!isBlacklisted[key] && options.hasOwnProperty(key)) {
  			var member = options[key];

  			// if this is a method that overwrites a method, wrap it:
  			if (typeof member === "function") {
  				member = wrapPrototype(parent, key, member);
  			}

  			target[key] = member;
  		}
  	}
  }

  function makeObj(array) {
  	var obj = {};
  	array.forEach(function (x) {
  		return obj[x] = true;
  	});
  	return obj;
  }

  var config_config = config;

  var prototype_bubble = Fragment$bubble;

  function Fragment$bubble() {
  	this.dirtyValue = this.dirtyArgs = true;

  	if (this.bound && typeof this.owner.bubble === "function") {
  		this.owner.bubble();
  	}
  }

  var Fragment_prototype_detach = Fragment$detach;

  function Fragment$detach() {
  	var docFrag;

  	if (this.items.length === 1) {
  		return this.items[0].detach();
  	}

  	docFrag = document.createDocumentFragment();

  	this.items.forEach(function (item) {
  		var node = item.detach();

  		// TODO The if {...} wasn't previously required - it is now, because we're
  		// forcibly detaching everything to reorder sections after an update. That's
  		// a non-ideal brute force approach, implemented to get all the tests to pass
  		// - as soon as it's replaced with something more elegant, this should
  		// revert to `docFrag.appendChild( item.detach() )`
  		if (node) {
  			docFrag.appendChild(node);
  		}
  	});

  	return docFrag;
  }

  var Fragment_prototype_find = Fragment$find;

  function Fragment$find(selector) {
  	var i, len, item, queryResult;

  	if (this.items) {
  		len = this.items.length;
  		for (i = 0; i < len; i += 1) {
  			item = this.items[i];

  			if (item.find && (queryResult = item.find(selector))) {
  				return queryResult;
  			}
  		}

  		return null;
  	}
  }

  var Fragment_prototype_findAll = Fragment$findAll;

  function Fragment$findAll(selector, query) {
  	var i, len, item;

  	if (this.items) {
  		len = this.items.length;
  		for (i = 0; i < len; i += 1) {
  			item = this.items[i];

  			if (item.findAll) {
  				item.findAll(selector, query);
  			}
  		}
  	}

  	return query;
  }

  var Fragment_prototype_findAllComponents = Fragment$findAllComponents;

  function Fragment$findAllComponents(selector, query) {
  	var i, len, item;

  	if (this.items) {
  		len = this.items.length;
  		for (i = 0; i < len; i += 1) {
  			item = this.items[i];

  			if (item.findAllComponents) {
  				item.findAllComponents(selector, query);
  			}
  		}
  	}

  	return query;
  }

  var Fragment_prototype_findComponent = Fragment$findComponent;

  function Fragment$findComponent(selector) {
  	var len, i, item, queryResult;

  	if (this.items) {
  		len = this.items.length;
  		for (i = 0; i < len; i += 1) {
  			item = this.items[i];

  			if (item.findComponent && (queryResult = item.findComponent(selector))) {
  				return queryResult;
  			}
  		}

  		return null;
  	}
  }

  var prototype_findNextNode = Fragment$findNextNode;

  function Fragment$findNextNode(item) {
  	var index = item.index,
  	    node;

  	if (this.items[index + 1]) {
  		node = this.items[index + 1].firstNode();
  	}

  	// if this is the root fragment, and there are no more items,
  	// it means we're at the end...
  	else if (this.owner === this.root) {
  		if (!this.owner.component) {
  			// TODO but something else could have been appended to
  			// this.root.el, no?
  			node = null;
  		}

  		// ...unless this is a component
  		else {
  			node = this.owner.component.findNextNode();
  		}
  	} else {
  		node = this.owner.findNextNode(this);
  	}

  	return node;
  }

  var prototype_firstNode = Fragment$firstNode;

  function Fragment$firstNode() {
  	if (this.items && this.items[0]) {
  		return this.items[0].firstNode();
  	}

  	return null;
  }

  var Parser,
      ParseError,
      parse_Parser__leadingWhitespace = /^\s+/;

  ParseError = function (message) {
  	this.name = "ParseError";
  	this.message = message;
  	try {
  		throw new Error(message);
  	} catch (e) {
  		this.stack = e.stack;
  	}
  };

  ParseError.prototype = Error.prototype;

  Parser = function (str, options) {
  	var items,
  	    item,
  	    lineStart = 0;

  	this.str = str;
  	this.options = options || {};
  	this.pos = 0;

  	this.lines = this.str.split("\n");
  	this.lineEnds = this.lines.map(function (line) {
  		var lineEnd = lineStart + line.length + 1; // +1 for the newline

  		lineStart = lineEnd;
  		return lineEnd;
  	}, 0);

  	// Custom init logic
  	if (this.init) this.init(str, options);

  	items = [];

  	while (this.pos < this.str.length && (item = this.read())) {
  		items.push(item);
  	}

  	this.leftover = this.remaining();
  	this.result = this.postProcess ? this.postProcess(items, options) : items;
  };

  Parser.prototype = {
  	read: function (converters) {
  		var pos, i, len, item;

  		if (!converters) converters = this.converters;

  		pos = this.pos;

  		len = converters.length;
  		for (i = 0; i < len; i += 1) {
  			this.pos = pos; // reset for each attempt

  			if (item = converters[i](this)) {
  				return item;
  			}
  		}

  		return null;
  	},

  	getLinePos: function (char) {
  		var lineNum = 0,
  		    lineStart = 0,
  		    columnNum;

  		while (char >= this.lineEnds[lineNum]) {
  			lineStart = this.lineEnds[lineNum];
  			lineNum += 1;
  		}

  		columnNum = char - lineStart;
  		return [lineNum + 1, columnNum + 1, char]; // line/col should be one-based, not zero-based!
  	},

  	error: function (message) {
  		var pos = this.getLinePos(this.pos);
  		var lineNum = pos[0];
  		var columnNum = pos[1];

  		var line = this.lines[pos[0] - 1];
  		var numTabs = 0;
  		var annotation = line.replace(/\t/g, function (match, char) {
  			if (char < pos[1]) {
  				numTabs += 1;
  			}

  			return "  ";
  		}) + "\n" + new Array(pos[1] + numTabs).join(" ") + "^----";

  		var error = new ParseError("" + message + " at line " + lineNum + " character " + columnNum + ":\n" + annotation);

  		error.line = pos[0];
  		error.character = pos[1];
  		error.shortMessage = message;

  		throw error;
  	},

  	matchString: function (string) {
  		if (this.str.substr(this.pos, string.length) === string) {
  			this.pos += string.length;
  			return string;
  		}
  	},

  	matchPattern: function (pattern) {
  		var match;

  		if (match = pattern.exec(this.remaining())) {
  			this.pos += match[0].length;
  			return match[1] || match[0];
  		}
  	},

  	allowWhitespace: function () {
  		this.matchPattern(parse_Parser__leadingWhitespace);
  	},

  	remaining: function () {
  		return this.str.substring(this.pos);
  	},

  	nextChar: function () {
  		return this.str.charAt(this.pos);
  	}
  };

  Parser.extend = function (proto) {
  	var Parent = this,
  	    Child,
  	    key;

  	Child = function (str, options) {
  		Parser.call(this, str, options);
  	};

  	Child.prototype = create(Parent.prototype);

  	for (key in proto) {
  		if (hasOwn.call(proto, key)) {
  			Child.prototype[key] = proto[key];
  		}
  	}

  	Child.extend = Parser.extend;
  	return Child;
  };

  var parse_Parser = Parser;

  var TEXT = 1;
  var INTERPOLATOR = 2;
  var TRIPLE = 3;
  var SECTION = 4;
  var INVERTED = 5;
  var CLOSING = 6;
  var ELEMENT = 7;
  var PARTIAL = 8;
  var COMMENT = 9;
  var DELIMCHANGE = 10;
  var ATTRIBUTE = 13;
  var CLOSING_TAG = 14;
  var COMPONENT = 15;
  var YIELDER = 16;
  var INLINE_PARTIAL = 17;
  var DOCTYPE = 18;

  var NUMBER_LITERAL = 20;
  var STRING_LITERAL = 21;
  var ARRAY_LITERAL = 22;
  var OBJECT_LITERAL = 23;
  var BOOLEAN_LITERAL = 24;
  var REGEXP_LITERAL = 25;

  var GLOBAL = 26;
  var KEY_VALUE_PAIR = 27;

  var REFERENCE = 30;
  var REFINEMENT = 31;
  var MEMBER = 32;
  var PREFIX_OPERATOR = 33;
  var BRACKETED = 34;
  var CONDITIONAL = 35;
  var INFIX_OPERATOR = 36;

  var INVOCATION = 40;

  var SECTION_IF = 50;
  var SECTION_UNLESS = 51;
  var SECTION_EACH = 52;
  var SECTION_WITH = 53;
  var SECTION_IF_WITH = 54;

  var ELSE = 60;
  var ELSEIF = 61;

  var stringMiddlePattern, escapeSequencePattern, lineContinuationPattern;

  // Match one or more characters until: ", ', \, or EOL/EOF.
  // EOL/EOF is written as (?!.) (meaning there's no non-newline char next).
  stringMiddlePattern = /^(?=.)[^"'\\]+?(?:(?!.)|(?=["'\\]))/;

  // Match one escape sequence, including the backslash.
  escapeSequencePattern = /^\\(?:['"\\bfnrt]|0(?![0-9])|x[0-9a-fA-F]{2}|u[0-9a-fA-F]{4}|(?=.)[^ux0-9])/;

  // Match one ES5 line continuation (backslash + line terminator).
  lineContinuationPattern = /^\\(?:\r\n|[\u000A\u000D\u2028\u2029])/;

  // Helper for defining getDoubleQuotedString and getSingleQuotedString.
  var makeQuotedStringMatcher = function (okQuote) {
  	return function (parser) {
  		var start, literal, done, next;

  		start = parser.pos;
  		literal = "\"";
  		done = false;

  		while (!done) {
  			next = parser.matchPattern(stringMiddlePattern) || parser.matchPattern(escapeSequencePattern) || parser.matchString(okQuote);
  			if (next) {
  				if (next === "\"") {
  					literal += "\\\"";
  				} else if (next === "\\'") {
  					literal += "'";
  				} else {
  					literal += next;
  				}
  			} else {
  				next = parser.matchPattern(lineContinuationPattern);
  				if (next) {
  					// convert \(newline-like) into a \u escape, which is allowed in JSON
  					literal += "\\u" + ("000" + next.charCodeAt(1).toString(16)).slice(-4);
  				} else {
  					done = true;
  				}
  			}
  		}

  		literal += "\"";

  		// use JSON.parse to interpret escapes
  		return JSON.parse(literal);
  	};
  };

  var getSingleQuotedString = makeQuotedStringMatcher("\"");
  var getDoubleQuotedString = makeQuotedStringMatcher("'");

  var readStringLiteral = function (parser) {
  	var start, string;

  	start = parser.pos;

  	if (parser.matchString("\"")) {
  		string = getDoubleQuotedString(parser);

  		if (!parser.matchString("\"")) {
  			parser.pos = start;
  			return null;
  		}

  		return {
  			t: STRING_LITERAL,
  			v: string
  		};
  	}

  	if (parser.matchString("'")) {
  		string = getSingleQuotedString(parser);

  		if (!parser.matchString("'")) {
  			parser.pos = start;
  			return null;
  		}

  		return {
  			t: STRING_LITERAL,
  			v: string
  		};
  	}

  	return null;
  };

  var literal_readNumberLiteral = readNumberLiteral;
  var literal_readNumberLiteral__numberPattern = /^(?:[+-]?)0*(?:(?:(?:[1-9]\d*)?\.\d+)|(?:(?:0|[1-9]\d*)\.)|(?:0|[1-9]\d*))(?:[eE][+-]?\d+)?/;
  function readNumberLiteral(parser) {
  	var result;

  	if (result = parser.matchPattern(literal_readNumberLiteral__numberPattern)) {
  		return {
  			t: NUMBER_LITERAL,
  			v: result
  		};
  	}

  	return null;
  }

  var patterns__name = /^[a-zA-Z_$][a-zA-Z_$0-9]*/;

  // http://mathiasbynens.be/notes/javascript-properties
  // can be any name, string literal, or number literal
  var shared_readKey = readKey;
  var identifier = /^[a-zA-Z_$][a-zA-Z_$0-9]*$/;
  function readKey(parser) {
  	var token;

  	if (token = readStringLiteral(parser)) {
  		return identifier.test(token.v) ? token.v : "\"" + token.v.replace(/"/g, "\\\"") + "\"";
  	}

  	if (token = literal_readNumberLiteral(parser)) {
  		return token.v;
  	}

  	if (token = parser.matchPattern(patterns__name)) {
  		return token;
  	}
  }

  var JsonParser, specials, specialsPattern, parseJSON__numberPattern, placeholderPattern, placeholderAtStartPattern, onlyWhitespace;

  specials = {
  	"true": true,
  	"false": false,
  	undefined: undefined,
  	"null": null
  };

  specialsPattern = new RegExp("^(?:" + Object.keys(specials).join("|") + ")");
  parseJSON__numberPattern = /^(?:[+-]?)(?:(?:(?:0|[1-9]\d*)?\.\d+)|(?:(?:0|[1-9]\d*)\.)|(?:0|[1-9]\d*))(?:[eE][+-]?\d+)?/;
  placeholderPattern = /\$\{([^\}]+)\}/g;
  placeholderAtStartPattern = /^\$\{([^\}]+)\}/;
  onlyWhitespace = /^\s*$/;

  JsonParser = parse_Parser.extend({
  	init: function (str, options) {
  		this.values = options.values;
  		this.allowWhitespace();
  	},

  	postProcess: function (result) {
  		if (result.length !== 1 || !onlyWhitespace.test(this.leftover)) {
  			return null;
  		}

  		return { value: result[0].v };
  	},

  	converters: [function getPlaceholder(parser) {
  		var placeholder;

  		if (!parser.values) {
  			return null;
  		}

  		placeholder = parser.matchPattern(placeholderAtStartPattern);

  		if (placeholder && parser.values.hasOwnProperty(placeholder)) {
  			return { v: parser.values[placeholder] };
  		}
  	}, function getSpecial(parser) {
  		var special;

  		if (special = parser.matchPattern(specialsPattern)) {
  			return { v: specials[special] };
  		}
  	}, function getNumber(parser) {
  		var number;

  		if (number = parser.matchPattern(parseJSON__numberPattern)) {
  			return { v: +number };
  		}
  	}, function getString(parser) {
  		var stringLiteral = readStringLiteral(parser),
  		    values;

  		if (stringLiteral && (values = parser.values)) {
  			return {
  				v: stringLiteral.v.replace(placeholderPattern, function (match, $1) {
  					return $1 in values ? values[$1] : $1;
  				})
  			};
  		}

  		return stringLiteral;
  	}, function getObject(parser) {
  		var result, pair;

  		if (!parser.matchString("{")) {
  			return null;
  		}

  		result = {};

  		parser.allowWhitespace();

  		if (parser.matchString("}")) {
  			return { v: result };
  		}

  		while (pair = getKeyValuePair(parser)) {
  			result[pair.key] = pair.value;

  			parser.allowWhitespace();

  			if (parser.matchString("}")) {
  				return { v: result };
  			}

  			if (!parser.matchString(",")) {
  				return null;
  			}
  		}

  		return null;
  	}, function getArray(parser) {
  		var result, valueToken;

  		if (!parser.matchString("[")) {
  			return null;
  		}

  		result = [];

  		parser.allowWhitespace();

  		if (parser.matchString("]")) {
  			return { v: result };
  		}

  		while (valueToken = parser.read()) {
  			result.push(valueToken.v);

  			parser.allowWhitespace();

  			if (parser.matchString("]")) {
  				return { v: result };
  			}

  			if (!parser.matchString(",")) {
  				return null;
  			}

  			parser.allowWhitespace();
  		}

  		return null;
  	}]
  });

  function getKeyValuePair(parser) {
  	var key, valueToken, pair;

  	parser.allowWhitespace();

  	key = shared_readKey(parser);

  	if (!key) {
  		return null;
  	}

  	pair = { key: key };

  	parser.allowWhitespace();
  	if (!parser.matchString(":")) {
  		return null;
  	}
  	parser.allowWhitespace();

  	valueToken = parser.read();
  	if (!valueToken) {
  		return null;
  	}

  	pair.value = valueToken.v;

  	return pair;
  }

  var parseJSON = function (str, values) {
  	var parser = new JsonParser(str, {
  		values: values
  	});

  	return parser.result;
  };

  var shared_processItems = processItems;

  function processItems(items, values, guid, counter) {
  	counter = counter || 0;

  	return items.map(function (item) {
  		var placeholderId, wrapped, value;

  		if (item.text) {
  			return item.text;
  		}

  		if (item.fragments) {
  			return item.fragments.map(function (fragment) {
  				return processItems(fragment.items, values, guid, counter);
  			}).join("");
  		}

  		placeholderId = guid + "-" + counter++;

  		if (item.keypath && (wrapped = item.root.viewmodel.wrapped[item.keypath.str])) {
  			value = wrapped.value;
  		} else {
  			value = item.getValue();
  		}

  		values[placeholderId] = value;

  		return "${" + placeholderId + "}";
  	}).join("");
  }

  var getArgsList = Fragment$getArgsList;
  function Fragment$getArgsList() {
  	var values, source, parsed, result;

  	if (this.dirtyArgs) {
  		source = shared_processItems(this.items, values = {}, this.root._guid);
  		parsed = parseJSON("[" + source + "]", values);

  		if (!parsed) {
  			result = [this.toString()];
  		} else {
  			result = parsed.value;
  		}

  		this.argsList = result;
  		this.dirtyArgs = false;
  	}

  	return this.argsList;
  }

  var getNode = Fragment$getNode;

  function Fragment$getNode() {
  	var fragment = this;

  	do {
  		if (fragment.pElement) {
  			return fragment.pElement.node;
  		}
  	} while (fragment = fragment.parent);

  	return this.root.detached || this.root.el;
  }

  var prototype_getValue = Fragment$getValue;
  function Fragment$getValue() {
  	var values, source, parsed, result;

  	if (this.dirtyValue) {
  		source = shared_processItems(this.items, values = {}, this.root._guid);
  		parsed = parseJSON(source, values);

  		if (!parsed) {
  			result = this.toString();
  		} else {
  			result = parsed.value;
  		}

  		this.value = result;
  		this.dirtyValue = false;
  	}

  	return this.value;
  }

  var booleanAttributes, voidElementNames, htmlEntities, controlCharacters, entityPattern, lessThan, greaterThan, amp;

  // https://github.com/kangax/html-minifier/issues/63#issuecomment-37763316
  booleanAttributes = /^(allowFullscreen|async|autofocus|autoplay|checked|compact|controls|declare|default|defaultChecked|defaultMuted|defaultSelected|defer|disabled|enabled|formNoValidate|hidden|indeterminate|inert|isMap|itemScope|loop|multiple|muted|noHref|noResize|noShade|noValidate|noWrap|open|pauseOnExit|readOnly|required|reversed|scoped|seamless|selected|sortable|translate|trueSpeed|typeMustMatch|visible)$/i;
  voidElementNames = /^(?:area|base|br|col|command|doctype|embed|hr|img|input|keygen|link|meta|param|source|track|wbr)$/i;

  htmlEntities = { quot: 34, amp: 38, apos: 39, lt: 60, gt: 62, nbsp: 160, iexcl: 161, cent: 162, pound: 163, curren: 164, yen: 165, brvbar: 166, sect: 167, uml: 168, copy: 169, ordf: 170, laquo: 171, not: 172, shy: 173, reg: 174, macr: 175, deg: 176, plusmn: 177, sup2: 178, sup3: 179, acute: 180, micro: 181, para: 182, middot: 183, cedil: 184, sup1: 185, ordm: 186, raquo: 187, frac14: 188, frac12: 189, frac34: 190, iquest: 191, Agrave: 192, Aacute: 193, Acirc: 194, Atilde: 195, Auml: 196, Aring: 197, AElig: 198, Ccedil: 199, Egrave: 200, Eacute: 201, Ecirc: 202, Euml: 203, Igrave: 204, Iacute: 205, Icirc: 206, Iuml: 207, ETH: 208, Ntilde: 209, Ograve: 210, Oacute: 211, Ocirc: 212, Otilde: 213, Ouml: 214, times: 215, Oslash: 216, Ugrave: 217, Uacute: 218, Ucirc: 219, Uuml: 220, Yacute: 221, THORN: 222, szlig: 223, agrave: 224, aacute: 225, acirc: 226, atilde: 227, auml: 228, aring: 229, aelig: 230, ccedil: 231, egrave: 232, eacute: 233, ecirc: 234, euml: 235, igrave: 236, iacute: 237, icirc: 238, iuml: 239, eth: 240, ntilde: 241, ograve: 242, oacute: 243, ocirc: 244, otilde: 245, ouml: 246, divide: 247, oslash: 248, ugrave: 249, uacute: 250, ucirc: 251, uuml: 252, yacute: 253, thorn: 254, yuml: 255, OElig: 338, oelig: 339, Scaron: 352, scaron: 353, Yuml: 376, fnof: 402, circ: 710, tilde: 732, Alpha: 913, Beta: 914, Gamma: 915, Delta: 916, Epsilon: 917, Zeta: 918, Eta: 919, Theta: 920, Iota: 921, Kappa: 922, Lambda: 923, Mu: 924, Nu: 925, Xi: 926, Omicron: 927, Pi: 928, Rho: 929, Sigma: 931, Tau: 932, Upsilon: 933, Phi: 934, Chi: 935, Psi: 936, Omega: 937, alpha: 945, beta: 946, gamma: 947, delta: 948, epsilon: 949, zeta: 950, eta: 951, theta: 952, iota: 953, kappa: 954, lambda: 955, mu: 956, nu: 957, xi: 958, omicron: 959, pi: 960, rho: 961, sigmaf: 962, sigma: 963, tau: 964, upsilon: 965, phi: 966, chi: 967, psi: 968, omega: 969, thetasym: 977, upsih: 978, piv: 982, ensp: 8194, emsp: 8195, thinsp: 8201, zwnj: 8204, zwj: 8205, lrm: 8206, rlm: 8207, ndash: 8211, mdash: 8212, lsquo: 8216, rsquo: 8217, sbquo: 8218, ldquo: 8220, rdquo: 8221, bdquo: 8222, dagger: 8224, Dagger: 8225, bull: 8226, hellip: 8230, permil: 8240, prime: 8242, Prime: 8243, lsaquo: 8249, rsaquo: 8250, oline: 8254, frasl: 8260, euro: 8364, image: 8465, weierp: 8472, real: 8476, trade: 8482, alefsym: 8501, larr: 8592, uarr: 8593, rarr: 8594, darr: 8595, harr: 8596, crarr: 8629, lArr: 8656, uArr: 8657, rArr: 8658, dArr: 8659, hArr: 8660, forall: 8704, part: 8706, exist: 8707, empty: 8709, nabla: 8711, isin: 8712, notin: 8713, ni: 8715, prod: 8719, sum: 8721, minus: 8722, lowast: 8727, radic: 8730, prop: 8733, infin: 8734, ang: 8736, and: 8743, or: 8744, cap: 8745, cup: 8746, int: 8747, there4: 8756, sim: 8764, cong: 8773, asymp: 8776, ne: 8800, equiv: 8801, le: 8804, ge: 8805, sub: 8834, sup: 8835, nsub: 8836, sube: 8838, supe: 8839, oplus: 8853, otimes: 8855, perp: 8869, sdot: 8901, lceil: 8968, rceil: 8969, lfloor: 8970, rfloor: 8971, lang: 9001, rang: 9002, loz: 9674, spades: 9824, clubs: 9827, hearts: 9829, diams: 9830 };
  controlCharacters = [8364, 129, 8218, 402, 8222, 8230, 8224, 8225, 710, 8240, 352, 8249, 338, 141, 381, 143, 144, 8216, 8217, 8220, 8221, 8226, 8211, 8212, 732, 8482, 353, 8250, 339, 157, 382, 376];
  entityPattern = new RegExp("&(#?(?:x[\\w\\d]+|\\d+|" + Object.keys(htmlEntities).join("|") + "));?", "g");

  function decodeCharacterReferences(html) {
  	return html.replace(entityPattern, function (match, entity) {
  		var code;

  		// Handle named entities
  		if (entity[0] !== "#") {
  			code = htmlEntities[entity];
  		} else if (entity[1] === "x") {
  			code = parseInt(entity.substring(2), 16);
  		} else {
  			code = parseInt(entity.substring(1), 10);
  		}

  		if (!code) {
  			return match;
  		}

  		return String.fromCharCode(validateCode(code));
  	});
  }

  // some code points are verboten. If we were inserting HTML, the browser would replace the illegal
  // code points with alternatives in some cases - since we're bypassing that mechanism, we need
  // to replace them ourselves
  //
  // Source: http://en.wikipedia.org/wiki/Character_encodings_in_HTML#Illegal_characters
  function validateCode(code) {
  	if (!code) {
  		return 65533;
  	}

  	// line feed becomes generic whitespace
  	if (code === 10) {
  		return 32;
  	}

  	// ASCII range. (Why someone would use HTML entities for ASCII characters I don't know, but...)
  	if (code < 128) {
  		return code;
  	}

  	// code points 128-159 are dealt with leniently by browsers, but they're incorrect. We need
  	// to correct the mistake or we'll end up with missing € signs and so on
  	if (code <= 159) {
  		return controlCharacters[code - 128];
  	}

  	// basic multilingual plane
  	if (code < 55296) {
  		return code;
  	}

  	// UTF-16 surrogate halves
  	if (code <= 57343) {
  		return 65533;
  	}

  	// rest of the basic multilingual plane
  	if (code <= 65535) {
  		return code;
  	}

  	return 65533;
  }

  lessThan = /</g;
  greaterThan = />/g;
  amp = /&/g;

  function escapeHtml(str) {
  	return str.replace(amp, "&amp;").replace(lessThan, "&lt;").replace(greaterThan, "&gt;");
  }

  var shared_detach = function () {
  	return detachNode(this.node);
  };

  var Text = function (options) {
  	this.type = TEXT;
  	this.text = options.template;
  };

  Text.prototype = {
  	detach: shared_detach,

  	firstNode: function () {
  		return this.node;
  	},

  	render: function () {
  		if (!this.node) {
  			this.node = document.createTextNode(this.text);
  		}

  		return this.node;
  	},

  	toString: function (escape) {
  		return escape ? escapeHtml(this.text) : this.text;
  	},

  	unrender: function (shouldDestroy) {
  		if (shouldDestroy) {
  			return this.detach();
  		}
  	}
  };

  var items_Text = Text;

  var shared_unbind = shared_unbind__unbind;

  function shared_unbind__unbind() {
  	if (this.registered) {
  		// this was registered as a dependant
  		this.root.viewmodel.unregister(this.keypath, this);
  	}

  	if (this.resolver) {
  		this.resolver.unbind();
  	}
  }

  var Mustache_getValue = Mustache$getValue;

  function Mustache$getValue() {
  	return this.value;
  }

  var ReferenceResolver = function (owner, ref, callback) {
  	var keypath;

  	this.ref = ref;
  	this.resolved = false;

  	this.root = owner.root;
  	this.parentFragment = owner.parentFragment;
  	this.callback = callback;

  	keypath = shared_resolveRef(owner.root, ref, owner.parentFragment);
  	if (keypath != undefined) {
  		this.resolve(keypath);
  	} else {
  		global_runloop.addUnresolved(this);
  	}
  };

  ReferenceResolver.prototype = {
  	resolve: function (keypath) {
  		if (this.keypath && !keypath) {
  			// it was resolved, and now it's not. Can happen if e.g. `bar` in
  			// `{{foo[bar]}}` becomes undefined
  			global_runloop.addUnresolved(this);
  		}

  		this.resolved = true;

  		this.keypath = keypath;
  		this.callback(keypath);
  	},

  	forceResolution: function () {
  		this.resolve(getKeypath(this.ref));
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		var keypath;

  		if (this.keypath != undefined) {
  			keypath = this.keypath.replace(oldKeypath, newKeypath);
  			// was a new keypath created?
  			if (keypath !== undefined) {
  				// resolve it
  				this.resolve(keypath);
  			}
  		}
  	},

  	unbind: function () {
  		if (!this.resolved) {
  			global_runloop.removeUnresolved(this);
  		}
  	}
  };

  var Resolvers_ReferenceResolver = ReferenceResolver;

  var SpecialResolver = function (owner, ref, callback) {
  	this.parentFragment = owner.parentFragment;
  	this.ref = ref;
  	this.callback = callback;

  	this.rebind();
  };

  var props = {
  	"@keypath": { prefix: "c", prop: ["context"] },
  	"@index": { prefix: "i", prop: ["index"] },
  	"@key": { prefix: "k", prop: ["key", "index"] }
  };

  function getProp(target, prop) {
  	var value;
  	for (var i = 0; i < prop.prop.length; i++) {
  		if ((value = target[prop.prop[i]]) !== undefined) {
  			return value;
  		}
  	}
  }

  SpecialResolver.prototype = {
  	rebind: function () {
  		var ref = this.ref,
  		    fragment = this.parentFragment,
  		    prop = props[ref],
  		    value;

  		if (!prop) {
  			throw new Error("Unknown special reference \"" + ref + "\" - valid references are @index, @key and @keypath");
  		}

  		// have we already found the nearest parent?
  		if (this.cached) {
  			return this.callback(getKeypath("@" + prop.prefix + getProp(this.cached, prop)));
  		}

  		// special case for indices, which may cross component boundaries
  		if (prop.prop.indexOf("index") !== -1 || prop.prop.indexOf("key") !== -1) {
  			while (fragment) {
  				if (fragment.owner.currentSubtype === SECTION_EACH && (value = getProp(fragment, prop)) !== undefined) {
  					this.cached = fragment;

  					fragment.registerIndexRef(this);

  					return this.callback(getKeypath("@" + prop.prefix + value));
  				}

  				// watch for component boundaries
  				if (!fragment.parent && fragment.owner && fragment.owner.component && fragment.owner.component.parentFragment && !fragment.owner.component.instance.isolated) {
  					fragment = fragment.owner.component.parentFragment;
  				} else {
  					fragment = fragment.parent;
  				}
  			}
  		} else {
  			while (fragment) {
  				if ((value = getProp(fragment, prop)) !== undefined) {
  					return this.callback(getKeypath("@" + prop.prefix + value.str));
  				}

  				fragment = fragment.parent;
  			}
  		}
  	},

  	unbind: function () {
  		if (this.cached) {
  			this.cached.unregisterIndexRef(this);
  		}
  	}
  };

  var Resolvers_SpecialResolver = SpecialResolver;

  var IndexResolver = function (owner, ref, callback) {
  	this.parentFragment = owner.parentFragment;
  	this.ref = ref;
  	this.callback = callback;

  	ref.ref.fragment.registerIndexRef(this);

  	this.rebind();
  };

  IndexResolver.prototype = {
  	rebind: function () {
  		var index,
  		    ref = this.ref.ref;

  		if (ref.ref.t === "k") {
  			index = "k" + ref.fragment.key;
  		} else {
  			index = "i" + ref.fragment.index;
  		}

  		if (index !== undefined) {
  			this.callback(getKeypath("@" + index));
  		}
  	},

  	unbind: function () {
  		this.ref.ref.fragment.unregisterIndexRef(this);
  	}
  };

  var Resolvers_IndexResolver = IndexResolver;

  var Resolvers_findIndexRefs = findIndexRefs;

  function findIndexRefs(fragment, refName) {
  	var result = {},
  	    refs,
  	    fragRefs,
  	    ref,
  	    i,
  	    owner,
  	    hit = false;

  	if (!refName) {
  		result.refs = refs = {};
  	}

  	while (fragment) {
  		if ((owner = fragment.owner) && (fragRefs = owner.indexRefs)) {

  			// we're looking for a particular ref, and it's here
  			if (refName && (ref = owner.getIndexRef(refName))) {
  				result.ref = {
  					fragment: fragment,
  					ref: ref
  				};
  				return result;
  			}

  			// we're collecting refs up-tree
  			else if (!refName) {
  				for (i in fragRefs) {
  					ref = fragRefs[i];

  					// don't overwrite existing refs - they should shadow parents
  					if (!refs[ref.n]) {
  						hit = true;
  						refs[ref.n] = {
  							fragment: fragment,
  							ref: ref
  						};
  					}
  				}
  			}
  		}

  		// watch for component boundaries
  		if (!fragment.parent && fragment.owner && fragment.owner.component && fragment.owner.component.parentFragment && !fragment.owner.component.instance.isolated) {
  			result.componentBoundary = true;
  			fragment = fragment.owner.component.parentFragment;
  		} else {
  			fragment = fragment.parent;
  		}
  	}

  	if (!hit) {
  		return undefined;
  	} else {
  		return result;
  	}
  }

  findIndexRefs.resolve = function resolve(indices) {
  	var refs = {},
  	    k,
  	    ref;

  	for (k in indices.refs) {
  		ref = indices.refs[k];
  		refs[ref.ref.n] = ref.ref.t === "k" ? ref.fragment.key : ref.fragment.index;
  	}

  	return refs;
  };

  var Resolvers_createReferenceResolver = createReferenceResolver;
  function createReferenceResolver(owner, ref, callback) {
  	var indexRef;

  	if (ref.charAt(0) === "@") {
  		return new Resolvers_SpecialResolver(owner, ref, callback);
  	}

  	if (indexRef = Resolvers_findIndexRefs(owner.parentFragment, ref)) {
  		return new Resolvers_IndexResolver(owner, indexRef, callback);
  	}

  	return new Resolvers_ReferenceResolver(owner, ref, callback);
  }

  var shared_getFunctionFromString = getFunctionFromString;
  var cache = {};
  function getFunctionFromString(str, i) {
  	var fn, args;

  	if (cache[str]) {
  		return cache[str];
  	}

  	args = [];
  	while (i--) {
  		args[i] = "_" + i;
  	}

  	fn = new Function(args.join(","), "return(" + str + ")");

  	cache[str] = fn;
  	return fn;
  }

  var ExpressionResolver,
      Resolvers_ExpressionResolver__bind = Function.prototype.bind;

  ExpressionResolver = function (owner, parentFragment, expression, callback) {
  	var _this = this;

  	var ractive;

  	ractive = owner.root;

  	this.root = ractive;
  	this.parentFragment = parentFragment;
  	this.callback = callback;
  	this.owner = owner;
  	this.str = expression.s;
  	this.keypaths = [];

  	// Create resolvers for each reference
  	this.pending = expression.r.length;
  	this.refResolvers = expression.r.map(function (ref, i) {
  		return Resolvers_createReferenceResolver(_this, ref, function (keypath) {
  			_this.resolve(i, keypath);
  		});
  	});

  	this.ready = true;
  	this.bubble();
  };

  ExpressionResolver.prototype = {
  	bubble: function () {
  		if (!this.ready) {
  			return;
  		}

  		this.uniqueString = getUniqueString(this.str, this.keypaths);
  		this.keypath = createExpressionKeypath(this.uniqueString);

  		this.createEvaluator();
  		this.callback(this.keypath);
  	},

  	unbind: function () {
  		var resolver;

  		while (resolver = this.refResolvers.pop()) {
  			resolver.unbind();
  		}
  	},

  	resolve: function (index, keypath) {
  		this.keypaths[index] = keypath;
  		this.bubble();
  	},

  	createEvaluator: function () {
  		var _this = this;

  		var computation, valueGetters, signature, keypath, fn;

  		keypath = this.keypath;
  		computation = this.root.viewmodel.computations[keypath.str];

  		// only if it doesn't exist yet!
  		if (!computation) {
  			fn = shared_getFunctionFromString(this.str, this.refResolvers.length);

  			valueGetters = this.keypaths.map(function (keypath) {
  				var value;

  				if (keypath === "undefined") {
  					return function () {
  						return undefined;
  					};
  				}

  				// 'special' keypaths encode a value
  				if (keypath.isSpecial) {
  					value = keypath.value;
  					return function () {
  						return value;
  					};
  				}

  				return function () {
  					var value = _this.root.viewmodel.get(keypath, { noUnwrap: true, fullRootGet: true });
  					if (typeof value === "function") {
  						value = wrapFunction(value, _this.root);
  					}
  					return value;
  				};
  			});

  			signature = {
  				deps: this.keypaths.filter(isValidDependency),
  				getter: function () {
  					var args = valueGetters.map(call);
  					return fn.apply(null, args);
  				}
  			};

  			computation = this.root.viewmodel.compute(keypath, signature);
  		} else {
  			this.root.viewmodel.mark(keypath);
  		}
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		// TODO only bubble once, no matter how many references are affected by the rebind
  		this.refResolvers.forEach(function (r) {
  			return r.rebind(oldKeypath, newKeypath);
  		});
  	}
  };

  var Resolvers_ExpressionResolver = ExpressionResolver;

  function call(value) {
  	return value.call();
  }

  function getUniqueString(str, keypaths) {
  	// get string that is unique to this expression
  	return str.replace(/_([0-9]+)/g, function (match, $1) {
  		var keypath, value;

  		// make sure we're not replacing a non-keypath _[0-9]
  		if (+$1 >= keypaths.length) {
  			return "_" + $1;
  		}

  		keypath = keypaths[$1];

  		if (keypath === undefined) {
  			return "undefined";
  		}

  		if (keypath.isSpecial) {
  			value = keypath.value;
  			return typeof value === "number" ? value : "\"" + value + "\"";
  		}

  		return keypath.str;
  	});
  }

  function createExpressionKeypath(uniqueString) {
  	// Sanitize by removing any periods or square brackets. Otherwise
  	// we can't split the keypath into keys!
  	// Remove asterisks too, since they mess with pattern observers
  	return getKeypath("${" + uniqueString.replace(/[\.\[\]]/g, "-").replace(/\*/, "#MUL#") + "}");
  }

  function isValidDependency(keypath) {
  	return keypath !== undefined && keypath[0] !== "@";
  }

  function wrapFunction(fn, ractive) {
  	var wrapped, prop, key;

  	if (fn.__ractive_nowrap) {
  		return fn;
  	}

  	prop = "__ractive_" + ractive._guid;
  	wrapped = fn[prop];

  	if (wrapped) {
  		return wrapped;
  	} else if (/this/.test(fn.toString())) {
  		defineProperty(fn, prop, {
  			value: Resolvers_ExpressionResolver__bind.call(fn, ractive),
  			configurable: true
  		});

  		// Add properties/methods to wrapped function
  		for (key in fn) {
  			if (fn.hasOwnProperty(key)) {
  				fn[prop][key] = fn[key];
  			}
  		}

  		ractive._boundFunctions.push({
  			fn: fn,
  			prop: prop
  		});

  		return fn[prop];
  	}

  	defineProperty(fn, "__ractive_nowrap", {
  		value: fn
  	});

  	return fn.__ractive_nowrap;
  }

  var MemberResolver = function (template, resolver, parentFragment) {
  	var _this = this;

  	this.resolver = resolver;
  	this.root = resolver.root;
  	this.parentFragment = parentFragment;
  	this.viewmodel = resolver.root.viewmodel;

  	if (typeof template === "string") {
  		this.value = template;
  	}

  	// Simple reference?
  	else if (template.t === REFERENCE) {
  		this.refResolver = Resolvers_createReferenceResolver(this, template.n, function (keypath) {
  			_this.resolve(keypath);
  		});
  	}

  	// Otherwise we have an expression in its own right
  	else {
  		new Resolvers_ExpressionResolver(resolver, parentFragment, template, function (keypath) {
  			_this.resolve(keypath);
  		});
  	}
  };

  MemberResolver.prototype = {
  	resolve: function (keypath) {
  		if (this.keypath) {
  			this.viewmodel.unregister(this.keypath, this);
  		}

  		this.keypath = keypath;
  		this.value = this.viewmodel.get(keypath);

  		this.bind();

  		this.resolver.bubble();
  	},

  	bind: function () {
  		this.viewmodel.register(this.keypath, this);
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		if (this.refResolver) {
  			this.refResolver.rebind(oldKeypath, newKeypath);
  		}
  	},

  	setValue: function (value) {
  		this.value = value;
  		this.resolver.bubble();
  	},

  	unbind: function () {
  		if (this.keypath) {
  			this.viewmodel.unregister(this.keypath, this);
  		}

  		if (this.refResolver) {
  			this.refResolver.unbind();
  		}
  	},

  	forceResolution: function () {
  		if (this.refResolver) {
  			this.refResolver.forceResolution();
  		}
  	}
  };

  var ReferenceExpressionResolver_MemberResolver = MemberResolver;

  var ReferenceExpressionResolver = function (mustache, template, callback) {
  	var _this = this;

  	var ractive, ref, keypath, parentFragment;

  	this.parentFragment = parentFragment = mustache.parentFragment;
  	this.root = ractive = mustache.root;
  	this.mustache = mustache;

  	this.ref = ref = template.r;
  	this.callback = callback;

  	this.unresolved = [];

  	// Find base keypath
  	if (keypath = shared_resolveRef(ractive, ref, parentFragment)) {
  		this.base = keypath;
  	} else {
  		this.baseResolver = new Resolvers_ReferenceResolver(this, ref, function (keypath) {
  			_this.base = keypath;
  			_this.baseResolver = null;
  			_this.bubble();
  		});
  	}

  	// Find values for members, or mark them as unresolved
  	this.members = template.m.map(function (template) {
  		return new ReferenceExpressionResolver_MemberResolver(template, _this, parentFragment);
  	});

  	this.ready = true;
  	this.bubble(); // trigger initial resolution if possible
  };

  ReferenceExpressionResolver.prototype = {
  	getKeypath: function () {
  		var values = this.members.map(ReferenceExpressionResolver_ReferenceExpressionResolver__getValue);

  		if (!values.every(isDefined) || this.baseResolver) {
  			return null;
  		}

  		return this.base.join(values.join("."));
  	},

  	bubble: function () {
  		if (!this.ready || this.baseResolver) {
  			return;
  		}

  		this.callback(this.getKeypath());
  	},

  	unbind: function () {
  		this.members.forEach(methodCallers__unbind);
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		var changed;

  		if (this.base) {
  			var newBase = this.base.replace(oldKeypath, newKeypath);
  			if (newBase && newBase !== this.base) {
  				this.base = newBase;
  				changed = true;
  			}
  		}

  		this.members.forEach(function (members) {
  			if (members.rebind(oldKeypath, newKeypath)) {
  				changed = true;
  			}
  		});

  		if (changed) {
  			this.bubble();
  		}
  	},

  	forceResolution: function () {
  		if (this.baseResolver) {
  			this.base = getKeypath(this.ref);

  			this.baseResolver.unbind();
  			this.baseResolver = null;
  		}

  		this.members.forEach(forceResolution);
  		this.bubble();
  	}
  };

  function ReferenceExpressionResolver_ReferenceExpressionResolver__getValue(member) {
  	return member.value;
  }

  function isDefined(value) {
  	return value != undefined;
  }

  function forceResolution(member) {
  	member.forceResolution();
  }

  var ReferenceExpressionResolver_ReferenceExpressionResolver = ReferenceExpressionResolver;

  var Mustache_initialise = Mustache$init;
  function Mustache$init(mustache, options) {

  	var ref, parentFragment, template;

  	parentFragment = options.parentFragment;
  	template = options.template;

  	mustache.root = parentFragment.root;
  	mustache.parentFragment = parentFragment;
  	mustache.pElement = parentFragment.pElement;

  	mustache.template = options.template;
  	mustache.index = options.index || 0;
  	mustache.isStatic = options.template.s;

  	mustache.type = options.template.t;

  	mustache.registered = false;

  	// if this is a simple mustache, with a reference, we just need to resolve
  	// the reference to a keypath
  	if (ref = template.r) {
  		mustache.resolver = Resolvers_createReferenceResolver(mustache, ref, resolve);
  	}

  	// if it's an expression, we have a bit more work to do
  	if (options.template.x) {
  		mustache.resolver = new Resolvers_ExpressionResolver(mustache, parentFragment, options.template.x, resolveAndRebindChildren);
  	}

  	if (options.template.rx) {
  		mustache.resolver = new ReferenceExpressionResolver_ReferenceExpressionResolver(mustache, options.template.rx, resolveAndRebindChildren);
  	}

  	// Special case - inverted sections
  	if (mustache.template.n === SECTION_UNLESS && !mustache.hasOwnProperty("value")) {
  		mustache.setValue(undefined);
  	}

  	function resolve(keypath) {
  		mustache.resolve(keypath);
  	}

  	function resolveAndRebindChildren(newKeypath) {
  		var oldKeypath = mustache.keypath;

  		if (newKeypath != oldKeypath) {
  			mustache.resolve(newKeypath);

  			if (oldKeypath !== undefined) {
  				mustache.fragments && mustache.fragments.forEach(function (f) {
  					f.rebind(oldKeypath, newKeypath);
  				});
  			}
  		}
  	}
  }

  var Mustache_resolve = Mustache$resolve;

  function Mustache$resolve(keypath) {
  	var wasResolved, value, twowayBinding;

  	// 'Special' keypaths, e.g. @foo or @7, encode a value
  	if (keypath && keypath.isSpecial) {
  		this.keypath = keypath;
  		this.setValue(keypath.value);
  		return;
  	}

  	// If we resolved previously, we need to unregister
  	if (this.registered) {
  		// undefined or null
  		this.root.viewmodel.unregister(this.keypath, this);
  		this.registered = false;

  		wasResolved = true;
  	}

  	this.keypath = keypath;

  	// If the new keypath exists, we need to register
  	// with the viewmodel
  	if (keypath != undefined) {
  		// undefined or null
  		value = this.root.viewmodel.get(keypath);
  		this.root.viewmodel.register(keypath, this);

  		this.registered = true;
  	}

  	// Either way we need to queue up a render (`value`
  	// will be `undefined` if there's no keypath)
  	this.setValue(value);

  	// Two-way bindings need to point to their new target keypath
  	if (wasResolved && (twowayBinding = this.twowayBinding)) {
  		twowayBinding.rebound();
  	}
  }

  var Mustache_rebind = Mustache$rebind;

  function Mustache$rebind(oldKeypath, newKeypath) {
  	// Children first
  	if (this.fragments) {
  		this.fragments.forEach(function (f) {
  			return f.rebind(oldKeypath, newKeypath);
  		});
  	}

  	// Expression mustache?
  	if (this.resolver) {
  		this.resolver.rebind(oldKeypath, newKeypath);
  	}
  }

  var Mustache = {
  	getValue: Mustache_getValue,
  	init: Mustache_initialise,
  	resolve: Mustache_resolve,
  	rebind: Mustache_rebind
  };

  var Interpolator = function (options) {
  	this.type = INTERPOLATOR;
  	Mustache.init(this, options);
  };

  Interpolator.prototype = {
  	update: function () {
  		this.node.data = this.value == undefined ? "" : this.value;
  	},
  	resolve: Mustache.resolve,
  	rebind: Mustache.rebind,
  	detach: shared_detach,

  	unbind: shared_unbind,

  	render: function () {
  		if (!this.node) {
  			this.node = document.createTextNode(safeToStringValue(this.value));
  		}

  		return this.node;
  	},

  	unrender: function (shouldDestroy) {
  		if (shouldDestroy) {
  			detachNode(this.node);
  		}
  	},

  	getValue: Mustache.getValue,

  	// TEMP
  	setValue: function (value) {
  		var wrapper;

  		// TODO is there a better way to approach this?
  		if (this.keypath && (wrapper = this.root.viewmodel.wrapped[this.keypath.str])) {
  			value = wrapper.get();
  		}

  		if (!isEqual(value, this.value)) {
  			this.value = value;
  			this.parentFragment.bubble();

  			if (this.node) {
  				global_runloop.addView(this);
  			}
  		}
  	},

  	firstNode: function () {
  		return this.node;
  	},

  	toString: function (escape) {
  		var string = "" + safeToStringValue(this.value);
  		return escape ? escapeHtml(string) : string;
  	}
  };

  var items_Interpolator = Interpolator;

  var Section_prototype_bubble = Section$bubble;

  function Section$bubble() {
  	this.parentFragment.bubble();
  }

  var Section_prototype_detach = Section$detach;

  function Section$detach() {
  	var docFrag;

  	if (this.fragments.length === 1) {
  		return this.fragments[0].detach();
  	}

  	docFrag = document.createDocumentFragment();

  	this.fragments.forEach(function (item) {
  		docFrag.appendChild(item.detach());
  	});

  	return docFrag;
  }

  var find = Section$find;

  function Section$find(selector) {
  	var i, len, queryResult;

  	len = this.fragments.length;
  	for (i = 0; i < len; i += 1) {
  		if (queryResult = this.fragments[i].find(selector)) {
  			return queryResult;
  		}
  	}

  	return null;
  }

  var findAll = Section$findAll;

  function Section$findAll(selector, query) {
  	var i, len;

  	len = this.fragments.length;
  	for (i = 0; i < len; i += 1) {
  		this.fragments[i].findAll(selector, query);
  	}
  }

  var findAllComponents = Section$findAllComponents;

  function Section$findAllComponents(selector, query) {
  	var i, len;

  	len = this.fragments.length;
  	for (i = 0; i < len; i += 1) {
  		this.fragments[i].findAllComponents(selector, query);
  	}
  }

  var findComponent = Section$findComponent;

  function Section$findComponent(selector) {
  	var i, len, queryResult;

  	len = this.fragments.length;
  	for (i = 0; i < len; i += 1) {
  		if (queryResult = this.fragments[i].findComponent(selector)) {
  			return queryResult;
  		}
  	}

  	return null;
  }

  var findNextNode = Section$findNextNode;

  function Section$findNextNode(fragment) {
  	if (this.fragments[fragment.index + 1]) {
  		return this.fragments[fragment.index + 1].firstNode();
  	}

  	return this.parentFragment.findNextNode(this);
  }

  var firstNode = Section$firstNode;

  function Section$firstNode() {
  	var len, i, node;

  	if (len = this.fragments.length) {
  		for (i = 0; i < len; i += 1) {
  			if (node = this.fragments[i].firstNode()) {
  				return node;
  			}
  		}
  	}

  	return this.parentFragment.findNextNode(this);
  }

  var shuffle = Section$shuffle;

  function Section$shuffle(newIndices) {
  	var _this = this;

  	var parentFragment, firstChange, i, newLength, reboundFragments, fragmentOptions, fragment;

  	// short circuit any double-updates, and ensure that this isn't applied to
  	// non-list sections
  	if (this.shuffling || this.unbound || this.currentSubtype !== SECTION_EACH) {
  		return;
  	}

  	this.shuffling = true;
  	global_runloop.scheduleTask(function () {
  		return _this.shuffling = false;
  	});

  	parentFragment = this.parentFragment;

  	reboundFragments = [];

  	// TODO: need to update this
  	// first, rebind existing fragments
  	newIndices.forEach(function (newIndex, oldIndex) {
  		var fragment, by, oldKeypath, newKeypath, deps;

  		if (newIndex === oldIndex) {
  			reboundFragments[newIndex] = _this.fragments[oldIndex];
  			return;
  		}

  		fragment = _this.fragments[oldIndex];

  		if (firstChange === undefined) {
  			firstChange = oldIndex;
  		}

  		// does this fragment need to be torn down?
  		if (newIndex === -1) {
  			_this.fragmentsToUnrender.push(fragment);
  			fragment.unbind();
  			return;
  		}

  		// Otherwise, it needs to be rebound to a new index
  		by = newIndex - oldIndex;
  		oldKeypath = _this.keypath.join(oldIndex);
  		newKeypath = _this.keypath.join(newIndex);

  		fragment.index = newIndex;

  		// notify any registered index refs directly
  		if (deps = fragment.registeredIndexRefs) {
  			deps.forEach(shuffle__blindRebind);
  		}

  		fragment.rebind(oldKeypath, newKeypath);
  		reboundFragments[newIndex] = fragment;
  	});

  	newLength = this.root.viewmodel.get(this.keypath).length;

  	// If nothing changed with the existing fragments, then we start adding
  	// new fragments at the end...
  	if (firstChange === undefined) {
  		// ...unless there are no new fragments to add
  		if (this.length === newLength) {
  			return;
  		}

  		firstChange = this.length;
  	}

  	this.length = this.fragments.length = newLength;

  	if (this.rendered) {
  		global_runloop.addView(this);
  	}

  	// Prepare new fragment options
  	fragmentOptions = {
  		template: this.template.f,
  		root: this.root,
  		owner: this
  	};

  	// Add as many new fragments as we need to, or add back existing
  	// (detached) fragments
  	for (i = firstChange; i < newLength; i += 1) {
  		fragment = reboundFragments[i];

  		if (!fragment) {
  			this.fragmentsToCreate.push(i);
  		}

  		this.fragments[i] = fragment;
  	}
  }

  function shuffle__blindRebind(dep) {
  	// the keypath doesn't actually matter here as it won't have changed
  	dep.rebind("", "");
  }

  var prototype_rebind = function (oldKeypath, newKeypath) {
  	Mustache.rebind.call(this, oldKeypath, newKeypath);
  };

  var Section_prototype_render = Section$render;

  function Section$render() {
  	var _this = this;

  	this.docFrag = document.createDocumentFragment();

  	this.fragments.forEach(function (f) {
  		return _this.docFrag.appendChild(f.render());
  	});

  	this.renderedFragments = this.fragments.slice();
  	this.fragmentsToRender = [];

  	this.rendered = true;
  	return this.docFrag;
  }

  var setValue = Section$setValue;

  function Section$setValue(value) {
  	var _this = this;

  	var wrapper, fragmentOptions;

  	if (this.updating) {
  		// If a child of this section causes a re-evaluation - for example, an
  		// expression refers to a function that mutates the array that this
  		// section depends on - we'll end up with a double rendering bug (see
  		// https://github.com/ractivejs/ractive/issues/748). This prevents it.
  		return;
  	}

  	this.updating = true;

  	// with sections, we need to get the fake value if we have a wrapped object
  	if (this.keypath && (wrapper = this.root.viewmodel.wrapped[this.keypath.str])) {
  		value = wrapper.get();
  	}

  	// If any fragments are awaiting creation after a splice,
  	// this is the place to do it
  	if (this.fragmentsToCreate.length) {
  		fragmentOptions = {
  			template: this.template.f || [],
  			root: this.root,
  			pElement: this.pElement,
  			owner: this
  		};

  		this.fragmentsToCreate.forEach(function (index) {
  			var fragment;

  			fragmentOptions.context = _this.keypath.join(index);
  			fragmentOptions.index = index;

  			fragment = new virtualdom_Fragment(fragmentOptions);
  			_this.fragmentsToRender.push(_this.fragments[index] = fragment);
  		});

  		this.fragmentsToCreate.length = 0;
  	} else if (reevaluateSection(this, value)) {
  		this.bubble();

  		if (this.rendered) {
  			global_runloop.addView(this);
  		}
  	}

  	this.value = value;
  	this.updating = false;
  }

  function changeCurrentSubtype(section, value, obj) {
  	if (value === SECTION_EACH) {
  		// make sure ref type is up to date for key or value indices
  		if (section.indexRefs && section.indexRefs[0]) {
  			var ref = section.indexRefs[0];

  			// when switching flavors, make sure the section gets updated
  			if (obj && ref.t === "i" || !obj && ref.t === "k") {
  				// if switching from object to list, unbind all of the old fragments
  				if (!obj) {
  					section.length = 0;
  					section.fragmentsToUnrender = section.fragments.slice(0);
  					section.fragmentsToUnrender.forEach(function (f) {
  						return f.unbind();
  					});
  				}
  			}

  			ref.t = obj ? "k" : "i";
  		}
  	}

  	section.currentSubtype = value;
  }

  function reevaluateSection(section, value) {
  	var fragmentOptions = {
  		template: section.template.f || [],
  		root: section.root,
  		pElement: section.parentFragment.pElement,
  		owner: section
  	};

  	section.hasContext = true;

  	// If we already know the section type, great
  	// TODO can this be optimised? i.e. pick an reevaluateSection function during init
  	// and avoid doing this each time?
  	if (section.subtype) {
  		switch (section.subtype) {
  			case SECTION_IF:
  				section.hasContext = false;
  				return reevaluateConditionalSection(section, value, false, fragmentOptions);

  			case SECTION_UNLESS:
  				section.hasContext = false;
  				return reevaluateConditionalSection(section, value, true, fragmentOptions);

  			case SECTION_WITH:
  				return reevaluateContextSection(section, fragmentOptions);

  			case SECTION_IF_WITH:
  				return reevaluateConditionalContextSection(section, value, fragmentOptions);

  			case SECTION_EACH:
  				if (isObject(value)) {
  					changeCurrentSubtype(section, section.subtype, true);
  					return reevaluateListObjectSection(section, value, fragmentOptions);
  				}

  				// Fallthrough - if it's a conditional or an array we need to continue
  		}
  	}

  	// Otherwise we need to work out what sort of section we're dealing with
  	section.ordered = !!isArrayLike(value);

  	// Ordered list section
  	if (section.ordered) {
  		changeCurrentSubtype(section, SECTION_EACH, false);
  		return reevaluateListSection(section, value, fragmentOptions);
  	}

  	// Unordered list, or context
  	if (isObject(value) || typeof value === "function") {
  		// Index reference indicates section should be treated as a list
  		if (section.template.i) {
  			changeCurrentSubtype(section, SECTION_EACH, true);
  			return reevaluateListObjectSection(section, value, fragmentOptions);
  		}

  		// Otherwise, object provides context for contents
  		changeCurrentSubtype(section, SECTION_WITH, false);
  		return reevaluateContextSection(section, fragmentOptions);
  	}

  	// Conditional section
  	changeCurrentSubtype(section, SECTION_IF, false);
  	section.hasContext = false;
  	return reevaluateConditionalSection(section, value, false, fragmentOptions);
  }

  function reevaluateListSection(section, value, fragmentOptions) {
  	var i, length, fragment;

  	length = value.length;

  	if (length === section.length) {
  		// Nothing to do
  		return false;
  	}

  	// if the array is shorter than it was previously, remove items
  	if (length < section.length) {
  		section.fragmentsToUnrender = section.fragments.splice(length, section.length - length);
  		section.fragmentsToUnrender.forEach(methodCallers__unbind);
  	}

  	// otherwise...
  	else {
  		if (length > section.length) {
  			// add any new ones
  			for (i = section.length; i < length; i += 1) {
  				// append list item to context stack
  				fragmentOptions.context = section.keypath.join(i);
  				fragmentOptions.index = i;

  				fragment = new virtualdom_Fragment(fragmentOptions);
  				section.fragmentsToRender.push(section.fragments[i] = fragment);
  			}
  		}
  	}

  	section.length = length;
  	return true;
  }

  function reevaluateListObjectSection(section, value, fragmentOptions) {
  	var id, i, hasKey, fragment, changed, deps;

  	hasKey = section.hasKey || (section.hasKey = {});

  	// remove any fragments that should no longer exist
  	i = section.fragments.length;
  	while (i--) {
  		fragment = section.fragments[i];

  		if (!(fragment.key in value)) {
  			changed = true;

  			fragment.unbind();
  			section.fragmentsToUnrender.push(fragment);
  			section.fragments.splice(i, 1);

  			hasKey[fragment.key] = false;
  		}
  	}

  	// notify any dependents about changed indices
  	i = section.fragments.length;
  	while (i--) {
  		fragment = section.fragments[i];

  		if (fragment.index !== i) {
  			fragment.index = i;
  			if (deps = fragment.registeredIndexRefs) {
  				deps.forEach(setValue__blindRebind);
  			}
  		}
  	}

  	// add any that haven't been created yet
  	i = section.fragments.length;
  	for (id in value) {
  		if (!hasKey[id]) {
  			changed = true;

  			fragmentOptions.context = section.keypath.join(id);
  			fragmentOptions.key = id;
  			fragmentOptions.index = i++;

  			fragment = new virtualdom_Fragment(fragmentOptions);

  			section.fragmentsToRender.push(fragment);
  			section.fragments.push(fragment);
  			hasKey[id] = true;
  		}
  	}

  	section.length = section.fragments.length;
  	return changed;
  }

  function reevaluateConditionalContextSection(section, value, fragmentOptions) {
  	if (value) {
  		return reevaluateContextSection(section, fragmentOptions);
  	} else {
  		return removeSectionFragments(section);
  	}
  }

  function reevaluateContextSection(section, fragmentOptions) {
  	var fragment;

  	// ...then if it isn't rendered, render it, adding section.keypath to the context stack
  	// (if it is already rendered, then any children dependent on the context stack
  	// will update themselves without any prompting)
  	if (!section.length) {
  		// append this section to the context stack
  		fragmentOptions.context = section.keypath;
  		fragmentOptions.index = 0;

  		fragment = new virtualdom_Fragment(fragmentOptions);

  		section.fragmentsToRender.push(section.fragments[0] = fragment);
  		section.length = 1;

  		return true;
  	}
  }

  function reevaluateConditionalSection(section, value, inverted, fragmentOptions) {
  	var doRender, emptyArray, emptyObject, fragment, name;

  	emptyArray = isArrayLike(value) && value.length === 0;
  	emptyObject = false;
  	if (!isArrayLike(value) && isObject(value)) {
  		emptyObject = true;
  		for (name in value) {
  			emptyObject = false;
  			break;
  		}
  	}

  	if (inverted) {
  		doRender = emptyArray || emptyObject || !value;
  	} else {
  		doRender = value && !emptyArray && !emptyObject;
  	}

  	if (doRender) {
  		if (!section.length) {
  			// no change to context stack
  			fragmentOptions.index = 0;

  			fragment = new virtualdom_Fragment(fragmentOptions);
  			section.fragmentsToRender.push(section.fragments[0] = fragment);
  			section.length = 1;

  			return true;
  		}

  		if (section.length > 1) {
  			section.fragmentsToUnrender = section.fragments.splice(1);
  			section.fragmentsToUnrender.forEach(methodCallers__unbind);

  			return true;
  		}
  	} else {
  		return removeSectionFragments(section);
  	}
  }

  function removeSectionFragments(section) {
  	if (section.length) {
  		section.fragmentsToUnrender = section.fragments.splice(0, section.fragments.length).filter(isRendered);
  		section.fragmentsToUnrender.forEach(methodCallers__unbind);
  		section.length = section.fragmentsToRender.length = 0;
  		return true;
  	}
  }

  function isRendered(fragment) {
  	return fragment.rendered;
  }

  function setValue__blindRebind(dep) {
  	// the keypath doesn't actually matter here as it won't have changed
  	dep.rebind("", "");
  }

  var prototype_toString = Section$toString;

  function Section$toString(escape) {
  	var str, i, len;

  	str = "";

  	i = 0;
  	len = this.length;

  	for (i = 0; i < len; i += 1) {
  		str += this.fragments[i].toString(escape);
  	}

  	return str;
  }

  var prototype_unbind = Section$unbind;
  function Section$unbind() {
  	var _this = this;

  	this.fragments.forEach(methodCallers__unbind);
  	this.fragmentsToRender.forEach(function (f) {
  		return removeFromArray(_this.fragments, f);
  	});
  	this.fragmentsToRender = [];
  	shared_unbind.call(this);

  	this.length = 0;
  	this.unbound = true;
  }

  var prototype_unrender = Section$unrender;

  function Section$unrender(shouldDestroy) {
  	this.fragments.forEach(shouldDestroy ? unrenderAndDestroy : prototype_unrender__unrender);
  	this.renderedFragments = [];
  	this.rendered = false;
  }

  function unrenderAndDestroy(fragment) {
  	fragment.unrender(true);
  }

  function prototype_unrender__unrender(fragment) {
  	fragment.unrender(false);
  }

  var prototype_update = Section$update;

  function Section$update() {
  	var fragment, renderIndex, renderedFragments, anchor, target, i, len;

  	// `this.renderedFragments` is in the order of the previous render.
  	// If fragments have shuffled about, this allows us to quickly
  	// reinsert them in the correct place
  	renderedFragments = this.renderedFragments;

  	// Remove fragments that have been marked for destruction
  	while (fragment = this.fragmentsToUnrender.pop()) {
  		fragment.unrender(true);
  		renderedFragments.splice(renderedFragments.indexOf(fragment), 1);
  	}

  	// Render new fragments (but don't insert them yet)
  	while (fragment = this.fragmentsToRender.shift()) {
  		fragment.render();
  	}

  	if (this.rendered) {
  		target = this.parentFragment.getNode();
  	}

  	len = this.fragments.length;
  	for (i = 0; i < len; i += 1) {
  		fragment = this.fragments[i];
  		renderIndex = renderedFragments.indexOf(fragment, i); // search from current index - it's guaranteed to be the same or higher

  		if (renderIndex === i) {
  			// already in the right place. insert accumulated nodes (if any) and carry on
  			if (this.docFrag.childNodes.length) {
  				anchor = fragment.firstNode();
  				target.insertBefore(this.docFrag, anchor);
  			}

  			continue;
  		}

  		this.docFrag.appendChild(fragment.detach());

  		// update renderedFragments
  		if (renderIndex !== -1) {
  			renderedFragments.splice(renderIndex, 1);
  		}
  		renderedFragments.splice(i, 0, fragment);
  	}

  	if (this.rendered && this.docFrag.childNodes.length) {
  		anchor = this.parentFragment.findNextNode(this);
  		target.insertBefore(this.docFrag, anchor);
  	}

  	// Save the rendering order for next time
  	this.renderedFragments = this.fragments.slice();
  }

  var Section = function (options) {
  	this.type = SECTION;
  	this.subtype = this.currentSubtype = options.template.n;
  	this.inverted = this.subtype === SECTION_UNLESS;

  	this.pElement = options.pElement;

  	this.fragments = [];
  	this.fragmentsToCreate = [];
  	this.fragmentsToRender = [];
  	this.fragmentsToUnrender = [];

  	if (options.template.i) {
  		this.indexRefs = options.template.i.split(",").map(function (k, i) {
  			return { n: k, t: i === 0 ? "k" : "i" };
  		});
  	}

  	this.renderedFragments = [];

  	this.length = 0; // number of times this section is rendered

  	Mustache.init(this, options);
  };

  Section.prototype = {
  	bubble: Section_prototype_bubble,
  	detach: Section_prototype_detach,
  	find: find,
  	findAll: findAll,
  	findAllComponents: findAllComponents,
  	findComponent: findComponent,
  	findNextNode: findNextNode,
  	firstNode: firstNode,
  	getIndexRef: function (name) {
  		if (this.indexRefs) {
  			var i = this.indexRefs.length;
  			while (i--) {
  				var ref = this.indexRefs[i];
  				if (ref.n === name) {
  					return ref;
  				}
  			}
  		}
  	},
  	getValue: Mustache.getValue,
  	shuffle: shuffle,
  	rebind: prototype_rebind,
  	render: Section_prototype_render,
  	resolve: Mustache.resolve,
  	setValue: setValue,
  	toString: prototype_toString,
  	unbind: prototype_unbind,
  	unrender: prototype_unrender,
  	update: prototype_update
  };

  var _Section = Section;

  var Triple_prototype_detach = Triple$detach;

  function Triple$detach() {
  	var len, i;

  	if (this.docFrag) {
  		len = this.nodes.length;
  		for (i = 0; i < len; i += 1) {
  			this.docFrag.appendChild(this.nodes[i]);
  		}

  		return this.docFrag;
  	}
  }

  var Triple_prototype_find = Triple$find;
  function Triple$find(selector) {
  	var i, len, node, queryResult;

  	len = this.nodes.length;
  	for (i = 0; i < len; i += 1) {
  		node = this.nodes[i];

  		if (node.nodeType !== 1) {
  			continue;
  		}

  		if (matches(node, selector)) {
  			return node;
  		}

  		if (queryResult = node.querySelector(selector)) {
  			return queryResult;
  		}
  	}

  	return null;
  }

  var Triple_prototype_findAll = Triple$findAll;
  function Triple$findAll(selector, queryResult) {
  	var i, len, node, queryAllResult, numNodes, j;

  	len = this.nodes.length;
  	for (i = 0; i < len; i += 1) {
  		node = this.nodes[i];

  		if (node.nodeType !== 1) {
  			continue;
  		}

  		if (matches(node, selector)) {
  			queryResult.push(node);
  		}

  		if (queryAllResult = node.querySelectorAll(selector)) {
  			numNodes = queryAllResult.length;
  			for (j = 0; j < numNodes; j += 1) {
  				queryResult.push(queryAllResult[j]);
  			}
  		}
  	}
  }

  var Triple_prototype_firstNode = Triple$firstNode;

  function Triple$firstNode() {
  	if (this.rendered && this.nodes[0]) {
  		return this.nodes[0];
  	}

  	return this.parentFragment.findNextNode(this);
  }

  var elementCache = {},
      ieBug,
      ieBlacklist;

  try {
  	createElement("table").innerHTML = "foo";
  } catch (err) {
  	ieBug = true;

  	ieBlacklist = {
  		TABLE: ["<table class=\"x\">", "</table>"],
  		THEAD: ["<table><thead class=\"x\">", "</thead></table>"],
  		TBODY: ["<table><tbody class=\"x\">", "</tbody></table>"],
  		TR: ["<table><tr class=\"x\">", "</tr></table>"],
  		SELECT: ["<select class=\"x\">", "</select>"]
  	};
  }

  var insertHtml = function (html, node, docFrag) {
  	var container,
  	    nodes = [],
  	    wrapper,
  	    selectedOption,
  	    child,
  	    i;

  	// render 0 and false
  	if (html != null && html !== "") {
  		if (ieBug && (wrapper = ieBlacklist[node.tagName])) {
  			container = element("DIV");
  			container.innerHTML = wrapper[0] + html + wrapper[1];
  			container = container.querySelector(".x");

  			if (container.tagName === "SELECT") {
  				selectedOption = container.options[container.selectedIndex];
  			}
  		} else if (node.namespaceURI === namespaces.svg) {
  			container = element("DIV");
  			container.innerHTML = "<svg class=\"x\">" + html + "</svg>";
  			container = container.querySelector(".x");
  		} else {
  			container = element(node.tagName);
  			container.innerHTML = html;

  			if (container.tagName === "SELECT") {
  				selectedOption = container.options[container.selectedIndex];
  			}
  		}

  		while (child = container.firstChild) {
  			nodes.push(child);
  			docFrag.appendChild(child);
  		}

  		// This is really annoying. Extracting <option> nodes from the
  		// temporary container <select> causes the remaining ones to
  		// become selected. So now we have to deselect them. IE8, you
  		// amaze me. You really do
  		// ...and now Chrome too
  		if (node.tagName === "SELECT") {
  			i = nodes.length;
  			while (i--) {
  				if (nodes[i] !== selectedOption) {
  					nodes[i].selected = false;
  				}
  			}
  		}
  	}

  	return nodes;
  };

  function element(tagName) {
  	return elementCache[tagName] || (elementCache[tagName] = createElement(tagName));
  }

  var helpers_updateSelect = updateSelect;

  function updateSelect(parentElement) {
  	var selectedOptions, option, value;

  	if (!parentElement || parentElement.name !== "select" || !parentElement.binding) {
  		return;
  	}

  	selectedOptions = toArray(parentElement.node.options).filter(isSelected);

  	// If one of them had a `selected` attribute, we need to sync
  	// the model to the view
  	if (parentElement.getAttribute("multiple")) {
  		value = selectedOptions.map(function (o) {
  			return o.value;
  		});
  	} else if (option = selectedOptions[0]) {
  		value = option.value;
  	}

  	if (value !== undefined) {
  		parentElement.binding.setValue(value);
  	}

  	parentElement.bubble();
  }

  function isSelected(option) {
  	return option.selected;
  }

  var Triple_prototype_render = Triple$render;
  function Triple$render() {
  	if (this.rendered) {
  		throw new Error("Attempted to render an item that was already rendered");
  	}

  	this.docFrag = document.createDocumentFragment();
  	this.nodes = insertHtml(this.value, this.parentFragment.getNode(), this.docFrag);

  	// Special case - we're inserting the contents of a <select>
  	helpers_updateSelect(this.pElement);

  	this.rendered = true;
  	return this.docFrag;
  }

  var prototype_setValue = Triple$setValue;
  function Triple$setValue(value) {
  	var wrapper;

  	// TODO is there a better way to approach this?
  	if (wrapper = this.root.viewmodel.wrapped[this.keypath.str]) {
  		value = wrapper.get();
  	}

  	if (value !== this.value) {
  		this.value = value;
  		this.parentFragment.bubble();

  		if (this.rendered) {
  			global_runloop.addView(this);
  		}
  	}
  }

  var Triple_prototype_toString = Triple$toString;
  function Triple$toString() {
  	return this.value != undefined ? decodeCharacterReferences("" + this.value) : "";
  }

  var Triple_prototype_unrender = Triple$unrender;
  function Triple$unrender(shouldDestroy) {
  	if (this.rendered && shouldDestroy) {
  		this.nodes.forEach(detachNode);
  		this.rendered = false;
  	}

  	// TODO update live queries
  }

  var Triple_prototype_update = Triple$update;
  function Triple$update() {
  	var node, parentNode;

  	if (!this.rendered) {
  		return;
  	}

  	// Remove existing nodes
  	while (this.nodes && this.nodes.length) {
  		node = this.nodes.pop();
  		node.parentNode.removeChild(node);
  	}

  	// Insert new nodes
  	parentNode = this.parentFragment.getNode();

  	this.nodes = insertHtml(this.value, parentNode, this.docFrag);
  	parentNode.insertBefore(this.docFrag, this.parentFragment.findNextNode(this));

  	// Special case - we're inserting the contents of a <select>
  	helpers_updateSelect(this.pElement);
  }

  var Triple = function (options) {
  	this.type = TRIPLE;
  	Mustache.init(this, options);
  };

  Triple.prototype = {
  	detach: Triple_prototype_detach,
  	find: Triple_prototype_find,
  	findAll: Triple_prototype_findAll,
  	firstNode: Triple_prototype_firstNode,
  	getValue: Mustache.getValue,
  	rebind: Mustache.rebind,
  	render: Triple_prototype_render,
  	resolve: Mustache.resolve,
  	setValue: prototype_setValue,
  	toString: Triple_prototype_toString,
  	unbind: shared_unbind,
  	unrender: Triple_prototype_unrender,
  	update: Triple_prototype_update
  };

  var _Triple = Triple;

  var Element_prototype_bubble = function () {
  	this.parentFragment.bubble();
  };

  var Element_prototype_detach = Element$detach;

  function Element$detach() {
  	var node = this.node,
  	    parentNode;

  	if (node) {
  		// need to check for parent node - DOM may have been altered
  		// by something other than Ractive! e.g. jQuery UI...
  		if (parentNode = node.parentNode) {
  			parentNode.removeChild(node);
  		}

  		return node;
  	}
  }

  var Element_prototype_find = function (selector) {
  	if (!this.node) {
  		// this element hasn't been rendered yet
  		return null;
  	}

  	if (matches(this.node, selector)) {
  		return this.node;
  	}

  	if (this.fragment && this.fragment.find) {
  		return this.fragment.find(selector);
  	}
  };

  var Element_prototype_findAll = function (selector, query) {
  	// Add this node to the query, if applicable, and register the
  	// query on this element
  	if (query._test(this, true) && query.live) {
  		(this.liveQueries || (this.liveQueries = [])).push(query);
  	}

  	if (this.fragment) {
  		this.fragment.findAll(selector, query);
  	}
  };

  var Element_prototype_findAllComponents = function (selector, query) {
  	if (this.fragment) {
  		this.fragment.findAllComponents(selector, query);
  	}
  };

  var Element_prototype_findComponent = function (selector) {
  	if (this.fragment) {
  		return this.fragment.findComponent(selector);
  	}
  };

  var Element_prototype_findNextNode = Element$findNextNode;

  function Element$findNextNode() {
  	return null;
  }

  var Element_prototype_firstNode = Element$firstNode;

  function Element$firstNode() {
  	return this.node;
  }

  var getAttribute = Element$getAttribute;

  function Element$getAttribute(name) {
  	if (!this.attributes || !this.attributes[name]) {
  		return;
  	}

  	return this.attributes[name].value;
  }

  var truthy = /^true|on|yes|1$/i;
  var processBindingAttributes__isNumeric = /^[0-9]+$/;

  var processBindingAttributes = function (element, template) {
  	var val, attrs, attributes;

  	attributes = template.a || {};
  	attrs = {};

  	// attributes that are present but don't have a value (=)
  	// will be set to the number 0, which we condider to be true
  	// the string '0', however is false

  	val = attributes.twoway;
  	if (val !== undefined) {
  		attrs.twoway = val === 0 || truthy.test(val);
  	}

  	val = attributes.lazy;
  	if (val !== undefined) {
  		// check for timeout value
  		if (val !== 0 && processBindingAttributes__isNumeric.test(val)) {
  			attrs.lazy = parseInt(val);
  		} else {
  			attrs.lazy = val === 0 || truthy.test(val);
  		}
  	}

  	return attrs;
  };

  var Attribute_prototype_bubble = Attribute$bubble;
  function Attribute$bubble() {
  	var value = this.useProperty || !this.rendered ? this.fragment.getValue() : this.fragment.toString();

  	// TODO this can register the attribute multiple times (see render test
  	// 'Attribute with nested mustaches')
  	if (!isEqual(value, this.value)) {

  		// Need to clear old id from ractive.nodes
  		if (this.name === "id" && this.value) {
  			delete this.root.nodes[this.value];
  		}

  		this.value = value;

  		if (this.name === "value" && this.node) {
  			// We need to store the value on the DOM like this so we
  			// can retrieve it later without it being coerced to a string
  			this.node._ractive.value = value;
  		}

  		if (this.rendered) {
  			global_runloop.addView(this);
  		}
  	}
  }

  var svgCamelCaseElements, svgCamelCaseAttributes, createMap, map;
  svgCamelCaseElements = "altGlyph altGlyphDef altGlyphItem animateColor animateMotion animateTransform clipPath feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting feSpotLight feTile feTurbulence foreignObject glyphRef linearGradient radialGradient textPath vkern".split(" ");
  svgCamelCaseAttributes = "attributeName attributeType baseFrequency baseProfile calcMode clipPathUnits contentScriptType contentStyleType diffuseConstant edgeMode externalResourcesRequired filterRes filterUnits glyphRef gradientTransform gradientUnits kernelMatrix kernelUnitLength keyPoints keySplines keyTimes lengthAdjust limitingConeAngle markerHeight markerUnits markerWidth maskContentUnits maskUnits numOctaves pathLength patternContentUnits patternTransform patternUnits pointsAtX pointsAtY pointsAtZ preserveAlpha preserveAspectRatio primitiveUnits refX refY repeatCount repeatDur requiredExtensions requiredFeatures specularConstant specularExponent spreadMethod startOffset stdDeviation stitchTiles surfaceScale systemLanguage tableValues targetX targetY textLength viewBox viewTarget xChannelSelector yChannelSelector zoomAndPan".split(" ");

  createMap = function (items) {
  	var map = {},
  	    i = items.length;
  	while (i--) {
  		map[items[i].toLowerCase()] = items[i];
  	}
  	return map;
  };

  map = createMap(svgCamelCaseElements.concat(svgCamelCaseAttributes));

  var enforceCase = function (elementName) {
  	var lowerCaseElementName = elementName.toLowerCase();
  	return map[lowerCaseElementName] || lowerCaseElementName;
  };

  var determineNameAndNamespace = function (attribute, name) {
  	var colonIndex, namespacePrefix;

  	// are we dealing with a namespaced attribute, e.g. xlink:href?
  	colonIndex = name.indexOf(":");
  	if (colonIndex !== -1) {

  		// looks like we are, yes...
  		namespacePrefix = name.substr(0, colonIndex);

  		// ...unless it's a namespace *declaration*, which we ignore (on the assumption
  		// that only valid namespaces will be used)
  		if (namespacePrefix !== "xmlns") {
  			name = name.substring(colonIndex + 1);

  			attribute.name = enforceCase(name);
  			attribute.namespace = namespaces[namespacePrefix.toLowerCase()];
  			attribute.namespacePrefix = namespacePrefix;

  			if (!attribute.namespace) {
  				throw "Unknown namespace (\"" + namespacePrefix + "\")";
  			}

  			return;
  		}
  	}

  	// SVG attribute names are case sensitive
  	attribute.name = attribute.element.namespace !== namespaces.html ? enforceCase(name) : name;
  };

  var helpers_getInterpolator = getInterpolator;
  function getInterpolator(attribute) {
  	var items = attribute.fragment.items;

  	if (items.length !== 1) {
  		return;
  	}

  	if (items[0].type === INTERPOLATOR) {
  		return items[0];
  	}
  }

  var prototype_init = Attribute$init;
  function Attribute$init(options) {
  	this.type = ATTRIBUTE;
  	this.element = options.element;
  	this.root = options.root;

  	determineNameAndNamespace(this, options.name);
  	this.isBoolean = booleanAttributes.test(this.name);

  	// if it's an empty attribute, or just a straight key-value pair, with no
  	// mustache shenanigans, set the attribute accordingly and go home
  	if (!options.value || typeof options.value === "string") {
  		this.value = this.isBoolean ? true : options.value || "";
  		return;
  	}

  	// otherwise we need to do some work

  	// share parentFragment with parent element
  	this.parentFragment = this.element.parentFragment;

  	this.fragment = new virtualdom_Fragment({
  		template: options.value,
  		root: this.root,
  		owner: this
  	});

  	// TODO can we use this.fragment.toString() in some cases? It's quicker
  	this.value = this.fragment.getValue();

  	// Store a reference to this attribute's interpolator, if its fragment
  	// takes the form `{{foo}}`. This is necessary for two-way binding and
  	// for correctly rendering HTML later
  	this.interpolator = helpers_getInterpolator(this);
  	this.isBindable = !!this.interpolator && !this.interpolator.isStatic;

  	// mark as ready
  	this.ready = true;
  }

  var Attribute_prototype_rebind = Attribute$rebind;

  function Attribute$rebind(oldKeypath, newKeypath) {
  	if (this.fragment) {
  		this.fragment.rebind(oldKeypath, newKeypath);
  	}
  }

  var Attribute_prototype_render = Attribute$render;
  var propertyNames = {
  	"accept-charset": "acceptCharset",
  	accesskey: "accessKey",
  	bgcolor: "bgColor",
  	"class": "className",
  	codebase: "codeBase",
  	colspan: "colSpan",
  	contenteditable: "contentEditable",
  	datetime: "dateTime",
  	dirname: "dirName",
  	"for": "htmlFor",
  	"http-equiv": "httpEquiv",
  	ismap: "isMap",
  	maxlength: "maxLength",
  	novalidate: "noValidate",
  	pubdate: "pubDate",
  	readonly: "readOnly",
  	rowspan: "rowSpan",
  	tabindex: "tabIndex",
  	usemap: "useMap"
  };
  function Attribute$render(node) {
  	var propertyName;

  	this.node = node;

  	// should we use direct property access, or setAttribute?
  	if (!node.namespaceURI || node.namespaceURI === namespaces.html) {
  		propertyName = propertyNames[this.name] || this.name;

  		if (node[propertyName] !== undefined) {
  			this.propertyName = propertyName;
  		}

  		// is attribute a boolean attribute or 'value'? If so we're better off doing e.g.
  		// node.selected = true rather than node.setAttribute( 'selected', '' )
  		if (this.isBoolean || this.isTwoway) {
  			this.useProperty = true;
  		}

  		if (propertyName === "value") {
  			node._ractive.value = this.value;
  		}
  	}

  	this.rendered = true;
  	this.update();
  }

  var Attribute_prototype_toString = Attribute$toString;

  function Attribute$toString() {
  	var _ref = this;

  	var name = _ref.name;
  	var namespacePrefix = _ref.namespacePrefix;
  	var value = _ref.value;
  	var interpolator = _ref.interpolator;
  	var fragment = _ref.fragment;

  	// Special case - select and textarea values (should not be stringified)
  	if (name === "value" && (this.element.name === "select" || this.element.name === "textarea")) {
  		return;
  	}

  	// Special case - content editable
  	if (name === "value" && this.element.getAttribute("contenteditable") !== undefined) {
  		return;
  	}

  	// Special case - radio names
  	if (name === "name" && this.element.name === "input" && interpolator) {
  		return "name={{" + (interpolator.keypath.str || interpolator.ref) + "}}";
  	}

  	// Boolean attributes
  	if (this.isBoolean) {
  		return value ? name : "";
  	}

  	if (fragment) {
  		// special case - this catches undefined/null values (#1211)
  		if (fragment.items.length === 1 && fragment.items[0].value == null) {
  			return "";
  		}

  		value = fragment.toString();
  	}

  	if (namespacePrefix) {
  		name = namespacePrefix + ":" + name;
  	}

  	return value ? name + "=\"" + Attribute_prototype_toString__escape(value) + "\"" : name;
  }

  function Attribute_prototype_toString__escape(value) {
  	return value.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
  }

  var Attribute_prototype_unbind = Attribute$unbind;

  function Attribute$unbind() {
  	// ignore non-dynamic attributes
  	if (this.fragment) {
  		this.fragment.unbind();
  	}

  	if (this.name === "id") {
  		delete this.root.nodes[this.value];
  	}
  }

  var updateSelectValue = Attribute$updateSelect;

  function Attribute$updateSelect() {
  	var value = this.value,
  	    options,
  	    option,
  	    optionValue,
  	    i;

  	if (!this.locked) {
  		this.node._ractive.value = value;

  		options = this.node.options;
  		i = options.length;

  		while (i--) {
  			option = options[i];
  			optionValue = option._ractive ? option._ractive.value : option.value; // options inserted via a triple don't have _ractive

  			if (optionValue == value) {
  				// double equals as we may be comparing numbers with strings
  				option.selected = true;
  				break;
  			}
  		}
  	}

  	// if we're still here, it means the new value didn't match any of the options...
  	// TODO figure out what to do in this situation
  }

  var updateMultipleSelectValue = Attribute$updateMultipleSelect;
  function Attribute$updateMultipleSelect() {
  	var value = this.value,
  	    options,
  	    i,
  	    option,
  	    optionValue;

  	if (!isArray(value)) {
  		value = [value];
  	}

  	options = this.node.options;
  	i = options.length;

  	while (i--) {
  		option = options[i];
  		optionValue = option._ractive ? option._ractive.value : option.value; // options inserted via a triple don't have _ractive
  		option.selected = arrayContains(value, optionValue);
  	}
  }

  var updateRadioName = Attribute$updateRadioName;

  function Attribute$updateRadioName() {
  	var _ref = this;

  	var node = _ref.node;
  	var value = _ref.value;

  	node.checked = value == node._ractive.value;
  }

  var updateRadioValue = Attribute$updateRadioValue;
  function Attribute$updateRadioValue() {
  	var wasChecked,
  	    node = this.node,
  	    binding,
  	    bindings,
  	    i;

  	wasChecked = node.checked;

  	node.value = this.element.getAttribute("value");
  	node.checked = this.element.getAttribute("value") === this.element.getAttribute("name");

  	// This is a special case - if the input was checked, and the value
  	// changed so that it's no longer checked, the twoway binding is
  	// most likely out of date. To fix it we have to jump through some
  	// hoops... this is a little kludgy but it works
  	if (wasChecked && !node.checked && this.element.binding) {
  		bindings = this.element.binding.siblings;

  		if (i = bindings.length) {
  			while (i--) {
  				binding = bindings[i];

  				if (!binding.element.node) {
  					// this is the initial render, siblings are still rendering!
  					// we'll come back later...
  					return;
  				}

  				if (binding.element.node.checked) {
  					global_runloop.addRactive(binding.root);
  					return binding.handleChange();
  				}
  			}

  			this.root.viewmodel.set(binding.keypath, undefined);
  		}
  	}
  }

  var updateCheckboxName = Attribute$updateCheckboxName;
  function Attribute$updateCheckboxName() {
  	var _ref = this;

  	var element = _ref.element;
  	var node = _ref.node;
  	var value = _ref.value;var binding = element.binding;var valueAttribute;var i;

  	valueAttribute = element.getAttribute("value");

  	if (!isArray(value)) {
  		binding.isChecked = node.checked = value == valueAttribute;
  	} else {
  		i = value.length;
  		while (i--) {
  			if (valueAttribute == value[i]) {
  				binding.isChecked = node.checked = true;
  				return;
  			}
  		}
  		binding.isChecked = node.checked = false;
  	}
  }

  var updateClassName = Attribute$updateClassName;
  function Attribute$updateClassName() {
  	this.node.className = safeToStringValue(this.value);
  }

  var updateIdAttribute = Attribute$updateIdAttribute;

  function Attribute$updateIdAttribute() {
  	var _ref = this;

  	var node = _ref.node;
  	var value = _ref.value;

  	this.root.nodes[value] = node;
  	node.id = value;
  }

  var updateIEStyleAttribute = Attribute$updateIEStyleAttribute;

  function Attribute$updateIEStyleAttribute() {
  	var node, value;

  	node = this.node;
  	value = this.value;

  	if (value === undefined) {
  		value = "";
  	}

  	node.style.setAttribute("cssText", value);
  }

  var updateContentEditableValue = Attribute$updateContentEditableValue;

  function Attribute$updateContentEditableValue() {
  	var value = this.value;

  	if (value === undefined) {
  		value = "";
  	}

  	if (!this.locked) {
  		this.node.innerHTML = value;
  	}
  }

  var updateValue = Attribute$updateValue;

  function Attribute$updateValue() {
  	var _ref = this;

  	var node = _ref.node;
  	var value = _ref.value;

  	// store actual value, so it doesn't get coerced to a string
  	node._ractive.value = value;

  	// with two-way binding, only update if the change wasn't initiated by the user
  	// otherwise the cursor will often be sent to the wrong place
  	if (!this.locked) {
  		node.value = value == undefined ? "" : value;
  	}
  }

  var updateBoolean = Attribute$updateBooleanAttribute;

  function Attribute$updateBooleanAttribute() {
  	// with two-way binding, only update if the change wasn't initiated by the user
  	// otherwise the cursor will often be sent to the wrong place
  	if (!this.locked) {
  		this.node[this.propertyName] = this.value;
  	}
  }

  var updateEverythingElse = Attribute$updateEverythingElse;

  function Attribute$updateEverythingElse() {
  	var _ref = this;

  	var node = _ref.node;
  	var namespace = _ref.namespace;
  	var name = _ref.name;
  	var value = _ref.value;
  	var fragment = _ref.fragment;

  	if (namespace) {
  		node.setAttributeNS(namespace, name, (fragment || value).toString());
  	} else if (!this.isBoolean) {
  		if (value == null) {
  			node.removeAttribute(name);
  		} else {
  			node.setAttribute(name, (fragment || value).toString());
  		}
  	}

  	// Boolean attributes - truthy becomes '', falsy means 'remove attribute'
  	else {
  		if (value) {
  			node.setAttribute(name, "");
  		} else {
  			node.removeAttribute(name);
  		}
  	}
  }

  // There are a few special cases when it comes to updating attributes. For this reason,
  // the prototype .update() method points to this method, which waits until the
  // attribute has finished initialising, then replaces the prototype method with a more
  // suitable one. That way, we save ourselves doing a bunch of tests on each call
  var Attribute_prototype_update = Attribute$update;
  function Attribute$update() {
  	var _ref = this;

  	var name = _ref.name;
  	var element = _ref.element;
  	var node = _ref.node;var type;var updateMethod;

  	if (name === "id") {
  		updateMethod = updateIdAttribute;
  	} else if (name === "value") {
  		// special case - selects
  		if (element.name === "select" && name === "value") {
  			updateMethod = element.getAttribute("multiple") ? updateMultipleSelectValue : updateSelectValue;
  		} else if (element.name === "textarea") {
  			updateMethod = updateValue;
  		}

  		// special case - contenteditable
  		else if (element.getAttribute("contenteditable") != null) {
  			updateMethod = updateContentEditableValue;
  		}

  		// special case - <input>
  		else if (element.name === "input") {
  			type = element.getAttribute("type");

  			// type='file' value='{{fileList}}'>
  			if (type === "file") {
  				updateMethod = noop; // read-only
  			}

  			// type='radio' name='{{twoway}}'
  			else if (type === "radio" && element.binding && element.binding.name === "name") {
  				updateMethod = updateRadioValue;
  			} else {
  				updateMethod = updateValue;
  			}
  		}
  	}

  	// special case - <input type='radio' name='{{twoway}}' value='foo'>
  	else if (this.isTwoway && name === "name") {
  		if (node.type === "radio") {
  			updateMethod = updateRadioName;
  		} else if (node.type === "checkbox") {
  			updateMethod = updateCheckboxName;
  		}
  	}

  	// special case - style attributes in Internet Exploder
  	else if (name === "style" && node.style.setAttribute) {
  		updateMethod = updateIEStyleAttribute;
  	}

  	// special case - class names. IE fucks things up, again
  	else if (name === "class" && (!node.namespaceURI || node.namespaceURI === namespaces.html)) {
  		updateMethod = updateClassName;
  	} else if (this.useProperty) {
  		updateMethod = updateBoolean;
  	}

  	if (!updateMethod) {
  		updateMethod = updateEverythingElse;
  	}

  	this.update = updateMethod;
  	this.update();
  }

  var Attribute = function (options) {
  	this.init(options);
  };

  Attribute.prototype = {
  	bubble: Attribute_prototype_bubble,
  	init: prototype_init,
  	rebind: Attribute_prototype_rebind,
  	render: Attribute_prototype_render,
  	toString: Attribute_prototype_toString,
  	unbind: Attribute_prototype_unbind,
  	update: Attribute_prototype_update
  };

  var _Attribute = Attribute;

  var createAttributes = function (element, attributes) {
  	var name,
  	    attribute,
  	    result = [];

  	for (name in attributes) {
  		// skip binding attributes
  		if (name === "twoway" || name === "lazy") {
  			continue;
  		}

  		if (attributes.hasOwnProperty(name)) {
  			attribute = new _Attribute({
  				element: element,
  				name: name,
  				value: attributes[name],
  				root: element.root
  			});

  			result[name] = attribute;

  			if (name !== "value") {
  				result.push(attribute);
  			}
  		}
  	}

  	// value attribute goes last. This is because it
  	// may get clamped on render otherwise, e.g. in
  	// `<input type='range' value='999' min='0' max='1000'>`
  	// since default max is 100
  	if (attribute = result.value) {
  		result.push(attribute);
  	}

  	return result;
  };

  var _ConditionalAttribute__div;

  if (typeof document !== "undefined") {
  	_ConditionalAttribute__div = createElement("div");
  }

  var ConditionalAttribute = function (element, template) {
  	this.element = element;
  	this.root = element.root;
  	this.parentFragment = element.parentFragment;

  	this.attributes = [];

  	this.fragment = new virtualdom_Fragment({
  		root: element.root,
  		owner: this,
  		template: [template]
  	});
  };

  ConditionalAttribute.prototype = {
  	bubble: function () {
  		if (this.node) {
  			this.update();
  		}

  		this.element.bubble();
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		this.fragment.rebind(oldKeypath, newKeypath);
  	},

  	render: function (node) {
  		this.node = node;
  		this.isSvg = node.namespaceURI === namespaces.svg;

  		this.update();
  	},

  	unbind: function () {
  		this.fragment.unbind();
  	},

  	update: function () {
  		var _this = this;

  		var str, attrs;

  		str = this.fragment.toString();
  		attrs = parseAttributes(str, this.isSvg);

  		// any attributes that previously existed but no longer do
  		// must be removed
  		this.attributes.filter(function (a) {
  			return notIn(attrs, a);
  		}).forEach(function (a) {
  			_this.node.removeAttribute(a.name);
  		});

  		attrs.forEach(function (a) {
  			_this.node.setAttribute(a.name, a.value);
  		});

  		this.attributes = attrs;
  	},

  	toString: function () {
  		return this.fragment.toString();
  	}
  };

  var _ConditionalAttribute = ConditionalAttribute;

  function parseAttributes(str, isSvg) {
  	var tag = isSvg ? "svg" : "div";
  	_ConditionalAttribute__div.innerHTML = "<" + tag + " " + str + "></" + tag + ">";

  	return toArray(_ConditionalAttribute__div.childNodes[0].attributes);
  }

  function notIn(haystack, needle) {
  	var i = haystack.length;

  	while (i--) {
  		if (haystack[i].name === needle.name) {
  			return false;
  		}
  	}

  	return true;
  }

  var createConditionalAttributes = function (element, attributes) {
  	if (!attributes) {
  		return [];
  	}

  	return attributes.map(function (a) {
  		return new _ConditionalAttribute(element, a);
  	});
  };

  var Binding = function (element) {
  	var interpolator, keypath, value, parentForm;

  	this.element = element;
  	this.root = element.root;
  	this.attribute = element.attributes[this.name || "value"];

  	interpolator = this.attribute.interpolator;
  	interpolator.twowayBinding = this;

  	if (keypath = interpolator.keypath) {
  		if (keypath.str.slice(-1) === "}") {
  			warnOnceIfDebug("Two-way binding does not work with expressions (`%s` on <%s>)", interpolator.resolver.uniqueString, element.name, { ractive: this.root });
  			return false;
  		}

  		if (keypath.isSpecial) {
  			warnOnceIfDebug("Two-way binding does not work with %s", interpolator.resolver.ref, { ractive: this.root });
  			return false;
  		}
  	} else {
  		// A mustache may be *ambiguous*. Let's say we were given
  		// `value="{{bar}}"`. If the context was `foo`, and `foo.bar`
  		// *wasn't* `undefined`, the keypath would be `foo.bar`.
  		// Then, any user input would result in `foo.bar` being updated.
  		//
  		// If, however, `foo.bar` *was* undefined, and so was `bar`, we would be
  		// left with an unresolved partial keypath - so we are forced to make an
  		// assumption. That assumption is that the input in question should
  		// be forced to resolve to `bar`, and any user input would affect `bar`
  		// and not `foo.bar`.
  		//
  		// Did that make any sense? No? Oh. Sorry. Well the moral of the story is
  		// be explicit when using two-way data-binding about what keypath you're
  		// updating. Using it in lists is probably a recipe for confusion...
  		var ref = interpolator.template.r ? "'" + interpolator.template.r + "' reference" : "expression";
  		warnIfDebug("The %s being used for two-way binding is ambiguous, and may cause unexpected results. Consider initialising your data to eliminate the ambiguity", ref, { ractive: this.root });
  		interpolator.resolver.forceResolution();
  		keypath = interpolator.keypath;
  	}

  	this.attribute.isTwoway = true;
  	this.keypath = keypath;

  	// initialise value, if it's undefined
  	value = this.root.viewmodel.get(keypath);

  	if (value === undefined && this.getInitialValue) {
  		value = this.getInitialValue();

  		if (value !== undefined) {
  			this.root.viewmodel.set(keypath, value);
  		}
  	}

  	if (parentForm = findParentForm(element)) {
  		this.resetValue = value;
  		parentForm.formBindings.push(this);
  	}
  };

  Binding.prototype = {
  	handleChange: function () {
  		var _this = this;

  		global_runloop.start(this.root);
  		this.attribute.locked = true;
  		this.root.viewmodel.set(this.keypath, this.getValue());
  		global_runloop.scheduleTask(function () {
  			return _this.attribute.locked = false;
  		});
  		global_runloop.end();
  	},

  	rebound: function () {
  		var bindings, oldKeypath, newKeypath;

  		oldKeypath = this.keypath;
  		newKeypath = this.attribute.interpolator.keypath;

  		// The attribute this binding is linked to has already done the work
  		if (oldKeypath === newKeypath) {
  			return;
  		}

  		removeFromArray(this.root._twowayBindings[oldKeypath.str], this);

  		this.keypath = newKeypath;

  		bindings = this.root._twowayBindings[newKeypath.str] || (this.root._twowayBindings[newKeypath.str] = []);
  		bindings.push(this);
  	},

  	unbind: function () {}
  };

  Binding.extend = function (properties) {
  	var Parent = this,
  	    SpecialisedBinding;

  	SpecialisedBinding = function (element) {
  		Binding.call(this, element);

  		if (this.init) {
  			this.init();
  		}
  	};

  	SpecialisedBinding.prototype = create(Parent.prototype);
  	utils_object__extend(SpecialisedBinding.prototype, properties);

  	SpecialisedBinding.extend = Binding.extend;

  	return SpecialisedBinding;
  };

  var Binding_Binding = Binding;

  function findParentForm(element) {
  	while (element = element.parent) {
  		if (element.name === "form") {
  			return element;
  		}
  	}
  }

  // this is called when the element is unbound.
  // Specialised bindings can override it

  // This is the handler for DOM events that would lead to a change in the model
  // (i.e. change, sometimes, input, and occasionally click and keyup)
  var handleDomEvent = handleChange;

  function handleChange() {
  	this._ractive.binding.handleChange();
  }

  var GenericBinding;

  GenericBinding = Binding_Binding.extend({
  	getInitialValue: function () {
  		return "";
  	},

  	getValue: function () {
  		return this.element.node.value;
  	},

  	render: function () {
  		var node = this.element.node,
  		    lazy,
  		    timeout = false;
  		this.rendered = true;

  		// any lazy setting for this element overrides the root
  		// if the value is a number, it's a timeout
  		lazy = this.root.lazy;
  		if (this.element.lazy === true) {
  			lazy = true;
  		} else if (this.element.lazy === false) {
  			lazy = false;
  		} else if (is__isNumeric(this.element.lazy)) {
  			lazy = false;
  			timeout = +this.element.lazy;
  		} else if (is__isNumeric(lazy || "")) {
  			timeout = +lazy;
  			lazy = false;

  			// make sure the timeout is available to the handler
  			this.element.lazy = timeout;
  		}

  		this.handler = timeout ? handleDelay : handleDomEvent;

  		node.addEventListener("change", handleDomEvent, false);

  		if (!lazy) {
  			node.addEventListener("input", this.handler, false);

  			if (node.attachEvent) {
  				node.addEventListener("keyup", this.handler, false);
  			}
  		}

  		node.addEventListener("blur", handleBlur, false);
  	},

  	unrender: function () {
  		var node = this.element.node;
  		this.rendered = false;

  		node.removeEventListener("change", handleDomEvent, false);
  		node.removeEventListener("input", this.handler, false);
  		node.removeEventListener("keyup", this.handler, false);
  		node.removeEventListener("blur", handleBlur, false);
  	}
  });

  var Binding_GenericBinding = GenericBinding;

  function handleBlur() {
  	var value;

  	handleDomEvent.call(this);

  	value = this._ractive.root.viewmodel.get(this._ractive.binding.keypath);
  	this.value = value == undefined ? "" : value;
  }

  function handleDelay() {
  	var binding = this._ractive.binding,
  	    el = this;

  	if (!!binding._timeout) clearTimeout(binding._timeout);

  	binding._timeout = setTimeout(function () {
  		if (binding.rendered) handleDomEvent.call(el);
  		binding._timeout = undefined;
  	}, binding.element.lazy);
  }

  var ContentEditableBinding = Binding_GenericBinding.extend({
  	getInitialValue: function () {
  		return this.element.fragment ? this.element.fragment.toString() : "";
  	},

  	getValue: function () {
  		return this.element.node.innerHTML;
  	}
  });

  var Binding_ContentEditableBinding = ContentEditableBinding;

  var shared_getSiblings = getSiblings;
  var sets = {};
  function getSiblings(id, group, keypath) {
  	var hash = id + group + keypath;
  	return sets[hash] || (sets[hash] = []);
  }

  var RadioBinding = Binding_Binding.extend({
  	name: "checked",

  	init: function () {
  		this.siblings = shared_getSiblings(this.root._guid, "radio", this.element.getAttribute("name"));
  		this.siblings.push(this);
  	},

  	render: function () {
  		var node = this.element.node;

  		node.addEventListener("change", handleDomEvent, false);

  		if (node.attachEvent) {
  			node.addEventListener("click", handleDomEvent, false);
  		}
  	},

  	unrender: function () {
  		var node = this.element.node;

  		node.removeEventListener("change", handleDomEvent, false);
  		node.removeEventListener("click", handleDomEvent, false);
  	},

  	handleChange: function () {
  		global_runloop.start(this.root);

  		this.siblings.forEach(function (binding) {
  			binding.root.viewmodel.set(binding.keypath, binding.getValue());
  		});

  		global_runloop.end();
  	},

  	getValue: function () {
  		return this.element.node.checked;
  	},

  	unbind: function () {
  		removeFromArray(this.siblings, this);
  	}
  });

  var Binding_RadioBinding = RadioBinding;

  var RadioNameBinding = Binding_Binding.extend({
  	name: "name",

  	init: function () {
  		this.siblings = shared_getSiblings(this.root._guid, "radioname", this.keypath.str);
  		this.siblings.push(this);

  		this.radioName = true; // so that ractive.updateModel() knows what to do with this
  	},

  	getInitialValue: function () {
  		if (this.element.getAttribute("checked")) {
  			return this.element.getAttribute("value");
  		}
  	},

  	render: function () {
  		var node = this.element.node;

  		node.name = "{{" + this.keypath.str + "}}";
  		node.checked = this.root.viewmodel.get(this.keypath) == this.element.getAttribute("value");

  		node.addEventListener("change", handleDomEvent, false);

  		if (node.attachEvent) {
  			node.addEventListener("click", handleDomEvent, false);
  		}
  	},

  	unrender: function () {
  		var node = this.element.node;

  		node.removeEventListener("change", handleDomEvent, false);
  		node.removeEventListener("click", handleDomEvent, false);
  	},

  	getValue: function () {
  		var node = this.element.node;
  		return node._ractive ? node._ractive.value : node.value;
  	},

  	handleChange: function () {
  		// If this <input> is the one that's checked, then the value of its
  		// `name` keypath gets set to its value
  		if (this.element.node.checked) {
  			Binding_Binding.prototype.handleChange.call(this);
  		}
  	},

  	rebound: function (oldKeypath, newKeypath) {
  		var node;

  		Binding_Binding.prototype.rebound.call(this, oldKeypath, newKeypath);

  		if (node = this.element.node) {
  			node.name = "{{" + this.keypath.str + "}}";
  		}
  	},

  	unbind: function () {
  		removeFromArray(this.siblings, this);
  	}
  });

  var Binding_RadioNameBinding = RadioNameBinding;

  var CheckboxNameBinding = Binding_Binding.extend({
  	name: "name",

  	getInitialValue: function () {
  		// This only gets called once per group (of inputs that
  		// share a name), because it only gets called if there
  		// isn't an initial value. By the same token, we can make
  		// a note of that fact that there was no initial value,
  		// and populate it using any `checked` attributes that
  		// exist (which users should avoid, but which we should
  		// support anyway to avoid breaking expectations)
  		this.noInitialValue = true;
  		return [];
  	},

  	init: function () {
  		var existingValue, bindingValue;

  		this.checkboxName = true; // so that ractive.updateModel() knows what to do with this

  		// Each input has a reference to an array containing it and its
  		// siblings, as two-way binding depends on being able to ascertain
  		// the status of all inputs within the group
  		this.siblings = shared_getSiblings(this.root._guid, "checkboxes", this.keypath.str);
  		this.siblings.push(this);

  		if (this.noInitialValue) {
  			this.siblings.noInitialValue = true;
  		}

  		// If no initial value was set, and this input is checked, we
  		// update the model
  		if (this.siblings.noInitialValue && this.element.getAttribute("checked")) {
  			existingValue = this.root.viewmodel.get(this.keypath);
  			bindingValue = this.element.getAttribute("value");

  			existingValue.push(bindingValue);
  		}
  	},

  	unbind: function () {
  		removeFromArray(this.siblings, this);
  	},

  	render: function () {
  		var node = this.element.node,
  		    existingValue,
  		    bindingValue;

  		existingValue = this.root.viewmodel.get(this.keypath);
  		bindingValue = this.element.getAttribute("value");

  		if (isArray(existingValue)) {
  			this.isChecked = arrayContains(existingValue, bindingValue);
  		} else {
  			this.isChecked = existingValue == bindingValue;
  		}

  		node.name = "{{" + this.keypath.str + "}}";
  		node.checked = this.isChecked;

  		node.addEventListener("change", handleDomEvent, false);

  		// in case of IE emergency, bind to click event as well
  		if (node.attachEvent) {
  			node.addEventListener("click", handleDomEvent, false);
  		}
  	},

  	unrender: function () {
  		var node = this.element.node;

  		node.removeEventListener("change", handleDomEvent, false);
  		node.removeEventListener("click", handleDomEvent, false);
  	},

  	changed: function () {
  		var wasChecked = !!this.isChecked;
  		this.isChecked = this.element.node.checked;
  		return this.isChecked === wasChecked;
  	},

  	handleChange: function () {
  		this.isChecked = this.element.node.checked;
  		Binding_Binding.prototype.handleChange.call(this);
  	},

  	getValue: function () {
  		return this.siblings.filter(isChecked).map(Binding_CheckboxNameBinding__getValue);
  	}
  });

  function isChecked(binding) {
  	return binding.isChecked;
  }

  function Binding_CheckboxNameBinding__getValue(binding) {
  	return binding.element.getAttribute("value");
  }

  var Binding_CheckboxNameBinding = CheckboxNameBinding;

  var CheckboxBinding = Binding_Binding.extend({
  	name: "checked",

  	render: function () {
  		var node = this.element.node;

  		node.addEventListener("change", handleDomEvent, false);

  		if (node.attachEvent) {
  			node.addEventListener("click", handleDomEvent, false);
  		}
  	},

  	unrender: function () {
  		var node = this.element.node;

  		node.removeEventListener("change", handleDomEvent, false);
  		node.removeEventListener("click", handleDomEvent, false);
  	},

  	getValue: function () {
  		return this.element.node.checked;
  	}
  });

  var Binding_CheckboxBinding = CheckboxBinding;

  var SelectBinding = Binding_Binding.extend({
  	getInitialValue: function () {
  		var options = this.element.options,
  		    len,
  		    i,
  		    value,
  		    optionWasSelected;

  		if (this.element.getAttribute("value") !== undefined) {
  			return;
  		}

  		i = len = options.length;

  		if (!len) {
  			return;
  		}

  		// take the final selected option...
  		while (i--) {
  			if (options[i].getAttribute("selected")) {
  				value = options[i].getAttribute("value");
  				optionWasSelected = true;
  				break;
  			}
  		}

  		// or the first non-disabled option, if none are selected
  		if (!optionWasSelected) {
  			while (++i < len) {
  				if (!options[i].getAttribute("disabled")) {
  					value = options[i].getAttribute("value");
  					break;
  				}
  			}
  		}

  		// This is an optimisation (aka hack) that allows us to forgo some
  		// other more expensive work
  		if (value !== undefined) {
  			this.element.attributes.value.value = value;
  		}

  		return value;
  	},

  	render: function () {
  		this.element.node.addEventListener("change", handleDomEvent, false);
  	},

  	unrender: function () {
  		this.element.node.removeEventListener("change", handleDomEvent, false);
  	},

  	// TODO this method is an anomaly... is it necessary?
  	setValue: function (value) {
  		this.root.viewmodel.set(this.keypath, value);
  	},

  	getValue: function () {
  		var options, i, len, option, optionValue;

  		options = this.element.node.options;
  		len = options.length;

  		for (i = 0; i < len; i += 1) {
  			option = options[i];

  			if (options[i].selected) {
  				optionValue = option._ractive ? option._ractive.value : option.value;
  				return optionValue;
  			}
  		}
  	},

  	forceUpdate: function () {
  		var _this = this;

  		var value = this.getValue();

  		if (value !== undefined) {
  			this.attribute.locked = true;
  			global_runloop.scheduleTask(function () {
  				return _this.attribute.locked = false;
  			});
  			this.root.viewmodel.set(this.keypath, value);
  		}
  	}
  });

  var Binding_SelectBinding = SelectBinding;

  var MultipleSelectBinding = Binding_SelectBinding.extend({
  	getInitialValue: function () {
  		return this.element.options.filter(function (option) {
  			return option.getAttribute("selected");
  		}).map(function (option) {
  			return option.getAttribute("value");
  		});
  	},

  	render: function () {
  		var valueFromModel;

  		this.element.node.addEventListener("change", handleDomEvent, false);

  		valueFromModel = this.root.viewmodel.get(this.keypath);

  		if (valueFromModel === undefined) {
  			// get value from DOM, if possible
  			this.handleChange();
  		}
  	},

  	unrender: function () {
  		this.element.node.removeEventListener("change", handleDomEvent, false);
  	},

  	setValue: function () {
  		throw new Error("TODO not implemented yet");
  	},

  	getValue: function () {
  		var selectedValues, options, i, len, option, optionValue;

  		selectedValues = [];
  		options = this.element.node.options;
  		len = options.length;

  		for (i = 0; i < len; i += 1) {
  			option = options[i];

  			if (option.selected) {
  				optionValue = option._ractive ? option._ractive.value : option.value;
  				selectedValues.push(optionValue);
  			}
  		}

  		return selectedValues;
  	},

  	handleChange: function () {
  		var attribute, previousValue, value;

  		attribute = this.attribute;
  		previousValue = attribute.value;

  		value = this.getValue();

  		if (previousValue === undefined || !arrayContentsMatch(value, previousValue)) {
  			Binding_SelectBinding.prototype.handleChange.call(this);
  		}

  		return this;
  	},

  	forceUpdate: function () {
  		var _this = this;

  		var value = this.getValue();

  		if (value !== undefined) {
  			this.attribute.locked = true;
  			global_runloop.scheduleTask(function () {
  				return _this.attribute.locked = false;
  			});
  			this.root.viewmodel.set(this.keypath, value);
  		}
  	},

  	updateModel: function () {
  		if (this.attribute.value === undefined || !this.attribute.value.length) {
  			this.root.viewmodel.set(this.keypath, this.initialValue);
  		}
  	}
  });

  var Binding_MultipleSelectBinding = MultipleSelectBinding;

  var FileListBinding = Binding_Binding.extend({
  	render: function () {
  		this.element.node.addEventListener("change", handleDomEvent, false);
  	},

  	unrender: function () {
  		this.element.node.removeEventListener("change", handleDomEvent, false);
  	},

  	getValue: function () {
  		return this.element.node.files;
  	}
  });

  var Binding_FileListBinding = FileListBinding;

  var NumericBinding = Binding_GenericBinding.extend({
  	getInitialValue: function () {
  		return undefined;
  	},

  	getValue: function () {
  		var value = parseFloat(this.element.node.value);
  		return isNaN(value) ? undefined : value;
  	}
  });

  var init_createTwowayBinding = createTwowayBinding;

  function createTwowayBinding(element) {
  	var attributes = element.attributes,
  	    type,
  	    Binding,
  	    bindName,
  	    bindChecked,
  	    binding;

  	// if this is a late binding, and there's already one, it
  	// needs to be torn down
  	if (element.binding) {
  		element.binding.teardown();
  		element.binding = null;
  	}

  	// contenteditable
  	if (
  	// if the contenteditable attribute is true or is bindable and may thus become true
  	(element.getAttribute("contenteditable") || !!attributes.contenteditable && isBindable(attributes.contenteditable)) && isBindable(attributes.value)) {
  		Binding = Binding_ContentEditableBinding;
  	}

  	// <input>
  	else if (element.name === "input") {
  		type = element.getAttribute("type");

  		if (type === "radio" || type === "checkbox") {
  			bindName = isBindable(attributes.name);
  			bindChecked = isBindable(attributes.checked);

  			// we can either bind the name attribute, or the checked attribute - not both
  			if (bindName && bindChecked) {
  				warnIfDebug("A radio input can have two-way binding on its name attribute, or its checked attribute - not both", { ractive: element.root });
  			}

  			if (bindName) {
  				Binding = type === "radio" ? Binding_RadioNameBinding : Binding_CheckboxNameBinding;
  			} else if (bindChecked) {
  				Binding = type === "radio" ? Binding_RadioBinding : Binding_CheckboxBinding;
  			}
  		} else if (type === "file" && isBindable(attributes.value)) {
  			Binding = Binding_FileListBinding;
  		} else if (isBindable(attributes.value)) {
  			Binding = type === "number" || type === "range" ? NumericBinding : Binding_GenericBinding;
  		}
  	}

  	// <select>
  	else if (element.name === "select" && isBindable(attributes.value)) {
  		Binding = element.getAttribute("multiple") ? Binding_MultipleSelectBinding : Binding_SelectBinding;
  	}

  	// <textarea>
  	else if (element.name === "textarea" && isBindable(attributes.value)) {
  		Binding = Binding_GenericBinding;
  	}

  	if (Binding && (binding = new Binding(element)) && binding.keypath) {
  		return binding;
  	}
  }

  function isBindable(attribute) {
  	return attribute && attribute.isBindable;
  }

  // and this element also has a value attribute to bind

  var EventHandler_prototype_bubble = EventHandler$bubble;

  function EventHandler$bubble() {
  	var hasAction = this.getAction();

  	if (hasAction && !this.hasListener) {
  		this.listen();
  	} else if (!hasAction && this.hasListener) {
  		this.unrender();
  	}
  }

  // This function may be overwritten, if the event directive
  // includes parameters
  var EventHandler_prototype_fire = EventHandler$fire;
  function EventHandler$fire(event) {
  	shared_fireEvent(this.root, this.getAction(), { event: event });
  }

  var getAction = EventHandler$getAction;

  function EventHandler$getAction() {
  	return this.action.toString().trim();
  }

  var EventHandler_prototype_init = EventHandler$init;

  var eventPattern = /^event(?:\.(.+))?/;
  function EventHandler$init(element, name, template) {
  	var _this = this;

  	var action, refs, ractive;

  	this.element = element;
  	this.root = element.root;
  	this.parentFragment = element.parentFragment;
  	this.name = name;

  	if (name.indexOf("*") !== -1) {
  		fatal("Only component proxy-events may contain \"*\" wildcards, <%s on-%s=\"...\"/> is not valid", element.name, name);
  		this.invalid = true;
  	}

  	if (template.m) {
  		refs = template.a.r;

  		// This is a method call
  		this.method = template.m;
  		this.keypaths = [];
  		this.fn = shared_getFunctionFromString(template.a.s, refs.length);

  		this.parentFragment = element.parentFragment;
  		ractive = this.root;

  		// Create resolvers for each reference
  		this.refResolvers = [];
  		refs.forEach(function (ref, i) {
  			var match = undefined;

  			// special case - the `event` object
  			if (match = eventPattern.exec(ref)) {
  				_this.keypaths[i] = {
  					eventObject: true,
  					refinements: match[1] ? match[1].split(".") : []
  				};
  			} else {
  				_this.refResolvers.push(Resolvers_createReferenceResolver(_this, ref, function (keypath) {
  					return _this.resolve(i, keypath);
  				}));
  			}
  		});

  		this.fire = fireMethodCall;
  	} else {
  		// Get action ('foo' in 'on-click='foo')
  		action = template.n || template;
  		if (typeof action !== "string") {
  			action = new virtualdom_Fragment({
  				template: action,
  				root: this.root,
  				owner: this
  			});
  		}

  		this.action = action;

  		// Get parameters
  		if (template.d) {
  			this.dynamicParams = new virtualdom_Fragment({
  				template: template.d,
  				root: this.root,
  				owner: this.element
  			});

  			this.fire = fireEventWithDynamicParams;
  		} else if (template.a) {
  			this.params = template.a;
  			this.fire = fireEventWithParams;
  		}
  	}
  }

  function fireMethodCall(event) {
  	var ractive, values, args;

  	ractive = this.root;

  	if (typeof ractive[this.method] !== "function") {
  		throw new Error("Attempted to call a non-existent method (\"" + this.method + "\")");
  	}

  	values = this.keypaths.map(function (keypath) {
  		var value, len, i;

  		if (keypath === undefined) {
  			// not yet resolved
  			return undefined;
  		}

  		// TODO the refinements stuff would be better handled at parse time
  		if (keypath.eventObject) {
  			value = event;

  			if (len = keypath.refinements.length) {
  				for (i = 0; i < len; i += 1) {
  					value = value[keypath.refinements[i]];
  				}
  			}
  		} else {
  			value = ractive.viewmodel.get(keypath);
  		}

  		return value;
  	});

  	shared_eventStack.enqueue(ractive, event);

  	args = this.fn.apply(null, values);
  	ractive[this.method].apply(ractive, args);

  	shared_eventStack.dequeue(ractive);
  }

  function fireEventWithParams(event) {
  	shared_fireEvent(this.root, this.getAction(), { event: event, args: this.params });
  }

  function fireEventWithDynamicParams(event) {
  	var args = this.dynamicParams.getArgsList();

  	// need to strip [] from ends if a string!
  	if (typeof args === "string") {
  		args = args.substr(1, args.length - 2);
  	}

  	shared_fireEvent(this.root, this.getAction(), { event: event, args: args });
  }

  var shared_genericHandler = genericHandler;
  function genericHandler(event) {
  	var storage,
  	    handler,
  	    indices,
  	    index = {};

  	storage = this._ractive;
  	handler = storage.events[event.type];

  	if (indices = Resolvers_findIndexRefs(handler.element.parentFragment)) {
  		index = Resolvers_findIndexRefs.resolve(indices);
  	}

  	handler.fire({
  		node: this,
  		original: event,
  		index: index,
  		keypath: storage.keypath.str,
  		context: storage.root.viewmodel.get(storage.keypath)
  	});
  }

  var listen = EventHandler$listen;

  var customHandlers = {},
      touchEvents = {
  	touchstart: true,
  	touchmove: true,
  	touchend: true,
  	touchcancel: true,
  	//not w3c, but supported in some browsers
  	touchleave: true
  };
  function EventHandler$listen() {
  	var definition,
  	    name = this.name;

  	if (this.invalid) {
  		return;
  	}

  	if (definition = findInViewHierarchy("events", this.root, name)) {
  		this.custom = definition(this.node, getCustomHandler(name));
  	} else {
  		// Looks like we're dealing with a standard DOM event... but let's check
  		if (!("on" + name in this.node) && !(window && "on" + name in window) && !isJsdom) {

  			// okay to use touch events if this browser doesn't support them
  			if (!touchEvents[name]) {
  				warnOnceIfDebug(missingPlugin(name, "event"), { node: this.node });
  			}

  			return;
  		}

  		this.node.addEventListener(name, shared_genericHandler, false);
  	}

  	this.hasListener = true;
  }

  function getCustomHandler(name) {
  	if (!customHandlers[name]) {
  		customHandlers[name] = function (event) {
  			var storage = event.node._ractive;

  			event.index = storage.index;
  			event.keypath = storage.keypath.str;
  			event.context = storage.root.viewmodel.get(storage.keypath);

  			storage.events[name].fire(event);
  		};
  	}

  	return customHandlers[name];
  }

  var EventHandler_prototype_rebind = EventHandler$rebind;

  function EventHandler$rebind(oldKeypath, newKeypath) {
  	var fragment;
  	if (this.method) {
  		fragment = this.element.parentFragment;
  		this.refResolvers.forEach(rebind);

  		return;
  	}

  	if (typeof this.action !== "string") {
  		rebind(this.action);
  	}

  	if (this.dynamicParams) {
  		rebind(this.dynamicParams);
  	}

  	function rebind(thing) {
  		thing && thing.rebind(oldKeypath, newKeypath);
  	}
  }

  var EventHandler_prototype_render = EventHandler$render;

  function EventHandler$render() {
  	this.node = this.element.node;
  	// store this on the node itself, so it can be retrieved by a
  	// universal handler
  	this.node._ractive.events[this.name] = this;

  	if (this.method || this.getAction()) {
  		this.listen();
  	}
  }

  var prototype_resolve = EventHandler$resolve;

  function EventHandler$resolve(index, keypath) {
  	this.keypaths[index] = keypath;
  }

  var EventHandler_prototype_unbind = EventHandler$unbind;
  function EventHandler$unbind() {
  	if (this.method) {
  		this.refResolvers.forEach(methodCallers__unbind);
  		return;
  	}

  	// Tear down dynamic name
  	if (typeof this.action !== "string") {
  		this.action.unbind();
  	}

  	// Tear down dynamic parameters
  	if (this.dynamicParams) {
  		this.dynamicParams.unbind();
  	}
  }

  var EventHandler_prototype_unrender = EventHandler$unrender;
  function EventHandler$unrender() {

  	if (this.custom) {
  		this.custom.teardown();
  	} else {
  		this.node.removeEventListener(this.name, shared_genericHandler, false);
  	}

  	this.hasListener = false;
  }

  var EventHandler = function (element, name, template) {
  	this.init(element, name, template);
  };

  EventHandler.prototype = {
  	bubble: EventHandler_prototype_bubble,
  	fire: EventHandler_prototype_fire,
  	getAction: getAction,
  	init: EventHandler_prototype_init,
  	listen: listen,
  	rebind: EventHandler_prototype_rebind,
  	render: EventHandler_prototype_render,
  	resolve: prototype_resolve,
  	unbind: EventHandler_prototype_unbind,
  	unrender: EventHandler_prototype_unrender
  };

  var _EventHandler = EventHandler;

  var createEventHandlers = function (element, template) {
  	var i,
  	    name,
  	    names,
  	    handler,
  	    result = [];

  	for (name in template) {
  		if (template.hasOwnProperty(name)) {
  			names = name.split("-");
  			i = names.length;

  			while (i--) {
  				handler = new _EventHandler(element, names[i], template[name]);
  				result.push(handler);
  			}
  		}
  	}

  	return result;
  };

  var Decorator = function (element, template) {
  	var self = this,
  	    ractive,
  	    name,
  	    fragment;

  	this.element = element;
  	this.root = ractive = element.root;

  	name = template.n || template;

  	if (typeof name !== "string") {
  		fragment = new virtualdom_Fragment({
  			template: name,
  			root: ractive,
  			owner: element
  		});

  		name = fragment.toString();
  		fragment.unbind();

  		if (name === "") {
  			// empty string okay, just no decorator
  			return;
  		}
  	}

  	if (template.a) {
  		this.params = template.a;
  	} else if (template.d) {
  		this.fragment = new virtualdom_Fragment({
  			template: template.d,
  			root: ractive,
  			owner: element
  		});

  		this.params = this.fragment.getArgsList();

  		this.fragment.bubble = function () {
  			this.dirtyArgs = this.dirtyValue = true;
  			self.params = this.getArgsList();

  			if (self.ready) {
  				self.update();
  			}
  		};
  	}

  	this.fn = findInViewHierarchy("decorators", ractive, name);

  	if (!this.fn) {
  		fatal(missingPlugin(name, "decorator"));
  	}
  };

  Decorator.prototype = {
  	init: function () {
  		var node, result, args;

  		node = this.element.node;

  		if (this.params) {
  			args = [node].concat(this.params);
  			result = this.fn.apply(this.root, args);
  		} else {
  			result = this.fn.call(this.root, node);
  		}

  		if (!result || !result.teardown) {
  			throw new Error("Decorator definition must return an object with a teardown method");
  		}

  		// TODO does this make sense?
  		this.actual = result;
  		this.ready = true;
  	},

  	update: function () {
  		if (this.actual.update) {
  			this.actual.update.apply(this.root, this.params);
  		} else {
  			this.actual.teardown(true);
  			this.init();
  		}
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		if (this.fragment) {
  			this.fragment.rebind(oldKeypath, newKeypath);
  		}
  	},

  	teardown: function (updating) {
  		this.torndown = true;
  		if (this.ready) {
  			this.actual.teardown();
  		}

  		if (!updating && this.fragment) {
  			this.fragment.unbind();
  		}
  	}
  };

  var _Decorator = Decorator;

  function select__bubble() {
  	var _this = this;

  	if (!this.dirty) {
  		this.dirty = true;

  		global_runloop.scheduleTask(function () {
  			sync(_this);
  			_this.dirty = false;
  		});
  	}

  	this.parentFragment.bubble(); // default behaviour
  }

  function sync(selectElement) {
  	var selectNode, selectValue, isMultiple, options, optionWasSelected;

  	selectNode = selectElement.node;

  	if (!selectNode) {
  		return;
  	}

  	options = toArray(selectNode.options);

  	selectValue = selectElement.getAttribute("value");
  	isMultiple = selectElement.getAttribute("multiple");

  	// If the <select> has a specified value, that should override
  	// these options
  	if (selectValue !== undefined) {
  		options.forEach(function (o) {
  			var optionValue, shouldSelect;

  			optionValue = o._ractive ? o._ractive.value : o.value;
  			shouldSelect = isMultiple ? valueContains(selectValue, optionValue) : selectValue == optionValue;

  			if (shouldSelect) {
  				optionWasSelected = true;
  			}

  			o.selected = shouldSelect;
  		});

  		if (!optionWasSelected) {
  			if (options[0]) {
  				options[0].selected = true;
  			}

  			if (selectElement.binding) {
  				selectElement.binding.forceUpdate();
  			}
  		}
  	}

  	// Otherwise the value should be initialised according to which
  	// <option> element is selected, if twoway binding is in effect
  	else if (selectElement.binding) {
  		selectElement.binding.forceUpdate();
  	}
  }

  function valueContains(selectValue, optionValue) {
  	var i = selectValue.length;
  	while (i--) {
  		if (selectValue[i] == optionValue) {
  			return true;
  		}
  	}
  }

  function special_option__init(option, template) {
  	option.select = findParentSelect(option.parent);

  	// we might be inside a <datalist> element
  	if (!option.select) {
  		return;
  	}

  	option.select.options.push(option);

  	// If the value attribute is missing, use the element's content
  	if (!template.a) {
  		template.a = {};
  	}

  	// ...as long as it isn't disabled
  	if (template.a.value === undefined && !template.a.hasOwnProperty("disabled")) {
  		template.a.value = template.f;
  	}

  	// If there is a `selected` attribute, but the <select>
  	// already has a value, delete it
  	if ("selected" in template.a && option.select.getAttribute("value") !== undefined) {
  		delete template.a.selected;
  	}
  }

  function special_option__unbind(option) {
  	if (option.select) {
  		removeFromArray(option.select.options, option);
  	}
  }

  function findParentSelect(element) {
  	if (!element) {
  		return;
  	}

  	do {
  		if (element.name === "select") {
  			return element;
  		}
  	} while (element = element.parent);
  }

  var Element_prototype_init = Element$init;
  function Element$init(options) {
  	var parentFragment, template, ractive, binding, bindings, twoway, bindingAttrs;

  	this.type = ELEMENT;

  	// stuff we'll need later
  	parentFragment = this.parentFragment = options.parentFragment;
  	template = this.template = options.template;

  	this.parent = options.pElement || parentFragment.pElement;

  	this.root = ractive = parentFragment.root;
  	this.index = options.index;
  	this.key = options.key;

  	this.name = enforceCase(template.e);

  	// Special case - <option> elements
  	if (this.name === "option") {
  		special_option__init(this, template);
  	}

  	// Special case - <select> elements
  	if (this.name === "select") {
  		this.options = [];
  		this.bubble = select__bubble; // TODO this is a kludge
  	}

  	// Special case - <form> elements
  	if (this.name === "form") {
  		this.formBindings = [];
  	}

  	// handle binding attributes first (twoway, lazy)
  	bindingAttrs = processBindingAttributes(this, template);

  	// create attributes
  	this.attributes = createAttributes(this, template.a);
  	this.conditionalAttributes = createConditionalAttributes(this, template.m);

  	// append children, if there are any
  	if (template.f) {
  		this.fragment = new virtualdom_Fragment({
  			template: template.f,
  			root: ractive,
  			owner: this,
  			pElement: this,
  			cssIds: null
  		});
  	}

  	// the element setting should override the ractive setting
  	twoway = ractive.twoway;
  	if (bindingAttrs.twoway === false) twoway = false;else if (bindingAttrs.twoway === true) twoway = true;

  	this.twoway = twoway;
  	this.lazy = bindingAttrs.lazy;

  	// create twoway binding
  	if (twoway && (binding = init_createTwowayBinding(this, template.a))) {
  		this.binding = binding;

  		// register this with the root, so that we can do ractive.updateModel()
  		bindings = this.root._twowayBindings[binding.keypath.str] || (this.root._twowayBindings[binding.keypath.str] = []);
  		bindings.push(binding);
  	}

  	// create event proxies
  	if (template.v) {
  		this.eventHandlers = createEventHandlers(this, template.v);
  	}

  	// create decorator
  	if (template.o) {
  		this.decorator = new _Decorator(this, template.o);
  	}

  	// create transitions
  	this.intro = template.t0 || template.t1;
  	this.outro = template.t0 || template.t2;
  }

  var Element_prototype_rebind = Element$rebind;
  function Element$rebind(oldKeypath, newKeypath) {
  	var i, storage, liveQueries, ractive;

  	if (this.attributes) {
  		this.attributes.forEach(rebind);
  	}

  	if (this.conditionalAttributes) {
  		this.conditionalAttributes.forEach(rebind);
  	}

  	if (this.eventHandlers) {
  		this.eventHandlers.forEach(rebind);
  	}

  	if (this.decorator) {
  		rebind(this.decorator);
  	}

  	// rebind children
  	if (this.fragment) {
  		rebind(this.fragment);
  	}

  	// Update live queries, if necessary
  	if (liveQueries = this.liveQueries) {
  		ractive = this.root;

  		i = liveQueries.length;
  		while (i--) {
  			liveQueries[i]._makeDirty();
  		}
  	}

  	if (this.node && (storage = this.node._ractive)) {

  		// adjust keypath if needed
  		assignNewKeypath(storage, "keypath", oldKeypath, newKeypath);
  	}

  	function rebind(thing) {
  		thing.rebind(oldKeypath, newKeypath);
  	}
  }

  function special_img__render(img) {
  	var loadHandler;

  	// if this is an <img>, and we're in a crap browser, we may need to prevent it
  	// from overriding width and height when it loads the src
  	if (img.attributes.width || img.attributes.height) {
  		img.node.addEventListener("load", loadHandler = function () {
  			var width = img.getAttribute("width"),
  			    height = img.getAttribute("height");

  			if (width !== undefined) {
  				img.node.setAttribute("width", width);
  			}

  			if (height !== undefined) {
  				img.node.setAttribute("height", height);
  			}

  			img.node.removeEventListener("load", loadHandler, false);
  		}, false);
  	}
  }

  function form__render(element) {
  	element.node.addEventListener("reset", handleReset, false);
  }

  function form__unrender(element) {
  	element.node.removeEventListener("reset", handleReset, false);
  }

  function handleReset() {
  	var element = this._ractive.proxy;

  	global_runloop.start();
  	element.formBindings.forEach(updateModel);
  	global_runloop.end();
  }

  function updateModel(binding) {
  	binding.root.viewmodel.set(binding.keypath, binding.resetValue);
  }

  var Transition_prototype_init = Transition$init;
  function Transition$init(element, template, isIntro) {
  	var ractive, name, fragment;

  	this.element = element;
  	this.root = ractive = element.root;
  	this.isIntro = isIntro;

  	name = template.n || template;

  	if (typeof name !== "string") {
  		fragment = new virtualdom_Fragment({
  			template: name,
  			root: ractive,
  			owner: element
  		});

  		name = fragment.toString();
  		fragment.unbind();

  		if (name === "") {
  			// empty string okay, just no transition
  			return;
  		}
  	}

  	this.name = name;

  	if (template.a) {
  		this.params = template.a;
  	} else if (template.d) {
  		// TODO is there a way to interpret dynamic arguments without all the
  		// 'dependency thrashing'?
  		fragment = new virtualdom_Fragment({
  			template: template.d,
  			root: ractive,
  			owner: element
  		});

  		this.params = fragment.getArgsList();
  		fragment.unbind();
  	}

  	this._fn = findInViewHierarchy("transitions", ractive, name);

  	if (!this._fn) {
  		warnOnceIfDebug(missingPlugin(name, "transition"), { ractive: this.root });
  	}
  }

  var camelCase = function (hyphenatedStr) {
  	return hyphenatedStr.replace(/-([a-zA-Z])/g, function (match, $1) {
  		return $1.toUpperCase();
  	});
  };

  var helpers_prefix__prefix, prefixCache, helpers_prefix__testStyle;

  if (!isClient) {
  	helpers_prefix__prefix = null;
  } else {
  	prefixCache = {};
  	helpers_prefix__testStyle = createElement("div").style;

  	helpers_prefix__prefix = function (prop) {
  		var i, vendor, capped;

  		prop = camelCase(prop);

  		if (!prefixCache[prop]) {
  			if (helpers_prefix__testStyle[prop] !== undefined) {
  				prefixCache[prop] = prop;
  			} else {
  				// test vendors...
  				capped = prop.charAt(0).toUpperCase() + prop.substring(1);

  				i = vendors.length;
  				while (i--) {
  					vendor = vendors[i];
  					if (helpers_prefix__testStyle[vendor + capped] !== undefined) {
  						prefixCache[prop] = vendor + capped;
  						break;
  					}
  				}
  			}
  		}

  		return prefixCache[prop];
  	};
  }

  var helpers_prefix = helpers_prefix__prefix;

  var getStyle, prototype_getStyle__getComputedStyle;

  if (!isClient) {
  	getStyle = null;
  } else {
  	prototype_getStyle__getComputedStyle = window.getComputedStyle || legacy.getComputedStyle;

  	getStyle = function (props) {
  		var computedStyle, styles, i, prop, value;

  		computedStyle = prototype_getStyle__getComputedStyle(this.node);

  		if (typeof props === "string") {
  			value = computedStyle[helpers_prefix(props)];
  			if (value === "0px") {
  				value = 0;
  			}
  			return value;
  		}

  		if (!isArray(props)) {
  			throw new Error("Transition$getStyle must be passed a string, or an array of strings representing CSS properties");
  		}

  		styles = {};

  		i = props.length;
  		while (i--) {
  			prop = props[i];
  			value = computedStyle[helpers_prefix(prop)];
  			if (value === "0px") {
  				value = 0;
  			}
  			styles[prop] = value;
  		}

  		return styles;
  	};
  }

  var prototype_getStyle = getStyle;

  var setStyle = function (style, value) {
  	var prop;

  	if (typeof style === "string") {
  		this.node.style[helpers_prefix(style)] = value;
  	} else {
  		for (prop in style) {
  			if (style.hasOwnProperty(prop)) {
  				this.node.style[helpers_prefix(prop)] = style[prop];
  			}
  		}
  	}

  	return this;
  };

  var Ticker = function (options) {
  	var easing;

  	this.duration = options.duration;
  	this.step = options.step;
  	this.complete = options.complete;

  	// easing
  	if (typeof options.easing === "string") {
  		easing = options.root.easing[options.easing];

  		if (!easing) {
  			warnOnceIfDebug(missingPlugin(options.easing, "easing"));
  			easing = linear;
  		}
  	} else if (typeof options.easing === "function") {
  		easing = options.easing;
  	} else {
  		easing = linear;
  	}

  	this.easing = easing;

  	this.start = utils_getTime();
  	this.end = this.start + this.duration;

  	this.running = true;
  	shared_animations.add(this);
  };

  Ticker.prototype = {
  	tick: function (now) {
  		var elapsed, eased;

  		if (!this.running) {
  			return false;
  		}

  		if (now > this.end) {
  			if (this.step) {
  				this.step(1);
  			}

  			if (this.complete) {
  				this.complete(1);
  			}

  			return false;
  		}

  		elapsed = now - this.start;
  		eased = this.easing(elapsed / this.duration);

  		if (this.step) {
  			this.step(eased);
  		}

  		return true;
  	},

  	stop: function () {
  		if (this.abort) {
  			this.abort();
  		}

  		this.running = false;
  	}
  };

  var shared_Ticker = Ticker;
  function linear(t) {
  	return t;
  }

  var unprefixPattern = new RegExp("^-(?:" + vendors.join("|") + ")-");

  var unprefix = function (prop) {
  	return prop.replace(unprefixPattern, "");
  };

  var vendorPattern = new RegExp("^(?:" + vendors.join("|") + ")([A-Z])");

  var hyphenate = function (str) {
  	var hyphenated;

  	if (!str) {
  		return ""; // edge case
  	}

  	if (vendorPattern.test(str)) {
  		str = "-" + str;
  	}

  	hyphenated = str.replace(/[A-Z]/g, function (match) {
  		return "-" + match.toLowerCase();
  	});

  	return hyphenated;
  };

  var createTransitions,
      animateStyle_createTransitions__testStyle,
      TRANSITION,
      TRANSITIONEND,
      CSS_TRANSITIONS_ENABLED,
      TRANSITION_DURATION,
      TRANSITION_PROPERTY,
      TRANSITION_TIMING_FUNCTION,
      canUseCssTransitions = {},
      cannotUseCssTransitions = {};

  if (!isClient) {
  	createTransitions = null;
  } else {
  	animateStyle_createTransitions__testStyle = createElement("div").style;

  	// determine some facts about our environment
  	(function () {
  		if (animateStyle_createTransitions__testStyle.transition !== undefined) {
  			TRANSITION = "transition";
  			TRANSITIONEND = "transitionend";
  			CSS_TRANSITIONS_ENABLED = true;
  		} else if (animateStyle_createTransitions__testStyle.webkitTransition !== undefined) {
  			TRANSITION = "webkitTransition";
  			TRANSITIONEND = "webkitTransitionEnd";
  			CSS_TRANSITIONS_ENABLED = true;
  		} else {
  			CSS_TRANSITIONS_ENABLED = false;
  		}
  	})();

  	if (TRANSITION) {
  		TRANSITION_DURATION = TRANSITION + "Duration";
  		TRANSITION_PROPERTY = TRANSITION + "Property";
  		TRANSITION_TIMING_FUNCTION = TRANSITION + "TimingFunction";
  	}

  	createTransitions = function (t, to, options, changedProperties, resolve) {

  		// Wait a beat (otherwise the target styles will be applied immediately)
  		// TODO use a fastdom-style mechanism?
  		setTimeout(function () {

  			var hashPrefix, jsTransitionsComplete, cssTransitionsComplete, checkComplete, transitionEndHandler;

  			checkComplete = function () {
  				if (jsTransitionsComplete && cssTransitionsComplete) {
  					// will changes to events and fire have an unexpected consequence here?
  					t.root.fire(t.name + ":end", t.node, t.isIntro);
  					resolve();
  				}
  			};

  			// this is used to keep track of which elements can use CSS to animate
  			// which properties
  			hashPrefix = (t.node.namespaceURI || "") + t.node.tagName;

  			t.node.style[TRANSITION_PROPERTY] = changedProperties.map(helpers_prefix).map(hyphenate).join(",");
  			t.node.style[TRANSITION_TIMING_FUNCTION] = hyphenate(options.easing || "linear");
  			t.node.style[TRANSITION_DURATION] = options.duration / 1000 + "s";

  			transitionEndHandler = function (event) {
  				var index;

  				index = changedProperties.indexOf(camelCase(unprefix(event.propertyName)));
  				if (index !== -1) {
  					changedProperties.splice(index, 1);
  				}

  				if (changedProperties.length) {
  					// still transitioning...
  					return;
  				}

  				t.node.removeEventListener(TRANSITIONEND, transitionEndHandler, false);

  				cssTransitionsComplete = true;
  				checkComplete();
  			};

  			t.node.addEventListener(TRANSITIONEND, transitionEndHandler, false);

  			setTimeout(function () {
  				var i = changedProperties.length,
  				    hash,
  				    originalValue,
  				    index,
  				    propertiesToTransitionInJs = [],
  				    prop,
  				    suffix;

  				while (i--) {
  					prop = changedProperties[i];
  					hash = hashPrefix + prop;

  					if (CSS_TRANSITIONS_ENABLED && !cannotUseCssTransitions[hash]) {
  						t.node.style[helpers_prefix(prop)] = to[prop];

  						// If we're not sure if CSS transitions are supported for
  						// this tag/property combo, find out now
  						if (!canUseCssTransitions[hash]) {
  							originalValue = t.getStyle(prop);

  							// if this property is transitionable in this browser,
  							// the current style will be different from the target style
  							canUseCssTransitions[hash] = t.getStyle(prop) != to[prop];
  							cannotUseCssTransitions[hash] = !canUseCssTransitions[hash];

  							// Reset, if we're going to use timers after all
  							if (cannotUseCssTransitions[hash]) {
  								t.node.style[helpers_prefix(prop)] = originalValue;
  							}
  						}
  					}

  					if (!CSS_TRANSITIONS_ENABLED || cannotUseCssTransitions[hash]) {
  						// we need to fall back to timer-based stuff
  						if (originalValue === undefined) {
  							originalValue = t.getStyle(prop);
  						}

  						// need to remove this from changedProperties, otherwise transitionEndHandler
  						// will get confused
  						index = changedProperties.indexOf(prop);
  						if (index === -1) {
  							warnIfDebug("Something very strange happened with transitions. Please raise an issue at https://github.com/ractivejs/ractive/issues - thanks!", { node: t.node });
  						} else {
  							changedProperties.splice(index, 1);
  						}

  						// TODO Determine whether this property is animatable at all

  						suffix = /[^\d]*$/.exec(to[prop])[0];

  						// ...then kick off a timer-based transition
  						propertiesToTransitionInJs.push({
  							name: helpers_prefix(prop),
  							interpolator: shared_interpolate(parseFloat(originalValue), parseFloat(to[prop])),
  							suffix: suffix
  						});
  					}
  				}

  				// javascript transitions
  				if (propertiesToTransitionInJs.length) {
  					new shared_Ticker({
  						root: t.root,
  						duration: options.duration,
  						easing: camelCase(options.easing || ""),
  						step: function (pos) {
  							var prop, i;

  							i = propertiesToTransitionInJs.length;
  							while (i--) {
  								prop = propertiesToTransitionInJs[i];
  								t.node.style[prop.name] = prop.interpolator(pos) + prop.suffix;
  							}
  						},
  						complete: function () {
  							jsTransitionsComplete = true;
  							checkComplete();
  						}
  					});
  				} else {
  					jsTransitionsComplete = true;
  				}

  				if (!changedProperties.length) {
  					// We need to cancel the transitionEndHandler, and deal with
  					// the fact that it will never fire
  					t.node.removeEventListener(TRANSITIONEND, transitionEndHandler, false);
  					cssTransitionsComplete = true;
  					checkComplete();
  				}
  			}, 0);
  		}, options.delay || 0);
  	};
  }

  var animateStyle_createTransitions = createTransitions;

  var hidden, vendor, animateStyle_visibility__prefix, animateStyle_visibility__i, visibility;

  if (typeof document !== "undefined") {
  	hidden = "hidden";

  	visibility = {};

  	if (hidden in document) {
  		animateStyle_visibility__prefix = "";
  	} else {
  		animateStyle_visibility__i = vendors.length;
  		while (animateStyle_visibility__i--) {
  			vendor = vendors[animateStyle_visibility__i];
  			hidden = vendor + "Hidden";

  			if (hidden in document) {
  				animateStyle_visibility__prefix = vendor;
  			}
  		}
  	}

  	if (animateStyle_visibility__prefix !== undefined) {
  		document.addEventListener(animateStyle_visibility__prefix + "visibilitychange", onChange);

  		// initialise
  		onChange();
  	} else {
  		// gah, we're in an old browser
  		if ("onfocusout" in document) {
  			document.addEventListener("focusout", onHide);
  			document.addEventListener("focusin", onShow);
  		} else {
  			window.addEventListener("pagehide", onHide);
  			window.addEventListener("blur", onHide);

  			window.addEventListener("pageshow", onShow);
  			window.addEventListener("focus", onShow);
  		}

  		visibility.hidden = false; // until proven otherwise. Not ideal but hey
  	}
  }

  function onChange() {
  	visibility.hidden = document[hidden];
  }

  function onHide() {
  	visibility.hidden = true;
  }

  function onShow() {
  	visibility.hidden = false;
  }

  var animateStyle_visibility = visibility;

  var animateStyle, _animateStyle__getComputedStyle, resolved;

  if (!isClient) {
  	animateStyle = null;
  } else {
  	_animateStyle__getComputedStyle = window.getComputedStyle || legacy.getComputedStyle;

  	animateStyle = function (style, value, options) {
  		var _this = this;

  		var to;

  		if (arguments.length === 4) {
  			throw new Error("t.animateStyle() returns a promise - use .then() instead of passing a callback");
  		}

  		// Special case - page isn't visible. Don't animate anything, because
  		// that way you'll never get CSS transitionend events
  		if (animateStyle_visibility.hidden) {
  			this.setStyle(style, value);
  			return resolved || (resolved = utils_Promise.resolve());
  		}

  		if (typeof style === "string") {
  			to = {};
  			to[style] = value;
  		} else {
  			to = style;

  			// shuffle arguments
  			options = value;
  		}

  		// As of 0.3.9, transition authors should supply an `option` object with
  		// `duration` and `easing` properties (and optional `delay`), plus a
  		// callback function that gets called after the animation completes

  		// TODO remove this check in a future version
  		if (!options) {
  			warnOnceIfDebug("The \"%s\" transition does not supply an options object to `t.animateStyle()`. This will break in a future version of Ractive. For more info see https://github.com/RactiveJS/Ractive/issues/340", this.name);
  			options = this;
  		}

  		var promise = new utils_Promise(function (resolve) {
  			var propertyNames, changedProperties, computedStyle, current, from, i, prop;

  			// Edge case - if duration is zero, set style synchronously and complete
  			if (!options.duration) {
  				_this.setStyle(to);
  				resolve();
  				return;
  			}

  			// Get a list of the properties we're animating
  			propertyNames = Object.keys(to);
  			changedProperties = [];

  			// Store the current styles
  			computedStyle = _animateStyle__getComputedStyle(_this.node);

  			from = {};
  			i = propertyNames.length;
  			while (i--) {
  				prop = propertyNames[i];
  				current = computedStyle[helpers_prefix(prop)];

  				if (current === "0px") {
  					current = 0;
  				}

  				// we need to know if we're actually changing anything
  				if (current != to[prop]) {
  					// use != instead of !==, so we can compare strings with numbers
  					changedProperties.push(prop);

  					// make the computed style explicit, so we can animate where
  					// e.g. height='auto'
  					_this.node.style[helpers_prefix(prop)] = current;
  				}
  			}

  			// If we're not actually changing anything, the transitionend event
  			// will never fire! So we complete early
  			if (!changedProperties.length) {
  				resolve();
  				return;
  			}

  			animateStyle_createTransitions(_this, to, options, changedProperties, resolve);
  		});

  		return promise;
  	};
  }

  var _animateStyle = animateStyle;

  var processParams = function (params, defaults) {
  	if (typeof params === "number") {
  		params = { duration: params };
  	} else if (typeof params === "string") {
  		if (params === "slow") {
  			params = { duration: 600 };
  		} else if (params === "fast") {
  			params = { duration: 200 };
  		} else {
  			params = { duration: 400 };
  		}
  	} else if (!params) {
  		params = {};
  	}

  	return fillGaps({}, params, defaults);
  };

  var prototype_start = Transition$start;

  function Transition$start() {
  	var _this = this;

  	var node, originalStyle, completed;

  	node = this.node = this.element.node;
  	originalStyle = node.getAttribute("style");

  	// create t.complete() - we don't want this on the prototype,
  	// because we don't want `this` silliness when passing it as
  	// an argument
  	this.complete = function (noReset) {
  		if (completed) {
  			return;
  		}

  		if (!noReset && _this.isIntro) {
  			resetStyle(node, originalStyle);
  		}

  		node._ractive.transition = null;
  		_this._manager.remove(_this);

  		completed = true;
  	};

  	// If the transition function doesn't exist, abort
  	if (!this._fn) {
  		this.complete();
  		return;
  	}

  	this._fn.apply(this.root, [this].concat(this.params));
  }

  function resetStyle(node, style) {
  	if (style) {
  		node.setAttribute("style", style);
  	} else {

  		// Next line is necessary, to remove empty style attribute!
  		// See http://stackoverflow.com/a/7167553
  		node.getAttribute("style");
  		node.removeAttribute("style");
  	}
  }

  var Transition = function (owner, template, isIntro) {
  	this.init(owner, template, isIntro);
  };

  Transition.prototype = {
  	init: Transition_prototype_init,
  	start: prototype_start,
  	getStyle: prototype_getStyle,
  	setStyle: setStyle,
  	animateStyle: _animateStyle,
  	processParams: processParams
  };

  var _Transition = Transition;

  var Element_prototype_render = Element$render;

  var updateCss, updateScript;

  updateCss = function () {
  	var node = this.node,
  	    content = this.fragment.toString(false);

  	// IE8 has no styleSheet unless there's a type text/css
  	if (window && window.appearsToBeIELessEqual8) {
  		node.type = "text/css";
  	}

  	if (node.styleSheet) {
  		node.styleSheet.cssText = content;
  	} else {

  		while (node.hasChildNodes()) {
  			node.removeChild(node.firstChild);
  		}

  		node.appendChild(document.createTextNode(content));
  	}
  };

  updateScript = function () {
  	if (!this.node.type || this.node.type === "text/javascript") {
  		warnIfDebug("Script tag was updated. This does not cause the code to be re-evaluated!", { ractive: this.root });
  		// As it happens, we ARE in a position to re-evaluate the code if we wanted
  		// to - we could eval() it, or insert it into a fresh (temporary) script tag.
  		// But this would be a terrible idea with unpredictable results, so let's not.
  	}

  	this.node.text = this.fragment.toString(false);
  };
  function Element$render() {
  	var _this = this;

  	var root = this.root,
  	    namespace,
  	    node,
  	    transition;

  	namespace = getNamespace(this);
  	node = this.node = createElement(this.name, namespace);

  	// Is this a top-level node of a component? If so, we may need to add
  	// a data-ractive-css attribute, for CSS encapsulation
  	if (this.parentFragment.cssIds) {
  		this.node.setAttribute("data-ractive-css", this.parentFragment.cssIds.map(function (x) {
  			return "{" + x + "}";
  		}).join(" "));
  	}

  	// Add _ractive property to the node - we use this object to store stuff
  	// related to proxy events, two-way bindings etc
  	defineProperty(this.node, "_ractive", {
  		value: {
  			proxy: this,
  			keypath: getInnerContext(this.parentFragment),
  			events: create(null),
  			root: root
  		}
  	});

  	// Render attributes
  	this.attributes.forEach(function (a) {
  		return a.render(node);
  	});
  	this.conditionalAttributes.forEach(function (a) {
  		return a.render(node);
  	});

  	// Render children
  	if (this.fragment) {
  		// Special case - <script> element
  		if (this.name === "script") {
  			this.bubble = updateScript;
  			this.node.text = this.fragment.toString(false); // bypass warning initially
  			this.fragment.unrender = noop; // TODO this is a kludge
  		}

  		// Special case - <style> element
  		else if (this.name === "style") {
  			this.bubble = updateCss;
  			this.bubble();
  			this.fragment.unrender = noop;
  		}

  		// Special case - contenteditable
  		else if (this.binding && this.getAttribute("contenteditable")) {
  			this.fragment.unrender = noop;
  		} else {
  			this.node.appendChild(this.fragment.render());
  		}
  	}

  	// deal with two-way bindings
  	if (this.binding) {
  		this.binding.render();
  		this.node._ractive.binding = this.binding;
  	}

  	// Add proxy event handlers
  	if (this.eventHandlers) {
  		this.eventHandlers.forEach(function (h) {
  			return h.render();
  		});
  	}

  	if (this.name === "option") {
  		processOption(this);
  	}

  	// Special cases
  	if (this.name === "img") {
  		// if this is an <img>, and we're in a crap browser, we may
  		// need to prevent it from overriding width and height when
  		// it loads the src
  		special_img__render(this);
  	} else if (this.name === "form") {
  		// forms need to keep track of their bindings, in case of reset
  		form__render(this);
  	} else if (this.name === "input" || this.name === "textarea") {
  		// inputs and textareas should store their initial value as
  		// `defaultValue` in case of reset
  		this.node.defaultValue = this.node.value;
  	} else if (this.name === "option") {
  		// similarly for option nodes
  		this.node.defaultSelected = this.node.selected;
  	}

  	// apply decorator(s)
  	if (this.decorator && this.decorator.fn) {
  		global_runloop.scheduleTask(function () {
  			if (!_this.decorator.torndown) {
  				_this.decorator.init();
  			}
  		}, true);
  	}

  	// trigger intro transition
  	if (root.transitionsEnabled && this.intro) {
  		transition = new _Transition(this, this.intro, true);
  		global_runloop.registerTransition(transition);
  		global_runloop.scheduleTask(function () {
  			return transition.start();
  		}, true);

  		this.transition = transition;
  	}

  	if (this.node.autofocus) {
  		// Special case. Some browsers (*cough* Firefix *cough*) have a problem
  		// with dynamically-generated elements having autofocus, and they won't
  		// allow you to programmatically focus the element until it's in the DOM
  		global_runloop.scheduleTask(function () {
  			return _this.node.focus();
  		}, true);
  	}

  	updateLiveQueries(this);
  	return this.node;
  }

  function getNamespace(element) {
  	var namespace, xmlns, parent;

  	// Use specified namespace...
  	if (xmlns = element.getAttribute("xmlns")) {
  		namespace = xmlns;
  	}

  	// ...or SVG namespace, if this is an <svg> element
  	else if (element.name === "svg") {
  		namespace = namespaces.svg;
  	} else if (parent = element.parent) {
  		// ...or HTML, if the parent is a <foreignObject>
  		if (parent.name === "foreignObject") {
  			namespace = namespaces.html;
  		}

  		// ...or inherit from the parent node
  		else {
  			namespace = parent.node.namespaceURI;
  		}
  	} else {
  		namespace = element.root.el.namespaceURI;
  	}

  	return namespace;
  }

  function processOption(option) {
  	var optionValue, selectValue, i;

  	if (!option.select) {
  		return;
  	}

  	selectValue = option.select.getAttribute("value");
  	if (selectValue === undefined) {
  		return;
  	}

  	optionValue = option.getAttribute("value");

  	if (option.select.node.multiple && isArray(selectValue)) {
  		i = selectValue.length;
  		while (i--) {
  			if (optionValue == selectValue[i]) {
  				option.node.selected = true;
  				break;
  			}
  		}
  	} else {
  		option.node.selected = optionValue == selectValue;
  	}
  }

  function updateLiveQueries(element) {
  	var instance, liveQueries, i, selector, query;

  	// Does this need to be added to any live queries?
  	instance = element.root;

  	do {
  		liveQueries = instance._liveQueries;

  		i = liveQueries.length;
  		while (i--) {
  			selector = liveQueries[i];
  			query = liveQueries["_" + selector];

  			if (query._test(element)) {
  				// keep register of applicable selectors, for when we teardown
  				(element.liveQueries || (element.liveQueries = [])).push(query);
  			}
  		}
  	} while (instance = instance.parent);
  }

  var Element_prototype_toString = function () {
  	var str, escape;

  	if (this.template.y) {
  		// DOCTYPE declaration
  		return "<!DOCTYPE" + this.template.dd + ">";
  	}

  	str = "<" + this.template.e;

  	str += this.attributes.map(stringifyAttribute).join("") + this.conditionalAttributes.map(stringifyAttribute).join("");

  	// Special case - selected options
  	if (this.name === "option" && optionIsSelected(this)) {
  		str += " selected";
  	}

  	// Special case - two-way radio name bindings
  	if (this.name === "input" && inputIsCheckedRadio(this)) {
  		str += " checked";
  	}

  	str += ">";

  	// Special case - textarea
  	if (this.name === "textarea" && this.getAttribute("value") !== undefined) {
  		str += escapeHtml(this.getAttribute("value"));
  	}

  	// Special case - contenteditable
  	else if (this.getAttribute("contenteditable") !== undefined) {
  		str += this.getAttribute("value") || "";
  	}

  	if (this.fragment) {
  		escape = this.name !== "script" && this.name !== "style";
  		str += this.fragment.toString(escape);
  	}

  	// add a closing tag if this isn't a void element
  	if (!voidElementNames.test(this.template.e)) {
  		str += "</" + this.template.e + ">";
  	}

  	return str;
  };

  function optionIsSelected(element) {
  	var optionValue, selectValue, i;

  	optionValue = element.getAttribute("value");

  	if (optionValue === undefined || !element.select) {
  		return false;
  	}

  	selectValue = element.select.getAttribute("value");

  	if (selectValue == optionValue) {
  		return true;
  	}

  	if (element.select.getAttribute("multiple") && isArray(selectValue)) {
  		i = selectValue.length;
  		while (i--) {
  			if (selectValue[i] == optionValue) {
  				return true;
  			}
  		}
  	}
  }

  function inputIsCheckedRadio(element) {
  	var attributes, typeAttribute, valueAttribute, nameAttribute;

  	attributes = element.attributes;

  	typeAttribute = attributes.type;
  	valueAttribute = attributes.value;
  	nameAttribute = attributes.name;

  	if (!typeAttribute || typeAttribute.value !== "radio" || !valueAttribute || !nameAttribute.interpolator) {
  		return;
  	}

  	if (valueAttribute.value === nameAttribute.interpolator.value) {
  		return true;
  	}
  }

  function stringifyAttribute(attribute) {
  	var str = attribute.toString();
  	return str ? " " + str : "";
  }

  var Element_prototype_unbind = Element$unbind;
  function Element$unbind() {
  	if (this.fragment) {
  		this.fragment.unbind();
  	}

  	if (this.binding) {
  		this.binding.unbind();
  	}

  	if (this.eventHandlers) {
  		this.eventHandlers.forEach(methodCallers__unbind);
  	}

  	// Special case - <option>
  	if (this.name === "option") {
  		special_option__unbind(this);
  	}

  	this.attributes.forEach(methodCallers__unbind);
  	this.conditionalAttributes.forEach(methodCallers__unbind);
  }

  var Element_prototype_unrender = Element$unrender;

  function Element$unrender(shouldDestroy) {
  	var binding, bindings, transition;

  	if (transition = this.transition) {
  		transition.complete();
  	}

  	// Detach as soon as we can
  	if (this.name === "option") {
  		// <option> elements detach immediately, so that
  		// their parent <select> element syncs correctly, and
  		// since option elements can't have transitions anyway
  		this.detach();
  	} else if (shouldDestroy) {
  		global_runloop.detachWhenReady(this);
  	}

  	// Children first. that way, any transitions on child elements will be
  	// handled by the current transitionManager
  	if (this.fragment) {
  		this.fragment.unrender(false);
  	}

  	if (binding = this.binding) {
  		this.binding.unrender();

  		this.node._ractive.binding = null;
  		bindings = this.root._twowayBindings[binding.keypath.str];
  		bindings.splice(bindings.indexOf(binding), 1);
  	}

  	// Remove event handlers
  	if (this.eventHandlers) {
  		this.eventHandlers.forEach(methodCallers__unrender);
  	}

  	if (this.decorator) {
  		global_runloop.registerDecorator(this.decorator);
  	}

  	// trigger outro transition if necessary
  	if (this.root.transitionsEnabled && this.outro) {
  		transition = new _Transition(this, this.outro, false);
  		global_runloop.registerTransition(transition);
  		global_runloop.scheduleTask(function () {
  			return transition.start();
  		});
  	}

  	// Remove this node from any live queries
  	if (this.liveQueries) {
  		removeFromLiveQueries(this);
  	}

  	if (this.name === "form") {
  		form__unrender(this);
  	}
  }

  function removeFromLiveQueries(element) {
  	var query, selector, i;

  	i = element.liveQueries.length;
  	while (i--) {
  		query = element.liveQueries[i];
  		selector = query.selector;

  		query._remove(element.node);
  	}
  }

  var Element = function (options) {
  	this.init(options);
  };

  Element.prototype = {
  	bubble: Element_prototype_bubble,
  	detach: Element_prototype_detach,
  	find: Element_prototype_find,
  	findAll: Element_prototype_findAll,
  	findAllComponents: Element_prototype_findAllComponents,
  	findComponent: Element_prototype_findComponent,
  	findNextNode: Element_prototype_findNextNode,
  	firstNode: Element_prototype_firstNode,
  	getAttribute: getAttribute,
  	init: Element_prototype_init,
  	rebind: Element_prototype_rebind,
  	render: Element_prototype_render,
  	toString: Element_prototype_toString,
  	unbind: Element_prototype_unbind,
  	unrender: Element_prototype_unrender
  };

  var _Element = Element;

  var deIndent__empty = /^\s*$/,
      deIndent__leadingWhitespace = /^\s*/;

  var deIndent = function (str) {
  	var lines, firstLine, lastLine, minIndent;

  	lines = str.split("\n");

  	// remove first and last line, if they only contain whitespace
  	firstLine = lines[0];
  	if (firstLine !== undefined && deIndent__empty.test(firstLine)) {
  		lines.shift();
  	}

  	lastLine = lastItem(lines);
  	if (lastLine !== undefined && deIndent__empty.test(lastLine)) {
  		lines.pop();
  	}

  	minIndent = lines.reduce(reducer, null);

  	if (minIndent) {
  		str = lines.map(function (line) {
  			return line.replace(minIndent, "");
  		}).join("\n");
  	}

  	return str;
  };

  function reducer(previous, line) {
  	var lineIndent = deIndent__leadingWhitespace.exec(line)[0];

  	if (previous === null || lineIndent.length < previous.length) {
  		return lineIndent;
  	}

  	return previous;
  }

  var Partial_getPartialTemplate = getPartialTemplate;

  function getPartialTemplate(ractive, name, parentFragment) {
  	var partial;

  	// If the partial in instance or view heirarchy instances, great
  	if (partial = getPartialFromRegistry(ractive, name, parentFragment || {})) {
  		return partial;
  	}

  	// Does it exist on the page as a script tag?
  	partial = template_parser.fromId(name, { noThrow: true });

  	if (partial) {
  		// is this necessary?
  		partial = deIndent(partial);

  		// parse and register to this ractive instance
  		var parsed = template_parser.parse(partial, template_parser.getParseOptions(ractive));

  		// register (and return main partial if there are others in the template)
  		return ractive.partials[name] = parsed.t;
  	}
  }

  function getPartialFromRegistry(ractive, name, parentFragment) {
  	var fn = undefined,
  	    partial = findParentPartial(name, parentFragment.owner);

  	// if there was an instance up-hierarchy, cool
  	if (partial) return partial;

  	// find first instance in the ractive or view hierarchy that has this partial
  	var instance = findInstance("partials", ractive, name);

  	if (!instance) {
  		return;
  	}

  	partial = instance.partials[name];

  	// partial is a function?
  	if (typeof partial === "function") {
  		fn = partial.bind(instance);
  		fn.isOwner = instance.partials.hasOwnProperty(name);
  		partial = fn.call(ractive, template_parser);
  	}

  	if (!partial && partial !== "") {
  		warnIfDebug(noRegistryFunctionReturn, name, "partial", "partial", { ractive: ractive });
  		return;
  	}

  	// If this was added manually to the registry,
  	// but hasn't been parsed, parse it now
  	if (!template_parser.isParsed(partial)) {

  		// use the parseOptions of the ractive instance on which it was found
  		var parsed = template_parser.parse(partial, template_parser.getParseOptions(instance));

  		// Partials cannot contain nested partials!
  		// TODO add a test for this
  		if (parsed.p) {
  			warnIfDebug("Partials ({{>%s}}) cannot contain nested inline partials", name, { ractive: ractive });
  		}

  		// if fn, use instance to store result, otherwise needs to go
  		// in the correct point in prototype chain on instance or constructor
  		var target = fn ? instance : findOwner(instance, name);

  		// may be a template with partials, which need to be registered and main template extracted
  		target.partials[name] = partial = parsed.t;
  	}

  	// store for reset
  	if (fn) {
  		partial._fn = fn;
  	}

  	return partial.v ? partial.t : partial;
  }

  function findOwner(ractive, key) {
  	return ractive.partials.hasOwnProperty(key) ? ractive : findConstructor(ractive.constructor, key);
  }

  function findConstructor(constructor, key) {
  	if (!constructor) {
  		return;
  	}
  	return constructor.partials.hasOwnProperty(key) ? constructor : findConstructor(constructor._Parent, key);
  }

  function findParentPartial(name, parent) {
  	if (parent) {
  		if (parent.template && parent.template.p && parent.template.p[name]) {
  			return parent.template.p[name];
  		} else if (parent.parentFragment && parent.parentFragment.owner) {
  			return findParentPartial(name, parent.parentFragment.owner);
  		}
  	}
  }

  var applyIndent = function (string, indent) {
  	var indented;

  	if (!indent) {
  		return string;
  	}

  	indented = string.split("\n").map(function (line, notFirstLine) {
  		return notFirstLine ? indent + line : line;
  	}).join("\n");

  	return indented;
  };

  var missingPartialMessage = "Could not find template for partial \"%s\"";

  var Partial = function (options) {
  	var parentFragment, template;

  	parentFragment = this.parentFragment = options.parentFragment;

  	this.root = parentFragment.root;
  	this.type = PARTIAL;
  	this.index = options.index;
  	this.name = options.template.r;
  	this.rendered = false;

  	this.fragment = this.fragmentToRender = this.fragmentToUnrender = null;

  	Mustache.init(this, options);

  	// If this didn't resolve, it most likely means we have a named partial
  	// (i.e. `{{>foo}}` means 'use the foo partial', not 'use the partial
  	// whose name is the value of `foo`')
  	if (!this.keypath) {
  		if (template = Partial_getPartialTemplate(this.root, this.name, parentFragment)) {
  			shared_unbind.call(this); // prevent any further changes
  			this.isNamed = true;
  			this.setTemplate(template);
  		} else {
  			warnOnceIfDebug(missingPartialMessage, this.name);
  		}
  	}
  };

  Partial.prototype = {
  	bubble: function () {
  		this.parentFragment.bubble();
  	},

  	detach: function () {
  		return this.fragment.detach();
  	},

  	find: function (selector) {
  		return this.fragment.find(selector);
  	},

  	findAll: function (selector, query) {
  		return this.fragment.findAll(selector, query);
  	},

  	findComponent: function (selector) {
  		return this.fragment.findComponent(selector);
  	},

  	findAllComponents: function (selector, query) {
  		return this.fragment.findAllComponents(selector, query);
  	},

  	firstNode: function () {
  		return this.fragment.firstNode();
  	},

  	findNextNode: function () {
  		return this.parentFragment.findNextNode(this);
  	},

  	getPartialName: function () {
  		if (this.isNamed && this.name) return this.name;else if (this.value === undefined) return this.name;else return this.value;
  	},

  	getValue: function () {
  		return this.fragment.getValue();
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		// named partials aren't bound, so don't rebind
  		if (!this.isNamed) {
  			Mustache_rebind.call(this, oldKeypath, newKeypath);
  		}

  		if (this.fragment) {
  			this.fragment.rebind(oldKeypath, newKeypath);
  		}
  	},

  	render: function () {
  		this.docFrag = document.createDocumentFragment();
  		this.update();

  		this.rendered = true;
  		return this.docFrag;
  	},

  	resolve: Mustache.resolve,

  	setValue: function (value) {
  		var template;

  		if (value !== undefined && value === this.value) {
  			// nothing has changed, so no work to be done
  			return;
  		}

  		if (value !== undefined) {
  			template = Partial_getPartialTemplate(this.root, "" + value, this.parentFragment);
  		}

  		// we may be here if we have a partial like `{{>foo}}` and `foo` is the
  		// name of both a data property (whose value ISN'T the name of a partial)
  		// and a partial. In those cases, this becomes a named partial
  		if (!template && this.name && (template = Partial_getPartialTemplate(this.root, this.name, this.parentFragment))) {
  			shared_unbind.call(this);
  			this.isNamed = true;
  		}

  		if (!template) {
  			warnOnceIfDebug(missingPartialMessage, this.name, { ractive: this.root });
  		}

  		this.value = value;

  		this.setTemplate(template || []);

  		this.bubble();

  		if (this.rendered) {
  			global_runloop.addView(this);
  		}
  	},

  	setTemplate: function (template) {
  		if (this.fragment) {
  			this.fragment.unbind();
  			if (this.rendered) {
  				this.fragmentToUnrender = this.fragment;
  			}
  		}

  		this.fragment = new virtualdom_Fragment({
  			template: template,
  			root: this.root,
  			owner: this,
  			pElement: this.parentFragment.pElement
  		});

  		this.fragmentToRender = this.fragment;
  	},

  	toString: function (toString) {
  		var string, previousItem, lastLine, match;

  		string = this.fragment.toString(toString);

  		previousItem = this.parentFragment.items[this.index - 1];

  		if (!previousItem || previousItem.type !== TEXT) {
  			return string;
  		}

  		lastLine = previousItem.text.split("\n").pop();

  		if (match = /^\s+$/.exec(lastLine)) {
  			return applyIndent(string, match[0]);
  		}

  		return string;
  	},

  	unbind: function () {
  		if (!this.isNamed) {
  			// dynamic partial - need to unbind self
  			shared_unbind.call(this);
  		}

  		if (this.fragment) {
  			this.fragment.unbind();
  		}
  	},

  	unrender: function (shouldDestroy) {
  		if (this.rendered) {
  			if (this.fragment) {
  				this.fragment.unrender(shouldDestroy);
  			}
  			this.rendered = false;
  		}
  	},

  	update: function () {
  		var target, anchor;

  		if (this.fragmentToUnrender) {
  			this.fragmentToUnrender.unrender(true);
  			this.fragmentToUnrender = null;
  		}

  		if (this.fragmentToRender) {
  			this.docFrag.appendChild(this.fragmentToRender.render());
  			this.fragmentToRender = null;
  		}

  		if (this.rendered) {
  			target = this.parentFragment.getNode();
  			anchor = this.parentFragment.findNextNode(this);
  			target.insertBefore(this.docFrag, anchor);
  		}
  	}
  };

  var _Partial = Partial;

  // finds the component constructor in the registry or view hierarchy registries

  var Component_getComponent = getComponent;
  function getComponent(ractive, name) {

  	var Component,
  	    instance = findInstance("components", ractive, name);

  	if (instance) {
  		Component = instance.components[name];

  		// best test we have for not Ractive.extend
  		if (!Component._Parent) {
  			// function option, execute and store for reset
  			var fn = Component.bind(instance);
  			fn.isOwner = instance.components.hasOwnProperty(name);
  			Component = fn();

  			if (!Component) {
  				warnIfDebug(noRegistryFunctionReturn, name, "component", "component", { ractive: ractive });

  				return;
  			}

  			if (typeof Component === "string") {
  				// allow string lookup
  				Component = getComponent(ractive, Component);
  			}

  			Component._fn = fn;
  			instance.components[name] = Component;
  		}
  	}

  	return Component;
  }

  var Component_prototype_detach = Component$detach;
  var Component_prototype_detach__detachHook = new hooks_Hook("detach");
  function Component$detach() {
  	var detached = this.instance.fragment.detach();
  	Component_prototype_detach__detachHook.fire(this.instance);
  	return detached;
  }

  var Component_prototype_find = Component$find;

  function Component$find(selector) {
  	return this.instance.fragment.find(selector);
  }

  var Component_prototype_findAll = Component$findAll;

  function Component$findAll(selector, query) {
  	return this.instance.fragment.findAll(selector, query);
  }

  var Component_prototype_findAllComponents = Component$findAllComponents;

  function Component$findAllComponents(selector, query) {
  	query._test(this, true);

  	if (this.instance.fragment) {
  		this.instance.fragment.findAllComponents(selector, query);
  	}
  }

  var Component_prototype_findComponent = Component$findComponent;

  function Component$findComponent(selector) {
  	if (!selector || selector === this.name) {
  		return this.instance;
  	}

  	if (this.instance.fragment) {
  		return this.instance.fragment.findComponent(selector);
  	}

  	return null;
  }

  var Component_prototype_findNextNode = Component$findNextNode;

  function Component$findNextNode() {
  	return this.parentFragment.findNextNode(this);
  }

  var Component_prototype_firstNode = Component$firstNode;

  function Component$firstNode() {
  	if (this.rendered) {
  		return this.instance.fragment.firstNode();
  	}

  	return null;
  }

  var processWrapper = function (wrapper, array, methodName, newIndices) {
  	var root = wrapper.root;
  	var keypath = wrapper.keypath;

  	if (!!newIndices) {
  		root.viewmodel.smartUpdate(keypath, array, newIndices);
  	} else {
  		// If this is a sort or reverse, we just do root.set()...
  		// TODO use merge logic?
  		root.viewmodel.mark(keypath);
  	}
  };

  var patchedArrayProto = [],
      mutatorMethods = ["pop", "push", "reverse", "shift", "sort", "splice", "unshift"],
      testObj,
      patchArrayMethods,
      unpatchArrayMethods;

  mutatorMethods.forEach(function (methodName) {
  	var method = function () {
  		for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
  			args[_key] = arguments[_key];
  		}

  		var newIndices, result, wrapper, i;

  		newIndices = shared_getNewIndices(this, methodName, args);

  		// apply the underlying method
  		result = Array.prototype[methodName].apply(this, arguments);

  		// trigger changes
  		global_runloop.start();

  		this._ractive.setting = true;
  		i = this._ractive.wrappers.length;
  		while (i--) {
  			wrapper = this._ractive.wrappers[i];

  			global_runloop.addRactive(wrapper.root);
  			processWrapper(wrapper, this, methodName, newIndices);
  		}

  		global_runloop.end();

  		this._ractive.setting = false;
  		return result;
  	};

  	defineProperty(patchedArrayProto, methodName, {
  		value: method
  	});
  });

  // can we use prototype chain injection?
  // http://perfectionkills.com/how-ecmascript-5-still-does-not-allow-to-subclass-an-array/#wrappers_prototype_chain_injection
  testObj = {};

  if (testObj.__proto__) {
  	// yes, we can
  	patchArrayMethods = function (array) {
  		array.__proto__ = patchedArrayProto;
  	};

  	unpatchArrayMethods = function (array) {
  		array.__proto__ = Array.prototype;
  	};
  } else {
  	// no, we can't
  	patchArrayMethods = function (array) {
  		var i, methodName;

  		i = mutatorMethods.length;
  		while (i--) {
  			methodName = mutatorMethods[i];
  			defineProperty(array, methodName, {
  				value: patchedArrayProto[methodName],
  				configurable: true
  			});
  		}
  	};

  	unpatchArrayMethods = function (array) {
  		var i;

  		i = mutatorMethods.length;
  		while (i--) {
  			delete array[mutatorMethods[i]];
  		}
  	};
  }

  patchArrayMethods.unpatch = unpatchArrayMethods;
  var patch = patchArrayMethods;

  var arrayAdaptor,

  // helpers
  ArrayWrapper, array_index__errorMessage;

  arrayAdaptor = {
  	filter: function (object) {
  		// wrap the array if a) b) it's an array, and b) either it hasn't been wrapped already,
  		// or the array didn't trigger the get() itself
  		return isArray(object) && (!object._ractive || !object._ractive.setting);
  	},
  	wrap: function (ractive, array, keypath) {
  		return new ArrayWrapper(ractive, array, keypath);
  	}
  };

  ArrayWrapper = function (ractive, array, keypath) {
  	this.root = ractive;
  	this.value = array;
  	this.keypath = getKeypath(keypath);

  	// if this array hasn't already been ractified, ractify it
  	if (!array._ractive) {

  		// define a non-enumerable _ractive property to store the wrappers
  		defineProperty(array, "_ractive", {
  			value: {
  				wrappers: [],
  				instances: [],
  				setting: false
  			},
  			configurable: true
  		});

  		patch(array);
  	}

  	// store the ractive instance, so we can handle transitions later
  	if (!array._ractive.instances[ractive._guid]) {
  		array._ractive.instances[ractive._guid] = 0;
  		array._ractive.instances.push(ractive);
  	}

  	array._ractive.instances[ractive._guid] += 1;
  	array._ractive.wrappers.push(this);
  };

  ArrayWrapper.prototype = {
  	get: function () {
  		return this.value;
  	},
  	teardown: function () {
  		var array, storage, wrappers, instances, index;

  		array = this.value;
  		storage = array._ractive;
  		wrappers = storage.wrappers;
  		instances = storage.instances;

  		// if teardown() was invoked because we're clearing the cache as a result of
  		// a change that the array itself triggered, we can save ourselves the teardown
  		// and immediate setup
  		if (storage.setting) {
  			return false; // so that we don't remove it from this.root.viewmodel.wrapped
  		}

  		index = wrappers.indexOf(this);
  		if (index === -1) {
  			throw new Error(array_index__errorMessage);
  		}

  		wrappers.splice(index, 1);

  		// if nothing else depends on this array, we can revert it to its
  		// natural state
  		if (!wrappers.length) {
  			delete array._ractive;
  			patch.unpatch(this.value);
  		} else {
  			// remove ractive instance if possible
  			instances[this.root._guid] -= 1;
  			if (!instances[this.root._guid]) {
  				index = instances.indexOf(this.root);

  				if (index === -1) {
  					throw new Error(array_index__errorMessage);
  				}

  				instances.splice(index, 1);
  			}
  		}
  	}
  };

  array_index__errorMessage = "Something went wrong in a rather interesting way";
  var array_index = arrayAdaptor;

  var numeric = /^\s*[0-9]+\s*$/;

  var createBranch = function (key) {
  	return numeric.test(key) ? [] : {};
  };

  var magicAdaptor, MagicWrapper;

  try {
  	Object.defineProperty({}, "test", { value: 0 });

  	magicAdaptor = {
  		filter: function (object, keypath, ractive) {
  			var parentWrapper, parentValue;

  			if (!keypath) {
  				return false;
  			}

  			keypath = getKeypath(keypath);

  			// If the parent value is a wrapper, other than a magic wrapper,
  			// we shouldn't wrap this property
  			if ((parentWrapper = ractive.viewmodel.wrapped[keypath.parent.str]) && !parentWrapper.magic) {
  				return false;
  			}

  			parentValue = ractive.viewmodel.get(keypath.parent);

  			// if parentValue is an array that doesn't include this member,
  			// we should return false otherwise lengths will get messed up
  			if (isArray(parentValue) && /^[0-9]+$/.test(keypath.lastKey)) {
  				return false;
  			}

  			return parentValue && (typeof parentValue === "object" || typeof parentValue === "function");
  		},
  		wrap: function (ractive, property, keypath) {
  			return new MagicWrapper(ractive, property, keypath);
  		}
  	};

  	MagicWrapper = function (ractive, value, keypath) {
  		var objKeypath, template, siblings;

  		keypath = getKeypath(keypath);

  		this.magic = true;

  		this.ractive = ractive;
  		this.keypath = keypath;
  		this.value = value;

  		this.prop = keypath.lastKey;

  		objKeypath = keypath.parent;
  		this.obj = objKeypath.isRoot ? ractive.viewmodel.data : ractive.viewmodel.get(objKeypath);

  		template = this.originalDescriptor = Object.getOwnPropertyDescriptor(this.obj, this.prop);

  		// Has this property already been wrapped?
  		if (template && template.set && (siblings = template.set._ractiveWrappers)) {

  			// Yes. Register this wrapper to this property, if it hasn't been already
  			if (siblings.indexOf(this) === -1) {
  				siblings.push(this);
  			}

  			return; // already wrapped
  		}

  		// No, it hasn't been wrapped
  		createAccessors(this, value, template);
  	};

  	MagicWrapper.prototype = {
  		get: function () {
  			return this.value;
  		},
  		reset: function (value) {
  			if (this.updating) {
  				return;
  			}

  			this.updating = true;
  			this.obj[this.prop] = value; // trigger set() accessor
  			global_runloop.addRactive(this.ractive);
  			this.ractive.viewmodel.mark(this.keypath, { keepExistingWrapper: true });
  			this.updating = false;
  			return true;
  		},
  		set: function (key, value) {
  			if (this.updating) {
  				return;
  			}

  			if (!this.obj[this.prop]) {
  				this.updating = true;
  				this.obj[this.prop] = createBranch(key);
  				this.updating = false;
  			}

  			this.obj[this.prop][key] = value;
  		},
  		teardown: function () {
  			var template, set, value, wrappers, index;

  			// If this method was called because the cache was being cleared as a
  			// result of a set()/update() call made by this wrapper, we return false
  			// so that it doesn't get torn down
  			if (this.updating) {
  				return false;
  			}

  			template = Object.getOwnPropertyDescriptor(this.obj, this.prop);
  			set = template && template.set;

  			if (!set) {
  				// most likely, this was an array member that was spliced out
  				return;
  			}

  			wrappers = set._ractiveWrappers;

  			index = wrappers.indexOf(this);
  			if (index !== -1) {
  				wrappers.splice(index, 1);
  			}

  			// Last one out, turn off the lights
  			if (!wrappers.length) {
  				value = this.obj[this.prop];

  				Object.defineProperty(this.obj, this.prop, this.originalDescriptor || {
  					writable: true,
  					enumerable: true,
  					configurable: true
  				});

  				this.obj[this.prop] = value;
  			}
  		}
  	};
  } catch (err) {
  	magicAdaptor = false; // no magic in this browser
  }

  var adaptors_magic = magicAdaptor;

  function createAccessors(originalWrapper, value, template) {

  	var object, property, oldGet, oldSet, get, set;

  	object = originalWrapper.obj;
  	property = originalWrapper.prop;

  	// Is this template configurable?
  	if (template && !template.configurable) {
  		// Special case - array length
  		if (property === "length") {
  			return;
  		}

  		throw new Error("Cannot use magic mode with property \"" + property + "\" - object is not configurable");
  	}

  	// Time to wrap this property
  	if (template) {
  		oldGet = template.get;
  		oldSet = template.set;
  	}

  	get = oldGet || function () {
  		return value;
  	};

  	set = function (v) {
  		if (oldSet) {
  			oldSet(v);
  		}

  		value = oldGet ? oldGet() : v;
  		set._ractiveWrappers.forEach(updateWrapper);
  	};

  	function updateWrapper(wrapper) {
  		var keypath, ractive;

  		wrapper.value = value;

  		if (wrapper.updating) {
  			return;
  		}

  		ractive = wrapper.ractive;
  		keypath = wrapper.keypath;

  		wrapper.updating = true;
  		global_runloop.start(ractive);

  		ractive.viewmodel.mark(keypath);

  		global_runloop.end();
  		wrapper.updating = false;
  	}

  	// Create an array of wrappers, in case other keypaths/ractives depend on this property.
  	// Handily, we can store them as a property of the set function. Yay JavaScript.
  	set._ractiveWrappers = [originalWrapper];
  	Object.defineProperty(object, property, { get: get, set: set, enumerable: true, configurable: true });
  }

  var magicArrayAdaptor, MagicArrayWrapper;

  if (adaptors_magic) {
  	magicArrayAdaptor = {
  		filter: function (object, keypath, ractive) {
  			return adaptors_magic.filter(object, keypath, ractive) && array_index.filter(object);
  		},

  		wrap: function (ractive, array, keypath) {
  			return new MagicArrayWrapper(ractive, array, keypath);
  		}
  	};

  	MagicArrayWrapper = function (ractive, array, keypath) {
  		this.value = array;

  		this.magic = true;

  		this.magicWrapper = adaptors_magic.wrap(ractive, array, keypath);
  		this.arrayWrapper = array_index.wrap(ractive, array, keypath);
  	};

  	MagicArrayWrapper.prototype = {
  		get: function () {
  			return this.value;
  		},
  		teardown: function () {
  			this.arrayWrapper.teardown();
  			this.magicWrapper.teardown();
  		},
  		reset: function (value) {
  			return this.magicWrapper.reset(value);
  		}
  	};
  }

  var magicArray = magicArrayAdaptor;

  var prototype_adapt = Viewmodel$adapt;

  var prefixers = {};
  function Viewmodel$adapt(keypath, value) {
  	var len, i, adaptor, wrapped;

  	if (!this.adaptors) return;

  	// Do we have an adaptor for this value?
  	len = this.adaptors.length;
  	for (i = 0; i < len; i += 1) {
  		adaptor = this.adaptors[i];

  		if (adaptor.filter(value, keypath, this.ractive)) {
  			wrapped = this.wrapped[keypath] = adaptor.wrap(this.ractive, value, keypath, getPrefixer(keypath));
  			wrapped.value = value;
  			return;
  		}
  	}
  }

  function prefixKeypath(obj, prefix) {
  	var prefixed = {},
  	    key;

  	if (!prefix) {
  		return obj;
  	}

  	prefix += ".";

  	for (key in obj) {
  		if (obj.hasOwnProperty(key)) {
  			prefixed[prefix + key] = obj[key];
  		}
  	}

  	return prefixed;
  }

  function getPrefixer(rootKeypath) {
  	var rootDot;

  	if (!prefixers[rootKeypath]) {
  		rootDot = rootKeypath ? rootKeypath + "." : "";

  		prefixers[rootKeypath] = function (relativeKeypath, value) {
  			var obj;

  			if (typeof relativeKeypath === "string") {
  				obj = {};
  				obj[rootDot + relativeKeypath] = value;
  				return obj;
  			}

  			if (typeof relativeKeypath === "object") {
  				// 'relativeKeypath' is in fact a hash, not a keypath
  				return rootDot ? prefixKeypath(relativeKeypath, rootKeypath) : relativeKeypath;
  			}
  		};
  	}

  	return prefixers[rootKeypath];
  }

  // TEMP

  var helpers_getUpstreamChanges = getUpstreamChanges;
  function getUpstreamChanges(changes) {
  	var upstreamChanges = [rootKeypath],
  	    i,
  	    keypath;

  	i = changes.length;
  	while (i--) {
  		keypath = changes[i].parent;

  		while (keypath && !keypath.isRoot) {
  			if (changes.indexOf(keypath) === -1) {
  				addToArray(upstreamChanges, keypath);
  			}
  			keypath = keypath.parent;
  		}
  	}

  	return upstreamChanges;
  }

  var applyChanges_notifyPatternObservers = notifyPatternObservers;

  function notifyPatternObservers(viewmodel, keypath, onlyDirect) {
  	var potentialWildcardMatches;

  	updateMatchingPatternObservers(viewmodel, keypath);

  	if (onlyDirect) {
  		return;
  	}

  	potentialWildcardMatches = keypath.wildcardMatches();
  	potentialWildcardMatches.forEach(function (upstreamPattern) {
  		cascade(viewmodel, upstreamPattern, keypath);
  	});
  }

  function cascade(viewmodel, upstreamPattern, keypath) {
  	var group, map, actualChildKeypath;

  	// TODO should be one or the other
  	upstreamPattern = upstreamPattern.str || upstreamPattern;

  	group = viewmodel.depsMap.patternObservers;
  	map = group && group[upstreamPattern];

  	if (!map) {
  		return;
  	}

  	map.forEach(function (childKeypath) {
  		actualChildKeypath = keypath.join(childKeypath.lastKey); // 'foo.bar.baz'

  		updateMatchingPatternObservers(viewmodel, actualChildKeypath);
  		cascade(viewmodel, childKeypath, actualChildKeypath);
  	});
  }

  function updateMatchingPatternObservers(viewmodel, keypath) {
  	viewmodel.patternObservers.forEach(function (observer) {
  		if (observer.regex.test(keypath.str)) {
  			observer.update(keypath);
  		}
  	});
  }

  var applyChanges = Viewmodel$applyChanges;

  function Viewmodel$applyChanges() {
  	var _this = this;

  	var self = this,
  	    changes,
  	    upstreamChanges,
  	    hash = {},
  	    bindings;

  	changes = this.changes;

  	if (!changes.length) {
  		// TODO we end up here on initial render. Perhaps we shouldn't?
  		return;
  	}

  	function invalidateComputation(computation) {
  		var key = computation.key;

  		if (computation.viewmodel === self) {
  			self.clearCache(key.str);
  			computation.invalidate();

  			changes.push(key);
  			cascade(key);
  		} else {
  			computation.viewmodel.mark(key);
  		}
  	}

  	function cascade(keypath) {
  		var map, computations;

  		if (self.noCascade.hasOwnProperty(keypath.str)) {
  			return;
  		}

  		if (computations = self.deps.computed[keypath.str]) {
  			computations.forEach(invalidateComputation);
  		}

  		if (map = self.depsMap.computed[keypath.str]) {
  			map.forEach(cascade);
  		}
  	}

  	changes.slice().forEach(cascade);

  	upstreamChanges = helpers_getUpstreamChanges(changes);
  	upstreamChanges.forEach(function (keypath) {
  		var computations;

  		// make sure we haven't already been down this particular keypath in this turn
  		if (changes.indexOf(keypath) === -1 && (computations = self.deps.computed[keypath.str])) {
  			computations.forEach(invalidateComputation);
  		}
  	});

  	this.changes = [];

  	// Pattern observers are a weird special case
  	if (this.patternObservers.length) {
  		upstreamChanges.forEach(function (keypath) {
  			return applyChanges_notifyPatternObservers(_this, keypath, true);
  		});
  		changes.forEach(function (keypath) {
  			return applyChanges_notifyPatternObservers(_this, keypath);
  		});
  	}

  	if (this.deps.observers) {
  		upstreamChanges.forEach(function (keypath) {
  			return notifyUpstreamDependants(_this, null, keypath, "observers");
  		});
  		notifyAllDependants(this, changes, "observers");
  	}

  	if (this.deps["default"]) {
  		bindings = [];
  		upstreamChanges.forEach(function (keypath) {
  			return notifyUpstreamDependants(_this, bindings, keypath, "default");
  		});

  		if (bindings.length) {
  			notifyBindings(this, bindings, changes);
  		}

  		notifyAllDependants(this, changes, "default");
  	}

  	// Return a hash of keypaths to updated values
  	changes.forEach(function (keypath) {
  		hash[keypath.str] = _this.get(keypath);
  	});

  	this.implicitChanges = {};
  	this.noCascade = {};

  	return hash;
  }

  function notifyUpstreamDependants(viewmodel, bindings, keypath, groupName) {
  	var dependants, value;

  	if (dependants = findDependants(viewmodel, keypath, groupName)) {
  		value = viewmodel.get(keypath);

  		dependants.forEach(function (d) {
  			// don't "set" the parent value, refine it
  			// i.e. not data = value, but data[foo] = fooValue
  			if (bindings && d.refineValue) {
  				bindings.push(d);
  			} else {
  				d.setValue(value);
  			}
  		});
  	}
  }

  function notifyBindings(viewmodel, bindings, changes) {

  	bindings.forEach(function (binding) {
  		var useSet = false,
  		    i = 0,
  		    length = changes.length,
  		    refinements = [];

  		while (i < length) {
  			var keypath = changes[i];

  			if (keypath === binding.keypath) {
  				useSet = true;
  				break;
  			}

  			if (keypath.slice(0, binding.keypath.length) === binding.keypath) {
  				refinements.push(keypath);
  			}

  			i++;
  		}

  		if (useSet) {
  			binding.setValue(viewmodel.get(binding.keypath));
  		}

  		if (refinements.length) {
  			binding.refineValue(refinements);
  		}
  	});
  }

  function notifyAllDependants(viewmodel, keypaths, groupName) {
  	var queue = [];

  	addKeypaths(keypaths);
  	queue.forEach(dispatch);

  	function addKeypaths(keypaths) {
  		keypaths.forEach(addKeypath);
  		keypaths.forEach(cascade);
  	}

  	function addKeypath(keypath) {
  		var deps = findDependants(viewmodel, keypath, groupName);

  		if (deps) {
  			queue.push({
  				keypath: keypath,
  				deps: deps
  			});
  		}
  	}

  	function cascade(keypath) {
  		var childDeps;

  		if (childDeps = viewmodel.depsMap[groupName][keypath.str]) {
  			addKeypaths(childDeps);
  		}
  	}

  	function dispatch(set) {
  		var value = viewmodel.get(set.keypath);
  		set.deps.forEach(function (d) {
  			return d.setValue(value);
  		});
  	}
  }

  function findDependants(viewmodel, keypath, groupName) {
  	var group = viewmodel.deps[groupName];
  	return group ? group[keypath.str] : null;
  }

  var capture = Viewmodel$capture;

  function Viewmodel$capture() {
  	this.captureGroups.push([]);
  }

  var clearCache = Viewmodel$clearCache;

  function Viewmodel$clearCache(keypath, keepExistingWrapper) {
  	var cacheMap, wrapper;

  	if (!keepExistingWrapper) {
  		// Is there a wrapped property at this keypath?
  		if (wrapper = this.wrapped[keypath]) {
  			// Did we unwrap it?
  			if (wrapper.teardown() !== false) {
  				// Is this right?
  				// What's the meaning of returning false from teardown?
  				// Could there be a GC ramification if this is a "real" ractive.teardown()?
  				this.wrapped[keypath] = null;
  			}
  		}
  	}

  	this.cache[keypath] = undefined;

  	if (cacheMap = this.cacheMap[keypath]) {
  		while (cacheMap.length) {
  			this.clearCache(cacheMap.pop());
  		}
  	}
  }

  var UnresolvedDependency = function (computation, ref) {
  	this.computation = computation;
  	this.viewmodel = computation.viewmodel;
  	this.ref = ref;

  	// TODO this seems like a red flag!
  	this.root = this.viewmodel.ractive;
  	this.parentFragment = this.root.component && this.root.component.parentFragment;
  };

  UnresolvedDependency.prototype = {
  	resolve: function (keypath) {
  		this.computation.softDeps.push(keypath);
  		this.computation.unresolvedDeps[keypath.str] = null;
  		this.viewmodel.register(keypath, this.computation, "computed");
  	}
  };

  var Computation_UnresolvedDependency = UnresolvedDependency;

  var Computation = function (key, signature) {
  	this.key = key;

  	this.getter = signature.getter;
  	this.setter = signature.setter;

  	this.hardDeps = signature.deps || [];
  	this.softDeps = [];
  	this.unresolvedDeps = {};

  	this.depValues = {};

  	this._dirty = this._firstRun = true;
  };

  Computation.prototype = {
  	constructor: Computation,

  	init: function (viewmodel) {
  		var _this = this;

  		var initial;

  		this.viewmodel = viewmodel;
  		this.bypass = true;

  		initial = viewmodel.get(this.key);
  		viewmodel.clearCache(this.key.str);

  		this.bypass = false;

  		if (this.setter && initial !== undefined) {
  			this.set(initial);
  		}

  		if (this.hardDeps) {
  			this.hardDeps.forEach(function (d) {
  				return viewmodel.register(d, _this, "computed");
  			});
  		}
  	},

  	invalidate: function () {
  		this._dirty = true;
  	},

  	get: function () {
  		var _this = this;

  		var newDeps,
  		    dependenciesChanged,
  		    dependencyValuesChanged = false;

  		if (this.getting) {
  			// prevent double-computation (e.g. caused by array mutation inside computation)
  			var msg = "The " + this.key.str + " computation indirectly called itself. This probably indicates a bug in the computation. It is commonly caused by `array.sort(...)` - if that's the case, clone the array first with `array.slice().sort(...)`";
  			warnOnce(msg);
  			return this.value;
  		}

  		this.getting = true;

  		if (this._dirty) {
  			// determine whether the inputs have changed, in case this depends on
  			// other computed values
  			if (this._firstRun || !this.hardDeps.length && !this.softDeps.length) {
  				dependencyValuesChanged = true;
  			} else {
  				[this.hardDeps, this.softDeps].forEach(function (deps) {
  					var keypath, value, i;

  					if (dependencyValuesChanged) {
  						return;
  					}

  					i = deps.length;
  					while (i--) {
  						keypath = deps[i];
  						value = _this.viewmodel.get(keypath);

  						if (!isEqual(value, _this.depValues[keypath.str])) {
  							_this.depValues[keypath.str] = value;
  							dependencyValuesChanged = true;

  							return;
  						}
  					}
  				});
  			}

  			if (dependencyValuesChanged) {
  				this.viewmodel.capture();

  				try {
  					this.value = this.getter();
  				} catch (err) {
  					warnIfDebug("Failed to compute \"%s\"", this.key.str);
  					logIfDebug(err.stack || err);

  					this.value = void 0;
  				}

  				newDeps = this.viewmodel.release();
  				dependenciesChanged = this.updateDependencies(newDeps);

  				if (dependenciesChanged) {
  					[this.hardDeps, this.softDeps].forEach(function (deps) {
  						deps.forEach(function (keypath) {
  							_this.depValues[keypath.str] = _this.viewmodel.get(keypath);
  						});
  					});
  				}
  			}

  			this._dirty = false;
  		}

  		this.getting = this._firstRun = false;
  		return this.value;
  	},

  	set: function (value) {
  		if (this.setting) {
  			this.value = value;
  			return;
  		}

  		if (!this.setter) {
  			throw new Error("Computed properties without setters are read-only. (This may change in a future version of Ractive!)");
  		}

  		this.setter(value);
  	},

  	updateDependencies: function (newDeps) {
  		var i, oldDeps, keypath, dependenciesChanged, unresolved;

  		oldDeps = this.softDeps;

  		// remove dependencies that are no longer used
  		i = oldDeps.length;
  		while (i--) {
  			keypath = oldDeps[i];

  			if (newDeps.indexOf(keypath) === -1) {
  				dependenciesChanged = true;
  				this.viewmodel.unregister(keypath, this, "computed");
  			}
  		}

  		// create references for any new dependencies
  		i = newDeps.length;
  		while (i--) {
  			keypath = newDeps[i];

  			if (oldDeps.indexOf(keypath) === -1 && (!this.hardDeps || this.hardDeps.indexOf(keypath) === -1)) {
  				dependenciesChanged = true;

  				// if this keypath is currently unresolved, we need to mark
  				// it as such. TODO this is a bit muddy...
  				if (isUnresolved(this.viewmodel, keypath) && !this.unresolvedDeps[keypath.str]) {
  					unresolved = new Computation_UnresolvedDependency(this, keypath.str);
  					newDeps.splice(i, 1);

  					this.unresolvedDeps[keypath.str] = unresolved;
  					global_runloop.addUnresolved(unresolved);
  				} else {
  					this.viewmodel.register(keypath, this, "computed");
  				}
  			}
  		}

  		if (dependenciesChanged) {
  			this.softDeps = newDeps.slice();
  		}

  		return dependenciesChanged;
  	}
  };

  function isUnresolved(viewmodel, keypath) {
  	var key = keypath.firstKey;

  	return !(key in viewmodel.data) && !(key in viewmodel.computations) && !(key in viewmodel.mappings);
  }

  var Computation_Computation = Computation;

  var compute = Viewmodel$compute;
  function Viewmodel$compute(key, signature) {
  	var computation = new Computation_Computation(key, signature);

  	if (this.ready) {
  		computation.init(this);
  	}

  	return this.computations[key.str] = computation;
  }

  var FAILED_LOOKUP = { FAILED_LOOKUP: true };

  var viewmodel_prototype_get = Viewmodel$get;

  var viewmodel_prototype_get__empty = {};
  function Viewmodel$get(keypath, options) {
  	var cache = this.cache,
  	    value,
  	    computation,
  	    wrapped,
  	    captureGroup,
  	    keypathStr = keypath.str,
  	    key;

  	options = options || viewmodel_prototype_get__empty;

  	// capture the keypath, if we're inside a computation
  	if (options.capture && (captureGroup = lastItem(this.captureGroups))) {
  		if (! ~captureGroup.indexOf(keypath)) {
  			captureGroup.push(keypath);
  		}
  	}

  	if (hasOwn.call(this.mappings, keypath.firstKey)) {
  		return this.mappings[keypath.firstKey].get(keypath, options);
  	}

  	if (keypath.isSpecial) {
  		return keypath.value;
  	}

  	if (cache[keypathStr] === undefined) {

  		// Is this a computed property?
  		if ((computation = this.computations[keypathStr]) && !computation.bypass) {
  			value = computation.get();
  			this.adapt(keypathStr, value);
  		}

  		// Is this a wrapped property?
  		else if (wrapped = this.wrapped[keypathStr]) {
  			value = wrapped.value;
  		}

  		// Is it the root?
  		else if (keypath.isRoot) {
  			this.adapt("", this.data);
  			value = this.data;
  		}

  		// No? Then we need to retrieve the value one key at a time
  		else {
  			value = retrieve(this, keypath);
  		}

  		cache[keypathStr] = value;
  	} else {
  		value = cache[keypathStr];
  	}

  	if (!options.noUnwrap && (wrapped = this.wrapped[keypathStr])) {
  		value = wrapped.get();
  	}

  	if (keypath.isRoot && options.fullRootGet) {
  		for (key in this.mappings) {
  			value[key] = this.mappings[key].getValue();
  		}
  	}

  	return value === FAILED_LOOKUP ? void 0 : value;
  }

  function retrieve(viewmodel, keypath) {

  	var parentValue, cacheMap, value, wrapped;

  	parentValue = viewmodel.get(keypath.parent);

  	if (wrapped = viewmodel.wrapped[keypath.parent.str]) {
  		parentValue = wrapped.get();
  	}

  	if (parentValue === null || parentValue === undefined) {
  		return;
  	}

  	// update cache map
  	if (!(cacheMap = viewmodel.cacheMap[keypath.parent.str])) {
  		viewmodel.cacheMap[keypath.parent.str] = [keypath.str];
  	} else {
  		if (cacheMap.indexOf(keypath.str) === -1) {
  			cacheMap.push(keypath.str);
  		}
  	}

  	// If this property doesn't exist, we return a sentinel value
  	// so that we know to query parent scope (if such there be)
  	if (typeof parentValue === "object" && !(keypath.lastKey in parentValue)) {
  		return viewmodel.cache[keypath.str] = FAILED_LOOKUP;
  	}

  	value = parentValue[keypath.lastKey];

  	// Do we have an adaptor for this value?
  	viewmodel.adapt(keypath.str, value, false);

  	// Update cache
  	viewmodel.cache[keypath.str] = value;
  	return value;
  }

  var viewmodel_prototype_init = Viewmodel$init;

  function Viewmodel$init() {
  	var key;

  	for (key in this.computations) {
  		this.computations[key].init(this);
  	}
  }

  var prototype_map = Viewmodel$map;

  function Viewmodel$map(key, options) {
  	var mapping = this.mappings[key.str] = new Mapping(key, options);
  	mapping.initViewmodel(this);
  	return mapping;
  }

  var Mapping = function (localKey, options) {
  	this.localKey = localKey;
  	this.keypath = options.keypath;
  	this.origin = options.origin;

  	this.deps = [];
  	this.unresolved = [];

  	this.resolved = false;
  };

  Mapping.prototype = {
  	forceResolution: function () {
  		// TODO warn, as per #1692?
  		this.keypath = this.localKey;
  		this.setup();
  	},

  	get: function (keypath, options) {
  		if (!this.resolved) {
  			return undefined;
  		}
  		return this.origin.get(this.map(keypath), options);
  	},

  	getValue: function () {
  		if (!this.keypath) {
  			return undefined;
  		}
  		return this.origin.get(this.keypath);
  	},

  	initViewmodel: function (viewmodel) {
  		this.local = viewmodel;
  		this.setup();
  	},

  	map: function (keypath) {
  		if (typeof this.keypath === undefined) {
  			return this.localKey;
  		}
  		return keypath.replace(this.localKey, this.keypath);
  	},

  	register: function (keypath, dependant, group) {
  		this.deps.push({ keypath: keypath, dep: dependant, group: group });

  		if (this.resolved) {
  			this.origin.register(this.map(keypath), dependant, group);
  		}
  	},

  	resolve: function (keypath) {
  		if (this.keypath !== undefined) {
  			this.unbind(true);
  		}

  		this.keypath = keypath;
  		this.setup();
  	},

  	set: function (keypath, value) {
  		if (!this.resolved) {
  			this.forceResolution();
  		}

  		this.origin.set(this.map(keypath), value);
  	},

  	setup: function () {
  		var _this = this;

  		if (this.keypath === undefined) {
  			return;
  		}

  		this.resolved = true;

  		// accumulated dependants can now be registered
  		if (this.deps.length) {
  			this.deps.forEach(function (d) {
  				var keypath = _this.map(d.keypath);
  				_this.origin.register(keypath, d.dep, d.group);

  				// TODO this is a bit of a red flag... all deps should be the same?
  				if (d.dep.setValue) {
  					d.dep.setValue(_this.origin.get(keypath));
  				} else if (d.dep.invalidate) {
  					d.dep.invalidate();
  				} else {
  					throw new Error("An unexpected error occurred. Please raise an issue at https://github.com/ractivejs/ractive/issues - thanks!");
  				}
  			});

  			this.origin.mark(this.keypath);
  		}
  	},

  	setValue: function (value) {
  		if (!this.keypath) {
  			throw new Error("Mapping does not have keypath, cannot set value. Please raise an issue at https://github.com/ractivejs/ractive/issues - thanks!");
  		}

  		this.origin.set(this.keypath, value);
  	},

  	unbind: function (keepLocal) {
  		var _this = this;

  		if (!keepLocal) {
  			delete this.local.mappings[this.localKey];
  		}

  		if (!this.resolved) {
  			return;
  		}

  		this.deps.forEach(function (d) {
  			_this.origin.unregister(_this.map(d.keypath), d.dep, d.group);
  		});

  		if (this.tracker) {
  			this.origin.unregister(this.keypath, this.tracker);
  		}
  	},

  	unregister: function (keypath, dependant, group) {
  		var deps, i;

  		if (!this.resolved) {
  			return;
  		}

  		deps = this.deps;
  		i = deps.length;

  		while (i--) {
  			if (deps[i].dep === dependant) {
  				deps.splice(i, 1);
  				break;
  			}
  		}
  		this.origin.unregister(this.map(keypath), dependant, group);
  	}
  };

  var mark = Viewmodel$mark;

  function Viewmodel$mark(keypath, options) {
  	var computation,
  	    keypathStr = keypath.str;

  	// implicit changes (i.e. `foo.length` on `ractive.push('foo',42)`)
  	// should not be picked up by pattern observers
  	if (options) {
  		if (options.implicit) {
  			this.implicitChanges[keypathStr] = true;
  		}
  		if (options.noCascade) {
  			this.noCascade[keypathStr] = true;
  		}
  	}

  	if (computation = this.computations[keypathStr]) {
  		computation.invalidate();
  	}

  	if (this.changes.indexOf(keypath) === -1) {
  		this.changes.push(keypath);
  	}

  	// pass on keepExistingWrapper, if we can
  	var keepExistingWrapper = options ? options.keepExistingWrapper : false;

  	this.clearCache(keypathStr, keepExistingWrapper);

  	if (this.ready) {
  		this.onchange();
  	}
  }

  var mapOldToNewIndex = function (oldArray, newArray) {
  	var usedIndices, firstUnusedIndex, newIndices, changed;

  	usedIndices = {};
  	firstUnusedIndex = 0;

  	newIndices = oldArray.map(function (item, i) {
  		var index, start, len;

  		start = firstUnusedIndex;
  		len = newArray.length;

  		do {
  			index = newArray.indexOf(item, start);

  			if (index === -1) {
  				changed = true;
  				return -1;
  			}

  			start = index + 1;
  		} while (usedIndices[index] && start < len);

  		// keep track of the first unused index, so we don't search
  		// the whole of newArray for each item in oldArray unnecessarily
  		if (index === firstUnusedIndex) {
  			firstUnusedIndex += 1;
  		}

  		if (index !== i) {
  			changed = true;
  		}

  		usedIndices[index] = true;
  		return index;
  	});

  	return newIndices;
  };

  var merge = Viewmodel$merge;

  var comparators = {};
  function Viewmodel$merge(keypath, currentArray, array, options) {
  	var oldArray, newArray, comparator, newIndices;

  	this.mark(keypath);

  	if (options && options.compare) {

  		comparator = getComparatorFunction(options.compare);

  		try {
  			oldArray = currentArray.map(comparator);
  			newArray = array.map(comparator);
  		} catch (err) {
  			// fallback to an identity check - worst case scenario we have
  			// to do more DOM manipulation than we thought...
  			warnIfDebug("merge(): \"%s\" comparison failed. Falling back to identity checking", keypath);

  			oldArray = currentArray;
  			newArray = array;
  		}
  	} else {
  		oldArray = currentArray;
  		newArray = array;
  	}

  	// find new indices for members of oldArray
  	newIndices = mapOldToNewIndex(oldArray, newArray);

  	this.smartUpdate(keypath, array, newIndices, currentArray.length !== array.length);
  }

  function stringify(item) {
  	return JSON.stringify(item);
  }

  function getComparatorFunction(comparator) {
  	// If `compare` is `true`, we use JSON.stringify to compare
  	// objects that are the same shape, but non-identical - i.e.
  	// { foo: 'bar' } !== { foo: 'bar' }
  	if (comparator === true) {
  		return stringify;
  	}

  	if (typeof comparator === "string") {
  		if (!comparators[comparator]) {
  			comparators[comparator] = function (item) {
  				return item[comparator];
  			};
  		}

  		return comparators[comparator];
  	}

  	if (typeof comparator === "function") {
  		return comparator;
  	}

  	throw new Error("The `compare` option must be a function, or a string representing an identifying field (or `true` to use JSON.stringify)");
  }

  var register = Viewmodel$register;

  function Viewmodel$register(keypath, dependant) {
  	var group = arguments[2] === undefined ? "default" : arguments[2];

  	var mapping, depsByKeypath, deps;

  	if (dependant.isStatic) {
  		return; // TODO we should never get here if a dependant is static...
  	}

  	if (mapping = this.mappings[keypath.firstKey]) {
  		mapping.register(keypath, dependant, group);
  	} else {
  		depsByKeypath = this.deps[group] || (this.deps[group] = {});
  		deps = depsByKeypath[keypath.str] || (depsByKeypath[keypath.str] = []);

  		deps.push(dependant);

  		if (!this.depsMap[group]) {
  			this.depsMap[group] = {};
  		}

  		if (!keypath.isRoot) {
  			register__updateDependantsMap(this, keypath, group);
  		}
  	}
  }

  function register__updateDependantsMap(viewmodel, keypath, group) {
  	var map, parent, keypathStr;

  	// update dependants map
  	while (!keypath.isRoot) {
  		map = viewmodel.depsMap[group];
  		parent = map[keypath.parent.str] || (map[keypath.parent.str] = []);

  		keypathStr = keypath.str;

  		// TODO find an alternative to this nasty approach
  		if (parent["_" + keypathStr] === undefined) {
  			parent["_" + keypathStr] = 0;
  			parent.push(keypath);
  		}

  		parent["_" + keypathStr] += 1;
  		keypath = keypath.parent;
  	}
  }

  var release = Viewmodel$release;

  function Viewmodel$release() {
  	return this.captureGroups.pop();
  }

  var reset = Viewmodel$reset;

  function Viewmodel$reset(data) {
  	this.data = data;
  	this.clearCache("");
  }

  var prototype_set = Viewmodel$set;

  function Viewmodel$set(keypath, value) {
  	var options = arguments[2] === undefined ? {} : arguments[2];

  	var mapping, computation, wrapper, keepExistingWrapper;

  	// unless data is being set for data tracking purposes
  	if (!options.noMapping) {
  		// If this data belongs to a different viewmodel,
  		// pass the change along
  		if (mapping = this.mappings[keypath.firstKey]) {
  			return mapping.set(keypath, value);
  		}
  	}

  	computation = this.computations[keypath.str];
  	if (computation) {
  		if (computation.setting) {
  			// let the other computation set() handle things...
  			return;
  		}
  		computation.set(value);
  		value = computation.get();
  	}

  	if (isEqual(this.cache[keypath.str], value)) {
  		return;
  	}

  	wrapper = this.wrapped[keypath.str];

  	// If we have a wrapper with a `reset()` method, we try and use it. If the
  	// `reset()` method returns false, the wrapper should be torn down, and
  	// (most likely) a new one should be created later
  	if (wrapper && wrapper.reset) {
  		keepExistingWrapper = wrapper.reset(value) !== false;

  		if (keepExistingWrapper) {
  			value = wrapper.get();
  		}
  	}

  	if (!computation && !keepExistingWrapper) {
  		resolveSet(this, keypath, value);
  	}

  	if (!options.silent) {
  		this.mark(keypath);
  	} else {
  		// We're setting a parent of the original target keypath (i.e.
  		// creating a fresh branch) - we need to clear the cache, but
  		// not mark it as a change
  		this.clearCache(keypath.str);
  	}
  }

  function resolveSet(viewmodel, keypath, value) {
  	var wrapper, parentValue, wrapperSet, valueSet;

  	wrapperSet = function () {
  		if (wrapper.set) {
  			wrapper.set(keypath.lastKey, value);
  		} else {
  			parentValue = wrapper.get();
  			valueSet();
  		}
  	};

  	valueSet = function () {
  		if (!parentValue) {
  			parentValue = createBranch(keypath.lastKey);
  			viewmodel.set(keypath.parent, parentValue, { silent: true });
  		}
  		parentValue[keypath.lastKey] = value;
  	};

  	wrapper = viewmodel.wrapped[keypath.parent.str];

  	if (wrapper) {
  		wrapperSet();
  	} else {
  		parentValue = viewmodel.get(keypath.parent);

  		// may have been wrapped via the above .get()
  		// call on viewmodel if this is first access via .set()!
  		if (wrapper = viewmodel.wrapped[keypath.parent.str]) {
  			wrapperSet();
  		} else {
  			valueSet();
  		}
  	}
  }

  var smartUpdate = Viewmodel$smartUpdate;

  var implicitOption = { implicit: true },
      noCascadeOption = { noCascade: true };
  function Viewmodel$smartUpdate(keypath, array, newIndices) {
  	var _this = this;

  	var dependants, oldLength, i;

  	oldLength = newIndices.length;

  	// Indices that are being removed should be marked as dirty
  	newIndices.forEach(function (newIndex, oldIndex) {
  		if (newIndex === -1) {
  			_this.mark(keypath.join(oldIndex), noCascadeOption);
  		}
  	});

  	// Update the model
  	// TODO allow existing array to be updated in place, rather than replaced?
  	this.set(keypath, array, { silent: true });

  	if (dependants = this.deps["default"][keypath.str]) {
  		dependants.filter(canShuffle).forEach(function (d) {
  			return d.shuffle(newIndices, array);
  		});
  	}

  	if (oldLength !== array.length) {
  		this.mark(keypath.join("length"), implicitOption);

  		for (i = newIndices.touchedFrom; i < array.length; i += 1) {
  			this.mark(keypath.join(i));
  		}

  		// don't allow removed indexes beyond end of new array to trigger recomputations
  		// TODO is this still necessary, now that computations are lazy?
  		for (i = array.length; i < oldLength; i += 1) {
  			this.mark(keypath.join(i), noCascadeOption);
  		}
  	}
  }

  function canShuffle(dependant) {
  	return typeof dependant.shuffle === "function";
  }

  var prototype_teardown = Viewmodel$teardown;

  function Viewmodel$teardown() {
  	var _this = this;

  	var unresolvedImplicitDependency;

  	// Clear entire cache - this has the desired side-effect
  	// of unwrapping adapted values (e.g. arrays)
  	Object.keys(this.cache).forEach(function (keypath) {
  		return _this.clearCache(keypath);
  	});

  	// Teardown any failed lookups - we don't need them to resolve any more
  	while (unresolvedImplicitDependency = this.unresolvedImplicitDependencies.pop()) {
  		unresolvedImplicitDependency.teardown();
  	}
  }

  var unregister = Viewmodel$unregister;

  function Viewmodel$unregister(keypath, dependant) {
  	var group = arguments[2] === undefined ? "default" : arguments[2];

  	var mapping, deps, index;

  	if (dependant.isStatic) {
  		return;
  	}

  	if (mapping = this.mappings[keypath.firstKey]) {
  		return mapping.unregister(keypath, dependant, group);
  	}

  	deps = this.deps[group][keypath.str];
  	index = deps.indexOf(dependant);

  	if (index === -1) {
  		throw new Error("Attempted to remove a dependant that was no longer registered! This should not happen. If you are seeing this bug in development please raise an issue at https://github.com/RactiveJS/Ractive/issues - thanks");
  	}

  	deps.splice(index, 1);

  	if (keypath.isRoot) {
  		return;
  	}

  	unregister__updateDependantsMap(this, keypath, group);
  }

  function unregister__updateDependantsMap(viewmodel, keypath, group) {
  	var map, parent;

  	// update dependants map
  	while (!keypath.isRoot) {
  		map = viewmodel.depsMap[group];
  		parent = map[keypath.parent.str];

  		parent["_" + keypath.str] -= 1;

  		if (!parent["_" + keypath.str]) {
  			// remove from parent deps map
  			removeFromArray(parent, keypath);
  			parent["_" + keypath.str] = undefined;
  		}

  		keypath = keypath.parent;
  	}
  }

  var Viewmodel = function (options) {
  	var adapt = options.adapt;
  	var data = options.data;
  	var ractive = options.ractive;
  	var computed = options.computed;
  	var mappings = options.mappings;
  	var key;
  	var mapping;

  	// TODO is it possible to remove this reference?
  	this.ractive = ractive;

  	this.adaptors = adapt;
  	this.onchange = options.onchange;

  	this.cache = {}; // we need to be able to use hasOwnProperty, so can't inherit from null
  	this.cacheMap = create(null);

  	this.deps = {
  		computed: create(null),
  		"default": create(null)
  	};
  	this.depsMap = {
  		computed: create(null),
  		"default": create(null)
  	};

  	this.patternObservers = [];

  	this.specials = create(null);

  	this.wrapped = create(null);
  	this.computations = create(null);

  	this.captureGroups = [];
  	this.unresolvedImplicitDependencies = [];

  	this.changes = [];
  	this.implicitChanges = {};
  	this.noCascade = {};

  	this.data = data;

  	// set up explicit mappings
  	this.mappings = create(null);
  	for (key in mappings) {
  		this.map(getKeypath(key), mappings[key]);
  	}

  	if (data) {
  		// if data exists locally, but is missing on the parent,
  		// we transfer ownership to the parent
  		for (key in data) {
  			if ((mapping = this.mappings[key]) && mapping.getValue() === undefined) {
  				mapping.setValue(data[key]);
  			}
  		}
  	}

  	for (key in computed) {
  		if (mappings && key in mappings) {
  			fatal("Cannot map to a computed property ('%s')", key);
  		}

  		this.compute(getKeypath(key), computed[key]);
  	}

  	this.ready = true;
  };

  Viewmodel.prototype = {
  	adapt: prototype_adapt,
  	applyChanges: applyChanges,
  	capture: capture,
  	clearCache: clearCache,
  	compute: compute,
  	get: viewmodel_prototype_get,
  	init: viewmodel_prototype_init,
  	map: prototype_map,
  	mark: mark,
  	merge: merge,
  	register: register,
  	release: release,
  	reset: reset,
  	set: prototype_set,
  	smartUpdate: smartUpdate,
  	teardown: prototype_teardown,
  	unregister: unregister
  };

  var viewmodel_Viewmodel = Viewmodel;

  function HookQueue(event) {
  	this.hook = new hooks_Hook(event);
  	this.inProcess = {};
  	this.queue = {};
  }

  HookQueue.prototype = {

  	constructor: HookQueue,

  	begin: function (ractive) {
  		this.inProcess[ractive._guid] = true;
  	},

  	end: function (ractive) {

  		var parent = ractive.parent;

  		// If this is *isn't* a child of a component that's in process,
  		// it should call methods or fire at this point
  		if (!parent || !this.inProcess[parent._guid]) {
  			fire(this, ractive);
  		}
  		// elsewise, handoff to parent to fire when ready
  		else {
  			getChildQueue(this.queue, parent).push(ractive);
  		}

  		delete this.inProcess[ractive._guid];
  	}
  };

  function getChildQueue(queue, ractive) {
  	return queue[ractive._guid] || (queue[ractive._guid] = []);
  }

  function fire(hookQueue, ractive) {

  	var childQueue = getChildQueue(hookQueue.queue, ractive);

  	hookQueue.hook.fire(ractive);

  	// queue is "live" because components can end up being
  	// added while hooks fire on parents that modify data values.
  	while (childQueue.length) {
  		fire(hookQueue, childQueue.shift());
  	}

  	delete hookQueue.queue[ractive._guid];
  }

  var hooks_HookQueue = HookQueue;

  var helpers_getComputationSignatures = getComputationSignatures;

  var pattern = /\$\{([^\}]+)\}/g;
  function getComputationSignatures(ractive, computed) {
  	var signatures = {},
  	    key;

  	for (key in computed) {
  		signatures[key] = getComputationSignature(ractive, key, computed[key]);
  	}

  	return signatures;
  }

  function getComputationSignature(ractive, key, signature) {
  	var getter, setter;

  	if (typeof signature === "function") {
  		getter = helpers_getComputationSignatures__bind(signature, ractive);
  	}

  	if (typeof signature === "string") {
  		getter = createFunctionFromString(ractive, signature);
  	}

  	if (typeof signature === "object") {
  		if (typeof signature.get === "string") {
  			getter = createFunctionFromString(ractive, signature.get);
  		} else if (typeof signature.get === "function") {
  			getter = helpers_getComputationSignatures__bind(signature.get, ractive);
  		} else {
  			fatal("`%s` computation must have a `get()` method", key);
  		}

  		if (typeof signature.set === "function") {
  			setter = helpers_getComputationSignatures__bind(signature.set, ractive);
  		}
  	}

  	return { getter: getter, setter: setter };
  }

  function createFunctionFromString(ractive, str) {
  	var functionBody, hasThis, fn;

  	functionBody = "return (" + str.replace(pattern, function (match, keypath) {
  		hasThis = true;
  		return "__ractive.get(\"" + keypath + "\")";
  	}) + ");";

  	if (hasThis) {
  		functionBody = "var __ractive = this; " + functionBody;
  	}

  	fn = new Function(functionBody);
  	return hasThis ? fn.bind(ractive) : fn;
  }

  function helpers_getComputationSignatures__bind(fn, context) {
  	return /this/.test(fn.toString()) ? fn.bind(context) : fn;
  }

  var constructHook = new hooks_Hook("construct");
  var configHook = new hooks_Hook("config");
  var initHook = new hooks_HookQueue("init");
  var initialise__uid = 0;

  var initialise__registryNames = ["adaptors", "components", "decorators", "easing", "events", "interpolators", "partials", "transitions"];

  var initialise = initialiseRactiveInstance;

  function initialiseRactiveInstance(ractive) {
  	var userOptions = arguments[1] === undefined ? {} : arguments[1];
  	var options = arguments[2] === undefined ? {} : arguments[2];

  	var el, viewmodel;

  	if (_Ractive.DEBUG) {
  		welcome();
  	}

  	initialiseProperties(ractive, options);

  	// TODO remove this, eventually
  	defineProperty(ractive, "data", { get: deprecateRactiveData });

  	// TODO don't allow `onconstruct` with `new Ractive()`, there's no need for it
  	constructHook.fire(ractive, userOptions);

  	// Add registries
  	initialise__registryNames.forEach(function (name) {
  		ractive[name] = utils_object__extend(create(ractive.constructor[name] || null), userOptions[name]);
  	});

  	// Create a viewmodel
  	viewmodel = new viewmodel_Viewmodel({
  		adapt: getAdaptors(ractive, ractive.adapt, userOptions),
  		data: custom_data.init(ractive.constructor, ractive, userOptions),
  		computed: helpers_getComputationSignatures(ractive, utils_object__extend(create(ractive.constructor.prototype.computed), userOptions.computed)),
  		mappings: options.mappings,
  		ractive: ractive,
  		onchange: function () {
  			return global_runloop.addRactive(ractive);
  		}
  	});

  	ractive.viewmodel = viewmodel;

  	// This can't happen earlier, because computed properties may call `ractive.get()`, etc
  	viewmodel.init();

  	// init config from Parent and options
  	config_config.init(ractive.constructor, ractive, userOptions);

  	configHook.fire(ractive);
  	initHook.begin(ractive);

  	// // If this is a component with a function `data` property, call the function
  	// // with `ractive` as context (unless the child was also a function)
  	// if ( typeof ractive.constructor.prototype.data === 'function' && typeof userOptions.data !== 'function' ) {
  	// 	viewmodel.reset( ractive.constructor.prototype.data.call( ractive ) || fatal( '`data` functions must return a data object' ) );
  	// }

  	// Render virtual DOM
  	if (ractive.template) {
  		var cssIds = undefined;

  		if (options.cssIds || ractive.cssId) {
  			cssIds = options.cssIds ? options.cssIds.slice() : [];

  			if (ractive.cssId) {
  				cssIds.push(ractive.cssId);
  			}
  		}

  		ractive.fragment = new virtualdom_Fragment({
  			template: ractive.template,
  			root: ractive,
  			owner: ractive, // saves doing `if ( this.parent ) { /*...*/ }` later on
  			cssIds: cssIds
  		});
  	}

  	initHook.end(ractive);

  	// render automatically ( if `el` is specified )
  	if (el = getElement(ractive.el)) {
  		var promise = ractive.render(el, ractive.append);

  		if (_Ractive.DEBUG_PROMISES) {
  			promise["catch"](function (err) {
  				warnOnceIfDebug("Promise debugging is enabled, to help solve errors that happen asynchronously. Some browsers will log unhandled promise rejections, in which case you can safely disable promise debugging:\n  Ractive.DEBUG_PROMISES = false;");
  				warnIfDebug("An error happened during rendering", { ractive: ractive });
  				err.stack && logIfDebug(err.stack);

  				throw err;
  			});
  		}
  	}
  }

  function getAdaptors(ractive, protoAdapt, userOptions) {
  	var adapt, magic, modifyArrays;

  	protoAdapt = protoAdapt.map(lookup);
  	adapt = ensureArray(userOptions.adapt).map(lookup);

  	adapt = initialise__combine(protoAdapt, adapt);

  	magic = "magic" in userOptions ? userOptions.magic : ractive.magic;
  	modifyArrays = "modifyArrays" in userOptions ? userOptions.modifyArrays : ractive.modifyArrays;

  	if (magic) {
  		if (!environment__magic) {
  			throw new Error("Getters and setters (magic mode) are not supported in this browser");
  		}

  		if (modifyArrays) {
  			adapt.push(magicArray);
  		}

  		adapt.push(adaptors_magic);
  	}

  	if (modifyArrays) {
  		adapt.push(array_index);
  	}

  	return adapt;

  	function lookup(adaptor) {
  		if (typeof adaptor === "string") {
  			adaptor = findInViewHierarchy("adaptors", ractive, adaptor);

  			if (!adaptor) {
  				fatal(missingPlugin(adaptor, "adaptor"));
  			}
  		}

  		return adaptor;
  	}
  }

  function initialise__combine(a, b) {
  	var c = a.slice(),
  	    i = b.length;

  	while (i--) {
  		if (! ~c.indexOf(b[i])) {
  			c.push(b[i]);
  		}
  	}

  	return c;
  }

  function initialiseProperties(ractive, options) {
  	// Generate a unique identifier, for places where you'd use a weak map if it
  	// existed
  	ractive._guid = "r-" + initialise__uid++;

  	// events
  	ractive._subs = create(null);

  	// storage for item configuration from instantiation to reset,
  	// like dynamic functions or original values
  	ractive._config = {};

  	// two-way bindings
  	ractive._twowayBindings = create(null);

  	// animations (so we can stop any in progress at teardown)
  	ractive._animations = [];

  	// nodes registry
  	ractive.nodes = {};

  	// live queries
  	ractive._liveQueries = [];
  	ractive._liveComponentQueries = [];

  	// bound data functions
  	ractive._boundFunctions = [];

  	// observers
  	ractive._observers = [];

  	// properties specific to inline components
  	if (options.component) {
  		ractive.parent = options.parent;
  		ractive.container = options.container || null;
  		ractive.root = ractive.parent.root;

  		ractive.component = options.component;
  		options.component.instance = ractive;

  		// for hackability, this could be an open option
  		// for any ractive instance, but for now, just
  		// for components and just for ractive...
  		ractive._inlinePartials = options.inlinePartials;
  	} else {
  		ractive.root = ractive;
  		ractive.parent = ractive.container = null;
  	}
  }

  function deprecateRactiveData() {
  	throw new Error("Using `ractive.data` is no longer supported - you must use the `ractive.get()` API instead");
  }

  function ComplexParameter(component, template, callback) {
  	this.parentFragment = component.parentFragment;
  	this.callback = callback;

  	this.fragment = new virtualdom_Fragment({
  		template: template,
  		root: component.root,
  		owner: this
  	});

  	this.update();
  }

  var initialise_ComplexParameter = ComplexParameter;

  ComplexParameter.prototype = {
  	bubble: function () {
  		if (!this.dirty) {
  			this.dirty = true;
  			global_runloop.addView(this);
  		}
  	},

  	update: function () {
  		this.callback(this.fragment.getValue());
  		this.dirty = false;
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		this.fragment.rebind(oldKeypath, newKeypath);
  	},

  	unbind: function () {
  		this.fragment.unbind();
  	}
  };

  var createInstance = function (component, Component, attributes, yieldTemplate, partials) {
  	var instance,
  	    parentFragment,
  	    ractive,
  	    fragment,
  	    container,
  	    inlinePartials = {},
  	    data = {},
  	    mappings = {},
  	    ready,
  	    resolvers = [];

  	parentFragment = component.parentFragment;
  	ractive = component.root;

  	partials = partials || {};
  	utils_object__extend(inlinePartials, partials);

  	// Make contents available as a {{>content}} partial
  	partials.content = yieldTemplate || [];

  	// set a default partial for yields with no name
  	inlinePartials[""] = partials.content;

  	if (Component.defaults.el) {
  		warnIfDebug("The <%s/> component has a default `el` property; it has been disregarded", component.name);
  	}

  	// find container
  	fragment = parentFragment;
  	while (fragment) {
  		if (fragment.owner.type === YIELDER) {
  			container = fragment.owner.container;
  			break;
  		}

  		fragment = fragment.parent;
  	}

  	// each attribute represents either a) data or b) a mapping
  	if (attributes) {
  		Object.keys(attributes).forEach(function (key) {
  			var attribute = attributes[key],
  			    parsed,
  			    resolver;

  			if (typeof attribute === "string") {
  				// it's static data
  				parsed = parseJSON(attribute);
  				data[key] = parsed ? parsed.value : attribute;
  			} else if (attribute === 0) {
  				// it had no '=', so we'll call it true
  				data[key] = true;
  			} else if (isArray(attribute)) {
  				// this represents dynamic data
  				if (isSingleInterpolator(attribute)) {
  					mappings[key] = {
  						origin: component.root.viewmodel,
  						keypath: undefined
  					};

  					resolver = createResolver(component, attribute[0], function (keypath) {
  						if (keypath.isSpecial) {
  							if (ready) {
  								instance.set(key, keypath.value); // TODO use viewmodel?
  							} else {
  								data[key] = keypath.value;

  								// TODO errr.... would be better if we didn't have to do this
  								delete mappings[key];
  							}
  						} else {
  							if (ready) {
  								instance.viewmodel.mappings[key].resolve(keypath);
  							} else {
  								// resolved immediately
  								mappings[key].keypath = keypath;
  							}
  						}
  					});
  				} else {
  					resolver = new initialise_ComplexParameter(component, attribute, function (value) {
  						if (ready) {
  							instance.set(key, value); // TODO use viewmodel?
  						} else {
  							data[key] = value;
  						}
  					});
  				}

  				resolvers.push(resolver);
  			} else {
  				throw new Error("erm wut");
  			}
  		});
  	}

  	instance = create(Component.prototype);

  	initialise(instance, {
  		el: null,
  		append: true,
  		data: data,
  		partials: partials,
  		magic: ractive.magic || Component.defaults.magic,
  		modifyArrays: ractive.modifyArrays,
  		// need to inherit runtime parent adaptors
  		adapt: ractive.adapt
  	}, {
  		parent: ractive,
  		component: component,
  		container: container,
  		mappings: mappings,
  		inlinePartials: inlinePartials,
  		cssIds: parentFragment.cssIds
  	});

  	ready = true;
  	component.resolvers = resolvers;

  	return instance;
  };

  function createResolver(component, template, callback) {
  	var resolver;

  	if (template.r) {
  		resolver = Resolvers_createReferenceResolver(component, template.r, callback);
  	} else if (template.x) {
  		resolver = new Resolvers_ExpressionResolver(component, component.parentFragment, template.x, callback);
  	} else if (template.rx) {
  		resolver = new ReferenceExpressionResolver_ReferenceExpressionResolver(component, template.rx, callback);
  	}

  	return resolver;
  }

  function isSingleInterpolator(template) {
  	return template.length === 1 && template[0].t === INTERPOLATOR;
  }

  // TODO how should event arguments be handled? e.g.
  // <widget on-foo='bar:1,2,3'/>
  // The event 'bar' will be fired on the parent instance
  // when 'foo' fires on the child, but the 1,2,3 arguments
  // will be lost

  var initialise_propagateEvents = propagateEvents;

  function propagateEvents(component, eventsDescriptor) {
  	var eventName;

  	for (eventName in eventsDescriptor) {
  		if (eventsDescriptor.hasOwnProperty(eventName)) {
  			propagateEvent(component.instance, component.root, eventName, eventsDescriptor[eventName]);
  		}
  	}
  }

  function propagateEvent(childInstance, parentInstance, eventName, proxyEventName) {
  	if (typeof proxyEventName !== "string") {
  		fatal("Components currently only support simple events - you cannot include arguments. Sorry!");
  	}

  	childInstance.on(eventName, function () {
  		var event, args;

  		// semi-weak test, but what else? tag the event obj ._isEvent ?
  		if (arguments.length && arguments[0] && arguments[0].node) {
  			event = Array.prototype.shift.call(arguments);
  		}

  		args = Array.prototype.slice.call(arguments);

  		shared_fireEvent(parentInstance, proxyEventName, { event: event, args: args });

  		// cancel bubbling
  		return false;
  	});
  }

  var initialise_updateLiveQueries = function (component) {
  	var ancestor, query;

  	// If there's a live query for this component type, add it
  	ancestor = component.root;
  	while (ancestor) {
  		if (query = ancestor._liveComponentQueries["_" + component.name]) {
  			query.push(component.instance);
  		}

  		ancestor = ancestor.parent;
  	}
  };

  var Component_prototype_init = Component$init;
  function Component$init(options, Component) {
  	var parentFragment, root;

  	if (!Component) {
  		throw new Error("Component \"" + this.name + "\" not found");
  	}

  	parentFragment = this.parentFragment = options.parentFragment;
  	root = parentFragment.root;

  	this.root = root;
  	this.type = COMPONENT;
  	this.name = options.template.e;
  	this.index = options.index;
  	this.indexRefBindings = {};
  	this.yielders = {};
  	this.resolvers = [];

  	createInstance(this, Component, options.template.a, options.template.f, options.template.p);
  	initialise_propagateEvents(this, options.template.v);

  	// intro, outro and decorator directives have no effect
  	if (options.template.t0 || options.template.t1 || options.template.t2 || options.template.o) {
  		warnIfDebug("The \"intro\", \"outro\" and \"decorator\" directives have no effect on components", { ractive: this.instance });
  	}

  	initialise_updateLiveQueries(this);
  }

  var Component_prototype_rebind = Component$rebind;

  function Component$rebind(oldKeypath, newKeypath) {
  	var query;

  	this.resolvers.forEach(rebind);

  	for (var k in this.yielders) {
  		if (this.yielders[k][0]) {
  			rebind(this.yielders[k][0]);
  		}
  	}

  	if (query = this.root._liveComponentQueries["_" + this.name]) {
  		query._makeDirty();
  	}

  	function rebind(x) {
  		x.rebind(oldKeypath, newKeypath);
  	}
  }

  var Component_prototype_render = Component$render;

  function Component$render() {
  	var instance = this.instance;

  	instance.render(this.parentFragment.getNode());

  	this.rendered = true;
  	return instance.fragment.detach();
  }

  var Component_prototype_toString = Component$toString;

  function Component$toString() {
  	return this.instance.fragment.toString();
  }

  var Component_prototype_unbind = Component$unbind;

  var Component_prototype_unbind__teardownHook = new hooks_Hook("teardown");
  function Component$unbind() {
  	var instance = this.instance;

  	this.resolvers.forEach(methodCallers__unbind);

  	removeFromLiveComponentQueries(this);

  	instance._observers.forEach(cancel);

  	// teardown the instance
  	instance.fragment.unbind();
  	instance.viewmodel.teardown();

  	if (instance.fragment.rendered && instance.el.__ractive_instances__) {
  		removeFromArray(instance.el.__ractive_instances__, instance);
  	}

  	Component_prototype_unbind__teardownHook.fire(instance);
  }

  function removeFromLiveComponentQueries(component) {
  	var instance, query;

  	instance = component.root;

  	do {
  		if (query = instance._liveComponentQueries["_" + component.name]) {
  			query._remove(component);
  		}
  	} while (instance = instance.parent);
  }

  var Component_prototype_unrender = Component$unrender;

  function Component$unrender(shouldDestroy) {
  	this.shouldDestroy = shouldDestroy;
  	this.instance.unrender();
  }

  var Component = function (options, Constructor) {
  	this.init(options, Constructor);
  };

  Component.prototype = {
  	detach: Component_prototype_detach,
  	find: Component_prototype_find,
  	findAll: Component_prototype_findAll,
  	findAllComponents: Component_prototype_findAllComponents,
  	findComponent: Component_prototype_findComponent,
  	findNextNode: Component_prototype_findNextNode,
  	firstNode: Component_prototype_firstNode,
  	init: Component_prototype_init,
  	rebind: Component_prototype_rebind,
  	render: Component_prototype_render,
  	toString: Component_prototype_toString,
  	unbind: Component_prototype_unbind,
  	unrender: Component_prototype_unrender
  };

  var _Component = Component;

  var Comment = function (options) {
  	this.type = COMMENT;
  	this.value = options.template.c;
  };

  Comment.prototype = {
  	detach: shared_detach,

  	firstNode: function () {
  		return this.node;
  	},

  	render: function () {
  		if (!this.node) {
  			this.node = document.createComment(this.value);
  		}

  		return this.node;
  	},

  	toString: function () {
  		return "<!--" + this.value + "-->";
  	},

  	unrender: function (shouldDestroy) {
  		if (shouldDestroy) {
  			this.node.parentNode.removeChild(this.node);
  		}
  	}
  };

  var items_Comment = Comment;

  var Yielder = function (options) {
  	var container, component;

  	this.type = YIELDER;

  	this.container = container = options.parentFragment.root;
  	this.component = component = container.component;

  	this.container = container;
  	this.containerFragment = options.parentFragment;
  	this.parentFragment = component.parentFragment;

  	var name = this.name = options.template.n || "";

  	var template = container._inlinePartials[name];

  	if (!template) {
  		warnIfDebug("Could not find template for partial \"" + name + "\"", { ractive: options.root });
  		template = [];
  	}

  	this.fragment = new virtualdom_Fragment({
  		owner: this,
  		root: container.parent,
  		template: template,
  		pElement: this.containerFragment.pElement
  	});

  	// even though only one yielder is allowed, we need to have an array of them
  	// as it's possible to cause a yielder to be created before the last one
  	// was destroyed in the same turn of the runloop
  	if (!isArray(component.yielders[name])) {
  		component.yielders[name] = [this];
  	} else {
  		component.yielders[name].push(this);
  	}

  	global_runloop.scheduleTask(function () {
  		if (component.yielders[name].length > 1) {
  			throw new Error("A component template can only have one {{yield" + (name ? " " + name : "") + "}} declaration at a time");
  		}
  	});
  };

  Yielder.prototype = {
  	detach: function () {
  		return this.fragment.detach();
  	},

  	find: function (selector) {
  		return this.fragment.find(selector);
  	},

  	findAll: function (selector, query) {
  		return this.fragment.findAll(selector, query);
  	},

  	findComponent: function (selector) {
  		return this.fragment.findComponent(selector);
  	},

  	findAllComponents: function (selector, query) {
  		return this.fragment.findAllComponents(selector, query);
  	},

  	findNextNode: function () {
  		return this.containerFragment.findNextNode(this);
  	},

  	firstNode: function () {
  		return this.fragment.firstNode();
  	},

  	getValue: function (options) {
  		return this.fragment.getValue(options);
  	},

  	render: function () {
  		return this.fragment.render();
  	},

  	unbind: function () {
  		this.fragment.unbind();
  	},

  	unrender: function (shouldDestroy) {
  		this.fragment.unrender(shouldDestroy);
  		removeFromArray(this.component.yielders[this.name], this);
  	},

  	rebind: function (oldKeypath, newKeypath) {
  		this.fragment.rebind(oldKeypath, newKeypath);
  	},

  	toString: function () {
  		return this.fragment.toString();
  	}
  };

  var items_Yielder = Yielder;

  var Doctype = function (options) {
  	this.declaration = options.template.a;
  };

  Doctype.prototype = {
  	init: noop,
  	render: noop,
  	unrender: noop,
  	teardown: noop,
  	toString: function () {
  		return "<!DOCTYPE" + this.declaration + ">";
  	}
  };

  var items_Doctype = Doctype;

  var Fragment_prototype_init = Fragment$init;

  function Fragment$init(options) {
  	var _this = this;

  	this.owner = options.owner; // The item that owns this fragment - an element, section, partial, or attribute
  	this.parent = this.owner.parentFragment;

  	// inherited properties
  	this.root = options.root;
  	this.pElement = options.pElement;
  	this.context = options.context;
  	this.index = options.index;
  	this.key = options.key;
  	this.registeredIndexRefs = [];

  	// encapsulated styles should be inherited until they get applied by an element
  	this.cssIds = "cssIds" in options ? options.cssIds : this.parent ? this.parent.cssIds : null;

  	this.items = options.template.map(function (template, i) {
  		return createItem({
  			parentFragment: _this,
  			pElement: options.pElement,
  			template: template,
  			index: i
  		});
  	});

  	this.value = this.argsList = null;
  	this.dirtyArgs = this.dirtyValue = true;

  	this.bound = true;
  }

  function createItem(options) {
  	if (typeof options.template === "string") {
  		return new items_Text(options);
  	}

  	switch (options.template.t) {
  		case YIELDER:
  			return new items_Yielder(options);
  		case INTERPOLATOR:
  			return new items_Interpolator(options);
  		case SECTION:
  			return new _Section(options);
  		case TRIPLE:
  			return new _Triple(options);
  		case ELEMENT:
  			var constructor = undefined;
  			if (constructor = Component_getComponent(options.parentFragment.root, options.template.e)) {
  				return new _Component(options, constructor);
  			}
  			return new _Element(options);
  		case PARTIAL:
  			return new _Partial(options);
  		case COMMENT:
  			return new items_Comment(options);
  		case DOCTYPE:
  			return new items_Doctype(options);

  		default:
  			throw new Error("Something very strange happened. Please file an issue at https://github.com/ractivejs/ractive/issues. Thanks!");
  	}
  }

  var Fragment_prototype_rebind = Fragment$rebind;
  function Fragment$rebind(oldKeypath, newKeypath) {

  	// assign new context keypath if needed
  	if (!this.owner || this.owner.hasContext) {
  		assignNewKeypath(this, "context", oldKeypath, newKeypath);
  	}

  	this.items.forEach(function (item) {
  		if (item.rebind) {
  			item.rebind(oldKeypath, newKeypath);
  		}
  	});
  }

  var Fragment_prototype_render = Fragment$render;

  function Fragment$render() {
  	var result;

  	if (this.items.length === 1) {
  		result = this.items[0].render();
  	} else {
  		result = document.createDocumentFragment();

  		this.items.forEach(function (item) {
  			result.appendChild(item.render());
  		});
  	}

  	this.rendered = true;
  	return result;
  }

  var Fragment_prototype_toString = Fragment$toString;

  function Fragment$toString(escape) {
  	if (!this.items) {
  		return "";
  	}

  	return this.items.map(escape ? toEscapedString : Fragment_prototype_toString__toString).join("");
  }

  function Fragment_prototype_toString__toString(item) {
  	return item.toString();
  }

  function toEscapedString(item) {
  	return item.toString(true);
  }

  var Fragment_prototype_unbind = Fragment$unbind;

  function Fragment$unbind() {
  	if (!this.bound) {
  		return;
  	}

  	this.items.forEach(unbindItem);
  	this.bound = false;
  }

  function unbindItem(item) {
  	if (item.unbind) {
  		item.unbind();
  	}
  }

  var Fragment_prototype_unrender = Fragment$unrender;

  function Fragment$unrender(shouldDestroy) {
  	if (!this.rendered) {
  		throw new Error("Attempted to unrender a fragment that was not rendered");
  	}

  	this.items.forEach(function (i) {
  		return i.unrender(shouldDestroy);
  	});
  	this.rendered = false;
  }

  var Fragment = function (options) {
  	this.init(options);
  };

  Fragment.prototype = {
  	bubble: prototype_bubble,
  	detach: Fragment_prototype_detach,
  	find: Fragment_prototype_find,
  	findAll: Fragment_prototype_findAll,
  	findAllComponents: Fragment_prototype_findAllComponents,
  	findComponent: Fragment_prototype_findComponent,
  	findNextNode: prototype_findNextNode,
  	firstNode: prototype_firstNode,
  	getArgsList: getArgsList,
  	getNode: getNode,
  	getValue: prototype_getValue,
  	init: Fragment_prototype_init,
  	rebind: Fragment_prototype_rebind,
  	registerIndexRef: function (idx) {
  		var idxs = this.registeredIndexRefs;
  		if (idxs.indexOf(idx) === -1) {
  			idxs.push(idx);
  		}
  	},
  	render: Fragment_prototype_render,
  	toString: Fragment_prototype_toString,
  	unbind: Fragment_prototype_unbind,
  	unregisterIndexRef: function (idx) {
  		var idxs = this.registeredIndexRefs;
  		idxs.splice(idxs.indexOf(idx), 1);
  	},
  	unrender: Fragment_prototype_unrender
  };

  var virtualdom_Fragment = Fragment;

  var prototype_reset = Ractive$reset;
  var shouldRerender = ["template", "partials", "components", "decorators", "events"],
      resetHook = new hooks_Hook("reset");
  function Ractive$reset(data) {
  	var promise, wrapper, changes, i, rerender;

  	data = data || {};

  	if (typeof data !== "object") {
  		throw new Error("The reset method takes either no arguments, or an object containing new data");
  	}

  	// If the root object is wrapped, try and use the wrapper's reset value
  	if ((wrapper = this.viewmodel.wrapped[""]) && wrapper.reset) {
  		if (wrapper.reset(data) === false) {
  			// reset was rejected, we need to replace the object
  			this.viewmodel.reset(data);
  		}
  	} else {
  		this.viewmodel.reset(data);
  	}

  	// reset config items and track if need to rerender
  	changes = config_config.reset(this);

  	i = changes.length;
  	while (i--) {
  		if (shouldRerender.indexOf(changes[i]) > -1) {
  			rerender = true;
  			break;
  		}
  	}

  	if (rerender) {
  		var component = undefined;

  		this.viewmodel.mark(rootKeypath);

  		// Is this is a component, we need to set the `shouldDestroy`
  		// flag, otherwise it will assume by default that a parent node
  		// will be detached, and therefore it doesn't need to bother
  		// detaching its own nodes
  		if (component = this.component) {
  			component.shouldDestroy = true;
  		}

  		this.unrender();

  		if (component) {
  			component.shouldDestroy = false;
  		}

  		// If the template changed, we need to destroy the parallel DOM
  		// TODO if we're here, presumably it did?
  		if (this.fragment.template !== this.template) {
  			this.fragment.unbind();

  			this.fragment = new virtualdom_Fragment({
  				template: this.template,
  				root: this,
  				owner: this
  			});
  		}

  		promise = this.render(this.el, this.anchor);
  	} else {
  		promise = global_runloop.start(this, true);
  		this.viewmodel.mark(rootKeypath);
  		global_runloop.end();
  	}

  	resetHook.fire(this, data);

  	return promise;
  }

  var resetPartial = function (name, partial) {
  	var promise,
  	    collection = [];

  	function collect(source, dest, ractive) {
  		// if this is a component and it has its own partial, bail
  		if (ractive && ractive.partials[name]) return;

  		source.forEach(function (item) {
  			// queue to rerender if the item is a partial and the current name matches
  			if (item.type === PARTIAL && item.getPartialName() === name) {
  				dest.push(item);
  			}

  			// if it has a fragment, process its items
  			if (item.fragment) {
  				collect(item.fragment.items, dest, ractive);
  			}

  			// or if it has fragments
  			if (isArray(item.fragments)) {
  				collect(item.fragments, dest, ractive);
  			}

  			// or if it is itself a fragment, process its items
  			else if (isArray(item.items)) {
  				collect(item.items, dest, ractive);
  			}

  			// or if it is a component, step in and process its items
  			else if (item.type === COMPONENT && item.instance) {
  				collect(item.instance.fragment.items, dest, item.instance);
  			}

  			// if the item is an element, process its attributes too
  			if (item.type === ELEMENT) {
  				if (isArray(item.attributes)) {
  					collect(item.attributes, dest, ractive);
  				}

  				if (isArray(item.conditionalAttributes)) {
  					collect(item.conditionalAttributes, dest, ractive);
  				}
  			}
  		});
  	}

  	collect(this.fragment.items, collection);
  	this.partials[name] = partial;

  	promise = global_runloop.start(this, true);

  	collection.forEach(function (item) {
  		item.value = undefined;
  		item.setValue(name);
  	});

  	global_runloop.end();

  	return promise;
  };

  // TODO should resetTemplate be asynchronous? i.e. should it be a case
  // of outro, update template, intro? I reckon probably not, since that
  // could be achieved with unrender-resetTemplate-render. Also, it should
  // conceptually be similar to resetPartial, which couldn't be async

  var resetTemplate = Ractive$resetTemplate;
  function Ractive$resetTemplate(template) {
  	var transitionsEnabled, component;

  	template_template.init(null, this, { template: template });

  	transitionsEnabled = this.transitionsEnabled;
  	this.transitionsEnabled = false;

  	// Is this is a component, we need to set the `shouldDestroy`
  	// flag, otherwise it will assume by default that a parent node
  	// will be detached, and therefore it doesn't need to bother
  	// detaching its own nodes
  	if (component = this.component) {
  		component.shouldDestroy = true;
  	}

  	this.unrender();

  	if (component) {
  		component.shouldDestroy = false;
  	}

  	// remove existing fragment and create new one
  	this.fragment.unbind();
  	this.fragment = new virtualdom_Fragment({
  		template: this.template,
  		root: this,
  		owner: this
  	});

  	this.render(this.el, this.anchor);

  	this.transitionsEnabled = transitionsEnabled;
  }

  var reverse = makeArrayMethod("reverse");

  var Ractive_prototype_set = Ractive$set;

  function Ractive$set(keypath, value) {
  	var map, promise;

  	promise = global_runloop.start(this, true);

  	// Set multiple keypaths in one go
  	if (isObject(keypath)) {
  		map = keypath;

  		for (keypath in map) {
  			if (map.hasOwnProperty(keypath)) {
  				value = map[keypath];
  				set(this, keypath, value);
  			}
  		}
  	}

  	// Set a single keypath
  	else {
  		set(this, keypath, value);
  	}

  	global_runloop.end();

  	return promise;
  }

  function set(ractive, keypath, value) {
  	keypath = getKeypath(normalise(keypath));

  	if (keypath.isPattern) {
  		getMatchingKeypaths(ractive, keypath).forEach(function (keypath) {
  			ractive.viewmodel.set(keypath, value);
  		});
  	} else {
  		ractive.viewmodel.set(keypath, value);
  	}
  }

  var shift = makeArrayMethod("shift");

  var prototype_sort = makeArrayMethod("sort");

  var splice = makeArrayMethod("splice");

  var subtract = Ractive$subtract;
  function Ractive$subtract(keypath, d) {
  	return shared_add(this, keypath, d === undefined ? -1 : -d);
  }

  // Teardown. This goes through the root fragment and all its children, removing observers
  // and generally cleaning up after itself

  var Ractive_prototype_teardown = Ractive$teardown;

  var Ractive_prototype_teardown__teardownHook = new hooks_Hook("teardown");
  function Ractive$teardown() {
  	var promise;

  	this.fragment.unbind();
  	this.viewmodel.teardown();

  	this._observers.forEach(cancel);

  	if (this.fragment.rendered && this.el.__ractive_instances__) {
  		removeFromArray(this.el.__ractive_instances__, this);
  	}

  	this.shouldDestroy = true;
  	promise = this.fragment.rendered ? this.unrender() : utils_Promise.resolve();

  	Ractive_prototype_teardown__teardownHook.fire(this);

  	this._boundFunctions.forEach(deleteFunctionCopy);

  	return promise;
  }

  function deleteFunctionCopy(bound) {
  	delete bound.fn[bound.prop];
  }

  var toggle = Ractive$toggle;
  function Ractive$toggle(keypath) {
  	var _this = this;

  	if (typeof keypath !== "string") {
  		throw new TypeError(badArguments);
  	}

  	var changes = undefined;

  	if (/\*/.test(keypath)) {
  		changes = {};

  		getMatchingKeypaths(this, getKeypath(normalise(keypath))).forEach(function (keypath) {
  			changes[keypath.str] = !_this.viewmodel.get(keypath);
  		});

  		return this.set(changes);
  	}

  	return this.set(keypath, !this.get(keypath));
  }

  var toHTML = Ractive$toHTML;

  function Ractive$toHTML() {
  	return this.fragment.toString(true);
  }

  var Ractive_prototype_unrender = Ractive$unrender;
  var unrenderHook = new hooks_Hook("unrender");
  function Ractive$unrender() {
  	var promise, shouldDestroy;

  	if (!this.fragment.rendered) {
  		warnIfDebug("ractive.unrender() was called on a Ractive instance that was not rendered");
  		return utils_Promise.resolve();
  	}

  	promise = global_runloop.start(this, true);

  	// If this is a component, and the component isn't marked for destruction,
  	// don't detach nodes from the DOM unnecessarily
  	shouldDestroy = !this.component || this.component.shouldDestroy || this.shouldDestroy;

  	// Cancel any animations in progress
  	while (this._animations[0]) {
  		this._animations[0].stop(); // it will remove itself from the index
  	}

  	this.fragment.unrender(shouldDestroy);

  	removeFromArray(this.el.__ractive_instances__, this);

  	unrenderHook.fire(this);

  	global_runloop.end();
  	return promise;
  }

  var unshift = makeArrayMethod("unshift");

  var Ractive_prototype_update = Ractive$update;
  var updateHook = new hooks_Hook("update");
  function Ractive$update(keypath) {
  	var promise;

  	keypath = getKeypath(keypath) || rootKeypath;

  	promise = global_runloop.start(this, true);
  	this.viewmodel.mark(keypath);
  	global_runloop.end();

  	updateHook.fire(this, keypath);

  	return promise;
  }

  var prototype_updateModel = Ractive$updateModel;

  function Ractive$updateModel(keypath, cascade) {
  	var values, key, bindings;

  	if (typeof keypath === "string" && !cascade) {
  		bindings = this._twowayBindings[keypath];
  	} else {
  		bindings = [];

  		for (key in this._twowayBindings) {
  			if (!keypath || getKeypath(key).equalsOrStartsWith(keypath)) {
  				// TODO is this right?
  				bindings.push.apply(bindings, this._twowayBindings[key]);
  			}
  		}
  	}

  	values = consolidate(this, bindings);
  	return this.set(values);
  }

  function consolidate(ractive, bindings) {
  	var values = {},
  	    checkboxGroups = [];

  	bindings.forEach(function (b) {
  		var oldValue, newValue;

  		// special case - radio name bindings
  		if (b.radioName && !b.element.node.checked) {
  			return;
  		}

  		// special case - checkbox name bindings come in groups, so
  		// we want to get the value once at most
  		if (b.checkboxName) {
  			if (!checkboxGroups[b.keypath.str] && !b.changed()) {
  				checkboxGroups.push(b.keypath);
  				checkboxGroups[b.keypath.str] = b;
  			}

  			return;
  		}

  		oldValue = b.attribute.value;
  		newValue = b.getValue();

  		if (arrayContentsMatch(oldValue, newValue)) {
  			return;
  		}

  		if (!isEqual(oldValue, newValue)) {
  			values[b.keypath.str] = newValue;
  		}
  	});

  	// Handle groups of `<input type='checkbox' name='{{foo}}' ...>`
  	if (checkboxGroups.length) {
  		checkboxGroups.forEach(function (keypath) {
  			var binding, oldValue, newValue;

  			binding = checkboxGroups[keypath.str]; // one to represent the entire group
  			oldValue = binding.attribute.value;
  			newValue = binding.getValue();

  			if (!arrayContentsMatch(oldValue, newValue)) {
  				values[keypath.str] = newValue;
  			}
  		});
  	}

  	return values;
  }

  var prototype = {
  	add: prototype_add,
  	animate: prototype_animate,
  	detach: prototype_detach,
  	find: prototype_find,
  	findAll: prototype_findAll,
  	findAllComponents: prototype_findAllComponents,
  	findComponent: prototype_findComponent,
  	findContainer: findContainer,
  	findParent: findParent,
  	fire: prototype_fire,
  	get: prototype_get,
  	insert: insert,
  	merge: prototype_merge,
  	observe: observe,
  	observeOnce: observeOnce,
  	off: off,
  	on: on,
  	once: once,
  	pop: pop,
  	push: push,
  	render: prototype_render,
  	reset: prototype_reset,
  	resetPartial: resetPartial,
  	resetTemplate: resetTemplate,
  	reverse: reverse,
  	set: Ractive_prototype_set,
  	shift: shift,
  	sort: prototype_sort,
  	splice: splice,
  	subtract: subtract,
  	teardown: Ractive_prototype_teardown,
  	toggle: toggle,
  	toHTML: toHTML,
  	toHtml: toHTML,
  	unrender: Ractive_prototype_unrender,
  	unshift: unshift,
  	update: Ractive_prototype_update,
  	updateModel: prototype_updateModel
  };

  var wrapMethod = function (method, superMethod, force) {

  	if (force || needsSuper(method, superMethod)) {

  		return function () {

  			var hasSuper = ("_super" in this),
  			    _super = this._super,
  			    result;

  			this._super = superMethod;

  			result = method.apply(this, arguments);

  			if (hasSuper) {
  				this._super = _super;
  			}

  			return result;
  		};
  	} else {
  		return method;
  	}
  };

  function needsSuper(method, superMethod) {
  	return typeof superMethod === "function" && /_super/.test(method);
  }

  var unwrapExtended = unwrap;

  function unwrap(Child) {
  	var options = {};

  	while (Child) {
  		addRegistries(Child, options);
  		addOtherOptions(Child, options);

  		if (Child._Parent !== _Ractive) {
  			Child = Child._Parent;
  		} else {
  			Child = false;
  		}
  	}

  	return options;
  }

  function addRegistries(Child, options) {
  	config_registries.forEach(function (r) {
  		addRegistry(r.useDefaults ? Child.prototype : Child, options, r.name);
  	});
  }

  function addRegistry(target, options, name) {
  	var registry,
  	    keys = Object.keys(target[name]);

  	if (!keys.length) {
  		return;
  	}

  	if (!(registry = options[name])) {
  		registry = options[name] = {};
  	}

  	keys.filter(function (key) {
  		return !(key in registry);
  	}).forEach(function (key) {
  		return registry[key] = target[name][key];
  	});
  }

  function addOtherOptions(Child, options) {
  	Object.keys(Child.prototype).forEach(function (key) {
  		if (key === "computed") {
  			return;
  		}

  		var value = Child.prototype[key];

  		if (!(key in options)) {
  			options[key] = value._method ? value._method : value;
  		}

  		// is it a wrapped function?
  		else if (typeof options[key] === "function" && typeof value === "function" && options[key]._method) {

  			var result = undefined,
  			    needsSuper = value._method;

  			if (needsSuper) {
  				value = value._method;
  			}

  			// rewrap bound directly to parent fn
  			result = wrapMethod(options[key]._method, value);

  			if (needsSuper) {
  				result._method = result;
  			}

  			options[key] = result;
  		}
  	});
  }

  var _extend = _extend__extend;

  function _extend__extend() {
  	for (var _len = arguments.length, options = Array(_len), _key = 0; _key < _len; _key++) {
  		options[_key] = arguments[_key];
  	}

  	if (!options.length) {
  		return extendOne(this);
  	} else {
  		return options.reduce(extendOne, this);
  	}
  }

  function extendOne(Parent) {
  	var options = arguments[1] === undefined ? {} : arguments[1];

  	var Child, proto;

  	// if we're extending with another Ractive instance...
  	//
  	//   var Human = Ractive.extend(...), Spider = Ractive.extend(...);
  	//   var Spiderman = Human.extend( Spider );
  	//
  	// ...inherit prototype methods and default options as well
  	if (options.prototype instanceof _Ractive) {
  		options = unwrapExtended(options);
  	}

  	Child = function (options) {
  		if (!(this instanceof Child)) return new Child(options);
  		initialise(this, options);
  	};

  	proto = create(Parent.prototype);
  	proto.constructor = Child;

  	// Static properties
  	defineProperties(Child, {
  		// alias prototype as defaults
  		defaults: { value: proto },

  		// extendable
  		extend: { value: _extend__extend, writable: true, configurable: true },

  		// Parent - for IE8, can't use Object.getPrototypeOf
  		_Parent: { value: Parent }
  	});

  	// extend configuration
  	config_config.extend(Parent, proto, options);

  	custom_data.extend(Parent, proto, options);

  	if (options.computed) {
  		proto.computed = utils_object__extend(create(Parent.prototype.computed), options.computed);
  	}

  	Child.prototype = proto;

  	return Child;
  }

  var getNodeInfo = function (node) {
  	var info = {},
  	    priv,
  	    indices;

  	if (!node || !(priv = node._ractive)) {
  		return info;
  	}

  	info.ractive = priv.root;
  	info.keypath = priv.keypath.str;
  	info.index = {};

  	// find all index references and resolve them
  	if (indices = Resolvers_findIndexRefs(priv.proxy.parentFragment)) {
  		info.index = Resolvers_findIndexRefs.resolve(indices);
  	}

  	return info;
  };

  var Ractive, properties;

  // Main Ractive required object
  Ractive = function (options) {
  	if (!(this instanceof Ractive)) return new Ractive(options);
  	initialise(this, options);
  };

  // Ractive properties
  properties = {

  	// debug flag
  	DEBUG: { writable: true, value: true },
  	DEBUG_PROMISES: { writable: true, value: true },

  	// static methods:
  	extend: { value: _extend },
  	getNodeInfo: { value: getNodeInfo },
  	parse: { value: parse },

  	// Namespaced constructors
  	Promise: { value: utils_Promise },

  	// support
  	svg: { value: svg },
  	magic: { value: environment__magic },

  	// version
  	VERSION: { value: "0.7.3" },

  	// Plugins
  	adaptors: { writable: true, value: {} },
  	components: { writable: true, value: {} },
  	decorators: { writable: true, value: {} },
  	easing: { writable: true, value: static_easing },
  	events: { writable: true, value: {} },
  	interpolators: { writable: true, value: static_interpolators },
  	partials: { writable: true, value: {} },
  	transitions: { writable: true, value: {} }
  };

  // Ractive properties
  defineProperties(Ractive, properties);

  Ractive.prototype = utils_object__extend(prototype, config_defaults);

  Ractive.prototype.constructor = Ractive;

  // alias prototype as defaults
  Ractive.defaults = Ractive.prototype;

  // Ractive.js makes liberal use of things like Array.prototype.indexOf. In
  // older browsers, these are made available via a shim - here, we do a quick
  // pre-flight check to make sure that either a) we're not in a shit browser,
  // or b) we're using a Ractive-legacy.js build
  var FUNCTION = "function";

  if (typeof Date.now !== FUNCTION || typeof String.prototype.trim !== FUNCTION || typeof Object.keys !== FUNCTION || typeof Array.prototype.indexOf !== FUNCTION || typeof Array.prototype.forEach !== FUNCTION || typeof Array.prototype.map !== FUNCTION || typeof Array.prototype.filter !== FUNCTION || typeof window !== "undefined" && typeof window.addEventListener !== FUNCTION) {
  	throw new Error("It looks like you're attempting to use Ractive.js in an older browser. You'll need to use one of the 'legacy builds' in order to continue - see http://docs.ractivejs.org/latest/legacy-builds for more information.");
  }

  var _Ractive = Ractive;

  return _Ractive;

}));


},{}],206:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

component.exports = {
  oninit: function oninit() {
    var _this = this;

    this.observe('value', function (newkey, oldkey, keypath) {
      var _get = _this.get(),
          min = _get.min,
          max = _get.max;

      var value = Math.clamp(min, max, newkey);
      _this.animate('percentage', Math.round((value - min) / (max - min) * 100));
    });
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"p":[13,1,305],"t":7,"e":"div","a":{"class":"bar"},"f":[{"p":[14,3,326],"t":7,"e":"div","a":{"class":["barFill ",{"t":2,"r":"state","p":[14,23,346]}],"style":["width: ",{"t":2,"r":"percentage","p":[14,48,371]},"%"]}}," ",{"p":[15,3,398],"t":7,"e":"span","a":{"class":"barText"},"f":[{"t":16,"p":[15,25,420]}]}]}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205}],207:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

var _constants = require('util/constants');

var _byond = require('util/byond');

component.exports = {
  computed: {
    clickable: function clickable() {
      if (this.get('enabled') && (!this.get('state') || this.get('state') == "toggle")) {
        return true;
      }
      return false;
    },
    enabled: function enabled() {
      if (this.get('config.status') === _constants.UI_INTERACTIVE) {
        return true;
      }
      return false;
    },
    styles: function styles() {
      var extra = '';
      if (this.get('class')) extra += ' ' + this.get('class');
      if (this.get('tooltip-side')) extra = ' tooltip-' + this.get('tooltip-side');
      if (this.get('grid')) extra += ' gridable';
      if (this.get('enabled')) {
        var state = this.get('state');
        var style = this.get('style');
        if (!state) {
          return 'active normal ' + style + ' ' + extra;
        } else {
          return 'inactive ' + state + ' ' + extra;
        }
      } else {
        return 'inactive disabled ' + extra;
      }
    }
  },
  oninit: function oninit() {
    var _this = this;

    this.on('press', function (event) {
      var _get = _this.get(),
          action = _get.action,
          params = _get.params;

      (0, _byond.act)(_this.get('config.ref'), action, params);
      event.node.blur();
    });
  },

  data: {
    iconStackToHTML: function iconStackToHTML(icon_stack) {
      //turns a string such as 'square-o 2x, twitter 1x' into fully valid fontawesome syntax+HTML
      var resultHTML = '';
      var icons = icon_stack.split(',');
      if (icons.length) {
        resultHTML += '<span class=\"fa-stack\">';
        for (var _iterator = icons, _isArray = Array.isArray(_iterator), _i = 0, _iterator = _isArray ? _iterator : _iterator[Symbol.iterator]();;) {
          var _ref;

          if (_isArray) {
            if (_i >= _iterator.length) break;
            _ref = _iterator[_i++];
          } else {
            _i = _iterator.next();
            if (_i.done) break;
            _ref = _i.value;
          }

          var iconinfo = _ref;

          var regex = /([\w\-]+)\s*(\dx)/g;
          var components = regex.exec(iconinfo);
          var icon = components[1]; //0 is the entire string
          var size = components[2];
          resultHTML += '<i class=\"fa fa-' + icon + ' fa-stack-' + size + '\"></i>';
        }
      }
      if (resultHTML) {
        resultHTML += '</span>';
      }
      return resultHTML;
    }
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"p":[70,1,2015],"t":7,"e":"span","a":{"class":["button ",{"t":2,"r":"styles","p":[70,21,2035]}],"unselectable":"on","data-tooltip":[{"t":2,"r":"tooltip","p":[73,17,2120]}]},"m":[{"t":4,"f":["tabindex='0'"],"r":"clickable","p":[72,3,2071]}],"v":{"mouseover-mousemove":"hover","mouseleave":"unhover","click-enter":{"n":[{"t":4,"f":["press"],"r":"clickable","p":[76,19,2213]}],"d":[]}},"f":[{"t":4,"f":[{"p":[78,5,2261],"t":7,"e":"i","a":{"class":["fa fa-",{"t":2,"r":"icon","p":[78,21,2277]}]}}],"n":50,"r":"icon","p":[77,3,2243]}," ",{"t":4,"f":[{"t":3,"x":{"r":["iconStackToHTML","icon_stack"],"s":"_0(_1)"},"p":[81,6,2331]}],"n":50,"r":"icon_stack","p":[80,3,2306]}," ",{"t":16,"p":[83,3,2379]}]}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205,"util/byond":230,"util/constants":231}],208:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"div","a":{"class":"display"},"f":[{"t":4,"f":[{"p":[3,5,44],"t":7,"e":"header","f":[{"p":[4,7,60],"t":7,"e":"h3","f":[{"t":2,"r":"title","p":[4,11,64]}]}," ",{"t":4,"f":[{"p":[6,9,110],"t":7,"e":"div","a":{"class":"buttonRight"},"f":[{"t":16,"n":"button","p":[6,34,135]}]}],"n":50,"r":"button","p":[5,7,86]}]}],"n":50,"r":"title","p":[2,3,25]}," ",{"p":[10,3,202],"t":7,"e":"article","f":[{"t":16,"p":[11,5,217]}]}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],209:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

component.exports = {
  oninit: function oninit() {
    var _this = this;

    this.on('clear', function () {
      _this.set('value', '');
      _this.find('input').focus();
    });
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"p":[12,1,170],"t":7,"e":"input","a":{"type":"text","value":[{"t":2,"r":"value","p":[12,27,196]}],"placeholder":[{"t":2,"r":"placeholder","p":[12,51,220]}]}}," ",{"p":[13,1,240],"t":7,"e":"ui-button","a":{"icon":"refresh"},"v":{"press":"clear"}}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205}],210:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

component.exports = {
  data: {
    graph: require('paths-js/smooth-line'),
    xaccessor: function xaccessor(point) {
      return point.x;
    },
    yaccessor: function yaccessor(point) {
      return point.y;
    }
  },
  computed: {
    size: function size() {
      var points = this.get('points');
      return points[0].length;
    },
    scale: function scale() {
      var points = this.get('points');
      return Math.max.apply(Math, Array.map(points, function (a) {
        return Math.max.apply(Math, Array.map(a, function (p) {
          return p.y;
        }));
      }));
    },
    xaxis: function xaxis() {
      var xinc = this.get('xinc');
      var size = this.get('size');
      return Array.from(Array(size).keys()).filter(function (num) {
        return num && num % xinc == 0;
      });
    },
    yaxis: function yaxis() {
      var yinc = this.get('yinc');
      var scale = this.get('scale');
      return Array.from(Array(yinc).keys()).map(function (num) {
        return Math.round(scale * (++num / 100) * 10);
      });
    }
  },
  oninit: function oninit() {
    var _this = this;

    this.on({
      enter: function enter(event) {
        this.set('selected', event.index.count);
      },
      exit: function exit(event) {
        this.set('selected');
      }
    });
    window.addEventListener('resize', function (event) {
      _this.set('width', _this.el.clientWidth);
    });
  },
  onrender: function onrender() {
    this.set('width', this.el.clientWidth);
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"p":[47,1,1269],"t":7,"e":"svg","a":{"class":"linegraph","width":"100%","height":[{"t":2,"x":{"r":["height"],"s":"_0+10"},"p":[47,45,1313]}]},"f":[{"p":[48,3,1334],"t":7,"e":"g","a":{"transform":"translate(0, 5)"},"f":[{"t":4,"f":[{"t":4,"f":[{"p":[51,9,1504],"t":7,"e":"line","a":{"x1":[{"t":2,"x":{"r":["xscale","."],"s":"_0(_1)"},"p":[51,19,1514]}],"x2":[{"t":2,"x":{"r":["xscale","."],"s":"_0(_1)"},"p":[51,38,1533]}],"y1":"0","y2":[{"t":2,"r":"height","p":[51,64,1559]}],"stroke":"darkgray"}}," ",{"t":4,"f":[{"p":[53,11,1635],"t":7,"e":"text","a":{"x":[{"t":2,"x":{"r":["xscale","."],"s":"_0(_1)"},"p":[53,20,1644]}],"y":[{"t":2,"x":{"r":["height"],"s":"_0-5"},"p":[53,38,1662]}],"text-anchor":"middle","fill":"white"},"f":[{"t":2,"x":{"r":["size",".","xfactor"],"s":"(_0-_1)*_2"},"p":[53,88,1712]}," ",{"t":2,"r":"xunit","p":[53,113,1737]}]}],"n":50,"x":{"r":["@index"],"s":"_0%2==0"},"p":[52,9,1600]}],"n":52,"r":"xaxis","p":[50,7,1479]}," ",{"t":4,"f":[{"p":[57,9,1820],"t":7,"e":"line","a":{"x1":"0","x2":[{"t":2,"r":"width","p":[57,26,1837]}],"y1":[{"t":2,"x":{"r":["yscale","."],"s":"_0(_1)"},"p":[57,41,1852]}],"y2":[{"t":2,"x":{"r":["yscale","."],"s":"_0(_1)"},"p":[57,60,1871]}],"stroke":"darkgray"}}," ",{"p":[58,9,1915],"t":7,"e":"text","a":{"x":"0","y":[{"t":2,"x":{"r":["yscale","."],"s":"_0(_1)-5"},"p":[58,24,1930]}],"text-anchor":"begin","fill":"white"},"f":[{"t":2,"x":{"r":[".","yfactor"],"s":"_0*_1"},"p":[58,76,1982]}," ",{"t":2,"r":"yunit","p":[58,92,1998]}]}],"n":52,"r":"yaxis","p":[56,7,1795]}," ",{"t":4,"f":[{"p":[61,9,2071],"t":7,"e":"path","a":{"d":[{"t":2,"x":{"r":["area.path"],"s":"_0.print()"},"p":[61,18,2080]}],"fill":[{"t":2,"rx":{"r":"colors","m":[{"t":30,"n":"curve"}]},"p":[61,47,2109]}],"opacity":"0.1"}}],"n":52,"i":"curve","r":"curves","p":[60,7,2039]}," ",{"t":4,"f":[{"p":[64,9,2200],"t":7,"e":"path","a":{"d":[{"t":2,"x":{"r":["line.path"],"s":"_0.print()"},"p":[64,18,2209]}],"stroke":[{"t":2,"rx":{"r":"colors","m":[{"t":30,"n":"curve"}]},"p":[64,49,2240]}],"fill":"none"}}],"n":52,"i":"curve","r":"curves","p":[63,7,2168]}," ",{"t":4,"f":[{"t":4,"f":[{"p":[68,11,2375],"t":7,"e":"circle","a":{"transform":["translate(",{"t":2,"r":".","p":[68,40,2404]},")"],"r":[{"t":2,"x":{"r":["selected","count"],"s":"_0==_1?10:4"},"p":[68,51,2415]}],"fill":[{"t":2,"rx":{"r":"colors","m":[{"t":30,"n":"curve"}]},"p":[68,89,2453]}]},"v":{"mouseenter":"enter","mouseleave":"exit"}}],"n":52,"i":"count","x":{"r":["line.path"],"s":"_0.points()"},"p":[67,9,2329]}],"n":52,"i":"curve","r":"curves","p":[66,7,2297]}," ",{"t":4,"f":[{"t":4,"f":[{"t":4,"f":[{"p":[74,13,2678],"t":7,"e":"text","a":{"transform":["translate(",{"t":2,"r":".","p":[74,40,2705]},") ",{"t":2,"x":{"r":["count","size"],"s":"_0<=_1/2?\"translate(15, 4)\":\"translate(-15, 4)\""},"p":[74,47,2712]}],"text-anchor":[{"t":2,"x":{"r":["count","size"],"s":"_0<=_1/2?\"start\":\"end\""},"p":[74,126,2791]}],"fill":"white"},"f":[{"t":2,"x":{"r":["count","item","yfactor"],"s":"_1[_0].y*_2"},"p":[75,15,2861]}," ",{"t":2,"r":"yunit","p":[75,43,2889]}," @ ",{"t":2,"x":{"r":["size","count","item","xfactor"],"s":"(_0-_2[_1].x)*_3"},"p":[75,55,2901]}," ",{"t":2,"r":"xunit","p":[75,92,2938]}]}],"n":50,"x":{"r":["selected","count"],"s":"_0==_1"},"p":[73,11,2638]}],"n":52,"i":"count","x":{"r":["line.path"],"s":"_0.points()"},"p":[72,9,2592]}],"n":52,"i":"curve","r":"curves","p":[71,7,2560]}," ",{"t":4,"f":[{"p":[81,9,3063],"t":7,"e":"g","a":{"transform":["translate(",{"t":2,"x":{"r":["width","curves.length","@index"],"s":"(_0/(_1+1))*(_2+1)"},"p":[81,33,3087]},", 10)"]},"f":[{"p":[82,11,3154],"t":7,"e":"circle","a":{"r":"4","fill":[{"t":2,"rx":{"r":"colors","m":[{"t":30,"n":"curve"}]},"p":[82,31,3174]}]}}," ",{"p":[83,11,3206],"t":7,"e":"text","a":{"x":"8","y":"4","fill":"white"},"f":[{"t":2,"rx":{"r":"legend","m":[{"t":30,"n":"curve"}]},"p":[83,42,3237]}]}]}],"n":52,"i":"curve","r":"curves","p":[80,7,3031]}],"x":{"r":["graph","points","xaccessor","yaccessor","width","height"],"s":"_0({data:_1,xaccessor:_2,yaccessor:_3,width:_4,height:_5})"},"p":[49,5,1371]}]}]}]};
module.exports = Ractive.extend(component.exports);

},{"paths-js/smooth-line":201,"ractive":205}],211:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"div","a":{"class":"notice"},"f":[{"t":16,"p":[2,3,24]}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],212:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

var _byond = require('util/byond');

var _dragresize = require('util/dragresize');

component.exports = {
  oninit: function oninit() {
    var _this = this;

    var onresize = _dragresize.resize.bind(this);
    var onrelease = function onrelease() {
      return _this.set({ resize: false, x: null, y: null });
    };

    this.observe('config.fancy', function (newkey, oldkey, keypath) {
      (0, _byond.winset)(_this.get('config.window'), 'can-resize', !newkey);

      if (newkey) {
        document.addEventListener('mousemove', onresize);
        document.addEventListener('mouseup', onrelease);
      } else {
        document.removeEventListener('mousemove', onresize);
        document.removeEventListener('mouseup', onrelease);
      }
    });

    this.on('resize', function () {
      return _this.toggle('resize');
    });
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"t":4,"f":[{"p":[28,3,766],"t":7,"e":"div","a":{"class":"resize"},"v":{"mousedown":"resize"}}],"n":50,"r":"config.fancy","p":[27,1,742]}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205,"util/byond":230,"util/dragresize":232}],213:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"section","a":{"class":[{"t":4,"f":["candystripe"],"r":"candystripe","p":[1,17,16]}]},"f":[{"t":4,"f":[{"p":[3,5,84],"t":7,"e":"span","a":{"class":"label","style":[{"t":4,"f":["color:",{"t":2,"r":"labelcolor","p":[3,53,132]}],"r":"labelcolor","p":[3,32,111]}]},"f":[{"t":2,"r":"label","p":[3,84,163]},":"]}],"n":50,"r":"label","p":[2,3,65]}," ",{"t":4,"f":[{"t":16,"p":[6,5,215]}],"n":50,"r":"nowrap","p":[5,3,195]},{"t":4,"n":51,"f":[{"p":[8,5,242],"t":7,"e":"div","a":{"class":"content","style":[{"t":4,"f":["float:right;"],"r":"right","p":[8,33,270]}]},"f":[{"t":16,"p":[9,7,312]}]}],"r":"nowrap"}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],214:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"div","a":{"class":"subdisplay"},"f":[{"t":4,"f":[{"p":[3,5,47],"t":7,"e":"header","f":[{"p":[4,7,63],"t":7,"e":"h4","f":[{"t":2,"r":"title","p":[4,11,67]}]}," ",{"t":4,"f":[{"t":16,"n":"button","p":[5,21,103]}],"n":50,"r":"button","p":[5,7,89]}]}],"n":50,"r":"title","p":[2,3,28]}," ",{"p":[8,3,156],"t":7,"e":"article","f":[{"t":16,"p":[9,5,171]}]}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],215:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

component.exports = {
  oninit: function oninit() {
    var _this = this;

    this.set('active', this.findComponent('tab').get('name'));
    this.on('switch', function (event) {
      _this.set('active', event.node.textContent.trim()); // Hack but it works...
    });

    this.observe('active', function (newkey, oldkey, path) {
      for (var _iterator = _this.findAllComponents('tab'), _isArray = Array.isArray(_iterator), _i = 0, _iterator = _isArray ? _iterator : _iterator[Symbol.iterator]();;) {
        var _ref;

        if (_isArray) {
          if (_i >= _iterator.length) break;
          _ref = _iterator[_i++];
        } else {
          _i = _iterator.next();
          if (_i.done) break;
          _ref = _i.value;
        }

        var tab = _ref;

        tab.set('shown', tab.get('name') === newkey);
      }
    });
  }
};
})(component);
component.exports.template = {"v":3,"t":[" "," ",{"p":[20,1,524],"t":7,"e":"header","f":[{"t":4,"f":[{"p":[22,5,556],"t":7,"e":"ui-button","a":{"pane":[{"t":2,"r":".","p":[22,22,573]}]},"v":{"press":"switch"},"f":[{"t":2,"r":".","p":[22,47,598]}]}],"n":52,"r":"tabs","p":[21,3,536]}]}," ",{"p":[25,1,641],"t":7,"e":"ui-display","f":[{"t":8,"r":"content","p":[26,3,657]}]}]};
component.exports.components = component.exports.components || {};
var components = {
  "tab": require("components/tabs/tab.ract")
};
for (var k in components) {
  if (components.hasOwnProperty(k))
    component.exports.components[k] = components[k];
}
module.exports = Ractive.extend(component.exports);

},{"components/tabs/tab.ract":216,"ractive":205}],216:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"t":4,"f":[{"t":16,"p":[2,3,17]}],"n":50,"r":"shown","p":[1,1,0]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],217:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

var _constants = require('util/constants');

var _byond = require('util/byond');

var _dragresize = require('util/dragresize');

component.exports = {
  computed: {
    visualStatus: function visualStatus() {
      switch (this.get('config.status')) {
        case _constants.UI_INTERACTIVE:
          return 'good';
        case _constants.UI_UPDATE:
          return 'average';
        case _constants.UI_DISABLED:
          return 'bad';
        default:
          return 'bad';
      }
    }
  },
  oninit: function oninit() {
    var _this = this;

    var ondrag = _dragresize.drag.bind(this);
    var onrelease = function onrelease(event) {
      return _this.set({ drag: false, x: null, y: null });
    };

    this.observe('config.fancy', function (newkey, oldkey, keypath) {
      (0, _byond.winset)(_this.get('config.window'), 'titlebar', !newkey && _this.get('config.titlebar'));

      if (newkey) {
        document.addEventListener('mousemove', ondrag);
        document.addEventListener('mouseup', onrelease);
      } else {
        document.removeEventListener('mousemove', ondrag);
        document.removeEventListener('mouseup', onrelease);
      }
    });

    this.on({
      drag: function drag() {
        this.toggle('drag');
      },
      close: function close() {
        (0, _byond.winset)(this.get('config.window'), 'is-visible', false);
        window.location.href = (0, _byond.href)({ command: 'uiclose ' + this.get('config.ref') }, 'winset');
      },
      minimize: function minimize() {
        (0, _byond.winset)(this.get('config.window'), 'is-minimized', true);
      }
    });
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"t":4,"f":[{"p":[50,3,1440],"t":7,"e":"header","a":{"class":"titlebar"},"v":{"mousedown":"drag"},"f":[{"p":[51,5,1491],"t":7,"e":"i","a":{"class":["statusicon fa fa-eye fa-2x ",{"t":2,"r":"visualStatus","p":[51,42,1528]}]}}," ",{"p":[52,5,1556],"t":7,"e":"span","a":{"class":"title"},"f":[{"t":16,"p":[52,25,1576]}]}," ",{"t":4,"f":[{"p":[54,7,1626],"t":7,"e":"i","a":{"class":"minimize fa fa-minus fa-2x"},"v":{"click":"minimize"}}," ",{"p":[55,7,1696],"t":7,"e":"i","a":{"class":"close fa fa-close fa-2x"},"v":{"click":"close"}}],"n":50,"r":"config.fancy","p":[53,5,1598]}]}],"n":50,"r":"config.titlebar","p":[49,1,1413]}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205,"util/byond":230,"util/constants":231,"util/dragresize":232}],218:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

var versions = [11, 10, 9, 8];

component.exports = {
  data: {
    userAgent: navigator.userAgent
  },
  computed: {
    ie: function ie() {
      if (document.documentMode) return document.documentMode;
      for (var version in versions) {
        var div = document.createElement('div');
        div.innerHTML = '<!--[if IE ' + version + ']><span></span><![endif]-->';
        if (div.getElementsByTagName('span').length) return version;
      }
      return undefined;
    }
  },
  oninit: function oninit() {
    var _this = this;

    this.on('debug', function () {
      return _this.toggle('debug');
    });
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"t":4,"f":[{"p":[27,3,662],"t":7,"e":"ui-notice","f":[{"p":[28,5,679],"t":7,"e":"span","f":["You have an old (IE",{"t":2,"r":"ie","p":[28,30,704]},"), end-of-life (click 'EOL Info' for more information) version of Internet Explorer installed."]},{"p":[28,137,811],"t":7,"e":"br"}," ",{"p":[29,5,822],"t":7,"e":"span","f":["To upgrade, click 'Upgrade IE' to download IE11 from Microsoft."]},{"p":[29,81,898],"t":7,"e":"br"}," ",{"p":[30,5,909],"t":7,"e":"span","f":["If you are unable to upgrade directly, click 'IE VMs' to download a VM with IE11 or Edge from Microsoft."]},{"p":[30,122,1026],"t":7,"e":"br"}," ",{"p":[31,5,1037],"t":7,"e":"span","f":["Otherwise, click 'No Frills' below to disable potentially incompatible features (and this message)."]}," ",{"p":[32,5,1155],"t":7,"e":"hr"}," ",{"p":[33,5,1166],"t":7,"e":"ui-button","a":{"icon":"close","action":"tgui:nofrills"},"f":["No Frills"]}," ",{"p":[34,5,1240],"t":7,"e":"ui-button","a":{"icon":"internet-explorer","action":"tgui:link","params":"{\"url\": \"http://windows.microsoft.com/en-us/internet-explorer/download-ie\"}"},"f":["Upgrade IE"]}," ",{"p":[36,5,1416],"t":7,"e":"ui-button","a":{"icon":"edge","action":"tgui:link","params":"{\"url\": \"https://dev.windows.com/en-us/microsoft-edge/tools/vms\"}"},"f":["IE VMs"]}," ",{"p":[38,5,1565],"t":7,"e":"ui-button","a":{"icon":"info","action":"tgui:link","params":"{\"url\": \"https://support.microsoft.com/en-us/lifecycle#gp/Microsoft-Internet-Explorer\"}"},"f":["EOL Info"]}," ",{"p":[40,5,1738],"t":7,"e":"ui-button","a":{"icon":"bug"},"v":{"press":"debug"},"f":["Debug Info"]}," ",{"t":4,"f":[{"p":[42,7,1826],"t":7,"e":"hr"}," ",{"p":[43,7,1839],"t":7,"e":"span","f":["Detected: IE",{"t":2,"r":"ie","p":[43,25,1857]}]},{"p":[43,38,1870],"t":7,"e":"br"}," ",{"p":[44,7,1883],"t":7,"e":"span","f":["User Agent: ",{"t":2,"r":"userAgent","p":[44,25,1901]}]}],"n":50,"r":"debug","p":[41,5,1805]}]}],"n":50,"x":{"r":["config.fancy","ie"],"s":"_0&&_1&&_1<11"},"p":[26,1,621]}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205}],219:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.css = "  table {\r\n    width: 100%;\r\n    border-spacing: 2px;\r\n  }\r\n  th {\r\n    text-align: left;\r\n  }\r\n  td {\r\n    vertical-align: top;\r\n  }\r\n  td .button {\r\n    margin-top: 4px\r\n  }";
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"ui-display","f":[{"t":4,"f":[{"p":[3,3,39],"t":7,"e":"ui-section","a":{"label":"Card locked!"},"f":["Swipe ID to continue: ",{"p":[4,27,100],"t":7,"e":"ui-button","a":{"icon":"unlock","action":"unlock"},"f":["Unlock"]}]}],"n":50,"r":"data.locked","p":[2,3,16]},{"t":4,"n":51,"f":[{"p":[7,3,192],"t":7,"e":"ui-section","f":[{"p":[8,5,210],"t":7,"e":"ui-button","a":{"icon":[{"t":2,"x":{"r":["data.oneAccess"],"s":"_0?\"unlock\":\"lock\""},"p":[8,22,227]}],"action":"one_access"},"f":[{"t":2,"x":{"r":["data.oneAccess"],"s":"_0?\"One\":\"All\""},"p":[8,82,287]}," Required"]}," ",{"p":[9,5,348],"t":7,"e":"ui-button","a":{"icon":"refresh","action":"clear"},"f":["Clear"]}," ",{"t":4,"f":[{"p":[11,6,440],"t":7,"e":"ui-button","a":{"icon":"lock","action":"lock"},"f":["Lock"]}],"n":50,"r":"data.lockable","p":[10,5,412]}]}," ",{"p":[14,3,527],"t":7,"e":"hr"}," ",{"p":[15,3,536],"t":7,"e":"table","f":[{"p":[16,3,547],"t":7,"e":"thead","f":[{"p":[17,4,559],"t":7,"e":"tr","f":[{"t":4,"f":[{"p":[18,5,591],"t":7,"e":"th","f":[{"p":[18,9,595],"t":7,"e":"span","a":{"class":"highlight bold"},"f":[{"t":2,"r":"name","p":[18,38,624]}]}]}],"n":52,"r":"data.regions","p":[17,8,563]}]}]}," ",{"p":[21,3,679],"t":7,"e":"tbody","f":[{"p":[22,4,691],"t":7,"e":"tr","f":[{"t":4,"f":[{"p":[23,5,723],"t":7,"e":"td","f":[{"t":4,"f":[{"p":[24,11,757],"t":7,"e":"ui-button","a":{"icon":[{"t":2,"x":{"r":["req"],"s":"_0?\"check-square-o\":\"square-o\""},"p":[24,28,774]}],"style":[{"t":2,"x":{"r":["req"],"s":"_0?\"selected\":null"},"p":[24,76,822]}],"action":"set","params":["{\"access\": \"",{"t":2,"r":"id","p":[25,46,897]},"\"}"]},"f":[{"t":2,"r":"name","p":[25,56,907]}]}," ",{"p":[26,9,937],"t":7,"e":"br"}],"n":52,"r":"accesses","p":[23,9,727]}]}],"n":52,"r":"data.regions","p":[22,8,695]}]}]}]}],"r":"data.locked"}]}," "]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],220:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

component.exports = {
  computed: {
    setsecond: function setsecond() {
      return Math.round(this.get('data.timetoset') / 10 % 60);
    },
    setminute: function setminute() {
      return Math.round((this.get('data.timetoset') / 10 - this.get('setsecond')) / 60);
    },
    getsecond: function getsecond() {
      return Math.round(this.get('data.timeleft') % 60);
    },
    getminute: function getminute() {
      return Math.round((this.get('data.timeleft') - this.get('getsecond')) / 60);
    }
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"p":{"button":[{"p":[22,7,575],"t":7,"e":"ui-button","a":{"icon":"clock-o","style":[{"t":2,"x":{"r":["data.timing"],"s":"_0?\"selected\":null"},"p":[22,40,608]}],"action":[{"t":2,"x":{"r":["data.timing"],"s":"_0?\"stop\":\"start\""},"p":[22,85,653]}]},"f":[{"t":2,"x":{"r":["data.timing"],"s":"_0?\"Stop\":\"Start\""},"p":[22,121,689]}]}," ",{"t":4,"f":[{"p":[24,9,775],"t":7,"e":"ui-button","a":{"icon":"lightbulb-o","action":"flash","style":[{"t":2,"x":{"r":["status"],"s":"_0?null:\"disabled\""},"p":[24,61,827]}]},"f":[{"t":2,"x":{"r":["status"],"s":"_0?\"Flash\":\"Recharging\""},"p":[24,93,859]}]}],"n":52,"r":"data.flashes","p":[23,7,743]}]},"t":7,"e":"ui-display","a":{"title":"Cell Timer","button":0},"f":[" ",{"p":[27,3,943],"t":7,"e":"ui-section","f":[{"p":[28,5,961],"t":7,"e":"ui-button","a":{"icon":"fast-backward","action":"time","params":"{\"adjust\": -600}","style":[{"t":2,"x":{"r":["data.timing"],"s":"_0?\"disabled\":null"},"p":[28,84,1040]}]}}," ",{"p":[29,5,1095],"t":7,"e":"ui-button","a":{"icon":"backward","action":"time","params":"{\"adjust\": -100}","style":[{"t":2,"x":{"r":["data.timing"],"s":"_0?\"disabled\":null"},"p":[29,79,1169]}]}}," ",{"t":4,"f":[{"p":[31,7,1251],"t":7,"e":"span","f":[{"t":2,"x":{"r":["text","getminute"],"s":"_0.zeroPad(_1,2)"},"p":[31,13,1257]},":",{"t":2,"x":{"r":["text","getsecond"],"s":"_0.zeroPad(_1,2)"},"p":[31,44,1288]}]}],"n":50,"r":"data.timing","p":[30,5,1224]},{"t":4,"n":51,"f":[{"p":[33,7,1347],"t":7,"e":"span","f":[{"t":2,"x":{"r":["text","setminute"],"s":"_0.zeroPad(_1,2)"},"p":[33,13,1353]},":",{"t":2,"x":{"r":["text","setsecond"],"s":"_0.zeroPad(_1,2)"},"p":[33,44,1384]}]}],"r":"data.timing"}," ",{"p":[35,5,1440],"t":7,"e":"ui-button","a":{"icon":"forward","action":"time","params":"{\"adjust\": 100}","style":[{"t":2,"x":{"r":["data.timing"],"s":"_0?\"disabled\":null"},"p":[35,77,1512]}]}}," ",{"p":[36,5,1567],"t":7,"e":"ui-button","a":{"icon":"fast-forward","action":"time","params":"{\"adjust\": 600}","style":[{"t":2,"x":{"r":["data.timing"],"s":"_0?\"disabled\":null"},"p":[36,82,1644]}]}}]}]}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205}],221:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"ui-notice","f":[{"p":[2,3,15],"t":7,"e":"span","f":["The regulator ",{"t":2,"x":{"r":["data.hasHoldingTank"],"s":"_0?\"is\":\"is not\""},"p":[2,23,35]}," connected to a tank."]}]}," ",{"p":{"button":[{"p":[6,5,185],"t":7,"e":"ui-button","a":{"icon":"pencil","action":"relabel","state":[{"t":2,"x":{"r":["data.canLabel"],"s":"_0?null:\"disabled\""},"p":[6,54,234]}]},"f":["Relabel"]}]},"t":7,"e":"ui-display","a":{"title":"Canister","button":0},"f":[" ",{"p":[8,3,311],"t":7,"e":"ui-section","a":{"label":"Pressure"},"f":[{"p":[9,5,346],"t":7,"e":"span","f":[{"t":2,"x":{"r":["adata.tankPressure"],"s":"Math.round(_0)"},"p":[9,11,352]}," kPa"]}]}," ",{"p":[11,3,418],"t":7,"e":"ui-section","a":{"label":"Port"},"f":[{"p":[12,5,449],"t":7,"e":"span","a":{"class":[{"t":2,"x":{"r":["data.portConnected"],"s":"_0?\"good\":\"average\""},"p":[12,18,462]}]},"f":[{"t":2,"x":{"r":["data.portConnected"],"s":"_0?\"Connected\":\"Not Connected\""},"p":[12,63,507]}]}]}]}," ",{"p":[15,1,602],"t":7,"e":"ui-display","a":{"title":"Valve"},"f":[{"p":[16,3,632],"t":7,"e":"ui-section","a":{"label":"Release Pressure"},"f":[{"p":[17,5,675],"t":7,"e":"ui-bar","a":{"min":[{"t":2,"r":"data.minReleasePressure","p":[17,18,688]}],"max":[{"t":2,"r":"data.maxReleasePressure","p":[17,52,722]}],"value":[{"t":2,"r":"data.releasePressure","p":[18,14,765]}]},"f":[{"t":2,"x":{"r":["adata.releasePressure"],"s":"Math.round(_0)"},"p":[18,40,791]}," kPa"]}]}," ",{"p":[20,3,862],"t":7,"e":"ui-section","a":{"label":"Pressure Regulator"},"f":[{"p":[21,5,907],"t":7,"e":"ui-button","a":{"icon":"minus","state":[{"t":2,"x":{"r":["data.releasePressure","data.minReleasePressure"],"s":"_0>_1?null:\"disabled\""},"p":[21,36,938]}],"action":"pressure","params":"{\"adjust\": \"-1000\"}"}}," ",{"p":[23,5,1082],"t":7,"e":"ui-button","a":{"icon":"minus","state":[{"t":2,"x":{"r":["data.releasePressure","data.minReleasePressure"],"s":"_0>_1?null:\"disabled\""},"p":[23,36,1113]}],"action":"pressure","params":"{\"adjust\": \"-100\"}"}}," ",{"p":[25,5,1256],"t":7,"e":"ui-button","a":{"icon":"minus","state":[{"t":2,"x":{"r":["data.releasePressure","data.minReleasePressure"],"s":"_0>_1?null:\"disabled\""},"p":[25,36,1287]}],"action":"pressure","params":"{\"adjust\": \"-10\"}"}}," ",{"p":[27,5,1429],"t":7,"e":"ui-button","a":{"icon":"minus","state":[{"t":2,"x":{"r":["data.releasePressure","data.minReleasePressure"],"s":"_0>_1?null:\"disabled\""},"p":[27,36,1460]}],"action":"pressure","params":"{\"adjust\": \"-1\"}"}}," ",{"p":[29,5,1601],"t":7,"e":"ui-button","a":{"icon":"plus","state":[{"t":2,"x":{"r":["data.releasePressure","data.maxReleasePressure"],"s":"_0<_1?null:\"disabled\""},"p":[29,35,1631]}],"action":"pressure","params":"{\"adjust\": \"1\"}"}}," ",{"p":[31,5,1771],"t":7,"e":"ui-button","a":{"icon":"plus","state":[{"t":2,"x":{"r":["data.releasePressure","data.maxReleasePressure"],"s":"_0<_1?null:\"disabled\""},"p":[31,35,1801]}],"action":"pressure","params":"{\"adjust\": \"10\"}"}}," ",{"p":[33,5,1942],"t":7,"e":"ui-button","a":{"icon":"plus","state":[{"t":2,"x":{"r":["data.releasePressure","data.maxReleasePressure"],"s":"_0<_1?null:\"disabled\""},"p":[33,35,1972]}],"action":"pressure","params":"{\"adjust\": \"100\"}"}}," ",{"p":[35,5,2114],"t":7,"e":"ui-button","a":{"icon":"plus","state":[{"t":2,"x":{"r":["data.releasePressure","data.maxReleasePressure"],"s":"_0<_1?null:\"disabled\""},"p":[35,35,2144]}],"action":"pressure","params":"{\"adjust\": \"1000\"}"}}]}," ",{"p":[38,3,2302],"t":7,"e":"ui-section","a":{"label":"Valve"},"f":[{"p":[39,5,2334],"t":7,"e":"ui-button","a":{"icon":[{"t":2,"x":{"r":["data.valveOpen"],"s":"_0?\"unlock\":\"lock\""},"p":[39,22,2351]}],"style":[{"t":2,"x":{"r":["data.valveOpen","data.hasHoldingTank"],"s":"_0?_1?\"caution\":\"danger\":null"},"p":[40,14,2405]}],"action":"valve"},"f":[{"t":2,"x":{"r":["data.valveOpen"],"s":"_0?\"Open\":\"Closed\""},"p":[41,22,2499]}]}]}]}," ",{"p":{"button":[{"t":4,"f":[{"p":[47,7,2687],"t":7,"e":"ui-button","a":{"icon":"eject","style":[{"t":2,"x":{"r":["data.valveOpen"],"s":"_0?\"danger\":null"},"p":[47,38,2718]}],"action":"eject"},"f":["Eject"]}],"n":50,"r":"data.hasHoldingTank","p":[46,5,2652]}]},"t":7,"e":"ui-display","a":{"title":"Holding Tank","button":0},"f":[" ",{"t":4,"f":[{"p":[51,3,2852],"t":7,"e":"ui-section","a":{"label":"Label"},"f":[{"t":2,"r":"data.holdingTank.name","p":[52,4,2883]}]}," ",{"p":[54,3,2929],"t":7,"e":"ui-section","a":{"label":"Pressure"},"f":[{"t":2,"x":{"r":["adata.holdingTank.tankPressure"],"s":"Math.round(_0)"},"p":[55,4,2963]}," kPa"]}],"n":50,"r":"data.hasHoldingTank","p":[50,3,2821]},{"t":4,"n":51,"f":[{"p":[58,3,3045],"t":7,"e":"ui-section","f":[{"p":[59,4,3062],"t":7,"e":"span","a":{"class":"average"},"f":["No Holding Tank"]}]}],"r":"data.hasHoldingTank"}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],222:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

component.exports = {
  computed: {
    tabs: function tabs() {
      return Object.keys(this.get('data.supplies'));
    }
  }
};
})(component);
component.exports.template = {"v":3,"t":[" ",{"t":4,"f":[{"p":[12,5,183],"t":7,"e":"ui-notice","a":{"button":0},"f":[{"p":[13,9,211],"t":7,"e":"span","f":["Cargo station logged in as register. ",{"p":[15,13,281],"t":7,"e":"ui-button","a":{"icon":"sign-in","action":"logout"},"f":["Log Out"]}]}]}],"n":50,"r":"data.active","p":[11,1,158]},{"p":[19,1,388],"t":7,"e":"ui-display","a":{"title":"Cargo"},"f":[{"p":[20,3,418],"t":7,"e":"ui-section","a":{"label":"Shuttle"},"f":["Location: ",{"t":2,"r":"data.location","p":[21,15,462]}," ",{"t":4,"f":[{"p":[23,7,512],"t":7,"e":"ui-button","a":{"action":"send","state":[{"t":2,"x":{"r":["data.canlaunch"],"s":"_0?null:\"disabled\""},"p":[23,39,544]}]},"f":["Undock Shuttle"]}],"n":50,"r":"data.active","p":[22,5,485]}]}," ",{"p":[26,3,644],"t":7,"e":"ui-section","a":{"label":"Points"},"f":[{"p":[27,5,677],"t":7,"e":"span","f":[{"t":2,"x":{"r":["adata.points"],"s":"Math.floor(_0)"},"p":[27,11,683]}]}]}," ",{"p":[29,3,739],"t":7,"e":"ui-section","a":{"label":"Total points earned this shift"},"f":[{"p":[30,5,796],"t":7,"e":"span","f":[{"t":2,"r":"data.pointstotalsum","p":[30,11,802]}]}," ",{"p":[31,2,835],"t":7,"e":"ui-button","a":{"action":"printtotal"},"f":["Print overview"]}]}]}," ",{"t":4,"f":[{"p":{"button":[{"p":[37,7,1014],"t":7,"e":"ui-button","a":{"icon":"close","state":[{"t":2,"x":{"r":["data.cart.length","data.canlaunch"],"s":"(_0&&_1)?null:\"disabled\""},"p":[37,38,1045]}],"action":"clear"},"f":["Clear"]}]},"t":7,"e":"ui-display","a":{"title":"Cart","button":0},"f":[" ",{"t":4,"f":[{"p":[40,7,1190],"t":7,"e":"ui-section","a":{"candystripe":0,"nowrap":0},"f":[{"p":[41,9,1231],"t":7,"e":"div","a":{"class":"content"},"f":["#",{"t":2,"r":"id","p":[41,31,1253]}]}," ",{"p":[42,9,1275],"t":7,"e":"div","a":{"class":"content"},"f":[{"t":2,"r":"object","p":[42,30,1296]}]}," ",{"p":[43,9,1322],"t":7,"e":"div","a":{"class":"content"},"f":[{"t":2,"r":"cost","p":[43,30,1343]}," Points"]}," ",{"p":[44,9,1374],"t":7,"e":"div","a":{"class":"content"},"f":["By: ",{"t":2,"r":"orderer","p":[44,34,1399]}]}," ",{"p":[45,9,1426],"t":7,"e":"div","a":{"class":"content"},"f":["Reason: ",{"t":2,"r":"reason","p":[45,38,1455]}]}," ",{"p":[46,9,1481],"t":7,"e":"div","a":{"class":"content"},"f":[{"p":[47,11,1514],"t":7,"e":"ui-button","a":{"icon":"minus","action":"remove","params":["{\"id\": \"",{"t":2,"r":"id","p":[47,67,1570]},"\"}"],"state":[{"t":2,"x":{"r":["data.canlaunch"],"s":"_0?null:\"disabled\""},"p":[47,84,1587]}]},"f":["Remove"]}," ",{"p":[48,11,1657],"t":7,"e":"ui-button","a":{"icon":"pencil","action":"edit","params":["{\"id\": \"",{"t":2,"r":"id","p":[48,66,1712]},"\"}"],"state":[{"t":2,"x":{"r":["data.canlaunch"],"s":"_0?null:\"disabled\""},"p":[48,83,1729]}]}}]}]}],"n":52,"r":"data.cart","p":[39,5,1163]},{"t":4,"n":51,"f":[{"p":[52,7,1829],"t":7,"e":"span","f":["Nothing in Cart"]}],"r":"data.cart"}]}],"n":50,"r":"data.active","p":[34,1,926]},{"p":{"button":[{"t":4,"f":[{"p":[59,7,1992],"t":7,"e":"ui-button","a":{"icon":"close","state":[{"t":2,"x":{"r":["data.requests.length"],"s":"_0?null:\"disabled\""},"p":[59,38,2023]}],"action":"denyall"},"f":["Clear"]}],"n":50,"r":"data.active","p":[58,5,1965]}]},"t":7,"e":"ui-display","a":{"title":"Requests","button":0},"f":[" ",{"t":4,"f":[{"p":[63,5,2165],"t":7,"e":"ui-section","a":{"candystripe":0,"nowrap":0},"f":[{"p":[64,7,2204],"t":7,"e":"div","a":{"class":"content"},"f":["#",{"t":2,"r":"id","p":[64,29,2226]}]}," ",{"p":[65,7,2246],"t":7,"e":"div","a":{"class":"content"},"f":[{"t":2,"r":"object","p":[65,28,2267]}]}," ",{"p":[66,7,2291],"t":7,"e":"div","a":{"class":"content"},"f":[{"t":2,"r":"cost","p":[66,28,2312]}," Points"]}," ",{"p":[67,7,2341],"t":7,"e":"div","a":{"class":"content"},"f":["By ",{"t":2,"r":"orderer","p":[67,31,2365]}]}," ",{"p":[68,7,2390],"t":7,"e":"div","a":{"class":"content"},"f":["Reason: ",{"t":2,"r":"reason","p":[68,36,2419]}]}," ",{"p":[69,7,2443],"t":7,"e":"div","a":{"class":"content"},"f":[{"t":4,"f":[{"p":[71,11,2503],"t":7,"e":"ui-button","a":{"icon":"check","action":"approve","params":["{\"id\": \"",{"t":2,"r":"id","p":[71,68,2560]},"\"}"]},"f":["Approve"]}," ",{"p":[72,11,2601],"t":7,"e":"ui-button","a":{"icon":"close","action":"deny","params":["{\"id\": \"",{"t":2,"r":"id","p":[72,65,2655]},"\"}"]},"f":["Deny"]}],"n":50,"r":"data.active","p":[70,7,2472]}," ",{"p":[74,7,2704],"t":7,"e":"ui-button","a":{"icon":"print","action":"print","params":["{\"id\": \"",{"t":2,"r":"id","p":[74,62,2759]},"\"}"]},"f":[{"t":2,"x":{"r":["data.active"],"s":"_0?\"\":\"Print Receipt\""},"p":[74,72,2769]}]}]}]}],"n":52,"r":"data.requests","p":[62,3,2136]},{"t":4,"n":51,"f":[{"p":[78,7,2873],"t":7,"e":"span","f":["No Requests"]}],"r":"data.requests"}]}," ",{"t":4,"f":[{"p":[82,5,2956],"t":7,"e":"ui-tabs","a":{"tabs":[{"t":2,"r":"tabs","p":[82,20,2971]}]},"f":[{"t":4,"f":[{"p":[84,9,3023],"t":7,"e":"tab","a":{"name":[{"t":2,"r":"name","p":[84,20,3034]}]},"f":[{"t":4,"f":[{"p":[86,13,3084],"t":7,"e":"ui-section","a":{"label":[{"t":2,"r":"name","p":[86,32,3103]}],"candystripe":0,"right":0},"f":[{"p":[87,15,3147],"t":7,"e":"ui-button","a":{"action":"add","params":["{\"id\": \"",{"t":2,"r":"id","p":[87,55,3187]},"\"}"]},"f":[{"t":2,"r":"cost","p":[87,65,3197]}," Credits"]}]}],"n":52,"r":"pack","p":[85,11,3056]}]}],"n":52,"r":"adata.supplies","p":[83,7,2989]}]}],"n":50,"r":"data.canorder","p":[81,1,2929]},{"t":4,"n":51,"f":[{"p":[94,5,3338],"t":7,"e":"ui-section","f":[{"p":[95,9,3360],"t":7,"e":"span","f":["Cargo Request services are disabled until a register is activated."]}]}],"r":"data.canorder"},{"t":4,"f":[{"p":[99,5,3495],"t":7,"e":"ui-notice","a":{"button":0},"f":[{"p":[100,9,3523],"t":7,"e":"span","f":["Log in to register mode (Will log out current register): ",{"p":[102,13,3613],"t":7,"e":"ui-button","a":{"icon":"sign-in","action":"login"},"f":["Log In"]}]}]}],"n":50,"x":{"r":["data.active"],"s":"!_0"},"p":[98,1,3469]}]};
module.exports = Ractive.extend(component.exports);

},{"ractive":205}],223:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"ui-notice","f":[{"p":[2,3,15],"t":7,"e":"span","f":["The requested interface (",{"t":2,"r":"config.interface","p":[2,34,46]},") was not found. Does it exist?"]}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],224:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"ui-display","a":{"title":["Current track: ",{"t":2,"r":"data.current_track","p":[1,35,34]}]},"f":[{"p":[2,5,64],"t":7,"e":"ui-section","f":[{"p":[3,9,86],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.playing"],"s":"_0?\"selected\":null"},"p":[3,27,104]}],"action":"play"},"f":["Play"]}," ",{"p":[4,9,182],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.playing"],"s":"_0?null:\"selected\""},"p":[4,27,200]}],"action":"stop"},"f":["Stop"]}]}]}," ",{"p":[7,1,304],"t":7,"e":"ui-display","a":{"title":"Available tracks:"},"f":[{"t":4,"f":[{"p":[9,9,379],"t":7,"e":"ui-button","a":{"action":"change_track","params":["{\"title\" : ",{"t":2,"r":".","p":[9,61,431]},"}"]},"f":[{"t":2,"r":".","p":[9,69,439]}]},{"p":[9,86,456],"t":7,"e":"br"}],"n":52,"r":"data.tracks","p":[8,5,348]}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],225:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"ui-display","a":{"title":"Neural Lace Resleever"},"f":[{"p":[2,5,48],"t":7,"e":"ui-section","a":{"label":"Occupant"},"f":[{"t":2,"r":"data.name","p":[3,9,87]}]}," ",{"p":[5,5,125],"t":7,"e":"ui-section","a":{"label":"Neural Lace backup"},"f":[{"t":2,"r":"data.lace","p":[6,9,174]}]}," ",{"p":[8,5,212],"t":7,"e":"ui-section","a":{"label":"Procedure Progress"},"f":[{"p":[9,5,257],"t":7,"e":"ui-bar","a":{"min":"0","max":[{"t":2,"r":"data.timetosleeve","p":[9,26,278]}],"value":[{"t":2,"r":"data.remaining","p":[10,14,315]}]}}]}," ",{"p":[12,5,369],"t":7,"e":"ui-section","f":[{"p":[13,9,391],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.ready"],"s":"_0?null:\"disabled\""},"p":[13,27,409]}],"action":"begin"},"f":["Start Procedure"]}]}," ",{"p":[15,5,512],"t":7,"e":"ui-section","f":[{"p":[16,9,534],"t":7,"e":"ui-button","a":{"icon":"eject","state":[{"t":2,"x":{"r":["data.isOccupiedEjectable"],"s":"_0?null:\"disabled\""},"p":[16,40,565]}],"action":"eject"},"f":["Eject Occupant"]}," ",{"p":[17,9,666],"t":7,"e":"ui-button","a":{"icon":"eject","state":[{"t":2,"x":{"r":["data.isLaceEjectable"],"s":"_0?null:\"disabled\""},"p":[17,40,697]}],"action":"ejectlace"},"f":["Eject Neural Lace"]}]}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],226:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"ui-display","a":{"title":"Contained Items:"},"f":[{"t":4,"f":[{"p":[3,9,73],"t":7,"e":"ui-button","a":{"action":"remove_item","params":["{\"name\":\"",{"t":2,"r":"name","p":[3,58,122]},"\", \"type\":\"",{"t":2,"r":"type","p":[3,77,141]},"\"}"]},"f":[{"t":2,"r":"name","p":[3,89,153]}," x",{"t":2,"r":"amount","p":[3,99,163]}]},{"p":[3,121,185],"t":7,"e":"br"}],"n":52,"r":"data.items","p":[2,5,43]}]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],227:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
component.exports.template = {"v":3,"t":[{"p":[1,1,0],"t":7,"e":"ui-display","a":{"title":["Active: ",{"t":2,"x":{"r":["data.active"],"s":"_0?\"Enabled\":\"Disabled\""},"p":[1,28,27]}]},"f":[{"p":[2,5,75],"t":7,"e":"ui-section","f":[{"p":[3,9,97],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.active"],"s":"_0?\"selected\":null"},"p":[3,27,115]}],"action":"enable_jammer"},"f":["Enable"]}," ",{"p":[4,9,203],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.active"],"s":"_0?null:\"selected\""},"p":[4,27,221]}],"action":"disable_jammer"},"f":["Disable"]}]}]}," ",{"p":[7,1,337],"t":7,"e":"ui-display","a":{"title":["Range: ",{"t":2,"r":"data.range","p":[7,27,363]}," meter(s)"]},"f":[{"p":[8,5,394],"t":7,"e":"ui-section","f":[{"p":[9,9,416],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.range"],"s":"_0<=0?\"selected\":null"},"p":[9,27,434]}],"action":"decrease_range"},"f":["Decrease"]}," ",{"p":[10,9,529],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.active","data.max_range"],"s":"_0>=_1?\"selected\":\"null\""},"p":[10,27,547]}],"action":"increase_range"},"f":["Increase"]}]}]}," ",{"p":[13,1,684],"t":7,"e":"ui-display","a":{"title":"Mode:"},"f":[{"t":4,"f":[{"p":[15,9,748],"t":7,"e":"ui-button","a":{"style":[{"t":2,"x":{"r":["data.current_method","ref"],"s":"_0==_1?\"selected\":null"},"p":[15,27,766]}],"action":"select_method","params":["{\"method\" : ",{"t":2,"r":"ref","p":[15,122,861]},"}"]},"f":[{"t":2,"r":"name","p":[15,132,871]}," - ",{"t":2,"r":"cost","p":[15,143,882]}]},{"p":[15,163,902],"t":7,"e":"br"}],"n":52,"r":"data.methods","p":[14,5,716]}]}," ",{"p":[18,1,938],"t":7,"e":"ui-section","f":[{"p":[19,2,953],"t":7,"e":"ui-display","a":{"title":["Charge: ",{"t":2,"r":"data.current_charge","p":[19,29,980]},"/",{"t":2,"r":"data.max_charge","p":[19,53,1004]}]},"f":[{"p":[20,2,1028],"t":7,"e":"ui-bar","a":{"min":"0","max":"1","value":[{"t":2,"x":{"r":["data.current_charge","data.max_charge"],"s":"_0/_1"},"p":[20,33,1059]}],"state":[{"t":2,"x":{"r":["data.current_charge","data.max_charge"],"s":"_0/_1"},"p":[20,81,1107]}]},"f":[{"t":2,"x":{"r":["data.current_charge","data.max_charge"],"s":"Math.fixed(_0*100/_1)"},"p":[20,122,1148]},"%"]}]}]}," ",{"p":[22,1,1230],"t":7,"e":"ui-display","a":{"title":["Energy Consumption: ~",{"t":2,"r":"data.total_cost","p":[22,41,1270]},"W"]},"f":[]}]};
module.exports = Ractive.extend(component.exports);
},{"ractive":205}],228:[function(require,module,exports){
(function (babelHelpers){
'use strict';

var _ractive = require('ractive');

var _ractive2 = babelHelpers.interopRequireDefault(_ractive);

require('ie8');

require('babel-polyfill');

require('dom4');

require('html5shiv');

var _tgui = require('tgui.ract');

var _tgui2 = babelHelpers.interopRequireDefault(_tgui);

var _byond = require('util/byond');

var _fgLoadcss = require('fg-loadcss');

var _fontfaceobserver = require('fontfaceobserver');

var _fontfaceobserver2 = babelHelpers.interopRequireDefault(_fontfaceobserver);

_ractive2["default"].DEBUG = /minified/.test(function () {/* minified */}); // Temporarily import Ractive first to keep it from detecting ie8's object.defineProperty shim, which it misuses (ractivejs/ractive#2343).


// Extend the Math builtin with our own utilities.
Object.assign(Math, require('util/math'));

// Set up the initialize function. This is either called below if JSON is provided
// inline, or called by the server if it was not.

window.initialize = function (dataString) {
  if (window.tgui) return; // Don't run twice.
  window.tgui = new _tgui2["default"]({
    el: '#container',
    data: function data() {
      var initial = JSON.parse(dataString);
      return {
        constants: require('util/constants'),
        text: require('util/text'),
        config: initial.config,
        data: initial.data,
        adata: initial.data
      };
    }
  });
};

// Try to find data in the page. If the JSON was inlined, load it.
var holder = document.getElementById('data');
var data = holder.textContent;
var ref = holder.getAttribute('data-ref');
if (data !== '{}') {
  window.initialize(data);
  holder.remove();
}
// Let the server know we're set up. This also sends data if it was not inlined.

(0, _byond.act)(ref, 'tgui:initialize');

// Load fonts.

(0, _fgLoadcss.loadCSS)('https://cdn.jsdelivr.net/fontawesome/4.5.0/css/font-awesome.min.css');
// Handle font loads.

var fontawesome = new _fontfaceobserver2["default"]('FontAwesome');
fontawesome.check('\uF240').then(function () {
  return document.body.classList.add('icons');
})["catch"](function () {
  return document.body.classList.add('no-icons');
});

}).call(this,require("babel/external-helpers"))
},{"babel-polyfill":1,"babel/external-helpers":"babel/external-helpers","dom4":190,"fg-loadcss":191,"fontfaceobserver":192,"html5shiv":193,"ie8":194,"ractive":205,"tgui.ract":229,"util/byond":230,"util/constants":231,"util/math":233,"util/text":234}],229:[function(require,module,exports){
var Ractive = require('ractive');
var component = { exports: {} };
(function (component) {
'use strict';

var _byond = require('util/byond');

var _dragresize = require('util/dragresize');

component.exports = {
  components: {
    'ui-bar': require('components/bar'),
    'ui-button': require('components/button'),
    'ui-display': require('components/display'),
    'ui-input': require('components/input'),
    'ui-linegraph': require('components/linegraph'),
    'ui-notice': require('components/notice'),
    'ui-section': require('components/section'),
    'ui-subdisplay': require('components/subdisplay'),
    'ui-tabs': require('components/tabs')
  },
  events: {
    enter: require('ractive-events-keys').enter,
    space: require('ractive-events-keys').space
  },
  transitions: {
    fade: require('ractive-transitions-fade')
  },
  onconfig: function onconfig() {
    var requested = this.get('config.interface');
    var interfaces = {'airlock_electronics': require('interfaces/airlock_electronics.ract'),'brig_timer': require('interfaces/brig_timer.ract'),'canister': require('interfaces/canister.ract'),'cargo': require('interfaces/cargo.ract'),'error': require('interfaces/error.ract'),'jukebox': require('interfaces/jukebox.ract'),'resleever': require('interfaces/resleever.ract'),'storage': require('interfaces/storage.ract'),'suit_sensor_jammer': require('interfaces/suit_sensor_jammer.ract')};
    if (requested in interfaces) {
      this.components["interface"] = interfaces[requested]; // Use the interface specified in the config...
    } else {
      this.components["interface"] = interfaces.error; // ...unless it does not exist.
    }
  },
  oninit: function oninit() {
    this.observe('config.style', function (newkey, oldkey, keypath) {
      if (newkey) document.body.classList.add(newkey);
      if (oldkey) document.body.classList.remove(oldkey);
    });
  },
  oncomplete: function oncomplete() {
    // If the window starts off screen, pull it back.
    if (this.get('config.locked')) {
      var _lock = (0, _dragresize.lock)(window.screenLeft, window.screenTop),
          x = _lock.x,
          y = _lock.y;

      (0, _byond.winset)(this.get('config.window'), 'pos', x + ',' + y);
    }

    // Give focus back to the map.
    (0, _byond.winset)('mapwindow.map', 'focus', true);
  }
};
})(component);
component.exports.template = {"v":3,"t":[" "," "," "," ",{"p":[56,1,1874],"t":7,"e":"titlebar","f":[{"t":3,"r":"config.title","p":[56,11,1884]}]}," ",{"p":[57,1,1915],"t":7,"e":"main","f":[{"p":[58,3,1925],"t":7,"e":"warnings"}," ",{"p":[59,3,1940],"t":7,"e":"interface"}]}," ",{"t":4,"f":[{"p":[62,3,1990],"t":7,"e":"resize"}],"n":50,"r":"config.titlebar","p":[61,1,1963]}]};
component.exports.components = component.exports.components || {};
var components = {
  "warnings": require("components/warnings.ract"),
  "titlebar": require("components/titlebar.ract"),
  "resize": require("components/resize.ract")
};
for (var k in components) {
  if (components.hasOwnProperty(k))
    component.exports.components[k] = components[k];
}
module.exports = Ractive.extend(component.exports);

},{"components/bar":206,"components/button":207,"components/display":208,"components/input":209,"components/linegraph":210,"components/notice":211,"components/resize.ract":212,"components/section":213,"components/subdisplay":214,"components/tabs":215,"components/titlebar.ract":217,"components/warnings.ract":218,"interfaces/airlock_electronics.ract":219,"interfaces/brig_timer.ract":220,"interfaces/canister.ract":221,"interfaces/cargo.ract":222,"interfaces/error.ract":223,"interfaces/jukebox.ract":224,"interfaces/resleever.ract":225,"interfaces/storage.ract":226,"interfaces/suit_sensor_jammer.ract":227,"ractive":205,"ractive-events-keys":203,"ractive-transitions-fade":204,"util/byond":230,"util/dragresize":232}],230:[function(require,module,exports){
'use strict';

exports.__esModule = true;
exports.href = href;
exports.act = act;
exports.winset = winset;
var encode = encodeURIComponent;

// Helper to generate a BYOND href given 'params' as an object (with an optional 'url' for eg winset).
function href() {
  var params = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var url = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : '';

  return 'byond://' + url + '?' + Object.keys(params).map(function (key) {
    return encode(key) + '=' + encode(params[key]);
  }).join('&');
}

// Helper to make a BYOND ui_act() call on the UI 'src' given an 'action' and optional 'params'.
function act(src, action) {
  var params = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};

  window.location.href = href(Object.assign({ src: src, action: action }, params));
}

// Helper to make a BYOND winset() call on 'window', setting 'key' to 'value'
function winset(win, key, value) {
  var _href;

  window.location.href = href((_href = {}, _href[win + '.' + key] = value, _href), 'winset');
}

},{}],231:[function(require,module,exports){
"use strict";

exports.__esModule = true;
// Constants used in tgui; these are mirrored from the BYOND code.
var UI_INTERACTIVE = exports.UI_INTERACTIVE = 2;
var UI_UPDATE = exports.UI_UPDATE = 1;
var UI_DISABLED = exports.UI_DISABLED = 0;
var UI_CLOSE = exports.UI_CLOSE = -1;

},{}],232:[function(require,module,exports){
'use strict';

exports.__esModule = true;
exports.lock = lock;
exports.drag = drag;
exports.sane = sane;
exports.resize = resize;

var _byond = require('./byond');

function lock(x, y) {
  if (x < 0) {
    // Left
    x = 0;
  } else if (x + window.innerWidth > window.screen.availWidth) {
    // Right
    x = window.screen.availWidth - window.innerWidth;
  }

  if (y < 0) {
    // Top
    y = 0;
  } else if (y + window.innerHeight > window.screen.availHeight) {
    // Bottom
    y = window.screen.availHeight - window.innerHeight;
  }

  return { x: x, y: y };
}

function drag(event) {
  event.preventDefault();

  if (!this.get('drag')) return;

  if (this.get('x')) {
    var x = event.screenX - this.get('x') + window.screenLeft;
    var y = event.screenY - this.get('y') + window.screenTop;
    if (this.get('config.locked')) {
      ;
      var _lock = lock(x, y);

      x = _lock.x;
      y = _lock.y;
    } // Lock to primary monitor.
    (0, _byond.winset)(this.get('config.window'), 'pos', x + ',' + y);
  }
  this.set({ x: event.screenX, y: event.screenY });
}

function sane(x, y) {
  x = Math.clamp(100, window.screen.width, x);
  y = Math.clamp(100, window.screen.height, y);
  return { x: x, y: y };
}

function resize(event) {
  event.preventDefault();

  if (!this.get('resize')) return;

  if (this.get('x')) {
    var x = event.screenX - this.get('x') + window.innerWidth;
    var y = event.screenY - this.get('y') + window.innerHeight;
    var _sane = sane(x, y);

    x = _sane.x;
    y = _sane.y;

    (0, _byond.winset)(this.get('config.window'), 'size', x + ',' + y);
  }
  this.set({ x: event.screenX, y: event.screenY });
}

},{"./byond":230}],233:[function(require,module,exports){
'use strict';

exports.__esModule = true;
exports.clamp = clamp;
exports.fixed = fixed;
// Helper to limit a number to be inside 'min' and 'max'.
function clamp(min, max, number) {
  return Math.max(min, Math.min(number, max));
}

// Helper to round a number to 'decimals' decimals.
function fixed(number) {
  var decimals = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 1;

  return Number(Math.round(number + 'e' + decimals) + 'e-' + decimals);
}

},{}],234:[function(require,module,exports){
'use strict';

exports.__esModule = true;
exports.upperCaseFirst = upperCaseFirst;
exports.titleCase = titleCase;
exports.zeroPad = zeroPad;
function upperCaseFirst(str) {
  return str[0].toUpperCase() + str.slice(1).toLowerCase();
}

function titleCase(str) {
  return str.replace(/\w\S*/g, upperCaseFirst);
}

function zeroPad(str, pad_size) {
  str = str.toString();
  while (str.length < pad_size) {
    str = '0' + str;
  }return str;
}

},{}],"babel/external-helpers":[function(require,module,exports){
var global = {}; (function (global) {
  var babelHelpers = global.babelHelpers = {};
  babelHelpers["typeof"] = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) {
    return typeof obj;
  } : function (obj) {
    return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
  };

  babelHelpers.jsx = function () {
    var REACT_ELEMENT_TYPE = typeof Symbol === "function" && Symbol["for"] && Symbol["for"]("react.element") || 0xeac7;
    return function createRawReactElement(type, props, key, children) {
      var defaultProps = type && type.defaultProps;
      var childrenLength = arguments.length - 3;

      if (!props && childrenLength !== 0) {
        props = {};
      }

      if (props && defaultProps) {
        for (var propName in defaultProps) {
          if (props[propName] === void 0) {
            props[propName] = defaultProps[propName];
          }
        }
      } else if (!props) {
        props = defaultProps || {};
      }

      if (childrenLength === 1) {
        props.children = children;
      } else if (childrenLength > 1) {
        var childArray = Array(childrenLength);

        for (var i = 0; i < childrenLength; i++) {
          childArray[i] = arguments[i + 3];
        }

        props.children = childArray;
      }

      return {
        $$typeof: REACT_ELEMENT_TYPE,
        type: type,
        key: key === undefined ? null : '' + key,
        ref: null,
        props: props,
        _owner: null
      };
    };
  }();

  babelHelpers.asyncIterator = function (iterable) {
    if (typeof Symbol === "function") {
      if (Symbol.asyncIterator) {
        var method = iterable[Symbol.asyncIterator];
        if (method != null) return method.call(iterable);
      }

      if (Symbol.iterator) {
        return iterable[Symbol.iterator]();
      }
    }

    throw new TypeError("Object is not async iterable");
  };

  babelHelpers.asyncGenerator = function () {
    function AwaitValue(value) {
      this.value = value;
    }

    function AsyncGenerator(gen) {
      var front, back;

      function send(key, arg) {
        return new Promise(function (resolve, reject) {
          var request = {
            key: key,
            arg: arg,
            resolve: resolve,
            reject: reject,
            next: null
          };

          if (back) {
            back = back.next = request;
          } else {
            front = back = request;
            resume(key, arg);
          }
        });
      }

      function resume(key, arg) {
        try {
          var result = gen[key](arg);
          var value = result.value;

          if (value instanceof AwaitValue) {
            Promise.resolve(value.value).then(function (arg) {
              resume("next", arg);
            }, function (arg) {
              resume("throw", arg);
            });
          } else {
            settle(result.done ? "return" : "normal", result.value);
          }
        } catch (err) {
          settle("throw", err);
        }
      }

      function settle(type, value) {
        switch (type) {
          case "return":
            front.resolve({
              value: value,
              done: true
            });
            break;

          case "throw":
            front.reject(value);
            break;

          default:
            front.resolve({
              value: value,
              done: false
            });
            break;
        }

        front = front.next;

        if (front) {
          resume(front.key, front.arg);
        } else {
          back = null;
        }
      }

      this._invoke = send;

      if (typeof gen["return"] !== "function") {
        this["return"] = undefined;
      }
    }

    if (typeof Symbol === "function" && Symbol.asyncIterator) {
      AsyncGenerator.prototype[Symbol.asyncIterator] = function () {
        return this;
      };
    }

    AsyncGenerator.prototype.next = function (arg) {
      return this._invoke("next", arg);
    };

    AsyncGenerator.prototype["throw"] = function (arg) {
      return this._invoke("throw", arg);
    };

    AsyncGenerator.prototype["return"] = function (arg) {
      return this._invoke("return", arg);
    };

    return {
      wrap: function (fn) {
        return function () {
          return new AsyncGenerator(fn.apply(this, arguments));
        };
      },
      await: function (value) {
        return new AwaitValue(value);
      }
    };
  }();

  babelHelpers.asyncGeneratorDelegate = function (inner, awaitWrap) {
    var iter = {},
        waiting = false;

    function pump(key, value) {
      waiting = true;
      value = new Promise(function (resolve) {
        resolve(inner[key](value));
      });
      return {
        done: false,
        value: awaitWrap(value)
      };
    }

    ;

    if (typeof Symbol === "function" && Symbol.iterator) {
      iter[Symbol.iterator] = function () {
        return this;
      };
    }

    iter.next = function (value) {
      if (waiting) {
        waiting = false;
        return value;
      }

      return pump("next", value);
    };

    if (typeof inner["throw"] === "function") {
      iter["throw"] = function (value) {
        if (waiting) {
          waiting = false;
          throw value;
        }

        return pump("throw", value);
      };
    }

    if (typeof inner["return"] === "function") {
      iter["return"] = function (value) {
        return pump("return", value);
      };
    }

    return iter;
  };

  babelHelpers.asyncToGenerator = function (fn) {
    return function () {
      var gen = fn.apply(this, arguments);
      return new Promise(function (resolve, reject) {
        function step(key, arg) {
          try {
            var info = gen[key](arg);
            var value = info.value;
          } catch (error) {
            reject(error);
            return;
          }

          if (info.done) {
            resolve(value);
          } else {
            return Promise.resolve(value).then(function (value) {
              step("next", value);
            }, function (err) {
              step("throw", err);
            });
          }
        }

        return step("next");
      });
    };
  };

  babelHelpers.classCallCheck = function (instance, Constructor) {
    if (!(instance instanceof Constructor)) {
      throw new TypeError("Cannot call a class as a function");
    }
  };

  babelHelpers.createClass = function () {
    function defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }

    return function (Constructor, protoProps, staticProps) {
      if (protoProps) defineProperties(Constructor.prototype, protoProps);
      if (staticProps) defineProperties(Constructor, staticProps);
      return Constructor;
    };
  }();

  babelHelpers.defineEnumerableProperties = function (obj, descs) {
    for (var key in descs) {
      var desc = descs[key];
      desc.configurable = desc.enumerable = true;
      if ("value" in desc) desc.writable = true;
      Object.defineProperty(obj, key, desc);
    }

    return obj;
  };

  babelHelpers.defaults = function (obj, defaults) {
    var keys = Object.getOwnPropertyNames(defaults);

    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      var value = Object.getOwnPropertyDescriptor(defaults, key);

      if (value && value.configurable && obj[key] === undefined) {
        Object.defineProperty(obj, key, value);
      }
    }

    return obj;
  };

  babelHelpers.defineProperty = function (obj, key, value) {
    if (key in obj) {
      Object.defineProperty(obj, key, {
        value: value,
        enumerable: true,
        configurable: true,
        writable: true
      });
    } else {
      obj[key] = value;
    }

    return obj;
  };

  babelHelpers["extends"] = Object.assign || function (target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];

      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }

    return target;
  };

  babelHelpers.get = function get(object, property, receiver) {
    if (object === null) object = Function.prototype;
    var desc = Object.getOwnPropertyDescriptor(object, property);

    if (desc === undefined) {
      var parent = Object.getPrototypeOf(object);

      if (parent === null) {
        return undefined;
      } else {
        return get(parent, property, receiver);
      }
    } else if ("value" in desc) {
      return desc.value;
    } else {
      var getter = desc.get;

      if (getter === undefined) {
        return undefined;
      }

      return getter.call(receiver);
    }
  };

  babelHelpers.inherits = function (subClass, superClass) {
    if (typeof superClass !== "function" && superClass !== null) {
      throw new TypeError("Super expression must either be null or a function, not " + typeof superClass);
    }

    subClass.prototype = Object.create(superClass && superClass.prototype, {
      constructor: {
        value: subClass,
        enumerable: false,
        writable: true,
        configurable: true
      }
    });
    if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass;
  };

  babelHelpers["instanceof"] = function (left, right) {
    if (right != null && typeof Symbol !== "undefined" && right[Symbol.hasInstance]) {
      return right[Symbol.hasInstance](left);
    } else {
      return left instanceof right;
    }
  };

  babelHelpers.interopRequireDefault = function (obj) {
    return obj && obj.__esModule ? obj : {
      "default": obj
    };
  };

  babelHelpers.interopRequireWildcard = function (obj) {
    if (obj && obj.__esModule) {
      return obj;
    } else {
      var newObj = {};

      if (obj != null) {
        for (var key in obj) {
          if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key];
        }
      }

      newObj["default"] = obj;
      return newObj;
    }
  };

  babelHelpers.newArrowCheck = function (innerThis, boundThis) {
    if (innerThis !== boundThis) {
      throw new TypeError("Cannot instantiate an arrow function");
    }
  };

  babelHelpers.objectDestructuringEmpty = function (obj) {
    if (obj == null) throw new TypeError("Cannot destructure undefined");
  };

  babelHelpers.objectWithoutProperties = function (obj, keys) {
    var target = {};

    for (var i in obj) {
      if (keys.indexOf(i) >= 0) continue;
      if (!Object.prototype.hasOwnProperty.call(obj, i)) continue;
      target[i] = obj[i];
    }

    return target;
  };

  babelHelpers.possibleConstructorReturn = function (self, call) {
    if (!self) {
      throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
    }

    return call && (typeof call === "object" || typeof call === "function") ? call : self;
  };

  babelHelpers.selfGlobal = typeof global === "undefined" ? self : global;

  babelHelpers.set = function set(object, property, value, receiver) {
    var desc = Object.getOwnPropertyDescriptor(object, property);

    if (desc === undefined) {
      var parent = Object.getPrototypeOf(object);

      if (parent !== null) {
        set(parent, property, value, receiver);
      }
    } else if ("value" in desc && desc.writable) {
      desc.value = value;
    } else {
      var setter = desc.set;

      if (setter !== undefined) {
        setter.call(receiver, value);
      }
    }

    return value;
  };

  babelHelpers.slicedToArray = function () {
    function sliceIterator(arr, i) {
      var _arr = [];
      var _n = true;
      var _d = false;
      var _e = undefined;

      try {
        for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) {
          _arr.push(_s.value);

          if (i && _arr.length === i) break;
        }
      } catch (err) {
        _d = true;
        _e = err;
      } finally {
        try {
          if (!_n && _i["return"]) _i["return"]();
        } finally {
          if (_d) throw _e;
        }
      }

      return _arr;
    }

    return function (arr, i) {
      if (Array.isArray(arr)) {
        return arr;
      } else if (Symbol.iterator in Object(arr)) {
        return sliceIterator(arr, i);
      } else {
        throw new TypeError("Invalid attempt to destructure non-iterable instance");
      }
    };
  }();

  babelHelpers.slicedToArrayLoose = function (arr, i) {
    if (Array.isArray(arr)) {
      return arr;
    } else if (Symbol.iterator in Object(arr)) {
      var _arr = [];

      for (var _iterator = arr[Symbol.iterator](), _step; !(_step = _iterator.next()).done;) {
        _arr.push(_step.value);

        if (i && _arr.length === i) break;
      }

      return _arr;
    } else {
      throw new TypeError("Invalid attempt to destructure non-iterable instance");
    }
  };

  babelHelpers.taggedTemplateLiteral = function (strings, raw) {
    return Object.freeze(Object.defineProperties(strings, {
      raw: {
        value: Object.freeze(raw)
      }
    }));
  };

  babelHelpers.taggedTemplateLiteralLoose = function (strings, raw) {
    strings.raw = raw;
    return strings;
  };

  babelHelpers.temporalRef = function (val, name, undef) {
    if (val === undef) {
      throw new ReferenceError(name + " is not defined - temporal dead zone");
    } else {
      return val;
    }
  };

  babelHelpers.temporalUndefined = {};

  babelHelpers.toArray = function (arr) {
    return Array.isArray(arr) ? arr : Array.from(arr);
  };

  babelHelpers.toConsumableArray = function (arr) {
    if (Array.isArray(arr)) {
      for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

      return arr2;
    } else {
      return Array.from(arr);
    }
  };
})(typeof global === "undefined" ? self : global); module.exports = global.babelHelpers;
},{}]},{},[228]);
