// Я срал, Глист, на читаемость и отладку
// Это уже протестировано и мы просто ждём пока на оффбей зальют эти кейбинды вонючие
// Ну а если не зальют - так уж и быть, в коркод суну

// SIERRA TODO: ПЕРЕНЕСТИ В КОР КОД ЕСЛИ ОФФЫ НЕ ЗАЛЬЮТ
/datum/preferences/setup()
	// give them default keybinds too
	key_bindings = deepCopyList(global.hotkey_keybinding_list_by_key)

	. = ..()

	if(client)
		client.set_macros()



/// checks through keybindings for outdated unbound keys and updates them
/datum/preferences/proc/check_keybindings()
	if(!client)
		return

	// When loading from savefile key_binding can be null
	// This happens when player had savefile created before new kb system, but hotkeys was not saved
	if(!length(key_bindings))
		key_bindings = deepCopyList(global.hotkey_keybinding_list_by_key) // give them default keybinds too

	var/list/user_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)
	var/list/notadded = list()
	for (var/name in global.keybindings_by_name)
		var/datum/keybinding/kb = global.keybindings_by_name[name]
		if(length(user_binds[kb.name]))
			continue // key is unbound and or bound to something
		var/addedbind = FALSE
		if(hotkeys)
			for(var/hotkeytobind in kb.hotkey_keys)
				if(!length(key_bindings[hotkeytobind]) || hotkeytobind == "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					LAZYADD(key_bindings[hotkeytobind], kb.name)
					addedbind = TRUE
		else
			for(var/classickeytobind in kb.classic_keys)
				if(!length(key_bindings[classickeytobind]) || classickeytobind == "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					LAZYADD(key_bindings[classickeytobind], kb.name)
					addedbind = TRUE
		if(!addedbind)
			notadded += kb

	if(length(notadded))
		addtimer(new Callback(src, PROC_REF(announce_conflict), notadded), 5 SECONDS)



/datum/preferences/proc/announce_conflict(list/notadded)
	to_chat(client, SPAN_DANGER("KEYBINDING CONFLICT.\n\
	There are new keybindings that have defaults bound to keys you already set, They will default to Unbound. You can bind them in Setup Character or Game Preferences\n\
	<a href='?src=\ref[src];preference=tab;tab=3'>Or you can click here to go straight to the keybindings page.</a>"))
	for(var/item in notadded)
		var/datum/keybinding/conflicted = item
		to_chat(client, SPAN_DANGER("[conflicted.category]: [conflicted.full_name] needs updating."))
		LAZYADD(key_bindings["None"], conflicted.name) // set it to unbound to prevent this from opening up again in the future
