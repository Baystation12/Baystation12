/datum/computer_file/program/crushercontrol
	filename = "crushercontrol"
	filedesc = "Crusher Control"
	extended_desc = "Application to Control the Crusher"
	program_icon_state = "supply"
	size = 8
	required_access = access_cargo
	usage_flags = PROGRAM_TELESCREEN | PROGRAM_CONSOLE
	nanomodule_path = /datum/nano_module/program/crushercontrol/

/datum/nano_module/program/crushercontrol/
	name = "Crusher Control"
	var/message = "" // Message to return to the user
	var/extending = 0 //If atleast one of the pistons is extending
	var/list/pistons = list() //List of pistons linked to the program
	var/list/airlocks = list() //List of airlocks linked to the program
	var/list/status_airlocks = list() //Status of the airlocks
	var/list/status_pistons = list() //Status of the pistons

/datum/nano_module/program/crushercontrol/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	status_pistons = list()
	extending = 0

	//Cycle through the pistons and get their status
	var/i = 1
	for(var/obj/machinery/crusher_base/piston in pistons)
		var/num_progress = piston.get_num_progress()
		var/is_blocked = piston.is_blocked()
		var/action = piston.get_action()
		if(action == "extend")
			extending = 1
		status_pistons.Add(list(list(
			"progress"=num_progress,
			"blocked"=is_blocked,
			"action"=action,
			"piston"=i
			)))
		i++

	data["message"] = message
	data["airlock_count"] = length(airlocks)
	data["piston_count"] = length(pistons)
	data["status_airlocks"] = status_airlocks
	data["status_pistons"] = status_pistons
	data["extending"] = extending
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "mods-crushercontrol.tmpl", name, 500, 350, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/crushercontrol/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["initialize"])
		pistons = list()
		for(var/obj/machinery/crusher_base/piston in orange(10,src.host))
			pistons += piston

		airlocks = list()
		for(var/obj/machinery/door/airlock/arlk in orange(10,src.host))
			if( arlk.id_tag != "crusher")
				continue
			airlocks += arlk

		airlock_open()

	if(href_list["hatch_open"])
		message = "Opening the Hatch"
		airlock_open()

	if(href_list["hatch_close"])
		message = "Closing the Hatch"
		airlock_close()

	if(href_list["crush"])
		message = "Crushing"
		airlock_close()
		crush_start()

	if(href_list["abort"])
		message = "Aborting"
		crush_stop()

	if(href_list["close"])
		message = null


/datum/nano_module/program/crushercontrol/proc/airlock_open()
	for(var/thing in airlocks)
		var/obj/machinery/door/airlock/airlock = thing
		if (!airlock.cur_command)
			// Not using do_command so that the command queuer works.
			airlock.cur_command = "secure_open"
			airlock.execute_current_command()

/datum/nano_module/program/crushercontrol/proc/airlock_close()
	for(var/thing in airlocks)
		var/obj/machinery/door/airlock/airlock = thing
		if (!airlock.cur_command)
			airlock.cur_command = "secure_close"
			airlock.execute_current_command()

/datum/nano_module/program/crushercontrol/proc/crush_start()
	for(var/obj/machinery/crusher_base/piston in pistons)
		piston.crush_start()

/datum/nano_module/program/crushercontrol/proc/crush_stop()
	for(var/obj/machinery/crusher_base/piston in pistons)
		piston.crush_abort()

/obj/item/modular_computer/telescreen/preset/trashcompactor/install_default_programs()
	..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.create_file(new/datum/computer_file/program/crushercontrol())
		os.set_autorun("crushercontrol")
