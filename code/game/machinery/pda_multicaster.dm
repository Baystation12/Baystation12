/obj/machinery/pda_multicaster
	name = "\improper PDA multicaster"
	desc = "This machine mirrors messages sent to it to specific departments."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "controller"
	density = 1
	anchored = 1
	circuit = /obj/item/weapon/circuitboard/telecomms/pda_multicaster
	use_power = 1
	idle_power_usage = 750
	var/on = 1		// If we're currently active,
	var/toggle = 1	// If we /should/ be active or not,
	var/list/internal_PDAs = list() // Assoc list of PDAs inside of this, with the department name being the index,

/obj/machinery/pda_multicaster/New()
	..()
	internal_PDAs = list("command" = new /obj/item/device/pda/multicaster/command(src),
		"security" = new /obj/item/device/pda/multicaster/security(src),
		"engineering" = new /obj/item/device/pda/multicaster/engineering(src),
		"medical" = new /obj/item/device/pda/multicaster/medical(src),
		"research" = new /obj/item/device/pda/multicaster/research(src),
		"cargo" = new /obj/item/device/pda/multicaster/cargo(src),
		"civilian" = new /obj/item/device/pda/multicaster/civilian(src))

/obj/machinery/pda_multicaster/prebuilt/New()
	..()

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/telecomms/pda_multicaster(src)
	component_parts += new /obj/item/weapon/stock_parts/subspace/ansible(src)
	component_parts += new /obj/item/weapon/stock_parts/subspace/filter(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/subspace/treatment(src)
	component_parts += new /obj/item/stack/cable_coil(src, 2)
	RefreshParts()

/obj/machinery/pda_multicaster/Destroy()
	for(var/atom/movable/AM in contents)
		qdel(AM)
	..()

/obj/machinery/pda_multicaster/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-p"

/obj/machinery/pda_multicaster/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		default_deconstruction_screwdriver(user, I)
	else if(istype(I, /obj/item/weapon/crowbar))
		default_deconstruction_crowbar(user, I)
	else
		..()

/obj/machinery/pda_multicaster/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/pda_multicaster/attack_hand(mob/user)
	toggle_power(user)

/obj/machinery/pda_multicaster/proc/toggle_power(mob/user)
	toggle = !toggle
	visible_message("\the [user] turns \the [src] [toggle ? "on" : "off"].")
	update_power()
	if(!toggle)
		var/msg = "[usr.client.key] ([usr]) has turned [src] off, at [x],[y],[z]."
		message_admins(msg)
		log_game(msg)

/obj/machinery/pda_multicaster/proc/update_PDAs(var/turn_off)
	for(var/obj/item/device/pda/pda in contents)
		pda.toff = turn_off

/obj/machinery/pda_multicaster/proc/update_power()
	if(toggle)
		if(stat & (BROKEN|NOPOWER|EMPED))
			on = 0
			update_PDAs(1) // 1 being to turn off.
			idle_power_usage = 0
		else
			on = 1
			update_PDAs(0)
			idle_power_usage = 750
	else
		on = 0
		update_PDAs(1)
		idle_power_usage = 0
	update_icon()

/obj/machinery/pda_multicaster/process()
	update_power()

/obj/machinery/pda_multicaster/emp_act(severity)
	if(!(stat & EMPED))
		stat |= EMPED
		var/duration = (300 * 10)/severity
		spawn(rand(duration - 20, duration + 20))
			stat &= ~EMPED
	update_icon()
	..()
