// Lift master datum. One per turbolift.
/datum/turbolift
	var/datum/turbolift_floor/target_floor              // Where are we going?
	var/datum/turbolift_floor/current_floor             // Where is the lift currently?
	var/list/doors = list()                             // Doors inside the lift structure.
	var/list/queued_floors = list()                     // Where are we moving to next?
	var/list/floors = list()                            // All floors in this system.
	var/move_delay = 30                                 // Time between floor changes.
	var/floor_wait_delay = 85                           // Time to wait at floor stops.
	var/obj/structure/lift/panel/control_panel_interior // Lift control panel.

	var/tmp/moving_upwards
	var/tmp/busy

/datum/turbolift/proc/emergency_stop()
	queued_floors.Cut()
	target_floor = null
	open_doors()

/datum/turbolift/proc/doors_are_open(var/datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		if(!door.density)
			return 1
	return 0

/datum/turbolift/proc/open_doors(var/datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		door.command("open")
	return

/datum/turbolift/proc/close_doors(var/datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		door.command("close")
	return

/datum/turbolift/proc/do_move()

	var/current_floor_index = floors.Find(current_floor)

	if(!target_floor)
		if(!queued_floors || !queued_floors.len)
			return 0
		target_floor = queued_floors[1]
		queued_floors -= target_floor
		if(current_floor_index < floors.Find(target_floor))
			moving_upwards = 1
		else
			moving_upwards = 0

	if(doors_are_open())
		close_doors()
		return 1

	var/area/turbolift/origin = locate(current_floor.area_ref)

	if(target_floor == current_floor)

		playsound(control_panel_interior.loc, origin.arrival_sound, 50, 1)
		target_floor.arrived(src)
		target_floor = null

		sleep(15)
		control_panel_interior.visible_message("<b>The elevator</b> announces, \"[origin.lift_announce_str]\"")
		sleep(floor_wait_delay)

		return 1

	// Work out where we're headed.
	var/datum/turbolift_floor/next_floor
	if(moving_upwards)
		next_floor = floors[current_floor_index+1]
	else
		next_floor = floors[current_floor_index-1]

	var/area/turbolift/destination = locate(next_floor.area_ref)

	if(!istype(origin) || !istype(destination) || (origin == destination))
		return 0

	for(var/turf/T in destination)
		for(var/atom/movable/AM in T)
			if(istype(AM, /mob/living))
				var/mob/living/M = AM
				M.gib()
			else if(AM.simulated)
				qdel(AM)

	origin.move_contents_to(destination)

	if((locate(/obj/machinery/power) in destination) || (locate(/obj/structure/cable) in destination))
		makepowernets()

	current_floor = next_floor
	control_panel_interior.visible_message("The elevator [moving_upwards ? "rises" : "descends"] smoothly.")

	return 1

/datum/turbolift/proc/queue_move_to(var/datum/turbolift_floor/floor)
	if(!floor || !(floor in floors) || (floor in queued_floors))
		return // STOP PRESSING THE BUTTON.
	floor.pending_move(src)
	queued_floors |= floor
	turbolift_controller.lift_is_moving(src)

// TODO: dummy machine ('lift mechanism') in powered area for functionality/blackout checks.
/datum/turbolift/proc/is_functional()
	return 1