/obj/cosmic_cult/vfx/ability_glare
	icon = 'icons/coscult/ability-glare.dmi'
	icon_state = "vfx"
	pixel_x = -32
	pixel_y = -32
	duration = 20

	plane = HUD_PLANE
	layer = UNDER_HUD_LAYER

/obj/cosmic_cult/light_fx/ability_glare
	time_in = 6
	time_out = 6

/proc/cosmic_cult_glare_vfx(atom/target)
	playsound(target.loc, 'sound/coscult/ability-glare.ogg', 75, FALSE)
	new /obj/cosmic_cult/vfx/ability_glare(target.loc)
	new /obj/cosmic_cult/light_fx/ability_glare(target.loc)
