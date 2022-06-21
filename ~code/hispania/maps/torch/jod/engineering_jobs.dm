/datum/job/senior_engineer
	title = "Senior Engineer"
	department = "Ingenieria"
	department_flag = ENG
	total_positions = 1
	spawn_positions = 1
	supervisors = "El jefe de ingenieria"
	selection_color = "#5b4d20"
	economic_power = 7
	minimal_player_age = 3
	minimum_character_age = list(SPECIES_HUMAN = 27)
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8,
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
	return "Eres el Ingeniero supervisor. Eres un veterano SNCO. Usted este subordinado con el Jefe de ingenieria, aunque puede tener mucha mas de experiencia que el y sus subordinados, son el resto del departamento de ingenieria. Debe ser un experto en practicamente todas las areas de ingenieria y poseer habilidades de liderazgo. Coordine el equipo y garantice el funcionamiento sin problemas del departamento junto con el Jefe de ingenieria."

/datum/job/engineer
	title = "Engineer"
	total_positions = 6
	spawn_positions = 6
	supervisors = "El Jefe de ingenieria"
	economic_power = 5
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 19)
	ideal_character_age = 30
	alt_titles = list(
		"Tecnico del motor",
		"Tecnico en reparaciones",
		"Electricista",
		"Tecnico atmosferico",
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/civ/contractor
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
	return "Eres un ingeniero. Usted opera bajo uno de los muchos titulos y puede ser altamente especializado en un area especifica de ingenieria. Probablemente tenga al menos una familiaridad general con la mayoria de las otras areas, aunque esto no se espera. Usted esta subordinado al Ingeniero supervisor y al Jefe de ingenieria y se espera que los obedezca."

/datum/job/engineer_trainee
	title = "Engineer Trainee"
	department = "Ingenieria"
	department_flag = ENG
	total_positions = 2
	spawn_positions = 2
	supervisors = "El Jefe de ingenieria y el personal de ingenieria"
	selection_color = "#5b4d20"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2
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
	return "Eres un aprendiz de ingeniero. Esta aprendiendo del personal de ingenieria a como operar los diversos sistemas de ingenieria en la nave. Estas subordinado a todos los otros ingenieros a bordo."

/datum/job/roboticist
	title = "Roboticist"
	department = "Ingenieria"
	department_flag = ENG|ROB

	total_positions = 2
	spawn_positions = 2
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 25)
	supervisors = "El Jefe de ingenieria."
	selection_color = "#5b4d20"
	economic_power = 6
	alt_titles = list(
		"Tecnico en exotrajes","Ingeniero biomecanico","Ingeniero mecatronico")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticistec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticistfleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(   SKILL_COMPUTER		= SKILL_ADEPT,
	                    SKILL_DEVICES		= SKILL_ADEPT,
	                    SKILL_EVA           = SKILL_ADEPT,
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
	skill_points = 20

	access = list(
		access_robotics, access_engine, access_solgov_crew, access_network, access_radio_eng, access_engine_equip,
		access_maint_tunnels, access_external_airlocks, access_emergency_storage, access_eva, access_janitor,
		access_construction, access_hangar, access_tech_storage
	)

/datum/job/roboticist/get_description_blurb()
	return "Eres el Robotista. Usted es responsable de reparar, actualizar y manejar los sinteticos de la nave (como los robots). Tambien usted es responsable de la producción de exotrajes (mechas) y bots para varios departamentos. Usted responde al Jefe de ingenieria."
