SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_CHEMISTRY
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_GAME
	wait = 0.5 SECONDS

	/// A map of (type = list(...reactions)) where type is the first reagent of a reaction
	var/static/list/id_reactions_map = list()

	/// A map of (type = list(...reactions)) where type is what the reactions create
	var/static/list/product_reactions_map = list()

	/// A map of (type = prototype instance) of randomized chems in typesof(/datum/reagent/random)
	var/static/list/datum/reagent/random/random_chem_prototypes = list()

	/// The waiting list of reagents datums to process reactions for
	var/static/list/datum/reagents/active_reagents = list()

	/// The current queue of reagents datums being processed
	var/static/list/datum/reagents/queue = list()

	/// If the queue was not finished, the index to read from on the next run
	var/static/saved_index


/datum/controller/subsystem/chemistry/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Reaction Queue: [length(active_reagents)]")


/datum/controller/subsystem/chemistry/Initialize(start_uptime)
	for (var/singleton/reaction/reaction as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/reaction))
		var/result = reaction.result
		if (!product_reactions_map[result])
			product_reactions_map[result] = list()
		product_reactions_map[result] += reaction
		if (!length(reaction.required_reagents))
			continue
		var/id = reaction.required_reagents[1]
		if (!id_reactions_map[id])
			id_reactions_map[id] = list()
		id_reactions_map[id] += reaction


/datum/controller/subsystem/chemistry/Recover()
	QDEL_NULL_LIST(active_reagents)
	active_reagents = list()
	queue.Cut()


/datum/controller/subsystem/chemistry/fire(resumed, no_mc_tick)
	if (!resumed)
		queue = active_reagents.Copy()
		saved_index = 1
	var/queue_length = length(queue)
	if (!queue_length)
		return
	var/datum/reagents/reagents
	for (var/i = saved_index to queue_length)
		reagents = queue[i]
		if (QDELETED(reagents))
			log_debug("SSchemistry: deleted reagents datum in active set! Info: [reagents?.del_info || "(nulled)"]")
			active_reagents -= reagents
		if (!reagents.process_reactions())
			active_reagents -= reagents
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			saved_index = i + 1
			return
	queue.Cut()


/datum/controller/subsystem/chemistry/proc/get_prototype(path, temperature)
	if (!ispath(path, /datum/reagent/random))
		return
	var/datum/reagent/random/prototype = random_chem_prototypes[path]
	if (!prototype)
		prototype = new path (null, TRUE)
		prototype.randomize_data(temperature)
		random_chem_prototypes[path] = prototype
	if (!isnull(temperature) && !prototype.stable_at_temperature(temperature))
		return
	return prototype


/datum/controller/subsystem/chemistry/proc/get_random_chem(only_if_unique, temperature = T20C)
	for (var/type in shuffle(typesof(/datum/reagent/random), TRUE))
		if (only_if_unique && random_chem_prototypes[type])
			continue
		if (get_prototype(type, temperature))
			return type
