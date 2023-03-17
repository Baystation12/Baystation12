/datum/shuttle/autodock/overmap/fleet_deimos
	name = "SFV Deimos"
	warmup_time = 5
	current_location = "nav_fleet_deimos_offship"
	dock_target = "fleet_deimos_shuttle"
	range = 1
	fuel_consumption = 0
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/fleet
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE
	knockdown = FALSE

/datum/shuttle/autodock/overmap/fleet_deimos/New(_name, obj/effect/shuttle_landmark/initial_location)
	shuttle_area = subtypesof(/area/map_template/fleet_deimos)
	..()

/turf/simulated/floor/shuttle_ceiling/fleet
	color = COLOR_SOL

/obj/effect/shuttle_landmark/fleet_deimos/start
	landmark_tag = "nav_fleet_deimos_offship"
	name = "Start Point"

/obj/effect/shuttle_landmark/fleet_deimos/deckbridgebow
	landmark_tag = "nav_fleet_deimos_deckbridgebow"
	name = "Bridge Deck, bow"

/obj/effect/shuttle_landmark/fleet_deimos/deckbridgestern
	landmark_tag = "nav_fleet_deimos_deckbridgestern"
	name = "Bridge Deck, stern"

/obj/effect/shuttle_landmark/fleet_deimos/deck1bow
	landmark_tag = "nav_fleet_deimos_deck1bow"
	name = "Deck 1, bow"

/obj/effect/shuttle_landmark/fleet_deimos/deck1stern
	landmark_tag = "nav_fleet_deimos_deck1stern"
	name = "Deck 1, stern"

/obj/effect/shuttle_landmark/fleet_deimos/deck2bow
	landmark_tag = "nav_fleet_deimos_deck2bow"
	name = "Deck 2, bow"

/obj/effect/shuttle_landmark/fleet_deimos/deck2stern
	landmark_tag = "nav_fleet_deimos_deck2stern"
	name = "Deck 2, stern"

/obj/effect/shuttle_landmark/fleet_deimos/deck3bow
	landmark_tag = "nav_fleet_deimos_deck3bow"
	name = "Deck 3, bow"

/obj/effect/shuttle_landmark/fleet_deimos/deck3stern
	landmark_tag = "nav_fleet_deimos_deck3stern"
	name = "Deck 3, stern"

/obj/effect/shuttle_landmark/fleet_deimos/deck4bow
	landmark_tag = "nav_fleet_deimos_deck4bow"
	name = "Deck 4, bow"

/obj/effect/shuttle_landmark/fleet_deimos/deck4stern
	landmark_tag = "nav_fleet_deimos_deck4stern"
	name = "Deck 4, stern"

/obj/effect/shuttle_landmark/fleet_deimos/deck5bow
	landmark_tag = "nav_fleet_deimos_deck5bow"
	name = "Deck 5, bow"

/obj/effect/shuttle_landmark/fleet_deimos/deck5stern
	landmark_tag = "nav_fleet_deimos_deck5stern"
	name = "Deck 5, stern"

/obj/effect/shuttle_landmark/transit/fleet_deimos
	name = "In transit"
	landmark_tag = "nav_transit_fleet_deimos"

// AREAS

/area/map_template/fleet_deimos/hospital
	name = "\improper SFV Deimos - Hospital wing"

/area/map_template/fleet_deimos/bridge
	name = "\improper SFV Deimos - Bridge deck"

/area/map_template/fleet_deimos/central
	name = "\improper SFV Deimos - Central spine"

/area/map_template/fleet_deimos/comms
	name = "\improper SFV Deimos - Communication relay"

/area/map_template/fleet_deimos/crew
	name = "\improper SFV Deimos - Crew compartment"

/area/map_template/fleet_deimos/reactor
	name = "\improper SFV Deimos - Reactor node"

/area/map_template/fleet_deimos/leftstorage
	name = "\improper SFV Deimos - Left storage wing"

/area/map_template/fleet_deimos/rightstorage
	name = "\improper SFV Deimos - Right storage wing"

/area/map_template/fleet_deimos/leftgun
	name = "\improper SFV Deimos - Left gunnery attachment"

/area/map_template/fleet_deimos/rightgun
	name = "\improper SFV Deimos - Right gunnery attachment"

/area/map_template/fleet_deimos/leftengi
	name = "\improper SFV Deimos - Left engineering wing"

/area/map_template/fleet_deimos/rightengi
	name = "\improper SFV Deimos - Right engineering wing"

/area/map_template/fleet_deimos/leftthrust
	name = "\improper SFV Deimos - Left thruster"

/area/map_template/fleet_deimos/rightthrust
	name = "\improper SFV Deimos - Right Thruster"


var/global/const/access_deimos = "ACCESS_DEIMOS"
/datum/access/deimos
	id = access_deimos
	desc = "SFV Deimos Crew"
	region = ACCESS_REGION_NONE


/obj/machinery/computer/shuttle_control/explore/fleet_deimos_shuttle
	name = "SFV Deimos Control Console"
	req_access = list(access_deimos)
	shuttle_tag = "SFV Deimos"
