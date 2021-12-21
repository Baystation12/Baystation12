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
	var/list/branches
	var/list/ranks
	var/list/hiding_maps = list()

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 2

/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1
	var/datum/browser/panel

/datum/category_item/player_setup_item/occupation/load_character(datum/pref_record_reader/R)
	pref.alternate_option = R.read("alternate_option")
	pref.job_high = R.read("job_high")
	pref.job_medium = R.read("job_medium")
	pref.job_low = R.read("job_low")
	pref.player_alt_titles = R.read("player_alt_titles")
	pref.skills_saved = R.read("skills_saved")
	pref.branches = R.read("branches")
	pref.ranks = R.read("ranks")
	pref.hiding_maps = R.read("hiding_maps")
	load_skills()

/datum/category_item/player_setup_item/occupation/save_character(datum/pref_record_writer/W)
	save_skills()
	W.write("alternate_option", pref.alternate_option)
	W.write("job_high", pref.job_high)
	W.write("job_medium", pref.job_medium)
	W.write("job_low", pref.job_low)
	W.write("player_alt_titles", pref.player_alt_titles)
	W.write("skills_saved", pref.skills_saved)
	W.write("branches", pref.branches)
	W.write("ranks", pref.ranks)
	W.write("hiding_maps", pref.hiding_maps)

/datum/category_item/player_setup_item/occupation/sanitize_character()
	if(!istype(pref.job_medium))		pref.job_medium = list()
	if(!istype(pref.job_low))			pref.job_low = list()
	if(!istype(pref.skills_saved))		pref.skills_saved = list()
	if(!islist(pref.branches))			pref.branches = list()
	if(!islist(pref.ranks))				pref.ranks = list()
	if(!islist(pref.hiding_maps))		pref.hiding_maps = list()

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

	for(var/job_type in SSjobs.types_to_datums)
		var/datum/job/job = SSjobs.types_to_datums[job_type]
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitJobs, splitLimit = 1)

	if(!SSmapping || !SSjobs.job_lists_by_map_name)
		return

	var/datum/species/S = preference_species()
	. = list()
	. += "<style>.Points,a.Points{background: #cc5555;}</style>"
	. += "<style>a.Points:hover{background: #55cc55;}</style>"
	. += "<tt><center>"
	. += "<font size=3><b>Select and configure your occupation preferences. Unavailable occupations are crossed out.</b></font>"
	. += "<br>"

	// Display everything.
	for(var/job_map in SSjobs.job_lists_by_map_name)

		var/list/map_data = SSjobs.job_lists_by_map_name[job_map]
		if(isnull(pref.hiding_maps[job_map]))
			pref.hiding_maps[job_map] = map_data["default_to_hidden"]

		. += "<hr><table width = '100%''><tr>"
		. += "<td width = '50%' align = 'right'><font size = 3><b>[capitalize(job_map)]</b></td>"
		. += "<td width = '50%' align = 'left''><a href='?src=\ref[src];toggle_map=[job_map]'>[pref.hiding_maps[job_map] ? "Show" : "Hide"]</a></font></td>"
		. += "</tr></table>"

		if(!pref.hiding_maps[job_map])

			. += "<hr/>"
			. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more columns.
			. += "<table width='100%' cellpadding='1' cellspacing='0'>"

			//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
			var/datum/job/lastJob
			var/list/map_job_list = map_data["jobs"]
			var/index = -1
			if(splitLimit) limit = round((LAZYLEN(map_job_list)+1)/2)

			for(var/datum/job/job in map_job_list)

				var/datum/mil_rank/player_rank
				var/datum/mil_branch/player_branch
				var/branch_string = ""
				var/rank_branch_string = ""
				var/branch_rank = job.allowed_branches ? job.get_branch_rank(S) : mil_branches.spawn_branches(S)
				if(GLOB.using_map && (GLOB.using_map.flags & MAP_HAS_BRANCH) && LAZYLEN(branch_rank))
					player_branch = mil_branches.get_branch(pref.branches[job.title])
					if(player_branch)
						if(LAZYLEN(branch_rank) > 1)
							branch_string += "<td width='10%' align='left'><a href='?src=\ref[src];char_branch=1;checking_job=\ref[job]'>[player_branch.name_short || player_branch.name]</a></td>"
						else
							branch_string += "<td width='10%' align='left'>[player_branch.name_short || player_branch.name]</td>"
				if(!branch_string)
					branch_string = "<td>-</td>"
				if(player_branch)
					var/ranks = branch_rank[player_branch.name] || mil_branches.spawn_ranks(player_branch.name, S)
					if(LAZYLEN(ranks))
						player_rank = mil_branches.get_rank(player_branch.name, pref.ranks[job.title])
						if(player_rank)
							if(LAZYLEN(ranks) > 1)
								rank_branch_string += "<td width='10%' align='left'><a href='?src=\ref[src];char_rank=1;checking_job=\ref[job]'>[player_rank.name_short || player_rank.name]</a></td>"
							else
								rank_branch_string += "<td width='10%' align='left'>[player_rank.name_short || player_rank.name]</td>"
				if(!rank_branch_string)
					rank_branch_string = "<td>-</td>"
				rank_branch_string = "[branch_string][rank_branch_string]"

				var/title = job.title
				var/title_link = length(job.alt_titles) ? "<a href='?src=\ref[src];select_alt_title=\ref[job]'>[pref.GetPlayerAltTitle(job)]</a>" : job.title
				if((title in SSjobs.titles_by_department(COM)) || (title == "AI"))//Bold head jobs
					title_link = "<b>[title_link]</b>"

				var/help_link = "</td><td width = '10%' align = 'center'><a href='?src=\ref[src];job_info=[title]'>?</a></td>"
				lastJob = job

				var/bodytype = S.get_bodytype()
				var/bad_message = ""
				if(job.total_positions == 0 && job.spawn_positions == 0)
					bad_message = "<b>\[UNAVAILABLE]</b>"
				else if(jobban_isbanned(user, title))
					bad_message = "<b>\[BANNED]</b>"
				else if (!job.is_species_whitelist_allowed(user.client))
					bad_message = "\[WHITELIST RESTRICTED ([job.use_species_whitelist])]"
				else if(!job.player_old_enough(user.client))
					var/available_in_days = job.available_in_days(user.client)
					bad_message = "\[IN [(available_in_days)] DAYS]"
				else if(LAZYACCESS(job.minimum_character_age, bodytype) && user.client && (user.client.prefs.age < job.minimum_character_age[bodytype]))
					bad_message = "\[MIN CHAR AGE: [job.minimum_character_age[bodytype]]]"
				else if(!job.is_species_allowed(S))
					bad_message = "<b>\[SPECIES RESTRICTED]</b>"
				else if(!S.check_background(job, user.client.prefs))
					bad_message = "<b>\[BACKGROUND RESTRICTED]</b>"

				var/current_level = JOB_LEVEL_NEVER
				if(pref.job_high == job.title)
					current_level = JOB_LEVEL_HIGH
				else if(job.title in pref.job_medium)
					current_level = JOB_LEVEL_MEDIUM
				else if(job.title in pref.job_low)
					current_level = JOB_LEVEL_LOW

				var/skill_link
				if(pref.points_by_job[job] && (!job.available_by_default || current_level != JOB_LEVEL_NEVER))
					skill_link = "<a class = 'Points' href='?src=\ref[src];set_skills=[title]'>Set Skills</a>"
				else
					skill_link = "<a href='?src=\ref[src];set_skills=[title]'>View Skills</a>"
				skill_link = "<td>[skill_link]</td>"

				// Begin assembling the actual HTML.
				index += 1
				if((index >= limit) || (job.title in splitJobs))
					if((index < limit) && (lastJob != null))
						//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
						//the last job's selection color. Creating a rather nice effect.
						for(var/i = 0, i < (limit - index), i += 1)
							. += "<tr bgcolor='[lastJob.selection_color]'><td width='40%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
					. += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
					index = 0

				. += "<tr bgcolor='[job.selection_color]'>"
				if(rank_branch_string && rank_branch_string != "")
					. += "[rank_branch_string]"
				. += "<td width='30%' align='left'>"

				if(bad_message)
					. += "<del>[title_link]</del>[help_link][skill_link]<td>[bad_message]</td></tr>"
					continue
				else if((GLOB.using_map.default_assistant_title in pref.job_low) && (title != GLOB.using_map.default_assistant_title))
					. += "<font color=grey>[title_link]</font>[help_link][skill_link]<td></td></tr>"
					continue
				else
					. += "[title_link][help_link][skill_link]"

				. += "<td>"
				if(title == GLOB.using_map.default_assistant_title)//Assistant is special
					var/yes_link = "Yes"
					var/no_link = "No"
					if(title in pref.job_low)
						yes_link = "<font color='#55cc55'>[yes_link]</font>"
						no_link = "<font color='black'>[no_link]</font>"
					else
						yes_link = "<font color='black'>[yes_link]</font>"
						no_link = "<font color='#55cc55'>[no_link]</font>"
					. += "<a href='?src=\ref[src];set_job=[title];set_level=[JOB_LEVEL_LOW]'>[yes_link]</a><a href='?src=\ref[src];set_job=[title];set_level=[JOB_LEVEL_NEVER]'>[no_link]</a>"
				else if(!job.available_by_default)
					. += "<font color = '#cccccc'>Not available at roundstart.</font>"
				else
					var/level_link
					switch(current_level)
						if(JOB_LEVEL_LOW)
							level_link = "<font color='#cc5555'>Low</font>"
						if(JOB_LEVEL_MEDIUM)
							level_link = "<font color='#eecc22'>Medium</font>"
						if(JOB_LEVEL_HIGH)
							level_link = "<font color='#55cc55'>High</font>"
						else
							level_link = "<font color=black>Never</font>"
					. += "<a href='?src=\ref[src];set_job=[title];inc_level=-1'>[level_link]</a>"
				. += "</td></tr>"
			. += "</td></tr></table>"
			. += "</center></table><center>"
	. += "<hr/>"
	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Get random job if preferences unavailable</a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Be assistant if preference unavailable</a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Return to lobby if preference unavailable</a></u>"
	. += "<a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	. += "<hr/>"
	. += "</tt><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/proc/validate_branch_and_rank()

	if(LAZYLEN(pref.branches))
		for(var/job_name in pref.branches)
			if(!(job_name in SSjobs.titles_to_datums))
				pref.branches -= job_name

	if(LAZYLEN(pref.ranks))
		var/list/removing_ranks
		for(var/job_name in pref.ranks)
			var/datum/job/job = SSjobs.get_by_title(job_name, TRUE)
			if(!job) LAZYADD(removing_ranks, job_name)
		if(LAZYLEN(removing_ranks))
			pref.ranks -= removing_ranks

	var/datum/species/S = preference_species()
	for(var/job_name in SSjobs.titles_to_datums)

		var/datum/job/job = SSjobs.get_by_title(job_name)

		var/datum/mil_branch/player_branch = pref.branches[job.title] ? mil_branches.get_branch(pref.branches[job.title]) : null
		var/branch_rank = job.allowed_branches ? job.get_branch_rank(S) : mil_branches.spawn_branches(S)
		if(!player_branch || !(player_branch.name in branch_rank))
			player_branch = LAZYLEN(branch_rank) ? mil_branches.get_branch(branch_rank[1]) : null

		if(player_branch)
			var/datum/mil_rank/player_rank = pref.ranks[job.title] ? mil_branches.get_rank(player_branch.name, pref.ranks[job.title]) : null
			var/ranks = branch_rank[player_branch.name] || mil_branches.spawn_ranks(player_branch.name, S)
			if(!player_rank || !(player_rank.name in ranks))
				player_rank = LAZYLEN(ranks) ? mil_branches.get_rank(player_branch.name, ranks[1]) : null

			// Now make the assignments
			pref.branches[job.title] = player_branch.name
			if(player_rank)
				pref.ranks[job.title] = player_rank.name
			else
				pref.ranks -= job.title
		else
			pref.branches -= job.title
			pref.ranks -= job.title

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return TOPIC_REFRESH

	else if(href_list["toggle_map"])
		var/mapname = href_list["toggle_map"]
		pref.hiding_maps[mapname] = !pref.hiding_maps[mapname]
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
		var/set_job = href_list["set_job"]
		var/set_to
		if(href_list["set_level"])
			set_to = text2num(href_list["set_level"])
		if(href_list["inc_level"])
			set_to = GetCurrentJobLevel(set_job) + text2num(href_list["inc_level"])
			if(set_to < JOB_LEVEL_HIGH)
				set_to = JOB_LEVEL_NEVER
			else if(set_to > JOB_LEVEL_NEVER)
				set_to = JOB_LEVEL_HIGH
		if(SetJob(user, set_job, set_to))
			return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["char_branch"])
		var/datum/job/job = locate(href_list["checking_job"])
		if(istype(job))
			var/datum/species/S = preference_species()
			var/list/options = job.allowed_branches ? job.get_branch_rank(S) : mil_branches.spawn_branches(S)
			var/choice = input(user, "Choose your branch of service.", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in options
			if(choice && CanUseTopic(user) && mil_branches.is_spawn_branch(choice, S))
				pref.branches[job.title] = choice
				pref.ranks -= job.title
				pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// Check our skillset is still valid
				validate_branch_and_rank()
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)
			return TOPIC_REFRESH

	else if(href_list["char_rank"])
		var/datum/job/job = locate(href_list["checking_job"])
		if(istype(job))
			var/datum/mil_branch/branch = mil_branches.get_branch(pref.branches[job.title])
			var/datum/species/S = preference_species()
			var/list/branch_rank = job.allowed_branches ? job.get_branch_rank(S) : mil_branches.spawn_branches(S)
			var/list/options = branch_rank[branch.name] || mil_branches.spawn_ranks(branch.name, S)
			var/choice = input(user, "Choose your rank.", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in options
			if(choice && CanUseTopic(user) && mil_branches.is_spawn_rank(branch.name, choice, preference_species()))
				pref.ranks[job.title] = choice
				pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// Check our skillset is still valid
				validate_branch_and_rank()
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)
			return TOPIC_REFRESH
	else if(href_list["set_skills"])
		var/rank = href_list["set_skills"]
		var/datum/job/job = SSjobs.get_by_title(rank, TRUE)
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
		panel.set_content(generate_skill_content(J))
		panel.open()
		return TOPIC_REFRESH

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
		var/datum/job/job = SSjobs.get_by_title(rank)

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
		if(config.wiki_url)
			dat += "<a href='?src=\ref[src];job_wiki=[rank]'>Open wiki page in browser</a>"

		var/description = job.get_description_blurb()
		if(description)
			dat += html_encode(description)
		var/datum/browser/popup = new(user, "Job Info", "[capitalize(rank)]", 430, 520, src)
		popup.set_content(jointext(dat,"<br>"))
		popup.open()

	else if(href_list["job_wiki"])
		var/rank = href_list["job_wiki"]
		send_link(user,"[config.wiki_url][rank]")

	return ..()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role, level)

	level = clamp(level, JOB_LEVEL_HIGH, JOB_LEVEL_NEVER)
	var/datum/job/job = SSjobs.get_by_title(role, TRUE)
	if(!job)
		return 0

	if(role == GLOB.using_map.default_assistant_title)
		if(level == JOB_LEVEL_NEVER)
			pref.job_low -= job.title
		else
			pref.job_low |= job.title
		return 1

	SetJobDepartment(job, level)

	return 1

/datum/category_item/player_setup_item/occupation/proc/GetCurrentJobLevel(var/job_title)
	if(pref.job_high == job_title)
		. = JOB_LEVEL_HIGH
	else if(job_title in pref.job_medium)
		. = JOB_LEVEL_MEDIUM
	else if(job_title in pref.job_low)
		. = JOB_LEVEL_LOW
	else
		. = JOB_LEVEL_NEVER

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0

	var/current_level = GetCurrentJobLevel(job.title)

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

	for(var/job_type in SSjobs.types_to_datums)
		var/datum/job/job = SSjobs.types_to_datums[job_type]
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
	prune_job_prefs()
	validate_branch_and_rank()

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_high = null
	pref.job_medium = list()
	pref.job_low = list()
	pref.player_alt_titles.Cut()
	pref.branches = list()
	pref.ranks = list()
	validate_branch_and_rank()

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title

#undef JOB_LEVEL_NEVER
#undef JOB_LEVEL_LOW
#undef JOB_LEVEL_MEDIUM
#undef JOB_LEVEL_HIGH
