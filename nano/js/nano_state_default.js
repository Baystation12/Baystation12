NanoStateDefaultClass.inheritsFrom(NanoStateClass)
var NanoStateDefault = new NanoStateDefaultClass()

function NanoStateDefaultClass() {
  this.key = 'default'
  this.key = this.key.toLowerCase()
  NanoStateManager.addState(this)
}
