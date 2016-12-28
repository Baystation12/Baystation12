/obj/machinery/computer/shuttle_control/multi/calypso
	name = "calypso control console"
	icon_keyboard = "rd_key"
	icon_screen = "shuttle"
	//req_access = list(access_mining)
	shuttle_tag = "Calypso"

/obj/machinery/computer/shuttle_control/multi/guppy
	name = "general utility pod control console"
	icon_keyboard = "power_key"
	icon_screen = "supply"
	//req_access = list(access_mining)
	shuttle_tag = "GUP"

//Torch Large Pods

/datum/shuttle/ferry/escape_pod/escape_pod_six
	name = "Escape Pod 6"
	location = 0
	warmup_time = 10
	area_station = /area/shuttle/escape_pod6/station
	area_offsite = /area/shuttle/escape_pod6/centcom
	area_transition = /area/shuttle/escape_pod6/transit
	docking_controller_tag = "escape_pod_6"
	dock_target_station = "escape_pod_6_berth"
	dock_target_offsite = "escape_pod_6_recovery"
	transit_direction = NORTH

/datum/shuttle/ferry/escape_pod/escape_pod_seven
	name = "Escape Pod 7"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod7/station
	area_offsite = /area/shuttle/escape_pod7/centcom
	area_transition = /area/shuttle/escape_pod7/transit
	docking_controller_tag = "escape_pod_7"
	dock_target_station = "escape_pod_7_berth"
	dock_target_offsite = "escape_pod_7_recovery"
	transit_direction = NORTH

/datum/shuttle/ferry/escape_pod/escape_pod_eight
	name = "Escape Pod 8"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod8/station
	area_offsite = /area/shuttle/escape_pod8/centcom
	area_transition = /area/shuttle/escape_pod8/transit
	docking_controller_tag = "escape_pod_8"
	dock_target_station = "escape_pod_8_berth"
	dock_target_offsite = "escape_pod_8_recovery"
	transit_direction = SOUTH

/datum/shuttle/ferry/escape_pod/escape_pod_nine
	name = "Escape Pod 9"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod9/station
	area_offsite = /area/shuttle/escape_pod9/centcom
	area_transition = /area/shuttle/escape_pod9/transit
	docking_controller_tag = "escape_pod_9"
	dock_target_station = "escape_pod_9_berth"
	dock_target_offsite = "escape_pod_9_recovery"
	transit_direction = SOUTH

/datum/shuttle/ferry/escape_pod/escape_pod_ten
	name = "Escape Pod 10"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod10/station
	area_offsite = /area/shuttle/escape_pod10/centcom
	area_transition = /area/shuttle/escape_pod10/transit
	docking_controller_tag = "escape_pod_10"
	dock_target_station = "escape_pod_10_berth"
	dock_target_offsite = "escape_pod_10_recovery"
	transit_direction = WEST

/datum/shuttle/ferry/escape_pod/escape_pod_eleven
	name = "Escape Pod 11"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod11/station
	area_offsite = /area/shuttle/escape_pod11/centcom
	area_transition = /area/shuttle/escape_pod11/transit
	docking_controller_tag = "escape_pod_11"
	dock_target_station = "escape_pod_11_berth"
	dock_target_offsite = "escape_pod_11_recovery"
	transit_direction = WEST

//Torch Small Pods

/datum/shuttle/ferry/escape_pod/escape_pod_twelve
	name = "Escape Pod 12"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod12/station
	area_offsite = /area/shuttle/escape_pod12/centcom
	area_transition = /area/shuttle/escape_pod12/transit
	docking_controller_tag = "escape_pod_12"
	dock_target_station = "escape_pod_12_berth"
	dock_target_offsite = "escape_pod_12_recovery"
	transit_direction = NORTH

/datum/shuttle/ferry/escape_pod/escape_pod_thirteen
	name = "Escape Pod 13"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod13/station
	area_offsite = /area/shuttle/escape_pod13/centcom
	area_transition = /area/shuttle/escape_pod13/transit
	docking_controller_tag = "escape_pod_13"
	dock_target_station = "escape_pod_13_berth"
	dock_target_offsite = "escape_pod_13_recovery"
	transit_direction = NORTH

/datum/shuttle/ferry/escape_pod/escape_pod_fourteen
	name = "Escape Pod 14"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod14/station
	area_offsite = /area/shuttle/escape_pod14/centcom
	area_transition = /area/shuttle/escape_pod14/transit
	docking_controller_tag = "escape_pod_14"
	dock_target_station = "escape_pod_14_berth"
	dock_target_offsite = "escape_pod_14_recovery"
	transit_direction = NORTH

/datum/shuttle/ferry/escape_pod/escape_pod_fifthteen
	name = "Escape Pod 15"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod15/station
	area_offsite = /area/shuttle/escape_pod15/centcom
	area_transition = /area/shuttle/escape_pod15/transit
	docking_controller_tag = "escape_pod_15"
	dock_target_station = "escape_pod_15_berth"
	dock_target_offsite = "escape_pod_15_recovery"
	transit_direction = SOUTH

/datum/shuttle/ferry/escape_pod/escape_pod_sixteen
	name = "Escape Pod 16"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod16/station
	area_offsite = /area/shuttle/escape_pod16/centcom
	area_transition = /area/shuttle/escape_pod16/transit
	docking_controller_tag = "escape_pod_16"
	dock_target_station = "escape_pod_16_berth"
	dock_target_offsite = "escape_pod_16_recovery"
	transit_direction = SOUTH

/datum/shuttle/ferry/escape_pod/escape_pod_seventeen
	name = "Escape Pod 17"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod17/station
	area_offsite = /area/shuttle/escape_pod17/centcom
	area_transition = /area/shuttle/escape_pod17/transit
	docking_controller_tag = "escape_pod_17"
	dock_target_station = "escape_pod_17_berth"
	dock_target_offsite = "escape_pod_17_recovery"
	transit_direction = SOUTH

//Calypso.
/datum/shuttle/multi_shuttle/calypso
	name = "Calypso"
	warmup_time = 0
	origin = /area/calypso_hangar/start
	interim = /area/calypso_hangar/transit
	start_location = "SEV Torch Hangar Deck"
	destinations = list(
		"North of First Deck" = /area/calypso_hangar/firstdeck,
		"South of Second Deck" = /area/calypso_hangar/seconddeck,
		"West of Third Deck" = /area/calypso_hangar/thirddeck,
		"East of Fourth Deck" = /area/calypso_hangar/fourthdeck,
		"Asteroid" = /area/calypso_hangar/mining,
		"Away Site" = /area/calypso_hangar/away,
		)
	announcer = "SEV Torch Docking Computer"
	arrival_message = "Attention, shuttle Calypso returning. Clear the Hangar Deck."
	departure_message = "Attention, shuttle Calypso departing. Clear the Hangar Deck."

//General Utility Pod.
/datum/shuttle/multi_shuttle/gup
	name = "GUP"
	warmup_time = 0
	origin = /area/guppy_hangar/start
	interim = /area/guppy_hangar/transit
	start_location = "SEV Torch Hangar Deck"

	destinations = list(
		"East of First Deck" = /area/guppy_hangar/firstdeck,
		"West of Second Deck" = /area/guppy_hangar/seconddeck,
		"South of Third Deck" = /area/guppy_hangar/thirddeck,
		"North of Fourth Deck" = /area/guppy_hangar/fourthdeck,
		"Asteroid" = /area/guppy_hangar/mining,
		)

	announcer = "SEV Torch Docking Computer"
	arrival_message = "Attention, General Utility Pod returning. Clear the Hangar Deck."
	departure_message = "Attention, General Utility Pod departing. Clear the Hangar Deck."

//Ninja Shuttle.
/datum/shuttle/multi_shuttle/ninja
	name = "Ninja"
	warmup_time = 0
	origin = /area/ninja_dojo/start
	interim = /area/ninja_dojo/transit
	start_location = "Clan Dojo"
	destinations = list(
		"South of First Deck" = /area/ninja_dojo/firstdeck,
		"North of Second Deck" = /area/ninja_dojo/seconddeck,
		"East of Third Deck" = /area/ninja_dojo/thirddeck,
		"West of Fourth Deck" = /area/ninja_dojo/fourthdeck,
		"Debris Field" = /area/ninja_dojo/salvage,
		"Asteroid" = /area/ninja_dojo/mining,
		"Away Site" = /area/ninja_dojo/away,
		)
	announcer = "SEV Torch Sensor Array"
	arrival_message = "Attention, anomalous sensor reading detected entering vessel proximity."
	departure_message = "Attention, anomalous sensor reading detected leaving vessel proximity."

//Merchant

/datum/shuttle/ferry/merchant
	name = "Merchant"
	warmup_time = 10
	docking_controller_tag = "merchant_ship_dock"
	dock_target_station = "merchant_station_dock"
	dock_target_offsite = "merchant_shuttle_station_dock"
	area_station = /area/shuttle/merchant/home
	area_offsite = /area/shuttle/merchant/away

//Admin

/datum/shuttle/ferry/administration
	name = "Administration"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/administration/centcom
	area_station = /area/shuttle/administration/station
	docking_controller_tag = "admin_shuttle"
	dock_target_station = "admin_shuttle_dock_airlock"
	dock_target_offsite = "admin_shuttle_bay"

//Merc

/datum/shuttle/multi_shuttle/mercenary
	name = "Mercenary"
	warmup_time = 0
	origin = /area/syndicate_station/start
	interim = /area/syndicate_station/transit
	start_location = "Mercenary Base"
	destinations = list(
		"Northeast of first deck" = /area/syndicate_station/firstdeck,
		"Southeast of the second deck" = /area/syndicate_station/seconddeck,
		"South of third deck" = /area/syndicate_station/thirddeck,
		"Northwest of fourth deck" = /area/syndicate_station/fourthdeck,
		"Away Site" = /area/syndicate_station/away,
		"Debris Field" = /area/syndicate_station/salvage,
		"Mining Site" = /area/syndicate_station/mining,
		"Docking Port" = /area/syndicate_station/arrivals_dock,
		)
	docking_controller_tag = "merc_shuttle"
	destination_dock_targets = list(
		"Forward Operating Base" = "merc_base",
		"Docking Port" = "nuke_shuttle_dock_airlock",
		)
	announcer = "SEV Torch Sensor Array"

/datum/shuttle/multi_shuttle/mercenary/New()
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."
	..()

//Skipjack

/datum/shuttle/multi_shuttle/skipjack
	name = "Skipjack"
	warmup_time = 0
	origin = /area/skipjack_station/start
	interim = /area/skipjack_station/transit
	destinations = list(
		"Northwest of first deck" = /area/skipjack_station/firstdeck,
		"Southwest of second deck" = /area/skipjack_station/seconddeck,
		"Southeast of third deck" = /area/skipjack_station/thirddeck,
		"Northeast of fourth deck" = /area/skipjack_station/fourthdeck,
		"Mining Site" = /area/skipjack_station/mining,
		"Debris Field" = /area/skipjack_station/salvage,
		"Away Site" = /area/skipjack_station/away,
		"Docking Port" = /area/skipjack_station/arrivals_dock,
		)
	docking_controller_tag = "skipjack_shuttle"
	destination_dock_targets = list(
		"Raider Outpost" = "skipjack_base",
		"Docking Port" = "skipjack_shuttle_dock_airlock",
		)
	announcer = "SEV Torch Sensor Array"

/datum/shuttle/multi_shuttle/skipjack/New()
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."
	..()

//NT Rescue Shuttle

/datum/shuttle/multi_shuttle/rescue
	name = "Rescue"
	warmup_time = 0
	origin = /area/rescue_base/start
	interim = /area/rescue_base/transit
	start_location = "Response Team Base"
	destinations = list(
		"Southwest of first deck" = /area/rescue_base/firstdeck,
		"Northwest of second deck" = /area/rescue_base/seconddeck,
		"North of third deck" = /area/rescue_base/thirddeck,
		"Southeast of fourth deck" = /area/rescue_base/fourthdeck,
		"Away Site" = /area/rescue_base/away,
		"Debris Field" = /area/rescue_base/salvage,
		"Mining Site" = /area/rescue_base/mining,
		"Docking Port" = /area/rescue_base/arrivals_dock,
		)
	docking_controller_tag = "rescue_shuttle"
	destination_dock_targets = list(
		"Response Team Base" = "rescue_base",
		"Docking Port" = "rescue_shuttle_dock_airlock",
		)
	announcer = "SEV Torch Sensor Array"

/datum/shuttle/multi_shuttle/rescue/New()
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."
	..()

//SCGMC Assault Pod

/datum/shuttle/ferry/multidock/specops/ert
	name = "Special Operations"
	location = 0
	warmup_time = 10
	area_offsite = /area/shuttle/specops/station
	area_station = /area/shuttle/specops/centcom
	docking_controller_tag = "specops_shuttle_port"
	docking_controller_tag_station = "specops_shuttle_port"
	docking_controller_tag_offsite = "specops_shuttle_fore"
	dock_target_station = "specops_centcom_dock"
	dock_target_offsite = "specops_dock_airlock"

//Cargo drone

/datum/shuttle/ferry/supply/drone
	name = "Supply Drone"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "" // lands, doesn't dock
