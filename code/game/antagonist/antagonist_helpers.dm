/datum/antagonist/proc/can_become_antag(var/datum/mind/player, var/ignore_role)
	if(player.current && jobban_isbanned(player.current, bantype))
		return 0
	if(!ignore_role)
		if(player.assigned_role in restricted_jobs)
			return 0
		if(config.protect_roles_from_antagonist && (player.assigned_role in protected_jobs))
			return 0
	return 1

/datum/antagonist/proc/antags_are_dead()
	for(var/datum/mind/antag in current_antagonists)
		if(mob_path && !istype(antag.current,mob_path))
			continue
		if(antag.current.stat==2)
			continue
		return 0
	return 1

/datum/antagonist/proc/get_antag_count()
	return current_antagonists ? current_antagonists.len : 0

/datum/antagonist/proc/get_active_antag_count()
	var/active_antags = 0
	for(var/datum/mind/player in current_antagonists)
		var/mob/living/L = player.current
		if(!L || L.stat == DEAD)
			continue //no mob or dead
		if(!L.client && !L.teleop)
			continue //SSD
		active_antags++
	return active_antags

/datum/antagonist/proc/is_antagonist(var/datum/mind/player)
	if(player in current_antagonists)
		return 1

/datum/antagonist/proc/is_type(var/antag_type)
	if(antag_type == id || antag_type == role_text)
		return 1
	return 0

/datum/antagonist/proc/is_votable()
	return (flags & ANTAG_VOTABLE)

/datum/antagonist/proc/can_late_spawn()
	return 1

/datum/antagonist/proc/is_latejoin_template()
	return (flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))

/proc/all_random_antag_types()
	// No caching as the ANTAG_RANDOM_EXCEPTED flag can be added/removed mid-round.
	var/list/antag_candidates = all_antag_types.Copy()
	for(var/datum/antagonist/antag in antag_candidates)
		if(antag.flags & ANTAG_RANDOM_EXCEPTED)
			antag_candidates -= antag
	return antag_candidates
