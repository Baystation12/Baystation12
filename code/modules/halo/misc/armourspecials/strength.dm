
/datum/armourspecials/superstrength
	var/mob/living/carbon/human/owner
	var/extra_melee_damage = 0.5
	var/equipment_ignore_threshold = 6
	var/equipment_slowdown_multiplier = 0.25
	var/extra_throw_multiplier = 1

/datum/armourspecials/superstrength/on_equip(var/obj/source_armour)
	owner = source_armour.loc

	//add bonus melee damage
	owner.damage_multiplier += extra_melee_damage

	//carry more stuff
	owner.equipment_slowdown_multiplier += equipment_slowdown_multiplier
	owner.ignore_equipment_threshold += equipment_ignore_threshold

	//throw further
	owner.throw_multiplier += extra_throw_multiplier

/datum/armourspecials/superstrength/on_drop(var/obj/source_armour)
	//add bonus melee damage
	owner.damage_multiplier -= extra_melee_damage

	//carry more stuff
	owner.equipment_slowdown_multiplier -= equipment_slowdown_multiplier
	owner.ignore_equipment_threshold -= equipment_ignore_threshold

	//throw further
	owner.throw_multiplier -= extra_throw_multiplier
