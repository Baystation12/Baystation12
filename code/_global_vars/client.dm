/// List to store the hotkey keybinds. Initially populated by default binds.
GLOBAL_LIST_INIT(hotkey_keybinding_list_by_key, list())

/// List to store names of all the controls that can have their keybinds changed.
GLOBAL_LIST_INIT(keybindings_by_name, list())

/// This is a mapping from JS keys to Byond - ref: https://keycode.info/
GLOBAL_LIST_INIT(_kbMap, list(
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
))


/// This is a mapping from Byond to JS keys - ref: https://keycode.info/. Without alt, shift, ctrl and etc because its not necessary
GLOBAL_LIST_INIT(_kbMap_reverse, list(
	"North" = "Up",
	"East" = "Right",
	"South" = "Down",
	"West" = "Left",
	"Northwest" = "Home",
	"Northeast" = "PageUp",
	"Southwest" = "End",
	"Southeast" = "PageDown",
))
