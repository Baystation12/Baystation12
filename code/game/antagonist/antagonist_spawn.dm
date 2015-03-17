/datum/antagonist/proc/attempt_late_spawn(var/datum/mind/player, var/move_to_spawn)

	update_cur_max()
	if(get_antag_count() >= cur_max)
		return 0

	player.current << "<span class='danger'><i>You have been selected this round as an antagonist!</i></span>"
	add_antagonist(player)
	equip(player.current)
	finalize(player)
	if(move_to_spawn)
		place_mob(player.current)
	return

/datum/antagonist/proc/update_cur_max(var/lower_count, var/upper_count)

	candidates = list()
	var/main_type
	if(ticker && ticker.mode)
		if(ticker.mode.antag_tag && ticker.mode.antag_tag == id)
			main_type = 1
	else
		return list()

	cur_max = (main_type ? max_antags_round : max_antags)
	if(ticker.mode.antag_scaling_coeff)
		cur_max = Clamp((ticker.mode.num_players()/ticker.mode.antag_scaling_coeff), 1, cur_max)

/datum/antagonist/proc/attempt_spawn(var/lower_count, var/upper_count, var/ghosts_only)

	world << "Attempting to spawn."
	// Get the raw list of potential players.
	update_cur_max(lower_count, upper_count)
	candidates = get_candidates(ghosts_only)

	// Update our boundaries.
	if(!candidates.len)
		world << "No candidates."
		return 0

	//Grab candidates randomly until we have enough.
	while(candidates.len)
		var/datum/mind/player = pick(candidates)
		current_antagonists |= player
		// Update job and role.
		player.special_role = role_text
		if(flags & ANTAG_OVERRIDE_JOB)
			player.assigned_role = "MODE"
		candidates -= player
	world << "Done."
	return 1

/datum/antagonist/proc/place_mob(var/mob/living/mob)
	if(!starting_locations || !starting_locations.len)
		return
	mob.loc = pick(starting_locations)

/datum/antagonist/proc/add_antagonist(var/datum/mind/player)
	if(!istype(player))
		return 0
	if(player in current_antagonists)
		return 0
	if(!can_become_antag(player))
		return 0
	current_antagonists |= player
	apply(player)
	finalize(player)
	return 1

/datum/antagonist/proc/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(player in current_antagonists)
		player.current << "<span class='danger'><font size = 3>You are no longer a [role_text]!</font></span>"
		current_antagonists -= player
		player.special_role = null
		update_icons_removed(player)
		BITSET(player.current.hud_updateflag, SPECIALROLE_HUD)
		return 1
	return 0