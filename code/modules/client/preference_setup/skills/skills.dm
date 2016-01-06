/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	S["skills"]					>> pref.skills
	S["used_skillpoints"]		>> pref.used_skillpoints
	S["skill_specialization"]	>> pref.skill_specialization

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	S["skills"]					<< pref.skills
	S["used_skillpoints"]		<< pref.used_skillpoints
	S["skill_specialization"]	<< pref.skill_specialization

/datum/category_item/player_setup_item/skills/sanitize_character()
	if(SKILLS == null)				setup_skills()
	if(!pref.skills)				pref.skills = list()
	if(!pref.skills.len)			pref.ZeroSkills()
	if(pref.used_skillpoints < 0)	pref.used_skillpoints = 0

/datum/category_item/player_setup_item/skills/content()
	. += "<b>Select your Skills</b><br>"
	. += "Current skill level: <b>[pref.GetSkillClass(pref.used_skillpoints)]</b> ([pref.used_skillpoints])<br>"
	. += "<a href='?src=\ref[src];preconfigured=1'>Use preconfigured skillset</a><br>"
	. += "<table>"
	for(var/V in SKILLS)
		. += "<tr><th colspan = 5><b>[V]</b>"
		. += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = pref.skills[S.ID]
			. += "<tr style='text-align:left;'>"
			. += "<th><a href='?src=\ref[src];skillinfo=\ref[S]'>[S.name]</a></th>"
			. += "<th><a href='?src=\ref[src];setskill=\ref[S];newvalue=[SKILL_NONE]'><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></a></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				. += "<th></th>"
			else
				. += "<th><a href='?src=\ref[src];setskill=\ref[S];newvalue=[SKILL_BASIC]'><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></a></th>"
			. += "<th><a href='?src=\ref[src];setskill=\ref[S];newvalue=[SKILL_ADEPT]'><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></a></th>"
			. += "<th><a href='?src=\ref[src];setskill=\ref[S];newvalue=[SKILL_EXPERT]'><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></a></th>"
			. += "</tr>"
	. += "</table>"

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["skillinfo"])
		var/datum/skill/S = locate(href_list["skillinfo"])
		var/HTML = "<b>[S.name]</b><br>[S.desc]"
		user << browse(HTML, "window=\ref[user]skillinfo")
		return TOPIC_HANDLED

	else if(href_list["setskill"])
		var/datum/skill/S = locate(href_list["setskill"])
		var/value = text2num(href_list["newvalue"])
		pref.skills[S.ID] = value
		pref.CalculateSkillPoints()
		return TOPIC_REFRESH

	else if(href_list["preconfigured"])
		var/selected = input(user, "Select a skillset", "Skillset") as null|anything in SKILL_PRE
		if(!selected && !CanUseTopic(user)) return

		pref.ZeroSkills(1)
		for(var/V in SKILL_PRE[selected])
			if(V == "field")
				pref.skill_specialization = SKILL_PRE[selected]["field"]
				continue
			pref.skills[V] = SKILL_PRE[selected][V]
		pref.CalculateSkillPoints()

		return TOPIC_REFRESH

	else if(href_list["setspecialization"])
		pref.skill_specialization = href_list["setspecialization"]
		pref.CalculateSkillPoints()
		return TOPIC_REFRESH

	return ..()
