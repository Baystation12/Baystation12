/obj/item/clothing

	var/datum/equip_slot/list/equip_slots = list()

	var/equip_flags = CLTH_COVER_UNDER			// Extra flags for if the item covers stuff below it or if it has buttons.

	var/datum/equip_node_group/nodes
	var/datum/species/node_species

/obj/item/clothing/proc/species_prep(var/datum/species/S)


/obj/item/clothing/proc/update_organs(var/obj/item/clothing/C)
	//mob/living/carbon/human/list/organs = list()