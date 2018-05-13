/datum/computer_file/program/uplink
	filename = "taxquickly"
	filedesc = "TaxQuickly 2559"
	program_icon_state = "uplink"
	extended_desc = "An online tax filing software. It is a few years out of date."
	size = 0 // it is cloud based
	requires_ntnet = 0
	available_on_ntnet = 0
	usage_flags = PROGRAM_PDA
	nanomodule_path = /datum/nano_module/program/uplink

	var/password
	var/authenticated = 0

/datum/computer_file/program/uplink/New(var/password)
	src.password = password

/datum/nano_module/program/uplink
	name = "TaxQuickly 2559"

/datum/nano_module/program/uplink/ui_interact(var/mob/user)
	var/datum/computer_file/program/uplink/prog = program
	var/obj/item/modular_computer/computer = host
	if(istype(computer) && istype(prog))
		if(computer.hidden_uplink && prog.password)
			if(prog.authenticated)
				if(alert(user, "Resume or close and secure?", name, "Resume", "Close") == "Resume")
					computer.hidden_uplink.trigger(user)
					return
			else if(computer.hidden_uplink.check_trigger(user, input(user, "Please enter your unique tax ID:", "Authentication"), prog.password))
				prog.authenticated = 1
				return
		else
			to_chat(user, "<span class='warning'>[computer] displays an \"ID not found\" error.</span>")

	prog.authenticated = 0
	computer.kill_program()