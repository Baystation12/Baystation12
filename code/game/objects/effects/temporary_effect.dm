//A temporary effect that does not DO anything except look pretty.
/obj/temporary
	anchored = TRUE
	unacidable = TRUE
	mouse_opacity = 0
	density = FALSE
	layer = ABOVE_HUMAN_LAYER

/obj/temporary/Initialize(mapload, duration = 30, _icon = 'icons/effects/effects.dmi', _state)
	. = ..()
	icon = _icon
	icon_state = _state
	QDEL_IN(src, duration)
