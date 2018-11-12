
/datum/armourspecials/superspeed
	var/mob/living/carbon/human/owner
	var/datum/species/modified_species
	var/slowdown_effect = -1

/datum/armourspecials/superspeed/on_equip(var/obj/source_armour)
	owner = source_armour.loc
	modified_species = owner.species

	//add bonus
	modified_species.slowdown += slowdown_effect

/datum/armourspecials/superspeed/on_drop(var/obj/source_armour)
	//remove the bonus
	modified_species.slowdown -= slowdown_effect
