/obj/structure/handrail
	name = "handrail"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "handrail"
	desc = "A safety railing with buckles to secure yourself to when floor isn't stable enough."
	density = FALSE
	anchored = TRUE
	can_buckle = 1

/obj/structure/handrail/buckle_mob(mob/living/M)
	. = ..()
	if(.)
		playsound(src, 'sound/effects/buckle.ogg', 20)
