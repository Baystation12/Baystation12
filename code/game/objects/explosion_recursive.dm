



var/global/list/explosion_turfs = list()

var/global/explosion_in_progress = 0


/proc/explosion_rec(turf/epicenter, power, shaped)
	var/loopbreak = 0
	while(explosion_in_progress)
		if(loopbreak >= 15) return
		sleep(10)
		loopbreak++

	if(power <= 0) return
	epicenter = get_turf(epicenter)
	if(!epicenter) return

	explosion_in_progress = 1
	explosion_turfs = list()

	explosion_turfs[epicenter] = power

	//This steap handles the gathering of turfs which will be ex_act() -ed in the next step. It also ensures each turf gets the maximum possible amount of power dealt to it.
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(epicenter, direction)
		var/adj_power = power - epicenter.get_explosion_resistance()
		if(shaped)
			if (shaped == direction)
				adj_power *= 3
			else if (shaped == reverse_direction(direction))
				adj_power *= 0.10
			else
				adj_power *= 0.45

		T.explosion_spread(adj_power, direction)

	//This step applies the ex_act effects for the explosion, as planned in the previous step.
	for(var/spot in explosion_turfs)
		var/turf/T = spot
		if(explosion_turfs[T] <= 0) continue
		if(!T) continue

		//Wow severity looks confusing to calculate... Fret not, I didn't leave you with any additional instructions or help. (just kidding, see the line under the calculation)
		var/severity = 4 - round(max(min( 3, ((explosion_turfs[T] - T.get_explosion_resistance()) / (max(3,(power/3)))) ) ,1), 1)								//sanity			effective power on tile				divided by either 3 or one third the total explosion power
								//															One third because there are three power levels and I
								//															want each one to take up a third of the crater
		var/x = T.x
		var/y = T.y
		var/z = T.z
		T.ex_act(severity)
		if(!T)
			T = locate(x,y,z)

		var/throw_target = get_edge_target_turf(T, get_dir(epicenter,T))
		for(var/atom_movable in T.contents)
			var/atom/movable/AM = atom_movable
			if(AM && AM.simulated && !T.protects_atom(AM))
				AM.ex_act(severity)
				if(AM && !AM.anchored)
					addtimer(CALLBACK(AM, /atom/movable/.proc/throw_at, throw_target, 9/severity, 9/severity), 0)

	explosion_turfs.Cut()
	explosion_in_progress = 0


//Code-wise, a safe value for power is something up to ~25 or ~30.. This does quite a bit of damage to the station.
//direction is the direction that the spread took to come to this tile. So it is pointing in the main blast direction - meaning where this tile should spread most of it's force.
/turf/proc/explosion_spread(power, direction)
	if(power <= 0)
		return

	if(explosion_turfs[src] >= power)
		return //The turf already sustained and spread a power greated than what we are dealing with. No point spreading again.
	explosion_turfs[src] = power
/*
	sleep(2)
	var/obj/effect/debugging/M = locate() in src
	if (!M)
		M = new(src, power, direction)
	M.maptext = "[power] vs [src.get_explosion_resistance()]"
	if(power > 10)
		M.color = "#cccc00"
	if(power > 20)
		M.color = "#ffcc00"
*/
	var/spread_power = power - src.get_explosion_resistance() //This is the amount of power that will be spread to the tile in the direction of the blast

	var/turf/T = get_step(src, direction)
	if(T)
		T.explosion_spread(spread_power, direction)
	T = get_step(src, turn(direction,90))
	if(T)
		T.explosion_spread(spread_power, turn(direction,90))
	T = get_step(src, turn(direction,-90))
	if(T)
		T.explosion_spread(spread_power, turn(direction,90))

/turf/unsimulated/explosion_spread(power)
	return //So it doesn't get to the parent proc, which simulates explosions

/atom/var/explosion_resistance
/atom/proc/get_explosion_resistance()
	if(simulated)
		return explosion_resistance

/turf/get_explosion_resistance()
	. = ..()
	for(var/obj/O in src)
		. += O.get_explosion_resistance()

/turf/space/explosion_resistance = 3

/turf/simulated/floor/get_explosion_resistance()
	. = ..()
	if(is_below_sound_pressure(src))
		. *= 3

/turf/simulated/floor/explosion_resistance = 1

/turf/simulated/mineral/explosion_resistance = 2

/turf/simulated/shuttle/wall/explosion_resistance = 10

/turf/simulated/wall/explosion_resistance = 10

/obj/machinery/door/get_explosion_resistance()
	if(!density)
		return 0
	else
		return ..()
