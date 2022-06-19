/datum/job/qm
	title = "Supervisor de abastecimiento"
	department = "Abastecimiento"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "El Ejecutivo oficial"
	economic_power = 5
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 27)
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/supply/deckofficer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_ADEPT,
	                    SKILL_FINANCE     = SKILL_BASIC,
	                    SKILL_HAULING     = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_PILOT       = SKILL_BASIC,
						SKILL_MECH        =	SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)
	skill_points = 18

	access = list(
		access_maint_tunnels, access_bridge, access_emergency_storage, access_tech_storage,  access_cargo, access_guppy_helm,
		access_cargo_bot, access_qm, access_mailsorting, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_mining, access_mining_office, access_mining_station, access_commissary, access_teleporter, access_eva, access_torch_fax,
		access_radio_sup, access_radio_exp, access_radio_comm
	)

	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/qm/get_description_blurb()
		return "Se ocupan principalmente de aprobar los pedidos entregados al departamento de abastecimiento y garantizar que los Tecnicos de abastecimiento hagan su trabajo para asegurarse de que dichos pedidos se reciban, cataloguen y envien a sus destinos correspondientes, ademas de asegurarse de que los transbordadores esten en condiciones de volar."

/datum/job/cargo_tech
	title = "Tecnico de abastecimiento"
	department = "Abastecimiento"
	department_flag = SUP
	total_positions = 3
	spawn_positions = 3
	supervisors = "El Ejecutivo oficial y El Supervisor de abastecimiento"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 24
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/supply/tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/supply/tech/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/supply/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_FINANCE     = SKILL_BASIC,
	                    SKILL_HAULING     = SKILL_BASIC,
	                    SKILL_MECH        =	SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)

	access = list(
		access_maint_tunnels, access_emergency_storage, access_cargo, access_guppy_helm,
		access_cargo_bot, access_mailsorting, access_solgov_crew, access_expedition_shuttle,
		access_guppy, access_hangar, access_commissary, access_radio_sup
	)

	software_on_spawn = list(/datum/computer_file/program/supply,
							 /datum/computer_file/program/deck_management,
							 /datum/computer_file/program/reports)

/datum/job/cargo_tech/get_description_blurb()
		return "El tecnico de abastecimiento es el trabajador duro de abastecimiento. Son responsables de enviar el correo, recibir la carga y, en general, garantizar que todas las entregas al departamento de abastecimiento lleguen a donde deben ir. Uno de los otros deberes de un tecnico de abastecimiento es reabastecer de combustible los dos transbordadores del hangar, el Charon y el GUP. Por lo general, es una buena idea hacer esto antes de que Exploradores enojados con machetes derriben tu puerta porque su nave no se puede mover."

/datum/job/mining
	title = "Prospector"
	department = "Abastecimiento"
	department_flag = SUP
	total_positions = 2
	spawn_positions = 2
	supervisors = "El Supervisor de abastecimiento, El Representante de EXO y El Ejecutivo oficial"
	economic_power = 7
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 25
	alt_titles = list(
		"Tecnico de perforación",
		"Minero",
		"Tecnico de salvamento")
	min_skill = list(   SKILL_HAULING = SKILL_ADEPT,
	                    SKILL_EVA     = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)

	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/research/prospector
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/contractor)

	access = list(
		access_mining, access_mining_office, access_mining_station,
		access_expedition_shuttle, access_guppy, access_hangar,
		access_guppy_helm, access_solgov_crew, access_eva,
		access_radio_exp, access_radio_sup
	)

/datum/job/mining/get_description_blurb()
		return "El Prospector es un caballo de batalla dedicado al salvamento y la recuperacion minera. Se unen a misiones fuera de casa en un intento de recuperar minerales, muestras y articulos valiosos para el resto del beneficio de la nave. Su objetivo principal es recolectar y traer el mineral para procesarlor, puede salir a bordo del Charon con los Exploradores o tomar la GUP usted mismo."
