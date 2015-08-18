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
	var/list/current_antagonists = list()
	var/list/pending_antagonists = list()
	var/list/starting_locations = list()
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
	
	// Prune restricted status. Broke it up for readability.
	// Note that this is done before jobs are handed out.
	for(var/datum/mind/player in ticker.mode.get_players_for_role(role_type, id))
		if(ghosts_only && !istype(player.current, /mob/dead))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts may join as this role!"
		else if(player.special_role)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They already have a special role ([player.special_role])!"
		else if (player in pending_antagonists)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They have already been selected for this role!"
		else if(!can_become_antag(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are blacklisted for this role!"
		else if(player_is_antag(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are already an antagonist!"
		else
			candidates += player

	return candidates

/datum/antagonist/proc/attempt_random_spawn()
	build_candidate_list(flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))
	attempt_spawn()
	finalize_spawn()

/datum/antagonist/proc/attempt_late_spawn(var/datum/mind/player)
	if(!can_late_spawn())
		return
	if(!istype(player)) player = get_candidates(is_latejoin_template())
	player.current << "<span class='danger'><i>You have been selected this round as an antagonist!</i></span>"
	if(istype(player.current, /mob/dead))
		create_default(player.current)
	else
		add_antagonist(player,0,1,0,1,1)
	return

/datum/antagonist/proc/build_candidate_list(var/ghosts_only)
	// Get the raw list of potential players.
	update_current_antag_max()
	candidates = get_candidates(ghosts_only)

//Selects players that will be spawned in the antagonist role from the potential candidates
//Selected players are added to the pending_antagonists lists.
//Attempting to spawn an antag role with ANTAG_OVERRIDE_JOB should be done before jobs are assigned,
//so that they do not occupy regular job slots. All other antag roles should be spawned after jobs are
//assigned, so that job restrictions can be respected.
/datum/antagonist/proc/attempt_spawn(var/rebuild_candidates = 1)

	// Update our boundaries.
	if(!candidates.len)
		return 0

	//Grab candidates randomly until we have enough.
	candidates = shuffle(candidates)
	while(candidates.len && pending_antagonists.len < cur_max)
		var/datum/mind/player = pick(candidates)
		candidates -= player
		draft_antagonist(player)

	return 1

/datum/antagonist/proc/draft_antagonist(var/datum/mind/player)
	//Check if the player can join in this antag role, or if the player has already been given an antag role.
	if(!can_become_antag(player) || player.special_role)
		log_debug("[player.key] was selected for [role_text] by lottery, but is not allowed to be that role.")
		return 0

	pending_antagonists |= player
	
	//Ensure that antags with ANTAG_OVERRIDE_JOB do not occupy job slots.
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text
	
	//Ensure that a player cannot be drafted for multiple antag roles, taking up slots for antag roles that they will not fill.
	player.special_role = role_text
	
	return 1

//Spawns all pending_antagonists. This is done separately from attempt_spawn in case the game mode setup fails.
/datum/antagonist/proc/finalize_spawn()
	if(!pending_antagonists)
		return

	for(var/datum/mind/player in pending_antagonists)
		pending_antagonists -= player
		add_antagonist(player,0,0,1)

//Resets all pending_antagonists, clearing their special_role (and assigned_role if ANTAG_OVERRIDE_JOB is set)
/datum/antagonist/proc/reset()
	for(var/datum/mind/player in pending_antagonists)
		if(flags & ANTAG_OVERRIDE_JOB)
			player.assigned_role = null
		player.special_role = null
	pending_antagonists.Cut()
