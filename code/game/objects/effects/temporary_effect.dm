//A temporary effect that does not DO anything except look pretty.
/obj/effect/temporary
	anchored = 1
	unacidable = 1
	mouse_opacity = 0
	density = 0
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/effect/temporary/Initialize(var/mapload, var/del_in, var/_icon = 'icons/effects/effects.dmi', var/_state, var/duration = 30)
	. = ..()
	icon = _icon
	icon_state = _state
	QDEL_IN(src, del_in)
