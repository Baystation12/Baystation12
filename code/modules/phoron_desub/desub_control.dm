/obj/machinery/computer/phoron_desublimer_control
	name = "desublimation control console"
	desc = "It controls the phoron desublimation machinery."
	icon_keyboard = "tech_key"
	icon_screen = "pd_screen_empty"

	idle_power_usage = 500
	active_power_usage = 70000 //70 kW per unit of strength
	var/active = 0
	var/assembled = 0
	var/state = "vessel"
	var/list/frequency_presets = list(DEFAULT_WALL_MATERIAL = 30)

	var/obj/machinery/phoron_desublimer/vessel/vessel = null
	var/obj/machinery/phoron_desublimer/furnace/furnace = null

/obj/machinery/computer/phoron_desublimer_control/Initialize()
	. = ..()
	find_parts()

/obj/machinery/computer/phoron_desublimer_control/Destroy()
	vessel = null
	furnace = null
	. = ..()

/obj/machinery/computer/phoron_desublimer_control/proc/find_parts()
	for(var/obj/machinery/phoron_desublimer/PD in get_area(src))
		if(istype(PD, /obj/machinery/phoron_desublimer/vessel))
			vessel = PD
			vessel.com = src
		if(istype(PD, /obj/machinery/phoron_desublimer/furnace))
			furnace = PD
	if((!vessel) || (!furnace))
		return 0
	return 1

/obj/machinery/computer/phoron_desublimer_control/proc/set_preset(var/mob/user)
	if(!user)
		return
	var/preset = null
	preset = input(user, "Which preset would you like set?", "Select Preset", preset) in frequency_presets
	if(CanPhysicallyInteract(user))
		frequency_presets[preset] = furnace.neutron_flow

/obj/machinery/computer/phoron_desublimer_control/attack_ai(mob/user)
	interact(user)

/obj/machinery/computer/phoron_desublimer_control/attack_hand(mob/user)
	..()
	ui_interact(user)

/obj/machinery/computer/phoron_desublimer_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["run_scan"] = 0
	data["state"] = state

	var/list/presets = list()
	for (var/re in frequency_presets)
		presets.Add(list(list("title" = re, "value" = frequency_presets[re] ,"commands" = list("set_neutron_flow" = frequency_presets[re]))))
	data["presets"] = presets

	if(vessel && state == "vessel")
		data["vessel"] = vessel
		data["shard"] = vessel.loaded_shard
		data["max_shard_size"] = 100
		data["vessel_pressure"] = vessel.air_contents.return_pressure()

		if(vessel.loaded_shard)
			var/obj/item/weapon/material/shard/supermatter/S = vessel.loaded_shard
			data["shard_size"] = round(100.0*S.size/S.max_size, 0.1)
		else
			data["shard_size"] = 0

		if(vessel.loaded_tank)
			data["tank"] = vessel.loaded_tank
			data["tank_pressure"] = round(vessel.loaded_tank.air_contents.return_pressure() ? vessel.loaded_tank.air_contents.return_pressure() : 0)
		else
			data["tank_pressure"] = 0
	else if(furnace && state == "furnace")
		data["furnace"] = furnace
		data["neutron_flow"] = furnace.neutron_flow
		data["max_neutron_flow"] = furnace.max_neutron_flow
		data["min_neutron_flow"] = furnace.min_neutron_flow
		data["shard"] = furnace.shard
		data["max_shard_size"] = 100

		if(furnace.shard)
			var/obj/item/weapon/material/shard/supermatter/S = furnace.shard
			data["shard_size"] = round(100.0*S.size/S.max_size, 0.1)
		else
			data["shard_size"] = 0

		// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "phoron_desublimation.tmpl", "Desublimation Control Console", 600, 385)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/phoron_desublimer_control/OnTopic(user, href_list)
	if(href_list["state"])
		state = href_list["state"]
	else if(href_list["run_scan"])
		src.find_parts()
	else if(href_list["set_preset"])
		src.set_preset(user)
	else if(href_list["vessel_eject_shard"])
		vessel.eject_shard()
	else if(href_list["vessel_eject_tank"])
		vessel.eject_tank()
	else if(href_list["vessel_fill"])
		vessel.fill()
	else if(href_list["vessel_feed"])
		vessel.crystalize()
	else if(href_list["furnace_eject_shard"])
		furnace.eject_shard()
	else if(href_list["neutron_adj"])
		var/diff = text2num(href_list["neutron_adj"])
		furnace.modify_flow(diff)
	else if(href_list["set_neutron_flow"])
		var/diff = text2num(href_list["set_neutron_flow"])
		if(diff)
			furnace.neutron_flow = Clamp(diff, furnace.min_neutron_flow, furnace.max_neutron_flow)
	else if(href_list["furnace_activate"])
		if(furnace.report_ready() & !furnace.active)
			furnace.produce()
	return TOPIC_HANDLED
