/datum/computer_file/program/revelation
	filename = "revelation"
	filedesc = "Revelation"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "home"
	extended_desc = "This virus can destroy hard drive of system it is executed on. It may be obfuscated to look like another non-malicious program. Once armed, it will destroy the system upon next execution."
	size = 13
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	nanomodule_path = /datum/nano_module/program/revelation
	var/armed = FALSE

/datum/computer_file/program/revelation/on_startup(mob/living/user, datum/extension/interactive/ntos/new_host)
	. = ..(user, new_host)
	if(armed)
		activate()

/datum/computer_file/program/revelation/proc/activate()
	if(!computer)
		return

	computer.visible_error("Hardware error: Voltage reaching unsafe leve-")
	computer.system_shutdown()
	computer.voltage_overload()

/datum/computer_file/program/revelation/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	else if(href_list["PRG_arm"])
		armed = !armed
		return TOPIC_HANDLED
	else if(href_list["PRG_activate"])
		activate()
		return TOPIC_HANDLED
	else if(href_list["PRG_obfuscate"])
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new program name: "))
		if(newname && program_state == PROGRAM_STATE_ACTIVE)
			filedesc = newname
			if(ntnet_global)
				for(var/datum/computer_file/program/P in ntnet_global.available_station_software)
					if(filedesc == P.filedesc)
						program_menu_icon = P.program_menu_icon
						break
		return TOPIC_HANDLED

/datum/computer_file/program/revelation/clone()
	var/datum/computer_file/program/revelation/temp = ..()
	temp.armed = armed
	return temp

/datum/nano_module/program/revelation
	name = "Revelation Virus"

/datum/nano_module/program/revelation/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	var/datum/computer_file/program/revelation/PRG = program
	if(!istype(PRG))
		return

	data = PRG.get_header_data()

	data["armed"] = PRG.armed

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "revelation.tmpl", "Revelation Virus", 400, 250, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
