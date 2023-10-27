
/* LARGE PODS
 * ==========
 */
/area/shuttle/transport1/centcom
	name = "Shuttle - Cargo"
	icon_state = "shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

/area/shuttle/escape_pod
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	icon_state = "exit"

/area/shuttle/escape_pod/escape_pod1/station
	name = "Shuttle - Escape - Pod One"

/area/shuttle/escape_pod/escape_pod2/station
	name = "Shuttle - Escape - Pod Two"

/area/shuttle/escape_pod/escape_pod3/station
	name = "Shuttle - Escape - Pod Three"

/area/shuttle/escape_pod/escape_pod4/station
	name = "Shuttle - Escape - Pod Four"

/area/shuttle/escape_pod/escape_pod5/station
	name = "Shuttle - Escape - Pod Five"

/* SMALL PODS
 * ==========
 */

/area/shuttle/escape_pod/escape_pod6/station
	name = "Shuttle - Escape - Small Pod Six"

/area/shuttle/escape_pod/escape_pod7/station
	name = "Shuttle - Escape - Small Pod Seven"

/area/shuttle/escape_pod/escape_pod8/station
	name = "Shuttle - Escape - Small Pod Eight"

/area/shuttle/escape_pod/escape_pod9/station
	name = "Shuttle - Escape - Small Pod Nine"

/area/shuttle/escape_pod/escape_pod10/station
	name = "Shuttle - Escape - Small Pod Nine"

/area/shuttle/escape_pod/escape_pod11/station
	name = "Shuttle - Escape - Small Pod Nine"

/* VESSEL'S SHUTTLES
 * =================
 */
/area/exploration_shuttle
	name = "Shuttle - Charon"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/exploration_shuttle/cockpit
	name = "Shuttle - Charon - Cockpit"
/area/exploration_shuttle/power
	name = "Shuttle - Charon - Power Compartment"
/area/exploration_shuttle/seats_place
	name = "Shuttle - Charon - Seats Place Compartment"
/area/exploration_shuttle/medical
	name = "Shuttle - Charon - Medical Compartment"
/area/exploration_shuttle/cargo_l
	name = "Shuttle - Charon - Cargo Bay Left"
/area/exploration_shuttle/cargo_r
	name = "Shuttle - Charon - Cargo Bay Right"
/area/exploration_shuttle/airlock
	name = "Shuttle - Charon - Airlock Compartment"

/area/guppy_hangar/start
	name = "Shuttle - Guppy"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_guppy)

/area/crucian_hangar/start
	name = "Shuttle - Сrucian"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_guppy)

/area/shuttle/petrov
	name = "Shuttle - Petrov"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_petrov)

/area/shuttle/petrov/ship
	icon_state = "shuttlered"
/area/shuttle/petrov/cockpit
	name = "Shuttle - Petrov - Cockpit"
	icon_state = "shuttlered"
/area/shuttle/petrov/test_room
	name = "Shuttle - Petrov - Test Room"
	icon_state = "shuttlered"
/area/shuttle/petrov/gas
	name = "Shuttle - Petrov - Gas"
	icon_state = "shuttlered"
/area/shuttle/petrov/airlock
	name = "Shuttle - Petrov - Airlock"
	icon_state = "shuttlered"
/area/shuttle/petrov/equipment
	name = "Shuttle - Petrov - Equipment"
	icon_state = "shuttlered"
/area/shuttle/petrov/eva
	name = "Shuttle - Petrov - Storage"
	icon_state = "shuttlered"
/area/shuttle/petrov/security
	name = "Shuttle - Petrov - Security Room"
	icon_state = "shuttlered"
/area/shuttle/petrov/scan
	name = "Shuttle - Petrov - Scan Room"
	icon_state = "shuttlered"
/area/shuttle/petrov/cell1
	name = "Shuttle - Petrov - Isolation Cell 1"
	icon_state = "shuttle"
/area/shuttle/petrov/cell2
	name = "Shuttle - Petrov - Isolation Cell 2"
	icon_state = "shuttlegrn"
/area/shuttle/petrov/cell3
	name = "Shuttle - Petrov - Isolation Cell 3"
	icon_state = "shuttle"

/* ELEVATORS
 * =========
 */

/obj/machinery/computer/shuttle_control/lift/rndmaint
	name = "RND maintenance lift controls"
	shuttle_tag = "RND Maintenance Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = FALSE

/obj/machinery/computer/shuttle_control/lift/medical
	name = "medical lift controls"
	shuttle_tag = "Medical Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = FALSE

/datum/shuttle/autodock/ferry/rndmaint_lift
	name = "RND Maintenance Lift"
	shuttle_area = /area/turbolift/rndmaint_lift
	warmup_time = 3
	waypoint_station = "nav_rndmaint_lift_top"
	waypoint_offsite = "nav_rndmaint_lift_bottom"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0

/datum/shuttle/autodock/ferry/medical_lift
	name = "Medical Lift"
	shuttle_area = /area/turbolift/medical_lift
	warmup_time = 3
	waypoint_station = "nav_medical_lift_top"
	waypoint_offsite = "nav_medical_lift_bottom"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0

/obj/shuttle_landmark/lift/rndmaint_top
	name = "First Deck - RND Maintenance"
	landmark_tag = "nav_rndmaint_lift_top"
	base_area = /area/maintenance/firstdeck/aftport
	base_turf = /turf/simulated/open

/obj/shuttle_landmark/lift/rndmaint_bottom
	name = "Second Deck - RND Toxins Lab"
	landmark_tag = "nav_rndmaint_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/maintenance/seconddeck/port
	base_turf = /turf/simulated/floor/plating

/obj/shuttle_landmark/lift/medical_top
	name = "First Deck - Autopsy"
	landmark_tag = "nav_medical_lift_top"
	base_area = /area/medical/morgue/autopsy
	base_turf = /turf/simulated/open

/obj/shuttle_landmark/lift/medical_bottom
	name = "Second Deck - Morgue"
	landmark_tag = "nav_medical_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/medical/morgue
	base_turf = /turf/simulated/floor/plating

//Base Area
/area/turbolift/rndmaint_lift
	name = "Research - Maintenance Lift"
	icon_state = "shuttle3"
	base_turf = /turf/simulated/open

/area/turbolift/medical_lift
	name = "Medical - Morgue Lift"
	icon_state = "shuttle3"
	base_turf = /turf/simulated/open
	lighting_tone = AREA_LIGHTING_COOL

/* TURBOLIFT
 * =========
 */
/area/turbolift
	icon_state = "shuttle"
	dynamic_lighting = 1
	area_flags = AREA_FLAG_ION_SHIELDED
	req_access = list(access_maint_tunnels)

/area/turbolift/sierra_top
	name = "Elevator - Bridge"
	lift_floor_label = "Мостик"
	lift_floor_name = "Командование судна"
	lift_announce_str = "Мостик - Командование судна."

/area/turbolift/sierra_d1
	name = "Elevator - First Deck"
	lift_floor_label = "1 Палуба"
	lift_floor_name = "Оперативная палуба"
	lift_announce_str = "Палуба 1 - Оперативная."

/area/turbolift/sierra_d2
	name = "Elevator - Second Deck"
	lift_floor_label = "2 Палуба"
	lift_floor_name = "Жилая палуба"
	lift_announce_str = "Палуба 2 - Жилая."

/area/turbolift/sierra_d3
	name = "Elevator - Third Deck"
	lift_floor_label = "3 Палуба"
	lift_floor_name = "Инженерная палуба"
	lift_announce_str = "Палуба 3 - Инженерная."

/area/turbolift/sierra_ground
	name = "Elevator - Third Deck"
	lift_floor_label = "3 Палуба"
	lift_floor_name = "Лётная палуба"
	lift_announce_str = "Палуба 4 - Лётная."
	base_turf = /turf/simulated/floor

/area/turbolift/start
	name = "Elevator - Start"

/area/turbolift/bridgedeck
	name = "bridge"
	base_turf = /turf/simulated/open

/area/turbolift/firstdeck
	name = "first deck"
	base_turf = /turf/simulated/open

/area/turbolift/seconddeck
	name = "second deck"
	base_turf = /turf/simulated/open

/area/turbolift/thirddeck
	name = "third deck"
	base_turf = /turf/simulated/open

/area/turbolift/fourthdeck
	name = "fourth deck"
	base_turf = /turf/simulated/open
