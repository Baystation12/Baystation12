#define EXPLOSION_RATIO_DEVASTATION 1
#define EXPLOSION_RATIO_HEAVY 2
#define EXPLOSION_RATIO_LIGHT 4


/proc/explosion(turf/epicenter, range, max_power = EX_ACT_DEVASTATING, adminlog = 1, z_transfer = UP|DOWN, shaped, turf_breaker)
	set waitfor = FALSE

	var/multi_z_scalar = 0.35
	UNLINT(src = null)	//so we don't abort once src is deleted
	epicenter = get_turf(epicenter)
	if(!epicenter) return

	/// Range, in tiles, of `EX_ACT_DEVASTATING` damage.
	var/devastation_range = 0
	/// Range, in tiles, of `EX_ACT_HEAVY` damage.
	var/heavy_impact_range = 0
	/// Range, in tiles, of `EX_ACT_LIGHT` damage.
	var/light_impact_range = 0
	/// Ratio multiplier based on `max_power` and `range` used to determine the above three range values.
	var/explosion_ratio = 0

	switch (max_power)
		if (EX_ACT_DEVASTATING)
			explosion_ratio = range / (EXPLOSION_RATIO_DEVASTATION + EXPLOSION_RATIO_HEAVY + EXPLOSION_RATIO_LIGHT)
			devastation_range = round(explosion_ratio * EXPLOSION_RATIO_DEVASTATION)
			heavy_impact_range = round(explosion_ratio * EXPLOSION_RATIO_HEAVY)
			light_impact_range = round(explosion_ratio * EXPLOSION_RATIO_LIGHT)
		if (EX_ACT_HEAVY)
			explosion_ratio = range / (EXPLOSION_RATIO_HEAVY + EXPLOSION_RATIO_LIGHT)
			heavy_impact_range = round(explosion_ratio * EXPLOSION_RATIO_HEAVY)
			light_impact_range = round(explosion_ratio * EXPLOSION_RATIO_LIGHT)
		if (EX_ACT_LIGHT)
			explosion_ratio = range
			light_impact_range = range

	// Handles recursive propagation of explosions.
	if(z_transfer)
		var/adj_dev   = max(0, (multi_z_scalar * devastation_range) - (shaped ? 2 : 0) )
		var/adj_heavy = max(0, (multi_z_scalar * heavy_impact_range) - (shaped ? 2 : 0) )
		var/adj_light = max(0, (multi_z_scalar * light_impact_range) - (shaped ? 2 : 0) )
		var/adj_range = adj_dev + adj_heavy + adj_light

		var/adj_max_power
		if (adj_dev)
			adj_max_power = EX_ACT_DEVASTATING
		else if (adj_heavy)
			adj_max_power = EX_ACT_HEAVY
		else
			adj_max_power = EX_ACT_LIGHT

		if(adj_dev > 0 || adj_heavy > 0)
			if(HasAbove(epicenter.z) && z_transfer & UP)
				explosion(GetAbove(epicenter), adj_range, adj_max_power, 0, UP, shaped)
			if(HasBelow(epicenter.z) && z_transfer & DOWN)
				explosion(GetBelow(epicenter), adj_range, adj_max_power, 0, DOWN, shaped)

	var/max_range = max(devastation_range, heavy_impact_range, light_impact_range)

	// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
	// Stereo users will also hear the direction of the explosion!
	// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
	// 3/7/14 will calculate to 80 + 35
	var/far_dist = 0
	far_dist += heavy_impact_range * 5
	far_dist += devastation_range * 20
	var/frequency = get_rand_frequency()
	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= round(max_range + world.view - 2, 1))
				M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
			else if(dist <= far_dist)
				var/far_volume = clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
				far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
				M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)

	if(adminlog)
		log_and_message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", null, epicenter)
	var/approximate_intensity = (devastation_range * 3) + (heavy_impact_range * 2) + light_impact_range
	// Large enough explosion. For performance reasons, powernets will be rebuilt manually
	if(!GLOB.defer_powernet_rebuild && (approximate_intensity > 25))
		GLOB.defer_powernet_rebuild = 1

	if(heavy_impact_range > 1)
		var/datum/effect/explosion/E = new
		E.set_up(epicenter)
		E.start()

	var/power = devastation_range * 2 + heavy_impact_range + light_impact_range //The ranges add up, ie light 14 includes both heavy 7 and devestation 3. So this calculation means devestation counts for 4, heavy for 2 and light for 1 power, giving us a cap of 27 power.
	explosion_rec(epicenter, power, shaped)

	sleep(8)

	return 1



/proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(EX_ACT_HEAVY)


#undef EXPLOSION_RATIO_DEVASTATION
#undef EXPLOSION_RATIO_HEAVY
#undef EXPLOSION_RATIO_LIGHT
