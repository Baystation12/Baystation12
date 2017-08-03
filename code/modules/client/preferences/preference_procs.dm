/datum/preferences/proc/get_metadata(var/underwear_category, var/datum/gear_tweak/gt)
	var/metadata = all_underwear_metadata[underwear_category]
	if(!metadata)
		metadata = list()
		all_underwear_metadata[underwear_category] = metadata

	var/tweak_data = metadata["[gt]"]
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata["[gt]"] = tweak_data
	return tweak_data

/datum/preferences/proc/set_metadata(var/underwear_category, var/datum/gear_tweak/gt, var/new_metadata)
	var/list/metadata = all_underwear_metadata[underwear_category]
	metadata["[gt]"] = new_metadata

/datum/preferences/proc/SetFlavorText(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavor_text=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavor_text;size=430x300")
	return



/datum/preferences/proc/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Robot Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavour_text_robot=Default'>Default:</a> "
	HTML += TextPreview(flavour_texts_robot["Default"])
	HTML += "<hr />"
	for(var/module in GLOB.robot_module_types)
		HTML += "<a href='?src=\ref[src];flavour_text_robot=[module]'>[module]:</a> "
		HTML += TextPreview(flavour_texts_robot[module])
		HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavour_text_robot;size=430x300")
	return

/datum/preferences/proc/valid_special_roles()
	var/list/private_valid_special_roles = list()

	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		private_valid_special_roles += antag.role_type

	var/list/ghost_traps = get_ghost_traps()
	for(var/ghost_trap_key in ghost_traps)
		var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
		if(!ghost_trap.list_as_special_role)
			continue
		private_valid_special_roles += ghost_trap.pref_check

	return private_valid_special_roles

/client/proc/wishes_to_be_role(var/role)
	if(!prefs)
		return FALSE
	if(role in prefs.be_special_role)
		return 2
	if(role in prefs.sometimes_be_special_role)
		return 1

/datum/preferences/proc/banned_from_ghost_role(var/mob, var/datum/ghosttrap/ghost_trap)
	for(var/ban_type in ghost_trap.ban_checks)
		if(jobban_isbanned(mob, ban_type))
			return 1
	return 0


/proc/can_select_ooc_color(var/mob/user)
	return config.allow_admin_ooccolor && check_rights(R_ADMIN, 0, user)


/client/proc/is_preference_enabled(var/preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	return cp && (cp.key in prefs.preferences_enabled)

/client/proc/is_preference_disabled(var/preference)
	return !is_preference_enabled(preference)

/client/proc/set_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	preference = cp.key

	if(set_preference && !(preference in prefs.preferences_enabled))
		return toggle_preference(cp)
	else if(!set_preference && (preference in prefs.preferences_enabled))
		return toggle_preference(cp)

/client/proc/toggle_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	if(!cp.may_toggle(mob))
		return FALSE
	preference = cp.key

	var/enabled
	if(preference in prefs.preferences_disabled)
		prefs.preferences_enabled  |= preference
		prefs.preferences_disabled -= preference
		enabled = TRUE
		. = TRUE
	else if(preference in prefs.preferences_enabled)
		prefs.preferences_enabled  -= preference
		prefs.preferences_disabled |= preference
		enabled = FALSE
		. = TRUE
	if(.)
		cp.toggled(mob, enabled)

/mob/proc/is_preference_enabled(var/preference)
	if(!client)
		return FALSE
	return client.is_preference_enabled(preference)

/mob/proc/is_preference_disabled(var/preference)
	if(!client)
		return TRUE
	return client.is_preference_disabled(preference)

/mob/proc/set_preference(var/preference, var/set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.set_preference(preference, set_preference)

/mob/proc/toggle_preference(var/preference)
	if(!client)
		return FALSE
	return client.toggle_preference(preference)

/datum/preferences/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		player_alt_titles[job.title] = new_title

/datum/preferences/proc/SetJob(mob/user, role)
	var/datum/job/job = job_master.GetJob(role)
	if(!job)
		return 0

	if(role == "Assistant")
		if(job.title in job_low)
			job_low -= job.title
		else
			job_low |= job.title
		return 1

	if(job.title == job_high)
		SetJobDepartment(job, 1)
	else if(job.title in job_medium)
		SetJobDepartment(job, 2)
	else if(job.title in job_low)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	return 1

/datum/preferences/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)//Only one of these should ever be active at once so clear them all here
			job_high = null
		if(2)//Set current highs to med, then reset them
			job_medium |= job_high
			job_high = job.title
			job_medium -= job.title
		if(3)
			job_medium |= job.title
			job_low -= job.title
		else
			job_low |= job.title
	return 1

/datum/preferences/proc/CorrectLevel(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)
			return job_high == job.title
		if(2)
			return !!(job.title in job_medium)
		if(3)
			return !!(job.title in job_low)
	return 0

/**
 *  Prune a player's job preferences based on current branch and rank
 *
 *  This proc goes through all the preferred jobs, and removes the ones incompatible with current rank or branch.
 */
/datum/preferences/proc/prune_job_prefs_for_rank()
	for(var/datum/job/job in job_master.occupations)
		if(job.title == job_high)
			if(!job.is_branch_allowed(char_branch) || !job.is_rank_allowed(char_branch, char_rank))
				job_high = null

		else if(job.title in job_medium)
			if(!job.is_branch_allowed(char_branch) || !job.is_rank_allowed(char_branch, char_rank))
				job_medium.Remove(job.title)

		else if(job.title in job_low)
			if(!job.is_branch_allowed(char_branch) || !job.is_rank_allowed(char_branch, char_rank))
				job_low.Remove(job.title)


/datum/preferences/proc/ResetJobs()
	job_high = null
	job_medium = list()
	job_low = list()

	player_alt_titles.Cut()

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title