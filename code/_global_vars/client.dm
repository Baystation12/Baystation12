var/global/list/hotkey_keybinding_list_by_key = list()
var/global/list/keybindings_by_name = list()

// This is a mapping from JS keys to Byond - ref: https://keycode.info/
var/global/list/_kbMap = list(
	"UP" = "North",
	"RIGHT" = "East",
	"DOWN" = "South",
	"LEFT" = "West",
	"INSERT" = "Insert",
	"HOME" = "Northwest",
	"PAGEUP" = "Northeast",
	"DEL" = "Delete",
	"END" = "Southwest",
	"PAGEDOWN" = "Southeast",
	"SPACEBAR" = "Space",
	"ALT" = "Alt",
	"SHIFT" = "Shift",
	"CONTROL" = "Ctrl"
)

// Without alt, shift, ctrl and etc because its not necessary
var/global/list/_kbMap_reverse = list(
	"North" = "Up",
	"East" = "Right",
	"South" = "Down",
	"West" = "Left",
	"Northwest" = "Home",
	"Northeast" = "PageUp",
	"Southwest" = "End",
	"Southeast" = "PageDown",
)
