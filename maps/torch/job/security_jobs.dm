/datum/job/warden
	title = "Brig Officer"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief of Security"
	economic_power = 5
	minimal_player_age = 7
	ideal_character_age = 35
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/brig_officer
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/brig_officer/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e6,
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

	access = list(access_security, access_brig, access_armory, access_forensics_lockers,
			            access_maint_tunnels, access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_solgov_crew, access_gun)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)
	required_education = EDUCATION_TIER_BASIC
	maximum_education = EDUCATION_TIER_BACHELOR

/datum/job/detective
	title = "Forensic Technician"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief of Security"
	economic_power = 5
	minimal_player_age = 7
	ideal_character_age = 35
	skill_points = 14
	alt_titles = list(
		"Criminal Investigator"
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
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/ec/e3,
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

	max_skill = list(   SKILL_COMBAT      = SKILL_MAX,
	                    SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_FORENSICS   = SKILL_MAX)
	skill_points = 20

	access = list(access_security, access_brig, access_forensics_lockers,
			            access_maint_tunnels, access_emergency_storage,
			            access_sec_doors, access_solgov_crew, access_morgue)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)
	required_education = EDUCATION_TIER_TRADE
	maximum_education = EDUCATION_TIER_MASTERS

/datum/job/officer
	title = "Master at Arms"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief of Security"
	economic_power = 4
	minimal_player_age = 7
	ideal_character_age = 25
	alt_titles = list()
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/security/maa
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/security/maa/fleet,
	)
	allowed_ranks = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/fleet/e2,
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
	                    SKILL_FORENSICS   = SKILL_MAX)

	access = list(access_security, access_brig, access_maint_tunnels,
						access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors, access_solgov_crew)
	minimal_access = list()

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)
	required_education = EDUCATION_TIER_BASIC
	maximum_education = EDUCATION_TIER_BACHELOR