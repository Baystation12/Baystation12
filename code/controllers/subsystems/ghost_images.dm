SUBSYSTEM_DEF(ghost_images)
	name = "Ghost Images"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_GHOST_IMAGES
	wait = 1
	runlevels = RUNLEVELS_PREGAME | RUNLEVELS_GAME

	/// When true, queues all ghosts for update.
	var/static/queue_all = FALSE

	/// The queue of ghosts to update images for.
	var/static/list/mob/observer/ghost/queue = list()


/datum/controller/subsystem/ghost_images/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Queue: [length(queue)]")


/datum/controller/subsystem/ghost_images/fire(resumed, no_mc_tick)
	if (!resumed && queue_all)
		queue = GLOB.ghost_mobs.Copy()
		queue_all = FALSE
	if (!length(queue))
		return
	var/cut_until = 1
	for (var/mob/observer/ghost/ghost as anything in queue)
		++cut_until
		if (QDELETED(ghost))
			continue
		ghost.updateghostimages()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


/datum/controller/subsystem/ghost_images/proc/queue_image_update(mob/observer/ghost/ghost)
	if(!queue_all)
		queue |= ghost


/datum/controller/subsystem/ghost_images/proc/queue_global_image_update()
	queue_all = TRUE
