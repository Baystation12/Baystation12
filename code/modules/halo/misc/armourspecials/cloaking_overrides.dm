
/mob/proc/disrupt_cloak_if_required()
	return

/mob/living/carbon/human/disrupt_cloak_if_required()
	var/obj/item/clothing/suit/armor/special/suit_special = wear_suit
	if(istype(suit_special))
		var/datum/armourspecials/cloaking/c = locate(/datum/armourspecials/cloaking) in suit_special.specials
		if(c)
			c.disrupt_cloak(c.cloak_recover_time*1.5)