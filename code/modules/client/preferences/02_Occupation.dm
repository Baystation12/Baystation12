#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

datum/preferences/proc/contentOccupation()
	var/data = {"

		<html><body>

		<nav class='vNav'>
		<ul>
		<li><a href='?src=\ref[src];page=1'>Character</a>
		<li><a class='active' href='?src=\ref[src];page=2'>Occupation</a>
		<li><a href='?src=\ref[src];page=3'>Loadout</a>
		<li><a href='?src=\ref[src];page=4'>Local Preferences</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=9'>Records</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=8'>Global Preferences</a>
		</ul>
		</nav>

		<nav class='hNav'>
		<ul>
		<li><a href='?src=\ref[src];save=1'>Save</a>
		<li><a href='?src=\ref[src];load=1'>Load</a>
		<li><a href='?src=\ref[src];delete=1'>Reset</a>
		<li><a href='?src=\ref[src];lock=1'>Lock</a>
		</ul>
		</nav>

		<div class='main' style='width:650px; font-size: medium;'>
		"}
	if(!job_master)
		return

	var/datum/mil_branch/player_branch = null
	var/datum/mil_rank/player_rank = null

	data += "<tt><center>"
	data += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br>"
	if(GLOB.using_map.flags & MAP_HAS_BRANCH)

		player_branch = mil_branches.get_branch(char_branch)

		data += "Department of Service: <a href='?src=\ref[src];char_department=1'>[char_department]</a>	"
	if(GLOB.using_map.flags & MAP_HAS_RANK)
		player_rank = mil_branches.get_rank(char_branch, char_rank)

		data += "Rank: <a href='?src=\ref[src];char_rank=1'>[char_rank]</a>	"
	data += "<br>"
	data += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more columns.
	data += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1
	var/limit = round((job_master.occupations.len+1)/2)
	var/list/splitJobs = list()
	for(var/datum/job/job in job_master.occupations)
		if(job.department_flag & COM || job.title == "AI")
			splitJobs += job

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
					data += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			data += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		data += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		lastJob = job
		if(job.total_positions == 0 && job.spawn_positions == 0)
			data += "<del>[rank]</del></td><td><b> \[UNAVAILABLE]</b></td></tr>"
			continue
		if(jobban_isbanned(usr, rank))
			data += "<del>[rank]</del></td><td><b> \[BANNED]</b></td></tr>"
			continue
		if(!job.player_old_enough(usr.client))
			var/available_in_days = job.available_in_days(usr.client)
			data += "<del>[rank]</del></td><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		if(job.minimum_character_age && usr.client && (usr.client.prefs.age < job.minimum_character_age))
			data += "<del>[rank]</del></td><td> \[MINIMUM CHARACTER AGE: [job.minimum_character_age]]</td></tr>"
			continue
		if(job.allowed_branches)
			if(!player_branch)
				data += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_branches=[rank]'><b> \[BRANCH RESTRICTED]</b></a></td></tr>"
				continue
			if(!is_type_in_list(player_branch, job.allowed_branches))
				data += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_branches=[rank]'><b> \[NOT FOR [player_branch.name_short]]</b></a></td></tr>"
				continue

		if(job.allowed_ranks)
			if(!player_rank)
				data += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_ranks=[rank]'><b> \[RANK RESTRICTED]</b></a></td></tr>"
				continue

			if(!is_type_in_list(player_rank, job.allowed_ranks))
				data += "<del>[rank]</del></td><td><a href='?src=\ref[src];show_ranks=[rank]'><b> \[NOT FOR [player_rank.name_short || player_rank.name]]</b></a></td></tr>"
				continue

		if(("Assistant" in job_low) && (rank != "Assistant"))
			data += "<font color=grey>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			data += "<b>[rank]</b>"
		else
			data += "[rank]"

		data += "</td><td width='40%'>"

		data += "<a href='?src=\ref[src];set_job=[rank]'>"

		if(rank == "Assistant")//Assistant is special
			if("Assistant" in job_low)
				data += " <font color=55cc55>\[Yes]</font>"
			else
				data += " <font color=black>\[No]</font>"
			if(job.alt_titles) //Blatantly cloned from a few lines down.
				data += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[GetPlayerAltTitle(job)]\]</a></td></tr>"
			data += "</a></td></tr>"
			continue

		if(job_high == job.title)
			data += " <font color=55cc55>\[High]</font>"
		else if(job.title in job_medium)
			data += " <font color=eecc22>\[Medium]</font>"
		else if(job.title in job_low)
			data += " <font color=cc5555>\[Low]</font>"
		else
			data += " <font color=black>\[NEVER]</font>"
		if(job.alt_titles)
			data += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[GetPlayerAltTitle(job)]\]</a></td></tr>"
		data += "</a></td></tr>"
	data += "</td'></tr></table>"
	data += "</center></table><center>"

	switch(alternate_option)
		if(GET_RANDOM_JOB)
			data += "<u><a href='?src=\ref[src];job_alternative=1'>Get random job if preferences unavailable</a></u>"
		if(BE_ASSISTANT)
			data += "<u><a href='?src=\ref[src];job_alternative=1'>Be assistant if preference unavailable</a></u>"
		if(RETURN_TO_LOBBY)
			data += "<u><a href='?src=\ref[src];job_alternative=1'>Return to lobby if preference unavailable</a></u>"

	data += "<a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	data += "</tt>"
	data += {"

		</div>

		<div class='secondary'>
		</div>

		<div class='background'>
		</div>

		</body></html>

		"}

	return data

/datum/preferences/proc/Topic2(var/href, var/list/href_list)
	if(href_list["page"])
		selected_menu = text2num(href_list["page"])

	else if(href_list["reset_jobs"])
		ResetJobs()

	else if(href_list["job_alternative"])
		if(alternate_option == GET_RANDOM_JOB || alternate_option == BE_ASSISTANT)
			alternate_option += 1
		else if(alternate_option == RETURN_TO_LOBBY)
			alternate_option = 0

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = input("Choose an title for [job.title].", "Choose Title", GetPlayerAltTitle(job)) as anything in choices|null
			if(choice && CanUseTopic(usr))
				SetPlayerAltTitle(job, choice)

	else if(href_list["set_job"])
		SetJob(usr, href_list["set_job"])

	else if(href_list["char_department"])
		var/new_department = input(user, "Select the department your character wishes to enlist in","Department enlistment", char_department) in list("Security","Medical","Engineering","Service","Science","Supply")
		if(new_department && CanUseTopic(user))
			char_department = new_department

	else if(href_list["char_branch"])
		var/choice = input(usr, "Choose your branch of service.", "Character Preference", char_branch) as null|anything in mil_branches.spawn_branches
		if(choice && CanUseTopic(usr))
			char_branch = choice
			char_rank = "None"
			prune_job_prefs_for_rank()

	else if(href_list["char_rank"])
		var/choice = null
		var/datum/mil_branch/current_branch = mil_branches.get_branch(char_branch)

		if(current_branch)
			choice = input(usr, "Choose your rank.", "Character Preference", char_rank) as null|anything in current_branch.spawn_ranks

		if(choice && CanUseTopic(usr))
			char_rank = choice
			prune_job_prefs_for_rank()

	else if(href_list["show_branches"])
		var/rank = href_list["show_branches"]
		var/datum/job/job = job_master.GetJob(rank)
		to_chat(usr, "<span clas='notice'>Valid branches for [rank]: [job.get_branches()]</span>")
	else if(href_list["show_ranks"])
		var/rank = href_list["show_ranks"]
		var/datum/job/job = job_master.GetJob(rank)
		to_chat(usr, "<span clas='notice'>Valid ranks for [rank] ([char_branch]): [job.get_ranks(char_branch)]</span>")
	else
		return 0

	ShowChoices(usr)
	return