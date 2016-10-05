/obj/item/device/assembly/transfer_valve // Should realistically be an assembly holder..
	name = "tank transfer valve"		 // Probably better if you can attach it to other things though
	desc = "Regulates the transfer of air between two tanks"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "valve_1"
	var/obj/item/weapon/tank/tank_one
	var/obj/item/weapon/tank/tank_two
	var/mob/attacher = null
	var/valve_open = 0
	var/toggle = 1
	holder_attackby = list(/obj/item/weapon/tank)
	var/obj/item/device/assembly/attached_device
	dangerous = 1

/obj/item/device/assembly/transfer_valve/attackby(obj/item/item, mob/user)
	var/turf/location = get_turf(src) // For admin logs
	if(istype(item, /obj/item/weapon/tank))
		attach_tank(item, user)
	else if(istype(item, /obj/item/device/assembly)) // You have to take the transfer valve
		var/obj/item/device/assembly/A = item		 // Out of the holder to modify it..
		if(attached_device)
			user << "<span class='warning'>There is already an device attached to the valve, remove it first.</span>"
			return
		user.remove_from_mob(item)
		attached_device = A
		A.forceMove(src)
		user << "<span class='notice'>You attach the [item] to the valve controls and secure it.</span>"
		A.holder = src

		bombers += "[key_name(user)] attached a [item] to a transfer valve."
		message_admins("[key_name_admin(user)] attached a [item] to a transfer valve. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
		log_game("[key_name_admin(user)] attached a [item] to a transfer valve.")
		attacher = user
		nanomanager.update_uis(src) // update all UIs attached to src
	..()
	return

/obj/item/device/assembly/transfer_valve/proc/attach_tank(var/obj/item/weapon/tank/to_attach, var/mob/user)
	if(to_attach && istype(to_attach))
		if(tank_one && tank_two)
			user << "<span class='warning'>There are already two tanks attached, remove one first.</span>"
			return 0
		var/turf/location = get_turf(src)
		to_attach.master = src
		if(user)
			bombers += "[key_name(user)] attached a [to_attach] to a transfer valve."
			message_admins("[key_name_admin(user)] attached a [to_attach] to a transfer valve. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
			log_game("[key_name_admin(user)] attached a [to_attach] to a transfer valve.")
			attacher = user
			user << "<span class='notice'>You attach the tank to the transfer valve.</span>"
			if(tank_one)
				message_admins("[key_name_admin(user)] attached both tanks to a transfer valve. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
				log_game("[key_name_admin(user)] attached both tanks to a transfer valve.")
			user.drop_item()
		if(!tank_one)
			tank_one = to_attach
			to_attach.forceMove(src)
		else if(!tank_two)
			tank_two = to_attach
			to_attach.forceMove(src)
		update_icon()
		nanomanager.update_uis(src) // update all UIs attached to srcb).
		return 1
	return 0

/obj/item/device/assembly/transfer_valve/attack_self(mob/user as mob)
	ui_interact(user)

/obj/item/device/assembly/transfer_valve/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	// this is the data which will be sent to the ui
	var/data[0]
	data["attachmentOne"] = tank_one ? tank_one.name : null
	data["attachmentTwo"] = tank_two ? tank_two.name : null
	data["valveAttachment"] = attached_device ? attached_device.name : null
	data["valveOpen"] = valve_open ? 1 : 0

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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

/obj/item/device/assembly/transfer_valve/Topic(href, href_list)
	if(..())
		return 1
	if(tank_one && href_list["tankone"])
		split_gases()
		valve_open = 0
		tank_one.forceMove(get_turf(src))
		tank_one = null
		update_icon()
		return 1
	else if(tank_two && href_list["tanktwo"])
		split_gases()
		valve_open = 0
		tank_two.forceMove(get_turf(src))
		tank_two = null
		update_icon()
		return 1
	else if(href_list["open"])
		toggle_valve()
	else if(attached_device)
		if(href_list["rem_device"])
			attached_device.forceMove(get_turf(src))
			attached_device:holder = null
			attached_device = null
			update_icon()
		if(href_list["device"])
			attached_device.attack_self(usr)
		return 1

/obj/item/device/assembly/transfer_valve/activate()
	toggle_valve()
	if(attached_device)
		send_direct_pulse(attached_device)
	return 1

/obj/item/device/assembly/transfer_valve/proc/merge_gases()
	tank_two.air_contents.volume += tank_one.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_one.air_contents.remove_ratio(1)
	tank_two.air_contents.merge(temp)

/obj/item/device/assembly/transfer_valve/proc/split_gases()
	if (!valve_open || !tank_one || !tank_two)
		return
	var/ratio1 = tank_one.air_contents.volume/tank_two.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_two.air_contents.remove_ratio(ratio1)
	tank_one.air_contents.merge(temp)
	tank_two.air_contents.volume -=  tank_one.air_contents.volume

	/*
	Exadv1: I know this isn't how it's going to work, but this was just to check
	it explodes properly when it gets a signal (and it does).
	*/

/obj/item/device/assembly/transfer_valve/proc/toggle_valve()
	if(valve_open==0 && (tank_one && tank_two))
		valve_open = 1
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
		bombers += log_str
		message_admins(log_str, 0, 1)
		log_game(log_str)
		merge_gases()
		spawn(20) // In case one tank bursts
			for (var/i=0,i<5,i++)
				src.update_icon()
				sleep(10)
			src.update_icon()

	else if(valve_open==1 && (tank_one && tank_two))
		split_gases()
		valve_open = 0
		src.update_icon()


/obj/item/device/assembly/transfer_valve/proc/remove_tank(var/obj/O)
	if(O == tank_two)
		split_gases()
		valve_open = 0
		tank_two.forceMove(get_turf(src))
		tank_two = null
		update_icon()
	else if(O == tank_one)
		split_gases()
		valve_open = 0
		tank_one.forceMove(get_turf(src))
		tank_one = null
		update_icon()