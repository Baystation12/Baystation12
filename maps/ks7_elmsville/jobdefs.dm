#include "outfits.dm"
#include "spawns_jobs.dm"

/datum/map/ks7_elmsville
	allowed_jobs = list(\
	/datum/job/colonist,
	/datum/job/colonist/mayor,
	/datum/job/colonist/aerodrome,
	/datum/job/colonist/biodome_worker,
	/datum/job/colonist/casino_owner,
	/datum/job/colonist/hospital_worker,
	/datum/job/colonist/pharmacist,
	/datum/job/colonist/colonist_marshall,
	/datum/job/colonist/bartender,
	/datum/job/colonist/chef,
	/datum/job/colonist/librarian_museum,
	/datum/job/unsc/spartan_two,
	/datum/job/unsc/marine,
	/datum/job/unsc/marine/specialist,
	/datum/job/unsc/marine/squad_leader,
	/datum/job/unsc/odst,
	/datum/job/unsc/odst/squad_leader,
	/datum/job/unsc/commanding_officer,
	/datum/job/unsc/executive_officer,
	/datum/job/unsc/oni/research,
	/datum/job/unsc/oni/research/director,
	/datum/job/unsc_ai,
	/datum/job/covenant/sangheili_minor,
	/datum/job/covenant/sangheili_major,
	/datum/job/covenant/sangheili_ultra,
	/datum/job/covenant/sangheili_shipmaster,
	/datum/job/covenant/kigyarminor,
	/datum/job/covenant/unggoy_minor,
	/datum/job/covenant/unggoy_major,
	/datum/job/covenant/unggoy_ultra,
	/datum/job/covenant/unggoy_deacon,
	/datum/job/covenant/unggoy_heavy,
	/datum/job/covenant/skirmmurmillo,
	/datum/job/covenant/skirmcommando,
	/datum/job/covenant/brute_minor,
	/datum/job/covenant/brute_major,
	/datum/job/covenant/brute_captain,
	/datum/job/covenant/yanmee_minor,
	/datum/job/covenant/yanmee_major,
	/datum/job/covenant/yanmee_ultra,
	/datum/job/covenant/yanmee_leader,
	)

	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID,
		"UNSC Base Spawns",
		"UNSC Base Fallback Spawns"
		)

	default_spawn = DEFAULT_SPAWNPOINT_ID
/*
	species_to_job_whitelist = list(\
		/datum/species/kig_yar = list(/datum/job/covenant/kigyarminor,/datum/job/covenant/kigyarmajor,/datum/job/covenant/kigyarcorvette/captain),\
		/datum/species/unggoy = list(/datum/job/covenant/unggoy_minor,/datum/job/covenant/unggoy_major),\
		/datum/species/sangheili = list(/datum/job/covenant/sangheili_minor,/datum/job/covenant/sangheili_major,/datum/job/covenant/sangheili_honour_guard,/datum/job/covenant/sangheili_shipmaster),\
		/datum/species/kig_yar_skirmisher = list(/datum/job/covenant/skirmminor,/datum/job/covenant/skirmmajor,/datum/job/covenant/skirmmurmillo,/datum/job/covenant/skirmcommando),\
		/datum/species/spartan = list(),\
		/datum/species/brutes = list(),\
		/datum/species/sanshyuum = list(/datum/job/covenant/lesser_prophet),\
		)
*/


/datum/job/colonist
	title = "KS7 Colonist"
	total_positions = -1
	//spawnpoint_override = "Colony Arrival Shuttle"
	selection_color = "#000000"
	spawn_faction = "Human Colony"
	supervisors = " the Colony Mayor"
	account_allowed = 1
	generate_email = 1
	loadout_allowed = TRUE
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist
	whitelisted_species = list(/datum/species/human)
	latejoin_at_spawnpoints = FALSE
	intro_blurb = "You are a colonist of the now-independent colony of KS7, New Pompeii. Go about your day, performing your daily tasks."

/datum/job/colonist/mayor
	title = "KS7 Mayor"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_mayor

/datum/job/colonist/aerodrome
	title = "KS7 Aerodrome Technician"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/aerodrome

/datum/job/colonist/biodome_worker
	title = "KS7 Biodome Worker"
	total_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/biodome_worker

/datum/job/colonist/casino_owner
	title = "KS7 Casino Owner"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/casino_owner

/datum/job/colonist/hospital_worker
	title = "KS7 Hospital Worker"
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/hospital_worker

/datum/job/colonist/pharmacist
	title = "KS7 Pharmacist"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/pharmacist

/datum/job/colonist/colonist_marshall
	title = "KS7 Colonist Marshall"
	total_positions = 5
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/colonist_marshall

/datum/job/colonist/bartender
	title = "KS7 Bartender"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/bartender

/datum/job/colonist/chef
	title = "KS7 Chef"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/chef

/datum/job/colonist/librarian_museum
	title = "KS7 Librarian / Museum Worker"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/librarian_museum

