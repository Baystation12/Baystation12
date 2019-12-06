/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_BLOOD
	var/mob/living/carbon/parent

/datum/reagents/metabolism/del_reagent(var/reagent_type)
	var/datum/reagent/current = locate(reagent_type) in reagent_list
	if(current)
		current.on_leaving_metabolism(parent, metabolism_class)
	. = ..()

/datum/reagents/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class)
	..(max, parent_mob)

	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()
	if(parent)
		var/metabolism_type = 0 //non-human mobs
		if(ishuman(parent))
			var/mob/living/carbon/human/H = parent
			metabolism_type = H.species.reagent_tag

		for(var/datum/reagent/current in reagent_list)
			current.on_mob_life(parent, metabolism_type, metabolism_class)
		update_total()