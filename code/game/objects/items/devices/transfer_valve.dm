/obj/item/device/transfer_valve
	name = "tank transfer valve"
	desc = "A small, versatile valve with dual-headed heat-resistant pipes. This mechanism is the standard size for coupling with portable gas tanks."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "valve_1"
	var/obj/item/tank/tank_one
	var/obj/item/tank/tank_two
	var/obj/item/device/assembly/attached_device
	var/mob/attacher = null
	var/valve_open = FALSE
	var/armed = FALSE
	var/panel_open= FALSE
	var/toggle = TRUE

	var/datum/wires/transfer_valve/wires

	movable_flags = MOVABLE_FLAG_PROXMOVE
/obj/item/device/transfer_valve/proc/process_activation(obj/item/device/D)

/obj/item/device/transfer_valve/IsAssemblyHolder()
	return TRUE


/obj/item/device/transfer_valve/use_tool(obj/item/tool, mob/user, list/click_params)
	// Assembly - Attach device
	if (isassembly(tool))
		if (armed)
			USE_FEEDBACK_FAILURE("\The [src] is armed and cannot be modified.")
			return TRUE
		if (attached_device)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [attached_device] attached.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		attached_device = tool
		attached_device.holder = src
		attached_device.toggle_secure()
		attacher = user
		SSnano.update_uis(src)
		GLOB.bombers += "[key_name(user)] attach \a [tool] to a transfer valve."
		log_and_message_admins("[key_name_admin(user)] attached \a [tool] to a transfer valve.", user, get_turf(src))
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [tool] to \a [src]."),
			SPAN_NOTICE("You attach \the [tool] to \the [src].")
		)
		return TRUE

	// Multitool, Wirecutters - Open wire panel
	if (isMultitool(tool) || isWirecutter(tool))
		if (!armed)
			USE_FEEDBACK_FAILURE("\The [src] isn't armed.")
			return TRUE
		if (!panel_open)
			USE_FEEDBACK_FAILURE("\The [src]'s panel is closed.")
			return TRUE
		wires.Interact(user)
		return TRUE

	// Screwdriver - Toggle control panel
	if (isScrewdriver(tool))
		if (!tank_one || !tank_two || !attached_device)
			USE_FEEDBACK_FAILURE("\The [src] isn't assembled.")
			return TRUE
		panel_open = !panel_open
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] [panel_open ? "opens" : "closes"] \a [src]'s control panel with \a [tool]."),
			SPAN_NOTICE("You [panel_open ? "open" : "close"] \the [src]'s control panel with \the [tool].")
		)
		return TRUE

	// Tank - Attach tank
	if (istype(tool, /obj/item/tank))
		if (tank_one && tank_two)
			USE_FEEDBACK_FAILURE("\The [src] already has two tanks attached.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		if (!tank_one)
			tank_one = tool
		else
			tank_two = tool
			log_and_message_admins("[key_name_admin(user)] attached both tanks to a transfer valve.", user, get_turf(src))
		w_class = max(initial(w_class), tank_one.w_class, tank_two?.w_class)
		update_icon()
		SSnano.update_uis(src)
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [tool] to \a [src]."),
			SPAN_NOTICE("You attach \the [tool] to \the [src].")
		)
		return TRUE

	return ..()


/obj/item/device/transfer_valve/HasProximity(atom/movable/AM as mob|obj)
	if(!attached_device)
		return
	attached_device.HasProximity(AM)
	return


/obj/item/device/transfer_valve/attack_self(mob/user as mob)
	if (panel_open)
		to_chat(user, SPAN_WARNING("The device's panel is open!"))
		return
	ui_interact(user)

/obj/item/device/transfer_valve/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)

	// this is the data which will be sent to the ui
	var/data[0]
	data["attachmentOne"] = tank_one ? tank_one.name : null
	data["attachmentTwo"] = tank_two ? tank_two.name : null
	data["valveAttachment"] = attached_device ? attached_device.name : null
	data["valveOpen"] = valve_open ? TRUE : FALSE
	data["armed"] = armed ? TRUE : FALSE

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "transfer_valve.tmpl", "Tank Transfer Valve", 460, 280)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		//ui.set_auto_update(1)

/obj/item/device/transfer_valve/Topic(href, href_list)
	..()
	if ( usr.stat || usr.restrained() )
		return FALSE
	if (src.loc != usr)
		return FALSE
	if (!armed)
		if(tank_one && href_list["tankone"])
			remove_tank(tank_one)
		else if(tank_two && href_list["tanktwo"])
			remove_tank(tank_two)
		else if(href_list["open"])
			toggle_valve()
		else if(attached_device)
			if (href_list["rem_device"])
				attached_device.dropInto(loc)
				attached_device:holder = null
				attached_device = null
				update_icon()
			if (href_list["device"])
				attached_device.attack_self(usr)
			if (href_list["arm"])
				toggle_armed()
	if(armed && href_list["activate"])
		attached_device.activate()
		visible_message(SPAN_WARNING("The [attached_device] blips!"), range = 3)
		message_admins("[key_name_admin(usr)] triggered \the [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
	return TRUE // Returning 1 sends an update to attached UIs

/obj/item/device/transfer_valve/process_activation(obj/item/device/D)
	if(toggle)
		toggle = FALSE
		toggle_valve()
		spawn(50) // To stop a signal being spammed from a proxy sensor constantly going off or whatever
			toggle = TRUE

/obj/item/device/transfer_valve/on_update_icon()
	overlays.Cut()
	underlays.Cut()

	if(!tank_one && !tank_two && !attached_device)
		icon_state = "valve_1"
		return
	icon_state = "valve"

	if(tank_one)
		overlays += "[tank_one.icon_state]"
	if(tank_two)
		var/icon/J = new(icon, icon_state = "[tank_two.icon_state]")
		J.Shift(WEST, 13)
		underlays += J
	if(attached_device)
		overlays += "device"

/obj/item/device/transfer_valve/proc/remove_tank(obj/item/tank/T)
	if(tank_one == T)
		split_gases()
		tank_one = null
	else if(tank_two == T)
		split_gases()
		tank_two = null
	else
		return

	if(!tank_one && !tank_two) src.w_class = initial(src.w_class) //returns it to just the transfer valve size
	T.dropInto(loc)
	update_icon()

/obj/item/device/transfer_valve/proc/merge_gases()
	if(valve_open)
		return
	tank_two.air_contents.volume += tank_one.air_contents.volume
	var/datum/gas_mixture/temp = tank_one.remove_air_ratio(1)
	tank_two.assume_air(temp)
	valve_open = TRUE

/obj/item/device/transfer_valve/proc/split_gases()
	if(!valve_open)
		return

	valve_open = FALSE

	if(QDELETED(tank_one) || QDELETED(tank_two))
		return

	var/ratio1 = tank_one.air_contents.volume/tank_two.air_contents.volume
	var/datum/gas_mixture/temp = tank_two.remove_air_ratio(ratio1)
	tank_two.air_contents.volume -=  tank_one.air_contents.volume
	tank_one.assume_air(temp)

/obj/item/device/transfer_valve/proc/toggle_armed()
	if (tank_one && tank_two && attached_device)
		armed = !armed
	if (armed)
		wires = new(src)
	else
		desc = initial(desc)
		wires = null

/obj/item/device/transfer_valve/examine(mob/user, distance)
	. = ..()
	if (armed && distance < 3)
		to_chat(user, SPAN_DANGER("This one looks like a bomb."))

	/*
	Exadv1: I know this isn't how it's going to work, but this was just to check
	it explodes properly when it gets a signal (and it does).
	*/

/obj/item/device/transfer_valve/proc/toggle_valve()
	if (!armed)
		return
	if(!valve_open && (tank_one && tank_two))
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)

		var/attacher_name = ""
		if(!attacher)
			attacher_name = "Unknown"
		else
			attacher_name = "[attacher.name]([attacher.ckey])"

		var/log_str = "Bomb valve opened in <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name]</a> "
		log_str += "with [attached_device ? attached_device : "no device"] attacher: [attacher_name]"

		if(attacher)
			log_str += "(<A HREF='?_src_=holder;adminmoreinfo=\ref[attacher]'>?</A>)"

		var/mob/mob = get_mob_by_key(src.fingerprintslast)
		var/last_touch_info = ""
		if(mob)
			last_touch_info = "(<A HREF='?_src_=holder;adminmoreinfo=\ref[mob]'>?</A>)"

		log_str += " Last touched by: [src.fingerprintslast][last_touch_info]"
		GLOB.bombers += log_str
		message_admins(log_str, 0, 1)
		log_game(log_str)
		merge_gases()

	else if(valve_open==1 && (tank_one && tank_two))
		split_gases()

	src.update_icon()

// this doesn't do anything but the timer etc. expects it to be here
// eventually maybe have it update icon to show state (timer, prox etc.) like old bombs
/obj/item/device/transfer_valve/proc/c_state()
	return
