// Power component for machines. Handles power interactions.

/obj/machinery
	var/list/power_components = list() // this is an optimization, as power code is expensive.

/obj/item/weapon/stock_parts/power
	lazy_initialize = FALSE
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "teslalink"
	var/priority = 0            // Higher priority is used first
	var/cached_channel

/obj/item/weapon/stock_parts/power/on_install(var/obj/machinery/machine)
	..()
	ADD_SORTED(machine.power_components, src, /proc/cmp_power_component_priority)
	machine.power_change() // Makes the machine recompute its power status.

/obj/item/weapon/stock_parts/power/on_uninstall(var/obj/machinery/machine)
	LAZYREMOVE(machine.power_components, src)
	..()
	machine.power_change()

// By returning true here, the part promises that it will provide the machine with power until it calls power_change on the machine.
/obj/item/weapon/stock_parts/power/proc/can_provide_power(var/obj/machinery/machine)
	return FALSE

// Doesn't actually do it.
/obj/item/weapon/stock_parts/power/proc/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	return 0

// A request for the amount of power on the given channel. Returns the amount of power which could be provided.
/obj/item/weapon/stock_parts/power/proc/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	return 0

// This alerts the part that it does not need to provide power anymore.
/obj/item/weapon/stock_parts/power/proc/not_needed(var/obj/machinery/machine)

// Basic power handler.
/obj/item/weapon/stock_parts/power/apc
	name = "tesla link receptor"
	desc = "Standard area-based power receptor, connecting the machine to a nearby area power controller through a tesla link."
	priority = 1

// Very simple; checks for area power and that's it.
/obj/item/weapon/stock_parts/power/apc/can_provide_power(var/obj/machinery/machine)
	return machine.powered()

// Doesn't actually do it.
/obj/item/weapon/stock_parts/power/apc/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	var/area/A = get_area(machine)		// make sure it's in an area
	. = 0
	if(!A)
		return
	if(A.powered(channel))
		return amount

/obj/item/weapon/stock_parts/power/apc/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	var/area/A = get_area(machine)
	. = 0
	if(!A)
		return
	if(A.powered(channel))
		A.use_power_oneoff(amount, channel)
		return amount

/obj/item/weapon/stock_parts/power/battery
	name = "battery backup"
	desc = "A self-contained battery backup system, using replaceable cells to provide backup power."
	icon_state = "battery0"
	var/obj/item/weapon/cell/cell
	var/charge_channel = ENVIRON  // The channel it attempts to charge from.
	var/charge_rate = 1           // This is in battery units, per tick.
	var/can_charge = TRUE
	var/charge_wait_counter = 10  // How many ticks we wait until we start charging after charging becomes an option.
	var/last_cell_charge  = 0     // Used for UI stuff.
	var/seek_alternatives = 5     // How many ticks we wait before seeking other power sources, if we can provide the machine with power. Set to 0 to never do this.

/obj/item/weapon/stock_parts/power/battery/Destroy()
	qdel(cell)
	. = ..()

/obj/item/weapon/stock_parts/power/battery/on_install(var/obj/machinery/machine)
	..()
	start_processing(machine)

/obj/item/weapon/stock_parts/power/battery/on_uninstall(var/obj/machinery/machine)
	if(cell)
		cell.dropInto(loc)
		remove_cell()
	..()

// None of these helpers actually change the cell's loc. They only manage internal references and state.
/obj/item/weapon/stock_parts/power/battery/proc/add_cell(var/obj/machinery/machine, var/obj/item/weapon/cell/new_cell)
	if(cell)
		return
	cell = new_cell
	GLOB.destroyed_event.register(cell, src, .proc/remove_cell)
	if(!machine)
		machine = loc
	if(istype(machine))
		machine.power_change()
	set_status(machine, PART_STAT_CONNECTED)
	update_icon()
	return cell

/obj/item/weapon/stock_parts/power/battery/proc/remove_cell()
	if(cell)
		GLOB.destroyed_event.unregister(cell, src)
		. = cell
		cell = null
		var/obj/machinery/machine = loc
		if(istype(machine))
			machine.power_change()
		update_icon()
		unset_status(machine, PART_STAT_CONNECTED)

/obj/item/weapon/stock_parts/power/battery/proc/extract_cell(mob/user)
	if(!cell)
		return
	cell.add_fingerprint(user)
	cell.update_icon()

	user.visible_message("<span class='warning'>\The [user] removes the power cell from [src]!</span>",\
							"<span class='notice'>You remove the power cell.</span>")
	. = remove_cell()
	var/obj/machinery/machine = loc
	if(machine)
		machine.update_icon()

/obj/item/weapon/stock_parts/power/battery/machine_process(var/obj/machinery/machine)
	last_cell_charge = cell && cell.charge

	if(status & PART_STAT_ACTIVE)
		if(!(cell && cell.checked_use(CELLRATE * machine.get_power_usage())))
			machine.update_power_channel(cached_channel)
			machine.power_change() // Out of power
			return
		if(seek_alternatives > 0)
			seek_alternatives--
			if(!seek_alternatives)
				seek_alternatives = initial(seek_alternatives)
				machine.update_power_channel(cached_channel)
				machine.power_change()
		return // We don't recharge if discharging

	// try and recharge
	var/area/A = get_area(machine)
	if(!can_charge || !cell || cell.fully_charged() || !A.powered(charge_channel))
		charge_wait_counter = initial(charge_wait_counter)
		return
	if(charge_wait_counter > 0)
		charge_wait_counter--
		return
	var/give = cell.give(charge_rate) / CELLRATE
	A.use_power_oneoff(give, charge_channel)

/obj/item/weapon/stock_parts/power/battery/can_provide_power(var/obj/machinery/machine)
	if(cell && cell.check_charge(CELLRATE * machine.get_power_usage()))
		cached_channel = machine.power_channel
		machine.update_power_channel(LOCAL)
		set_status(machine, PART_STAT_ACTIVE)
		return TRUE
	return FALSE

/obj/item/weapon/stock_parts/power/battery/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(cell && channel == LOCAL)
		return min(cell.charge / CELLRATE, amount)

/obj/item/weapon/stock_parts/power/battery/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(cell && channel == LOCAL)
		. = cell.use(amount * CELLRATE) / CELLRATE
		charge_wait_counter = initial(charge_wait_counter) // If we are providing power, we wait to start charging.

/obj/item/weapon/stock_parts/power/battery/not_needed(var/obj/machinery/machine)
	if(status & PART_STAT_ACTIVE)
		unset_status(machine, PART_STAT_ACTIVE)
		charge_wait_counter = initial(charge_wait_counter)

// Find a cell from the machine building materials if possible.
/obj/item/weapon/stock_parts/power/battery/on_refresh(var/obj/machinery/machine)
	if(machine && !cell)
		var/obj/item/weapon/stock_parts/building_material/mat = machine.get_component_of_type(/obj/item/weapon/stock_parts/building_material)
		var/obj/item/weapon/cell/cell = mat && mat.remove_material(/obj/item/weapon/cell, 1)
		if(cell)
			add_cell(machine, cell)
			cell.forceMove(src)

/obj/item/weapon/stock_parts/power/battery/on_update_icon()
	icon_state = "battery[!!cell]"

// Cell interaction
/obj/item/weapon/stock_parts/power/battery/attackby(obj/item/I, mob/user)
	var/obj/machinery/machine = loc
	if(!istype(machine))
		return ..()

	if(istype(I, /obj/item/weapon/cell))
		if(cell)
			to_chat(user, "There is a power cell already installed.")
			return
		if(machine && (machine.stat & MAINT))
			to_chat(user, "<span class='warning'>There is no connector for your power cell.</span>")
			return
		if(I.w_class != ITEM_SIZE_NORMAL)
			to_chat(user, "\The [I] is too [I.w_class < ITEM_SIZE_NORMAL? "small" : "large"] to fit here.")
			return

		if(!user.unEquip(I, src))
			return
		add_cell(machine, I)
		user.visible_message(\
			"<span class='warning'>\The [user.name] has inserted the power cell to [src.name]!</span>",\
			"<span class='notice'>You insert the power cell.</span>")
		if(machine)
			machine.update_icon()
		return TRUE

/obj/item/weapon/stock_parts/power/battery/attack_hand(mob/user)
	if(cell)
		user.put_in_hands(cell)
		extract_cell(user)
		return TRUE

/obj/item/weapon/stock_parts/power/battery/get_cell()
	return cell

// Direct powernet connection via terminal machinery.
// Note that this isn't for the terminal itself, which is an auxiliary entity; it's for whatever is connected to it.
/obj/item/weapon/stock_parts/power/terminal
	name = "wired connection"
	desc = "A power connection directly to the grid, via power cables."
	icon_state = "terminal"
	priority = 2
	var/obj/machinery/power/terminal/terminal
	var/terminal_dir = 0

/obj/item/weapon/stock_parts/power/terminal/on_uninstall(var/obj/machinery/machine)
	unset_terminal(loc, terminal)
	..()

/obj/item/weapon/stock_parts/power/terminal/Destroy()
	qdel(terminal)
	. = ..()

/obj/item/weapon/stock_parts/power/terminal/machine_process(var/obj/machinery/machine)
	if(!terminal)
		machine.update_power_channel(cached_channel)
		machine.power_change()
		return
	
	var/surplus = terminal.surplus()
	var/usage = machine.get_power_usage()
	terminal.draw_power(usage)
	if(surplus >= usage)
		return // had enough power and good to go.

	// Try and use other (local) sources of power to make up for the deficit.
	var/deficit = machine.use_power_oneoff(usage - surplus)
	if(deficit > 0)
		machine.update_power_channel(cached_channel)
		machine.power_change()

//Is willing to provide power if the wired contribution is nonnegligible and there is enough total local power to run the machine.
/obj/item/weapon/stock_parts/power/terminal/can_provide_power(var/obj/machinery/machine)
	if(terminal && terminal.surplus() && machine.can_use_power_oneoff(machine.get_power_usage(), LOCAL) <= 0)
		set_status(machine, PART_STAT_ACTIVE)
		cached_channel = machine.power_channel
		machine.update_power_channel(LOCAL)
		start_processing(machine)
		return TRUE
	return FALSE

/obj/item/weapon/stock_parts/power/terminal/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(terminal && channel == LOCAL)
		return min(terminal.surplus(), amount)

/obj/item/weapon/stock_parts/power/terminal/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(terminal && channel == LOCAL)
		return terminal.draw_power(amount)

/obj/item/weapon/stock_parts/power/terminal/not_needed(var/obj/machinery/machine)
	unset_status(machine, PART_STAT_ACTIVE)
	stop_processing(machine)

/obj/item/weapon/stock_parts/power/terminal/proc/set_terminal(var/obj/machinery/machine, var/obj/machinery/power/new_terminal)
	if(terminal)
		unset_terminal(machine, terminal)
	terminal = new_terminal
	terminal.master = src
	GLOB.destroyed_event.register(terminal, src, .proc/unset_terminal)
	set_status(machine, PART_STAT_CONNECTED)

/obj/item/weapon/stock_parts/power/terminal/proc/make_terminal(var/obj/machinery/machine)
	if(!machine)
		return
	var/obj/machinery/power/terminal/new_terminal = new (get_step(machine, terminal_dir))
	new_terminal.set_dir(terminal_dir ? GLOB.reverse_dir[terminal_dir] : machine.dir)
	new_terminal.connect_to_network()
	set_terminal(machine, new_terminal)

/obj/item/weapon/stock_parts/power/terminal/proc/unset_terminal(var/obj/machinery/power/old_terminal, var/obj/machinery/machine)
	GLOB.destroyed_event.unregister(old_terminal, src)
	terminal = null
	unset_status(machine, PART_STAT_CONNECTED)

/obj/item/weapon/stock_parts/power/terminal/proc/blocking_terminal_at_loc(var/obj/machinery/machine, var/turf/T, var/mob/user)
	. = FALSE
	var/check_dir = terminal_dir ? GLOB.reverse_dir[terminal_dir] : machine.dir
	for(var/obj/machinery/power/terminal/term in T)
		if(T.dir == check_dir)
			to_chat(user, "<span class='notice'>There is already a terminal here.</span>")
			return TRUE

/obj/item/weapon/stock_parts/power/terminal/attackby(obj/item/I, mob/user)
	var/obj/machinery/machine = loc
	if(!istype(machine))
		return ..()

	if (istype(I, /obj/item/stack/cable_coil) && !terminal)
		var/turf/T = get_step(machine, terminal_dir)
		if(terminal_dir && user.loc != T)
			return FALSE // Wrong terminal handler.
		if(blocking_terminal_at_loc(machine, T, user))
			return FALSE

		if(istype(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of \the [machine] first.</span>")
			return TRUE
		var/obj/item/stack/cable_coil/C = I
		if(!C.can_use(10))
			to_chat(user, "<span class='warning'>You need ten lengths of cable for \the [machine].</span>")
			return TRUE
		user.visible_message("<span class='warning'>\The [user] adds cables to the \the [machine].</span>", \
							"You start adding cables to \the [machine] frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20, machine))
			if(C.can_use(10) && !terminal && (machine == loc) && machine.components_are_accessible(type) && !blocking_terminal_at_loc(machine, T, user))
				var/obj/structure/cable/N = T.get_cable_node()
				if (prob(50) && electrocute_mob(user, N, N))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, machine)
					s.start()
					if(user.stunned)
						return TRUE
				C.use(10)
				user.visible_message(\
					"<span class='warning'>\The [user] has added cables to the \the [machine]!</span>",\
					"You add cables to the \the [machine].")
				make_terminal(machine)
		return TRUE

	if(isWirecutter(I) && terminal)
		var/turf/T = get_step(machine, terminal_dir)
		if(terminal_dir && user.loc != T)
			return FALSE // Wrong terminal handler.
		if(istype(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of \the [machine] first.</span>")
			return TRUE
		user.visible_message("<span class='warning'>\The [user] dismantles the power terminal from \the [machine].</span>", \
							"You begin to cut the cables...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50, machine))
			if(terminal && (machine == loc) && machine.components_are_accessible(type))
				if (prob(50) && electrocute_mob(user, terminal.powernet, terminal))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, machine)
					s.start()
					if(user.stunned)
						return TRUE
				new /obj/item/stack/cable_coil(T, 10)
				to_chat(user, "<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
				qdel(terminal)
		return TRUE