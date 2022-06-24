SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_CHEMISTRY
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	wait = 0.5 SECONDS
	var/static/list/reactions = list()
	var/static/list/reactions_by_id = list()
	var/static/list/reactions_by_result = list()
	var/static/list/random_chem_prototypes = list()
	var/static/list/processing = list()
	var/static/list/current = list()


/datum/controller/subsystem/chemistry/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Reaction Queue: [processing.len]")


/datum/controller/subsystem/chemistry/Initialize(start_uptime)
	for (var/datum/chemical_reaction/reaction as anything in subtypesof(/datum/chemical_reaction))
		reaction = new reaction
		var/result = reaction.result
		var/list/required = reaction.required_reagents
		if (!reactions_by_result[result])
			reactions_by_result[result] = list()
		reactions_by_result[result] += reaction
		if (length(required))
			var/id = required[1]
			if (!reactions_by_id[id])
				reactions_by_id[id] = list()
			reactions_by_id[id] += reaction


/datum/controller/subsystem/chemistry/Recover()
	current.Cut()


/datum/controller/subsystem/chemistry/fire(resumed, no_mc_tick)
	if (!resumed)
		current = processing.Copy()
	for (var/i = current.len to 1 step -1)
		var/datum/reagents/R = current[i]
		if (QDELETED(R))
			log_debug("SSchemistry: deleted reagents datum in processing queue! Info: [R?.del_info || "(nulled)"]")
			processing -= R
			if (MC_TICK_CHECK)
				current.Cut(i)
				return
			continue
		if (!R.process_reactions())
			processing -= R
		if (MC_TICK_CHECK)
			current.Cut(i)
			return


/datum/controller/subsystem/chemistry/proc/get_prototype(given_type, temperature)
	if(!ispath(given_type, /datum/reagent/random))
		return
	var/datum/reagent/random/prototype = random_chem_prototypes[given_type]
	if(!prototype)
		prototype = new given_type(null, TRUE)
		prototype.randomize_data(temperature)
		random_chem_prototypes[given_type] = prototype
	if(temperature && !prototype.stable_at_temperature(temperature))
		return
	return prototype


/datum/controller/subsystem/chemistry/proc/get_random_chem(only_if_unique, temperature = T20C)
	for(var/type in typesof(/datum/reagent/random))
		if(only_if_unique && random_chem_prototypes[type])
			continue
		if(get_prototype(type, temperature)) //returns truthy if it's valid for the given temperature
			return type
