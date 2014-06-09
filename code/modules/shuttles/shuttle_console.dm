#define IDLE_STATE		0
#define WAIT_LAUNCH		1
#define WAIT_ARRIVE		2
#define WAIT_FINISH		3


/*
	I dont really like how much this manipulates shuttle it's docking controller, as it makes this code
	depend a lot on their current implementation, and also having var/datum/shuttle/shuttle = shuttles[shuttle_tag] 
	everywhere is kind of messy. I'm probably going to end up creating a subtype of shuttle called ferry_shuttle 
	and move a lot of this into there when I get the time.
*/
/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"
	
	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.
	
	var/process_state = IDLE_STATE

/obj/machinery/computer/shuttle_control/proc/launch_shuttle()
	if (!can_launch()) return
	
	var/datum/shuttle/shuttle = shuttles[shuttle_tag]
	
	shuttle.in_use = 1	//obtain an exclusive lock on the shuttle
	
	process_state = WAIT_LAUNCH
	shuttle.undock()

/obj/machinery/computer/shuttle_control/proc/cancel_launch()
	if (!can_cancel()) return

	var/datum/shuttle/shuttle = shuttles[shuttle_tag]
	
	shuttle.moving_status = SHUTTLE_IDLE
	process_state = WAIT_FINISH
	
	if (shuttle.docking_controller && !shuttle.docking_controller.undocked())
		shuttle.docking_controller.force_undock()
	shuttle.dock()
	
	shuttle.in_use = 0
	
	return

/obj/machinery/computer/shuttle_control/proc/toggle_override()
	if (!can_override()) return

	var/datum/shuttle/shuttle = shuttles[shuttle_tag]
	
	if (shuttle.docking_controller.override_enabled)
		shuttle.docking_controller.disable_override()
	else
		shuttle.docking_controller.enable_override()

/obj/machinery/computer/shuttle_control/proc/can_launch()
	var/datum/shuttle/shuttle = shuttles[shuttle_tag]
	
	if (shuttle.moving_status != SHUTTLE_IDLE)
		return 0
	
	if (shuttle.in_use && !skip_checks())
		return 0
	
	return 1

/obj/machinery/computer/shuttle_control/proc/can_cancel()
	var/datum/shuttle/shuttle = shuttles[shuttle_tag]
	
	if (shuttle.moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH)
		return 1
	return 0

/obj/machinery/computer/shuttle_control/proc/can_override()
	var/datum/shuttle/shuttle = shuttles[shuttle_tag]
	
	if (shuttle.docking_controller && (!shuttle.docking_controller.override_enabled || !shuttle.in_use))
		return 1
	return 0

//TODO move this stuff into the shuttle datum itself, instead of manipulating the shuttle's members
/obj/machinery/computer/shuttle_control/process()
	if (!shuttles || !(shuttle_tag in shuttles))
		return

	var/datum/shuttle/shuttle = shuttles[shuttle_tag]

	switch(process_state)
		if (WAIT_LAUNCH)
			if (skip_checks() || shuttle.docking_controller.can_launch())
				shuttle.short_jump()
				if (shuttle.docking_controller && !shuttle.docking_controller.undocked())
					shuttle.docking_controller.force_undock()
				process_state = WAIT_ARRIVE
		if (WAIT_ARRIVE)
			if (shuttle.moving_status == SHUTTLE_IDLE)
				shuttle.dock()
				process_state = WAIT_FINISH
		if (WAIT_FINISH)
			if (skip_checks() || shuttle.docking_controller.docked())
				process_state = IDLE_STATE
				shuttle.in_use = 0	//release lock

/obj/machinery/computer/shuttle_control/proc/skip_checks()
	var/datum/shuttle/shuttle = shuttles[shuttle_tag]

	if (!shuttle.docking_controller || !shuttle.current_dock_target())
		return 1	//shuttles without docking controllers or at locations without docking ports act like old-style shuttles

	return shuttle.docking_controller.override_enabled	//override pretty much lets you do whatever you want


/obj/machinery/computer/shuttle_control/Del()
	var/datum/shuttle/shuttle = shuttles[shuttle_tag]
	
	if (process_state != IDLE_STATE)
		shuttle.in_use = 0	//shuttle may not dock properly if this gets deleted while in transit, but its not a big deal

/obj/machinery/computer/shuttle_control/attack_hand(user as mob)
	if(..(user))
		return
	//src.add_fingerprint(user)	//shouldn't need fingerprints just for looking at it.

	ui_interact(user)

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/data[0]
	var/datum/shuttle/shuttle = shuttles[shuttle_tag]

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	var/shuttle_status
	switch (process_state)
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
		"override_enabled" = shuttle.docking_controller? shuttle.docking_controller.override_enabled : null,
		"can_launch" = can_launch(),
		"can_cancel" = can_cancel(),
		"can_override" = can_override(),
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

	
	if(href_list["move"])
		launch_shuttle()
	else if(href_list["cancel"])
		cancel_launch()
	else if(href_list["override"])
		toggle_override()


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

