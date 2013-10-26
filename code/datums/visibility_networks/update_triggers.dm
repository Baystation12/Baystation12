//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

// TURFS

/turf
	var/image/obscured

/turf/proc/visibilityChanged()
	if(ticker)
		updateVisibilityNetworks(src)

/turf/simulated/Del()
	visibilityChanged()
	..()

/turf/simulated/New()
	..()
	visibilityChanged()



// STRUCTURES

/obj/structure/Del()
	if(ticker)
		updateVisibilityNetworks(src)
	..()

/obj/structure/New()
	..()
	if(ticker)
		updateVisibilityNetworks(src)

// EFFECTS

/obj/effect/Del()
	if(ticker)
		updateVisibilityNetworks(src)
	..()

/obj/effect/New()
	..()
	if(ticker)
		updateVisibilityNetworks(src)


// DOORS

// Simply updates the visibility of the area when it opens/closes/destroyed.
/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..(need_rebuild)
	// Glass door glass = 1
	// don't check then?
	if(!glass)
		updateVisibilityNetworks(src,0)