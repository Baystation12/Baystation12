/obj/item/material/disrupts_psionics()
	return (material && material.is_psi_null()) ? src : FALSE

/obj/item/material/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(is_alive() && . > 0 && disrupts_psionics())
		damage_health(.)
		. = max(0, -(get_current_health()))

/obj/item/material/shard/nullglass/New(var/newloc)
	..(newloc, MATERIAL_NULLGLASS)
