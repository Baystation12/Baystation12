/datum/keybinding/robot
	category = CATEGORY_ROBOT

/datum/keybinding/robot/can_use(client/user)
	return isrobot(user.mob)

/datum/keybinding/robot/moduleone
	hotkey_keys = list("1")
	name = "module_one"
	full_name = "Toggle Module 1"
	description = "Equips or unequips the first module"

/datum/keybinding/robot/moduleone/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(1)
	return TRUE

/datum/keybinding/robot/moduletwo
	hotkey_keys = list("2")
	name = "module_two"
	full_name = "Toggle Module 2"
	description = "Equips or unequips the second module"

/datum/keybinding/robot/moduletwo/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(2)
	return TRUE

/datum/keybinding/robot/modulethree
	hotkey_keys = list("3")
	name = "module_three"
	full_name = "Toggle Module 3"
	description = "Equips or unequips the third module"

/datum/keybinding/robot/modulethree/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(3)
	return TRUE

/datum/keybinding/robot/intent_cycle
	hotkey_keys = list("4")
	name = "cycle_intent"
	full_name = "Cycle Intent Left"
	description = "Cycles the intent left"

/datum/keybinding/robot/intent_cycle/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE

/datum/keybinding/robot/module_cycle
	hotkey_keys = list("X")
	name = "cycle_modules"
	full_name = "Cycle Modules"
	description = "Cycles your modules"

/datum/keybinding/robot/module_cycle/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.cycle_modules()
	return TRUE

/datum/keybinding/robot/unequip_module
	hotkey_keys = list("Q")
	name = "unequip_module"
	full_name = "Unequip Module"
	description = "Unequips the active module"

/datum/keybinding/robot/unequip_module/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	if(R.module)
		R.uneq_active()
	return TRUE
