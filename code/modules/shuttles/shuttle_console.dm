/obj/machinery/computer/shuttle_control
	name = "shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"

	//for mapping
	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/docking_controller_tag	//tag of the controller used to coordinate docking
	
	var/datum/computer/file/embedded_program/docking/docking_controller	//the controller itself
	var/hacked = 0   // Has been emagged, no access restrictions.
	var/waiting = 0

/obj/machinery/computer/shuttle_control/initialize()
	//search for our controller, if we have one.
	if (docking_controller_tag)
		for (var/obj/machinery/embedded_controller/radio/C in machines)	//only radio controllers are supported, for now...
			if (C.id_tag == docking_controller_tag && istype(C.program, /datum/computer/file/embedded_program/docking))
				docking_controller = C.program

/obj/machinery/computer/shuttle_control/attack_hand(user as mob)

	if(..(user))
		return
	src.add_fingerprint(user)
	var/dat

	dat = "<center>[shuttle_tag] Shuttle Control<hr>"

	if(waiting || shuttles.moving[shuttle_tag])
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [shuttles.locations[shuttle_tag] ? "Offsite" : "Station"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=[shuttle_tag]shuttlecontrol;size=200x150")

/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["move"])
		if (!shuttles.moving[shuttle_tag])
			usr << "\blue [shuttle_tag] Shuttle recieved message and will be sent shortly."
			shuttles.move_shuttle(shuttle_tag)
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
	
	for (var/obj/machinery/computer/shuttle_control/S in machines)
		var/location = shuttles.locations[S.shuttle_tag]
		var/dock_target = shuttles.docking_targets[S.shuttle_tag][location+1]	//damned byond is 1-indexed - don't forget
		
		if (!(S.shuttle_tag in setup_complete) && S.docking_controller && dock_target)
			S.docking_controller.initiate_docking(dock_target)
			setup_complete += S.shuttle_tag