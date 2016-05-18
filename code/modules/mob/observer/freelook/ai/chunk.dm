// CAMERA CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/chunk/camera
	var/list/cameras = list()

/datum/chunk/camera/Destroy()
	cameras.Cut()
	. = ..()

/datum/chunk/camera/add_source(var/atom/source)
	. = ..()
	if(. && istype(source, /obj/machinery/camera))
		cameras += source

/datum/chunk/camera/remove_source(var/atom/source)
	. = ..()
	if(. && istype(source, /obj/machinery/camera))
		cameras -= source

/datum/chunk/camera/acquire_visible_turfs(var/list/visible)
	for(var/source in sources)
		if(istype(source,/obj/machinery/camera))
			var/obj/machinery/camera/c = source
			if(!c.can_use())
				continue

			for(var/turf/t in c.can_see())
				visible[t] = t
		else if(isAI(source))
			var/mob/living/silicon/ai/AI = source
			if(AI.stat == DEAD)
				continue
			for(var/turf/t in seen_turfs_in_range(AI, world.view))
				visible[t] = t
		else
			var/datum/S = source
			log_debug("[visualnet] - [src] ([x]-[y]-[z]) contained an unhandled source: [S] [S ? "- [S.type]" : "" ]")
			sources -= source
