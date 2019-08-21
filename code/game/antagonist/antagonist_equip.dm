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

/datum/antagonist/proc/equip_rig(var/rig_type, var/mob/living/carbon/human/player)
	set waitfor = 0
	if(istype(player) && ispath(rig_type))
		var/obj/item/weapon/rig/rig = new rig_type(player)
		rig.seal_delay = 0
		player.put_in_hands(rig)
		player.equip_to_slot_or_del(rig,slot_back)
		if(rig)
			rig.visible_name = player.real_name
			rig.toggle_seals(src,1)
			rig.seal_delay = initial(rig.seal_delay)
			if(rig.air_supply)
				player.set_internals(rig.air_supply)
		return rig 