//used for pref.alternate_option
#define JOB_LEVEL_NEVER  4
#define JOB_LEVEL_LOW    3
#define JOB_LEVEL_MEDIUM 2
#define JOB_LEVEL_HIGH   1

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
	var/datum/browser/panel

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	from_file(S["alternate_option"], 	pref.alternate_option)
	from_file(S["job_high"],			pref.job_high)
	from_file(S["job_medium"],			pref.job_medium)
	from_file(S["job_low"],				pref.job_low)
	from_file(S["player_alt_titles"],	pref.player_alt_titles)
	from_file(S["char_branch"],			pref.char_branch)
	from_file(S["char_rank"],			pref.char_rank)
	from_file(S["skills_saved"],		pref.skills_saved)

	load_skills()

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	save_skills()

	to_file(S["alternate_option"],		pref.alternate_option)
	to_file(S["job_high"],				pref.job_high)
	to_file(S["job_medium"],			pref.job_medium)
	to_file(S["job_low"],				pref.job_low)
	to_file(S["player_alt_titles"],		pref.player_alt_titles)
	to_file(S["char_branch"],			pref.char_branch)
	to_file(S["char_rank"],				pref.char_rank)
	to_file(S["skills_saved"],			pref.skills_saved)

/datum/category_item/player_setup_item/occupation/sanitize_character()
	if(!istype(pref.job_medium)) 		pref.job_medium = list()
	if(!istype(pref.job_low))    		pref.job_low = list()
	if(!istype(pref.skills_saved))		pref.skills_saved = list()

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

	pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		//this proc also automatically computes and updates points_by_job

	var/jobs_by_type = decls_repository.get_decls(GLOB.using_map.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type[job_type]
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
	. += "<style>.Points,a.Points{background: #cc5555;}</style>"
	. += "<style>a.Points:hover{background: #55cc55;}</style>"
	. += "<tt><center>"
	. += "<b>Choose occupation chances. <font size=3>Click on the occupation to select skills.</font><br>Unavailable occupations are crossed out.</b>"
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
	for(var/datum/job/job in job_master.occupations)
		var/unspent = pref.points_by_job[job]
		var/current_level = JOB_LEVEL_NEVER
		if(pref.job_high == job.title)
			current_level = JOB_LEVEL_HIGH
		else if(job.title in pref.job_medium)
			current_level = JOB_LEVEL_MEDIUM
		else if(job.title in pref.job_low)
			current_level = JOB_LEVEL_LOW

		index += 1
		if((index >= limit) || (job.title in splitJobs))
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					. += "<tr bgcolor='[lastJob.selection_color]'><td width='40%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			. += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		. += "<tr bgcolor='[job.selection_color]'><td width='40%' align='right'>"
		var/rank = job.title
		lastJob = job
		. += "<a href='?src=\ref[src];job_info=[rank]'>\[?\]</a>"
		var/bad_message = ""
		if(job.total_positions == 0 && job.spawn_positions == 0)
			bad_message = "<b> \[UNAVAILABLE]</b>"
		else if(jobban_isbanned(user, rank))
			bad_message = "<b> \[BANNED]</b>"
		else if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			bad_message = "\[IN [(available_in_days)] DAYS]"
		else if(job.minimum_character_age && user.client && (user.client.prefs.age < job.minimum_character_age))
			bad_message = "\[MINIMUM CHARACTER AGE: [job.minimum_character_age]]"
		else if(!job.is_species_allowed(S))
			bad_message = "<b> \[SPECIES RESTRICTED]</b>"
		else if(!S.check_background(job, user.client.prefs))
			bad_message = "<b> \[BACKGROUND RESTRICTED]</b>"

		if(!bad_message && job.allowed_branches)
			if(!player_branch)
				bad_message = "<a href='?src=\ref[src];show_branches=[rank]'><b> \[BRANCH RESTRICTED]</b></a>"
			else if(!is_type_in_list(player_branch, job.allowed_branches))
				bad_message = "<a href='?src=\ref[src];show_branches=[rank]'><b> \[NOT FOR [player_branch.name_short]]</b></a>"

		if(!bad_message && job.allowed_ranks)
			if(!player_rank)
				bad_message = "<a href='?src=\ref[src];show_ranks=[rank]'><b> \[RANK RESTRICTED]</b></a>"
			else if(!is_type_in_list(player_rank, job.allowed_ranks))
				bad_message = "<a href='?src=\ref[src];show_ranks=[rank]'><b> \[NOT FOR [player_rank.name_short || player_rank.name]]</b></a>"

		if(("Assistant" in pref.job_low) && (rank != "Assistant"))
			. += "<a href='?src=\ref[src];set_skills=[rank]'><font color=grey>[rank]</font></a></td><td></td></tr>"
			continue
		if(bad_message)
			. += "<a href='?src=\ref[src];set_skills=[rank]'><del>[rank]</del></a></td><td>[bad_message]</td></tr>"
			continue

		. += (unspent && (current_level != JOB_LEVEL_NEVER) ? "<a class='Points' href='?src=\ref[src];set_skills=[rank]'>" : "<a href='?src=\ref[src];set_skills=[rank]'>")
		if((rank in GLOB.command_positions) || (rank == "AI"))//Bold head jobs
			. += "<b>[rank]</b>"
		else
			. += "[rank]"

		. += "</a></td><td width='40%'>"

		if(rank == "Assistant")//Assistant is special
			. += "<a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_LOW]'>"
			. += " [rank in pref.job_low ? "<font color=55cc55>" : ""]\[Yes][rank in pref.job_low ? "</font>" : ""]"
			. += "</a>"
			. += "<a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_NEVER]'>"
			. += " [!(rank in pref.job_low) ? "<font color=black>" : ""]\[No][!(rank in pref.job_low) ? "</font>" : ""]"
			. += "</a>"
		else
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_HIGH]'>[current_level == JOB_LEVEL_HIGH ? "<font color=55cc55>" : ""]\[High][current_level == JOB_LEVEL_HIGH ? "</font>" : ""]</a>"
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_MEDIUM]'>[current_level == JOB_LEVEL_MEDIUM ? "<font color=eecc22>" : ""]\[Medium][current_level == JOB_LEVEL_MEDIUM ? "</font>" : ""]</a>"
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_LOW]'>[current_level == JOB_LEVEL_LOW ? "<font color=cc5555>" : ""]\[Low][current_level == JOB_LEVEL_LOW ? "</font>" : ""]</a>"
			. += " <a href='?src=\ref[src];set_job=[rank];set_level=[JOB_LEVEL_NEVER]'>[current_level == JOB_LEVEL_NEVER ? "<font color=black>" : ""]\[NEVER][current_level == JOB_LEVEL_NEVER ? "</font>" : ""]</a>"

		if(job.alt_titles)
			. += "</td></tr><tr bgcolor='[lastJob.selection_color]'><td width='40%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
		. += "</td></tr>"
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
	. += "</tt><br>"
	. += "Jobs that <span class='Points'>look like this</span> have unspent skill points remaining."
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

	else if(href_list["set_job"] && href_list["set_level"])
		if(SetJob(user, href_list["set_job"], text2num(href_list["set_level"]))) return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["char_branch"])
		var/choice = input(user, "Choose your branch of service.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.char_branch) as null|anything in mil_branches.spawn_branches(preference_species())
		if(choice && CanUseTopic(user) && mil_branches.is_spawn_branch(choice, preference_species()))
			pref.char_branch = choice
			pref.char_rank = "None"
			prune_job_prefs()
			pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// Check our skillset is still valid
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
		if(job)
			to_chat(user, "<span clas='notice'>Valid branches for [rank]: [job.get_branches()]</span>")
	else if(href_list["show_ranks"])
		var/rank = href_list["show_ranks"]
		var/datum/job/job = job_master.GetJob(rank)
		if(job)
			to_chat(user, "<span clas='notice'>Valid ranks for [rank] ([pref.char_branch]): [job.get_ranks(pref.char_branch)]</span>")
	else if(href_list["set_skills"])
		var/rank = href_list["set_skills"]
		var/datum/job/job = job_master.GetJob(rank)
		if(job)
			open_skill_setup(user, job)

	//From the skills popup

	else if(href_list["hit_skill_button"])
		var/decl/hierarchy/skill/S = locate(href_list["hit_skill_button"])
		var/datum/job/J = locate(href_list["at_job"])
		if(!istype(S) || !istype(J))
			return
		var/value = text2num(href_list["newvalue"])
		update_skill_value(J, S, value)
		pref.ShowChoices(user) //Manual refresh to allow us to focus the panel, not the main window.
		panel.set_content(generate_skill_content(J))
		panel.open()
		winset(user, panel.window_id, "focus=1") //Focuses the panel.

	else if(href_list["skillinfo"])
		var/decl/hierarchy/skill/S = locate(href_list["skillinfo"])
		if(!istype(S))
			return
		var/HTML = list()
		HTML += "<h2>[S.name]</h2>"
		HTML += "[S.desc]<br>"
		var/i
		for(i=1, i <= length(S.levels), i++)
			var/level_name = S.levels[i]
			HTML +=	"<br><b>[level_name]</b>: [S.levels[level_name]]<br>"
		show_browser(user, jointext(HTML, null), "window=\ref[user]skillinfo")

	else if(href_list["job_info"])
		var/rank = href_list["job_info"]
		var/datum/job/job = job_master.GetJob(rank)
		var/dat = list()

		dat += "<p style='background-color: [job.selection_color]'><br><br><p>"
		if(job.alt_titles)
			dat += "<i><b>Alternative titles:</b> [english_list(job.alt_titles)].</i>"
		send_rsc(user, job.get_job_icon(), "job[ckey(rank)].png")
		dat += "<img src=job[ckey(rank)].png width=96 height=96 style='float:left;'>"
		if(job.department)
			dat += "<b>Department:</b> [job.department]."
			if(job.head_position)
				dat += "You are in charge of this department."

		dat += "You answer to <b>[job.supervisors]</b> normally."

		if(job.allowed_branches)
			dat += "You can be of following ranks:"
			for(var/T in job.allowed_branches)
				var/datum/mil_branch/B = mil_branches.get_branch_by_type(T)
				dat += "<li>[B.name]: [job.get_ranks(B.name)]"
		dat += "<hr style='clear:left;'>"
		if(config.wikiurl)
			dat += "<a href='?src=\ref[src];job_wiki=[rank]'>Open wiki page in browser</a>"

		var/description = job.get_description_blurb()
		if(job.required_education)
			description = "[description ? "[description]\n\n" : ""] This role requires [SSculture.education_tiers_to_strings["[job.required_education]"]] or higher,"
			if(!job.maximum_education)
				description = "[description] selected under Education in the Background tab of your character preferences."
			else
				description = "[description] but no higher than [SSculture.education_tiers_to_strings["[job.maximum_education]"]], selected under Education in the Background tab of your character preferences."

		if(description)
			dat += html_encode(description)
		var/datum/browser/popup = new(user, "Job Info", "[capitalize(rank)]", 430, 520, src)
		popup.set_content(jointext(dat,"<br>"))
		popup.open()

	else if(href_list["job_wiki"])
		var/rank = href_list["job_wiki"]
		open_link(user,"[config.wikiurl][rank]")

	return ..()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role, level)
	var/datum/job/job = job_master.GetJob(role)
	if(!job)
		return 0

	if(role == "Assistant")
		if(level == JOB_LEVEL_NEVER)
			pref.job_low -= job.title
		else
			pref.job_low |= job.title
		return 1

	SetJobDepartment(job, level)

	return 1

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0

	var/current_level = JOB_LEVEL_NEVER
	if(pref.job_high == job.title)
		current_level = JOB_LEVEL_HIGH
	else if(job.title in pref.job_medium)
		current_level = JOB_LEVEL_MEDIUM
	else if(job.title in pref.job_low)
		current_level = JOB_LEVEL_LOW

	switch(current_level)
		if(JOB_LEVEL_HIGH)
			pref.job_high = null
		if(JOB_LEVEL_MEDIUM)
			pref.job_medium -= job.title
		if(JOB_LEVEL_LOW)
			pref.job_low -= job.title

	switch(level)
		if(JOB_LEVEL_HIGH)
			if(pref.job_high)
				pref.job_medium |= pref.job_high
			pref.job_high = job.title
		if(JOB_LEVEL_MEDIUM)
			pref.job_medium |= job.title
		if(JOB_LEVEL_LOW)
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
	var/jobs_by_type = decls_repository.get_decls(GLOB.using_map.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type[job_type]
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

#undef JOB_LEVEL_NEVER
#undef JOB_LEVEL_LOW
#undef JOB_LEVEL_MEDIUM
#undef JOB_LEVEL_HIGH
