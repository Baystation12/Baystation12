//used for pref.alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/preferences
	//Since there can only be 1 high job.
	var/job_high = null
	var/list/job_medium        //List of all things selected for medium weight
	var/list/job_low           //List of all the things selected for low weight
	var/list/player_alt_titles // the default name of a job like "Medical Doctor"
	var/char_branch	= "None"   // military branch
	var/char_rank = "None"     // military rank

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 2

/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	S["alternate_option"]  >> pref.alternate_option
	S["job_high"]          >> pref.job_high
	S["job_medium"]        >> pref.job_medium
	S["job_low"]           >> pref.job_low
	S["player_alt_titles"] >> pref.player_alt_titles
	S["char_branch"]       >> pref.char_branch
	S["char_rank"]         >> pref.char_rank

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	S["alternate_option"]  << pref.alternate_option
	S["job_high"]          << pref.job_high
	S["job_medium"]        << pref.job_medium
	S["job_low"]           << pref.job_low
	S["player_alt_titles"] << pref.player_alt_titles
	S["char_branch"]       << pref.char_branch
	S["char_rank"]         << pref.char_rank

/datum/category_item/player_setup_item/occupation/sanitize_character()
	if(!istype(pref.job_medium)) pref.job_medium = list()
	if(!istype(pref.job_low))    pref.job_low = list()

	pref.alternate_option	= sanitize_integer(pref.alternate_option, 0, 2, initial(pref.alternate_option))
	pref.job_high	        = sanitize(pref.job_high, null)
	if(pref.job_medium && pref.job_medium.len)
		for(var/i in 1 to pref.job_medium.len)
			pref.job_medium[i]  = sanitize(pref.job_medium[i])
	if(pref.job_low && pref.job_low.len)
		for(var/i in 1 to pref.job_low.len)
			pref.job_low[i]  = sanitize(pref.job_low[i])
	if(!pref.player_alt_titles) pref.player_alt_titles = new()

	// We could have something like Captain set to high while on a non-rank map,
	// so we prune here to make sure we don't spawn as a PFC captain
	prune_occupation_prefs()

	if(!job_master)
		return

	for(var/datum/job/job in job_master.occupations)
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitJobs, splitLimit = 1)
	if(!job_master)
		return

	var/datum/species/S = preference_species()
	var/datum/mil_branch/player_branch = null
	var/datum/mil_rank/player_rank = null

	. = list()
	. += "<tt><center>"
	. += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br>"
	if(GLOB.using_map.flags & MAP_HAS_BRANCH)

		player_branch = mil_branches.get_branch(pref.char_branch)

		. += "Branch of Service: <a href='?src=\ref[src];char_branch=1'>[pref.char_branch]</a>	"
	if(GLOB.using_map.flags & MAP_HAS_RANK)
		player_rank = mil_branches.get_rank(pref.char_branch, pref.char_rank)

		. += "Rank: <a href='?src=\ref[src];char_rank=1'>[pref.char_rank]</a>	"
	. += "<br>"
	. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more columns.
	. += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1
	if(splitLimit)
		limit = round((job_master.occupations.len+1)/2)

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	if (!job_master)		return
	for(var/datum/job/job in job_master.occupations)

		index += 1
		if((index >= limit) || (job.title in splitJobs))
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					. += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			. += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		. += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		lastJob = job
		if(job.total_positions == 0 && job.spawn_positions == 0)
			. += "<del>[rank]</del></td><td><b> \[UNAVAILABLE]</b></td></tr>"
			continue
		if(jobban_isbanned(user, rank))
			. += "<del>[rank]</del></td><td><b> \[BANNED]</b></td></tr>"
			continue
		if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			. += "<del>[rank]</del></td><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		if(job.minimum_character_age && user.client && (user.client.prefs.age < job.minimum_character_age))
			. += "<del>[rank]</del></td><td> \[MINIMUM CHARACTER AGE: [job.minimum_character_age]]</td></tr>"
			continue

		if(!job.is_species_allowed(S))
			. += "<del>[rank]</del></td><td><b> \[SPECIES RESTRICTED]</b></td></tr>"
			continue

		if(job.allowed_branches)
			if(!player_branch)
				. += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_branches=[rank]'><b> \[BRANCH RESTRICTED]</b></a></td></tr>"
				continue
			if(!is_type_in_list(player_branch, job.allowed_branches))
				. += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_branches=[rank]'><b> \[NOT FOR [player_branch.name_short]]</b></a></td></tr>"
				continue

		if(job.allowed_ranks)
			if(!player_rank)
				. += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_ranks=[rank]'><b> \[RANK RESTRICTED]</b></a></td></tr>"
				continue

			if(!is_type_in_list(player_rank, job.allowed_ranks))
				. += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_ranks=[rank]'><b> \[NOT FOR [player_rank.name_short || player_rank.name]]</b></a></td></tr>"
				continue

		if(("Assistant" in pref.job_low) && (rank != "Assistant"))
			. += "<font color=grey>[rank]</font></td><td></td></tr>"
			continue
		if((rank in GLOB.command_positions) || (rank == "AI"))//Bold head jobs
			. += "<b>[rank]</b>"
		else
			. += "[rank]"

		. += "</td><td width='40%'>"

		. += "<a href='?src=\ref[src];set_job=[rank]'>"

		if(rank == "Assistant")//Assistant is special
			if("Assistant" in pref.job_low)
				. += " <font color=55cc55>\[Yes]</font>"
			else
				. += " <font color=black>\[No]</font>"
			if(job.alt_titles) //Blatantly cloned from a few lines down.
				. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
			. += "</a></td></tr>"
			continue

		if(pref.job_high == job.title)
			. += " <font color=55cc55>\[High]</font>"
		else if(job.title in pref.job_medium)
			. += " <font color=eecc22>\[Medium]</font>"
		else if(job.title in pref.job_low)
			. += " <font color=cc5555>\[Low]</font>"
		else
			. += " <font color=black>\[NEVER]</font>"
		if(job.alt_titles)
			. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
		. += "</a></td></tr>"
	. += "</td'></tr></table>"
	. += "</center></table><center>"

	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Get random job if preferences unavailable</a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Be assistant if preference unavailable</a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Return to lobby if preference unavailable</a></u>"

	. += "<a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	. += "</tt>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return TOPIC_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		return TOPIC_REFRESH

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = input("Choose an title for [job.title].", "Choose Title", pref.GetPlayerAltTitle(job)) as anything in choices|null
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(job, choice)
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"])) return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["char_branch"])
		var/choice = input(user, "Choose your branch of service.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.char_branch) as null|anything in mil_branches.spawn_branches(preference_species())
		if(choice && CanUseTopic(user) && mil_branches.is_spawn_branch(choice, preference_species()))
			pref.char_branch = choice
			pref.char_rank = "None"
			prune_job_prefs()
			return TOPIC_REFRESH

	else if(href_list["char_rank"])
		var/choice = null
		var/datum/mil_branch/current_branch = mil_branches.get_branch(pref.char_branch)

		if(current_branch)
			choice = input(user, "Choose your rank.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.char_rank) as null|anything in mil_branches.spawn_ranks(pref.char_branch, preference_species())

		if(choice && CanUseTopic(user) && mil_branches.is_spawn_rank(pref.char_branch, choice, preference_species()))
			pref.char_rank = choice
			prune_job_prefs()
			return TOPIC_REFRESH
	else if(href_list["show_branches"])
		var/rank = href_list["show_branches"]
		var/datum/job/job = job_master.GetJob(rank)
		to_chat(user, "<span clas='notice'>Valid branches for [rank]: [job.get_branches()]</span>")
	else if(href_list["show_ranks"])
		var/rank = href_list["show_ranks"]
		var/datum/job/job = job_master.GetJob(rank)
		to_chat(user, "<span clas='notice'>Valid ranks for [rank] ([pref.char_branch]): [job.get_ranks(pref.char_branch)]</span>")

	return ..()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role)
	var/datum/job/job = job_master.GetJob(role)
	if(!job)
		return 0

	if(role == "Assistant")
		if(job.title in pref.job_low)
			pref.job_low -= job.title
		else
			pref.job_low |= job.title
		return 1

	if(job.title == pref.job_high)
		SetJobDepartment(job, 1)
	else if(job.title in pref.job_medium)
		SetJobDepartment(job, 2)
	else if(job.title in pref.job_low)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	return 1

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)//Only one of these should ever be active at once so clear them all here
			pref.job_high = null
		if(2)//Set current highs to med, then reset them
			pref.job_medium |= pref.job_high
			pref.job_high = job.title
			pref.job_medium -= job.title
		if(3)
			pref.job_medium |= job.title
			pref.job_low -= job.title
		else
			pref.job_low |= job.title
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
 *  Prune a player's job preferences based on current branch, rank and species
 *
 *  This proc goes through all the preferred jobs, and removes the ones incompatible with current rank or branch.
 */
/datum/category_item/player_setup_item/proc/prune_job_prefs()
	var/allowed_titles = list()

	for(var/job_type in GLOB.using_map.allowed_jobs)
		var/datum/job/job = decls_repository.get_decl(job_type)
		allowed_titles += job.title

		if(job.title == pref.job_high)
			if(job.is_restricted(pref))
				pref.job_high = null

		else if(job.title in pref.job_medium)
			if(job.is_restricted(pref))
				pref.job_medium.Remove(job.title)

		else if(job.title in pref.job_low)
			if(job.is_restricted(pref))
				pref.job_low.Remove(job.title)

	if(pref.job_high && !(pref.job_high in allowed_titles))
		pref.job_high = null

	for(var/job_title in pref.job_medium)
		if(!(job_title in allowed_titles))
			pref.job_medium -= job_title

	for(var/job_title in pref.job_low)
		if(!(job_title in allowed_titles))
			pref.job_low -= job_title

datum/category_item/player_setup_item/proc/prune_occupation_prefs()
	var/datum/species/S = preference_species()
	if((GLOB.using_map.flags & MAP_HAS_BRANCH)\
	   && (!pref.char_branch || !mil_branches.is_spawn_branch(pref.char_branch, S)))
		pref.char_branch = "None"

	if((GLOB.using_map.flags & MAP_HAS_RANK)\
	   && (!pref.char_rank || !mil_branches.is_spawn_rank(pref.char_branch, pref.char_rank, S)))
		pref.char_rank = "None"

	prune_job_prefs()

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_high = null
	pref.job_medium = list()
	pref.job_low = list()

	pref.player_alt_titles.Cut()

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title