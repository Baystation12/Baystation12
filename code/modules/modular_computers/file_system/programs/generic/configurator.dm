// This is special hardware configuration program.
// It is to be used only with modular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/computerconfig
	filename = "compconfig"
	filedesc = "Computer Configuration Tool"
	extended_desc = "This program allows configuration of computer's hardware"
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "gear"
	unsendable = 1
	undeletable = 1
	size = 4
	available_on_ntnet = 0
	requires_ntnet = 0
	nanomodule_path = /datum/nano_module/program/computer_configurator/
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

/datum/nano_module/program/computer_configurator
	name = "NTOS Computer Configuration Tool"

/datum/nano_module/program/computer_configurator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()

	data = program.get_header_data()

	data["disk_size"] = program.computer.max_disk_capacity()
	data["disk_used"] = program.computer.used_disk_capacity()
	data["power_usage"] = program.computer.get_power_usage()
	var/obj/item/weapon/stock_parts/computer/battery_module/battery_module = program.computer.get_component(PART_BATTERY)
	data["battery_exists"] = !!battery_module
	if(battery_module)
		data["battery_rating"] = battery_module.battery.maxcharge
		data["battery_percent"] = round(battery_module.battery.percent())

	var/obj/item/weapon/stock_parts/computer/network_card/network_card = program.computer.get_component(PART_NETWORK)
	data["nic_exists"] = !!network_card
	if(network_card)
		var/datum/extension/exonet_device/exonet = get_extension(network_card, /datum/extension/exonet_device)
		var/datum/exonet/network = exonet.get_local_network()
		if(!network)		
			data["signal_strength"] = "Not Connected"
		else
			var/signal_strength = network.get_signal_strength(network_card, network_card.get_netspeed())
			if(signal_strength <= 0)
				data["signal_strength"] = "Not Connected"
			else if(signal_strength <= 1)
				data["signal_strength"] = "Low Signal"
			else
				data["signal_strength"] = "High Signal"
		data["ennid"] = network_card.ennid
		data["key"] = network_card.keydata

	var/list/all_entries[0]
	var/list/hardware = program.computer.get_all_components()
	for(var/obj/item/weapon/stock_parts/computer/H in hardware)
		all_entries.Add(list(list(
		"name" = H.name,
		"desc" = H.desc,
		"enabled" = H.enabled,
		"critical" = H.critical,
		"powerusage" = H.power_usage,
		"ref" = "\ref[H]"
		)))

	data["hardware"] = all_entries

	data["receives_updates"] = program.computer.receives_updates

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "laptop_configuration.tmpl", "NTOS Configuration Utility", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()