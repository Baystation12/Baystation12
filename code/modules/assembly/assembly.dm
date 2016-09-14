#define MAX_PULSE_COUNT 20 //How many pulses can happen within pulse_delay before an infinite loop is detected.
#define PULSE_DELAY 15 // The amount of time after a pulse before the pulse_count is reduced.
#define MAX_LOG_LENGTH 30 // The max debug log messages stored.
/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	flags = CONDUCT
	w_class = 2.0
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 1)
	var/reliability = 90

	var/datum/wires/assembly/wire_holder = null
	var/tmp/wire_num = 3 // Make sure to set this correctly.
	var/wires = WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_PROCESS_RECEIVE
	var/active_wires = 0
	var/list/examined_additions = list()

	var/weight = 1

	var/list/holder_attackby = list() // Anything in this list automatically transfers from holder.attackby() to src.attackby()

	var/radio = 0 // All assemblies can have a radio
	var/datum/radio_frequency/radio_connection
	var/code = 29
	var/frequency = 1457

	var/locked = 0 // Cannot be accessed in the ui_interact.
	var/obj/item/device/assembly_holder/holder = null
	var/list/connects_to = list()		// Sends a pulse to these. Refer to them as; holder.connected_devices[index]
	// Reason behind this is that indexes are very convenient with certain interactions, like swapping item positions
	// as opposed to straight references or associative lists.

	var/implantable = 0
	var/attachable = 0
	var/dangerous = 0 //Sends admin messages.

	var/interface_name = "" // Used for the interface when there are multiple of the same devices

	var/broken = 0

/obj/item/device/assembly/proc/send_data(var/list/data) // More complex signals.
	add_debug_log("Sending data \[[src]([data.len])\]")
	var/failed = 0
	if(active_wires & WIRE_MISC_CONNECTION)
		if(process_signals(1))
			for(var/obj/item/device/assembly/A in get_connected_devices())
				add_debug_log("Sent data \[[src] : [A]\]")
				if(!holder.sending_pulse(src, A))
					break
				if(!A.process_receive_data(data, src))
					failed = 1
	return !failed

/obj/item/device/assembly/proc/process_receive_data(var/list/data, var/obj/item/device/assembly/sender)
	add_debug_log("Receiving Data \[[src]\]")
	if(active_wires & WIRE_MISC_CONNECTION)
		if(!data.len) return 0
		var/changed_var = 0
		if(process_signals(0))
			for(var/index=1,index<=data.len,index++)
				var/T=data[index]
				if(istext(T) && lowertext(T) == "activate")
					process_activation()
				if(data.len > index && !(index&2))
					var/to_set = data[(index+1)]
					add_debug_log("Checking settings compatibility \[[src]\]: \"[T]\" : \"[to_set]\"")
					var/list/var_data = src.get_data() // Gets a list of 'user-accessible' vars. E.G var_data["Time Remaining", time_var]. Not associative, easier to work with in ui.
					for(var/i=1;i<=var_data.len;i+=2)
						if(lowertext(T) == lowertext(var_data[i]))
							if(isnum(src.vars[T]))
								to_set = text2num(to_set)
							vars[T] = to_set
							add_debug_log("Changing settings\[[src]\]: Setting \"[T]\" to \"[(vars[T])]\"")
							changed_var = 1
			if(!changed_var || holder.advanced_settings["forceprocess"])
				add_debug_log("Processing data..\[[src]\]")
				receive_data(data, sender)
			return 1
	return 0

/obj/item/device/assembly/proc/receive_data(var/list/data, var/obj/item/device/assembly/sender) // What happens when something tries to send us some data
	return 1

/obj/item/device/assembly/attack_self(var/mob/user)
	ui_interact(user)
	..()

/obj/item/device/assembly/proc/get_nonset_data(var/mob/user, var/ui_key)
	return 1

/obj/item/device/assembly/proc/get_ai_data(var/mob/user, var/ui_key)
	return 1

/obj/item/device/assembly/proc/get_help_info(var/mob/user, var/ui_key)
	return 1

/obj/item/device/assembly/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nano_ui/master_ui = null, var/datum/topic_state/state = default_state)
	user.set_machine(user)
	var/list/data = list()
	var/list/devices = list()
	if(holder) // Not using associative lists for ui.
		for(var/obj/item/device/assembly/A in holder.connected_devices) // We need the index AND object, can't use helper procs.
			var/index = get_index(A)
			if(index)
				if(num2text(index) in connects_to)
					devices.Add(A.interface_name, index)
					add_debug_log("Connected device: [src]:[A.name]")
	if(issilicon(user)) // As of yet unused.
		data["ai"] = 1
	else
		data["ai"] = 0
	data["ai_data"] = get_ai_data(user, ui_key)
	data["connected_devices"] = devices
	data["extra_data"] = get_data(user, ui_key)
	data["extra_buttons"] = get_buttons(user, ui_key)
	data["nonset_data"] = get_nonset_data(user, ui_key)
	data["help"] = get_help_info(user, ui_key)
	data["broken"] = broken

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "assembly.tmpl", src.name, state = state)
		ui.set_initial_data(data)
		ui.open()

//Index 1 for the button text, index 2 for a VARIABLE to associate with.
/obj/item/device/assembly/proc/get_data(var/mob/user, var/ui_key)
	return 1

/obj/item/device/assembly/proc/get_buttons(user, ui_key)
	return 1

/obj/item/device/assembly/Topic(href, href_list)
	var/datum/nanoui/ui = nanomanager.get_open_ui(usr, src, "main")
	if(href_list["disconnect"])
		if(href_list["disconnect"] in connects_to)
			var/list/new_connects_to = connects_to.Copy()
			new_connects_to.Remove(href_list["disconnect"])
			for(var/i=1,i<=new_connects_to.len,i++)
				if(new_connects_to[i] == null || new_connects_to[i] == 0)
					new_connects_to.Cut(i, i+1)
			connects_to = new_connects_to
	if(href_list["settings"])
		var/index = href_list["settings"]
		if(!(index % 2) && holder)
			add_debug_log("[holder.connected_devices[text2num(index)]]")
			var/obj/item/device/assembly/opened = holder.connected_devices[text2num(index)]
			if(opened)
				add_debug_log("Interacting with [opened.name]")
				opened.ui_interact(usr, "main", null, 1)
	if(href_list["wiring"])
		add_debug_log("Settings: [href_list["settings"]]")
		var/index = href_list["wiring"]
		if(!(index % 2) && holder)
			add_debug_log("[holder.connected_devices[text2num(index)]]")
			var/obj/item/device/assembly/opened = holder.connected_devices[text2num(index)]
			if(opened)
				if(opened.wire_holder)
					usr.set_machine(opened)
					opened.wire_holder.Interact(usr)
	if(href_list["activate"])
		usr << "You activate \the [src]!"
		process_activation()
	if(href_list["option"])
		switch(href_list["option"])
			if("close")
				ui.close()

	src.add_fingerprint(usr)
	nanomanager.update_uis(src)

/obj/item/device/assembly/receive_signal(var/datum/signal/signal)
	if(istype(signal))
		src.receive_radio_pulse(signal)
	return

/obj/item/device/assembly/New()
	..()
	wires |= WIRE_ASSEMBLY_PASSWORD
	active_wires = wires
	wire_holder = new (src, (wire_num+1)) // Hacky way of doing it.
	interface_name = name

/obj/item/device/assembly/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	if(wire_holder)
		qdel(wire_holder)
	if(holder)
		holder.remove_connected_device(src)
	sleep(0) // Let the holder do its thang
	..()

/obj/item/device/assembly/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	if(!radio_controller)
		sleep(20)
	if(!radio_controller)
		return
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)
	return

/obj/item/device/assembly/proc/receive_direct_pulse(var/obj/item/device/assembly/sender) // Sender not used often.
	add_debug_log("Received pulse \[[src]\]")
	if(WIRE_DIRECT_RECEIVE)
		if(process_signals(0))
			process_activation(0)

/obj/item/device/assembly/proc/receive_radio_pulse(var/datum/signal/signal)
	add_debug_log("Radio pulse received \[[src]\]")
	if(!(active_wires & WIRE_RADIO_RECEIVE)) return
	if(!signal || !istype(signal) || signal.source == src) // Just in case
		return
	if(signal.encryption == code)
		if(process_signals(0))
			if(signal.data["message"] == "ACTIVATE")
				process_activation()

/obj/item/device/assembly/proc/process_signals(var/sent = 0)
	add_debug_log("Processing signals\[[src]\]")
	if(sent && active_wires & (WIRE_PROCESS_SEND))
		return 1
	else if(!sent && active_wires & (WIRE_PROCESS_RECEIVE))
		return 1
	add_debug_log("Signal failure! \[[src]:[sent?"(sending)":"(receiving)"]\]")
	signal_failure(sent)
	return 0

/obj/item/device/assembly/proc/process_activation()
	add_debug_log("Processing Activation \[[src]\]")
	if(active_wires & WIRE_PROCESS_ACTIVATE)
		if(activate())
			add_debug_log("Processing Activation Success \[[src]\]")
			process_success()
			return 1
	return 0

/obj/item/device/assembly/proc/activate() // Default action is just to send pulse to the connected objects.
	send_pulse_to_connected()			  // There should be no cases where this is called directly. Use
	return 1							  // process_activation() or misc_activate() instead.

/obj/item/device/assembly/proc/send_pulse_to_connected()
	add_debug_log("Sending pulse to connected \[[src]\]")
	for(var/obj/item/device/assembly/O in get_connected_devices())
		send_direct_pulse(O)
	return 1

/obj/item/device/assembly/proc/send_direct_pulse(var/obj/item/device/assembly/O)
	add_debug_log("Sending pulse \[[src]\]")
	if(holder)
		if(!holder.sending_pulse(src, O))
			add_debug_log("Unable to send pulse! Connection error \[[src]:[O]\]")
			return 0
	if(active_wires & WIRE_DIRECT_SEND)
		if(istype(O))
			if(process_signals(1))
				add_debug_log("Pulsed: \[[O]\]")
				O.receive_direct_pulse(src)
				return 1
	return 0

/obj/item/device/assembly/proc/send_radio_pulse(var/list/data)
	if(!data || !data.len)
		data = list("ACTIVATE")
	add_debug_log("Sending radio signal: \[[src]\]")
	if(active_wires & WIRE_RADIO_SEND)
		if(process_signals(1))
			if(!radio_connection) return 0

			var/datum/signal/signal = new
			signal.source = src
			signal.encryption = code
			signal.data = data
			radio_connection.post_signal(src, signal)
			add_debug_log("Successfully sent radio signal \[[src]\]")
			return 1
	return 0

/obj/item/device/assembly/attackby(var/obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/device/multitool) || istype(O, /obj/item/weapon/wirecutters))
		if(!wires) return
		wire_holder.Interact(user)
	..()

/obj/item/device/assembly/proc/draw_power(var/amount = 0)
	add_debug_log("Drawing power: \[[src]:([amount]w)\]")
	if(active_wires & WIRE_POWER_RECEIVE)
		for(var/obj/item/device/assembly/A in get_devices_connected_to())
			if(istype(A))
				add_debug_log("Finding power source: [A.name]")
				if(A.attempt_get_power_amount(src, amount))
					add_debug_log("Drawing power success\[[src]:([amount]w)\]")
					return 1
	add_debug_log("Power draw failure! \[[src]:([amount]w)\]")
	return 0

/obj/item/device/assembly/proc/detatch() // For the sake of old code.
	if(holder)
		src.holder.remove_connected_device(src)

/obj/item/device/assembly/emp_act(var/severity = 0)
	switch(severity)
		if(1)
			if(wire_holder)
				wire_holder.RandomCutAll(90)
			broken = 1
		if(2)
			if(wire_holder)
				wire_holder.RandomCutAll(50)
			if(prob(45))
				broken = 1
		if(1)
			if(wire_holder)
				wire_holder.RandomCutAll(25)
			if(prob(30))
				broken = 1



/*
/obj/item/device/assembly/nano_host()
    if(istype(loc, /obj/item/device/assembly_holder))
        return loc.nano_host()
    return ..()

	var/small_icon_state = null//If this obj will go inside the assembly use this for icons
	var/list/small_icon_state_overlays = null//Same here
	var/obj/holder = null
	var/cooldown = 0//To prevent spam

*/





