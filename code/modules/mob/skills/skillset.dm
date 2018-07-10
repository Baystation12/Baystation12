//Holder for skill information for mobs.

/datum/skillset
	var/skill_list = list()
	var/mob/owner
	var/default_value = SKILL_DEFAULT
	var/skills_transferable = TRUE
	var/list/skill_buffs                                            // A list of /datum/skill_buff being applied to the skillset.
	var/list/skill_verbs                                            // A list of skill-related verb datums.

/datum/skillset/New(mob/mob)
	owner = mob
	for(var/datum/skill_verb/SV in GLOB.skill_verbs)
		if(SV.should_have_verb(src))
			SV.give_to_skillset(src)
	..()

/datum/skillset/Destroy()
	owner = null
	QDEL_NULL_LIST(skill_buffs)
	QDEL_NULL_LIST(skill_verbs)
	. = ..()

/datum/skillset/proc/get_value(skill_path)
	. = skill_list[skill_path] || default_value
	for(var/datum/skill_buff/SB in skill_buffs)
		. += SB.buffs[skill_path]

/datum/skillset/proc/obtain_from_mob(mob/mob)
	if(!istype(mob) || !skills_transferable || !mob.skillset.skills_transferable)
		return
	skill_list = mob.skillset.skill_list
	default_value = mob.skillset.default_value
	skill_buffs = mob.skillset.skill_buffs
	update_verbs()

/datum/skillset/proc/set_antag_skills()
	skill_list = list()
	update_verbs()                                      //Antags get generic skills, unless this is modified

/datum/skillset/proc/obtain_from_client(datum/job/job, client/given_client)
	if(!skills_transferable)
		return
	if(owner.mind && player_is_antag(owner.mind))		//Antags are dealt with at a different time. Note that this may be called before or after antag roles are assigned.
		return
	if(!given_client)
		return

	var/allocation = list()
	if(job in given_client.prefs.skills_allocated)
		allocation = given_client.prefs.skills_allocated[job]
	skill_list = list()
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		var/min = given_client.prefs.get_min_skill(job, S)
		skill_list[S.type] = min + (allocation[S] || 0)
	update_verbs()

//Skill-related mob helper procs

/mob/proc/get_skill_value(skill_path)
	return skillset.get_value(skill_path)

// Use to perform skill checks
/mob/proc/skill_check(skill_path, needed)
	var/points = get_skill_value(skill_path)
	return points >= needed

/mob/proc/get_skill_difference(skill_path, mob/opponent)
	return get_skill_value(skill_path) - opponent.get_skill_value(skill_path)

// A generic way of modifying times via skill values	
/mob/proc/skill_delay_mult(skill_path, factor = 0.3) 
	var/points = get_skill_value(skill_path)
	switch(points)
		if(SKILL_BASIC)
			return max(0, 1 + 3*factor)
		if(SKILL_NONE)
			return max(0, 1 + 6*factor)
		else
			return max(0, 1 + (SKILL_DEFAULT - points) * factor)

/mob/proc/do_skilled(base_delay, skill_path , atom/target = null, factor = 0.3)
	return do_after(src, base_delay * skill_delay_mult(skill_path, factor), target)

// A generic way of modifying success probabilities via skill values. Higher factor means skills have more effect. fail_chance is the chance at SKILL_NONE.
/mob/proc/skill_fail_chance(skill_path, fail_chance, no_more_fail = SKILL_MAX, factor = 1) 
	var/points = get_skill_value(skill_path)
	if(points >= no_more_fail)
		return 0
	else
		return fail_chance * 2 ** (factor*(SKILL_MIN - points))

// Show skills verb

proc/show_skill_window(var/mob/user, var/mob/M)
	if(!istype(M)) return

	if(!M.skillset)
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = list()
	HTML += "<body>"
	HTML += "<b>Skills: [M]</b><br>"
	HTML += "<table>"
	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
	for(var/decl/hierarchy/skill/V in skill.children)
		HTML += "<tr><th colspan = 4><b>[V.name]</b>"
		HTML += "</th></tr>"
		for(var/decl/hierarchy/skill/S in V.children)
			var/level = M.get_skill_value(S.type)
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
				HTML += "<th><font color=[(level == i) ? "red" : "black"]>[S.levels[i]]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	show_browser(user, null, "window=preferences")
	show_browser(user, jointext(HTML, null), "window=show_skills;size=700x900")

mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	show_skill_window(src, src)