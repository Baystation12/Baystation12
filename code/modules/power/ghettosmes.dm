//TODO: en Topic(), el dialogo no pone el Xput_level_max, sino 200k. Ademas se repite. Muy probablemente debido al ..() de topic
//DONE: attackby de code/defines/obj/weapon.dm/power module
//TODO: dangers
//TODO: mas tests

/obj/item/weapon/circuitboard/ghettosmes
	name = "Circuit board (PSU)"
	desc = "An APC circuit repurposed into some power storage device"
	build_path = "/obj/machinery/power/smes/ghetto"
	board_type = "machine"
//	origin_tech = "powerstorage=2;engineering=4;programming=4"
	frame_desc = "Requires 3 power cells."
	req_components = list("/obj/item/weapon/cell" = 3)


/obj/machinery/power/smes/ghetto
	name = "unreliable power storage unit"
	desc = "A rack of batteries connected by a mess of wires posing as a PSU."
	charge = 0 //you dont really want to make a potato PSU which already is overloaded
	online = 0
	chargelevel = 0
	output = 0
	var/opened = 0
	var/input_level_max = 0
	var/output_level_max = 0
	var/cells_amount = 0
	var/capacitors_amount = 0


/obj/machinery/power/smes/ghetto/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/ghettosmes
	component_parts += new /obj/item/weapon/cell
	component_parts += new /obj/item/weapon/cell
	component_parts += new /obj/item/weapon/cell
	RefreshParts()
	return

/obj/machinery/power/smes/ghetto/RefreshParts()
	capacitors_amount = 0
	cells_amount = 0
	var/max_level = 0 //for both input and output
	for(var/obj/item/weapon/stock_parts/capacitor/CP in component_parts)
		max_level += CP.rating
		capacitors_amount++
	input_level_max = 50000 + max_level * 20000
	output_level_max = 50000 + max_level * 20000

	var/C = 0
	for(var/obj/item/weapon/cell/PC in component_parts)
		C += PC.maxcharge
		cells_amount++
	capacity = C * 50   //Basic cells are such crap. Super cells will make a standard SMES


//Modified /vg/code
/obj/machinery/power/smes/ghetto/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		user << "You must not be on the same tile as the PSU."
		return 2

	//Direction the terminal will face
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if (NORTHWEST, SOUTHWEST)
			tempDir = WEST

	playsound(get_turf(src), 'sound/items/zip.ogg', 100, 1)
	if(do_after(user, 50))
		terminal = new /obj/machinery/power/terminal(get_step(src, reverse_direction(tempDir)))
		terminal.dir = tempDir
		terminal.master = src
		return 0
	return 1


/obj/machinery/power/smes/ghetto/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob) //these can only be moved by being reconstructed, solves having to remake the powernet.
	if(istype(W, /obj/item/weapon/screwdriver))
		if(!opened)
			src.opened = 1
			//src.icon_state = "smes_t"
			user << "You open the maintenance hatch of [src]"
		else
			src.opened = 0
			//src.icon_state = "smes"
			user << "You close the maintenance hatch of [src]"
	if(opened)
		if(istype(W, /obj/item/weapon/crowbar))
			if (charge < (capacity / 100))
				if (!online && !chargemode)
					playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
					var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
					M.state = 2
					M.icon_state = "box_1"
					for(var/obj/I in component_parts)
						if(I.reliability != 100 && crit_fail)
							I.crit_fail = 1
						I.loc = src.loc
					del(src)
					return 1
				else
					user << "Turn off the [src] before."
			else
				user << "Better let [src] discharge before dismantling it."
		else if(istype(W, /obj/item/weapon/cable_coil) && !terminal)
			var/obj/item/weapon/cable_coil/CC = W
			if (CC.amount < 10)
				user << "You need more cables."
				return

			user << "You start adding cable to the PSU."
			if (make_terminal(user))
				return

			CC.use(10)
			user.visible_message(\
					"\red [user.name] has added cables to the PSU!",\
					"You added cables the PSU.")
			terminal.connect_to_network()
			src.stat = 0

		else if(istype(W, /obj/item/weapon/wirecutters) && terminal)
			var/tempTDir = terminal.loc
			if(tempTDir:intact)
				user << "\red You must remove the floor plating in front of the PSU first."
				return
			user << "You begin to cut the cables..."
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			if(do_after(user, 50))
				if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					return
				new /obj/item/weapon/cable_coil(loc,10)
				user.visible_message(\
					"\red [user.name] cut the cables and dismantled the power terminal.",\
					"You cut the cables and dismantle the power terminal.")
				del(terminal)
		else if ((istype(W, /obj/item/weapon/stock_parts/capacitor) && (capacitors_amount < 5)) || (istype(W, /obj/item/weapon/cell) && (cells_amount < 5)))
			if (charge < (capacity / 100))
				if (!online && !chargemode)
					user.drop_item()
					component_parts += W
					W.loc = src
					RefreshParts()
					user << "You upgrade the [src] with [W.name]."
				else
					user << "Turn off the [src] before."
			else
				user << "Better let [src] discharge before putting your hand inside it."
		else
			user.set_machine(src)
			interact(user)
			return 1
	return


//Couple variables changed
/obj/machinery/power/smes/ghetto/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["nameTag"] = name_tag
	data["storedCapacity"] = round(100.0*charge/capacity, 0.1)
	data["charging"] = charging
	data["chargeMode"] = chargemode
	data["chargeLevel"] = chargelevel
	data["chargeMax"] = input_level_max
	data["outputOnline"] = online
	data["outputLevel"] = output
	data["outputMax"] = output_level_max
	data["outputLoad"] = round(loaddemand)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "smes.tmpl", "SMES Power Storage Unit", 540, 380)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)



/obj/machinery/power/smes/ghetto/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained() )
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		if(!istype(usr, /mob/living/silicon/ai))
			usr << "\red You don't have the dexterity to do this!"
			return

//world << "[href] ; [href_list[href]]"

	if (!istype(src.loc, /turf) && !istype(usr, /mob/living/silicon/))
		return 0 // Do not update ui

	for(var/area/A in active_areas)
		A.master.powerupdate = 3


	if( href_list["cmode"] )
		chargemode = !chargemode
		if(!chargemode)
			charging = 0
		updateicon()

	else if( href_list["online"] )
		online = !online
		updateicon()
	else if( href_list["input"] )
		switch( href_list["input"] )
			if("min")
				chargelevel = 0
			if("max")
				chargelevel = input_level_max		//30000
			if("set")
				chargelevel = input(usr, "Enter new input level (0-[input_level_max])", "SMES Input Power Control", chargelevel) as num
		chargelevel = max(0, min(input_level_max, chargelevel))	// clamp to range

	else if( href_list["output"] )
		switch( href_list["output"] )
			if("min")
				output = 0
			if("max")
				output = output_level_max		//30000
			if("set")
				output = input(usr, "Enter new output level (0-[output_level_max])", "SMES Output Power Control", output) as num
		output = max(0, min(output_level_max, output))	// clamp to range

	investigate_log("input/output; [chargelevel>output?"<font color='green'>":"<font color='red'>"][chargelevel]/[output]</font> | Output-mode: [online?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [chargemode?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [usr.key]","singulo")

	return 1