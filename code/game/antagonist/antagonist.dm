/datum/antagonist

	var/role_type = BE_TRAITOR
	var/role_text = "Traitor"
	var/role_text_plural = "Traitors"
	var/welcome_text = "Cry havoc and let slip the dogs of war!"
	var/leader_welcome_text
	var/victory_text
	var/loss_text
	var/victory_feedback_tag
	var/loss_feedback_tag
	var/max_antags = 3
	var/max_antags_round = 5

	// Random spawn values.
	var/spawn_announcement
	var/spawn_announcement_title
	var/spawn_announcement_sound
	var/spawn_announcement_delay

	var/id = "traitor"
	var/landmark_id
	var/antag_indicator
	var/mob_path = /mob/living/carbon/human
	var/feedback_tag = "traitor_objective"
	var/bantype = "Syndicate"
	var/suspicion_chance = 50
	var/flags = 0
	var/cur_max = 0

	var/datum/mind/leader
	var/spawned_nuke
	var/nuke_spawn_loc

	var/list/valid_species = list("Unathi","Tajara","Skrell","Human") // Used for setting appearance.
	var/list/starting_locations = list()
	var/list/current_antagonists = list()
	var/list/global_objectives = list()
	var/list/restricted_jobs = list()
	var/list/protected_jobs = list()
	var/list/candidates = list()

	var/default_access = list()
	var/id_type = /obj/item/weapon/card/id
	var/announced

/datum/antagonist/New()
	..()
	cur_max = max_antags
	get_starting_locations()
	if(!role_text_plural)
		role_text_plural = role_text
	if(config.protect_roles_from_antagonist)
		restricted_jobs |= protected_jobs

/datum/antagonist/proc/tick()
	return 1

/datum/antagonist/proc/get_candidates(var/ghosts_only)

	candidates = list() // Clear.
	candidates = ticker.mode.get_players_for_role(role_type, id)
	// Prune restricted jobs and status.
	for(var/datum/mind/player in candidates)
		if((ghosts_only && !istype(player.current, /mob/dead)) || player.special_role || (player.assigned_role in restricted_jobs))
			candidates -= player
	return candidates

/datum/antagonist/proc/attempt_random_spawn()
	attempt_spawn(flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))

/datum/antagonist/proc/attempt_late_spawn(var/datum/mind/player, var/move_to_spawn)

	update_current_antag_max()
	if(get_antag_count() >= cur_max)
		return 0

	player.current << "<span class='danger'><i>You have been selected this round as an antagonist!</i></span>"
	if(move_to_spawn)
		place_mob(player.current)
	add_antagonist(player)
	equip(player.current)
	return

/datum/antagonist/proc/attempt_spawn(var/ghosts_only)

	// Get the raw list of potential players.
	update_current_antag_max()
	candidates = get_candidates(ghosts_only)

	// Update our boundaries.
	if(!candidates.len)
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
	return 1

