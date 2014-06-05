//a docking port based on an airlock
/obj/machinery/embedded_controller/radio/airlock/airlock_controller/docking_port
	name = "docking port controller"
	var/datum/computer/file/embedded_program/airlock/docking/airlock_prog
	var/datum/computer/file/embedded_program/docking/airlock/docking_prog

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/docking_port/initialize()
	airlock_prog = new/datum/computer/file/embedded_program/airlock/docking(src)

	airlock_prog.tag_exterior_door = tag_exterior_door
	airlock_prog.tag_interior_door = tag_interior_door
	airlock_prog.tag_airpump = tag_airpump
	airlock_prog.tag_chamber_sensor = tag_chamber_sensor
	airlock_prog.tag_exterior_sensor = tag_exterior_sensor
	airlock_prog.tag_interior_sensor = tag_interior_sensor
	airlock_prog.memory["secure"] = 1
	
	docking_prog = new/datum/computer/file/embedded_program/docking/airlock/(src, airlock_prog)
	program = docking_prog
	
	spawn(10)
		airlock_prog.signalDoor(tag_exterior_door, "update")		//signals connected doors to update their status
		airlock_prog.signalDoor(tag_interior_door, "update")

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/docking_port/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/data[0]

	data = list(
		"chamber_pressure" = round(airlock_prog.memory["chamber_sensor_pressure"]),
		"exterior_status" = airlock_prog.memory["exterior_status"],
		"interior_status" = airlock_prog.memory["interior_status"],
		"processing" = airlock_prog.memory["processing"],
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)

	if (!ui)
		ui = new(user, src, ui_key, "simple_airlock_console.tmpl", name, 470, 290)

		ui.set_initial_data(data)

		ui.open()

		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/docking_port/Topic(href, href_list)
	var/clean = 0
	switch(href_list["command"])	//anti-HTML-hacking checks
		if("cycle_ext")
			clean = 1
		if("cycle_int")
			clean = 1
		if("force_ext")
			clean = 1
		if("force_int")
			clean = 1
		if("abort")
			clean = 1

	if(clean)
		program.receive_user_command(href_list["command"])

	return 1



//A docking controller for an airlock based docking port
/datum/computer/file/embedded_program/docking/airlock
	var/datum/computer/file/embedded_program/airlock/docking/airlock_prog

/datum/computer/file/embedded_program/docking/airlock/New(var/obj/machinery/embedded_controller/M, var/datum/computer/file/embedded_program/airlock/docking/A)
	..(M)
	airlock_prog = A
	airlock_prog.master_prog = src

/datum/computer/file/embedded_program/docking/airlock/receive_user_command(command)
	..(command)
	airlock_prog.receive_user_command(command)	//pass along to subprograms

/datum/computer/file/embedded_program/docking/airlock/process()
	airlock_prog.process()
	..()

/datum/computer/file/embedded_program/docking/airlock/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]		//for docking signals, this is the sender id
	var/command = signal.data["command"]
	var/recipient = signal.data["recipient"]	//the intended recipient of the docking signal
	
	if (recipient == id_tag && command == "enable_override" && receive_tag == tag_target)
		
	
	..(signal, receive_method, receive_param)
	airlock_prog.receive_signal(signal, receive_method, receive_param)	//pass along to subprograms

//tell the docking port to start getting ready for docking - e.g. pressurize
/datum/computer/file/embedded_program/docking/airlock/prepare_for_docking()
	airlock_prog.begin_cycle_in()

//are we ready for docking?
/datum/computer/file/embedded_program/docking/airlock/ready_for_docking()
	return airlock_prog.done_cycling()

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_program/docking/airlock/finish_docking()
	airlock_prog.open_doors()

//tell the docking port to start getting ready for undocking - e.g. close those doors.
/datum/computer/file/embedded_program/docking/airlock/prepare_for_undocking()
	airlock_prog.stop_cycling()
	airlock_prog.close_doors()

//are we ready for undocking?
/datum/computer/file/embedded_program/docking/airlock/ready_for_undocking()
	return airlock_prog.check_doors_secured()

/datum/computer/file/embedded_program/docking/airlock/reset()
	airlock_prog.stop_cycling()
	airlock_prog.close_doors()
	..()

//An airlock controller to be used by the airlock-based docking port controller.
//Same as a regular airlock controller but allows disabling of the regular airlock functions when docking
/datum/computer/file/embedded_program/airlock/docking
	
	var/datum/computer/file/embedded_program/docking/airlock/master_prog

/datum/computer/file/embedded_program/airlock/docking/receive_user_command(command)
	if (master_prog.undocked() || master_prog.override_enabled)	//only allow the port to be used as an airlock if nothing is docked here or the override is enabled
		..(command)

/datum/computer/file/embedded_program/airlock/docking/proc/open_doors()
	toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "open")
	toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "open")

/datum/computer/file/embedded_program/airlock/docking/cycleDoors(var/target)
	if (master_prog.undocked() || master_prog.override_enabled)	//only allow the port to be used as an airlock if nothing is docked here or the override is enabled
		..(target)