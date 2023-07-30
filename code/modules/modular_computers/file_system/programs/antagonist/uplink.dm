/datum/computer_file/program/uplink
	filename = "taxquickly"
	filedesc = "TaxQuickly 1.45b"
	program_icon_state = "uplink"
	extended_desc = "An online tax filing software. It is a few years out of date."
	size = 0 // it is cloud based
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	usage_flags = PROGRAM_PDA
	nanomodule_path = /datum/nano_module/program/uplink

	var/password
	var/authenticated = 0

/datum/computer_file/program/uplink/New(password)
	src.password = password

/datum/nano_module/program/uplink
	name = "TaxQuickly 1.45b"

/datum/nano_module/program/uplink/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, master_ui = null, datum/topic_state/state = GLOB.default_state)
	var/datum/computer_file/program/uplink/prog = program
	var/obj/item/holder = program.computer.get_physical_host()
	if (istype(holder) && holder.hidden_uplink && prog.password)
		if (prog.authenticated)
			if (!CanInteract(user, state))
				return
			if (alert(user, "Resume or close and secure?", name, "Resume", "Close") == "Resume")
				holder.hidden_uplink.trigger(user)
				return
			else
				holder.hidden_uplink.toggle()
				SSnano.close_user_uis(user, holder.hidden_uplink, "main")
				//No return here. We want the proc to run the last two lines.
		else if (holder.hidden_uplink.check_trigger(user, input(user, "Please enter your unique tax ID:", "Authentication"), prog.password))
			prog.authenticated = 1
			return
	else
		program.computer.show_error(user, "ID not found")

	prog.authenticated = 0
	program.computer.kill_program(program)
