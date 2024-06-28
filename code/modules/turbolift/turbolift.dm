/datum/turbolift

	var/const/LIFT_MOVING = 1

	var/const/LIFT_WAITING_A = 2

	var/const/LIFT_WAITING_B = 3

	// One of the LIFT_* states above. Indicates what the lift is currently doing
	var/busy_state

	/// Where are we going?
	var/datum/turbolift_floor/target_floor

	/// Where is the lift currently?
	var/datum/turbolift_floor/current_floor

	/// Doors inside the lift structure
	var/list/doors = list()

	/// Where are we moving to next?
	var/list/queued_floors = list()

	/// All floors in this system
	var/list/floors = list()

	/// Time between floor changes
	var/move_delay = 3 SECONDS

	/// Time to wait at floor stops
	var/floor_wait_delay = 9 SECONDS

	/// Lift control panel
	var/obj/structure/lift/panel/control_panel_interior

	/// Whether doors are in the process of closing
	var/doors_closing = FALSE

	/// ...
	var/moving_upwards

	/// ...
	var/next_process


/datum/turbolift/Process()
	if (world.time < next_process)
		return
	switch (busy_state)
		if (LIFT_MOVING)
			if (!do_move())
				queued_floors.Cut()
				return PROCESS_KILL
			if (!next_process)
				next_process = world.time + move_delay
		if (LIFT_WAITING_A)
			var/area/turbolift/origin = locate(current_floor.area_ref)
			control_panel_interior.visible_message("<b>The elevator</b> announces, \"[origin.lift_announce_str]\"")
			next_process = world.time + floor_wait_delay
			busy_state = LIFT_WAITING_B
		if (LIFT_WAITING_B)
			if (!length(queued_floors))
				busy_state = null
				return PROCESS_KILL
			busy_state = LIFT_MOVING


/datum/turbolift/proc/emergency_stop()
	queued_floors.Cut()
	target_floor = null
	open_doors()


/datum/turbolift/proc/doors_are_open(datum/turbolift_floor/use_floor = current_floor)
	for (var/obj/machinery/door/airlock/door in doors + use_floor?.doors)
		if (!door.density)
			return TRUE
	return FALSE


/datum/turbolift/proc/open_doors(datum/turbolift_floor/use_floor = current_floor)
	for (var/obj/machinery/door/airlock/door in doors + use_floor?.doors)
		door.command("open")


/datum/turbolift/proc/close_doors(datum/turbolift_floor/use_floor = current_floor)
	for (var/obj/machinery/door/airlock/door in doors + use_floor?.doors)
		door.command("close")


/datum/turbolift/proc/do_move()
	next_process = null
	var/current_floor_index = floors.Find(current_floor)
	if (!target_floor)
		if (!queued_floors || !length(queued_floors))
			return FALSE
		target_floor = queued_floors[1]
		queued_floors -= target_floor
		moving_upwards = current_floor_index < floors.Find(target_floor)
	if (doors_are_open())
		if (!doors_closing)
			close_doors()
			doors_closing = TRUE
			return TRUE
		doors_closing = FALSE
		open_doors()
		control_panel_interior.audible_message("\The [current_floor.ext_panel] buzzes loudly.")
		playsound(control_panel_interior, "sound/machines/buzz-two.ogg", 50, TRUE)
		return FALSE
	doors_closing = FALSE
	var/area/turbolift/origin = locate(current_floor.area_ref)
	if (target_floor == current_floor)
		playsound(control_panel_interior, origin.arrival_sound, 50, TRUE)
		target_floor.arrived(src)
		target_floor = null
		next_process = world.time + 2 SECONDS
		busy_state = LIFT_WAITING_A
		return TRUE
	var/datum/turbolift_floor/next_floor
	if (moving_upwards)
		next_floor = floors[current_floor_index + 1]
	else
		next_floor = floors[current_floor_index - 1]
	var/area/turbolift/destination = locate(next_floor.area_ref)
	if (!istype(origin) || !istype(destination) || (origin == destination))
		return FALSE
	if (!moving_upwards)
		for (var/turf/turf in destination)
			for (var/atom/movable/movable in turf)
				if (istype(movable, /mob/living))
					var/mob/living/living = movable
					living.gib()
				else if (movable.simulated)
					qdel(movable)
	origin.move_contents_to(destination)
	if ((locate(/obj/machinery/power) in destination) || (locate(/obj/structure/cable) in destination))
		SSmachines.makepowernets()
	current_floor = next_floor
	control_panel_interior.visible_message("The elevator [moving_upwards ? "rises" : "descends"] smoothly.")
	return TRUE


/datum/turbolift/proc/queue_move_to(datum/turbolift_floor/floor)
	if (!floor || !(floor in floors) || (floor in queued_floors))
		return
	floor.pending_move(src)
	queued_floors |= floor
	busy_state = LIFT_MOVING
	START_PROCESSING(SSprocessing, src)


/datum/turbolift/proc/is_functional()
	return TRUE
