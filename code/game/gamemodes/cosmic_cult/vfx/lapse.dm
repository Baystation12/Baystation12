/obj/cosmic_cult/vfx/ability_lapse
	icon = 'icons/coscult/ability-lapse.dmi'
	icon_state = "vfx"
	pixel_x = -16
	pixel_y = -16
	layer = ABOVE_HUMAN_LAYER

/obj/cosmic_cult/light_fx/ability_lapse
	time_in = 8
	time_out = 8

/proc/cosmic_cult_lapse_vfx(atom/target)
	new /obj/cosmic_cult/vfx/ability_lapse(target.loc)
	new /obj/cosmic_cult/light_fx/ability_lapse(target.loc)
	playsound(target.loc, 'sound/coscult/ability-lapse.ogg', 75, FALSE)
