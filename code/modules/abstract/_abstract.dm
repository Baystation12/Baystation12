// TODO: consider converting to /atom/movable or some other form that will
// hel with removing abstract objects from contents checks and maptick.
/obj/abstract
	name =          ""
	icon =          'icons/effects/landmarks.dmi'
	icon_state =    "x2"
	mouse_opacity = 0
	alpha =         0
	simulated =     FALSE
	density =       FALSE
	opacity =       FALSE
	anchored =      TRUE
	unacidable =    TRUE
	invisibility =  INVISIBILITY_MAXIMUM+1

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()

/obj/abstract/ex_act()
	SHOULD_CALL_PARENT(FALSE)
	return
