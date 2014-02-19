connection_edge
	var/zone/A

	var/list/connecting_turfs = list()

	var/coefficient = 0
	var/id

	New()
		CRASH("Cannot make connection edge without specifications.")

	proc/add_connection(connection/c)
		coefficient++
		//world << "Connection added. Coefficient: [coefficient]"

	proc/remove_connection(connection/c)
		//world << "Connection removed. Coefficient: [coefficient-1]"
		coefficient--
		if(coefficient <= 0)
			erase()

	proc/contains_zone(zone/Z)

	proc/erase()
		air_master.remove_edge(src)
		//world << "Erased."

	proc/tick()

	proc/flow(list/movable, differential, repelled)
		for(var/atom/movable/M in movable)

			//If they're already being tossed, don't do it again.
			if(M.last_airflow > world.time - vsc.airflow_delay) continue
			if(M.airflow_speed) continue

			//Check for knocking people over
			if(ismob(M) && differential > vsc.airflow_stun_pressure)
				if(M:status_flags & GODMODE) continue
				M:airflow_stun()

			if(M.check_airflow_movable(differential))
				//Check for things that are in range of the midpoint turfs.
				var/list/close_turfs = list()
				for(var/turf/U in connecting_turfs)
					if(get_dist(M,U) < world.view) close_turfs += U
				if(!close_turfs.len) continue

				M.airflow_dest = pick(close_turfs) //Pick a random midpoint to fly towards.

				if(repelled) spawn if(M) M.RepelAirflowDest(differential/5)
				else spawn if(M) M.GotoAirflowDest(differential/10)


connection_edge/zone

	var/zone/B
	var/direct = 0

	New(zone/A, zone/B)

		src.A = A
		src.B = B
		A.edges.Add(src)
		B.edges.Add(src)
		//id = edge_id(A,B)
		//world << "New edge between [A] and [B]"

	add_connection(connection/c)
		. = ..()
		connecting_turfs.Add(c.A)
		if(c.direct()) direct++

	remove_connection(connection/c)
		connecting_turfs.Remove(c.A)
		if(c.direct()) direct--
		. = ..()

	contains_zone(zone/Z)
		return A == Z || B == Z

	erase()
		A.edges.Remove(src)
		B.edges.Remove(src)
		. = ..()

	tick()
		//world << "[id]: Tick [air_master.current_cycle]: \..."
		if(direct)
			if(air_master.equivalent_pressure(A, B))
				//world << "merged."
				erase()
				air_master.merge(A, B)
				//world << "zones merged."
				return

		//air_master.equalize(A, B)
		ShareRatio(A.air,B.air,coefficient)
		air_master.mark_zone_update(A)
		air_master.mark_zone_update(B)
		//world << "equalized."

		var/differential = A.air.return_pressure() - B.air.return_pressure()
		if(abs(differential) < vsc.airflow_lightest_pressure) return

		var/list/attracted
		var/list/repelled
		if(differential > 0)
			attracted = A.movables()
			repelled = B.movables()
		else
			attracted = B.movables()
			repelled = A.movables()

		flow(attracted, abs(differential), 0)
		flow(repelled, abs(differential), 1)

connection_edge/unsimulated
	var/turf/B
	var/datum/gas_mixture/air

	New(zone/A, turf/B)
		src.A = A
		src.B = B
		A.edges.Add(src)
		air = B.return_air()
		//id = 52*A.id
		//world << "New edge from [A.id] to [B]."

	add_connection(connection/c)
		. = ..()
		connecting_turfs.Add(c.B)

	remove_connection(connection/c)
		connecting_turfs.Remove(c.B)
		. = ..()

	contains_zone(zone/Z)
		return A == Z

	tick()
		//world << "[id]: Tick [air_master.current_cycle]: To [B]!"
		//A.air.mimic(B, coefficient)
		ShareSpace(A.air,air)
		air_master.mark_zone_update(A)

		var/differential = A.air.return_pressure() - air.return_pressure()
		if(abs(differential) < vsc.airflow_lightest_pressure) return

		var/list/attracted = A.movables()
		flow(attracted, abs(differential), differential < 0)


//proc/edge_id(zone/A, zone/B)
//	return 52 * A.id + B.id

var/list/sharing_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)

proc/ShareRatio(datum/gas_mixture/A, datum/gas_mixture/B, connecting_tiles)
	//Shares a specific ratio of gas between mixtures using simple weighted averages.
	var
		//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD
		ratio = sharing_lookup_table[6]
		//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD

		size = max(1,A.group_multiplier)
		share_size = max(1,B.group_multiplier)

		full_oxy = A.oxygen * size
		full_nitro = A.nitrogen * size
		full_co2 = A.carbon_dioxide * size
		full_plasma = A.toxins * size

		full_heat_capacity = A.heat_capacity() * size

		s_full_oxy = B.oxygen * share_size
		s_full_nitro = B.nitrogen * share_size
		s_full_co2 = B.carbon_dioxide * share_size
		s_full_plasma = B.toxins * share_size

		s_full_heat_capacity = B.heat_capacity() * share_size

		oxy_avg = (full_oxy + s_full_oxy) / (size + share_size)
		nit_avg = (full_nitro + s_full_nitro) / (size + share_size)
		co2_avg = (full_co2 + s_full_co2) / (size + share_size)
		plasma_avg = (full_plasma + s_full_plasma) / (size + share_size)

		temp_avg = (A.temperature * full_heat_capacity + B.temperature * s_full_heat_capacity) / (full_heat_capacity + s_full_heat_capacity)

	//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD
	if(sharing_lookup_table.len >= connecting_tiles) //6 or more interconnecting tiles will max at 42% of air moved per tick.
		ratio = sharing_lookup_table[connecting_tiles]
	//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD

	A.oxygen = max(0, (A.oxygen - oxy_avg) * (1-ratio) + oxy_avg )
	A.nitrogen = max(0, (A.nitrogen - nit_avg) * (1-ratio) + nit_avg )
	A.carbon_dioxide = max(0, (A.carbon_dioxide - co2_avg) * (1-ratio) + co2_avg )
	A.toxins = max(0, (A.toxins - plasma_avg) * (1-ratio) + plasma_avg )

	A.temperature = max(0, (A.temperature - temp_avg) * (1-ratio) + temp_avg )

	B.oxygen = max(0, (B.oxygen - oxy_avg) * (1-ratio) + oxy_avg )
	B.nitrogen = max(0, (B.nitrogen - nit_avg) * (1-ratio) + nit_avg )
	B.carbon_dioxide = max(0, (B.carbon_dioxide - co2_avg) * (1-ratio) + co2_avg )
	B.toxins = max(0, (B.toxins - plasma_avg) * (1-ratio) + plasma_avg )

	B.temperature = max(0, (B.temperature - temp_avg) * (1-ratio) + temp_avg )

	for(var/datum/gas/G in A.trace_gases)
		var/datum/gas/H = locate(G.type) in B.trace_gases
		if(H)
			var/G_avg = (G.moles*size + H.moles*share_size) / (size+share_size)
			G.moles = (G.moles - G_avg) * (1-ratio) + G_avg

			H.moles = (H.moles - G_avg) * (1-ratio) + G_avg
		else
			H = new G.type
			B.trace_gases += H
			var/G_avg = (G.moles*size) / (size+share_size)
			G.moles = (G.moles - G_avg) * (1-ratio) + G_avg
			H.moles = (H.moles - G_avg) * (1-ratio) + G_avg

	for(var/datum/gas/G in B.trace_gases)
		var/datum/gas/H = locate(G.type) in A.trace_gases
		if(!H)
			H = new G.type
			A.trace_gases += H
			var/G_avg = (G.moles*size) / (size+share_size)
			G.moles = (G.moles - G_avg) * (1-ratio) + G_avg
			H.moles = (H.moles - G_avg) * (1-ratio) + G_avg

	A.update_values()
	B.update_values()

	if(A.compare(B)) return 1
	else return 0

proc/ShareSpace(datum/gas_mixture/A, list/unsimulated_tiles, dbg_output)
	//A modified version of ShareRatio for spacing gas at the same rate as if it were going into a large airless room.
	if(!unsimulated_tiles)
		return 0

	var
		unsim_oxygen = 0
		unsim_nitrogen = 0
		unsim_co2 = 0
		unsim_plasma = 0
		unsim_heat_capacity = 0
		unsim_temperature = 0

		size = max(1,A.group_multiplier)

	var/tileslen
	var/share_size

	if(istype(unsimulated_tiles, /datum/gas_mixture))
		var/datum/gas_mixture/avg_unsim = unsimulated_tiles
		unsim_oxygen = avg_unsim.oxygen
		unsim_co2 = avg_unsim.carbon_dioxide
		unsim_nitrogen = avg_unsim.nitrogen
		unsim_plasma = avg_unsim.toxins
		unsim_temperature = avg_unsim.temperature
		share_size = max(1, max(size + 3, 1) + avg_unsim.group_multiplier)
		tileslen = avg_unsim.group_multiplier

	else if(istype(unsimulated_tiles, /list))
		if(!unsimulated_tiles.len)
			return 0
		// We use the same size for the potentially single space tile
		// as we use for the entire room. Why is this?
		// Short answer: We do not want larger rooms to depressurize more
		// slowly than small rooms, preserving our good old "hollywood-style"
		// oh-shit effect when large rooms get breached, but still having small
		// rooms remain pressurized for long enough to make escape possible.
		share_size = max(1, max(size + 3, 1) + unsimulated_tiles.len)
		var/correction_ratio = share_size / unsimulated_tiles.len

		for(var/turf/T in unsimulated_tiles)
			unsim_oxygen += T.oxygen
			unsim_co2 += T.carbon_dioxide
			unsim_nitrogen += T.nitrogen
			unsim_plasma += T.toxins
			unsim_temperature += T.temperature/unsimulated_tiles.len

		//These values require adjustment in order to properly represent a room of the specified size.
		unsim_oxygen *= correction_ratio
		unsim_co2 *= correction_ratio
		unsim_nitrogen *= correction_ratio
		unsim_plasma *= correction_ratio
		tileslen = unsimulated_tiles.len

	else //invalid input type
		return 0

	unsim_heat_capacity = HEAT_CAPACITY_CALCULATION(unsim_oxygen, unsim_co2, unsim_nitrogen, unsim_plasma)

	var
		ratio = sharing_lookup_table[6]

		old_pressure = A.return_pressure()

		full_oxy = A.oxygen * size
		full_nitro = A.nitrogen * size
		full_co2 = A.carbon_dioxide * size
		full_plasma = A.toxins * size

		full_heat_capacity = A.heat_capacity() * size

		oxy_avg = (full_oxy + unsim_oxygen) / (size + share_size)
		nit_avg = (full_nitro + unsim_nitrogen) / (size + share_size)
		co2_avg = (full_co2 + unsim_co2) / (size + share_size)
		plasma_avg = (full_plasma + unsim_plasma) / (size + share_size)

		temp_avg = 0

	if((full_heat_capacity + unsim_heat_capacity) > 0)
		temp_avg = (A.temperature * full_heat_capacity + unsim_temperature * unsim_heat_capacity) / (full_heat_capacity + unsim_heat_capacity)

	if(sharing_lookup_table.len >= tileslen) //6 or more interconnecting tiles will max at 42% of air moved per tick.
		ratio = sharing_lookup_table[tileslen]

	A.oxygen = max(0, (A.oxygen - oxy_avg) * (1 - ratio) + oxy_avg )
	A.nitrogen = max(0, (A.nitrogen - nit_avg) * (1 - ratio) + nit_avg )
	A.carbon_dioxide = max(0, (A.carbon_dioxide - co2_avg) * (1 - ratio) + co2_avg )
	A.toxins = max(0, (A.toxins - plasma_avg) * (1 - ratio) + plasma_avg )

	A.temperature = max(TCMB, (A.temperature - temp_avg) * (1 - ratio) + temp_avg )

	for(var/datum/gas/G in A.trace_gases)
		var/G_avg = (G.moles * size) / (size + share_size)
		G.moles = (G.moles - G_avg) * (1 - ratio) + G_avg

	A.update_values()

	return abs(old_pressure - A.return_pressure())


proc/ShareHeat(datum/gas_mixture/A, datum/gas_mixture/B, connecting_tiles)
	//This implements a simplistic version of the Stefan-Boltzmann law.
	var/energy_delta = ((A.temperature - B.temperature) ** 4) * 5.6704e-8 * connecting_tiles * 2.5
	var/maximum_energy_delta = max(0, min(A.temperature * A.heat_capacity() * A.group_multiplier, B.temperature * B.heat_capacity() * B.group_multiplier))
	if(maximum_energy_delta > abs(energy_delta))
		if(energy_delta < 0)
			maximum_energy_delta *= -1
		energy_delta = maximum_energy_delta

	A.temperature -= energy_delta / (A.heat_capacity() * A.group_multiplier)
	B.temperature += energy_delta / (B.heat_capacity() * B.group_multiplier)