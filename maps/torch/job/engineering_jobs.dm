/datum/job/senior_engineer
	title = "Senior Engineer"
	department = "Engineering"
	department_flag = ENG
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Engineer"
	selection_color = "#5b4d20"
	economic_power = 6
	minimal_player_age = 3
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e6,
	)
	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_ADEPT,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_ADEPT,
	                    SKILL_ATMOS        = SKILL_BASIC,
	                    SKILL_ENGINES      = SKILL_ADEPT)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)
	skill_points = 24

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_tcomsat, access_solgov_crew, access_seneng, access_hangar)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)
	required_education = EDUCATION_TIER_TRADE
	maximum_education = EDUCATION_TIER_BACHELOR

/datum/job/senior_engineer/get_description_blurb()
	return "You are the Senior Engineer. You are a veteran SNCO. You are subordinate to the Chief Engineer though you may have many years more experience than them and your subordinates are the rest of engineering. You should be an expert in practically every engineering area and familiar and possess leadership skills. Coordinate the team and ensure the smooth running of the department along with the Chief Engineer."

/datum/job/engineer
	title = "Engineer"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief Engineer"
	economic_power = 5
	minimal_player_age = 0
	ideal_character_age = 30
	alt_titles = list(
		"Maintenance Technician",
		"Engine Technician",
		"Damage Control Technician",
		"EVA Technician",
		"Electrician",
		"Atmospheric Technician",
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2
	)
	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_BASIC,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_BASIC,
	                    SKILL_ATMOS        = SKILL_BASIC,
	                    SKILL_ENGINES      = SKILL_BASIC)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)
	skill_points = 20

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_solgov_crew, access_hangar)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)
	required_education = EDUCATION_TIER_TRADE
	maximum_education = EDUCATION_TIER_BACHELOR

/datum/job/engineer/get_description_blurb()
	return "You are an Engineer. You operate under one of many titles and may be highly specialised in a specific area of engineering. You probably have at least a general familiarity with most other areas though this is not expected. You are subordinate to the Senior Engineer and the Chief Engineer and are expected to follow them."

/datum/job/engineer_contractor
	title = "Engineering Contractor"
	department = "Engineering"
	department_flag = ENG
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Engineer, the Corporate Liaison and Engineering Personnel"
	minimal_player_age = 0
	selection_color = "#5b4d20"
	alt_titles = list(
		"Maintenance Assistant",
		"Structural Integrity Specialist",
		"Electrical Systems Specialist",
		"Information Systems Technician",
		"Reactor Technician",
		"Life Support Systems Specialist")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_COMPUTER      = SKILL_BASIC,
	                    SKILL_EVA           = SKILL_BASIC,
	                    SKILL_CONSTRUCTION	= SKILL_BASIC,
	                    SKILL_ELECTRICAL    = SKILL_BASIC,
	                    SKILL_ATMOS         = SKILL_BASIC,
	                    SKILL_ENGINES       = SKILL_BASIC)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)
	skill_points = 20

	access = list(access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			            access_solgov_crew, access_hangar)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)
	required_education = EDUCATION_TIER_TRADE
	maximum_education = EDUCATION_TIER_BACHELOR

/datum/job/engineer_contractor/get_description_blurb()
	return "You are an Engineering Contractor. Hired for either general maintenance duties or because of your specialist training and knowledge in a specific area of engineering you are either highly skilled or intermediate in your knowledge of engineering tasks related to your profession. You are subordinate to the Corporate Liaison and the rest of the engineering team."

/datum/job/engineer_trainee
	title = "Engineer Trainee"
	department = "Engineering"
	department_flag = ENG
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Engineer and Engineering Personnel"
	selection_color = "#5b4d20"
	ideal_character_age = 20

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
	)

	skill_points = 4
	no_skill_buffs = TRUE

	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_HAULING      = SKILL_ADEPT,
	                    SKILL_EVA          = SKILL_ADEPT,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_ADEPT,
	                    SKILL_ATMOS        = SKILL_ADEPT,
	                    SKILL_ENGINES      = SKILL_ADEPT)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)

	access = list(access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_tech_storage, access_janitor, access_construction,
			            access_solgov_crew, access_hangar)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)
	required_education = EDUCATION_TIER_BASIC
	maximum_education = EDUCATION_TIER_TRADE

/datum/job/engineer_trainee/get_description_blurb()
	return "You are an Engineer Trainee. You are learning how to operate the various onboard engineering systems from senior engineering staff. You are subordinate to all of the other engineers aboard."

/datum/job/roboticist
	title = "Roboticist"
	department = "Engineering"
	department_flag = ENG

	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 0
	supervisors = "the Chief Engineer and the Corporate Liaison."
	selection_color = "#5b4d20"
	economic_power = 6
	alt_titles = list(
		"Mechsuit Technician")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_COMPUTER		= SKILL_ADEPT,
	                    SKILL_DEVICES		= SKILL_ADEPT)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_EXPERT,
	                    SKILL_ENGINES      = SKILL_EXPERT,
	                    SKILL_DEVICES      = SKILL_MAX,
	                    SKILL_ANATOMY      = SKILL_EXPERT,
	                    SKILL_MEDICAL      = SKILL_EXPERT)
	skill_points = 20

	access = list(access_robotics, access_robotics_engineering, access_tech_storage, access_morgue, access_medical, access_robotics_engineering, access_solgov_crew)
	minimal_access = list()
	required_education = EDUCATION_TIER_TRADE
	maximum_education = EDUCATION_TIER_DOCTORATE

/datum/job/roboticist/get_description_blurb()
	return "You are the Roboticist. You are responsible for repairing, upgrading and handling ship synthetics (like robots). You are also responsible for the production of exosuits(mechs) and bots for various departments. You answer to the Corporate Liaison and the Chief Engineer."