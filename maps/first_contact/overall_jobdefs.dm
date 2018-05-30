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
	title = "Innie Ship Crew"
	total_positions = 6
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/innie_crewmember
	selection_color = "#ff0000"
	spawnpoint_override = "Innie Crew"

/datum/job/ship_cap_innie
	title = "Innie Ship Captain"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/innie_crew_captain
	selection_color = "#ff0000"
	spawnpoint_override = "Innie Crew"

/datum/job/unsc_ship_crew
	title = "UNSC Corvette Ship Crew"
	total_positions = 8
	spawn_positions = 8
	outfit_type = /decl/hierarchy/outfit/job/unsc_corvette/crewmember
	selection_color = "#008000"
	access = list(142)
	spawnpoint_override = "Corvette Crew"

/datum/job/unsc_ship_cap
	title = "UNSC Corvette Ship Captain"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc_corvette/CO
	selection_color = "#008000"
	access = list(142,143)
	spawnpoint_override = "Corvette Crew Captain"

/datum/job/ODST
	title = "ODST Rifleman"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/facil_ODST
	alt_titles = list("ODST Medic","ODST CQC Specialist","ODST Sharpshooter","ODST Combat Engineer")
	selection_color = "#008000"
	access = list(142,110,309,311)
	spawnpoint_override = "Research Facility Security Spawn"
	is_whitelisted = 1

/datum/job/ODSTO
	title = "ODST Officer"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/facil_ODSTO
	selection_color = "#008000"
	access = list(142,110,309,310,311)
	spawnpoint_override = "Research Facility Security Spawn"
	is_whitelisted = 1

/datum/map/first_contact
	allowed_jobs = list(/datum/job/researcher,/datum/job/ONIGUARD,/datum/job/ONIGUARDS,/datum/job/COMMO,/datum/job/IGUARD,/datum/job/LISTENG,/datum/job/colonist,/datum/job/ship_crew_civ,/datum/job/ship_cap_civ,/datum/job/ship_crew_innie,/datum/job/ship_cap_innie,/datum/job/unsc_ship_crew,/datum/job/unsc_ship_cap,/datum/job/ODST,/datum/job/ODSTO,/datum/job/covenant/kigyarpirate/captain,/datum/job/covenant/kigyarpirate,/datum/job/covenant/unggoy_deacon)
	allowed_spawns = list("Innie Crew","Corvette Crew","Corvette Crew Captain","Civilian Ship Crew","Civ Ship Cap Crew","Kig-Yar Pirate Spawn","Unggoy Pirate Spawn","Research Facility Spawn","Research Facility Security Spawn","Research Facility Comms Spawn","Depot Guard Spawn","Listening Post Spawn","Mining Asteroid Spawn","ODST Rifleman Spawn","ODST Squad Leader Spawn")

	species_to_job_whitelist = list(/datum/species/kig_yar = list(/datum/job/covenant/kigyarpirate,/datum/job/covenant/kigyarpirate/captain),/datum/species/unggoy = list(/datum/job/covenant/unggoy_deacon))

	species_to_job_blacklist = list(/datum/species/human = list(/datum/job/covenant/kigyarpirate,/datum/job/covenant/kigyarpirate/captain,/datum/job/covenant/unggoy_deacon))

