/datum/keybinding/movement
	category = CATEGORY_MOVEMENT


/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Move North"
	description = "Moves your character north"


/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Move South"
	description = "Moves your character south"


/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Move West"
	description = "Moves your character left"


/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Move East"
	description = "Moves your character east"


/datum/keybinding/movement/move_quickly
	hotkey_keys = list("Shift")
	name = "moving_quickly"
	full_name = "Move Quickly"
	description = "Makes you move quickly"


/datum/keybinding/movement/move_quickly/down(client/user)
	user.setmovingquickly()
	return TRUE


/datum/keybinding/movement/move_quickly/up(client/user)
	user.setmovingslowly()
	return TRUE


/datum/keybinding/movement/move_up
	hotkey_keys = list(",", "=")
	name = "move_up"
	full_name = "Move Up"
	description = "Makes you go up"


/datum/keybinding/movement/move_up/down(client/user)
	var/mob/M = user.mob
	M.move_up()


/datum/keybinding/movement/move_down
	hotkey_keys = list(".", "-")
	name = "move_down"
	full_name = "Move Down"
	description = "Makes you go down"


/datum/keybinding/movement/move_down/down(client/user)
	var/mob/M = user.mob
	M.down()
