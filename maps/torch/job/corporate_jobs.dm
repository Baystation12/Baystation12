/datum/job/liaison
	title = "Workplace Liaison"
	department = "Поддержка командования"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	supervisors = "Корпоративным регуляциям, уставу профсоюза и Организации Экспедиционного Корпуса"
	selection_color = "#2f2f7f"
	economic_power = 18
	minimal_player_age = 0
	minimum_character_age = list(SPECIES_HUMAN = 25)
	alt_titles = list(
		"Corporate Liaison",
		"Union Representative",
		"Corporate Representative",
		"Corporate Executive"
		)
	outfit_type = /decl/hierarchy/outfit/job/torch/passenger/workplace_liaison
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(	/datum/mil_rank/civ/second,
							/datum/mil_rank/civ/first)
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
	return "Вы - Корпоративный связной. Вы гражданский служащий Организации Экспедиционного корпуса (ЭКСО) - государственного конгламерата корпораций, который частично спонсирует Факел. \
	Вы находитесь на борту судна для продвижения корпоративных интересов и защиты прав контрактников на борту в качестве лидера их профсоюза. Вы не служащий отдела внутренних дел. \
	Вы консультируете командование по вопросам связанными с корпоративными и профсоюзными интересами, а также по правам и обязанностям контрактников. Максимизируйте прибыль. \
	Станьте теневым корпоративным зазывалой, которым Вы всегда хотели быть."

/datum/job/synthetic  //PRX
	title = "Synthetic"
	supervisors = "Командующему офицеру судна и регуляциям судна"
	department = "Поддержка командования"
	department_flag = SPT
	minimal_player_age = 14
	economic_power = 0
	ideal_character_age = 1
	minimum_character_age = list(SPECIES_SHELL = 1)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/synth
	selection_color = "#2f2f7f"
	req_admin_notify = TRUE
	create_record = 1
	total_positions = 0
	spawn_positions = 1
	hud_icon = "hudsynthetic"
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/exo_synth
	)
	use_species_whitelist = SPECIES_SHELL

	min_skill = list(   SKILL_COMBAT      = SKILL_ADEPT,
						SKILL_WEAPONS	  = SKILL_NONE,

						SKILL_BUREAUCRACY  = SKILL_ADEPT,
						SKILL_FINANCE      = SKILL_EXPERT,
						SKILL_EVA          = SKILL_EXPERT,
						SKILL_MECH         = HAS_PERK,
						SKILL_PILOT        = SKILL_EXPERT,
						SKILL_HAULING      = SKILL_PROF,
						SKILL_COMPUTER     = SKILL_PROF,
						SKILL_BOTANY       = SKILL_ADEPT,
						SKILL_COOKING      = SKILL_ADEPT,
						SKILL_FORENSICS    = SKILL_EXPERT,
						SKILL_CONSTRUCTION = SKILL_EXPERT,
						SKILL_ELECTRICAL   = SKILL_EXPERT,
						SKILL_ATMOS        = SKILL_EXPERT,
						SKILL_ENGINES      = SKILL_EXPERT,
						SKILL_DEVICES      = SKILL_EXPERT,
						SKILL_SCIENCE      = SKILL_EXPERT,
						SKILL_MEDICAL      = SKILL_EXPERT,
						SKILL_ANATOMY      = SKILL_EXPERT,
						SKILL_CHEMISTRY    = SKILL_ADEPT)

	skill_points = 0

	software_on_spawn = list(
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console)

/datum/job/synthetic/post_equip_rank(var/mob/person, var/alt_title)
	var/mob/living/carbon/H = person
	var/obj/item/organ/internal/posibrain/posi = H.internal_organs_by_name[BP_POSIBRAIN]
	posi.shackle(new /datum/ai_laws/exo_synth)
	priority_announcement.Announce("Пробуждение синтетической единицы ЭКСО из общего хранилища завершено.", "Attention")

/datum/job/synthetic/get_description_blurb()
	return "Вы - продвинутый ИПК-Шелл ЭКСО. Вы были назначенны как помощник командного состава для выполнения различных задач, для которых Вы были обученны. \
	Мастер на все руки, но не мастер ни в чем. Вы не подчиняетесь законам ЦПСС или Военно-Юридическому кодексу ЦПСС, но подчиняетесь регуляциям судна. \
	Ваши законы строго запрещают Вам входить в прямой бой по любым причиням, кроме самозащиты. Вы не можете использовать летальную силу ни при каких обстоятельствах."
