/datum/game_mode/var/next_spawn = 0
/datum/game_mode/var/min_autotraitor_delay = 4200  // Approx 7 minutes.
/datum/game_mode/var/max_autotraitor_delay = 12000 // Approx 20 minutes.
/datum/game_mode/var/process_count = 0

///process()
///Called by the gameticker
/datum/game_mode/proc/process()
	if(shall_process_autoantag())
		process_autoantag()

/datum/game_mode/proc/shall_process_autoantag()
	if(!round_autoantag || world.time < next_spawn)
		return FALSE
	if(evacuation_controller.is_evacuating() || evacuation_controller.has_evacuated())
		return FALSE
	// Don't create auto-antags in the last twenty minutes of the round, but only if the vote interval is longer than 20 minutes
	if((config.vote_autotransfer_interval > 20 MINUTES) && (transfer_controller.time_till_transfer_vote() < 20 MINUTES))
		return FALSE

	return TRUE

//This can be overriden in case a game mode needs to do stuff when a player latejoins but just remember to do . = ..()
/datum/game_mode/proc/handle_latejoin(var/mob/living/carbon/human/character)
	//job equip code already handles faction assigning
	//see code\game\jobs\job\job.dm
	/*
	var/datum/faction/F = GLOB.factions_by_name[character.faction]
	if(F)
		F.assigned_minds.Add(character.mind)
		F.living_minds.Add(character.mind)
		return 1
		*/

/datum/game_mode/proc/process_autoantag()
	message_admins("[uppertext(name)]: Attempting autospawn.")

	var/list/usable_templates = list()
	for(var/datum/antagonist/A in antag_templates)
		if(A.can_late_spawn())
			message_admins("[uppertext(name)]: [A.id] selected for spawn attempt.")
			usable_templates |= A

	if(!usable_templates.len)
		message_admins("[uppertext(name)]: Failed to find configured mode spawn templates, please re-enable auto-antagonists after one is added.")
		round_autoantag = 0
		return

	while(usable_templates.len)
		var/datum/antagonist/spawn_antag = pick(usable_templates)
		usable_templates -= spawn_antag

		if(spawn_antag.attempt_auto_spawn())
			message_admins("[uppertext(name)]: Auto-added a new [spawn_antag.role_text].")
			message_admins("There are now [spawn_antag.get_active_antag_count()]/[spawn_antag.cur_max] active [spawn_antag.role_text_plural].")
			next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)
			return

	message_admins("[uppertext(name)]: Failed to proc a viable spawn template.")
	next_spawn = world.time + min_autotraitor_delay //recheck again in the miniumum time
