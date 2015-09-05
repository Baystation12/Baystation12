/datum/game_mode/var/last_spawn = 0
/datum/game_mode/var/min_autotraitor_delay = 4200  // Approx 7 minutes.
/datum/game_mode/var/max_autotraitor_delay = 12000 // Approx 20 minutes.

/datum/game_mode/proc/get_usable_templates(var/list/supplied_templates)
	var/list/usable_templates = list()
	for(var/datum/antagonist/A in supplied_templates)
		if(A.can_late_spawn())
			usable_templates |= A
	return usable_templates

///process()
///Called by the gameticker
/datum/game_mode/proc/process()
	try_latespawn()

/datum/game_mode/proc/latespawn(var/mob/living/carbon/human/character)
	if(!character.mind)
		return
	try_latespawn(character.mind)
	return 0

/datum/game_mode/proc/try_latespawn(var/datum/mind/player, var/latejoin_only)

	if(emergency_shuttle.departed || !round_autoantag)
		return

	if(world.time < next_spawn)
		return

	next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)

	var/list/usable_templates
	if(latejoin_only && latejoin_templates.len)
		usable_templates = get_usable_templates(latejoin_templates)
	else if (antag_templates && antag_templates.len)
		usable_templates = get_usable_templates(antag_templates)
	else
		return

	if(usable_templates.len)
		var/datum/antagonist/spawn_antag = pick(usable_templates)
		spawn_antag.attempt_late_spawn(player)
