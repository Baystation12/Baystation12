/datum/job/pathfinder
	title = "Pathfinder"
	department = "Exploration"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Science Officer"
	selection_color = "#68099e"
	minimal_player_age = 1
	economic_power = 10
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/pathfinder
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_ADEPT,
	                    SKILL_SCIENCE     = SKILL_ADEPT,
	                    SKILL_PILOT       = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 22

	access = list(
		access_pathfinder, access_explorer, access_eva, access_maint_tunnels, access_bridge, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_expedition_shuttle_helm,
		access_guppy, access_hangar, access_petrov, access_petrov_helm, access_petrov_analysis, access_petrov_phoron,
		access_petrov_toxins, access_petrov_chemistry, access_petrov_maint, access_tox, access_tox_storage, access_research,
		access_xenobiology, access_xenoarch, access_torch_fax, access_radio_comm, access_radio_exp, access_radio_sci,
		access_exploration_guard //Proxima EC rework addition
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/pathfinder/get_description_blurb()
	return "You are the Pathfinder. Your duty is to organize and lead the expeditions to away sites, carrying out the EC's Primary Mission. You command Explorers and Marines. Watch that your men and women don't spend all shuttle's energy on recharging their cells. You make sure that expedition has the supplies and personnel it needs. You can pilot Charon if nobody else provides a pilot. Once on the away mission, your duty is to ensure that anything of scientific interest is brought back to the ship and passed to the relevant research lab."

/datum/job/nt_pilot
	title = "Shuttle Pilot"
	supervisors = "the Pathfinder"
	department = "Exploration"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	selection_color = "#68099e"
	economic_power = 8
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/pilot
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor = /decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7
	)

	access = list(
		access_mining_office, access_petrov, access_petrov_helm, access_petrov_maint, access_mining_station,
		access_expedition_shuttle, access_expedition_shuttle_helm, access_guppy, access_hangar, access_guppy_helm,
		access_mining, access_pilot, access_solgov_crew, access_eva, access_explorer, access_research,
		access_radio_exp, access_radio_sci, access_radio_sup, access_maint_tunnels, access_emergency_storage
	)
	min_skill = list(	SKILL_EVA   = SKILL_BASIC,
						SKILL_PILOT = SKILL_ADEPT,
						SKILL_MEDICAL = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

/datum/job/explorer
	title = "Explorer"
	department = "Exploration"
	department_flag = EXP
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Commanding Officer, Executive Officer, and Pathfinder"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/explorer
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)

	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC
					)

	max_skill = list(   SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/explorer/get_description_blurb()
	return "You are an Explorer. Your duty is to go on expeditions to away sites. The Pathfinder is your team leader. You are to look for anything of economic or scientific interest to the SCG - mineral deposits, alien flora/fauna, artifacts. You will also likely encounter hazardous environments, aggressive wildlife or malfunctioning defense systems, so tread carefully."

/datum/job/expmed
	title = "Exploration Medic"
	department = "Exploration"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commanding Officer, Executive Officer, and Pathfinder"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 19)
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/expmed
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/exploration/expmed/army
		)

	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_ADEPT
					)
	max_skill = list(   SKILL_MEDICAL	  = SKILL_EXPERT,
						SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 22

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp, access_radio_med,
		access_medical
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							/datum/computer_file/program/deck_management)

/datum/job/expmed/get_description_blurb()
	return "You are an Exploration Medic. Your duty is to go on expeditions to away sites. The Pathfinder is your team leader. You are to keep your team members alive. Keep a note that you are not a doctor, don't try to preform surgeries on your shuttle as you're not qualified for that."

/datum/job/expeng
	title = "Exploration Engineer"
	department = "Exploration"
	department_flag = EXP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commanding Officer, Executive Officer, and Pathfinder"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 19)
	ideal_character_age = 25
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/expeng
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/exploration/expeng/army
		)

	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_CONSTRUCTION = SKILL_BASIC,
						SKILL_ELECTRICAL = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC
					)
	max_skill = list(   SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)
	skill_points = 22

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp, access_radio_eng
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/expeng/get_description_blurb()
	return "You are an Exploration Engineer. Your duty is to go on expeditions to away sites. The Pathfinder is your team leader. You are to keep shuttle operational and make holes wherever your boss says."

/datum/job/expmar
	title = "Expedition Marine Guard"
	department = "Exploration"
	department_flag = EXP
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commanding Officer, Executive Officer, and Pathfinder"
	selection_color = "#68099e"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 21
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/exploration/expmar
	allowed_branches = list(
		/datum/mil_branch/army
		)

	allowed_ranks = list(
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5
	)
	min_skill = list(   SKILL_EVA = SKILL_BASIC,
						SKILL_MEDICAL = SKILL_BASIC,
						SKILL_WEAPONS = SKILL_ADEPT
					)
	max_skill = list(   SKILL_ANATOMY	  = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX,
	                    SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT)

	access = list(
		access_explorer, access_maint_tunnels, access_eva, access_emergency_storage,
		access_guppy_helm, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov, access_petrov_maint, access_research, access_radio_exp,
		access_exploration_guard
	)

	software_on_spawn = list(/datum/computer_file/program/deck_management)

/datum/job/expmar/get_description_blurb()
	return "You are an Exploration Guard. Your duty is to go on expeditions to away sites and keep members of the team safe. The Pathfinder is your team leader. Listen him and obey at all costs. Try not to recharge all your cells on a trip."
