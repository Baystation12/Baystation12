/datum/job/senior_doctor
	title = "Physician"
	department = "Медицинский"
	department_flag = MED
	minimal_player_age = 2
	minimum_character_age = list(SPECIES_HUMAN = 29)
	ideal_character_age = 45
	total_positions = 2
	spawn_positions = 2
	supervisors = "Главный медицинский офицер"
	selection_color = "#013d3b"
	economic_power = 10
	alt_titles = list(
		"Surgeon")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/senior
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/senior/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/senior,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/medical/senior/army
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/army/o1,
		/datum/mil_rank/army/o2,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_MEDICAL     = SKILL_EXPERT,
	                    SKILL_ANATOMY     = SKILL_EXPERT,
	                    SKILL_CHEMISTRY   = SKILL_BASIC,
						SKILL_DEVICES     = SKILL_ADEPT)

	max_skill = list(   SKILL_MEDICAL     = SKILL_MAX,
	                    SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_CHEMISTRY   = SKILL_MAX)
	skill_points = 20

	access = list(
		access_medical, access_morgue, access_virology, access_maint_tunnels, access_emergency_storage,
		access_crematorium, access_chemistry, access_surgery,
		access_medical_equip, access_solgov_crew, access_senmed, access_radio_med
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

/datum/job/senior_doctor/get_description_blurb()
	return "Вы - Врач. Ваша обязанность - проводить операции и обучать врачей-ординаторов. Вы подчиняетесь Главному медицинскому офицеру. \
	Обеспечивайте бесперебойную работу медицинского отсека и следите за количеством лекарств, крови и прочего. Жизнь людей - в ваших руках."

/datum/job/junior_doctor
	title = "Medical Resident"
	department = "Медицинский"
	department_flag = MED
	minimal_player_age = 2
	minimum_character_age = list(SPECIES_HUMAN = 24)
	ideal_character_age = 45
	total_positions = 1
	spawn_positions = 1
	supervisors = "Врачам и Главному медицинскому офицеру"
	selection_color = "#013d3b"
	economic_power = 6
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/senior
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/senior/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/senior,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/medical/junior/army
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/army/o1,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ
	)
	min_skill = list(   SKILL_BUREAUCRACY = SKILL_BASIC,
	                    SKILL_MEDICAL     = SKILL_EXPERT,
	                    SKILL_ANATOMY     = SKILL_EXPERT,
	                    SKILL_CHEMISTRY   = SKILL_BASIC,
						SKILL_DEVICES     = SKILL_ADEPT)

	max_skill = list(   SKILL_MEDICAL     = SKILL_MAX,
	                    SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_CHEMISTRY   = SKILL_MAX)
	skill_points = 16

	access = list(
		access_medical, access_morgue, access_virology, access_maint_tunnels, access_emergency_storage,
		access_crematorium, access_chemistry, access_surgery,
		access_medical_equip, access_solgov_crew, access_senmed, access_radio_med
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

/datum/job/junior_doctor/get_description_blurb()
	return "Вы - Врач-ординатор. Ваша обязанность - проводить лечение пациентов и обучатся тонкостям медицины благодаря помощи старших врачей. Вы подчиняетесь Главному медицинскому офицеру. \
	Лечите людей, проводите операции и постарайтесь никого не убить."

/datum/job/doctor
	title = "Medical Technician"
	department = "Медицинский"
	total_positions = 3
	spawn_positions = 3
	supervisors = "Врачам и Главному медицинскому офицеру"
	economic_power = 7
	minimum_character_age = list(SPECIES_HUMAN = 19)
	ideal_character_age = 40
	minimal_player_age = 0
	alt_titles = list(
		"Paramedic",
		"Corpsman")
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/doctor
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/medical/contractor,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/army
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/army/e3,
		//datum/mil_rank/army/e4,
		/datum/mil_rank/army/e4_alt,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/army/e6,
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/civ
	)
	min_skill = list(   SKILL_EVA     = SKILL_BASIC,
	                    SKILL_MEDICAL = SKILL_BASIC,
	                    SKILL_ANATOMY = SKILL_BASIC)

	max_skill = list(   SKILL_MEDICAL     = SKILL_MAX,
	                    SKILL_CHEMISTRY   = SKILL_MAX)

	access = list(
		access_medical, access_morgue, access_maint_tunnels,
		access_external_airlocks, access_emergency_storage,
		access_eva, access_surgery, access_medical_equip,
		access_solgov_crew, access_hangar, access_radio_med
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)
	skill_points = 22

/datum/job/doctor/get_description_blurb()
	return "Вы - Парамедик. Ваша обязанность - оказывать первую помощь и доставлять пациентов в медицинский отсек. Вы подчиняетесь Главному медицинскому офицеру и Врачам. \
	Жизнь людей зависит от Вашей скорости."

/datum/job/medical_trainee
	title = "Trainee Medical Technician"
	department = "Медицинский"
	department_flag = MED
	total_positions = 1
	spawn_positions = 1
	supervisors = "остальному медицинскому персоналу и Главному медицинскому офицеру"
	selection_color = "#013d3b"
	minimum_character_age = list(SPECIES_HUMAN = 18)
	ideal_character_age = 20
	alt_titles = list(
		"Corpsman Trainee",
		"Paramedic Trainee")  //PRX

	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/doctor
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/fleet,
		/datum/mil_branch/army = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/army
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/army/e2
	)

	skill_points = 4
	no_skill_buffs = TRUE

	min_skill = list(   SKILL_EVA     = SKILL_ADEPT,
	                    SKILL_HAULING = SKILL_ADEPT,
	                    SKILL_MEDICAL = SKILL_EXPERT,
	                    SKILL_ANATOMY = SKILL_BASIC)

	max_skill = list(   SKILL_MEDICAL     = SKILL_MAX,
	                    SKILL_ANATOMY     = SKILL_MAX,
	                    SKILL_CHEMISTRY   = SKILL_MAX)

	access = list(
		access_medical, access_morgue, access_maint_tunnels,
		access_external_airlocks, access_emergency_storage,
		access_surgery, access_medical_equip, access_solgov_crew,
		access_radio_med
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

/datum/job/medical_trainee/get_description_blurb()
	return "Вы - Парамедик-стажёр. Вы учитесь основам медицины благодаря помощи Ваших более опытных коллег. Вы подчиняетесь остальному медицинскому персоналу."


/datum/job/chemist
	title = "Pharmacist"
	department = "Медицинский"
	department_flag = MED
	total_positions = 1
	spawn_positions = 1
	supervisors = "остальному медицинскому персоналу, корпоративному связному и Главному медицинскому офицеру"
	selection_color = "#013d3b"
	economic_power = 4
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 30
	minimal_player_age = 7
	alt_titles = list(
		"Chemist",
		"Chemical Laboratory Technician"
	)
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/chemist
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/chemist/ec)

	allowed_ranks = list(
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/ec/o1)

	min_skill = list(   SKILL_MEDICAL   = SKILL_BASIC,
	                    SKILL_CHEMISTRY = SKILL_ADEPT)

	max_skill = list(   SKILL_MEDICAL     = SKILL_BASIC,
						SKILL_ANATOMY	  = SKILL_BASIC,
	                    SKILL_CHEMISTRY   = SKILL_MAX)
	skill_points = 16

	access = list(
		access_medical, access_maint_tunnels, access_emergency_storage,
		access_medical_equip, access_solgov_crew, access_chemistry,
	 	access_virology, access_morgue, access_crematorium, access_radio_med
	)

/datum/job/chemist/get_description_blurb()
	return "Вы - Фармацевт. Вы изготавливаете медицину и другие полезные субстанции. Вы не доктор или медик. Вам не следует лечить пациентов, вы должны предоставлять медицину для их лечения. \
	Вы подчиняетесь Врачам и Парамедикам (в случае, если Вы контрактник, то ещё и Корпоративному связному)."

/datum/job/psychiatrist
	title = "Counselor"
	department = "Медицинский"
	total_positions = 1
	spawn_positions = 1
	ideal_character_age = 40
	economic_power = 5
	minimum_character_age = list(SPECIES_HUMAN = 24)
	minimal_player_age = 0
	supervisors = "Главному медицинскому офицеру"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/medical/counselor
	alt_titles = list(
		"Psychiatrist",
		"Psionic Counselor" = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/mentalist,
		"Mentalist" = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/mentalist

	)

	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/expeditionary_corps = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/ec,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/fleet)
	allowed_ranks = list(
		/datum/mil_rank/civ/three,
		/datum/mil_rank/civ/second,
		/datum/mil_rank/civ/first,
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/army/o1,
		/datum/mil_rank/army/o2,
		/datum/mil_rank/ec/o1)
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_MEDICAL     = SKILL_BASIC
	)
	max_skill = list(
		SKILL_MEDICAL     = SKILL_MAX
	)
	access = list(
		access_medical, access_psychiatrist,
		access_solgov_crew, access_medical_equip, access_radio_med
	)

	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)
	give_psionic_implant_on_join = FALSE

/datum/job/psychiatrist/equip(var/mob/living/carbon/human/H)
	if(H.mind?.role_alt_title == "Psionic Counselor")
		psi_faculties = list("[PSI_REDACTION]" = PSI_RANK_OPERANT)
	if(H.mind?.role_alt_title == "Mentalist")
		psi_faculties = list("[PSI_COERCION]" = PSI_RANK_OPERANT)
	return ..()

/datum/job/psychiatrist/get_description_blurb()
		return "Вы - Консультант. Ваша главная обязанность - поддерживать ментальное здоровье экипажа в тонусе. Вы подчиняетесь Главному медицинскому офицеру."
