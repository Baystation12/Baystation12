/datum/job/senior_doctor
	title = "Surgeon"
	supervisors = "Главному врачу"
	department = "Медицинский"
	department_flag = MED

	minimal_player_age = 14
	minimum_character_age = list(SPECIES_HUMAN = 28)
	ideal_character_age = 45
	economic_power = 8
	skill_points = 26

	total_positions = 2
	spawn_positions = 2
	selection_color = "#013d3b"
	alt_titles = list(
		"Xenosurgeon" = /singleton/hierarchy/outfit/job/sierra/crew/medical/senior/xenosurgeon,
		"Trauma Surgeon" = /singleton/hierarchy/outfit/job/sierra/crew/medical/senior/traumasurgeon
	)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/medical/senior
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_MEDICAL     = SKILL_TRAINED,
		SKILL_ANATOMY     = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_VIROLOGY    = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL     = SKILL_MAX,
		SKILL_ANATOMY     = SKILL_MAX
	)
	access = list(
		access_medical, access_morgue, access_virology,
		access_maint_tunnels, access_emergency_storage, access_crematorium,
		access_surgery, access_eva, access_external_airlocks,
		access_medical_equip, access_senmed, access_hangar,
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)
	// SIERRA TODO: need_exp_to_play
	// need_exp_to_play = 2

/datum/job/senior_doctor/get_description_blurb()
	return "Хирург - основная медицинская сила корабля. В отличие от парамедика, который обычно заботится о том, чтобы вытащить пострадавших из места происшествия и оказать базовую неотложную помощь на месте,\
	вкупе с предоперационным лечением пострадавших, спектр активности хирурга является несколько более широким, начиная от обычного лечения медикаментами в случае необходимости и заканчивая проведением сложных хирургических операций."

/datum/job/doctor
	title = "Doctor"
	supervisors = "Главному Врачу"
	department = "Медицинский"
	department_flag = MED
	total_positions = 3
	spawn_positions = 3

	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 26
	economic_power = 7
	skill_points = 22

	alt_titles = list(
		"Paramedic" = /singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/paramedic
	)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/medical/doctor
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(
		SKILL_EVA		=	SKILL_BASIC,
		SKILL_MEDICAL	=	SKILL_BASIC,
		SKILL_ANATOMY	=	SKILL_BASIC
	)

	max_skill = list(
		SKILL_MEDICAL	=	SKILL_MAX,
		SKILL_VIROLOGY	=	SKILL_MAX
	)
	access = list(
		access_medical, access_morgue, access_virology,
		access_maint_tunnels, access_external_airlocks, access_emergency_storage,
		access_eva, access_surgery, access_medical_equip,
		access_hangar
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)

/datum/job/doctor/get_description_blurb()
	return "В отличии от хирургов, врач, а также парамедик, занимаются лечением обычных ранений и травм. Обычно они не имеют высшего медицинского образования, но они всё равно являются опорой медбея."

/datum/job/doctor_trainee
	title = "Intern"
	supervisors = "Главному Врачу и остальному медицинскому персоналу"
	department = "Медицинский"
	department_flag = MED

	minimum_character_age = list(SPECIES_HUMAN = 20)
	ideal_character_age = 21
	economic_power = 3
	skill_points = 18

	total_positions = 2
	spawn_positions = 2
	selection_color = "#013d3b"
	alt_titles = list(
		"Orderly" = /singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/orderly,
		"Nurse" = /singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/nurse
	)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/medical/doctor
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor
	)
	min_skill = list(
		SKILL_EVA = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL = SKILL_MAX
	)
	access = list(
		access_medical, access_morgue, access_surgery,
		access_medical_equip, access_maint_tunnels, access_emergency_storage,
		access_external_airlocks, access_hangar
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)

/datum/job/doctor_trainee/get_description_blurb()
	return "Интерн является самым младшим членом медицинского персонала, который учится искусству лечения у других врачей.\
	Оказывайте помощь другому медперсоналу, будь то химик или даже консультант - Вы здесь самые младшие. Будьте аккуратны и внимательны, и скоро станете настоящим врачом."

/datum/job/chemist
	title = "Chemist"
	supervisors = "Главному Врачу"
	department = "Медицинский"
	department_flag = MED

	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 26
	economic_power = 5
	skill_points = 18

	total_positions = 1
	spawn_positions = 1
	selection_color = "#013d3b"
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/chemist
	allowed_branches = list(/datum/mil_branch/employee, /datum/mil_branch/contractor)
	allowed_ranks = list(/datum/mil_rank/civ/nt, /datum/mil_rank/civ/contractor)
	min_skill = list(
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_TRAINED
	)
	max_skill = list(
		SKILL_MEDICAL = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)
	access = list(
		access_medical, access_maint_tunnels, access_emergency_storage,
		access_medical_equip, access_chemistry
	)


/datum/job/chemist/get_description_blurb()
	return "Химик - специалист с химическим либо фармацевтическим образованием.\
	Основная его задача заключается в снабжении медбея необходимыми препаратами. Так же он может принимать заказы от других членов экипажа, будь то лекарства, чистящие средства, гербициды и прочее."

/datum/job/psychiatrist
	title = "Counselor"
	supervisors = "Главному Врачу"
	department = "Медицинский"
	department_flag = MED

	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 30
	economic_power = 8

	total_positions = 1
	spawn_positions = 1
	alt_titles = list(
		"Mentalist" = /singleton/hierarchy/outfit/job/sierra/crew/medical/counselor/mentalist
	)
	outfit_type = /singleton/hierarchy/outfit/job/sierra/crew/medical/counselor
	allowed_branches = list(
		/datum/mil_branch/employee,
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL = SKILL_MAX
	)
	access = list(
		access_medical, access_morgue, access_chapel_office,
		access_crematorium, access_psychiatrist
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)
	give_psionic_implant_on_join = FALSE

/datum/job/psychiatrist/equip(mob/living/carbon/human/H)
	if(H.mind.role_alt_title == "Counselor")
		psi_faculties = list("[PSI_REDACTION]" = PSI_RANK_OPERANT)
	if(H.mind.role_alt_title == "Mentalist")
		psi_faculties = list("[PSI_COERCION]" = PSI_RANK_OPERANT)
	return ..()

/datum/job/psychiatrist/get_description_blurb()
	return "Вы - друг, наставник, священник... Или обычный психотерапевт. Помимо своих прямых обязанностей в обеспечении \
	персонала качественной (насколько это возможно) психологической помощью, у вас имеется особенность - вы псионически \
	одарены. Корпорация хорошо платит вам за то, чтобы вы проводили псионическое обследования членов экипажа на \
	предмет обладания особыми силами, естественно, с отчетом об этом. Ваша зарплата превышает таковую у \
	среднестатистческого менталиста из Фонда, и, вероятно, не просто так.<hr>В то время, как Менталист склонен к \
	исправлению психологических недугов, поиску псионики и даже чтению мыслей, Советник может проводить медицинскую \
	диагностику и слабое лечение."
