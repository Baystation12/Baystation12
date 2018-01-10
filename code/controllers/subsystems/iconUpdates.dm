var/datum/controller/subsystem/icon_updater/iconupdater

/datum/controller/subsystem/icon_updater
	name = "Icon Updating"
	priority = 25
	wait = 20
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVEL_INIT | RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/iconslasttick = 0
	var/list/icon_updates = list()

/datum/controller/subsystem/icon_updater/New()
	NEW_SS_GLOBAL(iconupdater)
	spawn(700) //After 70 seconds, so when everything has pretty much initialized..
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

//Since this controller is a bit wonky when it comes to lag, it is possible for it to become backlogged in icon update requests.
//The way they are added, every icon is still only updated once.
//Once the backlog is too great, we give it a faster processing speed and priority to catch up until it restores to normal levels.
/datum/controller/subsystem/icon_updater/proc/CheckBacklog()
	set waitfor = 0
	switch(icon_updates.len)
		if(1500 to 3000)
			if(iconslasttick < 50) //Large backlog, or not processing enough icons per tick
				wait = 15
			priority = 30
		if(3001 to 6000)
			if(iconslasttick < 50)
				wait = 15
				priority = 35
				message_admins("Something went bad with the Icon Updater and its running behind a lot.. Let Laser know.")
		if(6001 to 10000)//We fucking done did it now boys.
			message_admins("Flushing Icon Updates..")
			Instant_Queue()

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
	CheckBacklog()

/datum/controller/subsystem/icon_updater/proc/Instant_Queue()
	set waitfor = 0
	var/iconscomplete
	while(icon_updates.len)
		var/tmp/atom/A = icon_updates[1]
		if(!QDELETED(A))
			A.update_icon()
			iconscomplete++
		icon_updates.Cut(1, 2)
		CHECK_TICK2(84)
	report_progress("Icon refresh completed. [iconscomplete] icons refreshed.")

#define ADD_ICON_QUEUE(THING)           \
	if(!QDELETED(THING))                \
		iconupdater.icon_updates |= THING;