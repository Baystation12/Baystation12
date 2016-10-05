/obj/item/device/assembly/explosive/strong
	name = "big explosive"
	desc = "This looks like it could do some real damage..It needs to charge up first though."
	icon_state = "strong_explosive"
	w_class = 4.0
	slot_flags = null
	throw_range = 2
	throw_speed = 1
	power = 1
	var/failure = 0

	var/counting_down = 0
	var/count = 0

	var/init_count = 500
	var/explosive_count = 500
	var/explosive_counting = 0

	weight = 10
	// Which one do I cut? The red wire? No no no, it's always the blue wire!
	wires = WIRE_MISC_ACTIVATE | WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_ASSEMBLY_SAFETY
	wire_num = 7
	// To disarm, you must disable the safety, cut the activation wire, and re-enable the safety.
	activate()
		explosive_counting = 1

/obj/item/device/assembly/explosive/strong/New()
	..()
	processing_objects.Add(src)

/obj/item/device/assembly/explosive/strong/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/device/assembly/explosive/strong/igniter_act()
	activate()

/obj/item/device/assembly/explosive/strong/holder_disconnect()
	if(explosive_counting)
		return 0
	return 1

/obj/item/device/assembly/explosive/strong/wire_safety(var/index = 0, var/pulsed = 0)
	if(!pulsed)
		if(index == WIRE_ASSEMBLY_SAFETY)
			counting_down = 1
		else if(active_wires & WIRE_ASSEMBLY_SAFETY)
			counting_down = 1

/obj/item/device/assembly/explosive/strong/get_data()
	var/list/data = list()
	data.Add("Explosive Charge Progress", explosive_count)
	return data

/obj/item/device/assembly/explosive/strong/get_buttons()
	var/list/data = list()
	data.Add("Activate")
	return data

/obj/item/device/assembly/explosive/strong/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Explosive Charge Progress")
				if(explosive_counting)
					var/inp = input(usr, "Are you sure you want to try to defuse the bomb? This is very risky!", "Your fate") in list("Yes", "No")
					if(inp == "Yes" && explosive_counting)
						usr.visible_message("<span class='danger'>\The [usr] is trying to defuse \the [src]!</span>", "<span class='danger'>You begin defusing the bomb. Do not step away from the bomb!</span>")
						if(!do_after(usr, 100)) counting_down = 1
						usr << "<small><i>You start thinking back on your life..</i></small>"
						if(!do_after(usr, 100)) counting_down = 1
						if(prob(15))
							usr.visible_message("<span class='notice'>\The [usr] successfully disables the counter on \the [src]!</span>", "<span class='notice'>You successfully disable the counter on \the [src]!</span>")
							explosive_counting = 0
						else if(prob(55))
							explosive_count /= 2
							usr.visible_message("<span class='notice'>\The [usr] successfully delays the countdown on \the [src]!</span>", "<span class='notice'>You successfully delay the counter on \the [src]!</span>")
						else
							usr << "<span class='danger'><small>You cut the wire and watch in horror as the timer is reduced to 10 seconds...</small></span>"
							explosive_counting = min(explosive_counting, 10)
							spawn(10)
								usr.Weaken(10)
				else
					var/inp = text2num(input(usr, "What would you like to set the count to?", "Count"))
					if(inp)
						explosive_count = inp
						init_count = inp
			if("Activate")
				process_activation()
	..()

/obj/item/device/assembly/explosive/strong/process()
	var/active = 0
	if(explosive_counting)
		explosive_count--
	if(explosive_count <= 0)
		count++
		active = 1
	if(used) return
	if(!(active_wires & WIRE_ASSEMBLY_SAFETY))
		count++
		active = 1
	else if(!(active_wires & WIRE_MISC_ACTIVATE) && !wire_holder.IsIndexCut(WIRE_MISC_ACTIVATE))
		count++
		active = 1
	else if(counting_down)
		count++
		active = 1
	var/turf/T = get_turf(src)
	if(!T) return
	if(active)
		switch(count)
			if(1 to 3)
				T.visible_message("<span class='warning'><small>Tick..</small></span>")
			if(4 to 6)
				T.visible_message("<span class='warning'>Tick..</span>")
			if(7 to 9)
				T.visible_message("<span class='danger'><BIG>Tick..</BIG></SPAN>")
			if(10 to INFINITY)
				count = 0
				boom()


/obj/item/device/assembly/explosive/strong/process_signals()
	if(!..())
		failure++  // Avoiding infinite loops.
		misc_activate()

/obj/item/device/assembly/explosive/strong/holder_disconnect()
	misc_activate()
	return 1

/obj/item/device/assembly/explosive/strong/misc_activate()	// Failsafe
	if(connects_to.len && failure < 2) // You can make your own failsafe if you like.
		send_pulse_to_connected()
	else if(active_wires & WIRE_MISC_ACTIVATE)
		counting_down = 1
/obj/item/device/assembly/explosive/strong/boom()
	if(used) return
	power = min(3, init_count * 0.002)
	if(power < 0.5)
		var/turf/T = get_turf(src)
		if(T)
			T.audible_message("<small>You hear a quiet clicking sound..</small>")
		add_debug_log("Explosive failure: \[[src]\]")
		used = 1
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	var/turf/T = get_turf(src)
	explosion(T, 1 * power, 2 * power, 4 * power, 7 * power) // One big boom.
	qdel(src)
