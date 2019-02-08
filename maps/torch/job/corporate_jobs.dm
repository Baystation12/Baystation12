/datum/job/liaison
	title = "Workplace Liaison"
	department = "Support"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	supervisors = "Corporate Regulations, the Union Charter, and the Expeditionary Corps Organisation"
	selection_color = "#2f2f7f"
	economic_power = 15
	minimal_player_age = 0
	alt_titles = list(
		"Corporate Liaison",
		"Union Representative" = /decl/hierarchy/outfit/job/torch/passenger/workplace_liaison/union_rep,
		"Corporate Representative",
		"Corporate Executive"
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/workplace_liaison
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_BUREAUCRACY	= SKILL_EXPERT,
	                    SKILL_FINANCE		= SKILL_BASIC)
	skill_points = 20
	access = list(access_liaison, access_tox, access_tox_storage, access_bridge, access_research,
						access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard, access_hangar,
						access_petrov, access_petrov_helm, access_maint_tunnels, access_emergency_storage,
						access_janitor, access_hydroponics, access_kitchen, access_bar, access_commissary)
	software_on_spawn = list(/datum/computer_file/program/reports)

/datum/job/liaison/get_description_blurb()
	return "You are the Workplace Liaison. You are a civilian employee of the Expeditionary Corps Organisation, the corporate conglomerate partially funding the Torch, assigned to the vessel to promote corporate interests and protect the rights of the contractors on board. You are not internal affairs. You assume command of the Research Department in the absence of the RD and the Senior Researcher. You advise the RD on corporate matters and try to push corporate interests on the CO, and speak for the workers where required. Maximise profit. Be the shady corporate shill you always wanted to be."

/datum/job/liaison/post_equip_rank(var/mob/person)
	var/my_title = "\a ["\improper [(person.mind ? (person.mind.role_alt_title ? person.mind.role_alt_title : person.mind.assigned_role) : "Loss Prevention Associate")]"]"
	for(var/mob/M in GLOB.player_list)
		if(M.client && M.mind)
			if(M.mind.assigned_role == "Loss Prevention Associate")
				to_chat(M, SPAN_NOTICE("<b>One of your employers, [my_title] named [person.real_name], is present on [GLOB.using_map.full_name].</b>"))

/datum/job/bodyguard
	title = "Loss Prevention Associate"
	department = "Support"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Workplace Liaison"
	selection_color = "#3d3d7f"
	economic_power = 12
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_ADEPT,
	                    SKILL_FORENSICS   = SKILL_BASIC)
	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_FORENSICS   = SKILL_MAX)
	alt_titles = list(
		"Union Enforcer" = /decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard/union,
		"Executive Assistant",
		"Asset Protection Agent"
	)
	skill_points = 20
	access = list(access_liaison, access_tox, access_tox_storage, access_bridge, access_research,
						access_mining, access_mining_office, access_mining_station, access_xenobiology,
						access_xenoarch, access_nanotrasen, access_sec_guard, access_hangar,
						access_petrov, access_petrov_helm, access_maint_tunnels, access_emergency_storage,
						access_janitor, access_hydroponics, access_kitchen, access_bar, access_commissary)
	defer_roundstart_spawn = TRUE

/datum/job/bodyguard/is_position_available()
	if(..())
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.mind && M.mind.assigned_role == "Workplace Liaison")
				return TRUE
	return FALSE

/datum/job/bodyguard/get_description_blurb()
	return "You are the Loss Prevention Associate. You are an employee of one of the corporations that make up the Expeditionary Corps Organisation, and your job is to prevent the loss of the Liason's life - even at the cost of your own. Good luck."

/datum/job/bodyguard/post_equip_rank(var/mob/person)
	var/my_title = "\a ["\improper [(person.mind ? (person.mind.role_alt_title ? person.mind.role_alt_title : person.mind.assigned_role) : "Loss Prevention Associate")]"]"
	for(var/mob/M in GLOB.player_list)
		if(M.client && M.mind)
			if(M.mind.assigned_role == "Workplace Liaison")
				to_chat(M, SPAN_NOTICE("<b>Your bodyguard, [my_title] named [person.real_name], is present on [GLOB.using_map.full_name].</b>"))
