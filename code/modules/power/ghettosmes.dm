//TODO: en Topic(), el dialogo no pone el Xput_level_max, sino 200k. Ademas se repite. Muy probablemente debido al ..() de topic
//DONE: attackby de code/defines/obj/weapon.dm/power module
//TODO: dangers
//TODO: mas tests

/obj/item/weapon/circuitboard/ghettosmes
	name = "Circuit board (PSU)"
	desc = "An APC circuit repurposed into some power storage device controller"
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
	input_level_max = 0
	output_level_max = 0
	var/cells_amount = 0
	var/capacitors_amount = 0
	var/overcharge_percent = 0


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
	capacity = C * 40   //Basic cells are such crap. Hyper cells needed to get on normal SMES levels.


/obj/machinery/power/smes/ghetto/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob) //these can only be moved by being reconstructed, solves having to remake the powernet.
	..() //SMES attackby for now handles screwdriver, cable coils and wirecutters, no need to repeat that here
	if(open_hatch)
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
					user << "<span class='warning'>Turn off the [src] before.</span>"
			else
				user << "<span class='warning'>Better let [src] discharge before dismantling it.</span>"
		else if ((istype(W, /obj/item/weapon/stock_parts/capacitor) && (capacitors_amount < 5)) || (istype(W, /obj/item/weapon/cell) && (cells_amount < 5)))
			if (charge < (capacity / 100))
				if (!online && !chargemode)
					user.drop_item()
					component_parts += W
					W.loc = src
					RefreshParts()
					user << "<span class='notice'>You upgrade the [src] with [W.name].</span>"
				else
					user << "<span class='warning'>Turn off the [src] before.</span>"
			else
				user << "<span class='warning'>Better let [src] discharge before putting your hand inside it.</span>"
		else
			user.set_machine(src)
			interact(user)
			return 1
	return

//This mess of if-elses and magic numbers handles what happens if the engies don't pay attention and let it eat too much charge
//What happens depends on how much capacity has the ghetto smes and how much it is overcharged.
//Under 1.2M: 5% of ion_act() per process() tick from 125% and higher overcharges. 1.2M is achieved with 3 high cells.
//[1.2M-2.4M]: 6% ion_act from 120%. 5% of EMP from 140%.
//(2.4M-3.6M] :6% ion_act from 115%. 5% of EMP from 130%. Non-hull-breaching explosion at 150%.
//(3.6M-INFI): 6% ion_act from 115%. 5% of EMP from 125%. Hull-breaching explosion from 140%.
/obj/machinery/power/smes/ghetto/proc/overcharge_consequences()
	world << "Proc called"
	if (capacity < 1.2e6)
		world << "cap 1.2e6"
		if (overcharge_percent >= 125)
			world << "if entered, rolling"
			if (prob(5))
				world << "roll success"
				ion_act()
	else if (capacity <= 2.4e6)
		world << "cap 2.4e6"
		if (overcharge_percent >= 120)
			world << "if entered"
			if (prob(6))
				world << "roll success"
				ion_act()
		else
			return
		if (overcharge_percent >= 140)
			world << "second if"
			if (prob(1))
				world << "roll success"
				empulse(src.loc, 3, 8, 1)
	else if (capacity <= 3.6e6)
		world << "cap 3.6"
		if (overcharge_percent >= 115)
			world << "if entered"
			if (prob(7))
				world << "roll success"
				ion_act()
		else
			return
		if (overcharge_percent >= 130)
			world << "second if"
			if (prob(1))
				world << "roll success"
				empulse(src.loc, 3, 8, 1)
		if (overcharge_percent >= 150)
			world << "third if"
			if (prob(1))
				world << "roll success"
				explosion(src.loc, 0, 1, 3, 5)
	else //capacity > 3.6e6
		world << "cap >3.6"
		if (overcharge_percent >= 115)
			world << "if entered"
			if (prob(8))
				world << "roll success"
				ion_act()
		else
			return
		if (overcharge_percent >= 125)
			world << "second if"
			if (prob(2))
				world << "roll success"
				empulse(src.loc, 4, 10, 1)
		if (overcharge_percent >= 140)
			world << "third if"
			if (prob(1))
				world << "roll success"
				explosion(src.loc, 1, 3, 5, 8)


#define SMESRATE 0.05			// rate of internal charge to external power
/obj/machinery/power/smes/ghetto/process()
	if(stat & BROKEN)	return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = charging
	var/last_onln = online

	if(terminal)
		var/excess = terminal.surplus()

		if(charging)
			if(excess >= 0)		// if there's power available, try to charge
				var/load = min((capacity * 1.5 - charge)/SMESRATE, chargelevel)		// charge at set rate, limited to spare capacity
				charge += load * SMESRATE	// increase the charge
				add_load(load)		// add the load to the terminal side network

			else					// if not enough capacity
				charging = 0		// stop charging

		else
			if (chargemode && excess > 0 && excess >= chargelevel)
				charging = 1

	if(online)		// if outputting
		lastout = min( charge/SMESRATE, output)		//limit output to that stored
		charge -= lastout*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(lastout)				// add output to powernet (smes side)
		if(charge < 0.0001)
			online = 0					// stop output if charge falls to zero

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != charging || last_onln != online)
		updateicon()

	overcharge_percent = ((charge / capacity) * 100)
	if (overcharge_percent > 115) //115% is the minimum overcharge for anything to happen
		overcharge_consequences()
	return

#undef SMESRATE
