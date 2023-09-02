/client
	/// Custom movement keys for this client
	var/list/movement_keys = list()
	/// Are we locking our movement input?
	var/movement_locked = FALSE

	/// A buffer of currently held keys.
	var/list/keys_held = list()
	/// A buffer for combinations such of modifiers + keys (ex: CtrlD, AltE, ShiftT). Format: `"key"` -> `"combo"` (ex: `"D"` -> `"CtrlD"`)
	var/list/key_combos_held = list()
	/*
	** These next two vars are to apply movement for keypresses and releases made while move delayed.
	** Because discarding that input makes the game less responsive.
	*/
	/// On next move, add this dir to the move that would otherwise be done
	var/next_move_dir_add
	/// On next move, subtract this dir from the move that would otherwise be done
	var/next_move_dir_sub
	/// Movement dir of the most recently pressed movement key. Used in cardinal-only movement mode.
	var/last_move_dir_pressed


/client/Click(atom/A)
	if(!user_acted(src))
		return

	if(holder && holder.callproc && holder.callproc.waiting_for_click)
		if(alert("Do you want to select \the [A] as the [length(holder.callproc.arguments)+1]\th argument?",, "Yes", "No") == "Yes")
			holder.callproc.arguments += A

		holder.callproc.waiting_for_click = 0
		verbs -= /client/proc/cancel_callproc_select
		holder.callproc.do_args()
		return

	update_hotkey_mode()

	return ..()


/**
 * Updates the keybinds for special keys
 *
 * Handles adding macros for the keys that need it
 * And adding movement keys to the clients movement_keys list
 * At the time of writing this, communication(OOC, Say, IC) require macros
 * Arguments:
 * * direct_prefs - the preference we're going to get keybinds from
 */
/client/proc/update_special_keybinds(datum/preferences/direct_prefs)
	var/datum/preferences/D = prefs || direct_prefs
	if(!D?.key_bindings)
		return
	movement_keys = list()
	var/list/communication_hotkeys = list()
	for(var/key in D.key_bindings)
		for(var/kb_name in D.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH
				if("Say")
					winset(src, "default-\ref[key]", "parent=default;name=[key];command=say")
					communication_hotkeys += key
				if("OOC")
					winset(src, "default-\ref[key]", "parent=default;name=[key];command=ooc")
					communication_hotkeys += key
				if("Me")
					winset(src, "default-\ref[key]", "parent=default;name=[key];command=me")
					communication_hotkeys += key

	// winget() does not work for F1 and F2
	for(var/key in communication_hotkeys)
		if(!(key in list("F1","F2")) && !winget(src, "default-\ref[key]", "command"))
			to_chat(src, "You probably entered the game with a different keyboard layout.\n<a href='?src=\ref[src];reset_macros=1'>Please switch to the English layout and click here to fix the communication hotkeys.</a>")
			break


/client/verb/ToggleHotkeyMode()
	set hidden = TRUE
	prefs.hotkeys = !prefs.hotkeys
	update_hotkey_mode()


/client/proc/update_hotkey_mode()
	if (prefs.hotkeys)
		// If hotkey mode is enabled, then clicking the map will automatically
		// unfocus the text bar. This removes the red color from the text bar
		// so that the visual focus indicator matches reality.
		winset(src, "mainwindow.mainwindow", "macro=default")
		winset(src, "mapwindow.map", "focus=true")
		winset(src, "hotkey_toggle", "is-checked=true")
		winset(src, "mainwindow.input", "background-color = [COLOR_DARKMODE_BACKGROUND]; background-color = #ffffff")
		winset(src, "mainwindow.input", "text-color = [COLOR_DARKMODE_TEXT]; text-color = #000000")
	else
		winset(src, "mainwindow.mainwindow", "macro=macro")
		winset(src, "hotkey_toggle", "is-checked=false")
		winset(src, "mainwindow.input", "focus=true")
		winset(src, "mainwindow.input", "text-color = #000000; background-color = #d3b5b5")



// Я срал, Глист, на читаемость и отладку
// Это уже протестировано и мы просто ждём пока на оффбей зальют эти кейбинды вонючие
// Ну а если не зальют - так уж и быть, в коркод суну

// SIERRA TODO: ПЕРЕНЕСТИ В КОР КОД ЕСЛИ ОФФЫ НЕ ЗАЛЬЮТ
/client/Topic(href, href_list, hsrc)
	//byond bug ID:2694120
	if(href_list["reset_macros"])
		reset_macros(skip_alert = TRUE)
		return

	. = ..()
