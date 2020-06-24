/obj/item/weapon/material/disrupts_psionics()
	return (material && material.is_psi_null()) ? src : FALSE

/obj/item/weapon/material/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(health >= 0 && . > 0 && disrupts_psionics())
		health -= .
		. = max(0, -(health))
		check_health(consumed = TRUE)

/obj/item/weapon/material/shard/nullglass/New(var/newloc)
	..(newloc, MATERIAL_NULLGLASS)
