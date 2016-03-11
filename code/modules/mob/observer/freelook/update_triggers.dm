//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

// TURFS

/proc/updateVisibility(atom/A, var/opacity_check = 1)
	if(ticker)
		for(var/datum/visualnet/VN in visual_nets)
			VN.updateVisibility(A, opacity_check)

/turf
	var/list/image/obfuscations = new()

/turf/drain_power()
	return -1

/turf/simulated/Destroy()
	updateVisibility(src)
	return ..()

/turf/simulated/New()
	..()
	updateVisibility(src)


// STRUCTURES

/obj/structure/Destroy()
	updateVisibility(src)
	return ..()

/obj/structure/New()
	..()
	updateVisibility(src)

// EFFECTS

/obj/effect/Destroy()
	updateVisibility(src)
	return ..()

/obj/effect/New()
	..()
	updateVisibility(src)

// DOORS

// Simply updates the visibility of the area when it opens/closes/destroyed.
/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..(need_rebuild)
	// Glass door glass = 1
	// don't check then?
	if(!glass)
		updateVisibility(src, 0)