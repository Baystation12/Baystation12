// the SMES
// stores power

//Board
/obj/item/weapon/circuitboard/smes
	name = "Circuit board (SMES Cell)"
	build_path = "/obj/machinery/power/smes"
	board_type = "machine"
	origin_tech = "powerstorage=6;engineering=4" // Board itself is high tech. Coils have to be ordered from cargo or salvaged from existing SMESs.
	frame_desc = "Requires 1 superconducting magnetic coil and 30 wires."
	req_components = list("/obj/item/weapon/smes_coil" = 1, "/obj/item/stack/cable_coil" = 30)

//Construction Item
/obj/item/weapon/smes_coil
	name = "Superconducting Magnetic Coil"
	desc = "Heavy duty superconducting magnetic coil, mainly used in construction of SMES units."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"			// Just few icons patched together. If someone wants to make better icon, feel free to do so!
	w_class = 4.0 						// It's LARGE (backpack size)


/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = 1
	anchored = 1
	use_power = 0
	var/output = 0			//Amount of power it tries to output
	var/lastout = 0			//Amount of power it actually outputs to the powernet
	var/loaddemand = 0		//For use in restore()
	var/capacity = 5e6		//Maximum amount of power it can hold
	var/charge = 0			//Current amount of power it holds
	var/charging = 0		//1 if it's actually charging, 0 if not
	var/chargemode = 0		//1 if it's trying to charge, 0 if not.
	//var/chargecount = 0
	var/chargelevel = 0		//Amount of power it tries to charge from powernet
	var/online = 1			//1 if it's outputting power, 0 if not.
	var/name_tag = null
	var/obj/machinery/power/terminal/terminal = null
	//Holders for powerout event.
	var/last_output = 0
	var/last_charge = 0
	var/last_online = 0
	var/open_hatch = 0
	var/building_terminal = 0 //Suggestions about how to avoid clickspam building several terminals accepted!
	var/input_level_max = 250000		// It is now coil amount based, so no need for DEFINE
	var/output_level_max = 250000

	var/storage_per_coil = 5000000
	var/IO_per_coil = 250000
	var/max_coils = 6 //30M capacity, 1.5MW input/output when fully upgraded
	var/cur_coils = 1 // Current amount of installed coils

/obj/machinery/power/smes/New()
	component_parts = list()
	component_parts += new /obj/item/stack/cable_coil(src,30)
	component_parts += new /obj/item/weapon/circuitboard/smes(src)

	// Allows for mapped-in SMESs with larger capacity/IO
	for(var/i = 1, i <= cur_coils, i++)
		component_parts += new /obj/item/weapon/smes_coil(src)

	..()
	recalc_coils()
	spawn(5)
		if(!powernet)
			connect_to_network()

		dir_loop:
			for(var/d in cardinal)
				var/turf/T = get_step(src, d)
				for(var/obj/machinery/power/terminal/term in T)
					if(term && term.dir == turn(d, 180))
						terminal = term
						break dir_loop
		if(!terminal)
			stat |= BROKEN
			return
		terminal.master = src
		if(!terminal.powernet)
			terminal.connect_to_network()
		updateicon()
	return

/obj/machinery/power/smes/proc/recalc_coils()
	if ((cur_coils <= max_coils) && (cur_coils >= 1))
		capacity = cur_coils * storage_per_coil
		charge = between(0, charge, capacity)
		output_level_max = cur_coils * IO_per_coil
		output = between(0, output, output_level_max)
		input_level_max = cur_coils * IO_per_coil
		chargelevel = between(0, chargelevel, input_level_max)


/obj/machinery/power/smes/proc/updateicon()
	overlays.Cut()
	if(stat & BROKEN)	return

	overlays += image('icons/obj/power.dmi', "smes-op[online]")

	if(charging)
		overlays += image('icons/obj/power.dmi', "smes-oc1")
	else
		if(chargemode)
			overlays += image('icons/obj/power.dmi', "smes-oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += image('icons/obj/power.dmi', "smes-og[clevel]")
	return


/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5*charge/(capacity ? capacity : 5e6))

#define SMESRATE 0.05			// rate of internal charge to external power


/obj/machinery/power/smes/process()
	if(stat & BROKEN)	return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = charging
	var/last_onln = online

	if(terminal)
		var/excess = terminal.surplus()

		if(charging)
			if(excess >= 0)		// if there's power available, try to charge
				var/load = min((capacity-charge)/SMESRATE, chargelevel)		// charge at set rate, limited to spare capacity
				load = add_load(load)		// add the load to the terminal side network
				charge += load * SMESRATE	// increase the charge

			else					// if not enough capcity
				charging = 0		// stop charging
				//chargecount  = 0

		else
			if (chargemode && excess > 0 && excess >= chargelevel)
				charging = 1
		/*	if(chargemode)
				if(chargecount > rand(3,6))
					charging = 1
					chargecount = 0

				if(excess > chargelevel)
					chargecount++
				else
					chargecount = 0
			else
				chargecount = 0   */

	if(online)		// if outputting
		lastout = min( charge/SMESRATE, output)		//limit output to that stored
		charge -= lastout*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(lastout)				// add output to powernet (smes side)
		if(charge < 0.0001)
			online = 0					// stop output if charge falls to zero

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != charging || last_onln != online)
		updateicon()

	return

// called after all power processes are finished
// restores charge level to smes if there was excess this ptick


/obj/machinery/power/smes/proc/restore()
	if(stat & BROKEN)
		return

	if(!online)
		loaddemand = 0
		return

	var/excess = powernet.netexcess		// this was how much wasn't used on the network last ptick, minus any removed by other SMESes

	excess = min(lastout, excess)				// clamp it to how much was actually output by this SMES last ptick

	excess = min((capacity-charge)/SMESRATE, excess)	// for safety, also limit recharge by space capacity of SMES (shouldn't happen)

	// now recharge this amount

	var/clev = chargedisplay()

	charge += excess * SMESRATE
	powernet.netexcess -= excess		// remove the excess from the powernet, so later SMESes don't try to use it

	loaddemand = lastout-excess

	if(clev != chargedisplay() )
		updateicon()
	return

//Will return 1 on failure
/obj/machinery/power/smes/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		user << "<span class='warning'>You must not be on the same tile as the [src].</span>"
		return 1

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if (NORTHWEST, SOUTHWEST)
			tempDir = WEST
	var/turf/tempLoc = get_step(src, reverse_direction(tempDir))
	if (istype(tempLoc, /turf/space))
		user << "<span class='warning'>You can't build a terminal on space.</span>"
		return 1
	else if (istype(tempLoc))
		if(tempLoc.intact)
			user << "<span class='warning'>You must remove the floor plating first.</span>"
			return 1
	user << "<span class='notice'>You start adding cable to the [src].</span>"
	if(do_after(user, 50))
		terminal = new /obj/machinery/power/terminal(tempLoc)
		terminal.dir = tempDir
		terminal.master = src
		return 0
	return 1


/obj/machinery/power/smes/add_load(var/amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0


/obj/machinery/power/smes/attack_ai(mob/user)
	add_fingerprint(user)
	ui_interact(user)


/obj/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)


/obj/machinery/power/smes/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(!open_hatch)
			open_hatch = 1
			user << "<span class='notice'>You open the maintenance hatch of [src].</span>"
		else
			open_hatch = 0
			user << "<span class='notice'>You close the maintenance hatch of [src].</span>"
	if (open_hatch)
		if(istype(W, /obj/item/stack/cable_coil) && !terminal && !building_terminal)
			building_terminal = 1
			var/obj/item/stack/cable_coil/CC = W
			if (CC.get_amount() < 10)
				user << "<span class='warning'>You need more cables.</span>"
				building_terminal = 0
				return
			if (make_terminal(user))
				building_terminal = 0
				return
			building_terminal = 0
			CC.use(10)
			user.visible_message(\
					"<span class='notice'>[user.name] has added cables to the [src].</span>",\
					"<span class='notice'>You added cables to the [src].</span>")
			terminal.connect_to_network()
			stat = 0

		else if(istype(W, /obj/item/weapon/wirecutters) && terminal && !building_terminal)
			building_terminal = 1
			var/turf/tempTDir = terminal.loc
			if (istype(tempTDir))
				if(tempTDir.intact)
					user << "<span class='warning'>You must remove the floor plating first.</span>"
				else
					user << "<span class='notice'>You begin to cut the cables...</span>"
					playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 50))
						if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
							var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
							s.set_up(5, 1, src)
							s.start()
							building_terminal = 0
							return
						new /obj/item/stack/cable_coil(loc,10)
						user.visible_message(\
							"<span class='notice'>[user.name] cut the cables and dismantled the power terminal.</span>",\
							"<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
						del(terminal)
			building_terminal = 0

		// PSUs have their own code in batteryrack.dm
		else if(istype(W, /obj/item/weapon/crowbar) && !(istype(src, /obj/machinery/power/smes/batteryrack)))
			if (charge < (capacity / 100))
				if (!online && !chargemode)
					if (!terminal)
						playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
						usr << "\red You begin to disassemble the SMES cell!"
						if (do_after(usr, 100 * cur_coils)) // More coils = takes longer to disassemble. It's complex so largest one with 5 coils will take 50s
							usr << "\red You have disassembled the SMES cell!"
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
						user << "<span class='warning'>You have to disassemble the terminal first!</span>"
				else
					user << "<span class='warning'>Turn off the [src] before dismantling it.</span>"
			else
				user << "<span class='warning'>Better let [src] discharge before dismantling it.</span>"
		else if(istype(W, /obj/item/weapon/smes_coil) && !(istype(src, /obj/machinery/power/smes/batteryrack)))
			if (cur_coils < max_coils)
				usr << "You install the coil into the SMES unit!"
				user.drop_item()
				cur_coils ++
				component_parts += W
				W.loc = src
				recalc_coils()
			else
				usr << "\red You can't insert more coils to this SMES unit!"

/obj/machinery/power/smes/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

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
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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


/obj/machinery/power/smes/Topic(href, href_list)
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
				chargelevel = input_level_max
			if("set")
				chargelevel = input(usr, "Enter new input level (0-[input_level_max])", "SMES Input Power Control", chargelevel) as num
		chargelevel = max(0, min(input_level_max, chargelevel))	// clamp to range

	else if( href_list["output"] )
		switch( href_list["output"] )
			if("min")
				output = 0
			if("max")
				output = output_level_max
			if("set")
				output = input(usr, "Enter new output level (0-[output_level_max])", "SMES Output Power Control", output) as num
		output = max(0, min(output_level_max, output))	// clamp to range

	investigate_log("input/output; [chargelevel>output?"<font color='green'>":"<font color='red'>"][chargelevel]/[output]</font> | Output-mode: [online?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [chargemode?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [usr.key]","singulo")

	return 1


/obj/machinery/power/smes/proc/ion_act()
	if(src.z == 1)
		if(prob(1)) //explosion
			for(var/mob/M in viewers(src))
				M.show_message("\red The [src.name] is making strange noises!", 3, "\red You hear sizzling electronics.", 2)
			sleep(10*pick(4,5,6,7,10,14))
			var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()
			explosion(src.loc, -1, 0, 1, 3, 1, 0)
			del(src)
			return
		if(prob(15)) //Power drain
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(prob(50))
				emp_act(1)
			else
				emp_act(2)
		if(prob(5)) //smoke only
			var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()


/obj/machinery/power/smes/emp_act(severity)
	online = 0
	charging = 0
	output = 0
	charge -= 1e6/severity
	if (charge < 0)
		charge = 0
	spawn(100)
		output = initial(output)
		charging = initial(charging)
		online = initial(online)
	..()



/obj/machinery/power/smes/magical
	name = "magical power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. Magically produces power."
	capacity = 9000000
	output = 250000

/obj/machinery/power/smes/magical/process()
	charge = 5000000
	..()

/proc/rate_control(var/S, var/V, var/C, var/Min=1, var/Max=5, var/Limit=null)
	var/href = "<A href='?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit) return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate


#undef SMESRATE
