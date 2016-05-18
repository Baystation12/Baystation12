// This is special hardware configuration program.
// It is to be used only with modular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/computerconfig
	filename = "compconfig"
	filedesc = "Computer Configuration Tool"
	extended_desc = "This program allows configuration of computer's hardware"
	program_icon_state = "generic"
	unsendable = 1
	undeletable = 1
	size = 4
	available_on_ntnet = 0
	requires_ntnet = 0
	nanomodule_path = /datum/nano_module/program/computer_configurator/


/datum/nano_module/program/computer_configurator
	name = "NTOS Computer Configuration Tool"
	var/obj/item/modular_computer/movable = null

/datum/nano_module/program/computer_configurator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(program)
		movable = program.computer
	if(!istype(movable))
		movable = null

	// No computer connection, we can't get data from that.
	if(!movable)
		return 0

	var/list/data = list()

	if(program)
		data = program.get_header_data()

	var/list/hardware = movable.get_all_components()

	data["disk_size"] = movable.hard_drive.max_capacity
	data["disk_used"] = movable.hard_drive.used_capacity
	data["power_usage"] = movable.last_power_usage
	data["battery_exists"] = movable.battery_module ? 1 : 0
	if(movable.battery_module)
		data["battery_rating"] = movable.battery_module.battery.maxcharge
		data["battery_percent"] = round(movable.battery_module.battery.percent())

	var/list/all_entries[0]
	for(var/obj/item/weapon/computer_hardware/H in hardware)
		all_entries.Add(list(list(
		"name" = H.name,
		"desc" = H.desc,
		"enabled" = H.enabled,
		"critical" = H.critical,
		"powerusage" = H.power_usage
		)))

	data["hardware"] = all_entries
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "laptop_configuration.tmpl", "NTOS Configuration Utility", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/computer_configurator/proc/check_password(user)
	if(program)
		movable = program.computer
	var/pass_entered = sanitize(input(usr, "Access Denied: Enter Password", "Enter Password"), 16)
	if(!pass_entered)
		return 0
	if(pass_entered != movable.password)
		user << "<span class='warning'>Incorrect Password.</span>"
		return 0
	return 1

/datum/nano_module/program/computer_configurator/Topic(href, href_list)
	if(..())
		return 1
	if(program)
		movable = program.computer
	var/mob/user = usr
	switch(href_list["action"])
		if("setpassword")
			. = 1
			if(!movable.password)
				var/new_pass = sanitize(input(user, "Please enter the new password:", "New Password"), 16)
				if(!new_pass)
					return 1
				movable.password = new_pass
			else
				if(!check_password(user))
					return 1
				var/new_pass = sanitize(input(user, "Please enter the new password:", "New Password"), 16)
				if(!new_pass)
					return 1
				movable.password = new_pass
			user << "<span class='notice'>Password Set.</span>"
		if("rempassword")
			. = 1
			if(!movable.password)
				user << "<span class='warning'>No password set.</span>"
				return 1
			if(!check_password(user))
				return 1
			movable.password = null
			user << "<span class='notice'>Password Deleted.</span>"
	if(.)
		nanomanager.update_uis(src)