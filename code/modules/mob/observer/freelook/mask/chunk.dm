// CULT CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/obfuscation/cult
	icon_state = "white"

/datum/chunk/cult
	obfuscation = new /datum/obfuscation/cult()

/datum/chunk/cult/acquireVisibleTurfs(var/list/visible)
	for(var/mob/living/L in living_mob_list)
		for(var/turf/t in L.seen_cult_turfs())
			visible[t] = t

/mob/living/proc/seen_cult_turfs()
	return seen_turfs_in_range(src, 3)

/mob/living/carbon/human/seen_cult_turfs()
	if(mind in cult.current_antagonists)
		return seen_turfs_in_range(src, world.view)
	return ..()

/mob/living/silicon/seen_cult_turfs()
	return list()

/mob/living/simple_animal/seen_cult_turfs()
	return seen_turfs_in_range(src, 1)

/mob/living/simple_animal/shade/narsie/seen_cult_turfs()
	return view(2, src)

/proc/seen_turfs_in_range(var/source, var/range)
	var/turf/pos = get_turf(source)
	return hear(range, pos)
