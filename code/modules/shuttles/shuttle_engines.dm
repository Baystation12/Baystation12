/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "1"
	density = 1
	opacity = 0
	anchored = 1

/obj/structure/shuttle/window/CanPass(atom/movable/mover, turf/target, height, air_group)
		if(!height || air_group) return 0
		else return ..()

/obj/structure/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"
