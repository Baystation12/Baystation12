/datum/job/senior_engineer
	title = "Senior Engineer"
	department = "Инженерный"
	department_flag = ENG
	supervisors = "Главному Инженеру"
	selection_color = "#5b4d20"

	total_positions = 1
	spawn_positions = 1
	economic_power = 7
	minimal_player_age = 14
	minimum_character_age = list(SPECIES_HUMAN = 26)
	ideal_character_age = 28

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/engineering/senior_engineer
	allowed_branches = list(/datum/mil_branch/employee)
	allowed_ranks = list(/datum/mil_rank/civ/nt)

	skill_points = 24
	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_TRAINED,
	                    SKILL_CONSTRUCTION = SKILL_TRAINED,
	                    SKILL_ELECTRICAL   = SKILL_TRAINED,
	                    SKILL_ATMOS        = SKILL_TRAINED,
	                    SKILL_ENGINES      = SKILL_TRAINED)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
						SKILL_COMPUTER     = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)

	access = list(	access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			        access_eva, access_tech_storage, access_atmospherics, access_janitor, access_construction,
			        access_tcomsat, access_seneng, access_hangar)


	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

	// SIERRA TODO: need_exp_to_play
	// need_exp_to_play = 2

/datum/job/senior_engineer/get_description_blurb()
	return "Старший Инженер выполняет распоряжения Главного Инженера и контролирует повседневную работу отдела.\
	 Он - очень опытный и высокопоставленный сотрудник, поэтому должен иметь обширные знания во многих \
	 областях инженерии. При необходимости он может инструктировать рядовых инженеров."

/datum/job/engineer
	title = "Engineer"
	department = "Инженерный"
	department_flag = ENG
	supervisors = "Главному и Старшему инженеру"
	selection_color = "#5b4d20"

	total_positions = 4
	spawn_positions = 4
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 22)
	ideal_character_age = 24
	economic_power = 6

	alt_titles = list(
		"Maintenance Technician" = /singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/maints,
		"Structural Integrity Specialist" = /singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/maints,
		"Electrician",
		"Reactor Technician" = /singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/maints,,
		"Atmospheric Technician" = /singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/atmos)

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	skill_points = 20
	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_TRAINED,
	                    SKILL_CONSTRUCTION = SKILL_TRAINED,
	                    SKILL_ELECTRICAL   = SKILL_TRAINED,
	                    SKILL_ATMOS        = SKILL_TRAINED,
	                    SKILL_ENGINES      = SKILL_TRAINED)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_COMPUTER	   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)


	access = list(	access_engine, access_engine_equip, access_maint_tunnels, access_external_airlocks,
			       	access_eva, access_tech_storage, access_atmospherics, access_janitor,
			        access_construction, access_hangar, access_emergency_storage)


	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/engineer/get_description_blurb()
	return "Инженер поддерживает рабочее состояние систем корабля. Он отвечает за обеспечение энергией, \
	воздухом; ремонтирует повреждения, которые могут возникнуть при несчастных случаях. \
	Почти любая проблема, связанная с механикой и машинерией на борту возлагается на инженеров."

/datum/job/engineer_trainee
	title = "Engineer Trainee"
	department = "Инженерный"
	department_flag = ENG
	supervisors = "Главному инженеру и остальным инженерам"
	selection_color = "#5b4d20"

	total_positions = 2
	spawn_positions = 2
	minimum_character_age = list(SPECIES_HUMAN = 20)
	ideal_character_age = 21
	economic_power = 3

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/trainee
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	no_skill_buffs = TRUE
	skill_points = 16
	min_skill = list(   SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_BASIC,
	                    SKILL_CONSTRUCTION = SKILL_BASIC,
	                    SKILL_ELECTRICAL   = SKILL_BASIC,
	                    SKILL_ATMOS        = SKILL_BASIC,
	                    SKILL_ENGINES      = SKILL_BASIC)

	max_skill = list(   SKILL_CONSTRUCTION = SKILL_MAX,
	                    SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_ATMOS        = SKILL_MAX,
	                    SKILL_ENGINES      = SKILL_MAX)

	access = list(		access_engine, access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_janitor, access_construction,
			            access_hangar)


	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shields_monitor)

/datum/job/engineer_trainee/get_description_blurb()
	return "Инженер-стажер выполняет несложные поручения инженеров, изучая инженерную механику на практике. \
	От стажера не ожидается, что он самостоятельно запустит реактор суперматерии или выполнит другое сложное \
	задание. Он - ассистент в инженерном отделе."

/datum/job/infsys
	title = "Information Technician"
	department = "Инженерный"
	department_flag = ENG
	supervisors = "Главному и Старшему инженерам"
	selection_color = "#5b4d20"

	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 22)
	ideal_character_age = 24
	economic_power = 6

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/tcomms
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)

	skill_points = 12
	min_skill = list(   SKILL_COMPUTER     = SKILL_TRAINED,
	                    SKILL_CONSTRUCTION = SKILL_BASIC,
	                    SKILL_ELECTRICAL   = SKILL_TRAINED)

	max_skill = list(   SKILL_ELECTRICAL   = SKILL_MAX,
	                    SKILL_COMPUTER	   = SKILL_MAX)

	access = list(	access_maint_tunnels, access_network,
			       	access_tech_storage, access_emergency_storage, access_tcomsat)


/datum/job/infsys/get_description_blurb()
	return "Вы когда-нибудь хотели стать человеком, который сутками сидит на попе смирно и начинает проявлять признаки бурной деятельности, когда всё идёт коту под хвост?\
	Поздравляю, Вы приняты на должность информационного техника. Сидите на попе смирно, серфите NTNet, истерите, когда связь внезапно обрывается, становитесь главным Hackerman-ом этой смены."
