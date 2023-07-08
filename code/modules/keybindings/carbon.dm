/datum/keybinding/carbon
	category = CATEGORY_CARBON

/datum/keybinding/carbon/can_use(client/user)
	return iscarbon(user.mob)

/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R", "Southwest") // PAGEDOWN
	name = "toggle_throw_mode"
	full_name = "Toggle Throw Mode"
	description = "Toggle throwing the current item or not"

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode()
	return TRUE

/datum/keybinding/carbon/select_help_intent
	hotkey_keys = list("1")
	name = "select_help_intent"
	full_name = "Select Help Intent"
	description = ""

/datum/keybinding/carbon/select_help_intent/down(client/user)
	user.mob?.a_intent_change(I_HELP)
	return TRUE

/datum/keybinding/carbon/select_disarm_intent
	hotkey_keys = list("2")
	name = "select_disarm_intent"
	full_name = "Select Disarm Intent"
	description = ""

/datum/keybinding/carbon/select_disarm_intent/down(client/user)
	user.mob?.a_intent_change(I_DISARM)
	return TRUE

/datum/keybinding/carbon/select_grab_intent
	hotkey_keys = list("3")
	name = "select_grab_intent"
	full_name = "Select Grab Intent"
	description = ""

/datum/keybinding/carbon/select_grab_intent/down(client/user)
	user.mob?.a_intent_change(I_GRAB)
	return TRUE

/datum/keybinding/carbon/select_harm_intent
	hotkey_keys = list("4")
	name = "select_harm_intent"
	full_name = "Select Harm Intent"
	description = ""

/datum/keybinding/carbon/select_harm_intent/down(client/user)
	user.mob?.a_intent_change(I_HURT)
	return TRUE

/datum/keybinding/carbon/swap_hands
	hotkey_keys = list("X", "Northeast") // PAGEUP
	name = "swap_hands"
	full_name = "Swap Hands"
	description = ""

/datum/keybinding/carbon/swap_hands/down(client/user)
	var/mob/living/carbon/C = user.mob
	C.swap_hand()
	return TRUE
