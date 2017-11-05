/obj/effect/decal/warning_stripes
	icon = 'icons/effects/warning_stripes.dmi'
	var/icon_root = ""

/obj/effect/decal/warning_stripes/New()
	. = ..()
	var/turf/T=get_turf(src)
	var/image/I=image(icon, icon_state = icon_root + icon_state, dir = dir)
	I.color=color
	I.plane = ABOVE_TURF_PLANE
	I.layer = DECAL_LAYER
	T.overlays += I
	qdel(src)

/obj/effect/decal/warning_stripes/orange
	icon_root = "O"