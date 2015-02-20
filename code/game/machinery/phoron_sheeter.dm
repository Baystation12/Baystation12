/*
///////////// PHORON DESUBLIMER ////////////////
	~~Created by Kwask, sprites by Founded1992~~
Desc: This is a machine which will take gaseous phoron and turns it into bars OR supermatter shards
The process works like this:
	1.) Gaseous phoron is pumped into the Hyperinductor. This machine is basically a super heater, as it can heat gas up to 500,000 kelvin
	2.) Gas is heated up to the optimal temperature for crystalization, which is randomly determined at round start.
	3.) After the gas is hot enough, it is injected into the reaction chamber. The reaction chamber must be at a specific pressure.
		If it is too low, then there is waste product, and if it is too high, you risk breaking the machine.
	4.) The supermatter shard is then formed and extracted from the machine and sent into the compressor

	FOR BARS
	5.) Place the supermatter shard inside and choose "phoron bars" as the output.
	6.) The compressor then uses a set PSI and speed to stamp the shard into a sheet. PSI and speed is important here.
		Higher PSI means more sheets, but if you go too high, you can shatter the crystal and waste it.
		Speed is similar, but speeding it up simply makes it go faster, until the breaking point
	7.) Congrats, you now have any number of phoron bars based on how efficient your process was!

	FOR SUPERMATTER
	5.) Produce 9 supermatter shards at the pressure vessel, then bring them to the compressor.
		Place them inside and choose "Supermatter" as output. Set the PSI as high as possible and speed as low as possible.
	6.) Congrats, you now have a supermatter core!

*/

/obj/machinery/phoron_desublimer
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 0
	var/ready = 0
	var/active = 0

	proc/report_ready()
		return ready


/obj/machinery/phoron_desublimer/inductor
	name = "Hyperinductor"
	desc = "Gas goes into here to be superheated to prepare for crystalization."
	icon_state = "Pumped"
	var/datum/gas_mixture/air_contents = new
	var/heating_power = 500000
	active_power_usage = 500000
	var/set_temperature = 100000

	New()
		..()
		icon_state = "Pumped"

	process()
		..()

		air_contents.react()

		idle_power_usage = 0
		if( active )
			icon_state = "Pumping"
			heat_gas()

	report_ready()
		for( var/obj/machinery/phoron_desublimer/M in orange(src) )
			if( istype( M, /obj/machinery/phoron_desublimer/vessel ))
				ready = 1

		return ready

	proc/heat_gas() // Heating the contained gas
		var/heat_transfer = air_contents.get_thermal_energy_change(set_temperature)

		heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

		idle_power_usage = heat_transfer
		air_contents.add_thermal_energy(heat_transfer)


/obj/machinery/phoron_desublimer/vessel
	name = "Reactant Vessel"
	desc = "Created supermatter shards from high-temperature phoron."
	icon_state = "ProcessorEmpty"
	var/datum/gas_mixture/air_contents = new
	active_power_usage = 10000

	New()
		..()

	process()
		..()
		if( active )
			icon_state = "ProcessorFull"

	proc/start_fill()
		flick("ProcessorFill", src)
		active = 1

	proc/crystalize()
		flick("ProcessorCrystalize", src)
		active = 0

	report_ready()
		var/gas_intake = 0
		var/compressor = 0

		for( var/obj/machinery/phoron_desublimer/M in orange(src) )
			if( istype( M, /obj/machinery/phoron_desublimer/inductor ))
				gas_intake = 1
			else if( istype( M, /obj/machinery/phoron_desublimer/anvil ))
				compressor = 1

		if( gas_intake && compressor )
			ready = 1

		return ready


/obj/machinery/phoron_desublimer/anvil
	name = "Supermatter Giga-Anvil"
	desc = "Moulds the supermatter into the desired product."
	icon_state = "Pressed"

	New()
		..()

	process()
		..()

		if( active )
			press()

	proc/press()
		flick("Pressing", src)
		var/obj/item/stack/sheet/mineral/phoron/P = new(get_turf(src))
		P.amount = 1
		active = 0

	report_ready()
		for( var/obj/machinery/phoron_desublimer/M in orange(src) )
			if( istype( M, /obj/machinery/phoron_desublimer/vessel ))
				ready = 1

		return ready


/obj/machinery/computer/phoron_desublimer_control
	name = "Phoron Desublimation Control"
	desc = "Controls the phoron desublimation process."
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	icon_state = "Ready"

	idle_power_usage = 500
	active_power_usage = 70000 //70 kW per unit of strength
	var/active = 0
	var/assembled = 0

	var/list/obj/machinery/phoron_desublimer/connected_parts

	var/list/checklist = list( "inductor" = 0, "vessel" = 0, "anvil" = 0 )

	New()
		..()


	proc/find_parts()
		connected_parts = list()

		for( var/obj/machinery/phoron_desublimer/PD in orange(src) )
			if(PD.report_ready())
				src.connected_parts.Add(PD)

		return

	proc/check_parts()
		assembled = 0
		find_parts()

		for( var/i = 1, i <= checklist.len, i++ )
			checklist[i] = 0

		for( var/obj/machinery/phoron_desublimer/PD in connected_parts )
			if( istype( PD, /obj/machinery/phoron_desublimer/inductor ))
				checklist["inductor"] = PD
			else if( istype( PD, /obj/machinery/phoron_desublimer/vessel ))
				checklist["vessel"] = PD
			else if( istype( PD, /obj/machinery/phoron_desublimer/anvil ))
				checklist["anvil"] = PD

		var/count = 0

		for( var/i = 1, i <= checklist.len, i++ )
			if( checklist[i] )
				count++

		if( count == 3 )
			assembled = 1

		return

	attack_hand(mob/user as mob)
		interact(user)

	interact(mob/user)
		if((get_dist(src, user) > 1) || (stat & (BROKEN|NOPOWER)))
			if(!istype(user, /mob/living/silicon))
				user.unset_machine()
				user << browse(null, "window=pacontrol")
				return
		user.set_machine(src)

		var/dat = ""
		dat += "Phoron Desublimer Controller<BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A><BR><BR>"
		dat += "Status:<BR>"
		if( !assembled )
			dat += "Unable to detect all parts!<BR>"
			dat += "<A href='?src=\ref[src];scan=1'>Run Scan</A><BR><BR>"
		else
			dat += "All parts in place.<BR><BR>"

		user << browse(dat, "window=pdcontrol;size=420x500")
		onclose(user, "pdcontrol")
		return

	Topic(href, href_list)
		..()
		//Ignore input if we are broken, !silicon guy cant touch us, or nonai controlling from super far away
		if(stat & (BROKEN|NOPOWER) || (get_dist(src, usr) > 1 && !istype(usr, /mob/living/silicon)) || (get_dist(src, usr) > 8 && !istype(usr, /mob/living/silicon/ai)))
			usr << browse(null, "window=pdcontrol")
			usr.unset_machine()
			return

		if( href_list["close"] )
			usr << browse(null, "window=pdcontrol")
			usr.unset_machine()
			return
		else if(href_list["scan"])
			src.check_parts()

		src.updateDialog()
		src.update_icon()
		return