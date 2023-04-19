NanoBaseCallbacks = function () {
  var _canClick = true
  var _baseBeforeUpdateCallbacks = {}
  var _baseAfterUpdateCallbacks = {
    status: function (updateData) {
      var uiStatusClass
      // rome-ignore lint/suspicious/noDoubleEquals: Needs checking - this might rely on coercion
      if (updateData['config']['status'] == 2) {
        uiStatusClass = 'icon24 uiStatusGood'
        $('.linkActive').removeClass('inactive')
      }
      // rome-ignore lint/suspicious/noDoubleEquals: Needs checking - this might rely on coercion
      else if (updateData['config']['status'] == 1) {
        uiStatusClass = 'icon24 uiStatusAverage'
        $('.linkActive').addClass('inactive')
      }
      else {
        uiStatusClass = 'icon24 uiStatusBad'
        $('.linkActive').addClass('inactive')
      }
      $('#uiStatusIcon').attr('class', uiStatusClass)
      $('.linkActive').stopTime('linkPending')
      $('.linkActive').removeClass('linkPending')
      $('.linkActive')
        .off('click')
        .on('click', function (event) {
          event.preventDefault()
            var href = $(this).data('href')
            if (href != null && _canClick) {
              _canClick = false
              $('body').oneTime(300, 'enableClick', function () {
                  _canClick = true
              })
              // rome-ignore lint/suspicious/noDoubleEquals: Needs checking - this might rely on coercion
              if (updateData['config']['status'] == 2)
                $(this).oneTime(300, 'linkPending', function () {
                  $(this).addClass('linkPending')
                })
              window.location.href = href
            }
        })
      return updateData
    },

    nanomap: function (updateData) {
      $('.mapIcon')
        .off('mouseenter mouseleave')
        .on('mouseenter', function (event) {
          $('#uiMapTooltip')
            .html($(this).children('.tooltip').html())
            .show()
            .stopTime()
            .oneTime(5000, 'hideTooltip', function () {
              $(this).fadeOut(500)
          })
        })
      $('.zoomLink')
        .off('click')
        .on('click', function (event) {
          event.preventDefault()
          var zoomLevel = $(this).data('zoomLevel')
          var uiMapObject = $('#uiMap')
          var uiMapWidth = uiMapObject.width() * zoomLevel
          var uiMapHeight = uiMapObject.height() * zoomLevel
          uiMapObject.css({
            zoom: zoomLevel,
            left: '50%',
            top: '50%',
            marginLeft: '-' + Math.floor(uiMapWidth / 2) + 'px',
            marginTop: '-' + Math.floor(uiMapHeight / 2) + 'px'
          })
        })
      $('#uiMapImage').attr('src', updateData['config']['mapName'] + '-' + updateData['config']['mapZLevel'] + '.png')
      return updateData
    }
  }

  return {
    addCallbacks: function () {
      NanoStateManager.addBeforeUpdateCallbacks(_baseBeforeUpdateCallbacks)
      NanoStateManager.addAfterUpdateCallbacks(_baseAfterUpdateCallbacks)
    },

    removeCallbacks: function () {
      for (var callbackKey in _baseBeforeUpdateCallbacks)
        if (_baseBeforeUpdateCallbacks.hasOwnProperty(callbackKey))
          NanoStateManager.removeBeforeUpdateCallback(callbackKey)
      for (var callbackKey in _baseAfterUpdateCallbacks)
        if (_baseAfterUpdateCallbacks.hasOwnProperty(callbackKey))
          NanoStateManager.removeAfterUpdateCallback(callbackKey)
    }
  }
}()
