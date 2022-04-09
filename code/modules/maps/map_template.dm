/datum/map_template
	var/name = "Default Template Name"
	var/id = null // All maps that should be loadable during runtime needs an id
	var/width = 0
	var/height = 0
	var/tallness = 0
	var/list/mappaths = null
	var/loaded = 0 // Times loaded this round
	var/list/shuttles_to_initialise = list()
	var/list/subtemplates_to_spawn
	var/base_turf_for_zs = null
	var/accessibility_weight = 0
	var/template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/New(var/list/paths = null, var/rename = null)
	if(paths && !islist(paths))
		crash_with("Non-list paths passed into map template constructor.")
	if(paths)
		mappaths = paths
	if(mappaths)
		preload_size(mappaths)
	if(rename)
		name = rename
	if(!name && id)
		name = id

/datum/map_template/proc/preload_size()
	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/z_offset = 1 // needed to calculate z-bounds correctly
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = GLOB.maploader.load_map(file(mappath), 1, 1, z_offset, cropMap=FALSE, measureOnly=TRUE, no_changeturf=TRUE, clear_contents= template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS)
		if(M)
			bounds = extend_bounds_if_needed(bounds, M.bounds)
			z_offset++
		else
			return FALSE
	width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
	height = bounds[MAP_MAXY] - bounds[MAP_MINX] + 1
	tallness = bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1
	return TRUE

/datum/map_template/proc/init_atoms(var/list/atoms)
	if (SSatoms.atom_init_stage == INITIALIZATION_INSSATOMS)
		return // let proper initialisation handle it later

	var/list/turf/turfs = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/machinery/machines = list()
	var/list/obj/structure/cable/cables = list()

	for(var/atom/A in atoms)
		if(istype(A, /turf))
			turfs += A
		if(istype(A, /obj/structure/cable))
			cables += A
		if(istype(A, /obj/machinery/atmospherics))
			atmos_machines += A
		if(istype(A, /obj/machinery))
			machines += A
		if(istype(A,/obj/effect/landmark/map_load_mark))
			LAZYADD(subtemplates_to_spawn, A)

	var/notsuspended
	if(!SSmachines.suspended)
		SSmachines.suspend()
		notsuspended = TRUE

	SSatoms.InitializeAtoms() // The atoms should have been getting queued there. This flushes the queue.

	SSmachines.setup_powernets_for_cables(cables)
	SSmachines.setup_atmos_machinery(atmos_machines)
	if(notsuspended)
		SSmachines.wake()

	for (var/i in machines)
		var/obj/machinery/machine = i
		machine.power_change()

	for (var/i in turfs)
		var/turf/T = i
		T.post_change()
		if(template_flags & TEMPLATE_FLAG_NO_RUINS)
			T.turf_flags |= TURF_FLAG_NORUINS
		if(template_flags & TEMPLATE_FLAG_NO_RADS)
			qdel(SSradiation.sources_assoc[i])
		if(istype(T,/turf/simulated))
			var/turf/simulated/sim = T
			sim.update_air_properties()

/datum/map_template/proc/pre_init_shuttles()
	. = SSshuttle.block_queue
	SSshuttle.block_queue = TRUE

/datum/map_template/proc/init_shuttles(var/pre_init_state)
	for (var/shuttle_type in shuttles_to_initialise)
		LAZYADD(SSshuttle.shuttles_to_initialize, shuttle_type) // queue up for init.
	SSshuttle.block_queue = pre_init_state
	SSshuttle.clear_init_queue() // We will flush the queue unless there were other blockers, in which case they will do it.

/datum/map_template/proc/load_new_z(no_changeturf = TRUE)

	var/x = round((world.maxx - width)/2)
	var/y = round((world.maxy - height)/2)
	var/initial_z = world.maxz + 1

	if (x < 1) x = 1
	if (y < 1) y = 1

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()

	var/initialized_areas_by_type = list()
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = GLOB.maploader.load_map(file(mappath), x, y, no_changeturf = no_changeturf, initialized_areas_by_type = initialized_areas_by_type)
		if (M)
			bounds = extend_bounds_if_needed(bounds, M.bounds)
			atoms_to_initialise += M.atoms_to_initialise
		else
			return FALSE

	for (var/z_index = bounds[MAP_MINZ]; z_index <= bounds[MAP_MAXZ]; z_index++)
		if (accessibility_weight)
			GLOB.using_map.accessible_z_levels[num2text(z_index)] = accessibility_weight
		if (base_turf_for_zs)
			GLOB.using_map.base_turf_by_z[num2text(z_index)] = base_turf_for_zs
		GLOB.using_map.player_levels |= z_index

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state)
	after_load(initial_z)
	for(var/light_z = initial_z to world.maxz)
		create_lighting_overlays_zlevel(light_z)
	log_game("Z-level [name] loaded at [x],[y],[world.maxz]")
	loaded++

	return locate(world.maxx/2, world.maxy/2, world.maxz)

/datum/map_template/proc/load(turf/T, centered=FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()

	var/initialized_areas_by_type = list()
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = GLOB.maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE, clear_contents=(template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS), initialized_areas_by_type = initialized_areas_by_type)
		if (M)
			atoms_to_initialise += M.atoms_to_initialise
		else
			return FALSE

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state)
	after_load(T.z)
	SSlighting.InitializeTurfs(atoms_to_initialise)	// Hopefully no turfs get placed on new coords by SSatoms.
	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++

	return TRUE

/datum/map_template/proc/after_load(z)
	for(var/obj/effect/landmark/map_load_mark/mark in subtemplates_to_spawn)
		subtemplates_to_spawn -= mark
		if(LAZYLEN(mark.templates))
			var/template = pick(mark.templates)
			var/datum/map_template/M = new template()
			M.load(get_turf(mark), TRUE)
			qdel(mark)
	LAZYCLEARLIST(subtemplates_to_spawn)

/datum/map_template/proc/extend_bounds_if_needed(var/list/existing_bounds, var/list/new_bounds)
	var/list/bounds_to_combine = existing_bounds.Copy()
	for (var/min_bound in list(MAP_MINX, MAP_MINY, MAP_MINZ))
		bounds_to_combine[min_bound] = min(existing_bounds[min_bound], new_bounds[min_bound])
	for (var/max_bound in list(MAP_MAXX, MAP_MAXY, MAP_MAXZ))
		bounds_to_combine[max_bound] = max(existing_bounds[max_bound], new_bounds[max_bound])
	return bounds_to_combine


/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))

//for your ever biggening badminnery kevinz000
//? - Cyberboss
/proc/load_new_z_level(var/file, var/name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()
