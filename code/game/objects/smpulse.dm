/proc/supermatter_delamination(turf/epicenter, devastation_range = 9, smlevel = 1, adminlog = 1, z_transfer = UP|DOWN, shaped)
	var/multi_z_scalar = 0.35
	var/start = world.timeofday
	epicenter = get_turf(epicenter)
	if(!epicenter) return
	if(z_transfer)
		var/adj_dev   = max(0, (multi_z_scalar * devastation_range) - (shaped ? 2 : 0))

		if(adj_dev > 0)
			if(HasAbove(epicenter.z) && z_transfer & UP)
				supermatter_delamination(GetAbove(epicenter), round(adj_dev), smlevel, 0, UP, shaped)
			if(HasBelow(epicenter.z) && z_transfer & DOWN)
				supermatter_delamination(GetBelow(epicenter), round(adj_dev), smlevel, 0, DOWN, shaped)
	var/far_dist = 0
	far_dist += devastation_range * 20
	var/frequency = get_rand_frequency()
	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			var/far_volume = Clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
			far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
			M.playsound_local(epicenter, 'sound/effects/cascade.ogg', far_volume, 1, frequency, falloff = 5)

	if(adminlog)
		message_admins("Supermatter Delamination with size ([devastation_range], level [smlevel]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
		log_game("Supermatter Delamination with size ([devastation_range], level [smlevel]) in area [epicenter.loc.name] ")
	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/z0 = epicenter.z
	for(var/turf/T in trange(devastation_range, epicenter))
		if(istype(T, /turf/space) || istype(T, /turf/simulated/open))
			continue

		var/dist = approx_dist(T.x, T.y)
		var/crystal_spawn_chance = (devastation_range - dist) / (devastation_range) * 100
		var/spawned = FALSE
		if(prob(crystal_spawn_chance) && istype(T, /turf/simulated))
			for(var/obj/structure/S in T)
				if(istype(S, /obj/structure/metaphoron))
					spawned = TRUE
			if(!spawned && istype(T, /turf/simulated/wall))
				new /obj/structure/metaphoron/wall(T, smlevel)
				spawned = TRUE
			else if(!spawned)
				new /obj/structure/metaphoron(T, smlevel)
				spawned = TRUE
	var/took = (world.timeofday-start)/10
	if(Debug2)
		log_debug("## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],level [smlevel]): Took [took] seconds.")
	sleep(8)
	return 1

proc/approx_dist(var/x, var/y)
	x = abs(x)
	y = abs(y)
	var/mi = min(x,y)
	var/ma = max(x,y)

	var/approx = ((ma * 1007) + (mi * 441)) / 1024
	if(ma < (mi * 16))
		approx -= (ma * 40/1024)

	return approx