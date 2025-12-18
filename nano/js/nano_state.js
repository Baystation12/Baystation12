function NanoStateClass() {
}

NanoStateClass.prototype.key = null
NanoStateClass.prototype.layoutRendered = false
NanoStateClass.prototype.contentRendered = false
NanoStateClass.prototype.mapInitialised = false

NanoStateClass.prototype.isCurrent = function () {
  return NanoStateManager.getCurrentState() === this
}

NanoStateClass.prototype.onAdd = function (previousState) {
  NanoBaseCallbacks.addCallbacks()
  NanoBaseHelpers.addHelpers()
}

NanoStateClass.prototype.onRemove = function (nextState) {
  NanoBaseCallbacks.removeCallbacks()
  NanoBaseHelpers.removeHelpers()
}

NanoStateClass.prototype.onBeforeUpdate = function (data) {
  data = NanoStateManager.executeBeforeUpdateCallbacks(data)
  return data
}

NanoStateClass.prototype.onUpdate = function (data) {
  try {
    if (!this.layoutRendered || (data['config'].hasOwnProperty('autoUpdateLayout') && data['config']['autoUpdateLayout'])){
      $("#uiLayout").html(NanoTemplate.parse('layout', data))
      this.layoutRendered = true
    }
    if (!this.contentRendered || (data['config'].hasOwnProperty('autoUpdateContent') && data['config']['autoUpdateContent'])) {
      $("#uiContent").html(NanoTemplate.parse('main', data))
      if (NanoTemplate.templateExists('layoutHeader'))
        $("#uiHeaderContent").html(NanoTemplate.parse('layoutHeader', data))
      this.contentRendered = true
    }
    if (NanoTemplate.templateExists('mapContent')) {
      if (!this.mapInitialised) {
        $('#uiMap').draggable()
        $('#uiMapTooltip')
          .off('click')
          .on('click', function (event) {
            event.preventDefault()
            $(this).fadeOut(400)
          })
        this.mapInitialised = true
      }
      $("#uiMapContent").html(NanoTemplate.parse('mapContent', data))
      if (data['config'].hasOwnProperty('showMap') && data['config']['showMap']) {
        $('#uiContent').addClass('hidden')
        $('#uiMapWrapper').removeClass('hidden')
      }
      else {
        $('#uiMapWrapper').addClass('hidden')
        $('#uiContent').removeClass('hidden')
      }
    }
    if (NanoTemplate.templateExists('mapHeader'))
      $("#uiMapHeader").html(NanoTemplate.parse('mapHeader', data))
    if (NanoTemplate.templateExists('mapFooter'))
      $("#uiMapFooter").html(NanoTemplate.parse('mapFooter', data))
  }
  catch(error) {
    alert('ERROR: An error occurred while rendering the UI: ' + error.message)
    return
  }
}

NanoStateClass.prototype.onAfterUpdate = function (data) {
  NanoStateManager.executeAfterUpdateCallbacks(data)
}

NanoStateClass.prototype.alertText = function (text) {
  alert(text)
}
