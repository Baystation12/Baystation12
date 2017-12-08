/obj/machinery/atmospherics/binary/oxyregenerator
	icon = 'icons/atmos/oxyregenerator.dmi'
	icon_state = "off"
	level = 1
	use_power = 0
	idle_power_usage = 200		//internal circuitry, friction losses and stuff
	power_rating = 10000
	var/id = null
	var/flow = 150 //Liters per power-level. Just a guess. Will adjust as neccessary
	var/power_setting = 0 //power consumption setting, 0 throough five
	var/carbon_stored = 0

/obj/machinery/atmospherics/binary/oxyregenerator/Process(var/delay)
	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	last_power_draw = 0
	last_flow_rate = 0

	var/co2_intake = between(0, air1["carbon_dioxide"], MOLES_CELLSTANDARD*power_setting*delay/10)//takes as much CO2 as acessible within limit of power usage, 1 level per 0.1 mole per second

	carbon_stored += co2_intake

	while (carbon_stored >= MOLES_CELLSTANDARD)
		carbon_stored -= MOLES_CELLSTANDARD
		var/atom/movable/product = new/obj/item/weapon/ore/coal
		product.dropInto(loc)

	air1.adjust_gas("carbon_dioxide", -co2_intake, 1)
	air2.adjust_gas("oxygen", co2_intake, 1)

	power_draw = power_rating * power_setting
	last_flow_rate = (co2_intake/air1.total_moles)*air1.volume

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

/obj/machinery/atmospherics/binary/oxyregenerator/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/binary/oxyregenerator/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/atmospherics/binary/oxyregenerator/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/atmospherics/binary/oxyregenerator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["on"] = use_power ? 1 : 0
	data["powerSetting"] = power_setting
	data["gasPressure"] = round(air1.return_pressure())
	data["gasTemperature"] = round(air1.temperature)
	data["gasProcessed"] = last_flow_rate

		// update the ui if it exists, returns null if no ui is passed/found
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "oxyregenerator.tmpl", "Oxygen Regeneration System", 440, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/atmospherics/binary/oxyregenerator/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["toggleStatus"])
		use_power = !use_power
		update_icon()
		return 1
	if(href_list["setPower"]) //setting power to 0 is redundant anyways
		power_setting = text2num(href_list["setPower"])
		return 1