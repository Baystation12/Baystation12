/datum/reagents/metabolism
	var/metabolism_type

/datum/reagents/metabolism/New(var/max = 100, var/met_type, mob/living/carbon/parent_mob)
	..()
	metabolism_type = met_type
	my_atom = parent_mob

/datum/reagents/proc/metabolize(var/alien)
	if(!iscarbon(my_atom))
		return
	var/mob/living/carbon/C = my_atom
	if(!C || !istype(C))
		return
	for(var/datum/reagent/current in reagent_list)
		current.on_mob_life(C, alien, metabolism_type)
	update_total()