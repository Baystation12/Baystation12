// Simple holder for each floor in the lift.
/datum/turbolift_floor
	var/area_ref
	var/label
	var/name
	var/announce_str
	var/arrival_sound

	var/list/doors = list()
	var/obj/structure/lift/button/ext_panel

/datum/turbolift_floor/proc/set_area_ref(var/ref)
	var/area/shuttle/turbolift/A = locate(ref)
	if(!istype(A))
		log_debug("Turbolift floor area was of the wrong type: ref=[ref]")
		return

	area_ref = ref
	label = A.lift_floor_label
	name = A.lift_floor_name ? A.lift_floor_name : A.name
	announce_str = A.lift_announce_str
	arrival_sound = A.arrival_sound

