/datum/shuttle/ferry/emergency/centcom
	name = "Escape"
	location = 1
	warmup_time = 10
	area_offsite = /area/shuttle/escape/centcom
	area_station = /area/shuttle/escape/station
	area_transition = /area/shuttle/escape/transit
	docking_controller_tag = "escape_shuttle"
	dock_target_station = "rescue_shuttle"
	dock_target_offsite = "hq_dock"
	transit_direction = NORTH

/datum/shuttle/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "supply_shuttle"
	dock_target_station = "cargo_bay"

/datum/shuttle/multi_shuttle/mercenary
	name = "Mercenary"
	warmup_time = 0
	origin = /area/syndicate_station/start
	interim = /area/syndicate_station/transit
	start_location = "Mercenary Base"
	destinations = list(
		"North of the station" = /area/syndicate_station/north,
		"Southwest of the station" = /area/syndicate_station/southwest,
		"Southeast of the station" = /area/syndicate_station/southeast,
		"Arrivals dock" = /area/syndicate_station/arrivals_dock,
		)
	docking_controller_tag = "merc_shuttle"
	destination_dock_targets = list(
		"Mercenary Base" = "merc_base",
		"Arrivals dock" = "nuke_shuttle_dock_airlock",
		)
	announcer = "NDV Icarus"

/datum/shuttle/multi_shuttle/mercenary/New()
	arrival_message = "Attention, [using_map.station_short], you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	departure_message = "Your visitors are on their way out of the system, [using_map.station_short], burning delta-v like it's nothing. Good riddance."
	..()

/datum/shuttle/ferry/centcom
	name = "Centcom"
	location = 1
	warmup_time = 10
	area_offsite = /area/shuttle/transport1/centcom
	area_station = /area/shuttle/transport1/station
	docking_controller_tag = "centcom_shuttle"
	dock_target_station = "centcom_shuttle_dock_airlock"
	dock_target_offsite = "centcom_shuttle_bay"

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

/datum/shuttle/multi_shuttle/rescue
	name = "Rescue"
	warmup_time = 0
	origin = /area/rescue_base/start
	interim = /area/rescue_base/transit
	start_location = "Response Team Base"
	destinations = list(
		"North of the station" = /area/rescue_base/north,
		"Southwest of the station" = /area/rescue_base/southwest,
		"Southeast of the station" = /area/rescue_base/southeast,
		"Arrivals dock" = /area/rescue_base/arrivals_dock,

		)
	docking_controller_tag = "rescue_shuttle"
	destination_dock_targets = list(
		"Response Team Base" = "rescue_base",
		"Arrivals dock" = "rescue_shuttle_dock_airlock",
		)
	announcer = "NDV Icarus"

/datum/shuttle/multi_shuttle/rescue/New()
	arrival_message = "Attention, [using_map.station_short], there's a small patrol craft headed your way, it flashed us Asset Protection codes and we let it pass. You've got guests on the way."
	departure_message = "[using_map.station_short], That Asset Protection vessel is headed back the way it came. Hope they were helpful."
	..()

/datum/shuttle/ferry/escape_pod/escape_pod_one
	name = "Escape Pod 1"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod1/station
	area_offsite = /area/shuttle/escape_pod1/centcom
	area_transition = /area/shuttle/escape_pod1/transit
	docking_controller_tag = "escape_pod_1"
	dock_target_station = "escape_pod_1_berth"
	dock_target_offsite = "escape_pod_1_recovery"
	transit_direction = NORTH

/datum/shuttle/ferry/escape_pod/escape_pod_two
	name = "Escape Pod 2"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod2/station
	area_offsite = /area/shuttle/escape_pod2/centcom
	area_transition = /area/shuttle/escape_pod2/transit
	docking_controller_tag = "escape_pod_2"
	dock_target_station = "escape_pod_2_berth"
	dock_target_offsite = "escape_pod_2_recovery"
	transit_direction = NORTH

/datum/shuttle/ferry/escape_pod/escape_pod_three
	name = "Escape Pod 3"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod3/station
	area_offsite = /area/shuttle/escape_pod3/centcom
	area_transition = /area/shuttle/escape_pod3/transit
	docking_controller_tag = "escape_pod_3"
	dock_target_station = "escape_pod_3_berth"
	dock_target_offsite = "escape_pod_3_recovery"
	transit_direction = EAST

/datum/shuttle/ferry/escape_pod/escape_pod_four
	name = "Escape Pod 4"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod5/station
	area_offsite = /area/shuttle/escape_pod5/centcom
	area_transition = /area/shuttle/escape_pod5/transit
	docking_controller_tag = "escape_pod_5"
	dock_target_station = "escape_pod_5_berth"
	dock_target_offsite = "escape_pod_5_recovery"
	transit_direction = EAST //should this be WEST? I have no idea.

/datum/shuttle/ferry/mining
	name = "Mining"
	warmup_time = 10
	area_offsite = /area/shuttle/mining/outpost
	area_station = /area/shuttle/mining/station
	docking_controller_tag = "mining_shuttle"
	dock_target_station = "mining_dock_airlock"
	dock_target_offsite = "mining_outpost_airlock"