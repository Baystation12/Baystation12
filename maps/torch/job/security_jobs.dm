/datum/job/warden
	title = "Brig Chief"
	department = "Охранный"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главе службы безопасности"
	economic_power = 5
	minimal_player_age = 7
	ideal_character_age = 35
	minimum_character_age = list(SPECIES_HUMAN = 27)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/brig_chief
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/brig_chief/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/security/brig_chief/army
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/army/e6,
		/datum/mil_rank/army/e7,
		/datum/mil_rank/army/e8,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8
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
	return "Вы - Смотритель. Вы отвечаете за cохранность брига и арсенала, а также проводите надзор за заключёнными. Вы подчиняетесь Главе службы безопасности. \
	Сообщайте охране информацию о преступлениях, смотрите камеры и пересчитывайте оружие в арсенале. От вас ожидается очень хорошее знание закона ЦПСС и основных регуляций судна."

/datum/job/detective
	title = "Forensic Technician"
	department = "Охранный"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Главе службы безопасности и Смотрителю"
	economic_power = 5
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 35
	skill_points = 14
	alt_titles = list(
		"Criminal Investigator",
		"Psionic Sleuth",
		"Psi-Operative"
	)  //PRX
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
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/sol/agent,
		/datum/mil_rank/sol/duty_agent,
		/datum/mil_rank/sol/senior_agent,
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

/datum/job/detective/equip(var/mob/living/carbon/human/H)
	if(H.mind?.role_alt_title == "Psionic Sleuth")
		psi_faculties = list("[PSI_PSYCHOKINESIS]" = PSI_RANK_MASTER)
	if(H.mind?.role_alt_title == "Psi-Operative")
		psi_faculties = list("[PSI_ENERGISTICS]" = PSI_RANK_MASTER)
	return ..()

/datum/job/detective/get_description_blurb()
	return "Вы - Криминалист. Ваша задача - проводить осмотр мест преступлений и раскрывать дела. Вы подчиняетесь Главе службы безопасности и Смотрителю. \
	Ищите и анализируйте улики, проводите допросы. От вас ожидается хорошее знание закона ЦПСС и основных регуляций судна."

/datum/job/officer
	title = "Master at Arms"
	department = "Охранный"
	total_positions = 4
	spawn_positions = 4
	supervisors = "Главе службы безопасности и Смотрителю"
	economic_power = 4
	minimal_player_age = 7
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 25
	alt_titles = list() // This is a hack. Overriding a list var with null does not actually override it due to the particulars of dm list init. Do not "clean up" without testing.
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/maa
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/maa/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/security/maa/army
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/army/e3,
		//datum/mil_rank/army/e4,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5
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

/datum/job/senior_scientist/get_description_blurb()
	return "Вы - Каптенармус. Ваша задача - поддерживать порядок на судне и защищать его от различных угроз. Вы подчиняетесь Главе службы безопасности и Смотрителю. \
	Проводите задержания, опрашивайте свидетелей. От вас ожидается хорошее знание закона ЦПСС и основных регуляций судна."

/* До лучших времен
/datum/job/officer/sfp
	title = "Police Enforcer"
	total_positions = 2
	spawn_positions = 2
	hud_icon = "hudmasteratarms"
	alt_titles = list(
		"Police Officer",
		"Police Operative"
	)
	allowed_branches = list(
		/datum/mil_branch/solgov = /decl/hierarchy/outfit/job/torch/crew/security/maa/agent
	)
	allowed_ranks = list(
		/datum/mil_rank/sol/junior_agent,
		/datum/mil_rank/sol/agent
	)
*/
