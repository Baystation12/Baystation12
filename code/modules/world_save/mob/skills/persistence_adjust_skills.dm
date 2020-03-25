#define P_STARTING_SKILL_POINTS 50

/datum/skillset
	var/points_remaining = P_STARTING_SKILL_POINTS
	var/time_skills_set								 // Players get three days to finalize the skills of their characters.

/datum/skillset/proc/set_skillset_min()				 // Outside of Persistence skills are tied to job preferences, so this should be kept here.
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		skill_list[S.type] = SKILL_MIN
	on_levels_change()

/mob/living/verb/adjust_skills()
	set category = "IC"
	set name = "Adjust your skills"

	adjust_skills_ui()

/mob/living/proc/adjust_skills_ui()
	if(world.realtime <= (skillset.time_skills_set + 3 DAYS))
		var/datum/browser/panel = new(usr, "skill_selection", "Skill Selection: [src.name]", 770, 850, src)
		panel.set_content(p_generate_skill_content(src))
		panel.open()
	else
		to_chat(src, SPAN_WARNING("You can no longer adjust your skills!"))

/mob/living/OnSelfTopic(href_list)
	if(href_list["hit_skill_button"])
		var/decl/hierarchy/skill/S = locate(href_list["hit_skill_button"])
		if(!istype(S))
			return TOPIC_HANDLED
		var/value = text2num(href_list["newvalue"])
		p_update_skill_value(S, usr.skillset, value)
		adjust_skills_ui() // Refresh
		return TOPIC_HANDLED

	else if(href_list["skillinfo"])
		var/decl/hierarchy/skill/S = locate(href_list["skillinfo"])
		if(!istype(S))
			return TOPIC_HANDLED
		var/HTML = list()
		HTML += "<h2>[S.name]</h2>"
		HTML += "[S.desc]<br>"
		var/i
		for(i=1, i <= length(S.levels), i++)
			var/level_name = S.levels[i]
			HTML +=	"<br><b>[level_name]</b>: [S.levels[level_name]]<br>"
		show_browser(usr, jointext(HTML, null), "window=\ref[usr]skillinfo")
		return TOPIC_HANDLED

	return ..()

// Largely taken from skill_selection.dm. Modified to remove references to jobs.
/proc/p_generate_skill_content(var/mob/living/M)
	var/dat = list()
	var/datum/skillset/SS = M.skillset
	var/time_left = (SS.time_skills_set + 3 DAYS) - world.realtime  // time2text does not properly convert these adjusted numbers, so we have to do it manually.
	var/hours = num2text(time_left/10/60/60, 2)
	var/minutes = num2text((time_left/10/60)%60, 2)
	dat += "<body>"
	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
	dat += "<style>.Unavailable{background: #d09000}</style>"
	dat += "<tt><center>"
	dat += "<b>Skill points remaining: [SS.points_remaining].</b><hr>"
	dat += "<b>Time before finalization: [hours]:[minutes]</b><hr>"
	dat += "<hr>"
	dat += "</center></tt>"

	dat += "<table>"
	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
	for(var/decl/hierarchy/skill/cat in skill.children)
		dat += "<tr><th colspan = 4><b>[cat.name]</b>"
		dat += "</th></tr>"
		for(var/decl/hierarchy/skill/S in cat.children)
			dat += p_get_skill_row(M, S, SS)
			for(var/decl/hierarchy/skill/perk in S.children)
				dat += p_get_skill_row(M, perk, SS)
	dat += "</table>"
	return JOINTEXT(dat)

/proc/p_get_skill_row(var/mob/living/usr, decl/hierarchy/skill/S, var/datum/skillset/SS)
	var/list/dat = list()
	var/level = SS.get_value(S.type)	//the current skill level
	var/cap = p_get_max_affordable(S, SS) //if selecting the skill would make you overspend, it won't be shown
	dat += "<tr style='text-align:left;'>"
	dat += "<th><a href='?src=\ref[usr];skillinfo=\ref[S]'>[S.name] ([p_get_spent_points(S, SS)])</a></th>"
	for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
		dat += p_skill_to_button(usr, S, SS, level, i, SKILL_MIN, cap)
	dat += "</tr>"
	return JOINTEXT(dat)

/proc/p_get_max_affordable(decl/hierarchy/skill/S, var/datum/skillset/SS)
	var/current_level = 0
	current_level += SS.get_value(S.type)
	var/max = SKILL_MAX						// Ignoring the natural limits on skills without having the respective job.
	var/budget = SS.points_remaining
	. = max
	for(var/i=current_level+1, i <= max, i++)
		if(budget - S.get_cost(i) < 0)
			return i-1
		budget -= S.get_cost(i)

/proc/p_skill_to_button(var/mob/living/usr, decl/hierarchy/skill/S, var/datum/skillset/SS, current_level, selection_level, min, max)
	var/offset = S.prerequisites ? S.prerequisites[S.parent.type] - 1 : 0
	var/effective_level = selection_level - offset
	if(effective_level <= 0 || effective_level > length(S.levels))
		return "<th></th>"
	var/level_name = S.levels[effective_level]
	var/cost = S.get_cost(effective_level)
	var/button_label = "[level_name] ([cost])"
	if(effective_level < min)
		return "<th><span class='Unavailable'>[button_label]</span></th>"
	else if(effective_level < current_level)
		return "<th>[p_add_skill_link(usr, S, SS, button_label, "'Current'", effective_level)]</th>"
	else if(effective_level == current_level)
		return "<th><span class='Current'>[button_label]</span></th>"
	else if(effective_level <= max)
		return "<th>[p_add_skill_link(usr, S, SS, button_label, "'Selectable'", effective_level)]</th>"
	else
		return "<th><span class='Toohigh'>[button_label]</span></th>"

/proc/p_add_skill_link(var/mob/living/usr, decl/hierarchy/skill/S, var/datum/skillset/SS, text, style, value)
	if(p_check_skill_prerequisites(S, SS))
		return "<a class=[style] href='?src=\ref[usr];hit_skill_button=\ref[S];newvalue=[value]'>[text]</a>"
	return text

/proc/p_get_spent_points(decl/hierarchy/skill/S, var/datum/skillset/SS)
	return p_get_level_cost(S, SS.get_value(S.type))

/proc/p_get_level_cost(decl/hierarchy/skill/S, level)
	. = 0
	for(var/i=SKILL_MIN, i <= level, i++)
		. += S.get_cost(i)

/proc/p_check_skill_prerequisites(decl/hierarchy/skill/S, var/datum/skillset/SS)
	if(!S.prerequisites)
		return TRUE
	for(var/skill_type in S.prerequisites)
		var/decl/hierarchy/skill/prereq = decls_repository.get_decl(skill_type)
		var/value = SKILL_MIN + SS.get_value(prereq.type)
		if(value < S.prerequisites[skill_type])
			return FALSE
	return TRUE

/proc/p_purge_skills_missing_prerequisites(var/datum/skillset/SS)
	for(var/decl/hierarchy/skill/S in SS.skill_list)
		if(!p_check_skill_prerequisites(S, SS))
			p_clear_skill(S, SS)
			.() // restart checking from the beginning, as after doing this we don't know whether what we've already checked is still fine.
			return

/proc/p_clear_skill(decl/hierarchy/skill/S, var/datum/skillset/SS)
	var/freed_points = p_get_level_cost(S, SS.get_value(S.type))
	SS.points_remaining += freed_points
	SS.skill_list[S.type] = SKILL_MIN
	SS.on_levels_change()

proc/p_update_skill_value(decl/hierarchy/skill/S, var/datum/skillset/SS, new_level)
	if(!isnum(new_level) || (round(new_level) != new_level))
		return											//Checks to make sure we were fed an integer.
	if(!p_check_skill_prerequisites(S, SS))
		return

	var/current_value = p_get_level_cost(S, SS.get_value(S.type))
	var/new_value = p_get_level_cost(S, new_level)

	if((new_level < SKILL_MIN) || (new_level > SKILL_MAX) || (SS.points_remaining + current_value - new_value < 0))
		return											//Checks if the new value is actually allowed.
														//None of this should happen normally, but this avoids client attacks.
	SS.skill_list[S.type] = new_level
	SS.on_levels_change()
	SS.points_remaining += (current_value - new_value)
	p_purge_skills_missing_prerequisites(SS)

#undef P_STARTING_SKILL_POINTS