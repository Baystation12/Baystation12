/// Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling()
	if(!mind)
		return
	if(!mind.changeling)
		mind.changeling = new /datum/changeling(gender)
		mind.changeling.owner_mind = mind

	verbs += /datum/changeling/proc/EvolutionMenu
	add_language(LANGUAGE_CHANGELING_GLOBAL)

	if(!LAZYLEN(GLOB.changeling_power_instances))
		for(var/P in GLOB.changeling_powers)
			GLOB.changeling_power_instances += new P()

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in GLOB.changeling_power_instances)
		if(!P.genome_cost && !P.no_autobuy && !(P in mind.changeling.purchased_powers)) // Is it free, and we don't own it?
			mind.changeling.purchasePower(mind, P.name, 0, TRUE) // Purchase it. Don't remake our verbs, we're doing it after this.

	/*for(var/datum/power/changeling/P in mind.changeling.purchased_powers)
		if(P.isVerb)
			if(lesser_form && !P.allow_during_lesser_form)	continue
			if(!(P in src.verbs))
				src.verbs += P.verbpath*/ // Keeping this comment in case this functionality is restored in the future

	for(var/language in languages)
		mind.changeling.absorbed_languages |= language

	var/mob/living/carbon/human/H = src
	if(istype(H))
		var/datum/absorbed_dna/newDNA = new(H.real_name, H.dna, H.species.name, H.languages)
		mind.changeling.absorb_DNA(newDNA)

	return TRUE


/mob/proc/sting_can_reach(mob/M, sting_range = 1)
	if(M.loc == loc)
		return 1 //target and source are in the same thing
	if(!isturf(loc) || !isturf(M.loc))
		to_chat(src, SPAN_WARNING("We cannot reach \the [M] with a sting!"))
		return //One is inside, the other is outside something.
	// Maximum queued turfs set to 25; I don't *think* anything raises sting_range above 2, but if it does the 25 may need raising
	if(!AStar(loc, M.loc, /turf/proc/AdjacentTurfs, /turf/proc/Distance, max_nodes=25, max_node_depth=sting_range)) //If we can't find a path, fail
		to_chat(src, SPAN_WARNING("We cannot find a path to sting \the [M] by!"))
		return
	return TRUE
