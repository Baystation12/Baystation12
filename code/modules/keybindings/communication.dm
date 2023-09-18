/datum/keybinding/client/communication
	category = CATEGORY_COMMUNICATION


/datum/keybinding/client/communication/say
	hotkey_keys = list("F3", "T")
	name = "IC Say"
	full_name = "IC Say"


/datum/keybinding/client/communication/say/down(client/user)
	user.mob.say_wrapper()
	return TRUE


/datum/keybinding/client/communication/ooc
	hotkey_keys = list("F2")
	name = "OOC"
	full_name = "Out Of Character Say (OOC)"


/datum/keybinding/client/communication/looc
	hotkey_keys = list("L")
	name = "LOOC"
	full_name = "Local Out Of Character Say (LOOC)"


/datum/keybinding/client/communication/looc/down(client/user)
	user.looc()
	return TRUE


/datum/keybinding/client/communication/me
	hotkey_keys = list("F4", "M", "5")
	name = "IC Me"
	full_name = "Custom Emote (/Me)"


/datum/keybinding/client/communication/me/down(client/user)
	user.mob.me_wrapper()
	return TRUE
