//Holder for skill information for mobs.

/datum/skillset
	var/skill_list = list()
	var/mob/owner
	var/default_value = SKILL_DEFAULT
	var/skills_transferable = TRUE
	var/list/skill_buffs                                            // A list of /datum/skill_buff being applied to the skillset.
	var/list/skill_verbs                                            // A list of skill-related verb datums.
	var/nm_type = /datum/nano_module/skill_ui
	var/datum/nano_module/skill_ui/NM
	var/list/nm_viewing

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
	QDEL_NULL_LIST(nm_viewing)
	QDEL_NULL(NM)
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
	nm_type = mob.skillset.nm_type
	QDEL_NULL(NM) //Clean all nano_modules for simplicity.
	QDEL_NULL(mob.skillset.NM)
	QDEL_NULL_LIST(nm_viewing)
	QDEL_NULL_LIST(mob.skillset.nm_viewing)
	on_levels_change()

//Called when a player is added as an antag and the antag datum processes the skillset.
/datum/skillset/proc/on_antag_initialize()
	on_levels_change()

/datum/skillset/proc/on_levels_change()
	update_verbs()
	update_special_effects()
	refresh_uis()

/datum/skillset/proc/update_special_effects()
	if(!owner)
		return
	for(var/decl/hierarchy/skill/skill in GLOB.skills)
		skill.update_special_effects(owner, get_value(skill.type))

/datum/skillset/proc/obtain_from_client(datum/job/job, client/given_client, override = 0)
	if(!skills_transferable)
		return
	if(!override && owner.mind && player_is_antag(owner.mind))		//Antags are dealt with at a different time. Note that this may be called before or after antag roles are assigned.
		return
	if(!given_client)
		return

	var/allocation = given_client.prefs.skills_allocated[job] || list()
	skill_list = list()

	for(var/decl/hierarchy/skill/S in GLOB.skills)
		var/min = job ? given_client.prefs.get_min_skill(job, S) : SKILL_MIN
		skill_list[S.type] = min + (allocation[S] || 0)
	on_levels_change()

//Skill-related mob helper procs

/mob/proc/get_skill_value(skill_path)
	return skillset.get_value(skill_path)

/mob/proc/reset_skillset()
	qdel(skillset)
	var/new_type = initial(skillset)
	skillset = new new_type(src)
	var/datum/job/job = mind && SSjobs.get_by_title(mind.assigned_role)
	skillset.obtain_from_client(job, client)

// Use to perform skill checks
/mob/proc/skill_check(skill_path, needed)
	var/points = get_skill_value(skill_path)
	return points >= needed

//Passing a list in format of 'skill = level_needed'
/mob/proc/skill_check_multiple(skill_reqs)
	for(var/skill in skill_reqs)
		. = skill_check(skill, skill_reqs[skill])
		if(!.)
			return

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

// Simple prob using above
/mob/proc/skill_fail_prob(skill_path, fail_chance, no_more_fail = SKILL_MAX, factor = 1)
	return prob(skill_fail_chance(skill_path, fail_chance, no_more_fail, factor ))

// Show skills verb

/mob/living/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	skillset.open_ui()

/datum/skillset/proc/open_ui()
	if(!owner)
		return
	if(!NM)
		NM = new nm_type(owner)
	NM.ui_interact(owner)

/datum/skillset/proc/refresh_uis()
	for(var/nano_module in nm_viewing)
		SSnano.update_uis(nano_module)