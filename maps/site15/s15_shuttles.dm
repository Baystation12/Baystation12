//Some helpers because so much copypasta for pods
/datum/shuttle/autodock/ferry/escape_pod/torchpod
	category = /datum/shuttle/autodock/ferry/escape_pod/torchpod
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	warmup_time = 10

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"

//Pods
#define TORCH_ESCAPE_POD(NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/torchpod/escape_pod##NUMBER { \
	shuttle_area = /area/shuttle/escape_pod##NUMBER/station; \
	name = "Escape Pod " + #NUMBER; \
	dock_target = "escape_pod_" + #NUMBER; \
	arming_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	waypoint_station = "escape_pod_"+ #NUMBER +"_start"; \
	landmark_transition = "escape_pod_"+ #NUMBER +"_internim"; \
	waypoint_offsite = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/start/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_start"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_berth"; \
} \
/obj/effect/shuttle_landmark/escape_pod/out/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_internim"; \
} \
/obj/effect/shuttle_landmark/escape_pod/transit/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_out"; \
}

TORCH_ESCAPE_POD(6)
TORCH_ESCAPE_POD(7)
TORCH_ESCAPE_POD(8)
TORCH_ESCAPE_POD(9)
TORCH_ESCAPE_POD(10)
TORCH_ESCAPE_POD(11)
TORCH_ESCAPE_POD(12)
TORCH_ESCAPE_POD(13)
TORCH_ESCAPE_POD(14)
TORCH_ESCAPE_POD(15)
TORCH_ESCAPE_POD(16)
TORCH_ESCAPE_POD(17)

//Petrov

/datum/shuttle/autodock/ferry/petrov
	name = "Petrov"
	warmup_time = 10
	dock_target = "petrov_shuttle_airlock"
	waypoint_station = "nav_petrov_start"
	waypoint_offsite = "nav_petrov_out"
	logging_home_tag = "nav_petrov_start"
	logging_access = access_petrov_helm
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/datum/shuttle/autodock/ferry/petrov/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	shuttle_area = subtypesof(/area/shuttle/petrov)
	..()

/obj/effect/shuttle_landmark/petrov/start
	name = "First Deck"
	landmark_tag = "nav_petrov_start"
	docking_controller = "petrov_shuttle_dock_airlock"

/obj/effect/shuttle_landmark/petrov/out
	name = "Space near the ship"
	landmark_tag = "nav_petrov_out"

//Ninja Shuttle.
/datum/shuttle/autodock/multi/antag/ninja
	destination_tags = list(
		"nav_ninja_deck1",
		"nav_ninja_deck2",
		"nav_ninja_deck3",
		"nav_ninja_deck4",
		"nav_ninja_deck5",
		"nav_ninja_hanger",
		"nav_away_6",
		"nav_derelict_5",
		"nav_cluster_6",
		"nav_ninja_start",
		"nav_lost_supply_base_antag",
		"nav_marooned_antag",
		"nav_smugglers_antag",
		"nav_magshield_antag",
		"nav_casino_antag",
		"nav_yacht_antag",
		"nav_slavers_base_antag"
		)

/obj/effect/shuttle_landmark/ninja/hanger
	name = "West of Hanger Deck"
	landmark_tag = "nav_ninja_hanger"

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

/obj/effect/shuttle_landmark/merc/hanger
	name = "Northeast of Hanger Deck"
	landmark_tag = "nav_merc_hanger"

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
	destination_tags = list(
		"nav_skipjack_deck1",
		"nav_skipjack_deck2",
		"nav_skipjack_deck3",
		"nav_skipjack_deck4",
		"nav_skipjack_deck5",
		"nav_skipjack_hanger",
		"nav_away_7",
		"nav_derelict_7",
		"nav_cluster_7",
		"nav_skipjack_dock",
		"nav_skipjack_start",
		"nav_lost_supply_base_antag",
		"nav_marooned_antag",
		"nav_smugglers_antag",
		"nav_magshield_antag",
		"nav_casino_antag",
		"nav_yacht_antag",
		"nav_slavers_base_antag",
		)

/obj/effect/shuttle_landmark/skipjack/hanger
	name = "North of Hanger Deck"
	landmark_tag = "nav_skipjack_hanger"

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
	destination_tags = list(
		"nav_ert_deck1",
		"nav_ert_deck2",
		"nav_ert_deck3",
		"nav_ert_deck4",
		"nav_ert_deck5",
		"nav_ert_hanger",
		"nav_away_4",
		"nav_derelict_4",
		"nav_cluster_4",
		"nav_ert_dock",
		"nav_ert_start",
		"nav_lost_supply_base_antag",
		"nav_marooned_antag",
		"nav_smugglers_antag",
		"nav_magshield_antag",
		"nav_casino_antag",
		"nav_yacht_antag",
		"nav_slavers_base_antag",
		)

/obj/effect/shuttle_landmark/ert/hanger
	name =  "Southeast of Hanger deck"
	landmark_tag = "nav_ert_hanger"

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
	name = "Offsite"
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
	dock_target = "calypso_shuttle"
	current_location = "nav_hangar_calypso"
	landmark_transition = "nav_transit_calypso"
	range = 1
	fuel_consumption = 4
	logging_home_tag = "nav_hangar_calypso"
	logging_access = access_expedition_shuttle_helm
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/torch

/obj/effect/shuttle_landmark/torch/hangar/exploration_shuttle
	name = "Charon Hangar"
	landmark_tag = "nav_hangar_calypso"
	base_area = /area/quartermaster/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/torch/deck1/exploration_shuttle
	name = "Space near Forth Deck"
	landmark_tag = "nav_deck1_calypso"

/obj/effect/shuttle_landmark/torch/deck2/exploration_shuttle
	name = "Space near Third Deck"
	landmark_tag = "nav_deck2_calypso"

/obj/effect/shuttle_landmark/torch/deck3/exploration_shuttle
	name = "Space near Second Deck"
	landmark_tag = "nav_deck3_calypso"

/obj/effect/shuttle_landmark/torch/deck4/exploration_shuttle
	name = "Space near First Deck"
	landmark_tag = "nav_deck4_calypso"

/obj/effect/shuttle_landmark/torch/deck5/exploration_shuttle
	name = "Space near Bridge"
	landmark_tag = "nav_bridge_calypso"

/obj/effect/shuttle_landmark/transit/torch/exploration_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_calypso"

/datum/shuttle/autodock/overmap/guppy
	name = "Guppy"
	warmup_time = 5
	move_time = 30
	shuttle_area = /area/guppy_hangar/start
	dock_target ="guppy_shuttle"
	current_location = "nav_hangar_guppy"
	landmark_transition = "nav_transit_guppy"
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_guppy"
	logging_access = access_guppy_helm
	skill_needed = SKILL_NONE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/torch

/obj/effect/shuttle_landmark/torch/hangar/guppy
	name = "Guppy Hangar"
	landmark_tag = "nav_hangar_guppy"
	base_area = /area/quartermaster/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/torch/deck1/guppy
	name = "Space near Forth Deck"
	landmark_tag = "nav_deck1_guppy"

/obj/effect/shuttle_landmark/torch/deck2/guppy
	name = "Space near Third Deck"
	landmark_tag = "nav_deck2_guppy"

/obj/effect/shuttle_landmark/torch/deck3/guppy
	name = "Space near Second Deck"
	landmark_tag = "nav_deck3_guppy"

/obj/effect/shuttle_landmark/torch/deck4/guppy
	name = "Space near First Deck"
	landmark_tag = "nav_deck4_guppy"

/obj/effect/shuttle_landmark/torch/deck5/guppy
	name = "Space near Bridge"
	landmark_tag = "nav_bridge_guppy"

/obj/effect/shuttle_landmark/transit/torch/guppy
	name = "In transit"
	landmark_tag = "nav_transit_guppy"

/datum/shuttle/autodock/overmap/aquila
	name = "Aquila"
	move_time = 60
	shuttle_area = list(/area/aquila/cockpit, /area/aquila/maintenance, /area/aquila/storage, /area/aquila/secure_storage, /area/aquila/mess, /area/aquila/passenger, /area/aquila/medical, /area/aquila/head, /area/aquila/airlock)
	current_location = "nav_hangar_aquila"
	landmark_transition = "nav_transit_aquila"
	dock_target = "aquila_shuttle"
	range = 2
	logging_home_tag = "nav_hangar_aquila"
	logging_access = access_aquila_helm
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/torch

/obj/effect/shuttle_landmark/torch/hangar/aquila
	name = "Aquila Hangar"
	landmark_tag = "nav_hangar_aquila"
	docking_controller = "aquila_shuttle_dock_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/torch/deck1/aquila
	name = "Space near Forth Deck"
	landmark_tag = "nav_deck1_aquila"

/obj/effect/shuttle_landmark/torch/deck2/aquila
	name = "Space near Third Deck"
	landmark_tag = "nav_deck2_aquila"

/obj/effect/shuttle_landmark/torch/deck3/aquila
	name = "Space near Second Deck"
	landmark_tag = "nav_deck3_aquila"

/obj/effect/shuttle_landmark/torch/deck4/aquila
	name = "Space near First Deck"
	landmark_tag = "nav_deck4_aquila"

/obj/effect/shuttle_landmark/torch/deck5/aquila
	name = "Space near Bridge"
	landmark_tag = "nav_bridge_aquila"

/obj/effect/shuttle_landmark/transit/torch/aquila
	name = "In transit"
	landmark_tag = "nav_transit_aquila"

//Makes the deck management program use hangar access
/datum/nano_module/deck_management
	default_access = list(access_hangar, access_cargo, access_heads)