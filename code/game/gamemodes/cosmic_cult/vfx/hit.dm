/obj/cosmic_cult/vfx/hit
	icon = 'icons/coscult/attack-weapons.dmi'
	icon_state = "vfx"
	duration = 6
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER

/obj/cosmic_cult/light_fx/hit
	time_in = 2
	time_out = 2

/proc/cosmic_cult_hit_vfx(atom/target)
	new /obj/cosmic_cult/vfx/hit(get_turf(target))
	new /obj/cosmic_cult/light_fx/hit(get_turf(target))
