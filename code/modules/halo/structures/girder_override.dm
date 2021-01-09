
/obj/structure/girder/CanPass(var/mob/living/m, turf/T, height=1.5, air_group = 0)
	. = ..()
	if(istype(m) && density)
		if(m.elevation != elevation)
			. = 0