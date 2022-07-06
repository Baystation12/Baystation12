/datum/job/liaison
	title = "Workplace Liaison"
	department = "Support"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	supervisors = "Corporate Regulations, the Union Charter, and the Expeditionary Corps Organisation"
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
	return "You are the Workplace Liaison. You are a civilian employee of EXO, the Expeditionary Corps Organisation, the government-owned corporate conglomerate that partially funds the Torch. You are on board the vessel to promote corporate interests and protect the rights of the contractors on board as their union leader. You are not internal affairs. You advise command on corporate and union matters and contractors on their rights and obligations. Maximise profit. Be the shady corporate shill you always wanted to be."

/datum/job/synthetic
	title = "Synthetic"
	supervisors = "The SEV Torch's acting command offcer, it's regulations and laws of SCG."
	department = "Support"
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
	hud_icon = "hudworkplaceliaison"
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
	priority_announcement.Announce("Синтетик ЭКСО закончил пробуждения из Криогенного Хранилища судна.", "Attention!")

/datum/job/synthetic/get_description_blurb()
	return "You are advanced EXO's Shell IPC. You were assigned as the command staff's assistant for various tasks you have been trained. Jack of all tools, but master of none. You are no subject to laws or SCUJ, but your assigned object's regulations. Your shackles strictly forbids you to engage in direct combat for any reasons aside of self deffense. You can't use lethal force at any moment of your work."
