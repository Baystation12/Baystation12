/datum/job/chaplain
	title = "Chaplain"
	department = "Servicios"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 40
	economic_power = 6
	minimal_player_age = 0
	supervisors = "El Ejecutivo oficial"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/chaplain
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/chaplain/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/chaplain/fleet)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/ec/o1)
	min_skill = list(SKILL_BUREAUCRACY = SKILL_BASIC)

	access = list(
		access_morgue, access_chapel_office,
		access_crematorium, access_solgov_crew,
		access_radio_serv
	)

/datum/job/chaplain/get_description_blurb()
		return "El sacerdote brinda apoyo religioso y espiritual a la tripulacion en general. Esto puede incluir asesoramiento espiritual, servicios de adoracion y ceremonias como bodas y funerales. Los servicios que realiza tu personaje se basan en la religion que practica, asi como en sus propias tradiciones. Es responsable de todo lo relacionado con la fe a bordo de la nave y debe estar preparado para ayudar a las personas a practicar su fe, asi como mantener la Capilla en un ambiente ordenado y acogedor para todos. Puede hablar con las personas en su oficina, asi como realizar confesiones u otros servicios segun su propia fe."

/datum/job/janitor
	title = "Sanitation Technician"
	department = "Servicios"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	supervisors = "El Ejecutivo oficial"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	alt_titles = list(
		"Concerje")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/janitor
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/janitor/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/janitor/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4
	)
	min_skill = list(   SKILL_HAULING = SKILL_BASIC)

	access = list(
		access_maint_tunnels, access_emergency_storage,
		access_janitor, access_solgov_crew,
		access_radio_serv
	)

/datum/job/janitor/get_description_blurb()
		return "Como Tecnico Sanitario, tienes uno de los trabajos mas sencillos a bordo del barco: encontrar lugares que esten sucios y hacer que dejen de estarlo, asi como desatascar inodoros o lavabos y cambiar luces. Todo esto se reduce en gran medida a tirar del carrito de limpieza, colocar letreros de piso mojado y limpiar cualquier suciedad, sangre u otras sustancias que se hayan derramado en el piso. Ocasionalmente, algun departamento u otro puede hacer una llamada especifica para asistencia de limpieza cuando se rompen algunas luces o un tiroteo deja el lugar como una carniceria, pero aparte de esto, se espera que el Tecnico Sanitario trabaje bajo su propia direccion."

/datum/job/chef
	title = "Steward"
	department = "Servicios"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	minimum_character_age = list(SPECIES_HUMAN = 18)
	supervisors = "El Ejecutivo oficial"
	alt_titles = list(
		"Camarero",
		"Cocinero",
		"Especialista culinario",
		"Cantinero"
	)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/cook
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/service/cook/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/cook/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4
	)
	min_skill = list(
		SKILL_BOTANY = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC,
		SKILL_COOKING = SKILL_ADEPT
	)
	access = list(
		access_commissary,
		access_hydroponics,
		access_kitchen,
		access_radio_serv,
		access_solgov_crew
	)

/datum/job/chef/get_description_blurb()
		return "El Mayordomo es el administrador de la cocina y el comedor de la nave, responsable de preparar la comida para la tripulacion y mantenerlos lo suficientemente ebrios como para comprender los horrores diarios de su existencia. Desenvolver el papel de cocinero, camarero y anfitrion: no solo tienen la tarea de administrar la cocina y el bar, sino tambien de hacer que el comedor sea un lugar agradable y acogedor para comer, beber y pasar el rato. Inicie la conversacion, preguntele a la tripulacion como estuvo su dia, invente algunos especiales y, en general, haga que la experiencia gastronomica de las personas sea divertida!"

/datum/job/crew
	title = "Crewman"
	department = "Service"
	department_flag = SRV
	total_positions = 5
	spawn_positions = 5
	supervisors = "El Ejecutivo oficial y el personal de la nave"
	alt_titles = list(
		"Aprendiz de tripulante")
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/service/crewman
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/crewman/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4
	)

	access = list(
		access_maint_tunnels, access_emergency_storage,
		access_solgov_crew, access_radio_serv
	)

/datum/job/crew/get_description_blurb()
		return "El Tripulante es el miembro de menor rango del personal no civil a bordo del barco; de hecho, en la mayoria de las situaciones, generalmente se supondra que cualquier miembro del personal civil es mas competente que un Tripulante. Tienen poca o ninguna autoridad o responsabilidad en el barco, y esencialmente existen para hacer cualquier trabajo que nadie mas quiera hacer."
