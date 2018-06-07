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

/obj/effect/shuttle_landmark/escape_pod
	var/number

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"
	autoset = 0
	base_turf = /turf/space
/obj/effect/shuttle_landmark/escape_pod/start/New()
	landmark_tag = "escape_pod_[number]_start"
	docking_controller = "escape_pod_[number]_berth"
	..()

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"
	autoset = 1

/obj/effect/shuttle_landmark/escape_pod/transit/New()
	landmark_tag = "escape_pod_[number]_internim"
	..()

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"
	autoset = 1

/obj/effect/shuttle_landmark/escape_pod/out/New()
	landmark_tag = "escape_pod_[number]_out"
	docking_controller = "escape_pod_[number]_recovery"
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

//Transport shuttle

/datum/shuttle/autodock/ferry/transport
	name = "Transport"
	warmup_time = 0
	dock_target = "centcom_transport_shuttle"
	shuttle_area = /area/shuttle/transport1/centcom
	waypoint_offsite = "nav_transport_start"
	waypoint_station = "nav_transport_station"
	location = 1


/obj/effect/shuttle_landmark/transport/start
	name = "Centcomm"
	landmark_tag = "nav_transport_start"
	docking_controller = "transport_centcom_dock"
	autoset = 0


/obj/effect/shuttle_landmark/transport/station
	name = "To station"
	landmark_tag = "nav_transport_station"
	docking_controller = "transport_shuttle_dock_airlock"
	autoset = 1

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


//Emergency Response Team Shuttle

/datum/shuttle/autodock/multi/antag/rescue
	name = "Rescue"
	warmup_time = 10
	destination_tags = list(
		"nav_rescue_start",
		"nav_rescue_station",
		"nav_rescue_dock",
		"nav_rescue_coupole",
		"nav_rescue_minage",
		"nav_rescue_residentiel",
		"nav_rescue_southeast",
		"nav_rescue_northeast",
		)
	shuttle_area = /area/rescue_base/start
	dock_target = "rescue_shuttle"
	current_location = "nav_rescue_start"
	landmark_transition = "nav_rescue_transition"
	home_waypoint = "nav_rescue_start"

/obj/effect/shuttle_landmark/rescue/start
	name = "Rescue Base"
	landmark_tag = "nav_rescue_start"
	docking_controller = "rescue_base"

/obj/effect/shuttle_landmark/rescue/internim
	name = "In transit"
	landmark_tag = "nav_rescue_transition"
	autoset = 1

/obj/effect/shuttle_landmark/rescue/station
	name = "Station Dock"
	landmark_tag = "nav_rescue_station"
	autoset = 1
	docking_controller = "rescue_shuttle_dock_airlock"

/obj/effect/shuttle_landmark/rescue/dock
	name = "North West"
	landmark_tag = "nav_rescue_dock"
	autoset = 1

/obj/effect/shuttle_landmark/rescue/northeast
	name = "North East"
	landmark_tag = "nav_rescue_northeast"
	autoset = 1

/obj/effect/shuttle_landmark/rescue/coupole
	name = "South"
	landmark_tag = "nav_rescue_coupole"
	autoset = 1

/obj/effect/shuttle_landmark/rescue/minage
	name = "South West"
	landmark_tag = "nav_rescue_minage"
	autoset = 1

/obj/effect/shuttle_landmark/rescue/residentiel
	name = "North"
	landmark_tag = "nav_rescue_residentiel"
	autoset = 1

/obj/effect/shuttle_landmark/rescue/southeast
	name = "South East"
	landmark_tag = "nav_rescue_southeast"
	autoset = 1

// emergency

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
	autoset = 1

/obj/effect/shuttle_landmark/escape/station
	name = "Station"
	landmark_tag = "nav_escape_dock"
	docking_controller = "escape_dock"
	autoset = 1

// Administration

/datum/shuttle/autodock/ferry/administration
	name = "Administration"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/administration/centcom
	dock_target = "admin_shuttle"
	landmark_transition = "nav_admin_transition"
	waypoint_offsite = "nav_admin_centcom_dock"
	waypoint_station = "nav_admin_station_dock"

/obj/effect/shuttle_landmark/administration/centcom
	name = "Centcom"
	landmark_tag = "nav_admin_centcom_dock"
	docking_controller = "admin_shuttle_centcom_dock"
	autoset = 0

/obj/effect/shuttle_landmark/administration/internim
	name = "In transit"
	landmark_tag = "nav_admin_transition"
	autoset = 1

/obj/effect/shuttle_landmark/administration/station
	name = "Station"
	landmark_tag = "nav_admin_station_dock"
	docking_controller = "admin_shuttle_dock_airlock"
	autoset = 1

// Merc

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 10
	destination_tags = list(
		"nav_merc_start",
		"nav_merc_dock",
		"nav_merc_coupole",
		"nav_merc_minage",
		"nav_merc_residentiel",
		"nav_merc_south",
		"nav_merc_north",
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
	name = "North West"
	landmark_tag = "nav_merc_dock"
	autoset = 1

/obj/effect/shuttle_landmark/merc/coupole
	name = "South West"
	landmark_tag = "nav_merc_coupole"
	autoset = 1

/obj/effect/shuttle_landmark/merc/minage
	name = "South East"
	landmark_tag = "nav_merc_minage"
	autoset = 1

/obj/effect/shuttle_landmark/merc/residentiel
	name = "North East"
	landmark_tag = "nav_merc_residentiel"
	autoset = 1

/obj/effect/shuttle_landmark/merc/north
	name = "North"
	landmark_tag = "nav_merc_north"
	autoset = 1

/obj/effect/shuttle_landmark/merc/south
	name = "South"
	landmark_tag = "nav_merc_south"
	autoset = 1

// Elite Merc

/datum/shuttle/autodock/multi/antag/elite_mercenary
	name = "Elite Mercenary"
	warmup_time = 10
	destination_tags = list(
		"nav_emerc_start",
		"nav_emerc_nw",
		"nav_emerc_sw",
		"nav_emerc_se",
		"nav_emerc_ne",
		)
	shuttle_area = /area/shuttle/syndicate_elite/mothership
	dock_target = "emerc_shuttle"
	current_location = "nav_emerc_start"
	landmark_transition = "nav_emerc_transition"
	home_waypoint = "nav_emerc_start"

/obj/effect/shuttle_landmark/elite_mercenary/start
	name = "Elite Mercenary Base"
	landmark_tag = "nav_emerc_start"
	docking_controller = "emerc_base"

/obj/effect/shuttle_landmark/elite_mercenary/internim
	name = "In transit"
	landmark_tag = "nav_emerc_transition"
	autoset = 1

/obj/effect/shuttle_landmark/elite_mercenary/northwest
	name = "North West"
	landmark_tag = "nav_emerc_nw"
	autoset = 1

/obj/effect/shuttle_landmark/elite_mercenary/southwest
	name = "South West"
	landmark_tag = "nav_emerc_sw"
	autoset = 1

/obj/effect/shuttle_landmark/elite_mercenary/southeast
	name = "South East"
	landmark_tag = "nav_emerc_se"
	autoset = 1

/obj/effect/shuttle_landmark/elite_mercenary/northeast
	name = "North East"
	landmark_tag = "nav_emerc_ne"
	autoset = 1

// deathsquad

/datum/shuttle/autodock/ferry/deathsquad
	name = "Deathsquad"
	warmup_time = 10
	location = 0
	shuttle_area = /area/shuttle/specops/centcom
	dock_target = "deathsquad_shuttle_port"
	waypoint_station = "nav_deathsquad_centcom"
	waypoint_offsite = "nav_deathsquad_station"

/obj/effect/shuttle_landmark/deathsquad/centcom
	name = "Centcom"
	landmark_tag = "nav_deathsquad_centcom"
	docking_controller = "deathsquad_centcom_dock"
	autoset = 0

/obj/effect/shuttle_landmark/deathsquad/station
	name = "Station"
	landmark_tag = "nav_deathsquad_station"
	docking_controller = "deathsquad_shuttle_dock_airlock"
	autoset = 1

//Merchant

/datum/shuttle/autodock/ferry/merchant
	name = "Merchant"
	warmup_time = 10
	location = 0
	shuttle_area = /area/shuttle/merchant/home
	waypoint_station = "nav_merchant_start"
	waypoint_offsite = "nav_merchant_out"
	dock_target = "merchant_ship_dock"

/obj/effect/shuttle_landmark/merchant/start
	name = "Merchant Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station_dock"
	autoset = 0

/obj/effect/shuttle_landmark/merchant/out
	name = "Docking Bay"
	landmark_tag = "nav_merchant_out"
	docking_controller = "merchant_shuttle_station_dock"
	autoset = 1


//Skipjack

/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	warmup_time = 10
	destination_tags = list(
		"nav_skipjack_start",
		"nav_skipjack_nw",
		"nav_skipjack_sw",
		"nav_skipjack_se",
		"nav_skipjack_ne",
		)
	shuttle_area = /area/skipjack_station/start
	dock_target = "skipjack_shuttle"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_transition"
	home_waypoint = "nav_skipjack_start"

/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Base"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "skipjack_base"

/obj/effect/shuttle_landmark/skipjack/internim
    name = "In transit"
    landmark_tag = "nav_skipjack_transition"
    autoset = 1

/obj/effect/shuttle_landmark/skipjack/northwest
	name = "North West"
	landmark_tag = "nav_skipjack_nw"
	autoset = 1

/obj/effect/shuttle_landmark/skipjack/southwest
	name = "South West"
	landmark_tag = "nav_skipjack_sw"
	autoset = 1

/obj/effect/shuttle_landmark/skipjack/southeast
	name = "South East"
	landmark_tag = "nav_skipjack_se"
	autoset = 1

/obj/effect/shuttle_landmark/skipjack/northeast
	name = "North East"
	landmark_tag = "nav_skipjack_ne"
	autoset = 1