/datum/keybinding/mob
	category = CATEGORY_HUMAN


/datum/keybinding/mob/can_use(client/user)
	return ismob(user.mob) ? TRUE : FALSE


/datum/keybinding/mob/cycle_intent_right
	hotkey_keys = list("G", "Insert")
	name = "cycle_intent_right"
	full_name = "Сycle Intent: Right"
	description = ""


/datum/keybinding/mob/cycle_intent_right/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_RIGHT)
	return TRUE


/datum/keybinding/mob/cycle_intent_left
	hotkey_keys = list("F")
	name = "cycle_intent_left"
	full_name = "Сycle Intent: Left"
	description = ""


/datum/keybinding/mob/cycle_intent_left/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE


/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z", "Y","Southeast") // Southeast = PAGEDOWN
	name = "activate_inhand"
	full_name = "Activate In-Hand"
	description = "Uses whatever item you have inhand"


/datum/keybinding/mob/activate_inhand/down(client/user)
	var/mob/M = user.mob
	M.mode()
	return TRUE


/datum/keybinding/mob/target_head_cycle
	hotkey_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "Target: Cycle Head"
	description = ""


/datum/keybinding/mob/target_head_cycle/down(client/user)
	user.body_toggle_head()
	return TRUE


/datum/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "Target: Right Arm"
	description = ""


/datum/keybinding/mob/target_r_arm/down(client/user)
	user.body_r_arm()
	return TRUE


/datum/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "Target: Body"
	description = ""


/datum/keybinding/mob/target_body_chest/down(client/user)
	user.body_chest()
	return TRUE


/datum/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "Target: Left Arm"
	description = ""


/datum/keybinding/mob/target_left_arm/down(client/user)
	user.body_l_arm()
	return TRUE


/datum/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "Target: Right leg"
	description = ""


/datum/keybinding/mob/target_right_leg/down(client/user)
	user.body_r_leg()
	return TRUE


/datum/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "Target: Groin"
	description = ""


/datum/keybinding/mob/target_body_groin/down(client/user)
	user.body_groin()
	return TRUE


/datum/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "Target: Left Leg"
	description = ""


/datum/keybinding/mob/target_left_leg/down(client/user)
	user.body_l_leg()
	return TRUE


/datum/keybinding/mob/prevent_movement
	hotkey_keys = list("Ctrl")
	name = "block_movement"
	full_name = "Block movement"
	description = "Prevents you from moving"


/datum/keybinding/mob/prevent_movement/down(client/user)
	user.movement_locked = TRUE
	return TRUE


/datum/keybinding/mob/prevent_movement/up(client/user)
	user.movement_locked = FALSE
	return TRUE


/datum/keybinding/mob/toggle_gun_mode
	hotkey_keys = list("J")
	name = "toggle_gun_mode"
	full_name = "Toggle Gun Mode"


/datum/keybinding/mob/toggle_gun_mode/down(client/user)
	var/mob/M = user.mob
	M.toggle_gun_mode()
