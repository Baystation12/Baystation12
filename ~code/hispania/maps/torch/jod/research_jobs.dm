/datum/job/senior_scientist
	title = "Cientifico supervisor"
	department = "Ciencias"
	department_flag = SCI

	total_positions = 1
	spawn_positions = 1
	supervisors = "El Jefe de ciencias oficial"
	selection_color = "#633d63"
	economic_power = 12
	minimal_player_age = 3
	minimum_character_age = list(SPECIES_HUMAN = 30)
	ideal_character_age = 50
	alt_titles = list(
		"Investigador supervisor")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/research/senior_scientist
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1
	)

	access = list(
		access_tox, access_tox_storage, access_maint_tunnels, access_research, access_mining_office,
		access_mining_station, access_xenobiology, access_xenoarch, access_nanotrasen, access_solgov_crew,
		access_expedition_shuttle, access_guppy, access_hangar, access_petrov, access_petrov_helm, access_guppy_helm,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control,
		access_petrov_maint, access_torch_fax, access_radio_sci, access_radio_exp
	)

	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_FINANCE     = SKILL_BASIC,
	                    SKILL_BOTANY      = SKILL_BASIC,
	                    SKILL_ANATOMY     = SKILL_BASIC,
	                    SKILL_DEVICES     = SKILL_ADEPT,
	                    SKILL_SCIENCE     = SKILL_ADEPT)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)
	skill_points = 20
	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/senior_scientist/get_description_blurb()
		return "El miembro mas antiguo del equipo de investigacion, el investigador principal, esta a cargo de asegurarse de que el resto del departamento sepan lo que se supone que deben hacer y lo hagan de manera rapida y profesional. Es su trabajo converti las ordenes del Jefe de ciencias oficial en acciones y supervisar las operaciones diarias del departamento para asegurarse de que todo se haga correctamente. Eres el ejecutivo y administrador del Jefe de ciencias oficial, el que convierte la lista de prioridades e instrucciones en trabajo real para el resto del departamento, y deben coordinarse estrechamente con ambos."

/datum/job/scientist
	title = "Cientifico"
	total_positions = 6
	spawn_positions = 6
	supervisors = "El Jefe de ciencias oficial"
	economic_power = 10
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 45
	minimal_player_age = 0
	alt_titles = list(
		"Xenoarqueologo",
		"Anomalista",
		"Investigador",
		"Xenobiologista",
		"Xenobotanista"
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_DEVICES     = SKILL_BASIC,
	                    SKILL_SCIENCE     = SKILL_ADEPT)

	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/research/scientist
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/civ/contractor = /decl/hierarchy/outfit/job/torch/passenger/research/scientist,
		/datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/scientist/solgov
	)

	access = list(
		access_tox, access_tox_storage, access_research, access_petrov, access_petrov_helm,
		access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
		access_xenoarch, access_nanotrasen, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control, access_torch_fax,
		access_petrov_maint, access_radio_sci, access_radio_exp
	)
	skill_points = 20
	possible_goals = list(/datum/goal/achievement/notslimefodder)

datum/job/scientist/get_description_blurb()
		return "Un cientifico produce nuevas formas de tecnologia o informacion que pueda ser util para EXO. En la practica, muchos cientificos hacen este tipo de trabajo por sus propios motivos, la mayoria de las veces, solo para ver lo que realmente pueden lograr. Siempre que los laboratorios permanezcan intactos y el trabajo este lo suficientemente bien documentado como para permitir su reproduccion posterior y el Jefe de ciencias oficial permita el projecto, ya que dicha experimentacion suele producir algo, bueno o malo, pero algo."

/datum/job/scientist_assistant
	title = "Asistente de ciencias"
	department = "ciencias"
	department_flag = SCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "El Jefe de ciencias oficial y el personal cientifico"
	selection_color = "#633d63"
	economic_power = 3
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 30
	alt_titles = list(
		"Concerje de ciencias" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/janitor,
		"Sujeto de pruebas" = /decl/hierarchy/outfit/job/torch/passenger/research/assist/testsubject,
		"Interno de ciencias",
		"Pasante",
		"Asistente de campo")

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/research
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/expeditionary_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/civ/contractor = /decl/hierarchy/outfit/job/torch/passenger/research/assist,
		/datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/assist/solgov
	)
	max_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX,
	                    SKILL_SCIENCE     = SKILL_MAX)

	access = list(
		access_tox, access_tox_storage, access_research, access_petrov,
		access_mining_office, access_mining_station, access_xenobiology, access_guppy_helm,
		access_xenoarch, access_nanotrasen, access_solgov_crew, access_expedition_shuttle, access_guppy, access_hangar,
		access_petrov_analysis, access_petrov_phoron, access_petrov_toxins, access_petrov_chemistry, access_petrov_control,
		access_radio_sci, access_radio_exp
	)
	possible_goals = list(/datum/goal/achievement/notslimefodder)

/datum/job/scientist_assistant/get_description_blurb()
		return "Los asistentes de ciencias deambulan por el departamento de Ciencias en busca de un cientifico loco que necesita un Igor. Una vez que se encuentra a ese individuo, ofrece sus servicios como voluntario y proporciona lo que sea que el cientifico en cuestion necesite, ya sea cafe, alguien para completar el papeleo, un cerebro fresco o simplemente un idiota desafortunado con quien experimentar. sirve como un excelente punto de entrada para los que desean aprender mas sobre la investigacion."
