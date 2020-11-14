// Consist of modular changes, for now.

// Command
// Captain is basically a modular fix.
/datum/job/captain
	allowed_branches = list(
		/datum/mil_branch/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o6
	)

/datum/job/hop
	allowed_branches = list(
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/XO/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/XO/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o5,
		/datum/mil_rank/marine_corps/o4,
		/datum/mil_rank/marine_corps/o5
	)

/datum/job/rd
	allowed_branches = list(
		/datum/mil_branch/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o5
	)

/datum/job/cmo
	allowed_branches = list(
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/cmo/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/cmo/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o5,
		/datum/mil_rank/marine_corps/o4,
		/datum/mil_rank/marine_corps/o5
	)

/datum/job/chief_engineer
	allowed_branches = list(
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3
	)

/datum/job/hos
	allowed_branches = list(
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/cos/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/cos/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3
	)

/datum/job/sea/marine
	title = "SMC Attache"
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/sea/marineattache
	minimum_character_age = list(SPECIES_HUMAN = 21,SPECIES_UNATHI = 21,SPECIES_SERGAL = 21, SPECIES_SKRELL = 21, SPECIES_PROMETHEAN = 21, SPECIES_YEOSA = 21, SPECIES_VASS = 21, SPECIES_TAJ = 21, SPECIES_CUSTOM = 21, SPECIES_AKULA = 21)
	allowed_branches = list(
		/datum/mil_branch/marine_corps
	)
	allowed_ranks = list(
		/datum/mil_rank/marine_corps/e8_alt,
		/datum/mil_rank/marine_corps/e9,
		/datum/mil_rank/marine_corps/e9_alt,
		/datum/mil_rank/marine_corps/o1,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3
	)

/datum/job/bridgeofficer
	alt_titles = list(
		"Helmsman",
		"Tactical Officer",
		"Sensor Operator"
	)
	allowed_branches = list(
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine_corps/o1,
		/datum/mil_rank/marine_corps/o2
	)
/***/

// Engineering
/datum/job/senior_engineer
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/fleet/w1,
		/datum/mil_rank/fleet/w2,
		/datum/mil_rank/marine_corps/e6,
		/datum/mil_rank/marine_corps/e7,
		/datum/mil_rank/marine_corps/e8,
		/datum/mil_rank/marine_corps/w1,
		/datum/mil_rank/marine_corps/w2

	)

/datum/job/engineer
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/engineering/contractor,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5,
		/datum/mil_rank/civ/contractor
	)

/datum/job/engineer_trainee
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/engineering/engineer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3
	)
/***/

// Exploration
/datum/job/pathfinder
	allowed_branches = list(/datum/mil_branch/fleet)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3
	)

/datum/job/nt_pilot
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot,
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor = /decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot,
		/datum/mil_rank/fleet/w1 = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot/fleet,
		/datum/mil_rank/fleet/w2 = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot/fleet,
		/datum/mil_rank/fleet/w3 = /decl/hierarchy/outfit/job/torch/crew/exploration/pilot/fleet
	)

/datum/job/explorer
	alt_titles = list(
		"Exploratory Technician" = /decl/hierarchy/outfit/job/torch/crew/exploration/technician,
		"Exploratory Medic" = /decl/hierarchy/outfit/job/torch/crew/exploration/medic
	)
	allowed_branches = list(/datum/mil_branch/fleet)

	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5
	)
	min_skill = list(SKILL_EVA     = SKILL_ADEPT,
					 SKILL_SCIENCE = SKILL_BASIC,
					 SKILL_COMBAT  = SKILL_BASIC)
/***/

// Medical
/datum/job/senior_doctor
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/medical/contractor/senior,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/medical/senior/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/marine_corps/o3,
		/datum/mil_rank/marine_corps/o4,
		/datum/mil_rank/civ/contractor
	)

/datum/job/doctor
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/medical/contractor,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5,
		/datum/mil_rank/marine_corps/e6,
		/datum/mil_rank/civ/contractor
	)

/datum/job/medical_trainee
	allowed_branches = list(
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/medical/doctor/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3
	)

/datum/job/psychiatrist
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/ec,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/medical/counselor/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3
	)
/***/

// Research
/datum/job/senior_scientist
	allowed_branches = list(
		/datum/mil_branch/fleet
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/fleet/o4
	)

/datum/job/scientist
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/civ/contractor = /decl/hierarchy/outfit/job/torch/passenger/research/scientist,
		/datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/scientist/solgov
	)

/datum/job/scientist_assistant
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/civ/contractor = /decl/hierarchy/outfit/job/torch/passenger/research/assist,
		/datum/mil_rank/sol/scientist = /decl/hierarchy/outfit/job/torch/passenger/research/assist/solgov
	)
/***/

// Security
/datum/job/warden
	title = "Brig Chief"
	alt_titles = list(
		"Warden"
	)
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/security/brig_chief/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/marine_corps/e6,
		/datum/mil_rank/marine_corps/e7,
		/datum/mil_rank/marine_corps/e8
	)

/datum/job/detective
	allowed_branches = list(
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/contractor,
		/datum/mil_branch/private_security,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/marine,
		/datum/mil_branch/solgov = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/agent
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/private_security/pcrc_agt = /decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/pcrc_agent,
		/datum/mil_rank/sol/agent,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5
	)

/datum/job/officer
	title = "Security Guard"
	alt_titles = list(
		"Master at Arms",
		"Enforcer",
		"Military Police"
	)
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/security/maa/marine,
		/datum/mil_branch/private_security
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5,
		/datum/mil_rank/private_security/pcrc = /decl/hierarchy/outfit/job/torch/crew/security/maa/pcrc,
		/datum/mil_rank/private_security/saare = /decl/hierarchy/outfit/job/torch/crew/security/maa/saare
	)
/***/

// Service
/datum/job/chaplain
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/chaplain/ec,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/service/chaplain/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/marine_corps/o1,
		/datum/mil_rank/marine_corps/o2
	)

/datum/job/janitor
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/janitor/ec,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/service/janitor/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine_corps/e1,
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5
	)

/datum/job/chef
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/service/cook/ec,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/service/cook/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5
	)

/datum/job/crew
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/service/crewman/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5
	)
/***/

// Supply
/datum/job/qm
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/w1,
		/datum/mil_rank/fleet/w2,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/marine_corps/w1,
		/datum/mil_rank/marine_corps/w2,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3
	)

/datum/job/cargo_tech
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian = /decl/hierarchy/outfit/job/torch/crew/supply/contractor,
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/supply/tech/marine
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5,
		/datum/mil_rank/civ/contractor
	)
/***/

// Corporate
/datum/job/bodyguard
	allowed_branches = list(/datum/mil_branch/private_security, /datum/mil_branch/civilian)
	allowed_ranks = list(
		/datum/mil_rank/private_security/pcrc = /decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard/pcrc,
		/datum/mil_rank/private_security/pcrc_agt = /decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard/pcrc/agent,
		/datum/mil_rank/private_security/saare = /decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard/saare,
		/datum/mil_rank/civ/contractor
	)

/datum/job/bodyguard/get_description_blurb()
	return "You are the Loss Prevention Associate. Your job is to prevent the loss of the Liason's life - even at the cost of your own. Good luck."
/***/

// Misc
/datum/job/assistant
	skill_points = 18

/datum/job/psiadvisor
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/foundationadvisor)
/*
/////////
// flag - boh
/////////
/datum/job/flag
	title = "Flag Officer"
	department = "Support"
	department_flag = SPT
	total_positions = 1
	spawn_positions = 1
	latejoin_at_spawnpoints = 1
	supervisors = "High Command"
	selection_color = "#807c7c"
	minimum_character_age = list(SPECIES_HUMAN = 52)
	ideal_character_age = 60
	skill_points = 24
	economic_power = 16
	outfit_type = /decl/hierarchy/outfit/job/torch/crew/command/CO
	allowed_branches = list(
		/datum/mil_branch/marine_corps = /decl/hierarchy/outfit/job/torch/crew/command/sea/marine,
		/datum/mil_branch/fleet = /decl/hierarchy/outfit/job/torch/crew/command/CO/fleet
	)
	allowed_ranks = list(
	/datum/mil_rank/marine_corps/o7,
	/datum/mil_rank/marine_corps/o8,
	/datum/mil_rank/marine_corps/o9,
	/datum/mil_rank/marine_corps/o10,
	/datum/mil_rank/fleet/o7,
	/datum/mil_rank/fleet/o8,
	/datum/mil_rank/fleet/o9,
	/datum/mil_rank/fleet/o10
	)

/datum/job/flag/get_access()
	return get_all_station_access()

/datum/job/flag/post_equip_rank(var/mob/person, var/alt_title)
	var/sound/announce_sound = (GAME_STATE <= RUNLEVEL_SETUP)? null : sound('sound/misc/boatswain.ogg', volume=20)
	captain_announcement.Announce("All hands, [alt_title || title] [person.real_name] on deck!", new_sound = announce_sound)
	..()

/datum/job/flag/is_position_available()
	return FALSE
*/
