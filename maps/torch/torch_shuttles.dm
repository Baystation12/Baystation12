/datum/shuttle/ferry/administration
	name = "Administration"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/administration/centcom
	area_station = /area/shuttle/administration/station
	docking_controller_tag = "admin_shuttle"
	dock_target_station = "admin_shuttle_dock_airlock"
	dock_target_offsite = "admin_shuttle_bay"

/datum/shuttle/multi_shuttle/mercenary
	name = "Mercenary"
	warmup_time = 0
	origin = /area/syndicate_station/start
	interim = /area/syndicate_station/transit
	start_location = "Mercenary Base"
	destinations = list(
		"Northwest of the station" = /area/syndicate_station/northwest,
		"North of the station" = /area/syndicate_station/north,
		"Northeast of the station" = /area/syndicate_station/northeast,
		"Southwest of the station" = /area/syndicate_station/southwest,
		"South of the station" = /area/syndicate_station/south,
		"Southeast of the station" = /area/syndicate_station/southeast,
		"Telecomms Satellite" = /area/syndicate_station/commssat,
		"Mining Station" = /area/syndicate_station/mining,
		"Arrivals dock" = /area/syndicate_station/arrivals_dock,
		)
	docking_controller_tag = "merc_shuttle"
	destination_dock_targets = list(
		"Mercenary Base" = "merc_base",
		"Arrivals dock" = "nuke_shuttle_dock_airlock",
		)
	announcer = "NDV Icarus"

/datum/shuttle/multi_shuttle/mercenary/New()
	arrival_message = "Attention, [station_short], you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	departure_message = "Your visitors are on their way out of the system, [station_short], burning delta-v like it's nothing. Good riddance."
	..()

/datum/shuttle/multi_shuttle/skipjack
	name = "Skipjack"
	warmup_time = 0
	origin = /area/skipjack_station/start
	interim = /area/skipjack_station/transit
	destinations = list(
		"Fore Starboard Solars" = /area/skipjack_station/northeast_solars,
		"Fore Port Solars" = /area/skipjack_station/northwest_solars,
		"Aft Starboard Solars" = /area/skipjack_station/southeast_solars,
		"Aft Port Solars" = /area/skipjack_station/southwest_solars,
		"Mining Station" = /area/skipjack_station/mining
		)
	announcer = "NDV Icarus"

/datum/shuttle/multi_shuttle/skipjack/New()
	arrival_message = "Attention, [station_short], we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	departure_message = "Your guests are pulling away, [station_short] - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	..()

/datum/shuttle/multi_shuttle/rescue
	name = "Rescue"
	warmup_time = 0
	origin = /area/rescue_base/start
	interim = /area/rescue_base/transit
	start_location = "Response Team Base"
	destinations = list(
		"Northwest of the station" = /area/rescue_base/northwest,
		"North of the station" = /area/rescue_base/north,
		"Northeast of the station" = /area/rescue_base/northeast,
		"Southwest of the station" = /area/rescue_base/southwest,
		"South of the station" = /area/rescue_base/south,
		"Southeast of the station" = /area/rescue_base/southeast,
		"Telecomms Satellite" = /area/rescue_base/commssat,
		"Engineering Station" = /area/rescue_base/mining,
		"Arrivals dock" = /area/rescue_base/arrivals_dock,
		)
	docking_controller_tag = "rescue_shuttle"
	destination_dock_targets = list(
		"Response Team Base" = "rescue_base",
		"Arrivals dock" = "rescue_shuttle_dock_airlock",
		)
	announcer = "NDV Icarus"

/datum/shuttle/multi_shuttle/rescue/New()
	arrival_message = "Attention, [station_short], there's a small patrol craft headed your way, it flashed us Asset Protection codes and we let it pass. You've got guests on the way."
	departure_message = "[station_short], That Asset Protection vessel is headed back the way it came. Hope they were helpful."
	..()

/datum/shuttle/ferry/multidock/specops/ert
	name = "Special Operations"
	location = 0
	warmup_time = 10
	area_offsite = /area/shuttle/specops/station	//centcom is the home station, the Exodus is offsite
	area_station = /area/shuttle/specops/centcom
	docking_controller_tag = "specops_shuttle_port"
	docking_controller_tag_station = "specops_shuttle_port"
	docking_controller_tag_offsite = "specops_shuttle_fore"
	dock_target_station = "specops_centcom_dock"
	dock_target_offsite = "specops_dock_airlock"


//Torch Large Pods

/datum/shuttle/ferry/emergency/escape_pod_six
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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
		"Debris Field" = /area/calypso_hangar/salvage,
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
		"Debris Field" = /area/guppy_hangar/salvage,
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
