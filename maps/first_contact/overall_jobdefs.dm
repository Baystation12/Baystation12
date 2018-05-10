/datum/job/ship_crew_civ
	title = "Civillian Ship Crew"
	total_positions = 6
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/civ_crewmember
	selection_color = "#667700"
	spawnpoint_override = "Civ Crew"

/datum/job/ship_cap_civ
	title = "Civillian Ship Captain"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/civ_captain
	selection_color = "#667700"
	spawnpoint_override = "Civ Ship Cap Crew"

/datum/job/ship_cap_civ/equip(var/mob/m)
	. = ..()
	for(var/turf/T in range(2,m)) //Removing our spawn loc from the potential spawnpos's, so a ship doesn't get 2 captains.
		for(var/obj/effect/landmark/start/ship_cap_civ/spawnpos in T.contents)
			GLOB.ship_cap_civ_spawns -= spawnpos.loc

/datum/job/ship_crew_innie
	title = "Innie Ship Crew"
	total_positions = 5
	spawn_positions = 5
	outfit_type = /decl/hierarchy/outfit/job/innie_crewmember
	selection_color = "#667700"
	spawnpoint_override = "Innie Crew"

/datum/job/ship_cap_innie
	title = "Innie Ship Captain"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/innie_crew_captain
	selection_color = "#667700"
	spawnpoint_override = "Innie Crew"

/datum/job/unsc_ship_crew
	title = "UNSC Corvette Ship Crew"
	total_positions = 7
	spawn_positions = 7
	outfit_type = /decl/hierarchy/outfit/job/unsc_corvette/crewmember
	selection_color = "#667700"
	spawnpoint_override = "Corvette Crew"

/datum/job/unsc_ship_cap
	title = "UNSC Corvette Ship Captain"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc_corvette/CO
	selection_color = "#667700"
	spawnpoint_override = "Corvette Crew"

/datum/map/first_contact
	allowed_jobs = list(/datum/job/ship_crew_civ,/datum/job/ship_cap_civ,/datum/job/ship_crew_innie,/datum/job/ship_cap_innie,/datum/job/unsc_ship_crew,/datum/job/unsc_ship_cap,/datum/job/covenant/kigyarpirate/captain,/datum/job/covenant/kigyarpirate,/datum/job/covenant/unggoy_deacon)
	allowed_spawns = list("Innie Crew","Corvette Crew","Civ Crew","Civ Ship Cap Crew","Kig-Yar Pirate Spawn")
