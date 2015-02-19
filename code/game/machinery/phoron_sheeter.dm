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


/obj/machinery/phoron_desublimer/gas_intake
	name = "Gas Buffer"
	desc = "Gas goes into here to be superheated to prepare for crystalization."
	icon_state = "Pumped"
	var/datum/gas_mixture/air_contents = new
	var/heating_power = 500000
	active_power_usage = 500000
	var/set_temperature = 100000

	New()
		..()
		name = "Gas Buffer"
		desc = "Gas goes into here to be superheated to prepare for crystalization."
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
			if( istype( M, /obj/machinery/phoron_desublimer/crystalizer ))
				ready = 1

		return ready

	proc/heat_gas() // Heating the contained gas
		var/heat_transfer = air_contents.get_thermal_energy_change(set_temperature)

		heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

		idle_power_usage = heat_transfer
		air_contents.add_thermal_energy(heat_transfer)


/obj/machinery/phoron_desublimer/crystalizer
	name = "Phoron Crystalizer"
	desc = "Superheated"
	icon_state = "ProcessorEmpty"
	var/datum/gas_mixture/air_contents = new
	active_power_usage = 10000

	New()
		..()
		name = "Phoron Crystalizer"
		desc = "Superheated"
		icon_state = "ProcessorEmpty"

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
			if( istype( M, /obj/machinery/phoron_desublimer/gas_intake ))
				gas_intake = 1
			else if( istype( M, /obj/machinery/phoron_desublimer/compressor ))
				compressor = 1

		if( gas_intake && compressor )
			ready = 1

		return ready


/obj/machinery/phoron_desublimer/compressor
	name = "Phoron Compressor"
	desc = "Moulds the phoron crystal into a sheet."
	icon_state = "Pressed"

	New()
		..()
		name = "Phoron Compressor"
		desc = "Moulds the phoron crystal into a sheet."
		icon_state = "Pressed"

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
			if( istype( M, /obj/machinery/phoron_desublimer/crystalizer ))
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

	var/list/obj/machinery/phoron_desublimer/connected_parts

	New()
		..()
		name = "Phoron Desublimation Control"
		desc = "Controls the phoron desublimation process."
		icon_state = "Ready"


	proc/find_parts()
		for( var/obj/machinery/phoron_desublimer/PD in orange(src) )
			if(istype(PD, type))
				if(PD.report_ready())
					src.connected_parts.Add(PD)

		return 1

	proc/check_parts()
		for( var/obj/machinery/phoron_desublimer/PD in orange(src) )
			if(istype(PD, type))
				if(PD.report_ready())
					src.connected_parts.Add(PD)

	interact(mob/user)
		var/assembled = 0

		if(find_parts())
			assembled = 1

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
		if(!assembled)
			dat += "Unable to detect all parts!<BR>"
			dat += "<A href='?src=\ref[src];scan=1'>Run Scan</A><BR><BR>"
		else
			dat += "All parts in place.<BR><BR>"

		user << browse(dat, "window=pdcontrol;size=420x500")
		onclose(user, "pdcontrol")
		return
