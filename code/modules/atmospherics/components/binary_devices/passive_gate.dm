#define REGULATE_NONE	0
#define REGULATE_INPUT	1	//shuts off when input side is below the target pressure
#define REGULATE_OUTPUT	2	//shuts off when output side is above the target pressure

/obj/machinery/atmospherics/binary/passive_gate
	icon = 'icons/atmos/passive_gate.dmi'
	icon_state = "map_off"
	level = 1

	name = "pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. Does not require power."

	use_power = 0
	interact_offline = 1
	var/unlocked = 0	//If 0, then the valve is locked closed, otherwise it is open(-able, it's a one-way valve so it closes if gas would flow backwards).
	var/target_pressure = ONE_ATMOSPHERE
	var/max_pressure_setting = MAX_PUMP_PRESSURE
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	var/regulate_mode = REGULATE_OUTPUT

	var/flowing = 0	//for icons - becomes zero if the valve closes itself due to regulation mode

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/passive_gate/on
	unlocked = 1
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/passive_gate/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5

/obj/machinery/atmospherics/binary/passive_gate/update_icon()
	icon_state = (unlocked && flowing)? "on" : "off"

/obj/machinery/atmospherics/binary/passive_gate/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, 180))
		add_underlay(T, node2, dir)

/obj/machinery/atmospherics/binary/passive_gate/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/passive_gate/Process()
	..()

	last_flow_rate = 0

	if(!unlocked)
		return 0

	var/output_starting_pressure = air2.return_pressure()
	var/input_starting_pressure = air1.return_pressure()

	var/pressure_delta
	switch (regulate_mode)
		if (REGULATE_INPUT)
			pressure_delta = input_starting_pressure - target_pressure
		if (REGULATE_OUTPUT)
			pressure_delta = target_pressure - output_starting_pressure

	//-1 if pump_gas() did not move any gas, >= 0 otherwise
	var/returnval = -1
	if((regulate_mode == REGULATE_NONE || pressure_delta > 0.01) && (air1.temperature > 0 || air2.temperature > 0))	//since it's basically a valve, it makes sense to check both temperatures
		flowing = 1

		//flow rate limit
		var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

		//Figure out how much gas to transfer to meet the target pressure.
		switch (regulate_mode)
			if (REGULATE_INPUT)
				transfer_moles = min(transfer_moles, calculate_transfer_moles(air2, air1, pressure_delta, (network1)? network1.volume : 0))
			if (REGULATE_OUTPUT)
				transfer_moles = min(transfer_moles, calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0))

		//pump_gas() will return a negative number if no flow occurred
		returnval = pump_gas_passive(src, air1, air2, transfer_moles)

	if (returnval >= 0)
		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	if (last_flow_rate)
		flowing = 1

	update_icon()


//Radio remote control

/obj/machinery/atmospherics/binary/passive_gate/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/passive_gate/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = unlocked,
		"target_output" = target_pressure,
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = set_flow_rate,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/passive_gate/Initialize()
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/passive_gate/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0

	if("power" in signal.data)
		unlocked = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		unlocked = !unlocked

	if("set_target_pressure" in signal.data)
		target_pressure = between(
			0,
			text2num(signal.data["set_target_pressure"]),
			max_pressure_setting
		)

	if("set_regulate_mode" in signal.data)
		regulate_mode = text2num(signal.data["set_regulate_mode"])

	if("set_flow_rate" in signal.data)
		regulate_mode = text2num(signal.data["set_flow_rate"])

	if("status" in signal.data)
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/binary/passive_gate/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/passive_gate/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (BROKEN|NOPOWER))
		return

	// this is the data which will be sent to the ui
	var/data[0]

	data = list(
		"on" = unlocked,
		"pressure_set" = round(target_pressure*100),	//Nano UI can't handle rounded non-integers, apparently.
		"max_pressure" = max_pressure_setting,
		"input_pressure" = round(air1.return_pressure()*100),
		"output_pressure" = round(air2.return_pressure()*100),
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = round(set_flow_rate*10),
		"last_flow_rate" = round(last_flow_rate*10),
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "pressure_regulator.tmpl", name, 470, 370)
		ui.set_initial_data(data)	// when the ui is first opened this is the data it will use
		ui.open()					// open the new ui window
		ui.set_auto_update(1)		// auto update every Master Controller tick


/obj/machinery/atmospherics/binary/passive_gate/Topic(href,href_list)
	if(..()) return 1

	if(href_list["toggle_valve"])
		unlocked = !unlocked

	if(href_list["regulate_mode"])
		switch(href_list["regulate_mode"])
			if ("off") regulate_mode = REGULATE_NONE
			if ("input") regulate_mode = REGULATE_INPUT
			if ("output") regulate_mode = REGULATE_OUTPUT

	switch(href_list["set_press"])
		if ("min")
			target_pressure = 0
		if ("max")
			target_pressure = max_pressure_setting
		if ("set")
			var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure Control",src.target_pressure) as num
			src.target_pressure = between(0, new_pressure, max_pressure_setting)

	switch(href_list["set_flow_rate"])
		if ("min")
			set_flow_rate = 0
		if ("max")
			set_flow_rate = air1.volume
		if ("set")
			var/new_flow_rate = input(usr,"Enter new flow rate limit (0-[air1.volume]kPa)","Flow Rate Control",src.set_flow_rate) as num
			src.set_flow_rate = between(0, new_flow_rate, air1.volume)

	usr.set_machine(src)	//Is this even needed with NanoUI?
	src.update_icon()
	src.add_fingerprint(usr)
	return

/obj/machinery/atmospherics/binary/passive_gate/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!iswrench(W))
		return ..()
	if (unlocked)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], turn it off first.</span>")
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40, src))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)

#undef REGULATE_NONE
#undef REGULATE_INPUT
#undef REGULATE_OUTPUT
