/obj/cosmic_cult/vfx/corruption
	icon = 'icons/coscult/tile-spawn.dmi'
	icon_state = "vfx"
	duration = 5
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER

/proc/cosmic_cult_tile_spawn(loc)
	new /obj/cosmic_cult/vfx/corruption(loc)
