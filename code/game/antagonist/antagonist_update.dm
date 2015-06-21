/datum/antagonist/proc/update_leader()
	if(!leader && current_antagonists.len && (flags & ANTAG_HAS_LEADER))
		leader = current_antagonists[1]

/datum/antagonist/proc/update_antag_mob(var/datum/mind/player, var/preserve_appearance)

	// Get the mob.
	if((flags & ANTAG_OVERRIDE_MOB) && (!player.current || (mob_path && !istype(player.current, mob_path))))
		var/mob/holder = player.current
		player.current = new mob_path(get_turf(player.current))
		player.transfer_to(player.current)
		if(holder) qdel(holder)
	player.original = player.current
	if(!preserve_appearance && (flags & ANTAG_SET_APPEARANCE))
		spawn(3)
			var/mob/living/carbon/human/H = player.current
			if(istype(H)) H.change_appearance(APPEARANCE_ALL, H.loc, H, valid_species, state = z_state)
	return player.current

/datum/antagonist/proc/update_access(var/mob/living/player)
	for(var/obj/item/weapon/card/id/id in player.contents)
		id.name = "[player.real_name]'s ID Card"
		id.registered_name = player.real_name

/datum/antagonist/proc/update_all_icons()
	if(!antag_indicator)
		return
	for(var/datum/mind/antag in current_antagonists)
		if(antag.current && antag.current.client)
			for(var/image/I in antag.current.client.images)
				if(I.icon_state == antag_indicator)
					qdel(I)
			for(var/datum/mind/other_antag in current_antagonists)
				if(other_antag.current)
					antag.current.client.images |= image('icons/mob/mob.dmi', loc = other_antag.current, icon_state = antag_indicator)

/datum/antagonist/proc/update_icons_added(var/datum/mind/player)
	if(!antag_indicator || !player.current)
		return
	spawn(0)
		for(var/datum/mind/antag in current_antagonists)
			if(!antag.current)
				continue
			if(antag.current.client)
				antag.current.client.images |= image('icons/mob/mob.dmi', loc = player.current, icon_state = antag_indicator)
			if(player.current.client)
				player.current.client.images |= image('icons/mob/mob.dmi', loc = antag.current, icon_state = antag_indicator)

/datum/antagonist/proc/update_icons_removed(var/datum/mind/player)
	if(!antag_indicator || !player.current)
		return
	spawn(0)
		for(var/datum/mind/antag in current_antagonists)
			if(antag.current)
				if(antag.current.client)
					for(var/image/I in antag.current.client.images)
						if(I.icon_state == antag_indicator && I.loc == player.current)
							qdel(I)
		if(player.current && player.current.client)
			for(var/image/I in player.current.client.images)
				if(I.icon_state == antag_indicator)
					qdel(I)

/datum/antagonist/proc/update_current_antag_max()
	var/main_type
	if(ticker && ticker.mode)
		if(ticker.mode.antag_tag && ticker.mode.antag_tag == id)
			main_type = 1
	cur_max = (main_type ? max_antags_round : max_antags)
	if(ticker.mode.antag_scaling_coeff)
		cur_max = Clamp((ticker.mode.num_players()/ticker.mode.antag_scaling_coeff), 1, cur_max)
