//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	var/datum/shuttle/ferry/pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/data[0]

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory["door_status"]["state"],
		"door_lock" = 	docking_program.memory["door_status"]["lock"],
		"can_force" = pod.can_force(),
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)

	if (!ui)
		ui = new(user, src, ui_key, "simple_docking_console_pod.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/Topic(href, href_list)
	if(..())
		return
	
	usr.set_machine(src)
	src.add_fingerprint(usr)
	
	var/clean = 0
	switch(href_list["command"])	//anti-HTML-hacking checks
		if("force_door")
			clean = 1
		if("toggle_override")
			clean = 1
		if("force_launch")
			pod.force_launch(src)
	
	if(clean)
		program.receive_user_command(href_list["command"])

	return 1


//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/initialize()
	..()
	docking_program = new/datum/computer/file/embedded_program/docking/simple/escape_pod(src)
	program = docking_program

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/data[0]

	var/armed = null
	if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
		armed = P.armed
	
	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/emag) && !emagged)
		user << "\blue You emag the [src], arming the escape pod!"
		emagged = 1
		
		if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
			var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
			P.arm()
		return



//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	var/armed = 0
	var/eject_delay = 10	//give latecomers some time to get out of the way if they don't make it onto the pod
	var/eject_time = null
	var/closing = 0

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/arm()
	armed = 1
	open_door()


/datum/computer/file/embedded_program/docking/simple/escape_pod/receive_user_command(command)
	if (!armed)
		return
	..(command)

/datum/computer/file/embedded_program/docking/simple/escape_pod/process()
	..()
	if (eject_time && world.time >= eject_time && !closing)
		close_door()
		closing = 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_docking()
	return

/datum/computer/file/embedded_program/docking/simple/escape_pod/ready_for_docking()
	return 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/finish_docking()
	return		//don't do anything - the doors only open when the pod is armed.

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_undocking()
	eject_time = world.time + eject_delay*10

/*
/datum/computer/file/embedded_program/docking/simple/escape_pod/ready_for_undocking()
	if (world.time < eject_time)
		return 0
	return ..()
*/