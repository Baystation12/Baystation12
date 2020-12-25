//TODO: Flash range does nothing currently
//Directional is used to specify an explosion direction. Directional blast offset determines how much to offset the epicenter of the cone of the explosion. Directional cone spread step determines the amount of steps before the cone increases in spread
proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, shaped,guaranteed_damage = 0,guaranteed_damage_range = 0,effect_datum_override = null,directional,directional_blast_offset = 0,directional_cone_spread_step = 2)
	var/multi_z_scalar = 0.35
	src = null	//so we don't abort once src is deleted
	spawn(0)
		var/start = world.timeofday
		epicenter = get_turf(epicenter)
		if(!epicenter) return

		// Handles recursive propagation of explosions.
		if(z_transfer)
			var/adj_dev   = max(0, (multi_z_scalar * devastation_range) - (shaped ? 2 : 0) )
			var/adj_heavy = max(0, (multi_z_scalar * heavy_impact_range) - (shaped ? 2 : 0) )
			var/adj_light = max(0, (multi_z_scalar * light_impact_range) - (shaped ? 2 : 0) )
			var/adj_flash = max(0, (multi_z_scalar * flash_range) - (shaped ? 2 : 0) )


			if(adj_dev > 0 || adj_heavy > 0)
				if(HasAbove(epicenter.z) && z_transfer & UP)
					explosion(GetAbove(epicenter), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, UP, shaped)
				if(HasBelow(epicenter.z) && z_transfer & DOWN)
					explosion(GetBelow(epicenter), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, DOWN, shaped)

		var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)

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
					var/far_volume = Clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
					far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)

		if(adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

		var/approximate_intensity = (max(0,devastation_range) * 3) + (max(0,heavy_impact_range) * 2) + max(0,light_impact_range)
		// Large enough explosion. For performance reasons, powernets will be rebuilt manually
		if(!defer_powernet_rebuild && (approximate_intensity > 25))
			defer_powernet_rebuild = 1

		if(approximate_intensity >= 2)
			if(isnull(effect_datum_override))
				if(approximate_intensity >= 4)
					effect_datum_override = /datum/effect/system/explosion/has_smoke
				else
					effect_datum_override = /datum/effect/system/explosion
			var/datum/effect/system/explosion/E = new effect_datum_override()
			E.set_up(epicenter)
			E.start()

		if(config.use_recursive_explosions)
			var/power = devastation_range * 2 + heavy_impact_range + light_impact_range //The ranges add up, ie light 14 includes both heavy 7 and devestation 3. So this calculation means devestation counts for 4, heavy for 2 and light for 1 power, giving us a cap of 27 power.
			explosion_rec(epicenter, power, shaped)
		else
			var/list/exploded = list()
			var/list/area_search = list()
			if(directional)
				//First we need to move our epicenter point to create the cone from
				var/turf/epi = epicenter
				if(directional_blast_offset != 0)
					var/dir_move = directional
					if(directional_blast_offset < 0)
						dir_move = turn(directional,180)
					var/offset_moves_left = abs(directional_blast_offset)
					if(offset_moves_left > 0)
						for(var/i = 1 to offset_moves_left)
							epi = get_step(epi,dir_move)
					epicenter = epi
				//Now we create the cone, facing the original cone direction
				var/turf/last_turf = epi
				var/spread_left = turn(directional,-90)
				var/spread_right = turn(directional,90)
				var/amt_spread = 0
				area_search += epi
				for(var/i = 1 to max_range)
					//For each vertical step of the cone from the epicenter
					//If we need to, spread outwards to the sides by the required amount
					if(i%directional_cone_spread_step==0)
						amt_spread = i/directional_cone_spread_step
					if(amt_spread > 0)
						var/turf/last_spread_turf = last_turf
						var/spread_dir_using = spread_left
						for(var/j = 1 to amt_spread*2)
							if(j == amt_spread+1)
								spread_dir_using = spread_right
								last_spread_turf = last_turf
							last_spread_turf = get_step(last_spread_turf,spread_dir_using)
							area_search += last_spread_turf

					last_turf = get_step(last_turf,directional)
					area_search += last_turf
			else
				area_search = trange(max_range, epicenter)

			var/x0 = epicenter.x
			var/y0 = epicenter.y
			var/z0 = epicenter.z

			for(var/turf/T in area_search)
				var/dist = sqrt((T.x - x0)**2 + (T.y - y0)**2)

				if(dist < devastation_range)		dist = 1
				else if(dist < heavy_impact_range)	dist = 2
				else if(dist < light_impact_range)	dist = 3
				else								continue

				T.ex_act(dist,epicenter)
				if(!T)
					T = locate(x0,y0,z0)
				//This method means an item can be hit multiple times by a single explosion.
				for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
					if(atom_movable in exploded)
						continue
					var/atom/movable/AM = atom_movable
					if(AM && AM.simulated && !T.protects_atom(AM))
						AM.ex_act(dist,epicenter)
						exploded += AM
		if(guaranteed_damage_range > 0)
			for(var/mob/living/m in range(guaranteed_damage_range,epicenter))
				var/mob/living/carbon/human/h = m
				if(istype(h))
					if(h.check_shields(guaranteed_damage*2, null, null, null, "the explosion"))
						m.apply_damage(guaranteed_damage/2,BRUTE,,m.run_armor_check(null,"bomb"))
						m.apply_damage(guaranteed_damage/2,BURN,,m.run_armor_check(null,"bomb"))
				else
					m.apply_damage(guaranteed_damage/2,BRUTE,,m.run_armor_check(null,"bomb"))
					m.apply_damage(guaranteed_damage/2,BURN,,m.run_armor_check(null,"bomb"))

		var/took = (world.timeofday-start)/10
		//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
		if(Debug2) to_world_log("## DEBUG: Explosion([epicenter.x],[epicenter.y],[epicenter.z])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds.")

		sleep(8)

	return 1



proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(2)

