/datum/job/senior_engineer
	title = "Senior Engineer"
	department = "Инженерный"
	department_flag = ENG
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главному инженеру"
	selection_color = "#5b4d20"
	economic_power = 7
	minimal_player_age = 3
	minimum_character_age = list(SPECIES_HUMAN = 27)
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/fleet,
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8
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

	access = list(
		access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
		access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
		access_tcomsat, access_solgov_crew, access_seneng, access_hangar, access_network, access_network_admin, access_radio_eng
	)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/senior_engineer/get_description_blurb()
	return "Вы - Старший инженер (СИ). Вы опытный старший унтер-офицер. Вам подчиняется остальной отдел, за исключением Главного инженера. \
	Вы должны быть экспертом практически в каждом инженерном деле, а также быть знакомым с лидерскими качествами и владеть ими. \
	Координируйте команду и убедитесь в правильной работе отдела вместе с Главным инженером."

/datum/job/engineer
	title = "Engineer"
	department = "Инженерный"
	total_positions = 6
	spawn_positions = 6
	supervisors = "Главному и Старшему инженеру"
	economic_power = 5
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 19)
	ideal_character_age = 30
	alt_titles = list(
		"Engine Technician",
		"Damage Control Technician",
		"Electrical Technician",
		"Atmospheric Technician",
		"Life Support Technician"
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/army,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/civ/three ,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ
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

	access = list(
		access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
		access_teleporter, access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
		access_solgov_crew, access_hangar, access_network, access_radio_eng
	)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/engineer/get_description_blurb()
	return "Вы - инженер. Вы работаете под одним из множества названий и можете быть высокоспециализированны в определённой области инженернии. \
	Возможно, что у Вы хотя бы в общем знакомы с большинством остальных областей инженерии, хотя это не ожидается от Вас."

/datum/job/engineer_trainee
	title = "Engineer Trainee"
	department = "Инженерный"
	department_flag = ENG
	total_positions = 2
	spawn_positions = 2
	supervisors = "Главному инженеру и остальному инженерному персоналу"
	selection_color = "#5b4d20"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/army,
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/army/e2,
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

	access = list(
		access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
		access_eva, access_tech_storage, access_janitor, access_construction,
		access_solgov_crew, access_hangar, access_radio_eng
	)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/engineer_trainee/get_description_blurb()
	return "Вы - Инженер-стажёр. Вы обучаетесь работе с множеством бортовых систем используя помощь старшего инженерного состава. \
	Вы подчиняетесь всему остальному инженерному составу на борту судна."

/datum/job/roboticist
	title = "Roboticist"
	department = "Инженерный"
	department_flag = ENG|ROB

	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 22)
	supervisors = "Главному и Старшему инженеру"
	selection_color = "#5b4d20"
	economic_power = 6
	alt_titles = list(
		"Mechsuit Technician",
		"Biomechanical Engineer")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticistec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticistfleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticistarmy,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ

	)
	min_skill = list(   SKILL_COMPUTER		= SKILL_ADEPT,
	                    SKILL_DEVICES		= SKILL_ADEPT,
	                    SKILL_EVA           = SKILL_BASIC,
	                    SKILL_ANATOMY       = SKILL_ADEPT,
						SKILL_CONSTRUCTION  = SKILL_BASIC,
						SKILL_ELECTRICAL    = SKILL_BASIC,
	                    SKILL_MECH          = HAS_PERK)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_EXPERT,
	                    SKILL_ENGINES      = SKILL_EXPERT,
	                    SKILL_DEVICES      = SKILL_MAX,
	                    SKILL_MEDICAL      = SKILL_EXPERT,
	                    SKILL_ANATOMY      = SKILL_EXPERT)
	skill_points = 22

	access = list(
		access_robotics, access_engine, access_solgov_crew, access_network, access_radio_med, access_radio_eng
	)

/datum/job/roboticist/get_description_blurb()
	return "Вы - робототехник. Вы ответственны за починку, улучшение, обслуживание и создание судовых синтетиков (например - ИПК). \
	Вы также ответственны за производство экзокостюмов (мехов), скафандров, экзоскелетов (ИКС) и ботов для различных департаментов на борту."
