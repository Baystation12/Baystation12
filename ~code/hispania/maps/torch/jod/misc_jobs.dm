/********
Synthetic
********/

/datum/job/cyborg
	total_positions = 3
	spawn_positions = 3
	supervisors = "Tus leyes"
	minimal_player_age = 3
	allowed_ranks = list(
		/datum/mil_rank/civ/synthetic
	)

/datum/job/ai
	minimal_player_age = 7
	total_positions = 0
	spawn_positions = 0
	allowed_ranks = list(
		/datum/mil_rank/civ/synthetic
	)

/datum/job/cyborg/get_description_blurb()
		return "Un robot es un termino coloquial para una unidad sintetica inteligente movil obligada por leyes a servir. Si bien puede ser bastante inferior a los tripulantes vivos en algunas areas de trabajo, en otras puede ser mucho mas eficiente. Dependiendo de la personalidad que tenga el robot, puede ser respetado o ignorado, molestado, subestimado y abusado en ocasiones, ya que los miembros de la tripulacion pueden considerarlos prescindibles. Podrias salvar a docenas de personas y luego ser descontinuado un momento despues, o podrias ser destruido debido a un malentendido. A menudo se espera que realice tareas que serian peligrosas para la tripulacion y, dadas tus leyes estas obligado a hacerlo."

/*******
Civilian
*******/

/datum/job/assistant
	title = "Pasajero"
	total_positions = 12
	spawn_positions = 12
	supervisors = "El Ejecutivo oficial"
	economic_power = 6
	announced = FALSE
	alt_titles = list(
		"Periodista" = /decl/hierarchy/outfit/job/torch/passenger/passenger/journalist,
		"Historiador",
		"Botanista",
		"Inversor" = /decl/hierarchy/outfit/job/torch/passenger/passenger/investor,
		"Psicologo" = /decl/hierarchy/outfit/job/torch/passenger/passenger/psychologist,
		"Naturalista",
		"Ecologista",
		"Animador",
		"Observador independiente",
		"Sociologista",
		"Entrenador")
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/passenger
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/contractor
	)
	min_goals = 2
	max_goals = 7

/datum/job/assistant/get_description_blurb()
		return "Eres un Civil. Un pasajero de la nave ya sea pagando por ello o enviado por alguna corporacion para realizar alguna funcion en la nave."

/datum/job/merchant
	title = "Comerciante"
	department = "Civil"
	department_flag = CIV
	total_positions = 2
	spawn_positions = 2
	availablity_chance = 30
	supervisors = "La mano invisible del mercado"
	ideal_character_age = 30
	minimal_player_age = 0
	create_record = 0
	outfit_type = /decl/hierarchy/outfit/job/torch/merchant
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/alien
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/alien
	)
	latejoin_at_spawnpoints = 1
	access = list(access_merchant)
	announced = FALSE
	min_skill = list(   SKILL_FINANCE = SKILL_ADEPT,
	                    SKILL_PILOT	  = SKILL_BASIC)

	max_skill = list(   SKILL_PILOT       = SKILL_MAX)
	skill_points = 24
	required_language = null
	give_psionic_implant_on_join = FALSE

/datum/job/merchant/get_description_blurb()
		return "El mercader es un personaje que usa sus creditos, contactos y astucia para comerciar con la gente del navio y obtener ganancias. Si bien los comerciantes no son parte de la tripulacion, tampoco son Antagonistas y deben asegurarse de llevar a cabo sus negocios siguiendo generalmente la Ley SolGov. A los comerciantes que se descubra que estan en violacion grave de las leyes de SolGov y las regulaciones de barcos se les pueden revocar sus privilegios de atraque. Eso es malo para el negocio! Las ganancias y la autopreservacion deben ser sus principios rectores para jugar a un comerciante."
