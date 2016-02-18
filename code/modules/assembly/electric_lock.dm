/obj/item/device/assembly/electric_lock
	name = "electric lock"
	desc = "An electronic lock"
	icon_state = "electric_lock"
	item_state = "assembly"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	weight = 2

	wires = WIRE_POWER_RECEIVE | WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_ASSEMBLY_SAFETY | WIRE_MISC_ACTIVATE
	wire_num = 8

	var/on = 0

/obj/item/device/assembly/electric_lock/activate()
	on = !on

/obj/item/device/assembly/electric_lock/get_nonset_data()
	return "There is no information to show"

/obj/item/device/assembly/electric_lock/holder_interface(mob/user)
	if(on)
		if(src.draw_power(10))
			user << "<span class='warning'><small>*bzzt*</small></span>"
			return 0
		else
			user << "<span class='warning'><small>*ping*</small></span>"
			on = 0
	return 1

/obj/item/device/assembly/electric_lock/wire_safety(var/index = 0, var/pulsed = 0)
	if(!pulsed)
		if(index == WIRE_ASSEMBLY_SAFETY)
			alarm()
		else if(active_wires & WIRE_ASSEMBLY_SAFETY)
			alarm()
	else if(index == WIRE_PROCESS_ACTIVATE)
		if(holder)
			holder.visible_message("<span class='warning'>**beep** **beep**</span>")
			spawn(30)
				if(prob(50) && active_wires & WIRE_ASSEMBLY_SAFETY)
					alarm()


/obj/item/device/assembly/electric_lock/proc/alarm()
	if(holder)
		holder.visible_message("<span class='danger'><BIG>ALERT! ALERT! ALERT!</BIG></span>")
		spawn((110-reliability))
			if(prob(reliability))
				misc_activate(1)

/obj/item/device/assembly/electric_lock/misc_activate(var/forced = 0)
	if(active_wires & WIRE_MISC_ACTIVATE || forced)
		send_pulse_to_connected()
