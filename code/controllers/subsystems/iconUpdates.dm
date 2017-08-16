var/datum/controller/subsystem/icon_updater/iconupdater

/datum/controller/subsystem/icon_updater
	name = "Icon Updating"
	priority = 20
	wait = 20
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVEL_INIT | RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/iconslasttick = 0
	var/list/icon_updates = list()

/datum/controller/subsystem/icon_updater/New()
	NEW_SS_GLOBAL(iconupdater)
	spawn(200) //After 20 seconds, so when everything has pretty much initialized..
		report_progress("Completing icon refresh.")
		Instant_Queue() //We do the entire queue now so we won't have to catch up.

/datum/controller/subsystem/icon_updater/stat_entry(msg)
	msg += "ICONS:[icon_updates.len]|LAST: [iconslasttick]"
	..(msg)

/datum/controller/subsystem/icon_updater/fire()
	if(state == SS_RUNNING)
		HandleQueue()
	if (state == SS_PAUSED) //make us wait again before the next run.
		state = SS_RUNNING

/datum/controller/subsystem/icon_updater/proc/HandleQueue()
	iconslasttick = 0

	while(icon_updates.len)
		var/tmp/atom/A = icon_updates[1]
		if(!QDELETED(A))
			A.update_icon()
			iconslasttick++
		icon_updates.Cut(1, 2)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/icon_updater/proc/Instant_Queue()
	while(icon_updates.len)
		var/tmp/atom/A = icon_updates[1]
		if(!QDELETED(A))
			A.update_icon()
			iconslasttick++
		icon_updates.Cut(1, 2)
		sleep()
	report_progress("Icon refresh completed. [iconslasttick] icons refreshed.")

#define ADD_ICON_QUEUE(THING)           \
	if(!QDELETED(THING))                \
		iconupdater.icon_updates |= THING;