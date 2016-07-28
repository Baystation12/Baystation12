//Shamelessly copied over form occupation.dm, needs cleaning up
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
		var/choice = input(user, "Choose your branch of service.", "Character Preference", pref.char_branch) as null|anything in BRANCHES_SCG
		if(choice && CanUseTopic(user))
			pref.char_branch = choice
			pref.char_rank = "Unset"
			return TOPIC_REFRESH

	else if(href_list["char_rank"])
		var/choice
		if(pref.char_branch == BRANCH_SCG_FLEET || pref.char_branch == BRANCH_SCG_EXPCORP)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in RANKS_SCG_FLEET
		else if(pref.char_branch == BRANCH_SCG_MARINE)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in RANKS_SCG_MARINE
		else if(pref.char_branch == BRANCH_SCG_CIVILIAN)
			choice = input(user, "Choose your rank.", "Character Preference", pref.char_rank) as null|anything in RANKS_SCG_CIVILIAN

		if(choice && CanUseTopic(user))
			pref.char_rank = choice
			return TOPIC_REFRESH

	return ..()