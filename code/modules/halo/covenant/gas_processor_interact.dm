
/obj/machinery/portable_atmospherics/gas_processor/attack_hand(var/mob/living/user)
	if(anchored)
		ui_interact(user)
	else
		to_chat(user,"<span class='notice'>[src] must be wrenched down first.</span>")

/obj/machinery/portable_atmospherics/gas_processor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/data[0]
	data["gas_inventory"] = gas_inventory
	data["volume"] = volume
	data["pressure"] = air_contents.return_pressure()
	data["max_pressure"] = max_pressure
	data["fill_percent"] = "[round(100*(data["pressure"] / max_pressure))]%"
	data["total_moles"] = air_contents.total_moles
	data["is_holding"] = holding ? 1 : 0
	data["holding"] = holding ? holding.name : "Nothing"
	data["holding_pressure"] = holding ? holding.air_contents.return_pressure() : "NA"
	data["holding_volume"] = holding ? holding.volume : "NA"
	data["held_steel"] = held_steel

	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "gas_processor.tmpl", "Gas processor", 700, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/gas_processor/Topic(href, href_list)
	if(href_list["eject"])
		if(holding)
			holding.loc = src.loc
			holding = null
			overlays -= "dispenser_tank"

	if(href_list["expel_gas"])
		if(expel_gas(href_list["expel_gas"], locate(href_list["user"])))
			update_gases_ui()

	if(href_list["fill_holding"])
		if(fill_holding(href_list["fill_holding"]))
			update_gases_ui()

	if(href_list["drain_holding"])
		if(drain_holding())
			update_gases_ui()

	if(href_list["make_packet"])
		if(make_gas_packet(href_list["make_packet"], locate(href_list["user"])))
			update_gases_ui()
