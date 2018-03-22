var/list/escape_pods = list()
var/list/escape_pods_by_name = list()

/datum/shuttle/autodock/ferry/escape_pod
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/arming_controller
	category = /datum/shuttle/autodock/ferry/escape_pod
	move_time = 100

/datum/shuttle/autodock/ferry/escape_pod/New()
	if(name in escape_pods_by_name)
		CRASH("An escape pod with the name '[name]' has already been defined.")
	move_time = evacuation_controller.evac_transit_delay + rand(-30, 60)
	escape_pods_by_name[name] = src
	escape_pods += src
	move_time = round(evacuation_controller.evac_transit_delay/10)

	..()

	//find the arming controller (berth)
	var/arming_controller_tag = arming_controller
	arming_controller = locate(arming_controller_tag)
	if(!istype(arming_controller))
		CRASH("Could not find arming controller for escape pod \"[name]\", tag was '[arming_controller_tag]'.")

	//find the pod's own controller
	var/datum/computer/file/embedded_program/docking/simple/prog = locate(dock_target)
	var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/controller_master = prog.master
	if(!istype(controller_master))
		CRASH("Escape pod \"[name]\" could not find it's controller master!")

	controller_master.pod = src

/datum/shuttle/autodock/ferry/escape_pod/can_launch()
	if(arming_controller && !arming_controller.armed)	//must be armed
		return 0
	if(location)
		return 0	//it's a one-way trip.
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_force()
	if (arming_controller.eject_time && world.time < arming_controller.eject_time + 50)
		return 0	//dont allow force launching until 5 seconds after the arming controller has reached it's countdown
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_cancel()
	return 0


//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	var/datum/shuttle/autodock/ferry/escape_pod/pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory["door_status"]["state"],
		"door_lock" = 	docking_program.memory["door_status"]["lock"],
		"can_force" = pod.can_force() || (evacuation_controller.has_evacuated() && pod.can_launch()),	//allow players to manually launch ahead of time if the shuttle leaves
		"is_armed" = pod.arming_controller.armed,
	)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/OnTopic(user, href_list)
	if("manual_arm")
		pod.arming_controller.arm()
		return TOPIC_REFRESH

	if("force_launch")
		if (pod.can_force())
			pod.force_launch(src)
		else if (evacuation_controller.has_evacuated() && pod.can_launch())	//allow players to manually launch ahead of time if the shuttle leaves
			pod.launch(src)
		return TOPIC_REFRESH

//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"
	progtype = /datum/computer/file/embedded_program/docking/simple/escape_pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
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

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_berth_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		to_chat(user, "<span class='notice'>You emag the [src], arming the escape pod!</span>")
		emagged = 1
		if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
			var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
			if (!P.armed)
				P.arm()
		return 1

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	var/armed = 0
	var/eject_delay = 10	//give latecomers some time to get out of the way if they don't make it onto the pod
	var/eject_time = null
	var/closing = 0

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/arm()
	if(!armed)
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
