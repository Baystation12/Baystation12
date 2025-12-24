/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, CHEM_BLOOD, or CHEM_METABOLITES
	var/mob/living/carbon/parent
	var/no_reactions = FALSE

/datum/reagents/metabolism/del_reagent(reagent_type)
	var/datum/reagent/current = locate(reagent_type) in reagent_list
	if(current)
		current.on_leaving_metabolism(parent, metabolism_class)
	. = ..()

/datum/reagents/metabolism/New(max = 100, mob/living/carbon/parent_mob, met_class, no_react)
	..(max, parent_mob)

	metabolism_class = met_class
	no_reactions = no_react
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/process_reactions()
	if (no_reactions)
		return
	return ..()

/datum/reagents/metabolism/proc/metabolize()
	if(parent)
		for(var/datum/reagent/current in reagent_list)
			current.on_mob_life(parent, metabolism_class)
		update_total()
