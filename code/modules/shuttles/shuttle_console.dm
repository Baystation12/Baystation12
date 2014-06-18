#define IDLE_STATE		0
#define WAIT_LAUNCH		1
#define WAIT_ARRIVE		2
#define WAIT_FINISH		3


/datum/shuttle/ferry
	var/location = 0	//0 = at area_station, 1 = at area_offsite
	var/process_state = IDLE_STATE
	
	//this mutex ensures that only one console is processing the shuttle's controls at a time
	var/obj/machinery/computer/shuttle_control/in_use = null
	
	var/area_station
	var/area_offsite
	//TODO: change location to a string and use a mapping for area and dock targets.
	var/dock_target_station
	var/dock_target_offsite

/datum/shuttle/ferry/short_jump(var/area/origin,var/area/destination)
	if(isnull(location))
		return

	if(!destination)
		destination = get_location_area(!location)
	if(!origin)
		origin = get_location_area(location)
	
	..(origin, destination)

/datum/shuttle/ferry/long_jump(var/area/departing,var/area/destination,var/area/interim,var/travel_time)
	if(isnull(location))
		return

	if(!destination)
		destination = get_location_area(!location)
	if(!departing)
		departing = get_location_area(location)
	
	..(departing, destination, interim, travel_time)

/datum/shuttle/ferry/move(var/area/origin,var/area/destination)
	if(!destination)
		destination = get_location_area(!location)
	if(!origin)
		origin = get_location_area(location)
	
	if (docking_controller && !docking_controller.undocked())
		docking_controller.force_undock()
	..(origin, destination)
	location = !location

/datum/shuttle/ferry/proc/get_location_area(location_id = null)
	if (isnull(location_id))
		location_id = location
	
	if (!location_id)
		return area_station
	return area_offsite

/datum/shuttle/ferry/proc/process_shuttle()
	switch(process_state)
		if (WAIT_LAUNCH)
			if (skip_docking_checks() || docking_controller.can_launch())
				
				//once you have a transition area, making ferry shuttles have a transition would merely requre replacing this with
				//if (transition_area) long_jump(...)
				//else short_jump ()
				short_jump()
				
				process_state = WAIT_ARRIVE
		if (WAIT_ARRIVE)
			if (moving_status == SHUTTLE_IDLE)
				dock()
				process_state = WAIT_FINISH
		if (WAIT_FINISH)
			if (skip_docking_checks() || docking_controller.docked())
				process_state = IDLE_STATE
				in_use = null	//release lock

/datum/shuttle/ferry/current_dock_target()
	var/dock_target
	if (!location)	//station
		dock_target = dock_target_station
	else
		dock_target = dock_target_offsite
	return dock_target


/datum/shuttle/ferry/proc/launch(var/obj/machinery/computer/shuttle_control/user)
	if (!can_launch()) return
	
	in_use = user	//obtain an exclusive lock on the shuttle
	
	process_state = WAIT_LAUNCH
	undock()

/datum/shuttle/ferry/proc/force_launch(var/obj/machinery/computer/shuttle_control/user)
	if (!can_force()) return
	
	in_use = user	//obtain an exclusive lock on the shuttle
	
	short_jump()
	
	process_state = WAIT_ARRIVE

/datum/shuttle/ferry/proc/cancel_launch(var/obj/machinery/computer/shuttle_control/user)
	if (!can_cancel()) return
	
	moving_status = SHUTTLE_IDLE
	process_state = WAIT_FINISH
	
	if (docking_controller && !docking_controller.undocked())
		docking_controller.force_undock()
	
	spawn(10)
		dock()
	
	return

/datum/shuttle/ferry/proc/can_launch()
	if (moving_status != SHUTTLE_IDLE)
		return 0
	
	if (in_use)
		return 0
	
	return 1

/datum/shuttle/ferry/proc/can_force()
	if (moving_status == SHUTTLE_IDLE && process_state == WAIT_LAUNCH)
		return 1
	return 0

/datum/shuttle/ferry/proc/can_cancel()
	if (moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH)
		return 1
	return 0



/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = null
	
	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.
	var/launch_override = 0



//TODO move this stuff into the shuttle datum itself, instead of manipulating the shuttle's members
/obj/machinery/computer/shuttle_control/process()
	if (!shuttles || !(shuttle_tag in shuttles))
		return
	
	var/datum/shuttle/ferry/shuttle = shuttles[shuttle_tag]
	if (!istype(shuttle))
		return
	
	if (shuttle.in_use == src)
		shuttle.process_shuttle()

/obj/machinery/computer/shuttle_control/Del()
	var/datum/shuttle/ferry/shuttle = shuttles[shuttle_tag]
	if (!istype(shuttle))
		return
	
	if (shuttle.in_use == src)
		shuttle.in_use = null	//shuttle may not dock properly if this gets deleted while in transit, but its not a big deal

/obj/machinery/computer/shuttle_control/attack_hand(user as mob)
	if(..(user))
		return
	//src.add_fingerprint(user)	//shouldn't need fingerprints just for looking at it.

	ui_interact(user)

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/data[0]
	var/datum/shuttle/ferry/shuttle = shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else if (!shuttle.location)
				shuttle_status = "Standing-by at station."
			else
				shuttle_status = "Standing-by at offsite location."
		if(WAIT_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."
	
	data = list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.docking_controller? 1 : 0,
		"docking_status" = shuttle.docking_controller? shuttle.docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.docking_controller? shuttle.docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)

	if (!ui)
		ui = new(user, src, ui_key, "shuttle_control_console.tmpl", "[shuttle_tag] Shuttle Control", 470, 310)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//TODO: Canceling launches, dock overrides using the console, forcing dock/undock
/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/datum/shuttle/ferry/shuttle = shuttles[shuttle_tag]
	if (!istype(shuttle))
		return
	
	if(href_list["move"])
		shuttle.launch(src)
	if(href_list["force"])
		shuttle.force_launch(src)
	else if(href_list["cancel"])
		shuttle.cancel_launch()


/obj/machinery/computer/shuttle_control/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You short out the console's ID checking system. It's now available to everyone!"
	else
		..()

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("[Proj] ricochets off [src]!")

#undef IDLE_STATE
#undef WAIT_LAUNCH
#undef WAIT_ARRIVE
#undef WAIT_FINISH

