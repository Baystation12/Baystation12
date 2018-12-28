
/obj/machinery/portable_atmospherics/gas_collector/attack_hand(var/mob/living/user)
	if(isliving(user))
		add_fingerprint(user)
		user.set_machine(src)
		ui_interact(user)

/obj/machinery/portable_atmospherics/gas_collector/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/data[0]
	data["gas_inventory"] = gas_inventory
	data["volume"] = volume
	data["pressure"] = air_contents.return_pressure()
	data["max_pressure"] = max_pressure
	data["fill_percent"] = "[round(100*(data["pressure"] / max_pressure))]%"
	data["temperature"] = air_contents.temperature
	data["total_moles"] = air_contents.total_moles
	data["is_holding"] = holding ? 1 : 0
	data["holding"] = holding ? holding.name : "Nothing"
	data["holding_pressure"] = holding ? holding.air_contents.return_pressure() : 0
	data["holding_volume"] = holding ? holding.volume : 0
	data["holding_fill_percent"] = "[round(100*(data["holding_pressure"] / max_pressure))]%"
	data["anchored"] = anchored
	data["secured_geyser"] = secured_geyser ? 1 : 0

	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "gas_collector.tmpl", secured_geyser ? "[secured_geyser.name] Collector" : src.name, 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/gas_collector/Topic(href, href_list)
	if(href_list["eject"])
		if(holding)
			holding.loc = src.loc
			holding = null

	if(href_list["expel_gas"])
		var/gasid = href_list["expel_gas"]
		if(gases_to_expel.Find(gasid))
			gases_to_expel -= gasid
		else
			gases_to_expel += gasid
		update_gases_ui()

	if(href_list["drain_to_tank"])
		var/mob/living/user = locate(href_list["user"])
		if(holding)
			//proc/calculate_transfer_moles(datum/gas_mixture/source, datum/gas_mixture/sink, var/pressure_delta, var/sink_volume_mod=0)
			//calculate_transfer_moles() is only an approximate calculation, so a 10% margin of safety will hopefully be enough
			var/target_pressure_delta = max_pressure - holding.air_contents.return_pressure()
			var/moles_to_transfer = calculate_transfer_moles(air_contents, holding.air_contents, target_pressure_delta)
			var/datum/gas_mixture/drained_air = air_contents.remove(moles_to_transfer)
			holding.air_contents.merge(drained_air)
			qdel(drained_air)
			if(user)
				to_chat(user, "<span class='info'>You drain [src]'s internal tank into the [holding].</span>")
