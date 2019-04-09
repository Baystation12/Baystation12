SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	init_order = SS_INIT_CHAR_SETUP
	flags = SS_NO_FIRE

	var/list/prefs_awaiting_setup = list()
	var/list/preferences_datums = list()
	var/list/newplayers_requiring_init = list()

/datum/controller/subsystem/character_setup/Initialize()
	while(prefs_awaiting_setup.len)
		var/datum/preferences/prefs = prefs_awaiting_setup[prefs_awaiting_setup.len]
		prefs_awaiting_setup.len--
		prefs.setup()
	while(newplayers_requiring_init.len)
		var/mob/new_player/new_player = newplayers_requiring_init[newplayers_requiring_init.len]
		newplayers_requiring_init.len--
		new_player.deferred_login()
	. = ..()