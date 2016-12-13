/obj/machinery/space_battle/computer/sensor
	name = "sensor control"
	desc = "Allows control of sensors"
	screen_icon = "sensorcomputer"
	var/list/sensors = list()
	var/obj/machinery/space_battle/missile_sensor/selected_machine

/obj/machinery/space_battle/computer/sensor/initialize()
	populate_sensor_list()
	..()

/obj/machinery/space_battle/computer/sensor/proc/populate_sensor_list()
	sensors.Cut()
	if(!linked)
		linked = map_sectors["[z]"]
		if(!linked)
			return 0
	for(var/M in linked.fire_sensors)
		var/obj/machinery/space_battle/missile_sensor/S = M
		sensors.Add(S)

/obj/machinery/space_battle/computer/sensor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/list/machines = list()
	for(var/M in sensors)
		var/obj/O = M
		machines.Add("[O.name]")
	data["machines"] = machines
	var/list/info = list()
	if(selected_machine)
		var/status = selected_machine.can_sense()
		if(status == 1) status = "Nominal"
		info.Add(list(list(
		"name" = selected_machine.name,
		"status" = status,
		"dish" = selected_machine.dishes.len,
		"id_tag" = selected_machine.id_tag,
		"sensor_id" = selected_machine.sensor_id,
		"enabled" = (selected_machine.use_power == 2 ? "Enabled" : "Disabled")
		)))
		data["info"] = info
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sensorcomp.tmpl", "Sensor Control", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/space_battle/computer/sensor/attack_hand(var/mob/user)
	ui_interact(user)
	return 1

/obj/machinery/space_battle/computer/sensor/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["refresh"])
		populate_sensor_list()
		selected_machine = null
		return 1
	if(href_list["return"])
		selected_machine = null
		return 1
	if(href_list["selected"])
		var/N = href_list["selected"]
		for(var/M in sensors)
			var/obj/O = M
			if(O.name == N)
				selected_machine = O
		return 1
	if(href_list["sensor_id"])
		var/inp = input(usr, "What would you like to change \the [src]'s sensor ID to?")
		if(inp)
			if(length(inp) < 25)
				selected_machine.sensor_id = inp
				reconnect()
				usr << "<span class='notice'>You set \the [src]'s sensor identification to, \"[selected_machine.sensor_id]\"</span>"
			else
				usr << "<span class='warning'>That is too long!</span>"
		return 1
	if(href_list["id_tag"])
		var/inp = input(usr, "What would you like to change \the [src]'s ID to?")
		if(inp)
			if(length(inp) < 25)
				selected_machine.id_tag = inp
				selected_machine.reconnect()
				usr << "<span class='notice'>You set \the [src]'s identification to, \"[selected_machine.id_tag]\"</span>"
			else
				usr << "<span class='warning'>That is too long!</span>"
		return 1

