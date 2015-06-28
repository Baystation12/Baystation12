/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	density = 1
	anchored = 0

	use_power = 1
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.

	var/max_power = 500000
	var/thermal_efficiency = 0.65

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = 0

/obj/machinery/power/generator/New()
	..()
	desc = initial(desc) + " Rated for [round(max_power/1000)] kW."
	spawn(1)
		reconnect()

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the NORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	circ1 = null
	circ2 = null
	if(src.loc && anchored)
		if(src.dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)

			if(circ1 && circ2)
				if(circ1.dir != NORTH || circ2.dir != SOUTH)
					circ1 = null
					circ2 = null

		else if(src.dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,NORTH)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 = null
				circ2 = null

/obj/machinery/power/generator/proc/updateicon()
	if(stat & (NOPOWER|BROKEN))
		overlays.Cut()
	else
		overlays.Cut()

		if(lastgenlev != 0)
			overlays += image('icons/obj/power.dmi', "teg-op[lastgenlev]")

/obj/machinery/power/generator/process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		stored_energy = 0
		return

	updateDialog()

	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()

	lastgen2 = lastgen1
	lastgen1 = 0
	last_thermal_gen = 0
	last_circ1_gen = 0
	last_circ2_gen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
			var/heat = energy_transfer*(1-thermal_efficiency)
			last_thermal_gen = energy_transfer*thermal_efficiency

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity

	//Transfer the air
	if (air1)
		circ1.air2.merge(air1)
	if (air2)
		circ2.air2.merge(air2)

	//Update the gas networks
	if(circ1.network2)
		circ1.network2.update = 1
	if(circ2.network2)
		circ2.network2.update = 1

	//Exceeding maximum power leads to some power loss
	if(effective_gen > max_power && prob(5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		stored_energy *= 0.5

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// update icon overlays and power usage only if displayed level has changed
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		updateicon()
	add_avail(effective_gen)

/obj/machinery/power/generator/attack_ai(mob/user)
	if(stat & (BROKEN|NOPOWER)) return
	interact(user)

/obj/machinery/power/generator/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")
		use_power = anchored
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
	else
		..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored) return
	interact(user)


/obj/machinery/power/generator/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) && (!istype(user, /mob/living/silicon/ai)))
		user.unset_machine()
		user << browse(null, "window=teg")
		return

	user.set_machine(src)

	var/t = "<PRE><B>Thermoelectric Generator</B><HR>"
	t += "Total Output: [round(effective_gen/1000)] kW<HR>"
	t += "Thermal Output: [round(last_thermal_gen/1000)] kW<BR>"
	t += " <BR>"

	var/vertical = 0
	if (dir == NORTH || dir == SOUTH)
		vertical = 1

	if(circ1 && circ2)
		t += "<B>Primary Circulator ([vertical ? "top" : "left"])</B><BR>"
		t += "Turbine Output: [round(last_circ1_gen/1000)] kW<BR>"
		t += "Flow Capacity: [round(circ1.volume_capacity_used*100)]%<BR>"
		t += " <BR>"
		t += "Inlet Pressure: [round(circ1.air1.return_pressure(), 0.1)] kPa<BR>"
		t += "Inlet Temperature: [round(circ1.air1.temperature, 0.1)] K<BR>"
		t += " <BR>"
		t += "Outlet Pressure: [round(circ1.air2.return_pressure(), 0.1)] kPa<BR>"
		t += "Outlet Temperature: [round(circ1.air2.temperature, 0.1)] K<BR>"
		t += " <BR>"
		t += "<B>Secondary Circulator ([vertical ? "bottom" : "right"])</B><BR>"
		t += "Turbine Output: [round(last_circ2_gen/1000)] kW<BR>"
		t += "Flow Capacity: [round(circ2.volume_capacity_used*100)]%<BR>"
		t += " <BR>"
		t += "Inlet Pressure: [round(circ2.air1.return_pressure(), 0.1)] kPa<BR>"
		t += "Inlet Temperature: [round(circ2.air1.temperature, 0.1)] K<BR>"
		t += " <BR>"
		t += "Outlet Pressure: [round(circ2.air2.return_pressure(), 0.1)] kPa<BR>"
		t += "Outlet Temperature: [round(circ2.air2.temperature, 0.1)] K<BR>"

	else
		t += "Unable to connect to circulators.<br>"
		t += "Ensure both are in position and wrenched into place."

	t += " <BR>"
	t += "<HR>"
	t += "<A href='?src=\ref[src]'>Refresh</A> <A href='?src=\ref[src];close=1'>Close</A>"

	user << browse(t, "window=teg;size=400x500")
	onclose(user, "teg")
	return 1


/obj/machinery/power/generator/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=teg")
		usr.unset_machine()
		return 0

	updateDialog()
	return 1


/obj/machinery/power/generator/power_change()
	..()
	updateicon()


/obj/machinery/power/generator/verb/rotate_clock()
	set category = "Object"
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/power/generator/verb/rotate_anticlock()
	set category = "Object"
	set name = "Rotate Generator (Counterclockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, -90))
