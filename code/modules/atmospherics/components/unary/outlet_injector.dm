//Basically a one way passive valve. If the pressure inside is greater than the environment then gas will flow passively,
//but it does not permit gas to flow back from the environment into the injector. Can be turned off to prevent any gas flow.
//When it receives the "inject" signal, it will try to pump it's entire contents into the environment regardless of pressure, using power.

/obj/machinery/atmospherics/unary/outlet_injector
	icon = 'icons/atmos/injector.dmi'
	icon_state = "off"

	name = "injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 45000	//45000 W ~ 60 HP

	var/injecting = 0

	var/volume_rate = 50	//flow rate limit

	var/frequency = 1439
	var/id = null
	var/datum/radio_frequency/radio_connection


	level = 1

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	build_icon = 'icons/atmos/injector.dmi'
	build_icon_state = "map_injector"

/obj/machinery/atmospherics/unary/outlet_injector/Initialize()
	. = ..()
	//Give it a small reservoir for injecting. Also allows it to have a higher flow rate limit than vent pumps, to differentiate injectors a bit more.
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500

/obj/machinery/atmospherics/unary/outlet_injector/Initialize()
	. = ..()
	set_frequency(frequency)
	broadcast_status()

/obj/machinery/atmospherics/unary/outlet_injector/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/unary/outlet_injector/on_update_icon()
	if (!node)
		update_use_power(POWER_USE_OFF)

	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/unary/outlet_injector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/machinery/atmospherics/unary/outlet_injector/proc/get_console_data()
	. = list()
	. += "<table>"
	. += "<tr><td><b>Name:</b></td><td>[name]</td>"
	. += "<tr><td><b>Power:</b></td><td>[use_power?("<font color = 'green'>Injecting</font>"):("<font color = 'red'>Offline</font>")]</td><td><a href='?src=\ref[src];toggle_power=\ref[src]'>Toggle</a></td></tr>"
	. += "<tr><td><b>ID Tag:</b></td><td>[id]</td><td><a href='?src=\ref[src];settag=\ref[id]'>Set ID Tag</a></td></td></tr>"
	if(frequency%10)
		. += "<tr><td><b>Frequency:</b></td><td>[frequency/10]</td><td><a href='?src=\ref[src];setfreq=\ref[frequency]'>Set Frequency</a></td></td></tr>"
	else
		. += "<tr><td><b>Frequency:</b></td><td>[frequency/10].0</td><td><a href='?src=\ref[src];setfreq=\ref[frequency]'>Set Frequency</a></td></td></tr>"
	.+= "</table>"
	. = JOINTEXT(.)

/obj/machinery/atmospherics/unary/outlet_injector/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return
	if(href_list["toggle_power"])
		update_use_power(!use_power)
		queue_icon_update()
		to_chat(user, "<span class='notice'>The multitool emits a short beep confirming the change.</span>")
		return TOPIC_REFRESH
	if(href_list["settag"])
		var/t = sanitizeSafe(input(user, "Enter the ID tag for [src.name]", src.name, id), MAX_NAME_LEN)
		if(t && CanInteract(user, state))
			id = t
			to_chat(user, "<span class='notice'>The multitool emits a short beep confirming the change.</span>")
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	if(href_list["setfreq"])
		var/freq = input(user, "Enter the Frequency for [src.name]. Decimal will automatically be inserted", src.name, frequency) as num|null
		if(CanInteract(user, state))
			set_frequency(freq)
			to_chat(user, "<span class='notice'>The multitool emits a short beep confirming the change.</span>")
			return TOPIC_REFRESH
		return TOPIC_HANDLED

/obj/machinery/atmospherics/unary/outlet_injector/Process()
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/datum/gas_mixture/environment = loc.return_air()

	if(environment && air_contents.temperature > 0)
		var/transfer_moles = (volume_rate/air_contents.volume)*air_contents.total_moles //apply flow rate limit
		power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

		if(network)
			network.update = 1

	return 1

/obj/machinery/atmospherics/unary/outlet_injector/proc/inject()
	set waitfor = 0

	if(injecting || (stat & NOPOWER))
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	if (!environment)
		return 0

	injecting = 1

	if(air_contents.temperature > 0)
		var/power_used = pump_gas(src, air_contents, environment, air_contents.total_moles, power_rating)
		use_power_oneoff(power_used)

		if(network)
			network.update = 1

	flick("inject", src)

/obj/machinery/atmospherics/unary/outlet_injector/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/unary/outlet_injector/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AO",
		"power" = use_power,
		"volume_rate" = volume_rate,
		"sigtype" = "status"
	 )

	radio_connection.post_signal(src, signal)

	return 1

/obj/machinery/atmospherics/unary/outlet_injector/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || signal.data["tag"] != id || signal.data["sigtype"]!="command")
		return 0

	if(signal.data["power"])
		update_use_power(sanitize_integer(text2num(signal.data["power"]), POWER_USE_OFF, POWER_USE_ACTIVE, use_power))
		queue_icon_update()

	if(signal.data["power_toggle"] || signal.data["command"] == "valve_toggle") // some atmos buttons use "valve_toggle" as a command
		update_use_power(!use_power)
		queue_icon_update()

	if(signal.data["inject"])
		inject()
		return

	if(signal.data["set_volume_rate"])
		var/number = text2num(signal.data["set_volume_rate"])
		volume_rate = clamp(number, 0, air_contents.volume)

	if(signal.data["status"])
		addtimer(CALLBACK(src, .proc/broadcast_status), 2, TIMER_UNIQUE)
		return

	addtimer(CALLBACK(src, .proc/broadcast_status), 2, TIMER_UNIQUE)

/obj/machinery/atmospherics/unary/outlet_injector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/unary/outlet_injector/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(isMultitool(O))
		var/datum/browser/popup = new (user, "Vent Configuration Utility", "[src] Configuration Panel", 600, 200)
		popup.set_content(jointext(get_console_data(),"<br>"))
		popup.open()
		return

	if(isWrench(O))
		new /obj/item/pipe(loc, src)
		qdel(src)
		return
	return ..()