/obj/cosmic_cult/vfx/monument_influence
	icon = 'icons/coscult/monument-vfx.dmi'
	icon_state = "vfx-1"
	pixel_x = -32 + -1
	pixel_y = -32 + 56
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER

/proc/cosmic_cult_monument_influence(atom/target)
	new /obj/cosmic_cult/vfx/monument_influence(target.loc)
	playsound(target.loc, 'sound/coscult/monument-gacha.ogg', 75, FALSE)
