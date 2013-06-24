/obj/effect/decal/warning_stripes
	icon = 'icons/effects/warning_stripes.dmi'
	layer = 2

/obj/effect/decal/warning_stripes/New()
	. = ..()

	loc.overlays += src
	del src