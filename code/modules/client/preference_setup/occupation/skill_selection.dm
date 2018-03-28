//These procs convert to/from static save-data formats.

/datum/category_item/player_setup_item/occupation/proc/load_skills()
	if(!length(GLOB.skills))
		decls_repository.get_decl(/decl/hierarchy/skill)

	pref.skills_allocated = list()
	var/jobs_by_type = decls_repository.get_decls(GLOB.using_map.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type[job_type]
		if("[job.type]" in pref.skills_saved)
			var/S = pref.skills_saved["[job.type]"]
			var/L = list()
			for(var/decl/hierarchy/skill/skill in GLOB.skills)
				if("[skill.type]" in S)
					L[skill] = S["[skill.type]"]
			if(length(L))
				pref.skills_allocated[job] = L

/datum/category_item/player_setup_item/occupation/proc/save_skills()
	pref.skills_saved = list()
	for(var/datum/job/job in pref.skills_allocated)
		var/S = pref.skills_allocated[job]
		var/L = list()
		for(var/decl/hierarchy/skill/skill in S)
			L["[skill.type]"] = S[skill]
		if(length(L))
			pref.skills_saved["[job.type]"] = L

//Sets up skills_allocated
/datum/preferences/proc/sanitize_skills(var/list/input)
	. = list()
	var/datum/species/S = all_species[species]
	var/jobs_by_type = decls_repository.get_decls(GLOB.using_map.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type[job_type]
		var/input_skills = list()
		if((job in input) && istype(input[job], /list))
			input_skills = input[job]

		var/L = list()
		var/sum = 0
		
		for(var/decl/hierarchy/skill/skill in GLOB.skills)
			if(skill in input_skills)
				var/min = job.min_skill[skill.type] || SKILL_MIN
				var/max = max(min, job.max_skill[skill.type] || SKILL_MAX)
				var/spent = sanitize_integer(input_skills[skill], 0, max - min, 0) 
				if(spent)						//Only include entries with nonzero spent points
					L[skill] = spent 
					sum += spent

		points_by_job[job] = job.skill_points							//We compute how many points we had.
		if(!job.no_skill_buffs)
			points_by_job[job] += S.skills_from_age(age)				//Applies the species-appropriate age modifier.
			points_by_job[job] += S.job_skill_buffs[job.type]			//Applies the per-job species modifier, if any.

		if((points_by_job[job] >= sum) && sum)				//we didn't overspend, so use sanitized imported data
			.[job] = L
			points_by_job[job] -= sum						//if we overspent, or did no spending, default to not including the job at all

/datum/category_item/player_setup_item/occupation/proc/update_skill_value(datum/job/job, decl/hierarchy/skill/S, new_value)
	var/min = job.min_skill[S.type] || SKILL_MIN
	var/max = max(min, job.max_skill[S.type] || SKILL_MAX)
	if(new_value == min)
		if(job in pref.skills_allocated)
			var/T = pref.skills_allocated[job]
			if(S in T)
				pref.points_by_job[job] += T[S]			  //Updating the points available
				T -= S								  //And we no longer need this entry
			if(!length(T))
				pref.skills_allocated -= job		  //Don't keep track of a job with no allocation
	else
		if(!(job in pref.skills_allocated))
			pref.skills_allocated[job] = list()
		var/T = pref.skills_allocated[job]
		var/current_value = min + (T[S] || 0)

		if(!isnum(new_value) || (round(new_value) != new_value))
			return											//Checks to make sure we were fed an integer.
		if((new_value < min) || (new_value > max) || (pref.points_by_job[job] + current_value - new_value < 0))
			return											//Checks if the new value is actually allowed.
															//None of this should happen normally, but this avoids client attacks.
		pref.points_by_job[job] += (current_value - new_value)
		T[S] = new_value - min								//skills_allocated stores the difference from job minimum

/datum/category_item/player_setup_item/occupation/proc/generate_skill_content(datum/job/job)
	var/allocation = list()
	if(job in pref.skills_allocated)
		allocation = pref.skills_allocated[job]

	var/dat  = list()
	dat += "<body>"
	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
	dat += "<style>.Unavailable{background: #d09000}</style>"
	dat += "<tt><center>"
	dat += "<b>Skill points remaining: [pref.points_by_job[job]].</b><hr>"
	dat += "<hr>"
	dat += "</center></tt>"
	
	dat += "<table>"
	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
	for(var/decl/hierarchy/skill/cat in skill.children)
		dat += "<tr><th colspan = 4><b>[cat.name]</b>"
		dat += "</th></tr>"
		for(var/decl/hierarchy/skill/S in cat.children)
			var/min = job.min_skill[S.type] || SKILL_MIN
			var/max = max(min, job.max_skill[S.type] || SKILL_MAX)
			var/level = min + (allocation[S] || 0)				//the current skill level
			var/cap   = min(max, level + pref.points_by_job[job]) //if selecting the skill would make you overspend, it won't be shown
			dat += "<tr style='text-align:left;'>"
			dat += "<th><a href='?src=\ref[src];skillinfo=\ref[S]'>[S.name]</a></th>"
			for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
				dat += skill_to_button(S, job, level, i, min, cap)
			dat += "</tr>"
	dat += "</table>"
	return jointext(dat,null)

/datum/category_item/player_setup_item/occupation/proc/open_skill_setup(mob/user, datum/job/job)
	panel = new(user, "Skill Selection: [job.title]", "Skill Selection: [job.title]", 650, 850, src)
	panel.set_content(generate_skill_content(job))
	panel.open()

/datum/category_item/player_setup_item/proc/skill_to_button(decl/hierarchy/skill/skill, datum/job/job, current_level, selection_level, min, max)
	var/level_name = skill.level_names[selection_level]
	if(selection_level < min)
		return "<th><span class='Unavailable'>[level_name]</span></th>"
	else if(selection_level < current_level)
		return "<th><a class='Current' href='?src=\ref[src];hit_skill_button=\ref[skill];at_job=\ref[job];newvalue=[selection_level]'>[level_name]</a></th>"
	else if(selection_level == current_level)
		return "<th><span class='Current'>[level_name]</span></th>"
	else if(selection_level <= max)
		return "<th><a class='Selectable' href='?src=\ref[src];hit_skill_button=\ref[skill];at_job=\ref[job];newvalue=[selection_level]'>[level_name]</a></th>"
	else
		return "<th><span class='Toohigh'>[level_name]</span></th>"
