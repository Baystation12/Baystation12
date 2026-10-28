/obj/cosmic_cult/vfx/ability_shunt
	icon = 'icons/coscult/ability-shunt.dmi'
	icon_state = "vfx"
	pixel_x = -16
	pixel_y = -16
	duration = 15
	layer = ABOVE_HUMAN_LAYER

/obj/cosmic_cult/light_fx/ability_shunt
	time_in = 8
	time_out = 8

/proc/cosmic_cult_shunt_vfx(atom/target)
	playsound(target.loc, 'sound/coscult/ability-shunt.ogg', 75, FALSE)
	new /obj/cosmic_cult/vfx/ability_shunt(target.loc)
	new /obj/cosmic_cult/light_fx/ability_shunt(target.loc)
