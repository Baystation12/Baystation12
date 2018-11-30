
/datum/armourspecials/superspeed
	var/slowdown_effect = -4
	var/equipment_ignore_threshold = 3

/datum/armourspecials/superspeed/New(var/obj/item/clothing/source_armour)
	. = ..()

	//speed up
	source_armour.slowdown_per_slot[slot_wear_suit] = slowdown_effect

/datum/armourspecials/superstrength/on_equip(var/obj/source_armour)

	//carry more stuff
	owner.ignore_equipment_threshold += equipment_ignore_threshold

/datum/armourspecials/superstrength/on_drop(var/obj/source_armour)

	//carry more stuff
	owner.ignore_equipment_threshold -= equipment_ignore_threshold
