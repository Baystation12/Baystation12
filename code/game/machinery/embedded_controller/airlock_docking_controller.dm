//a docking port based on an airlock
/obj/machinery/embedded_controller/radio/airlock/docking_port
	name = "docking port controller"
	program = /datum/computer/file/embedded_program/docking/airlock
	var/display_name			//how would it show up on docking monitoring program, area name + coordinates if unset
	tag_secure = 1

/obj/machinery/embedded_controller/radio/airlock/docking_port/Initialize()
	. = ..()
	if(display_name)
		var/datum/computer/file/embedded_program/docking/airlock/docking_program = program
		docking_program.display_name = display_name

/obj/machinery/embedded_controller/radio/airlock/docking_port/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/device/multitool)) //give them part of code, would take few tries to get full
		var/datum/computer/file/embedded_program/docking/airlock/docking_program = program
		var/code = docking_program.docking_codes
		if(!code)
			code = "N/A"
		else
			code = stars(code)
		to_chat(user,"[W]'s screen displays '[code]'")
	else
		..()

/obj/machinery/embedded_controller/radio/airlock/docking_port/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]
	var/datum/computer/file/embedded_program/docking/airlock/docking_program = program
	var/datum/computer/file/embedded_program/airlock/docking/airlock_program = docking_program.airlock_program

	data = list(
		"chamber_pressure" = round(airlock_program.memory["chamber_sensor_pressure"]),
		"exterior_status" = airlock_program.memory["exterior_status"],
		"interior_status" = airlock_program.memory["interior_status"],
		"processing" = airlock_program.memory["processing"],
		"docking_status" = docking_program.get_docking_status(),
		"airlock_disabled" = !(docking_program.undocked() || docking_program.override_enabled),
		"override_enabled" = docking_program.override_enabled,
		"docking_codes" = docking_program.docking_codes,
		"name" = docking_program.get_name()
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "docking_airlock_console.tmpl", name, 470, 290, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//A docking controller for an airlock based docking port
/datum/computer/file/embedded_program/docking/airlock
	var/datum/computer/file/embedded_program/airlock/docking/airlock_program

/datum/computer/file/embedded_program/docking/airlock/New(var/obj/machinery/embedded_controller/M)
	..()
	airlock_program = new(M)
	airlock_program.master_prog = src

/datum/computer/file/embedded_program/docking/airlock/Destroy()
	qdel(airlock_program)
	return ..()

/datum/computer/file/embedded_program/docking/airlock/receive_user_command(command)
	if (command == "toggle_override")
		if (override_enabled)
			disable_override()
		else
			enable_override()
		return TRUE

	. = ..(command)
	. = airlock_program.receive_user_command(command) || .	//pass along to subprograms; bypass shortcircuit

/datum/computer/file/embedded_program/docking/airlock/process()
	airlock_program.process()
	..()

/datum/computer/file/embedded_program/docking/airlock/receive_signal(datum/signal/signal, receive_method, receive_param)
	airlock_program.receive_signal(signal, receive_method, receive_param)	//pass along to subprograms
	..(signal, receive_method, receive_param)

//tell the docking port to start getting ready for docking - e.g. pressurize
/datum/computer/file/embedded_program/docking/airlock/prepare_for_docking()
	airlock_program.begin_dock_cycle()

//are we ready for docking?
/datum/computer/file/embedded_program/docking/airlock/ready_for_docking()
	return airlock_program.done_cycling()

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_program/docking/airlock/finish_docking()
	airlock_program.enable_mech_regulators()
	airlock_program.open_doors()

//tell the docking port to start getting ready for undocking - e.g. close those doors.
/datum/computer/file/embedded_program/docking/airlock/prepare_for_undocking()
	airlock_program.stop_cycling()
	airlock_program.close_doors()
	airlock_program.disable_mech_regulators()

//are we ready for undocking?
/datum/computer/file/embedded_program/docking/airlock/ready_for_undocking()
	var/ext_closed = airlock_program.check_exterior_door_secured()
	var/int_closed = airlock_program.check_interior_door_secured()
	return (ext_closed || int_closed)

//An airlock controller to be used by the airlock-based docking port controller.
//Same as a regular airlock controller but allows disabling of the regular airlock functions when docking
/datum/computer/file/embedded_program/airlock/docking
	var/datum/computer/file/embedded_program/docking/airlock/master_prog

/datum/computer/file/embedded_program/airlock/docking/Destroy()
	if(master_prog)
		master_prog.airlock_program = null
		master_prog = null
	return ..()

/datum/computer/file/embedded_program/airlock/docking/receive_user_command(command)
	if (master_prog.undocked() || master_prog.override_enabled)	//only allow the port to be used as an airlock if nothing is docked here or the override is enabled
		return ..(command)

/datum/computer/file/embedded_program/airlock/docking/proc/enable_mech_regulators()
	enable_mech_regulation()

/datum/computer/file/embedded_program/airlock/docking/proc/disable_mech_regulators()
	disable_mech_regulation()

/datum/computer/file/embedded_program/airlock/docking/proc/open_doors()
	toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "open")
	toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "open")

/datum/computer/file/embedded_program/airlock/docking/cycleDoors(var/target)
	if (master_prog.undocked() || master_prog.override_enabled)	//only allow the port to be used as an airlock if nothing is docked here or the override is enabled
		..(target)

/*** DEBUG VERBS ***

/datum/computer/file/embedded_program/docking/proc/print_state()
	log_debug("id_tag: [id_tag]")
	log_debug("dock_state: [dock_state]")
	log_debug("control_mode: [control_mode]")
	log_debug("tag_target: [tag_target]")
	log_debug("response_sent: [response_sent]")

/datum/computer/file/embedded_program/docking/post_signal(datum/signal/signal, comm_line)
	log_debug("Program [id_tag] sent a message!")

	print_state()
	log_debug("[id_tag] sent command \"[signal.data["command"]]\" to \"[signal.data["recipient"]]\"")

	..(signal)

/obj/machinery/embedded_controller/radio/airlock/docking_port/verb/view_state()
	set category = "Debug"
	set src in view(1)
	src.program:print_state()

/obj/machinery/embedded_controller/radio/airlock/docking_port/verb/spoof_signal(var/command as text, var/sender as text)
	set category = "Debug"
	set src in view(1)
	var/datum/signal/signal = new
	signal.data["tag"] = sender
	signal.data["command"] = command
	signal.data["recipient"] = id_tag

	src.program:receive_signal(signal)

/obj/machinery/embedded_controller/radio/airlock/docking_port/verb/debug_init_dock(var/target as text)
	set category = "Debug"
	set src in view(1)
	src.program:initiate_docking(target)

/obj/machinery/embedded_controller/radio/airlock/docking_port/verb/debug_init_undock()
	set category = "Debug"
	set src in view(1)
	src.program:initiate_undocking()

*/