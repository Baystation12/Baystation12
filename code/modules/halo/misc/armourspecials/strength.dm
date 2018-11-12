
/datum/armourspecials/superstrength
	var/extra_melee_damage = 0.5
	var/old_melee_force_multiplier
	var/mob/living/carbon/human/owner
	var/datum/species/modified_species
	var/equipment_ignore_threshold = 3
	var/equipment_slowdown_multiplier = 0.25
	var/equipment_slowdown_multiplier_old = 1

/datum/armourspecials/superstrength/on_equip(var/obj/source_armour)
	owner = source_armour.loc
	modified_species = owner.species

	//add bonus melee damage
	modified_species.melee_force_multiplier += extra_melee_damage

	//carry more stuff
	equipment_slowdown_multiplier_old = modified_species.equipment_slowdown_multiplier
	modified_species.equipment_slowdown_multiplier = min(equipment_slowdown_multiplier_old, equipment_slowdown_multiplier)
	modified_species.ignore_equipment_threshold += equipment_ignore_threshold

/datum/armourspecials/superstrength/on_drop(var/obj/source_armour)
	//remove the bonus melee damage
	modified_species.melee_force_multiplier -= extra_melee_damage

	//remove the carry equipment bonus
	modified_species.ignore_equipment_threshold -= equipment_ignore_threshold
	modified_species.equipment_slowdown_multiplier = equipment_slowdown_multiplier_old
