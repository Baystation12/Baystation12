SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_CHEMISTRY
	wait = 0.5 SECONDS
	var/static/list/reactions_by_id = list()
	var/static/list/reactions_by_result = list()
	var/static/list/datum/reagent/random/random_chem_prototypes = list()
	var/static/list/datum/reagents/active_reagents = list()
	var/static/list/datum/reagents/queue = list()


/datum/controller/subsystem/chemistry/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Reaction Queue: [length(active_reagents)]")


/datum/controller/subsystem/chemistry/Initialize(start_uptime)
	for (var/singleton/reaction/reaction as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/reaction))
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
	queue.Cut()


/datum/controller/subsystem/chemistry/fire(resumed, no_mc_tick)
	if (!resumed)
		queue = active_reagents.Copy()
		if (!length(queue))
			return
	var/cut_until = 1
	for (var/datum/reagents/reagents as anything in queue)
		++cut_until
		if (QDELETED(reagents))
			log_debug("SSchemistry: deleted reagents datum in active set! Info: [reagents?.del_info || "(nulled)"]")
			active_reagents -= reagents
			continue
		if (!reagents.process_reactions())
			active_reagents -= reagents
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


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
