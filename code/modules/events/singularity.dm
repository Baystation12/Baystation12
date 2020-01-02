#define OVERMAP_EDGE 2

/datum/event/rogue_singularity
	startWhen				= 0
	announceWhen			= 1
	endWhen					= null
	var/list/singularity_path		= list()
	var/position			= 1
	var/obj/effect/overmap/event/rogue_singularity
	var/velocity			= 15 //number of ticks to cross one sector
	var/energy_level		= 500

	var/list/valid_absorb = list()

	var/list/singularities = list()

/datum/event/rogue_singularity/check_conditions()
	return GLOB.using_map.use_overmap

/datum/event/rogue_singularity/setup()
	// Singularity will move along a straight path from an edge of one quadrant to the opposite quadrant's edge
	var/list/start_point[2]
	start_point[1] = OVERMAP_EDGE
	start_point[2] = rand(OVERMAP_EDGE, Ceiling((GLOB.using_map.overmap_size - OVERMAP_EDGE)/2))
	start_point = shuffle(start_point)

	if(prob(50))
		start_point[1] = GLOB.using_map.overmap_size - start_point[1] // rotate start point to adjacent corner
		start_point = shuffle(start_point)

	var/list/end_point[2]
	end_point[1] = GLOB.using_map.overmap_size - start_point[1]
	end_point[2] = GLOB.using_map.overmap_size - start_point[2]

	var/turf/start_turf = locate(start_point[1], start_point[2], GLOB.using_map.overmap_z)
	var/turf/end_turf = locate(end_point[1], end_point[2], GLOB.using_map.overmap_z)

	singularity_path = getline(start_turf, end_turf)

	rogue_singularity = new /obj/effect/overmap/event/singularity(singularity_path[1])

	endWhen = velocity * (singularity_path.len + 1)

/datum/event/rogue_singularity/announce()
	command_announcement.Announce("A rogue singularity has been detected passing through this sector. Avoid it at all costs.", "[location_name()] Sensor Array", zlevels = GLOB.using_map.map_levels)

/datum/event/rogue_singularity/tick()
	if(activeFor % velocity == 0)
		if(position <= singularity_path.len)
			position++
			rogue_singularity.forceMove(singularity_path[position])
		
		absorb_overmap_effect()
		move_overmap_effect()
	move_ship()

/datum/event/rogue_singularity/end()
	command_announcement.Announce("The rogue singularity has passed beyond our sensor range.", "[location_name()] Sensor Array", zlevels = GLOB.using_map.map_levels)
	qdel(rogue_singularity)

/datum/event/rogue_singularity/proc/absorb_overmap_effect()
	var/turf/T = get_turf(rogue_singularity)

	for(var/obj/effect/overmap/event/E in T)
		if(!istype(E, /obj/effect/overmap/event/singularity))
			qdel(E)

/datum/event/rogue_singularity/proc/move_overmap_effect() // tries to move nearby overmap effects in a circle around itself, this should fill in the holes it creates with its passing a bit
	var/list/sectors = block(locate(rogue_singularity.x-1,rogue_singularity.y-1,rogue_singularity.z), locate(rogue_singularity.x+1,rogue_singularity.y+1,rogue_singularity.z))
	sectors.Swap(4,6)
	sectors.Swap(7,9)
	sectors -= sectors[5]

	for(var/i=sectors.len; i>0; i--)
		for(var/obj/effect/overmap/event/E in sectors[i])
			var/turf/destination = sectors[(i%sectors.len)+1]
			if(!(locate(/obj/effect/overmap) in destination))
				E.forceMove(destination)

/datum/event/rogue_singularity/proc/move_ship()
	var/list/sectors = block(locate(rogue_singularity.x-1,rogue_singularity.y-1,rogue_singularity.z), locate(rogue_singularity.x+1,rogue_singularity.y+1,rogue_singularity.z))

	for(var/i=1; i<=sectors.len; i++)
		for(var/obj/effect/overmap/visitable/ship/S in sectors[i])
			S.forceMove(get_turf(rogue_singularity))
			var/pull_dir = pick(GLOB.cardinal)
			var/pull_strength = 4*(rand()+1) * 1e3 // want this to be sometimes more powerful than a single basic inertial damper
			if(S.needs_dampers && S.damping_strength < pull_strength)
				for(var/area/A in world)
					if(A.z in S.map_z)
						A.throw_unbuckled_occupants(pull_strength+2, pull_strength, pull_dir)