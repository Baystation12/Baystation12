//Helpers for the pods
//If you want to make a new one
//Just copy paste the pod 1 code and change 1 for 2 and so on

/datum/shuttle/autodock/ferry/escape_pod
	category = /datum/shuttle/autodock/ferry/escape_pod
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	var/number

/datum/shuttle/autodock/ferry/escape_pod/New()
	name = "Escape Pod [number]"
	dock_target = "escape_pod_[number]"
	arming_controller = "escape_pod_[number]_berth"
	waypoint_station = "escape_pod_[number]_start"
	landmark_transition = "escape_pod_[number]_internim"
	waypoint_offsite = "escape_pod_[number]_out"
	..()

/obj/effect/shuttle_landmark/escape_pod/
	var/number

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"

/obj/effect/shuttle_landmark/escape_pod/start/New()
	landmark_tag = "escape_pod_[number]_start"
	docking_controller = "escape_pod_[number]_berth"
	..()

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/effect/shuttle_landmark/escape_pod/transit/New()
	landmark_tag = "escape_pod_[number]_internim"
	..()

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"

/obj/effect/shuttle_landmark/escape_pod/out/New()
	landmark_tag = "escape_pod_[number]_out"
	..()

//Actually pods

/datum/shuttle/autodock/ferry/escape_pod/escape_pod1
	shuttle_area = /area/shuttle/escape_pod1/station
	number = 1
/obj/effect/shuttle_landmark/escape_pod/start/pod1
	number = 1
/obj/effect/shuttle_landmark/escape_pod/out/pod1
	number = 1
/obj/effect/shuttle_landmark/escape_pod/transit/pod1
	number = 1

/datum/shuttle/autodock/ferry/escape_pod/escape_pod2
	shuttle_area = /area/shuttle/escape_pod2/station
	number = 2
/obj/effect/shuttle_landmark/escape_pod/start/pod2
	number = 2
/obj/effect/shuttle_landmark/escape_pod/out/pod2
	number = 2
/obj/effect/shuttle_landmark/escape_pod/transit/pod2
	number = 2

/datum/shuttle/autodock/ferry/escape_pod/escape_pod3
	shuttle_area = /area/shuttle/escape_pod3/station
	number = 3
/obj/effect/shuttle_landmark/escape_pod/start/pod3
	number = 3
/obj/effect/shuttle_landmark/escape_pod/out/pod3
	number = 3
/obj/effect/shuttle_landmark/escape_pod/transit/pod3
	number = 3

/datum/shuttle/autodock/ferry/escape_pod/escape_pod5
	shuttle_area = /area/shuttle/escape_pod5/station
	number = 5
/obj/effect/shuttle_landmark/escape_pod/start/pod5
	number = 5
/obj/effect/shuttle_landmark/escape_pod/out/pod5
	number = 5
/obj/effect/shuttle_landmark/escape_pod/transit/pod5
	number = 5

// ERT - Shuttle


/datum/shuttle/autodock/multi/antag/rescue
	name = "Rescue"
	warmup_time = 0
	destination_tags = list(
		"nav_lavalette_coupole",
		"nav_lavalette_xenoarch",
		"nav_lavalette_residen",
		"nav_lavalette_start",
		)
	current_location = "nav_specops_start"
	landmark_transition = "nav_specops_transition"
	home_waypoint = "nav_specops_start"
	shuttle_area = /area/shuttle/specops/centcom
	announcer = "CMA"
	arrival_message = "You guys fucked it all up. CMA units are on the way to fix you're mistake."
	departure_message = "The units."

/obj/effect/shuttle_landmark/specops/start
	name = "Patrol Area"
	landmark_tag = "nav_specops_start"

/obj/effect/shuttle_landmark/specops/internim
	name = "In transit"
	landmark_tag = "nav_specops_transition"

/obj/effect/shuttle_landmark/specops/xenoarch
	name = "To the Xenoarcheology Airlock"
	landmark_tag = "nav_specops_xenoarch"

/obj/effect/shuttle_landmark/specops/coupole
	name =  "Near the Dome"
	landmark_tag = "nav_specops_coupole"

/obj/effect/shuttle_landmark/specops/residentiel
	name = "Near the Residential Access"
	landmark_tag = "nav_specops_residen"

//Cargo shuttle

/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	dock_target = "supply_shuttle"
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"

/obj/effect/shuttle_landmark/supply/centcom
	name = "Centcom"
	landmark_tag = "nav_cargo_start"
	autoset = 0

/obj/effect/shuttle_landmark/supply/station
	name = "Dock Station"
	landmark_tag = "nav_cargo_station"
	docking_controller = "cargo_bay"
	autoset = 1

//Research Shuttle

/datum/shuttle/autodock/ferry/research
	name = "Research"
	warmup_time = 10
	location = 1
	shuttle_area = /area/shuttle/research/station
	dock_target = "research_shuttle"
	waypoint_offsite = "nav_research_start"
	waypoint_station = "nav_research_station"


/obj/effect/shuttle_landmark/research/station
	name = "Station"
	landmark_tag = "nav_research_start"
	docking_controller = "research_station"
	autoset = 0

/obj/effect/shuttle_landmark/research/asteroid
	name = "Asteroid"
	landmark_tag = "nav_research_station"
	docking_controller = "research_outpost_dock"
	autoset = 1

//Engineer Shuttle

/datum/shuttle/autodock/ferry/engie
	name = "Engineering"
	warmup_time = 10
	location = 0
	shuttle_area = /area/shuttle/constructionsite
	dock_target = "engineering_shuttle"
	waypoint_station = "nav_engie_station"
	waypoint_offsite = "nav_engie_outpost"

/obj/effect/shuttle_landmark/engie/station
	name = "Station"
	landmark_tag = "nav_engie_station"
	docking_controller = "edock_airlock"
	autoset = 0

/obj/effect/shuttle_landmark/engie/asteroid
	name = "Asteroid Outpost"
	landmark_tag = "nav_engie_outpost"
	docking_controller = "engineering_dock_airlock"
	autoset = 1


//Mining shuttle
/datum/shuttle/autodock/ferry/mining
	name = "Mining"
	warmup_time = 10
	location = 0
	shuttle_area = /area/shuttle/mining
	dock_target = "mining_shuttle"
	waypoint_station = "nav_mining_station"
	waypoint_offsite = "nav_mining_outpost"

/obj/effect/shuttle_landmark/mining/station
	name = "Station"
	landmark_tag = "nav_mining_station"
	docking_controller = "mining_dock_airlock"
	autoset = 0

/obj/effect/shuttle_landmark/mining/asteroid
	name = "Asteroid Outpost"
	landmark_tag = "nav_mining_outpost"
	docking_controller = "mining_outpost_airlock"
	autoset = 1


//Emergency shuttle

/datum/shuttle/autodock/ferry/emergency/centcom
	name = "Escape"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/escape/centcom
	dock_target = "escape_shuttle"
	landmark_transition = "nav_escape_transition"
	waypoint_offsite = "nav_centcom_dock"
	waypoint_station = "nav_escape_dock"

/obj/effect/shuttle_landmark/escape/centcom
	name = "Centcom"
	landmark_tag = "nav_centcom_dock"
	docking_controller = "centcom_dock"
	autoset = 0

/obj/effect/shuttle_landmark/escape/internim
	name = "In transit"
	landmark_tag = "nav_escape_transition"
	autoset = 0

/obj/effect/shuttle_landmark/escape/station
	name = "Station"
	landmark_tag = "nav_escape_dock"
	docking_controller = "escape_dock"
	autoset = 1

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 0
	destination_tags = list(
		"nav_merc_start",
		"nav_merc_dock",
		"nav_merc_coupole",
		"nav_merc_minage",
		"nav_merc_residentiel",
		)
	shuttle_area = /area/syndicate_station/start
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_transition"
	announcer = "Chasseur Huon"
	home_waypoint = "nav_merc_start"
	arrival_message = "Attention, you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	departure_message = "Your visitors are on their way out of the system, burning delta-v like it's nothing. Good riddance."

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"

/obj/effect/shuttle_landmark/merc/internim
	name = "In transit"
	landmark_tag = "nav_merc_transition"
	autoset = 1

/obj/effect/shuttle_landmark/merc/dock
	name = "Northwest"
	landmark_tag = "nav_merc_dock"
	autoset = 1

/obj/effect/shuttle_landmark/merc/coupole
	name = "South"
	landmark_tag = "nav_merc_coupole"
	autoset = 1

/obj/effect/shuttle_landmark/merc/minage
	name = "Southwest"
	landmark_tag = "nav_merc_minage"
	autoset = 1

/obj/effect/shuttle_landmark/merc/residentiel
	name = "North"
	landmark_tag = "nav_merc_residentiel"
	autoset = 1


//Skipjack
/*
/datum/shuttle/autodock/multi/antag/skipjack
    name = "Skipjack"
    warmup_time = 0
    destination_tags = list(
        "nav_skipjack_ai",
        "nav_skipjack_civ",
        "nav_skipjack_ind",
        "nav_skipjack_start"
        )
    shuttle_area =  /area/skipjack_station/start
    dock_target = "skipjack_shuttle"
    current_location = "nav_skipjack_start"
    landmark_transition = "nav_skipjack_transition"
    announcer = "ESIN Dreyfus Sensor Array"
    home_waypoint = "nav_skipjack_start"
    arrival_message = "Attention, vessel detected entering station proximity."
    departure_message = "Attention, vessel detected leaving station proximity."

/obj/effect/shuttle_landmark/skipjack/start
    name = "Raider Outpost"
    landmark_tag = "nav_skipjack_start"
    docking_controller = "skipjack_base"

/obj/effect/shuttle_landmark/skipjack/internim
    name = "In transit"
    landmark_tag = "nav_skipjack_transition"

/obj/effect/shuttle_landmark/skipjack/ai
    name = "Silicon Deck"
    landmark_tag = "nav_skipjack_ai"

/obj/effect/shuttle_landmark/skipjack/civ
    name = "West of Civilian Deck"
    landmark_tag = "nav_skipjack_civ"

/obj/effect/shuttle_landmark/skipjack/ind
    name = "Mining Airlock"
    landmark_tag = "nav_skipjack_ind"
*/