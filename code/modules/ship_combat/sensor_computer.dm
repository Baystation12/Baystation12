/obj/machinery/space_battle/sensor_computer
	name = "sensor control"
	desc = "Allows control of sensors"
	icon_state = "sensor_computer"
	var/list/sensors = list()
	var/selected_machine

/obj/machinery/space_battle/sensor_computer/initialize()
	populate_sensor_list()
	..()

/obj/machinery/space_battle/sensor_computer/proc/populate_sensor_list()
	sensors.Cut()
	for(var/M in linked.fire_sensors)
		var/obj/machinery/space_batte/missile_sensor/S = M
		sensors.Add(S)

/obj/machinery/space_battle/sensor_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/list/machines = list()
	for(var/M in sensors)
		machines.Add("[M.name]")
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

/obj/machinery/space_battle/sensor_computer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["refresh"])
		populate_sensor_list()
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
				sensor_id = inp
				reconnect()
				usr << "<span class='notice'>You set \the [src]'s sensor identification to, \"[sensor_id]\"</span>"
			else
				usr << "<span class='warning'>That is too long!</span>"
		return 1
	if(href_list["id_tag"])
		var/inp = input(usr, "What would you like to change \the [src]'s ID to?")
		if(inp)
			if(length(inp) < 25)
				id_tag = inp
				reconnect()
				usr << "<span class='notice'>You set \the [src]'s identification to, \"[id_tag]\"</span>"
			else
				usr << "<span class='warning'>That is too long!</span>"
		return 1

