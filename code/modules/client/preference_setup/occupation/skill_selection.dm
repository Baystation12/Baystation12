/datum/preferences
	var/list/skills_saved	 	= list()	   //List of /datum/job paths, with values (lists of "/decl/hierarchy/skill" , with values saved skill points spent). Should only include entries with nonzero spending.
	var/list/skills_allocated	= list()	   //Same as above, but using instances rather than path strings for both jobs and skills.
	var/list/points_by_job		= list()	   //List of jobs, with value the number of free skill points remaining

/datum/preferences/proc/get_max_skill(datum/job/job, decl/hierarchy/skill/S)
	var/min = get_min_skill(job, S)
	if(job && job.max_skill)
		. = job.max_skill[S.type]
	if(!.)
		. = S.default_max
	if(!.)
		. = SKILL_MAX
	. = max(min, .)

/datum/preferences/proc/get_total_skill_value(datum/job/job, decl/hierarchy/skill/req_skill)
	if(!(job in skills_allocated))
		return get_min_skill(job, req_skill)
	var/allocated = skills_allocated[job]
	if(req_skill in allocated)
		return allocated[req_skill] + get_min_skill(job, req_skill)

/datum/preferences/proc/get_min_skill(datum/job/job, decl/hierarchy/skill/S)
	if(job && job.min_skill)
		. = job.min_skill[S.type]
	if(!.)
		var/datum/mil_branch/branch = mil_branches.get_branch(branches[job.title])
		if(branch && branch.min_skill)
			. = branch.min_skill[S.type]
	if(!.)
		. = SKILL_MIN

/datum/preferences/proc/get_spent_points(datum/job/job, decl/hierarchy/skill/S)
	if(!(job in skills_allocated))
		return 0
	var/allocated = skills_allocated[job]
	if(!(S in allocated))
		return 0
	var/min = get_min_skill(job, S)
	return get_level_cost(job, S, min + allocated[S])

/datum/preferences/proc/get_level_cost(datum/job/job, decl/hierarchy/skill/S, level)
	var/min = get_min_skill(job, S)
	. = 0
	for(var/i=min+1, i <= level, i++)
		. += S.get_cost(i)

/datum/preferences/proc/get_max_affordable(datum/job/job, decl/hierarchy/skill/S)
	var/current_level = get_min_skill(job, S)
	var/allocation = skills_allocated[job]
	if(allocation && allocation[S])
		current_level += allocation[S]
	var/max = get_max_skill(job, S)
	var/budget = points_by_job[job]
	. = max
	for(var/i=current_level+1, i <= max, i++)
		if(budget - S.get_cost(i) < 0)
			return i-1
		budget -= S.get_cost(i)

//These procs convert to/from static save-data formats.
/datum/category_item/player_setup_item/occupation/proc/load_skills()
	if(!length(GLOB.skills))
		decls_repository.get_decl(/decl/hierarchy/skill)

	pref.skills_allocated = list()
	for(var/job_type in SSjobs.types_to_datums)
		var/datum/job/job = SSjobs.get_by_path(job_type)
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
	for(var/job_name in SSjobs.titles_to_datums)
		var/datum/job/job = SSjobs.get_by_title(job_name)
		var/input_skills = list()
		if((job in input) && istype(input[job], /list))
			input_skills = input[job]

		var/L = list()
		var/sum = 0

		for(var/decl/hierarchy/skill/skill in GLOB.skills)
			if(skill in input_skills)
				var/min = get_min_skill(job, skill)
				var/max = get_max_skill(job, skill)
				var/level = sanitize_integer(input_skills[skill], 0, max - min, 0)
				var/spent = get_level_cost(job, skill, min + level)
				if(spent)						//Only include entries with nonzero spent points
					L[skill] = level
					sum += spent

		points_by_job[job] = job.skill_points							//We compute how many points we had.
		if(!job.no_skill_buffs)
			points_by_job[job] += S.skills_from_age(age)				//Applies the species-appropriate age modifier.
			points_by_job[job] += S.job_skill_buffs[job.type]			//Applies the per-job species modifier, if any.

		if((points_by_job[job] >= sum) && sum)				//we didn't overspend, so use sanitized imported data
			.[job] = L
			points_by_job[job] -= sum						//if we overspent, or did no spending, default to not including the job at all
		purge_skills_missing_prerequisites(job)

/datum/preferences/proc/check_skill_prerequisites(datum/job/job, decl/hierarchy/skill/S)
	if(!S.prerequisites)
		return TRUE
	for(var/skill_type in S.prerequisites)
		var/decl/hierarchy/skill/prereq = decls_repository.get_decl(skill_type)
		var/value = get_min_skill(job, prereq) + LAZYACCESS(skills_allocated[job], prereq)
		if(value < S.prerequisites[skill_type])
			return FALSE
	return TRUE

/datum/preferences/proc/purge_skills_missing_prerequisites(datum/job/job)
	var/allocation = skills_allocated[job]
	if(!allocation)
		return
	for(var/decl/hierarchy/skill/S in allocation)
		if(!check_skill_prerequisites(job, S))
			clear_skill(job, S)
			.() // restart checking from the beginning, as after doing this we don't know whether what we've already checked is still fine.
			return

/datum/preferences/proc/clear_skill(datum/job/job, decl/hierarchy/skill/S)
	if(job in skills_allocated)
		var/min = get_min_skill(job,S)
		var/T = skills_allocated[job]
		var/freed_points = get_level_cost(job, S, min+T[S])
		points_by_job[job] += freed_points
		T -= S								  //And we no longer need this entry
		if(!length(T))
			skills_allocated -= job		  //Don't keep track of a job with no allocation

/datum/category_item/player_setup_item/occupation/proc/update_skill_value(datum/job/job, decl/hierarchy/skill/S, new_level)
	if(!isnum(new_level) || (round(new_level) != new_level))
		return											//Checks to make sure we were fed an integer.
	if(!pref.check_skill_prerequisites(job, S))
		return
	var/min = pref.get_min_skill(job,S)

	if(new_level == min)
		pref.clear_skill(job, S)
		pref.purge_skills_missing_prerequisites(job)
		return

	var/max = pref.get_max_skill(job,S)
	if(!(job in pref.skills_allocated))
		pref.skills_allocated[job] = list()
	var/list/T = pref.skills_allocated[job]
	var/current_value = pref.get_level_cost(job, S, min+T[S])
	var/new_value = pref.get_level_cost(job, S, new_level)

	if((new_level < min) || (new_level > max) || (pref.points_by_job[job] + current_value - new_value < 0))
		return											//Checks if the new value is actually allowed.
														//None of this should happen normally, but this avoids client attacks.
	pref.points_by_job[job] += (current_value - new_value)
	T[S] = new_level - min								//skills_allocated stores the difference from job minimum
	pref.purge_skills_missing_prerequisites(job)

/datum/category_item/player_setup_item/occupation/proc/generate_skill_content(datum/job/job)
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
			dat += get_skill_row(job, S)
			for(var/decl/hierarchy/skill/perk in S.children)
				dat += get_skill_row(job, perk)
	dat += "</table>"
	return JOINTEXT(dat)

/datum/category_item/player_setup_item/occupation/proc/get_skill_row(datum/job/job, decl/hierarchy/skill/S)
	var/list/dat = list()
	var/min = pref.get_min_skill(job,S)
	var/level = min + (pref.skills_allocated[job] ? pref.skills_allocated[job][S] : 0)				//the current skill level
	var/cap = pref.get_max_affordable(job, S) //if selecting the skill would make you overspend, it won't be shown
	dat += "<tr style='text-align:left;'>"
	dat += "<th><a href='?src=\ref[src];skillinfo=\ref[S]'>[S.name] ([pref.get_spent_points(job, S)])</a></th>"
	for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
		dat += skill_to_button(S, job, level, i, min, cap)
	dat += "</tr>"
	return JOINTEXT(dat)

/datum/category_item/player_setup_item/occupation/proc/open_skill_setup(mob/user, datum/job/job)
	panel = new(user, "skill-selection", "Skill Selection: [job.title]", 770, 850, src)
	panel.set_content(generate_skill_content(job))
	panel.open()

/datum/category_item/player_setup_item/occupation/proc/skill_to_button(decl/hierarchy/skill/skill, datum/job/job, current_level, selection_level, min, max)
	var/offset = skill.prerequisites ? skill.prerequisites[skill.parent.type] - 1 : 0
	var/effective_level = selection_level - offset
	if(effective_level <= 0 || effective_level > length(skill.levels))
		return "<th></th>"
	var/level_name = skill.levels[effective_level]
	var/cost = skill.get_cost(effective_level)
	var/button_label = "[level_name] ([cost])"
	if(effective_level < min)
		return "<th><span class='Unavailable'>[button_label]</span></th>"
	else if(effective_level < current_level)
		return "<th>[add_link(skill, job, button_label, "'Current'", effective_level)]</th>"
	else if(effective_level == current_level)
		return "<th><span class='Current'>[button_label]</span></th>"
	else if(effective_level <= max)
		return "<th>[add_link(skill, job, button_label, "'Selectable'", effective_level)]</th>"
	else
		return "<th><span class='Toohigh'>[button_label]</span></th>"

/datum/category_item/player_setup_item/occupation/proc/add_link(decl/hierarchy/skill/skill, datum/job/job, text, style, value)
	if(pref.check_skill_prerequisites(job, skill))
		return "<a class=[style] href='?src=\ref[src];hit_skill_button=\ref[skill];at_job=\ref[job];newvalue=[value]'>[text]</a>"
	return text