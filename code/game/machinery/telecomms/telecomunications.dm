//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	Hello, friends, this is Doohl from sexylands. You may be wondering what this
	monstrous code file is. Sit down, boys and girls, while I tell you the tale.


	The machines defined in this file were designed to be compatible with any radio
	signals, provided they use subspace transmission. Currently they are only used for
	headsets, but they can eventually be outfitted for real COMPUTER networks. This
	is just a skeleton, ladies and gentlemen.

	Look at radio.dm for the prequel to this code.
*/

var/global/list/obj/machinery/telecomms/telecomms_list = list()

/obj/machinery/telecomms
	var/list/links = list() // list of machines this machine is linked to
	var/traffic = 0 // value increases as traffic increases
	var/netspeed = 5 // how much traffic to lose per tick (50 gigabytes/second * netspeed)
	var/list/autolinkers = list() // list of text/number values to link with
	var/id = "NULL" // identification string
	var/network = "NULL" // the network of the machinery

	var/list/freq_listening = list() // list of frequencies to tune into: if none, will listen to all
	var/list/channel_tags = list() // a list specifying what to tag packets on different frequencies

	var/machinetype = 0 // just a hacky way of preventing alike machines from pairing
	var/toggled = 1 	// Is it toggled on
	var/on = 1
	var/integrity = 100 // basically HP, loses integrity by heat
	var/produces_heat = 1	//whether the machine will produce heat when on.
	var/delay = 10 // how many process() ticks to delay per heat
	var/long_range_link = 0	// Can you link it across Z levels or on the otherside of the map? (Relay & Hub)
	var/circuitboard = null // string pointing to a circuitboard type
	var/hide = 0				// Is it a hidden machine?
	var/listening_levels = null	// null = auto set in Initialize() - these are the z levels that the machine is listening to.
	var/overloaded_for = 0
	var/outage_probability = 75			// Probability of failing during a ionospheric storm


/obj/machinery/telecomms/proc/relay_information(datum/signal/signal, filter, copysig, amount = 20)
	// relay signal to all linked machinery that are of type [filter]. If signal has been sent [amount] times, stop sending

	if(!on || overloaded_for)
		return
//	log_debug("[src] ([src.id]) - [signal.debug_print()]")

	var/send_count = 0

	signal.data["slow"] += rand(0, round((100-integrity))) // apply some lag based on integrity

	/*
	// Edit by Atlantis: Commented out as emergency fix due to causing extreme delays in communications.
	// Apply some lag based on traffic rates
	var/netlag = round(traffic / 50)
	if(netlag > signal.data["slow"])
		signal.data["slow"] = netlag
	*/
// Loop through all linked machines and send the signal or copy.
	for(var/obj/machinery/telecomms/machine in links)
		if(filter && !istype( machine, filter ))
			continue
		if(!machine.on)
			continue
		if(amount && send_count >= amount)
			break
		if(!(machine.loc.z in listening_levels))
			if(long_range_link == 0 && machine.long_range_link == 0)
				continue
		// If we're sending a copy, be sure to create the copy for EACH machine and paste the data
		var/datum/signal/copy
		if(copysig)
			copy = new
			copy.transmission_method = 2
			copy.frequency = signal.frequency
			copy.data = signal.data.Copy()

			// Keep the "original" signal constant
			if(!signal.data["original"])
				copy.data["original"] = signal
			else
				copy.data["original"] = signal.data["original"]

		send_count++
		if(machine.is_freq_listening(signal))
			machine.traffic++

		if(copysig && copy)
			machine.receive_information(copy, src)
		else
			machine.receive_information(signal, src)


	if(send_count > 0 && is_freq_listening(signal))
		traffic++

	return send_count

/obj/machinery/telecomms/proc/relay_direct_information(datum/signal/signal, obj/machinery/telecomms/machine)
	// send signal directly to a machine
	machine.receive_information(signal, src)

/obj/machinery/telecomms/proc/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	// receive information from linked machinery

/obj/machinery/telecomms/proc/is_freq_listening(datum/signal/signal)
	// return 1 if found, 0 if not found
	if(!signal)
		return 0
	if((signal.frequency in freq_listening) || (!freq_listening.len))
		return 1
	else
		return 0


/obj/machinery/telecomms/New()
	telecomms_list += src
	..()

/obj/machinery/telecomms/Initialize()
	//Set the listening_levels if there's none.
	if(!listening_levels)
		//Defaults to our Z level!
		var/turf/position = get_turf(src)
		listening_levels = GetConnectedZlevels(position.z)

	if(autolinkers.len)
		// Links nearby machines
		if(!long_range_link)
			for(var/obj/machinery/telecomms/T in orange(20, src))
				add_link(T)
		else
			for(var/obj/machinery/telecomms/T in telecomms_list)
				add_link(T)
	. = ..()
	update_power()

/obj/machinery/telecomms/Destroy()
	telecomms_list -= src
	for(var/obj/machinery/telecomms/comm in telecomms_list)
		comm.links -= src
	links = list()
	..()

// Used in auto linking
/obj/machinery/telecomms/proc/add_link(var/obj/machinery/telecomms/T)
	var/turf/position = get_turf(src)
	var/turf/T_position = get_turf(T)
	if((position.z == T_position.z) || (src.long_range_link && T.long_range_link))
		for(var/x in autolinkers)
			if(T.autolinkers.Find(x))
				if(src != T)
					links |= T

/obj/machinery/telecomms/on_update_icon()
	if(on && !overloaded_for)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/telecomms/Move()
	. = ..()
	listening_levels = GetConnectedZlevels(z)
	update_power()

/obj/machinery/telecomms/forceMove(var/newloc)
	. = ..(newloc)
	listening_levels = GetConnectedZlevels(z)
	update_power()

/obj/machinery/telecomms/proc/update_power()
	if(toggled)
		if(stat & (BROKEN|NOPOWER|EMPED) || integrity <= 0) // if powered, on. if not powered, off. if too damaged, off
			on = 0
		else
			on = 1
	else
		on = 0
	update_use_power(on)

/obj/machinery/telecomms/Process()
	update_power()

	if(overloaded_for)
		overloaded_for--

	// Check heat and generate some
	checkheat()

	// Update the icon
	update_icon()

	if(traffic > 0)
		traffic -= netspeed

/obj/machinery/telecomms/emp_act(severity)
	if(prob(100/severity))
		overloaded_for = max(round(150 / severity), overloaded_for)
	..()

/obj/machinery/telecomms/proc/checkheat()
	// Checks heat from the environment and applies any integrity damage
	var/datum/gas_mixture/environment = loc.return_air()
	var/damage_chance = 0                           // Percent based chance of applying 1 integrity damage this tick
	switch(environment.temperature)
		if((T0C + 40) to (T0C + 70))                // 40C-70C, minor overheat, 10% chance of taking damage
			damage_chance = 10
		if((T0C + 70) to (T0C + 130))				// 70C-130C, major overheat, 25% chance of taking damage
			damage_chance = 25
		if((T0C + 130) to (T0C + 200))              // 130C-200C, dangerous overheat, 50% chance of taking damage
			damage_chance = 50
		if((T0C + 200) to INFINITY)					// More than 200C, INFERNO. Takes damage every tick.
			damage_chance = 100
	if (damage_chance && prob(damage_chance))
		integrity = between(0, integrity - 1, 100)


	if(delay > 0)
		delay--
	else if(on)
		produce_heat()
		delay = initial(delay)



/obj/machinery/telecomms/proc/produce_heat()
	if (!produces_heat)
		return

	if (!use_power)
		return

	if(!(stat & (NOPOWER|BROKEN)))
		var/turf/simulated/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()

			var/transfer_moles = 0.25 * env.total_moles

			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)

				var/heat_produced = idle_power_usage	//obviously can't produce more heat than the machine draws from it's power source
				if (traffic <= 0)
					heat_produced *= 0.30	//if idle, produce less heat.

				removed.add_thermal_energy(heat_produced)

			env.merge(removed)
/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. They then just relay this information to all linked devices,
	which can would probably be network hubs.

	Link to Processor Units in case receiver can't send to bus units.
*/

/obj/machinery/telecomms/receiver
	name = "Subspace Receiver"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	density = 1
	anchored = 1
	idle_power_usage = 600
	machinetype = 1
	produces_heat = 0
	circuitboard = /obj/item/weapon/stock_parts/circuitboard/telecomms/receiver
	base_type = /obj/machinery/telecomms/receiver
	outage_probability = 10

/obj/machinery/telecomms/receiver/receive_signal(datum/signal/signal)

	if(!on) // has to be on to receive messages
		return
	if(!signal)
		return
	if(!check_receive_level(signal))
		return

	if(signal.transmission_method == 2)

		if(is_freq_listening(signal)) // detect subspace signals

			//Remove the level and then start adding levels that it is being broadcasted in.
			signal.data["level"] = list()

			var/can_send = relay_information(signal, /obj/machinery/telecomms/hub) // ideally relay the copied information to relays
			if(!can_send)
				relay_information(signal, /obj/machinery/telecomms/bus) // Send it to a bus instead, if it's linked to one

/obj/machinery/telecomms/receiver/proc/check_receive_level(datum/signal/signal)

	if(!(signal.data["level"] in listening_levels))
		return 0
	return 1


/*
	The HUB idles until it receives information. It then passes on that information
	depending on where it came from.

	This is the heart of the Telecommunications Network, sending information where it
	is needed. It mainly receives information from long-distance Relays and then sends
	that information to be processed. Afterwards it gets the uncompressed information
	from Servers/Buses and sends that back to the relay, to then be broadcasted.
*/

/obj/machinery/telecomms/hub
	name = "Telecommunication Hub"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "hub"
	desc = "A mighty piece of hardware used to send/receive massive amounts of data."
	density = 1
	anchored = 1
	idle_power_usage = 1600
	machinetype = 7
	circuitboard = /obj/item/weapon/stock_parts/circuitboard/telecomms/hub
	base_type = /obj/machinery/telecomms/hub
	long_range_link = 1
	netspeed = 40
	outage_probability = 10

/obj/machinery/telecomms/hub/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	if(is_freq_listening(signal))
		if(istype(machine_from, /obj/machinery/telecomms/receiver))
			//If the signal is compressed, send it to the bus.
			relay_information(signal, /obj/machinery/telecomms/bus, 1) // ideally relay the copied information to bus units
		else
			relay_information(signal, /obj/machinery/telecomms/broadcaster, 1) // Send it to a broadcaster.

/*
	The bus mainframe idles and waits for hubs to relay them signals. They act
	as junctions for the network.

	They transfer uncompressed subspace packets to processor units, and then take
	the processed packet to a server for logging.

	Link to a subspace hub if it can't send to a server.
*/

/obj/machinery/telecomms/bus
	name = "Bus Mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bus"
	desc = "A mighty piece of hardware used to send massive amounts of data quickly."
	density = 1
	anchored = 1
	idle_power_usage = 1000
	machinetype = 2
	circuitboard = /obj/item/weapon/stock_parts/circuitboard/telecomms/bus
	base_type = /obj/machinery/telecomms/bus
	netspeed = 40
	var/change_frequency = 0

/obj/machinery/telecomms/bus/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	if(is_freq_listening(signal))

		if(change_frequency)
			signal.frequency = change_frequency

		if(!istype(machine_from, /obj/machinery/telecomms/processor) && machine_from != src) // Signal must be ready (stupid assuming machine), let's send it
			// send to one linked processor unit
			var/send_to_processor = relay_information(signal, /obj/machinery/telecomms/processor)

			if(send_to_processor)
				return
			// failed to send to a processor, relay information anyway
			signal.data["slow"] += rand(1, 5) // slow the signal down only slightly
			src.receive_information(signal, src)

		// Try sending it!
		var/list/try_send = list(/obj/machinery/telecomms/server, /obj/machinery/telecomms/hub, /obj/machinery/telecomms/broadcaster, /obj/machinery/telecomms/bus)
		var/i = 0
		for(var/send in try_send)
			if(i)
				signal.data["slow"] += rand(0, 1) // slow the signal down only slightly
			i++
			var/can_send = relay_information(signal, send)
			if(can_send)
				break



/*
	The processor is a very simple machine that decompresses subspace signals and
	transfers them back to the original bus. It is essential in producing audible
	data.

	Link to servers if bus is not present
*/

/obj/machinery/telecomms/processor
	name = "Processor Unit"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "processor"
	desc = "This machine is used to process large quantities of information."
	density = 1
	anchored = 1
	idle_power_usage = 600
	machinetype = 3
	delay = 5
	circuitboard = /obj/item/weapon/stock_parts/circuitboard/telecomms/processor
	base_type = /obj/machinery/telecomms/processor
	var/process_mode = 1 // 1 = Uncompress Signals, 0 = Compress Signals

/obj/machinery/telecomms/processor/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	if(!is_freq_listening(signal))
		return

	if(process_mode)
		signal.data["compression"] = 0 // uncompress subspace signal
	else
		signal.data["compression"] = 100 // even more compressed signal

	if(istype(machine_from, /obj/machinery/telecomms/bus))
		relay_direct_information(signal, machine_from) // send the signal back to the machine
	else // no bus detected - send the signal to servers instead
		signal.data["slow"] += rand(5, 10) // slow the signal down
		relay_information(signal, /obj/machinery/telecomms/server)


/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster.

	Store a maximum of 100 logs and then deletes them.
*/


/obj/machinery/telecomms/server
	name = "Telecommunication Server"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A machine used to store data and network statistics."
	density = 1
	anchored = 1
	idle_power_usage = 300
	machinetype = 4
	circuitboard = /obj/item/weapon/stock_parts/circuitboard/telecomms/server
	base_type = /obj/machinery/telecomms/server
	var/list/log_entries = list()
	var/list/stored_names = list()
	var/list/TrafficActions = list()
	var/logs = 0 // number of logs
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

	var/list/memory = list()	// stored memory
	var/encryption = "null" // encryption key: ie "password"
	var/salt = "null"		// encryption salt: ie "123comsat"
							// would add up to md5("password123comsat")
	var/language = "human"
	var/obj/item/device/radio/headset/server_radio = null

/obj/machinery/telecomms/server/New()
	..()
	server_radio = new()

/obj/machinery/telecomms/server/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	if(signal.data["message"])

		if(is_freq_listening(signal))

			if(traffic > 0)
				totaltraffic += traffic // add current traffic to total traffic

			// channel tag the signal
			var/list/data = get_channel_info(signal.frequency)
			signal.data["channel_tag"] = data[1]
			signal.data["channel_color"] = data[2]

			//Is this a test signal? Bypass logging
			if(signal.data["type"] != 4)

				// If signal has a message and appropriate frequency

				update_logs()

				var/datum/comm_log_entry/log = new
				var/mob/M = signal.data["mob"]

				// Copy the signal.data entries we want
				log.parameters["mobtype"] = signal.data["mobtype"]
				log.parameters["job"] = signal.data["job"]
				log.parameters["key"] = signal.data["key"]
				log.parameters["vmessage"] = signal.data["message"]
				log.parameters["vname"] = signal.data["vname"]
				log.parameters["message"] = signal.data["message"]
				log.parameters["name"] = signal.data["name"]
				log.parameters["realname"] = signal.data["realname"]
				log.parameters["language"] = signal.data["language"]

				var/race = "Unknown"
				if(ishuman(M) || isbrain(M))
					race = "Sapient Race"
					log.parameters["intelligible"] = 1
				else if(M.isMonkey())
					race = "Monkey"
				else if(issilicon(M))
					race = "Artificial Life"
					log.parameters["intelligible"] = 1
				else if(isslime(M))
					race = "Slime"
				else if(isanimal(M))
					race = "Domestic Animal"

				log.parameters["race"] = race

				if(!istype(M, /mob/new_player) && M)
					log.parameters["uspeech"] = M.universal_speak
				else
					log.parameters["uspeech"] = 0

				// If the signal is still compressed, make the log entry gibberish
				if(signal.data["compression"] > 0)
					log.parameters["message"] = Gibberish(signal.data["message"], signal.data["compression"] + 50)
					log.parameters["job"] = Gibberish(signal.data["job"], signal.data["compression"] + 50)
					log.parameters["name"] = Gibberish(signal.data["name"], signal.data["compression"] + 50)
					log.parameters["realname"] = Gibberish(signal.data["realname"], signal.data["compression"] + 50)
					log.parameters["vname"] = Gibberish(signal.data["vname"], signal.data["compression"] + 50)
					log.input_type = "Corrupt File"

				// Log and store everything that needs to be logged
				log_entries.Add(log)
				if(!(signal.data["name"] in stored_names))
					stored_names.Add(signal.data["name"])
				logs++
				signal.data["server"] = src

				// Give the log a name
				var/identifier = num2text( rand(-1000,1000) + world.time )
				log.name = "data packet ([md5(identifier)])"

			var/can_send = relay_information(signal, /obj/machinery/telecomms/hub)
			if(!can_send)
				relay_information(signal, /obj/machinery/telecomms/broadcaster)

/obj/machinery/telecomms/server/proc/update_logs()
	// start deleting the very first log entry
	if(logs >= 400)
		for(var/i = 1, i <= logs, i++) // locate the first garbage collectable log entry and remove it
			var/datum/comm_log_entry/L = log_entries[i]
			if(L.garbage_collector)
				log_entries.Remove(L)
				logs--
				break

/obj/machinery/telecomms/server/proc/add_entry(var/content, var/input)
	var/datum/comm_log_entry/log = new
	var/identifier = num2text( rand(-1000,1000) + world.time )
	log.name = "[input] ([md5(identifier)])"
	log.input_type = input
	log.parameters["message"] = content
	log_entries.Add(log)
	update_logs()

/obj/machinery/telecomms/server/proc/get_channel_info(var/freq)
	for(var/list/rule in channel_tags)
		if(rule[1] == freq)
			return list(rule[2], rule[3])
	return list(format_frequency(freq), channel_color_presets["Global Green"])


// Simple log entry datum

/datum/comm_log_entry
	var/parameters = list() // carbon-copy to signal.data[]
	var/name = "data packet (#)"
	var/garbage_collector = 1 // if set to 0, will not be garbage collected
	var/input_type = "Speech File"







