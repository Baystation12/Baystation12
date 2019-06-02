/datum/antagonist/proc/equip(var/mob/living/carbon/human/player)

	if(!istype(player))
		return 0
	
	if (required_language)
		player.add_language(required_language)
		player.set_default_language(all_languages[required_language])

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			if(player.canUnEquip(thing))
				qdel(thing)
		//mainly for vox antag compatibility. Should not effect item spawning.
		player.species.equip_survival_gear(player)
	return 1

/datum/antagonist/proc/unequip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return 0
	return 1