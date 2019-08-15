
/datum/job/geminus_innie
	title = "Insurrectionist"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	total_positions = -1
	spawn_positions = -1
	access = list(access_innie)
	outfit_type = /decl/hierarchy/outfit/job/colonist/geminus_innie
	selection_color = "#ff0000"
	spawnpoint_override = "Geminus Innie"
	alt_titles = list(\
	"Insurrectionist Ship Crew",
	"Insurrectionist Technician",
	"Insurrectionist Machine Gunner",
	"Insurrectionist Field Medic",
	"Insurrectionist Bartender",
	"Insurrectionist Janitor",
	"Insurrectionist Breacher",
	"Insurrectionist Engineer",
	"Insurrectionist Guard",
	"Insurrectionist Negotiator",
	"Insurrectionist Interrogator",
	"Insurrectionist Tracker",
	"Insurrectionist Trainer",
	"Insurrectionist Bombmaker",
	"Insurrectionist Mechanic",
	"Insurrectionist Pilot",
	"Insurrectionist Marksman",
	"Insurrectionist Trooper",
	"Insurrectionist Smuggler",\
	"Insurrectionist Broker",\
	"Insurrectionist Recruiter",\
	"Insurrectionist Saboteur",\
	"Insurrectionist Infiltrator")
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

/datum/job/geminus_innie/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	. = ..()

	var/datum/antagonist/geminus_insurrectionist/antag = all_antag_types()["Geminus Insurrectionist"]
	///datum/antagonist/proc/add_antagonist_mind(var/datum/mind/player, var/ignore_role, var/nonstandard_role_type, var/nonstandard_role_msg)
	antag.add_antagonist_mind(H.mind, 1, 1)
	//antag.add_antagonist(H.mind, 1, 1, 0, 1, 1)

/datum/job/geminus_innie/officer
	title = "Insurrectionist Officer"
	spawn_faction = "Insurrection"
	open_slot_on_death = 1
	track_players = 1
	latejoin_at_spawnpoints = 1
	total_positions = 2
	spawn_positions = 2
	access = list(access_innie, access_innie_boss)
	selection_color = "#ff0000"
	spawnpoint_override = "Geminus Innie"
	alt_titles = null

/datum/job/geminus_innie/commander
	title = "Insurrectionist Commander"
	department_flag = COM
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	track_players = 1
	total_positions = 1
	spawn_positions = 1
	access = list(access_innie, access_innie_boss)
	selection_color = "#ff0000"
	spawnpoint_override = "Geminus Innie"
	faction_whitelist = "Insurrection"
	alt_titles = null
