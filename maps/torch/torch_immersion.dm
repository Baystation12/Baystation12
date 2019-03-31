//Turns map so fore is located in the top of the map, to further enhance spatial immersion
/mob/forceMove()
	var/old_z = z
	. = ..()
	if(. && client && z != old_z)
		client.align_to_ship()
		
/client/New()
	..()
	spawn(2)
		align_to_ship()

/client/proc/align_to_ship()
	var/ndir = NORTH
	if(GLOB.using_map.use_overmap && mob)
		var/obj/effect/overmap/ship/S = map_sectors["[get_z(mob)]"]
		if(istype(S))
			ndir = S.fore_dir
	dir = ndir

