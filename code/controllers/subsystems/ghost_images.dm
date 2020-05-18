SUBSYSTEM_DEF(ghost_images)
	name = "Ghost Images"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_GHOST_IMAGES
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/queue = list()
	var/queue_all = FALSE

/datum/controller/subsystem/ghost_images/stat_entry()
	..("P:[queue.len]")

/datum/controller/subsystem/ghost_images/fire(resumed = 0)
	if(!resumed && queue_all)
		queue = GLOB.ghost_mob_list.Copy()
		queue_all = FALSE

	var/list/curr = queue
	while (curr.len)
		var/mob/observer/ghost/target = curr[curr.len]
		curr.len--

		if(!QDELETED(target))
			target.updateghostimages()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/ghost_images/proc/queue_image_update(mob/observer/ghost/ghost)
	if(!queue_all)
		queue |= ghost

/datum/controller/subsystem/ghost_images/proc/queue_global_image_update()
	queue_all = TRUE