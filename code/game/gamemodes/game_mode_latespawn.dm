/datum/game_mode/var/next_spawn = 0
/datum/game_mode/var/min_autotraitor_delay = 4200  // Approx 7 minutes.
/datum/game_mode/var/max_autotraitor_delay = 12000 // Approx 20 minutes.
/datum/game_mode/var/process_count = 0

///process()
///Called by the gameticker
/datum/game_mode/proc/process()
	if(round_autoantag && world.time >= next_spawn && !evacuation_controller.has_evacuated())
		process_autoantag()

//This can be overriden in case a game mode needs to do stuff when a player latejoins
/datum/game_mode/proc/handle_latejoin(var/mob/living/carbon/human/character)
	return 0

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
