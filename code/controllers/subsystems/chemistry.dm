SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_CHEMISTRY
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	wait = 0.5 SECONDS

	var/static/list/reactions = list()
	var/static/list/reactions_by_id = list()
	var/static/list/reactions_by_result = list()
	var/static/list/random_reagents = list()
	var/static/list/processing = list()
	var/static/list/current = list()


/datum/controller/subsystem/chemistry/stat_entry(msg)
	..("[msg] P: [processing.len]")


/datum/controller/subsystem/chemistry/Initialize(timeofday)
	var/id
	var/result
	var/datum/chemical_reaction/C
	for(var/path in subtypesof(/datum/chemical_reaction))
		C = new path
		result = C.result
		reactions += C
		if (!reactions_by_result[result])
			reactions_by_result[result] = list()
		reactions_by_result[result] += C
		if (C.required_reagents?.len)
			id = C.required_reagents[1]
			if (!reactions_by_id[id])
				reactions_by_id[id] = list()
			reactions_by_id[id] += C


/datum/controller/subsystem/chemistry/fire(resumed, no_mc_tick)
	if (!resumed)
		current = processing.Copy()
	var/datum/reagents/R
	for (var/i = current.len to 1 step -1)
		R = current[i]
		if (QDELETED(R))
			log_debug("SSchemistry: QDELETED entry found in processing!")
			processing -= R
			continue
		if (!R.process_reactions())
			processing -= R
		if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()


/datum/controller/subsystem/chemistry/proc/get_prototype(try_path, temperature)
	if (!ispath(try_path, /datum/reagent/random))
		return
	var/datum/reagent/random/prototype = random_reagents[try_path]
	if (!prototype)
		prototype = new try_path (null, TRUE)
		prototype.randomize_data(temperature)
		random_reagents[try_path] = prototype
	if (temperature && !prototype.stable_at_temperature(temperature))
		return
	return prototype


/datum/controller/subsystem/chemistry/proc/get_random_chem(only_if_unique, temperature = T20C)
	for (var/type in typesof(/datum/reagent/random))
		if (only_if_unique && random_reagents[type])
			continue
		if (get_prototype(type, temperature))
			return type
