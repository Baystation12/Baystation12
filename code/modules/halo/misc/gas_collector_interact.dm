
/obj/machinery/portable_atmospherics/gas_collector/attack_hand(var/mob/living/user)
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
	data["holding_pressure"] = holding ? holding.air_contents.return_pressure() : "NA"
	data["holding_volume"] = holding ? holding.volume : "NA"
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
