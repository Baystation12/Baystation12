/datum/job/liaison
	title = "Workplace Liaison"
	department = "Apoyo"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	supervisors = "Regulaciones corporativas, La Carta sindical y La Organización del Cuerpo Expedicionario"
	selection_color = "#2f2f7f"
	economic_power = 18
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 25)
	alt_titles = list(
		"Enlace corporativo",
		"Representante sindical",
		"Representante corporativo",
		"Ejecutivo corporativo"
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
	return "Eres el Representante de EXO. Usted es un empleado civil de EXO, la organizacion del Cuerpo Expedicionario, el conglomerado corporativo propiedad del gobierno que financia parcialmente la antorcha. Usted esta a bordo la nave para promover intereses corporativos y proteger los derechos de los contratistas a bordo como su lider sindical. No eres asuntos internos. Usted asesora al comando sobre distintos asuntos, contratistas corporativos, derechos sindicales y las obligaciones en los distintos puestos de trabajo. Maximizar la productividad. Se el abuson corporativo que siempre quisiste ser."
