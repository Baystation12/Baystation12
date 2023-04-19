var NanoUtility = function () {
  var _urlParameters = {}
  return {
    init: function () {
      var body = $('body')
      _urlParameters = body.data('urlParameters')
    },

    generateHref: function (parameters) {
      var queryString = '?'
      for (var key in _urlParameters) {
        if (_urlParameters.hasOwnProperty(key)) {
          if (queryString !== '?')
            queryString += ';'
          queryString += key + '=' + _urlParameters[key]
        }
      }
      for (var key in parameters) {
        if (parameters.hasOwnProperty(key)) {
          if (queryString !== '?')
            queryString += ';'
          queryString += key + '=' + parameters[key]
        }
      }
      return queryString
    }
  }
}()

if (!Array.prototype.indexOf) {
  Array.prototype.indexOf = function (searchElement, fromIndex) {
    var length = this.length
    if (!length)
      return -1
    else if (fromIndex >= length)
      return -1
    else if ((fromIndex|0) !== fromIndex)
      return -1
    else if (typeof searchElement === 'number' && searchElement !== searchElement)
      return -1
    else if (fromIndex == null)
      fromIndex = 0
    else if (fromIndex < -length)
      fromIndex = 0
    else if (fromIndex < 0)
      fromIndex += length
    for (var index = fromIndex; index < length; ++index)
      if (this[index] === searchElement)
      return index
    return -1
  }
}

if (!String.prototype.format) {
  String.prototype.format = function (args) {
    var str = this
    return str.replace(String.prototype.format.regex, function(item) {
      var intVal = parseInt(item.substring(1, item.length - 1))
      var replace
      if (intVal >= 0)
          replace = args[intVal]
      else if (intVal === -1)
          replace = "{"
      else if (intVal === -2)
          replace = "}"
      else
          replace = ""
      return replace
    })
  }
  String.prototype.format.regex = new RegExp("{-?[0-9]+}", "g")
}

Object.size = function (obj) {
  var size = 0
  for (var key in obj)
    if (obj.hasOwnProperty(key))
      size++
  return size
}

if (!window.console) {
  window.console = {
    log: function (str) {
      return false
    }
  }
}

String.prototype.toTitleCase = function () {
  var smallWords = /^(a|an|and|as|at|but|by|en|for|if|in|of|on|or|the|to|vs?\.?|via)$/i
  return this.replace(/([^\W_]+[^\s-]*) */g, function (match, p1, index, title) {
    if (index > 0 && index + p1.length !== title.length &&
      p1.search(smallWords) > -1 && title.charAt(index - 2) !== ":" &&
      title.charAt(index - 1).search(/[^\s-]/) < 0) {
      return match.toLowerCase()
    }
    if (p1.substr(1).search(/[A-Z]|\../) > -1) {
      return match
    }
    return match.charAt(0).toUpperCase() + match.substr(1)
  })
}

Function.prototype.inheritsFrom = function (parentClassOrObject) {
  this.prototype = new parentClassOrObject
  this.prototype.constructor = this
  this.prototype.parent = parentClassOrObject.prototype
  return this
}

if (!String.prototype.trim) {
  String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, '')
  }
}

if (!String.prototype.ckey) {
  String.prototype.ckey = function () {
    return this.replace(/\W/g, '').toLowerCase()
  }
}

if (typeof jQuery === 'undefined')
  alert('ERROR: Javascript library failed to load!')
if (typeof doT === 'undefined')
  alert('ERROR: Template engine failed to load!')

(function () {
  var _alert = window.alert
  window.alert = function(str) {
    window.location = "byond://?nano_err=" + encodeURIComponent(str)
    _alert(str)
  }
})()

$(document).ready(function () {
  NanoUtility.init()
  NanoStateManager.init()
  NanoTemplate.init()
})

$.ajaxSetup({
  cache: false
})
