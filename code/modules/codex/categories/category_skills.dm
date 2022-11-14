/datum/codex_category/skills
	name = "Skills"
	desc = "Certifiable skills."

//SKILLTODO: HATE CODEX HARDER
/datum/codex_category/skills/Initialize()
	for(var/singleton/skill/skill as anything in GLOB.skills.skills)
		var/list/skill_info = list()
		if(skill.prerequisites)
			var/list/reqs = list()
			for(var/req in skill.prerequisites)//SKILLTODO: FIX THIS
				var/singleton/skill/skill_req = GET_SINGLETON(req)
				reqs += "[skill_req.levels[skill.prerequisites[req]]] [skill_req.name]"
			skill_info += "Prerequisites: [english_list(reqs)]"
		for(var/level in skill.levels)
			skill_info += "<h4>[level]</h4>[skill.levels[level]]"
		var/datum/codex_entry/entry = new(_display_name = lowertext(trim("[skill.name] (skill)")), _lore_text = skill.desc, _mechanics_text = jointext(skill_info, "<br>"))
		SScodex.add_entry_by_string(entry.display_name, entry)
		SScodex.add_entry_by_string(skill.name, entry)
		items += skill.name
	..()
