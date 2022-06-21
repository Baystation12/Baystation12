/datum/job/warden
	title = "Brig Chief"
	total_positions = 1
	spawn_positions = 1
	supervisors = "El Jefe de seguridad"
	economic_power = 5
	minimal_player_age = 7
	ideal_character_age = 35
	minimum_character_age = list(SPECIES_HUMAN = 27)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/brig_chief
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/brig_chief/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8,
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_ADEPT,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_ADEPT,
	                    SKILL_FORENSICS   = SKILL_BASIC)

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_FORENSICS   = SKILL_MAX)
	skill_points = 20

	access = list(
		access_security, access_brig, access_armory, access_forensics_lockers,
		access_maint_tunnels, access_external_airlocks, access_emergency_storage,
		access_eva, access_sec_doors, access_solgov_crew, access_gun, access_torch_fax,
		access_radio_sec
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/warden/get_description_blurb()
		return "El Agente supervisor de seguridad, en un universo ideal, nunca tiene que abandonar el departamento de seguridad. Como su nombre lo indica, son responsables de cuidar las diversas celdas y areas de detencion disponibles para el departamento de Seguridad, asi como de asegurarse de que todo el personal acusado sea tratado adecuadamente y castigado apropiadamente. Esto incluye actualizar sus registros para reflejar los cargos en su contra y los castigos administrados, ademas de arrastrarlos a las celdas y cerrar la puerta. gestiona las asignaciones y ordenes de patrulla de seguridad, coordinando a los Agentes de seguridad para garantizar que el barco este completamente seguro."

/datum/job/detective
	title = "Forensic Technician"
	total_positions = 1
	spawn_positions = 1
	supervisors = "El Jefe de seguridad"
	economic_power = 5
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 35
	skill_points = 14
	alt_titles = list(
		"Investigador criminal",
		"Detective"
	)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/contractor,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/fleet,
		/datum/mil_branch/solgov = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/agent
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/sol/agent
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_BASIC,
	                    SKILL_FORENSICS   = SKILL_ADEPT)

	max_skill = list(   SKILL_COMBAT      = SKILL_EXPERT,
	                    SKILL_WEAPONS     = SKILL_EXPERT,
	                    SKILL_FORENSICS   = SKILL_MAX)
	skill_points = 20

	access = list(
		access_security, access_brig, access_forensics_lockers,
		access_maint_tunnels, access_emergency_storage,
		access_sec_doors, access_solgov_crew, access_morgue,
		access_torch_fax, access_network, access_radio_sec
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/detective/get_description_blurb()
		return "El tecnico forense tiene acceso a una amplia variedad de equipos, desde iluminacion ultravioleta hasta camaras, limpiadores de huellas dactilares, microscopios electronicos y espectrometros de masas portatiles. Cada uno de estos dispositivos tiene una funcion unica para ayudar a rastrear e identificar a los perpetradores de cualquier delito cometido en la estacion. El trabajo del tecnico forense es asegurar las escenas del crimen, entrevistar a los testigos y examinar minuciosamente las pruebas resultantes. A traves de un analisis cuidadoso, convertiran esta evidencia en una descripcion clara de lo que sucedio, quien lo hizo y como."

/datum/job/officer
	title = "Master at Arms"
	total_positions = 4
	spawn_positions = 4
	supervisors = "El Jefe de seguridad"
	economic_power = 4
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 25
	alt_titles = list() // This is a hack. Overriding a list var with null does not actually override it due to the particulars of dm list init. Do not "clean up" without testing.
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/maa
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/maa/fleet,
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_ADEPT,
	                    SKILL_FORENSICS   = SKILL_BASIC)

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_FORENSICS   = SKILL_EXPERT)

	access = list(
		access_security, access_brig, access_maint_tunnels,
		access_external_airlocks, access_emergency_storage,
		access_eva, access_sec_doors, access_solgov_crew,
		access_radio_sec
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/officer/get_description_blurb()
		return "Los Agentes de seguridad son muy simples en teoria, pero muy exigentes en la practica: deben patrullar el barco, detener a los infractores de la ley y neutralizar a los hostiles, todo mientras obedecen la ley ellos mismos. Son los primeros en la linea de fuego en caso de que el barco sea atacado por fuerzas hostiles, ya sea desde dentro o desde fuera. Son los defensores de la nave y todo su personal. Debe conocer la Ley del Gobierno Central del Sol en todas sus formas, asi como aplicarla de manera efectiva ademas de ser capaz y efectivo en el combate."
