
//SLIPSPACE RUPTURE EFFECT//
/obj/effect/slipspace_rupture
	name = "slipspace rupture"
	icon = 'code/modules/halo/overmap/slipspace/slipspace_jump_effects.dmi'
	icon_state = "slipspace_effect"
	var/lifetime = 12

/obj/effect/slipspace_rupture/New()
	. = ..()
	spawn(lifetime)
		qdel(src)
