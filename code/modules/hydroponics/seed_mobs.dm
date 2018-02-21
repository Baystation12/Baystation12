// The following procs are used to grab players for mobs produced by a seed (mostly for dionaea).
/datum/seed/proc/handle_living_product(var/mob/living/host)
	if(!host || !istype(host)) return
	SSghosttraps.RequestCandidates(/decl/ghost_trap/plant, "Someone is harvesting \a [display_name].", host, name)
