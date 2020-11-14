//Infantry Jobs
/datum/job/squad_lead
	title = "Squad Lead"
	department = "Infantry"
	department_flag = INF
	head_position = 1
	total_positions = 1
	spawn_positions = 1

	supervisors = "the highest ranking Marine and SolGov Command"
	selection_color = "#557e38"
	minimal_player_age = 12
	economic_power = 7
	skill_points = 24
	minimum_character_age = list(SPECIES_HUMAN = 25)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
						SKILL_EVA         = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_BASIC,
						SKILL_COMBAT      = SKILL_ADEPT,
						SKILL_WEAPONS     = SKILL_ADEPT)

	max_skill = list(	SKILL_COMBAT      = SKILL_PROF,		//SKILL_SPEC Being given as undefined var. Changing to SKILL_PROF
						SKILL_WEAPONS     = SKILL_PROF,		//Thanks Vhbraz
						SKILL_EVA		  = SKILL_EXPERT,
						SKILL_HAULING     = SKILL_PROF)

	outfit_type = /decl/hierarchy/outfit/job/infantry/squadlead

/datum/job/squad_lead/get_description_blurb()
	return "<span class='warning'>You are NOT Security. Ignoring this will get you job banned, or worse.</span> - You are a Squad Leader. Your duty is to organize and lead the small infantry squad to support the Pathfinder. You command Marines in your Squad. You make sure that expedition has the firepower it needs. Once on the away mission, your duty is to ensure that the worst doesn't become reality."

/datum/job/combat_tech
	title = "Combat Technician"
	supervisors = "the Squad Leader"
	department = "Infantry"
	department_flag = INF
	total_positions = 1
	spawn_positions = 1
	selection_color = "#557e38"
	economic_power = 4
	minimal_player_age = 8
	skill_points = 24
	minimum_character_age = list(SPECIES_HUMAN = 20)
	min_skill = list(	SKILL_CONSTRUCTION = SKILL_ADEPT,
						SKILL_ELECTRICAL   = SKILL_ADEPT,
						SKILL_MEDICAL      = SKILL_BASIC,
						SKILL_COMBAT       = SKILL_ADEPT,
						SKILL_WEAPONS      = SKILL_ADEPT)

	max_skill = list(	SKILL_COMBAT       = SKILL_EXPERT,
						SKILL_WEAPONS      = SKILL_PROF,	//Being given as undefined var. Changing to SKILL_PROF
						SKILL_EVA		   = SKILL_EXPERT,
						SKILL_CONSTRUCTION = SKILL_EXPERT,
						SKILL_ELECTRICAL   = SKILL_EXPERT)

	alt_titles = list(
		"Combat Engineer",
		"Combat Medic")

	outfit_type = /decl/hierarchy/outfit/job/infantry/tech

/datum/job/combat_tech/is_position_available()
	if(..())
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.mind && M.mind.assigned_role == "Squad Lead")
				return TRUE
	return FALSE

/datum/job/combat_tech/get_description_blurb()
	return "<span class='warning'>You are NOT Security. Ignoring this will get you job banned, or worse.</span> - You are the singular Combat Technician in the squad. Your duty is to provide both firepower and demolitions as required. You may assume Command if no Squad Leader is present."

/datum/job/grunt
	title = "Rifleman"
	department = "Infantry"
	department_flag = INF
	total_positions = 3
	spawn_positions = 3
	minimal_player_age = 6
	supervisors = "the Combat Technician and Squad Leader"
	selection_color = "#557e38"
	skill_points = 18
	minimum_character_age = list(SPECIES_HUMAN = 18)
	min_skill = list(	SKILL_COMBAT       = SKILL_ADEPT,
						SKILL_WEAPONS      = SKILL_ADEPT,
						SKILL_EVA          = SKILL_BASIC)

	max_skill = list(	SKILL_COMBAT      = SKILL_EXPERT,
						SKILL_WEAPONS     = SKILL_EXPERT,
						SKILL_EVA		  = SKILL_EXPERT)

	alt_titles = list(
		"Grunt",
		"Trooper")

	outfit_type = /decl/hierarchy/outfit/job/infantry/grunt

/datum/job/grunt/is_position_available()
	if(..())
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.mind && M.mind.assigned_role == "Squad Lead")
				return TRUE
	return FALSE

/datum/job/grunt/get_description_blurb()
	return "<span class='warning'>You are NOT Security. Ignoring this will get you job banned, or worse.</span> - You are a Marine! Your duty is to listen to the Squad Leader. If they're not present, the Combat Technician may pull rank. Do your best not to die, while also taking orders. Oorah!"
