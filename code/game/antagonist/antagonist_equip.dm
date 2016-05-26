/datum/antagonist/proc/equip(var/mob/living/carbon/human/player)

	if(!istype(player))
		return 0

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			player.drop_from_inventory(thing)
			if(thing.loc != player)
				qdel(thing)
		//mainly for vox antag compatibility. Should not effect item spawning.
		player.species.equip_survival_gear(player)
	return 1

/datum/antagonist/proc/unequip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return 0
	return 1