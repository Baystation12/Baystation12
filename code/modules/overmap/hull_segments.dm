
/obj/effect/hull_segment
	name = "Hull Segment"
	desc = "A critical segment of the ship's superstructure. Destruction of this tile will lead to a loss of ship superstructure strength."
	icon = 'code/modules/halo/overmap/hull_segments.dmi'
	icon_state = "hull_segment_marker"
	layer = ABOVE_WINDOW_LAYER
	invisibility = 0
	anchored = 1
	density = 0
	alpha = 64

	var/segment_strength = 1 //How important is this segment of the hull?

/obj/effect/hull_segment/Initialize()
	. = ..()
	var/obj/effect/overmap/om_obj = map_sectors["[z]"]
	if(om_obj)
		om_obj.hull_segments += src

/obj/effect/hull_segment/examine(var/mob/examiner)
	. = ..()
	var/segment_destroyed = is_segment_destroyed()
	to_chat(examiner,"<span class = 'notice'>This segment of the superstructure is [segment_destroyed ? "destroyed":"intact"].</span>")

/obj/effect/hull_segment/proc/is_segment_destroyed()
	if(istype(loc,/turf/simulated/wall) || istype(loc,/turf/unsimulated/wall))
		return 0
	return 1
