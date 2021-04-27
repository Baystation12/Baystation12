/datum/job/liaison
	title = "Workplace Liaison"
	department = "Support"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	supervisors = "Corporate Regulations, the Union Charter, and the Expeditionary Corps Organisation"
	selection_color = "#2f2f7f"
	economic_power = 18
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 25)
	alt_titles = list(
		"Corporate Liaison",
		"Union Representative",
		"Corporate Representative",
		"Corporate Executive"
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/workplace_liaison
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_BUREAUCRACY	= SKILL_EXPERT,
	                    SKILL_FINANCE		= SKILL_BASIC)
	skill_points = 20

	access = list(
		access_liaison, access_bridge, access_solgov_crew,
		access_nanotrasen, access_commissary, access_torch_fax,
		access_radio_comm, access_radio_serv
	)

	software_on_spawn = list(/datum/computer_file/program/reports)

/datum/job/liaison/get_description_blurb()
	return "You are the Workplace Liaison. You are a civilian employee of EXO, the Expeditionary Corps Organisation, the government-owned corporate conglomerate that partially funds the Torch. You are on board the vessel to promote corporate interests and protect the rights of the contractors on board as their union leader. You are not internal affairs. You advise command on corporate and union matters and contractors on their rights and obligations. Maximise profit. Be the shady corporate shill you always wanted to be."

/datum/job/liaison/post_equip_rank(var/mob/person, var/alt_title)
	var/my_title = "\a ["\improper [(person.mind ? (person.mind.role_alt_title ? person.mind.role_alt_title : person.mind.assigned_role) : "Executive Assistant")]"]"
	for(var/mob/M in GLOB.player_list)
		if(M.client && M.mind)
			if(M.mind.assigned_role == "Executive Assistant")
				to_chat(M, SPAN_NOTICE("<b>One of your employers, [my_title] named [person.real_name], is present on [GLOB.using_map.full_name].</b>"))
	..()

/datum/job/bodyguard
	title = "Executive Assistant"
	department = "Support"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Workplace Liaison"
	selection_color = "#3d3d7f"
	economic_power = 12
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 19)
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_BASIC,
	                    SKILL_FORENSICS   = SKILL_BASIC)
	max_skill = list(   SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT,
	                    SKILL_FORENSICS   = SKILL_EXPERT)
	alt_titles = list(
		"Union Enforcer",
		"Loss Prevention Associate",
		"Asset Protection Agent"
	)
	skill_points = 20

	access = list(
		access_liaison, access_bridge, access_solgov_crew,
		access_nanotrasen, access_commissary,
		access_sec_guard, access_torch_fax, access_radio_serv
	)

	defer_roundstart_spawn = TRUE

/datum/job/bodyguard/is_position_available()
	if(..())
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.mind && M.mind.assigned_role == "Workplace Liaison")
				return TRUE
	return FALSE

/datum/job/bodyguard/get_description_blurb()
	return "You are the Executive Assistant. You are an employee of one of the corporations that make up the Expeditionary Corps Organisation, and your job is to assist the Liason in corporate affairs. You are also expected to protect the Liason's life, though not in any way that breaks the law."

/datum/job/bodyguard/post_equip_rank(var/mob/person, var/alt_title)
	var/my_title = "\a ["\improper [(person.mind ? (person.mind.role_alt_title ? person.mind.role_alt_title : person.mind.assigned_role) : "Executive Assistant")]"]"
	for(var/mob/M in GLOB.player_list)
		if(M.client && M.mind)
			if(M.mind.assigned_role == "Workplace Liaison")
				to_chat(M, SPAN_NOTICE("<b>Your bodyguard, [my_title] named [person.real_name], is present on [GLOB.using_map.full_name].</b>"))
	..()
