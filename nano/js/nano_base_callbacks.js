NanoBaseCallbacks = function () {
  var _canClick = true
  let _savedTextInputs = {}
  let _savedScrollPositions = {}

  const submitTextInput = (input) => {
    const value = input.val()
    if (!value || !_canClick || input.siblings('.textInputSend').hasClass('inactive'))
      return
    _canClick = false
    $('body').oneTime(300, 'enableClick', () => {
      _canClick = true
    })
    input.val('')
    window.location.href = `${input.data('href')};${input.data('param')}=${encodeURIComponent(value)}`
  }

  const saveScrollPositions = () => {
    _savedScrollPositions = {}
    $('.scrollToBottom').each((i, el) => {
      _savedScrollPositions[el.id] = {
        scrollTop: el.scrollTop,
        atBottom: el.scrollTop + el.clientHeight >= el.scrollHeight - 5
      }
    })
  }

  const restoreScrollPositions = () => {
    $('.scrollToBottom').each((i, el) => {
      const saved = _savedScrollPositions[el.id]
      el.scrollTop = (!saved || saved.atBottom) ? el.scrollHeight : saved.scrollTop
    })
  }

  const fillHeight = () => {
    $('.fillHeight').each((i, el) => {
      const minHeight = Number.parseInt($(el).css('min-height'), 10) || 0
      el.style.height = `${minHeight}px`
      const spare = document.documentElement.clientHeight - document.documentElement.offsetHeight
      if (spare > 0)
        el.style.height = `${minHeight + spare}px`
    })
  }

  const onWindowResize = () => {
    saveScrollPositions()
    fillHeight()
    restoreScrollPositions()
  }

  var _baseBeforeUpdateCallbacks = {
    textInput: (updateData) => {
      _savedTextInputs = {}
      $('.textInput').each((i, el) => {
        _savedTextInputs[el.id] = {
          value: el.value,
          focused: document.hasFocus() && document.activeElement === el,
          selectionStart: el.selectionStart,
          selectionEnd: el.selectionEnd
        }
      })
      return updateData
    },

    scrollToBottom: (updateData) => {
      saveScrollPositions()
      return updateData
    }
  }
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
            transform: 'scale(' + zoomLevel + ')',
          })
        })
      $('#uiMapImage').attr('src', updateData['config']['mapName'] + '-' + updateData['config']['mapZLevel'] + '.png')
      return updateData
    },

    textInput: (updateData) => {
      $('.textInput').each((i, el) => {
        const saved = _savedTextInputs[el.id]
        if (!saved)
          return
        el.value = saved.value
        if (saved.focused) {
          el.focus({ preventScroll: true })
          el.setSelectionRange(saved.selectionStart, saved.selectionEnd)
        }
      })
      return updateData
    },

    fillHeight: (updateData) => {
      fillHeight()
      return updateData
    },

    scrollToBottom: (updateData) => {
      restoreScrollPositions()
      return updateData
    }
  }

  return {
    addCallbacks: function () {
      NanoStateManager.addBeforeUpdateCallbacks(_baseBeforeUpdateCallbacks)
      NanoStateManager.addAfterUpdateCallbacks(_baseAfterUpdateCallbacks)
      $(document)
        .on('keydown.textInput', '.textInput', (event) => {
          if (event.key === 'Enter') {
            event.preventDefault()
            submitTextInput($(event.currentTarget))
          }
        })
        .on('click.textInput', '.textInputSend', (event) => {
          event.preventDefault()
          submitTextInput($(event.currentTarget).siblings('.textInput'))
        })
      $(window).on('resize.fillHeight', onWindowResize)
    },

    removeCallbacks: function () {
      for (var callbackKey in _baseBeforeUpdateCallbacks)
        if (_baseBeforeUpdateCallbacks.hasOwnProperty(callbackKey))
          NanoStateManager.removeBeforeUpdateCallback(callbackKey)
      for (var callbackKey in _baseAfterUpdateCallbacks)
        if (_baseAfterUpdateCallbacks.hasOwnProperty(callbackKey))
          NanoStateManager.removeAfterUpdateCallback(callbackKey)
      $(document).off('.textInput')
      $(window).off('resize.fillHeight')
    }
  }
}()
