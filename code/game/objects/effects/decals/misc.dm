/obj/effect/decal/point
	name = "arrow"
	desc = "It's an arrow hanging in mid-air. There may be a wizard about."
	icon = 'icons/mob/screen1.dmi'
	icon_state = "arrow"
	layer = POINTER_LAYER
	anchored = TRUE
	mouse_opacity = 0

/obj/effect/decal/point/Initialize()
	. = ..()
	addtimer(CALLBACK(null, /proc/qdel, src), 2 SECONDS)

// Used for spray that you spray at walls, tables, hydrovats etc
/obj/effect/decal/spraystill
	density = FALSE
	anchored = TRUE
	layer = PROJECTILE_LAYER
