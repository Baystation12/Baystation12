SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	init_order = SS_INIT_CHAR_SETUP
	priority = SS_PRIORITY_CHAR_SETUP
	flags = SS_BACKGROUND
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/prefs_awaiting_setup = list()
	var/list/preferences_datums = list()
	var/list/newplayers_requiring_init = list()

	var/list/save_queue = list()


/datum/controller/subsystem/character_setup/UpdateStat(time)
	return


/datum/controller/subsystem/character_setup/Initialize(start_uptime)
	while(length(prefs_awaiting_setup))
		var/datum/preferences/prefs = prefs_awaiting_setup[length(prefs_awaiting_setup)]
		LIST_DEC(prefs_awaiting_setup)
		prefs.setup()
	while(length(newplayers_requiring_init))
		var/mob/new_player/new_player = newplayers_requiring_init[length(newplayers_requiring_init)]
		LIST_DEC(newplayers_requiring_init)
		new_player.deferred_login()


/datum/controller/subsystem/character_setup/fire(resumed = FALSE)
	while(length(save_queue))
		var/datum/preferences/prefs = save_queue[length(save_queue)]
		LIST_DEC(save_queue)

		if(!QDELETED(prefs))
			prefs.save_preferences()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/character_setup/proc/queue_preferences_save(datum/preferences/prefs)
	save_queue |= prefs
