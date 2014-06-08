#define STATUS_IDLE
#define STATUS_LAUNCH
#define STATUS_ARRIVE

/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"

	//for mapping
	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/datum/shuttle/shuttle
	var/docking_controller_tag	//tag of the controller used to coordinate docking
	
	var/datum/computer/file/embedded_program/docking/docking_controller	//the controller itself
	var/hacked = 0   // Has been emagged, no access restrictions.

/obj/machinery/computer/shuttle_control/initialize()
	shuttle = shuttles[shuttle_tag]
	
	//search for our controller, if we have one.
	if (docking_controller_tag)
		for (var/obj/machinery/embedded_controller/radio/C in machines)	//only radio controllers are supported, for now...
			if (C.id_tag == docking_controller_tag && istype(C.program, /datum/computer/file/embedded_program/docking))
				docking_controller = C.program
	

/obj/machinery/computer/shuttle_control/process()
	/*
	switch (launch_status)

	if (wait_for_launch)
		if (docking_controller && docking_controller.can_launch())
			shuttles.jump_shuttle(shuttle_tag)
			wait_for_launch = 0
	*/


/obj/machinery/computer/shuttle_control/attack_hand(user as mob)
	if(..(user))
		return
	//src.add_fingerprint(user)	//shouldn't need fingerprints just for looking at it.

	ui_interact(user)


/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/data[0]

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	if (docking_controller)
		data = list(
			"shuttle_state" = shuttle_state,
			"shuttle_loc" = shuttle.location,
			"has_docking" = 1,
			"docking_status" = docking_controller.get_docking_status(),
			"override_enabled" = docking_controller.override_enabled,
		)
	else
		data = list(
			"shuttle_state" = shuttle_state,
			"shuttle_loc" = shuttle.location,
			"has_docking" = 0,
			"docking_status" = null,
			"override_enabled" = null,
		)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)

	if (!ui)
		ui = new(user, src, ui_key, "shuttle_control_console.tmpl", "[shuttle_tag] Shuttle Control", 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//TODO: Canceling launches
/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["move"])
		if (shuttle.moving_status == SHUTTLE_IDLE)
			usr << "\blue [shuttle_tag] Shuttle recieved message and will be sent shortly."
			shuttle.short_jump()
		else
			usr << "\blue [shuttle_tag] Shuttle is already moving."


/obj/machinery/computer/shuttle_control/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You short out the console's ID checking system. It's now available to everyone!"
	else
		..()

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("[Proj] ricochets off [src]!")

//makes all shuttles docked to something at round start go into the docked state
/proc/setup_shuttle_docks()
	var/list/setup_complete = list()	//so we dont setup the same shuttle repeatedly
	
	for (var/obj/machinery/computer/shuttle_control/SC in machines)
		var/dock_target = SC.shuttle.docking_targets[SC.shuttle.location+1]	//damned byond is 1-indexed - don't forget
		
		if (!(SC.shuttle_tag in setup_complete) && SC.docking_controller && dock_target)
			SC.docking_controller.initiate_docking(dock_target)
			setup_complete += SC.shuttle_tag