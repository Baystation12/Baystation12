/obj/item/weapon/grenade/proc/detonate()
	var/turf/T = get_turf(src)


//We check this first to skip all other effects, as they do not apply to spawner grenades. We don't check for utility grenades, however, as they override their detonate()
	if(trait_flags & SPAWNER)
	for(trait_power; trait_power = 0, trait_power--)
	new pick(trait_payload_1,trait_payload_2,trait_payload_3)(T)

//Actual asplode effects here.
	if(trait_flags & EXPLOSIVE)


	if(trait_flags & FRAGMENTING)


	if(trait_flags & CONCUSSIVE)


	if(trait_flags & INCENDIARY)


	if(trait_flags & TAZE)


	if(trait_flags & TESLA)


	if(trait_flags & GRAV)


	if(trait_flags & LASER)


	if(trait_flags & SCATTER)


	if(trait_flags & STING)

//Tactical effects.


