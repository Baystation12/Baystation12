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

/datum/job/corporate_guard
	title = "Corporate Security Officer"
	department = "Science"
	department_flag = SCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Science Officer and Corporate Liason"
	selection_color = "#473d63"
	economic_power = 18
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 26)
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/corporate_guard
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_ADEPT,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_ADEPT
						)

	max_skill = list(   SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 20

	access = list(
		access_research_security, access_tox, access_tox_storage, access_maint_tunnels, access_research, access_xenobiology, access_xenoarch, access_nanotrasen, access_solgov_crew,
		access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_petrov_helm, access_guppy_helm,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_security,
		access_petrov_maint, access_radio_sci
	)

	software_on_spawn = list(/datum/computer_file/program/camera_monitor)

/datum/job/corporate_guard/get_description_blurb()
	return "You are a security guard from the Organization of the Expeditionary Corps, which must protect the scientific department and its employees from various threats. Eat donuts, call scientists \"eggheads\"."
