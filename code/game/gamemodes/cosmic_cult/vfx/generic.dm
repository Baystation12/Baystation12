/obj/cosmic_cult/vfx/generic
	icon = 'icons/coscult/effect-generic.dmi'
	icon_state = "vfx"
	duration = 20
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	pixel_x = -16
	pixel_y = -16

/obj/cosmic_cult/light_fx/generic
	time_in = 10
	time_out = 10

/proc/cosmic_cult_ingress_vfx(atom/target)
	playsound(target.loc, 'sound/coscult/ability-ingress.ogg', 75, FALSE)
	new /obj/cosmic_cult/vfx/generic(get_turf(target))
	new /obj/cosmic_cult/light_fx/generic(get_turf(target))
