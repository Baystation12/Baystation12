NanoStateManager = function () { // Renders templates from server data.
  var _isInitialised = false // True once all of this UIs templates are ready.
  var _data = null // the data for this UI, if any.
  var _beforeUpdateCallbacks = {} // Callbacks to call on NanoStateClass.onBeforeUpdate.
  var _afterUpdateCallbacks = {} // Callbacks to call on NanoStateClass.onAfterUpdate.
  var _states = {} // State objects for custom behavior.
  var _currentState = null

  // Called when the UI loads. Sets up templates and behaviors.
  var init = function () {
    _data = $('body').data('initialData')
    if (_data == null || !_data.hasOwnProperty('config') || !_data.hasOwnProperty('data'))
      alert('Error: Initial data did not load correctly.')
    var stateKey = 'default'
    if (_data['config'].hasOwnProperty('stateKey') && _data['config']['stateKey'])
      stateKey = _data['config']['stateKey'].toLowerCase()
    NanoStateManager.setCurrentState(stateKey)
    $(document).on('templatesLoaded', function () {
      doUpdate(_data)
      _isInitialised = true
    })
  }

  // Receive update data from the server
  var receiveUpdateData = function (jsonString) {
    var updateData
    try {
      updateData = jQuery.parseJSON(jsonString)
    }
    catch (error) {
      alert("recieveUpdateData failed. " + "<br>Error name: " + error.name + "<br>Error Message: " + error.message)
      return
    }
    if (!updateData.hasOwnProperty('data'))
      if (_data && _data.hasOwnProperty('data'))
        updateData['data'] = _data['data']
      else
        updateData['data'] = {}
    if (_isInitialised)
      doUpdate(updateData)
    else
      _data = updateData
  }

  // Update the template once ready and data is available.
  var doUpdate = function (data) {
    if (_currentState == null)
        return
    data = _currentState.onBeforeUpdate(data)
    if (data === false) {
      alert('data is false, return')
      return // No render.
    }
    _data = data
    _currentState.onUpdate(_data)
    _currentState.onAfterUpdate(_data)
  }

  // Run everything in callbacks on data and return the result.
  var executeCallbacks = function (callbacks, data) {
    for (var key in callbacks)
      if (callbacks.hasOwnProperty(key) && jQuery.isFunction(callbacks[key]))
        data = callbacks[key].call(this, data)
    return data
  }

  return {
    init: function () {
      init()
    },

    receiveUpdateData: function (jsonString) {
      receiveUpdateData(jsonString)
    },

    addBeforeUpdateCallback: function (key, callbackFunction) {
      _beforeUpdateCallbacks[key] = callbackFunction
    },

    addBeforeUpdateCallbacks: function (callbacks) {
      for (var callbackKey in callbacks)
        if (callbacks.hasOwnProperty(callbackKey))
          NanoStateManager.addBeforeUpdateCallback(callbackKey, callbacks[callbackKey])
    },

    removeBeforeUpdateCallback: function (key) {
      if (_beforeUpdateCallbacks.hasOwnProperty(key))
        delete _beforeUpdateCallbacks[key]
    },

    executeBeforeUpdateCallbacks: function (data) {
      return executeCallbacks(_beforeUpdateCallbacks, data)
    },

    addAfterUpdateCallback: function (key, callbackFunction) {
      _afterUpdateCallbacks[key] = callbackFunction
    },

    addAfterUpdateCallbacks: function (callbacks) {
      for (var callbackKey in callbacks)
        if (callbacks.hasOwnProperty(callbackKey))
          NanoStateManager.addAfterUpdateCallback(callbackKey, callbacks[callbackKey])
    },

    removeAfterUpdateCallback: function (key) {
      if (_afterUpdateCallbacks.hasOwnProperty(key))
        delete _afterUpdateCallbacks[key]
    },

    executeAfterUpdateCallbacks: function (data) {
      return executeCallbacks(_afterUpdateCallbacks, data)
    },

    addState: function (state) {
      if (!(state instanceof NanoStateClass)) {
        alert('ERROR: Attempted to add a state which is not instanceof NanoStateClass')
        return
      }
      if (!state.key) {
        alert('ERROR: Attempted to add a state with an invalid stateKey')
        return
      }
      _states[state.key] = state
    },

    setCurrentState: function (stateKey) {
      if (typeof stateKey === 'undefined' || !stateKey) {
        alert('ERROR: No state key was passed!')
        return false
      }
      if (!_states.hasOwnProperty(stateKey)) {
        alert('ERROR: Attempted to set a current state which does not exist: ' + stateKey)
        return false
      }
      var previousState = _currentState;
      _currentState = _states[stateKey]

      if (previousState != null)
        previousState.onRemove(_currentState)
      _currentState.onAdd(previousState)
      return true
    },

    getCurrentState: function () {
      return _currentState
    }
  }
}()
