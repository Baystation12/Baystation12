
/datum/armourspecials/self_destruct/on_equip(var/obj/source_armour)
	source_armour.verbs += /obj/item/clothing/suit/armor/special/proc/verb_self_destruct

/datum/armourspecials/self_destruct/on_drop(var/obj/source_armour)
	source_armour.verbs -= /obj/item/clothing/suit/armor/special/proc/verb_self_destruct