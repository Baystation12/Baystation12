/datum/job/ship_crew_civ
	title = "Civilian Ship Crew"
	total_positions = 7
	spawn_positions = 7
	outfit_type = /decl/hierarchy/outfit/job/civ_crewmember
	selection_color = "#000000"
	spawnpoint_override = "Civilian Ship Crew"

/datum/job/ship_cap_civ
	title = "Civilian Ship Captain"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/civ_captain
	selection_color = "#000000"
	spawnpoint_override = "Civ Ship Cap Crew"

/datum/job/ship_cap_civ/equip(var/mob/m)
	. = ..()
	for(var/turf/T in range(2,m)) //Removing our spawn loc from the potential spawnpos's, so a ship doesn't get 2 captains.
		for(var/obj/effect/landmark/start/ship_cap_civ/spawnpos in T.contents)
			GLOB.ship_cap_civ_spawns -= spawnpos.loc

/datum/job/ship_crew_innie
	title = "Insurrectionist Ship Crew"
	total_positions = 6
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/innie_crewmember
	selection_color = "#ff0000"
	spawnpoint_override = "Innie Crew"

/datum/job/ship_cap_innie
	title = "Insurrectionist Ship Captain"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/innie_crew_captain
	selection_color = "#ff0000"
	spawnpoint_override = "Innie Crew"

/datum/job/ODST
	title = "Orbital Drop Shock Trooper"
	total_positions = 5
	spawn_positions = 5
	outfit_type = /decl/hierarchy/outfit/job/facil_ODST
	alt_titles = list("Private First Class"= /decl/hierarchy/outfit/job/ODSTCQC,
	"Lance Corporal"= /decl/hierarchy/outfit/job/ODSTengineer,
	"Corporal"= /decl/hierarchy/outfit/job/facil_ODST,
	"Petty Officer Third Class"= /decl/hierarchy/outfit/job/ODSTMedic,
	"Sergeant"= /decl/hierarchy/outfit/job/ODSTSharpshooter,
	"Staff Sergeant"= /decl/hierarchy/outfit/job/ODSTstaffsergeant,
	"Gunnery Sergeant"= /decl/hierarchy/outfit/job/ODSTgunnerysergeant,
	"Master Sergeant" = /decl/hierarchy/outfit/job/ODSTFireteamLead)

	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Rifleman Spawn"
	is_whitelisted = 1

/datum/job/ODSTO
	title = "Orbital Drop Shock Trooper Officer"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ODSTsecondlieutenant
	alt_titles = list("Second Lieutenant" = /decl/hierarchy/outfit/job/ODSTsecondlieutenant,
	"First Lieutenant" = /decl/hierarchy/outfit/job/ODSTfirstlieutenant,
	"Captain" = /decl/hierarchy/outfit/job/ODSTcaptain,
	"Major" = /decl/hierarchy/outfit/job/ODSTmajor,
	"Lieutenant Colonel" = /decl/hierarchy/outfit/job/ODSTltcolonel,
	"Colonel" = /decl/hierarchy/outfit/job/ODSTcolonel)
	selection_color = "#008000"
	access = list(142,144,110,300,306,309,310,311)
	spawnpoint_override = "ODST Squad Leader Spawn"
	is_whitelisted = 1

/datum/map/first_contact
	allowed_jobs = list(/datum/job/unscbertels_co,/datum/job/unscbertels_xo,/datum/job/unscbertels_ship_crew,/datum/job/unscbertels_medical_crew,/datum/job/bertelsunsc_ship_marine,/datum/job/unsc_ship_marineplatoon,/datum/job/bertelsODST,/datum/job/bertelsODSTO,/datum/job/researchdirector,/datum/job/researcher,/datum/job/ONIGUARD,/datum/job/ONIGUARDS,/datum/job/COMMO,/datum/job/IGUARD,/datum/job/ship_crew_civ,/datum/job/ship_cap_civ,/datum/job/Emsville_Colonist,/datum/job/Emsville_Marshall,/datum/job/Asteroidinnieleader,/datum/job/Asteroidinnie,/datum/job/ship_crew_innie,/datum/job/ship_cap_innie,/datum/job/covenant/kigyarpirate/captain,/datum/job/covenant/kigyarpirate,/datum/job/covenant/unggoy_deacon)
	allowed_spawns = list("UNSC Bertels Ship Crew Spawn","UNSC Bertels Medical Staff Spawn","UNSC Bertels CO Spawn","UNSC Bertels XO Spawn","UNSC Bertels Marine Spawn","UNSC Bertels Marine Platoon Leader Spawn","UNSC Bertels ODST Spawn","UNSC Bertels ODST Officer Spawn","Innie Crew","Civilian Ship Crew","Civ Ship Cap Crew","Emsville Spawn","Emsville Spawn Marshall","Kig-Yar Pirate Spawn","Unggoy Pirate Spawn","Research Facility Spawn","Research Facility Director Spawn","Research Facility Security Spawn","Research Facility Comms Spawn","Depot Guard Spawn","Listening Post Spawn","Listening Post Commander Spawn",)

	species_to_job_whitelist = list(/datum/species/kig_yar = list(/datum/job/covenant/kigyarpirate,/datum/job/covenant/kigyarpirate/captain),/datum/species/unggoy = list(/datum/job/covenant/unggoy_deacon))

	species_to_job_blacklist = list(/datum/species/human = list(/datum/job/covenant/kigyarpirate,/datum/job/covenant/kigyarpirate/captain,/datum/job/covenant/unggoy_deacon))

