//For the sake of old code.
/proc/isassembly(O)
	if(istype(O, /obj/item/device/assembly))
		return 1
	return 0

/proc/isigniter(O)
	if(istype(O, /obj/item/device/assembly/igniter))
		return 1
	return 0

/proc/isinfared(O)
	if(istype(O, /obj/item/device/assembly/infra))
		return 1
	return 0

/proc/isprox(O)
	if(istype(O, /obj/item/device/assembly/prox_sensor))
		return 1
	return 0

/proc/issignaler(O)
	if(istype(O, /obj/item/device/assembly/signaler))
		return 1
	return 0

/proc/istimer(O)
	if(istype(O, /obj/item/device/assembly/timer))
		return 1
	return 0

/obj/item/device/assembly/proc/get_connected_devices()
//	add_debug_log("Getting linked devices: \[[src]\]")
	var/list/devices = list()
	if(connects_to.len && holder)
		for(var/i=1, i<=connects_to.len, i++)
			var/obj/O = holder.connected_devices[(text2num(connects_to[i]))]
			if(O) devices += O
	add_debug_log("Got linked devices: \[[src]:[devices.len]\]")
	return devices

/obj/item/device/assembly/proc/get_devices_connected_to()
//	add_debug_log("Getting devices linked to \[[src]\]")
	var/list/devices = list()
	if(!holder) return
	for(var/obj/item/device/assembly/connected in holder.connected_devices)
		if(src in connected.get_connected_devices())
			devices += connected

	add_debug_log("Got devices linked to \[[src]:[devices.len]\]")
	return devices

/obj/item/device/assembly_holder/proc/sending_pulse(var/obj/item/device/assembly/sender, var/obj/item/device/assembly/receiver)
	var/fail = 0
	for(var/obj/item/device/assembly/A in connected_devices)
		if(!A.holder_pulsing(sender, receiver))
			fail = 1 // So we can get all our reactions, not just the first one
	if(receiver.dangerous)
		var/log_str = "Dangerous Assembly triggered! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)"
		var/mob/mob = get_mob_by_key(src.fingerprintslast)
		var/last_touch_info = ""
		if(mob)
			last_touch_info = "(<A HREF='?_src_=holder;adminmoreinfo=\ref[mob]'>?</A>)"
		log_str += " Last touched by: [src.fingerprintslast][last_touch_info]"
		if(admin_messages)
			log_str += " <A href='?src=\ref[src];disableadmin=1'>(Safe)</a>"
			message_admins(log_str, 0, 1)
		log_game(log_str)
	if(advanced_settings["disablepulse"] == 1 || (!debug_mode && !prob(pulse_chance)))
		fail = 1
	var/index = recent_pulses.Find(sender)
	if(index)
		index += 1
		var/pulses = recent_pulses[index]
		if(pulses >= MAX_PULSE_COUNT) // We'll cut infinite loops, literally.
			sender.wire_holder.CutAll()
			var/turf/T = get_turf(src.loc)
			if(T) T.visible_message("<span class='danger'>\The [src] sparks dangerously!</span>")
			recent_pulses[index] = 0
		recent_pulses[index] += 1
		spawn(PULSE_DELAY)
			recent_pulses[index] -= 1
	if(fail)
		add_debug_log("Sending pulse interrupted! \[[sender] > [receiver]\]")
		return 0
	return 1

/obj/item/device/assembly_holder/proc/door_opened(var/forced = 0) // Tried to avoid this..
	var/failed = 0
	for(var/obj/item/device/assembly/A in connected_devices)
		if(!A.door_opened(forced)) failed = 1
	if(failed)
		return 0
	return 1

/obj/item/device/assembly_holder/proc/attached_to(var/obj/machinery/M)
	for(var/obj/item/device/assembly/A in connected_devices)
		A.attached_to(M)
	return 1

/obj/item/device/assembly_holder/proc/detatched_from(var/obj/machinery/M)
	var/failed = 0
	for(var/obj/item/device/assembly/A in connected_devices)
		if(!A.detatched_from(M))
			failed = 1
	if(failed)
		return 0
	return 1

/obj/item/device/assembly_holder/proc/anchored(anchored, mob/user)
	update_holder()
	var/fail = 0
	for(var/obj/item/device/assembly/A in connected_devices)
		if(!A.anchored(!anchored, user))
			fail = 1
	if(fail) return 0
	spawn(0) anchored = !anchored
	return 1

/obj/item/device/assembly/proc/add_debug_log(var/message as text)
	if(holder) holder.add_debug_log(message)

/obj/item/device/assembly_holder/proc/add_debug_log(var/message as text)
	if(message)
		if(logs.len >= MAX_LOG_LENGTH)
			logs.Cut(1, 2)
		logs.Add(message)
		if(debug_mode)
			world << message

/obj/item/device/assembly_holder/proc/get_index(var/obj/item/device/assembly/A)
	if(!A || !istype(A) || !A in connected_devices) return 0
	for(var/i=1,i<=connected_devices.len,i++)
		var/obj/item/device/assembly/device = connected_devices[i]
		if(device == A)
			return i
	return 0

/obj/item/device/assembly/proc/get_index(var/obj/item/device/assembly/A)
	if(holder)
		return holder.get_index(A)
	return 0

/obj/item/device/assembly/proc/IndexHasSafety(var/index) // Wire proc
	if(wires & index)
		for(var/obj/item/device/assembly/A in get_devices_connected_to())
			if(A.has_safety(index))
				return 1
	return 0

/obj/item/device/assembly_holder/proc/admin_access(var/mob/user)
	if(advanced_settings["noadmin"]==1 || debug_mode) return 1
	var/inp = input(user, "Enter admin password")
	if(inp == password)
		return 1
	user << "<span class='warning'>Access denied!</span>"
	return 0

//Miscellaneous procs.
/obj/item/device/assembly/proc/holder_pulsing(var/obj/item/device/assembly/sender, var/obj/item/device/assembly/receiver) // ^^
	return 1
/obj/item/device/assembly/proc/holder_movement() // Called when the holder moves (e.g. pulling, throwing)
	return 1
/obj/item/device/assembly/proc/holder_disconnect() // Called when the device is being removed from it's holder
	return 1
/obj/item/device/assembly/proc/misc_activate() // Skips wire checking (though has optional wire) and is not called by default.
	return 1
/obj/item/device/assembly/proc/igniter_act() // Called when an igniter tries to ignite us.
	return 1
/obj/item/device/assembly/proc/process_success() // Called by process_activation() when activate() succeeds.
	return 1
/obj/item/device/assembly/proc/get_charge() // Gets the charge of any power sources.
	return 0
/obj/item/device/assembly/proc/holder_attack_self(var/mob/user) // Called when the user tries to interact with us.
	return 1
/obj/item/device/assembly/proc/holder_attack_hand() // Called (usually) when the holder is picked up or somethin'.
	return holder_movement()
/obj/item/device/assembly/proc/holder_click(target, mob/user, proximity_flag, click_parameters) // Called when the holder is in someones hand when they click on something
	return 1
/obj/item/device/assembly/proc/misc_special(var/mob/M, var/mob/user) // Anything to do with mob references goes here.
	return 1
/obj/item/device/assembly/proc/holder_attach(var/mob/user) // What happens when it's attached.
	return 1
/obj/item/device/assembly/proc/wire_safety(var/index = 0, var/pulsed = 0) // Sensitive equipment can sometimes detect wires being cut.
	return 1
/obj/item/device/assembly/proc/holder_wire_safety(var/obj/item/device/assembly/A, var/index, var/pulsed) // Called when something is cut/pulsed
	return 1
/obj/item/device/assembly/proc/implanted(var/mob/living/carbon/C) // Called by holder when implanted
	return 1
/obj/item/device/assembly/proc/implant_process(var/mob/living/carbon/C) // Called by holder process() while implanted.
	return 1
/obj/item/device/assembly/proc/attached(var/mob/living/carbon/C) // Same as above, but when attached.
	return 1
/obj/item/device/assembly/proc/attached_process(var/mob/living/carbon/C) // ...
	return 1
/obj/item/device/assembly/proc/door_opened(var/forced = 0) // Called when an attached door opens.
	return 1
/obj/item/device/assembly/proc/attached_to(var/obj/machinery/M) // Called when attached to a machine e.g airlock
	return 1
/obj/item/device/assembly/proc/detatched_from(var/obj/machinery/M) // Called when detatched from a machine.
	return 1
/obj/item/device/assembly/proc/anchored(var/anchored, var/mob/user) // Called when it's anchored.
	return 1
/obj/item/device/assembly/proc/attempt_get_power_amount(var/obj/item/device/assembly/A, var/amount) // Called when something is searching for a power source.
	return 0
/obj/item/device/assembly/proc/disposal_trigger(var/obj/structure/disposalpipe/target) // Called when a disposal pipe has something going through it
	return 1
/obj/item/device/assembly/proc/holder_interface(var/mob/user) // Whether or not a user can access wires/settings.
	return 1
/obj/item/device/assembly/proc/holder_can_remove() // Whether or not ANYTHING can be removed.
	return 1
/obj/item/device/assembly/proc/has_safety(var/index) // Wire safeties.
	return 0
/obj/item/device/assembly/proc/signal_failure(var/sent = 0) // Called when signals are failed.
	return 1
/obj/item/device/assembly/proc/holder_hear_talk(mob/living/M, msg) // Called when signals are failed.
	return 0


