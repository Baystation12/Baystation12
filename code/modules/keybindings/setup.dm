// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/// Called when a key is pressed down initially
/datum/proc/key_down(key, client/user)
	return


/// Called when a key is released
/datum/proc/key_up(key, client/user)
	return


/// Called once every frame
/datum/proc/keyLoop(client/user)
	set waitfor = FALSE
	return


/// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")
		var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
		erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)


/client/proc/set_macros()
	set waitfor = FALSE

	//Reset the buffer
	reset_held_keys()

	erase_all_macros()

	var/list/macro_set = SSinput.macro_set
	for(var/k in 1 to length(macro_set))
		var/key = macro_set[k]
		var/command = macro_set[key]
		winset(src, "default-\ref[key]", "parent=default;name=[key];command=[command]")

	update_special_keybinds()


// byond bug ID:2694120
/client/verb/reset_macros_wrapper()
	set category = "OOC"
	set name = "Fix Keybindings"

	reset_macros()


/client/proc/reset_macros(skip_alert = FALSE)
	var/ans
	if(!skip_alert)
		ans = alert(src, "Change your keyboard language to ENG", "Reset macros")

	if(skip_alert || ans)
		set_macros()
		to_chat(src, SPAN_NOTICE("Keybindings were fixed.")) // not yet but set_macros works fast enough


/**
 * Manually clears any held keys, in case due to lag or other undefined behavior a key gets stuck.
 *
 * Hardcoded to the ESC key.
 */
/client/verb/reset_held_keys()
	set name = "Reset Held Keys"
	set hidden = TRUE

	for(var/key in keys_held)
		keyUp(key)

	//In case one got stuck and the previous loop didn't clean it, somehow.
	for(var/key in key_combos_held)
		keyUp(key_combos_held[key])
