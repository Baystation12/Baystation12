PROCESSING_SUBSYSTEM_DEF(cosmic_corruption)
	name = "Cosmic Corruption"
	flags = SS_KEEP_TIMING | SS_NO_INIT
	wait = 2 SECONDS

/datum/extension/cosmic_cult
	base_type = /datum/extension/cosmic_cult
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE

/datum/extension/cosmic_cult/corruptor
	var/conversion_time = 8 SECONDS
	var/conversion_chance = 100
	var/chance_reduction = 16
	var/max_ticks = 6
	var/ticks = 0
	var/auto_disable = TRUE
	var/enabled = TRUE
	var/flood_fill_starting = TRUE
	var/mobile = FALSE

	var/static/list/conversion_floors = list(
		/turf/simulated/floor/cosmic_cult/malign,
		/turf/simulated/floor/cosmic_cult/malign,
		/turf/simulated/floor/cosmic_cult/smooth,
		/turf/simulated/floor/cosmic_cult/half,
		/turf/simulated/floor/cosmic_cult/split
	)
	var/static/list/conversion_walls = list(
		/turf/simulated/wall = /turf/simulated/wall/malign
	)

	var/next_tick = 0
	var/list/candidates = list()

/datum/extension/cosmic_cult/corruptor/New(holder)
	..()
	START_PROCESSING(SScosmic_corruption, src)
	next_tick = world.time + conversion_time
	rebuild_candidates()
	convert(get_turf(holder))

/datum/extension/cosmic_cult/corruptor/Destroy()
	STOP_PROCESSING(SScosmic_corruption, src)
	candidates = null
	. = ..()

/datum/extension/cosmic_cult/corruptor/proc/is_converted(turf/T)
	if(istype(T, /turf/simulated/floor/cosmic_cult) || istype(T, /turf/simulated/wall/malign))
		return TRUE
	return FALSE

/datum/extension/cosmic_cult/corruptor/proc/can_convert(turf/T)
	if(!T || isspaceturf(T) || is_converted(T))
		return FALSE
	if(istype(T, /turf/simulated/floor))
		return TRUE
	for(var/type in conversion_walls)
		if(istype(T, type))
			return TRUE
	return FALSE

/datum/extension/cosmic_cult/corruptor/proc/convertible_neighbors(turf/T)
	RETURN_TYPE(/list)

	. = list()
	for(var/turf/N in RANGE_TURFS(T, 1))
		if(N != T && can_convert(N))
			. += N

/datum/extension/cosmic_cult/corruptor/proc/rebuild_candidates()
	candidates = list()
	var/turf/origin = get_turf(holder)
	if(!origin)
		return

	if(mobile && can_convert(origin))
		candidates[origin] = TRUE
	for(var/turf/N in convertible_neighbors(origin))
		candidates[N] = TRUE

	if(!flood_fill_starting || mobile)
		return

	var/list/visited = list()
	var/list/queue = list()
	for(var/turf/N in RANGE_TURFS(origin, 1))
		if(is_converted(N))
			visited[N] = TRUE
			queue += N
	var/head = 1
	while(head <= length(queue))
		var/turf/current = queue[head++]
		for(var/turf/N in RANGE_TURFS(current, 1))
			if(visited[N])
				continue
			visited[N] = TRUE
			if(is_converted(N))
				queue += N
			else if(can_convert(N))
				candidates[N] = TRUE

/datum/extension/cosmic_cult/corruptor/Process()
	if (!enabled || world.time < next_tick)
		return
	next_tick = world.time + conversion_time

	if (mobile)
		rebuild_candidates()

	var/list/current = candidates
	candidates = list()
	for(var/turf/T as anything in current)
		if(!can_convert(T))
			continue
		if(!prob(conversion_chance))
			candidates[T] = TRUE
			continue
		convert(T)

	ticks++
	conversion_chance = max(0, conversion_chance - chance_reduction)
	if(auto_disable && ticks >= max_ticks)
		enabled = FALSE

/datum/extension/cosmic_cult/corruptor/proc/convert(turf/T)
	var/turf/result
	if (istype(T, /turf/simulated/floor))
		result = T.ChangeTurf(pick(conversion_floors))
	else
		for (var/type in conversion_walls)
			if (istype(T, type))
				result = T.ChangeTurf(conversion_walls[type])
				break
	if(!result)
		return

	for(var/turf/N in convertible_neighbors(result))
		candidates[N] = TRUE

	cosmic_cult_tile_spawn(result)
