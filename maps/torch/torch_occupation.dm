//Shamelessly copied over form occupation.dm, needs cleaning up
/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	S["alternate_option"]	>> pref.alternate_option
	S["job_high"]	>> pref.job_high
	S["job_medium"]	>> pref.job_medium
	S["job_low"]	>> pref.job_low
	if(!pref.job_medium)
		pref.job_medium = list()
	if(!pref.job_low)
		pref.job_low = list()
	S["player_alt_titles"]	>> pref.player_alt_titles
	S["char_branch"] 			>> pref.char_branch
	S["char_rank"] 				>> pref.char_rank
/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	S["alternate_option"]	<< pref.alternate_option
	S["job_high"]	<< pref.job_high
	S["job_medium"]	<< pref.job_medium
	S["job_low"]	<< pref.job_low
	S["player_alt_titles"]	<< pref.player_alt_titles
	S["char_branch"] 			<< pref.char_branch
	S["char_rank"] 				<< pref.char_rank

/datum/category_item/player_setup_item/occupation/sanitize_character()
	pref.alternate_option	= sanitize_integer(pref.alternate_option, 0, 2, initial(pref.alternate_option))
	pref.job_high	        = sanitize(pref.job_high, null)
	if(pref.job_medium && pref.job_medium.len)
		for(var/i in 1 to pref.job_medium.len)
			pref.job_medium[i]  = sanitize(pref.job_medium[i])
	if(pref.job_low && pref.job_low.len)
		for(var/i in 1 to pref.job_low.len)
			pref.job_low[i]  = sanitize(pref.job_low[i])
	if(!pref.player_alt_titles) pref.player_alt_titles = new()

	if(!job_master)
		return

	if(!pref.char_branch)
		pref.char_branch = "Unset"
	if(!pref.char_rank)
		pref.char_rank = "Unset"

	for(var/datum/job/job in job_master.occupations)
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitJobs, splitLimit = 1)
	if(!job_master)
		return

	. = list()
	. += "<tt><center>"
	. += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br>"
	. += "Branch of Service: <a href='?src=\ref[src];char_branch=1'>[pref.char_branch]</a>	Rank: <a href='?src=\ref[src];char_rank=1'>[pref.char_rank]</a><br/>"
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
		if(!(pref.char_rank in job.allowed_ranks))
			. += "<del>[rank]</del></td><td><b> \[NOT AVAILABLE]</b></td></tr>"
			continue
		if(("Assistant" in pref.job_low) && (rank != "Assistant"))
			. += "<font color=grey>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
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
		var/choice = input(user, "Choose your branch of service.", "Character Preference", pref.char_branch) as null|anything in SCG_BRANCHES
		if(choice && CanUseTopic(user))
			pref.char_branch = choice
			pref.char_rank = "Unset"
			return TOPIC_REFRESH

	else if(href_list["char_rank"])
		var/choice
		if(pref.char_branch == SCG_FLEET || pref.char_branch == SCG_EXP_CORP)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in SCG_RANKS_FLEET
		else if(pref.char_branch == SCG_MARINE)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in SCG_RANKS_MARINE
		else if(pref.char_branch == SCG_CIVILIAN)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in SCG_RANKS_CIVILIAN

		if(choice && CanUseTopic(user))
			pref.char_rank = choice
			return TOPIC_REFRESH

	return ..()