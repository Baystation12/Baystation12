//Some helpers because so much copypasta for pods
/datum/shuttle/autodock/ferry/escape_pod/torchpod
	category = /datum/shuttle/autodock/ferry/escape_pod/torchpod
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	var/number

/datum/shuttle/autodock/ferry/escape_pod/torchpod/New()
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

//Pods

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod6
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod6/station
	number = 6
/obj/effect/shuttle_landmark/escape_pod/start/pod6
	number = 6
/obj/effect/shuttle_landmark/escape_pod/out/pod6
	number = 6
/obj/effect/shuttle_landmark/escape_pod/transit/pod6
	number = 6

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod7
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod7/station
	number = 7
/obj/effect/shuttle_landmark/escape_pod/start/pod7
	number = 7
/obj/effect/shuttle_landmark/escape_pod/out/pod7
	number = 7
/obj/effect/shuttle_landmark/escape_pod/transit/pod7
	number = 7

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod8
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod8/station
	number = 8
/obj/effect/shuttle_landmark/escape_pod/start/pod8
	number = 8
/obj/effect/shuttle_landmark/escape_pod/out/pod8
	number = 8
/obj/effect/shuttle_landmark/escape_pod/transit/pod8
	number = 8

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod9
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod9/station
	number = 9
/obj/effect/shuttle_landmark/escape_pod/start/pod9
	number = 9
/obj/effect/shuttle_landmark/escape_pod/out/pod9
	number = 9
/obj/effect/shuttle_landmark/escape_pod/transit/pod9
	number = 9

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod10
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod10/station
	number = 10
/obj/effect/shuttle_landmark/escape_pod/start/pod10
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 10
/obj/effect/shuttle_landmark/escape_pod/out/pod10
	number = 10
/obj/effect/shuttle_landmark/escape_pod/transit/pod10
	number = 10

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod11
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod11/station
	number = 11
/obj/effect/shuttle_landmark/escape_pod/start/pod11
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 11
/obj/effect/shuttle_landmark/escape_pod/out/pod11
	number = 11
/obj/effect/shuttle_landmark/escape_pod/transit/pod11
	number = 11

//Smoll pods

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod12
	shuttle_area = /area/shuttle/escape_pod12/station
	number = 12
/obj/effect/shuttle_landmark/escape_pod/start/pod12
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 12
/obj/effect/shuttle_landmark/escape_pod/out/pod12
	number = 12
/obj/effect/shuttle_landmark/escape_pod/transit/pod12
	number = 12

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod13
	shuttle_area = /area/shuttle/escape_pod13/station
	number = 13
/obj/effect/shuttle_landmark/escape_pod/start/pod13
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 13
/obj/effect/shuttle_landmark/escape_pod/out/pod13
	number = 13
/obj/effect/shuttle_landmark/escape_pod/transit/pod13
	number = 13

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod14
	shuttle_area = /area/shuttle/escape_pod14/station
	number = 14
/obj/effect/shuttle_landmark/escape_pod/start/pod14
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 14
/obj/effect/shuttle_landmark/escape_pod/out/pod14
	number = 14
/obj/effect/shuttle_landmark/escape_pod/transit/pod14
	number = 14

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod15
	shuttle_area = /area/shuttle/escape_pod15/station
	number = 15
/obj/effect/shuttle_landmark/escape_pod/start/pod15
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 15
/obj/effect/shuttle_landmark/escape_pod/out/pod15
	number = 15
/obj/effect/shuttle_landmark/escape_pod/transit/pod15
	number = 15

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod116
	shuttle_area = /area/shuttle/escape_pod16/station
	number = 16
/obj/effect/shuttle_landmark/escape_pod/start/pod16
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 16
/obj/effect/shuttle_landmark/escape_pod/out/pod16
	number = 16
/obj/effect/shuttle_landmark/escape_pod/transit/pod16
	number = 16

/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod17
	shuttle_area = /area/shuttle/escape_pod17/station
	number = 17
/obj/effect/shuttle_landmark/escape_pod/start/pod17
	base_turf = /turf/simulated/floor/reinforced/airless
	number = 17
/obj/effect/shuttle_landmark/escape_pod/out/pod17
	number = 17
/obj/effect/shuttle_landmark/escape_pod/transit/pod17
	number = 17

//Petrov

/datum/shuttle/autodock/ferry/petrov
	name = "Petrov"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/petrov/ship,/area/shuttle/petrov/cell1,/area/shuttle/petrov/cell2,/area/shuttle/petrov/cell3)
	dock_target = "petrov_shuttle"
	waypoint_station = "nav_petrov_start"
	waypoint_offsite = "nav_petrov_out"

/obj/effect/shuttle_landmark/petrov/start
	name = "First Deck"
	landmark_tag = "nav_petrov_start"
	docking_controller = "petrov_shuttle_dock_airlock"

/obj/effect/shuttle_landmark/petrov/out
	name = "Space near the ship"
	landmark_tag = "nav_petrov_out"

//Ninja Shuttle.
/datum/shuttle/autodock/multi/antag/ninja
	name = "Ninja"
	warmup_time = 0
	destinations = list(
		"nav_ninja_deck1",
		"nav_ninja_deck2",
		"nav_ninja_deck3",
		"nav_ninja_deck4",
		"nav_ninja_deck5",
		"nav_away_6",
		"nav_derelict_5",
		"nav_cluster_6",
		"nav_ninja_start"
		)
	shuttle_area = /area/ninja_dojo/start
	current_location = "nav_ninja_start"
	landmark_transition = "nav_ninja_transition"
	announcer = "SEV Torch Sensor Array"
	arrival_message = "Attention, anomalous sensor reading detected entering vessel proximity."
	departure_message = "Attention, anomalous sensor reading detected leaving vessel proximity."


/obj/effect/shuttle_landmark/ninja/start
	name = "Clan Dojo"
	landmark_tag = "nav_ninja_start"

/obj/effect/shuttle_landmark/ninja/internim
	name = "In transit"
	landmark_tag = "nav_ninja_transition"

/obj/effect/shuttle_landmark/ninja/deck1
	name = "South of First Deck"
	landmark_tag = "nav_ninja_deck1"

/obj/effect/shuttle_landmark/ninja/deck2
	name = "Northeast of Second Deck"
	landmark_tag = "nav_ninja_deck2"

/obj/effect/shuttle_landmark/ninja/deck3
	name = "East of Third Deck"
	landmark_tag = "nav_ninja_deck3"

/obj/effect/shuttle_landmark/ninja/deck4
	name = "West of Fourth Deck"
	landmark_tag = "nav_ninja_deck4"

/obj/effect/shuttle_landmark/ninja/deck5
	name = "Southeast of Bridge"
	landmark_tag = "nav_ninja_deck5"

//Merchant

/datum/shuttle/autodock/ferry/merchant
	name = "Merchant"
	warmup_time = 10
	shuttle_area = /area/shuttle/merchant/home
	waypoint_station = "nav_merchant_start"
	waypoint_offsite = "nav_merchant_out"
	dock_target = "merchant_ship_dock"

/obj/effect/shuttle_landmark/merchant/start
	name = "Merchant Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station_dock"

/obj/effect/shuttle_landmark/merchant/out
	name = "Docking Bay"
	landmark_tag = "nav_merchant_out"
	docking_controller = "merchant_shuttle_station_dock"

//Admin

/datum/shuttle/autodock/ferry/administration
	name = "Administration"
	warmup_time = 10	//want some warmup time so people can cancel.
	shuttle_area = /area/shuttle/administration/centcom
	dock_target = "admin_shuttle"
	waypoint_station = "nav_admin_start"
	waypoint_offsite = "nav_admin_out"

/obj/effect/shuttle_landmark/admin/start
	name = "Centcom"
	landmark_tag = "nav_admin_start"
	docking_controller = "admin_shuttle"
	base_area = /area/centcom
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/admin/out
	name = "Docking Bay"
	landmark_tag = "nav_admin_out"
	docking_controller = "admin_shuttle_dock_airlock"

//Transport

/datum/shuttle/autodock/ferry/centcom
	name = "Centcom"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/transport1/centcom
	dock_target = "centcom_shuttle"
	waypoint_offsite = "nav_ferry_start"
	waypoint_station = "nav_ferry_out"

/obj/effect/shuttle_landmark/ferry/start
	name = "Centcom"
	landmark_tag = "nav_ferry_start"
	docking_controller = "centcom_shuttle_bay"

/obj/effect/shuttle_landmark/ferry/out
	name = "Docking Bay"
	landmark_tag = "nav_ferry_out"
	docking_controller = "centcom_shuttle_dock_airlock"

//Merc

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 0
	destinations = list(
		"nav_merc_deck1",
		"nav_merc_deck2",
		"nav_merc_deck3",
		"nav_merc_deck4",
		"nav_merc_deck5",
		"nav_away_5",
		"nav_derelict_6",
		"nav_cluster_5",
		"nav_merc_dock",
		"nav_merc_start"
		)
	shuttle_area = /area/syndicate_station/start
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_transition"
	announcer = "SEV Torch Sensor Array"
	home_waypoint = "nav_merc_start"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"

/obj/effect/shuttle_landmark/merc/internim
	name = "In transit"
	landmark_tag = "nav_merc_transition"

/obj/effect/shuttle_landmark/merc/dock
	name = "Docking Port"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"

/obj/effect/shuttle_landmark/merc/deck1
	name = "Northeast of First Deck"
	landmark_tag = "nav_merc_deck1"

/obj/effect/shuttle_landmark/merc/deck2
	name = "Southeast of the Second deck"
	landmark_tag = "nav_merc_deck2"

/obj/effect/shuttle_landmark/merc/deck3
	name = "South of Third deck"
	landmark_tag = "nav_merc_deck3"

/obj/effect/shuttle_landmark/merc/deck4
	name = "Northwest of Fourth Deck"
	landmark_tag = "nav_merc_deck4"

/obj/effect/shuttle_landmark/merc/deck5
	name = "East of Bridge"
	landmark_tag = "nav_merc_deck5"

//Skipjack

/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	warmup_time = 0
	destinations = list(
		"nav_skipjack_deck1",
		"nav_skipjack_deck2",
		"nav_skipjack_deck3",
		"nav_skipjack_deck4",
		"nav_skipjack_deck5",
		"nav_away_7",
		"nav_derelict_7",
		"nav_cluster_7",
		"nav_skipjack_dock",
		"nav_skipjack_start"
		)
	shuttle_area =  /area/skipjack_station/start
	dock_target = "skipjack_shuttle"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_transition"
	announcer = "SEV Torch Sensor Array"
	home_waypoint = "nav_skipjack_start"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."

/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Outpost"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "skipjack_base"

/obj/effect/shuttle_landmark/skipjack/internim
	name = "In transit"
	landmark_tag = "nav_skipjack_transition"

/obj/effect/shuttle_landmark/skipjack/dock
	name = "Docking Port"
	landmark_tag = "nav_skipjack_dock"
	docking_controller = "skipjack_shuttle_dock_airlock"

/obj/effect/shuttle_landmark/skipjack/deck1
	name = "Northwest of First Deck"
	landmark_tag = "nav_skipjack_deck1"

/obj/effect/shuttle_landmark/skipjack/deck2
	name = "Southwest of the Second deck"
	landmark_tag = "nav_skipjack_deck2"

/obj/effect/shuttle_landmark/skipjack/deck3
	name = "Southeast of Third deck"
	landmark_tag = "nav_skipjack_deck3"

/obj/effect/shuttle_landmark/skipjack/deck4
	name = "Northwest of Fourth Deck"
	landmark_tag = "nav_skipjack_deck4"

/obj/effect/shuttle_landmark/skipjack/deck5
	name = "South of Bridge"
	landmark_tag = "nav_skipjack_deck5"

//NT Rescue Shuttle

/datum/shuttle/autodock/multi/antag/rescue
	name = "Rescue"
	warmup_time = 0
	destinations = list(
		"nav_ert_deck1",
		"nav_ert_deck2",
		"nav_ert_deck3",
		"nav_ert_deck4",
		"nav_ert_deck5",
		"nav_away_4",
		"nav_derelict_4",
		"nav_cluster_4",
		"nav_ert_dock",
		"nav_ert_start"
		)
	shuttle_area = /area/rescue_base/start
	dock_target = "rescue_shuttle"
	current_location = "nav_ert_start"
	landmark_transition = "nav_ert_transition"
	home_waypoint = "nav_ert_start"
	announcer = "SEV Torch Sensor Array"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."

/obj/effect/shuttle_landmark/ert/start
	name = "Response Team Base"
	landmark_tag = "nav_ert_start"
	docking_controller = "rescue_base"

/obj/effect/shuttle_landmark/ert/internim
	name = "In transit"
	landmark_tag = "nav_ert_transition"

/obj/effect/shuttle_landmark/ert/dock
	name = "Docking Port"
	landmark_tag = "nav_ert_dock"
	docking_controller = "rescue_shuttle_dock_airlock"

/obj/effect/shuttle_landmark/ert/deck1
	name =  "Southwest of Fourth deck"
	landmark_tag = "nav_ert_deck1"

/obj/effect/shuttle_landmark/ert/deck2
	name = "Northwest of Third deck"
	landmark_tag = "nav_ert_deck2"

/obj/effect/shuttle_landmark/ert/deck3
	name = "Northwest of Second deck"
	landmark_tag = "nav_ert_deck3"

/obj/effect/shuttle_landmark/ert/deck4
	name = "Southwest of First Deck"
	landmark_tag = "nav_ert_deck4"

/obj/effect/shuttle_landmark/ert/deck5
	name = "West of Bridge"
	landmark_tag = "nav_ert_deck5"

//SCGMC Assault Pod

/datum/shuttle/autodock/ferry/specops/ert
	name = "Special Operations"
	warmup_time = 10
	shuttle_area = /area/shuttle/specops/centcom
	dock_target = "specops_shuttle_fore"
	waypoint_station = "nav_specops_start"
	waypoint_offsite = "nav_specops_out"

/obj/effect/shuttle_landmark/specops/start
	name = "Centcom"
	landmark_tag = "nav_specops_start"
	docking_controller = "specops_shuttle_port"

/obj/effect/shuttle_landmark/specops/out
	name = "Docking Bay"
	landmark_tag = "nav_specops_out"
	docking_controller = "specops_dock_airlock"

//Cargo drone

/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply Drone"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"

/obj/effect/shuttle_landmark/supply/centcom
	name = "Centcom"
	landmark_tag = "nav_cargo_start"

/obj/effect/shuttle_landmark/supply/station
	name = "Hangar"
	landmark_tag = "nav_cargo_station"
	base_area = /area/quartermaster/hangar
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/overmap/exploration_shuttle
	name = "Charon"
	move_time = 90
	shuttle_area = list(/area/exploration_shuttle/cockpit, /area/exploration_shuttle/atmos, /area/exploration_shuttle/power, /area/exploration_shuttle/crew, /area/exploration_shuttle/cargo, /area/exploration_shuttle/airlock)
	current_location = "nav_hangar_calypso"
	landmark_transition = "nav_transit_calypso"
	range = 1

/obj/effect/shuttle_landmark/torch/hangar/exploration_shuttle
	name = "Charon Hangar"
	landmark_tag = "nav_hangar_calypso"
	base_area = /area/quartermaster/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/torch/deck1/exploration_shuttle
	name = "Space near Deck Four"
	landmark_tag = "nav_deck1_calypso"

/obj/effect/shuttle_landmark/torch/deck2/exploration_shuttle
	name = "Space near Deck Three"
	landmark_tag = "nav_deck2_calypso"

/obj/effect/shuttle_landmark/torch/deck3/exploration_shuttle
	name = "Space near Deck Two"
	landmark_tag = "nav_deck3_calypso"

/obj/effect/shuttle_landmark/torch/deck4/exploration_shuttle
	name = "Space near Deck One"
	landmark_tag = "nav_deck4_calypso"

/obj/effect/shuttle_landmark/torch/deck5/exploration_shuttle
	name = "Space near Bridge"
	landmark_tag = "nav_bridge_calypso"

/obj/effect/shuttle_landmark/torch/transit/exploration_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_calypso"

/datum/shuttle/autodock/overmap/guppy
	name = "Guppy"
	warmup_time = 5
	move_time = 30
	shuttle_area = /area/guppy_hangar/start
	current_location = "nav_hangar_guppy"
	landmark_transition = "nav_transit_guppy"
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'

/obj/effect/shuttle_landmark/torch/hangar/guppy
	name = "Guppy Hangar"
	landmark_tag = "nav_hangar_guppy"
	base_area = /area/quartermaster/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/torch/deck1/guppy
	name = "Space near Deck Four"
	landmark_tag = "nav_deck1_guppy"

/obj/effect/shuttle_landmark/torch/deck2/guppy
	name = "Space near Deck Three"
	landmark_tag = "nav_deck2_guppy"

/obj/effect/shuttle_landmark/torch/deck3/guppy
	name = "Space near Deck Two"
	landmark_tag = "nav_deck3_guppy"

/obj/effect/shuttle_landmark/torch/deck4/guppy
	name = "Space near Deck One"
	landmark_tag = "nav_deck4_guppy"

/obj/effect/shuttle_landmark/torch/deck5/guppy
	name = "Space near Bridge"
	landmark_tag = "nav_bridge_guppy"

/obj/effect/shuttle_landmark/torch/transit/guppy
	name = "In transit"
	landmark_tag = "nav_transit_guppy"

/datum/shuttle/autodock/overmap/aquila
	name = "Aquila"
	move_time = 60
	shuttle_area = /area/aquila_hangar/start
	current_location = "nav_hangar_aquila"
	landmark_transition = "nav_transit_aquila"
	dock_target = "aquila_shuttle"
	range = 2

/obj/effect/shuttle_landmark/torch/hangar/aquila
	name = "Aquila Hangar"
	landmark_tag = "nav_hangar_aquila"
	docking_controller = "aquila_shuttle_dock_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/torch/deck1/aquila
	name = "Space near Deck Four"
	landmark_tag = "nav_deck1_aquila"

/obj/effect/shuttle_landmark/torch/deck2/aquila
	name = "Space near Deck Three"
	landmark_tag = "nav_deck2_aquila"

/obj/effect/shuttle_landmark/torch/deck3/aquila
	name = "Space near Deck Two"
	landmark_tag = "nav_deck3_aquila"

/obj/effect/shuttle_landmark/torch/deck4/aquila
	name = "Space near Deck One"
	landmark_tag = "nav_deck4_aquila"

/obj/effect/shuttle_landmark/torch/deck5/aquila
	name = "Space near Bridge"
	landmark_tag = "nav_bridge_aquila"

/obj/effect/shuttle_landmark/torch/transit/aquila
	name = "In transit"
	landmark_tag = "nav_transit_aquila"