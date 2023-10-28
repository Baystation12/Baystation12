/datum/job/warden
	title = "Warden"
	department = "Охранный"
	department_flag = SEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "Главе Службы безопасности"
	economic_power = 8
	minimal_player_age = 14
	minimum_character_age = list(SPECIES_HUMAN = 26)
	ideal_character_age = 28
	alt_titles = list(
		"Security Sergeant",
		)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/security/warden
	allowed_branches = list(/datum/mil_branch/employee)
	allowed_ranks = list(/datum/mil_rank/civ/nt)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_TRAINED,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_HAULING	  = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_TRAINED,
	                    SKILL_FORENSICS   = SKILL_BASIC)

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_FORENSICS   = SKILL_MAX)
	skill_points = 25

	access = list(access_seceva, access_guard, access_security, access_brig, access_armory, access_forensics_lockers,
			            access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_gun, access_hangar, access_warden
			            )



	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

	// SIERRA TODO: need_exp_to_play
	// need_exp_to_play = 2

/datum/job/warden/get_description_blurb()
	return "Надзиратель отвечает за наблюдение, допрос, уход и безопасность заключенных, арестованных охранниками.\
	Как следует из названия, он несет ответственность за наблюдение за различными камерами и шкафами со снаряжением, доступным персоналу безопасности,\
	а также за надлежащую организацию проведения допросов подозреваемых и наказаний виновных.\
	Это включает в себя обновление их записей в базах данных, а также исполнение наказаний, в виде помещения в камеру."

/datum/job/detective
	title = "Criminal Investigator"
	department = "Охранный"
	department_flag = SEC
	hud_icon = "huddetective"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Главе Службы безопасности"
	economic_power = 5
	minimal_player_age = 7
	ideal_character_age = 35
	skill_points = 14
	alt_titles = list(
		"Forensic Technician"
		)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/security/detective
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/civilian, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor, /datum/mil_rank/civ/civ)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_BASIC,
	                    SKILL_FORENSICS   = SKILL_TRAINED)

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_FORENSICS   = SKILL_MAX)
	skill_points = 22

	access = list(access_seceva, access_security, access_brig, access_forensics_lockers,
			            access_maint_tunnels, access_emergency_storage, access_eva,
			            access_sec_doors, access_morgue, access_hangar)



	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/detective/get_description_blurb()
	return "Детектив занимается расследованием преступлений, взятием отпечатков пальцев, поиском потенциальных преступников и разрешением самых запутанных дел.\
	Его основная миссия - выяснить, кто совершил преступление и собрать все имеющиеся доказательства."

/datum/job/officer
	title = "Security Guard"
	department = "Охранный"
	department_flag = SEC
	total_positions = 4
	spawn_positions = 4
	supervisors = "Главе Службы безопасности и Смотрителю (сержанту)"
	economic_power = 6
	minimal_player_age = 10
	ideal_character_age = 25
	alt_titles = list("Junior Guard")

	skill_points = 20

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/security/officer
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_EVA         = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_HAULING     = SKILL_BASIC,
	                    SKILL_WEAPONS     = SKILL_TRAINED,
	                    SKILL_FORENSICS   = SKILL_BASIC)

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX)

	access = list(access_seceva, access_guard, access_security, access_brig, access_maint_tunnels,
						access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_hangar)



	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/datum/job/officer/get_description_blurb()
	return "Охранник - это основная должность отдела безопасности. Офицеры представляют собой первую линию защиты корабля от криминальных элементов и враждебных форм жизни. \
	 Со своими надежными дубинкой и тазером, охрана преследует различных нарушителей закона на судне и отправляет их в бриг отбывать заслуженное наказание. \
	 Главной задачей офицеров СБ является предотвращение ущерба персоналу корабля и собственности корпорации, и охранник который не ставит эти обязанности для себя на первое место имеет мало шансов задержаться на этой работе."

/datum/job/security_assistant
	title = "Security Cadet"
	department = "Охранный"
	department_flag = SEC

	total_positions = 2
	spawn_positions = 2
	supervisors = "Главе Службы безопасности и остальному охранному персоналу"
	economic_power = 3
	ideal_character_age = 21
	selection_color = "#601c1c"
	alt_titles = list("Security Recruit")

	min_skill = list(	SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_COMBAT      = SKILL_BASIC,
	                    SKILL_HAULING     = SKILL_BASIC)
	skill_points = 18

	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/security/assist
	allowed_branches = list(
			/datum/mil_branch/employee
		)
	allowed_ranks = list(
			/datum/mil_rank/civ/nt
		)

	access = list(access_seceva, access_security, access_brig, access_maint_tunnels,
						access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_hangar)



/datum/job/security_assistant/get_description_blurb()
	return "Кадетом может быть как молодой специалист, заканчивающий или уже кончивший свое обучение по специальности, так и более опытный человек, \
	например бывший военный, только стажирующийся, находящийся на испытательном сроке. Основное занятие кадета - патрулирование вместе с Офицером, либо же просмотр камер при нахождении в бриге."
