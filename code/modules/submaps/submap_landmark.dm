/obj/submap_landmark
	icon = 'icons/misc/mark.dmi'
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE
	simulated = FALSE
	density = FALSE
	opacity = FALSE


/obj/submap_landmark/joinable_submap
	icon_state = "x4"
	var/archetype
	var/submap_datum_type = /datum/submap


/obj/submap_landmark/joinable_submap/Initialize(mapload)
	. = ..(mapload)
	var/singleton/submap_archetype = GET_SINGLETON(archetype)
	if(!SSmapping.submaps[name] && submap_archetype)
		var/datum/submap/submap = new submap_datum_type(z)
		submap.name = name
		submap.setup_submap(submap_archetype)
	else
		if(SSmapping.submaps[name])
			to_world_log( "Submap error - mapped landmark is duplicate of existing.")
		else
			to_world_log( "Submap error - mapped landmark had invalid archetype.")
	return INITIALIZE_HINT_QDEL


/obj/submap_landmark/spawnpoint
	icon_state = "x3"


/obj/submap_landmark/spawnpoint/survivor
	name = "Survivor"
