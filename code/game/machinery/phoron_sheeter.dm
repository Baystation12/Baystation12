/obj/machinery/phoron_desublimer
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 0
	delay = 60
	var/ready = 0

	proc/report_ready()
		return ready


/obj/machinery/phoron_desublimer/gas_intake
	name = "Gas Buffer"
	desc = "Gas goes into here to be superheated to prepare for crystalization."
	icon_state = "Pumped"
	var/datum/gas_mixture/air_contents = new
	var/heating_power = 500000
	active_power_usage = 500000

	New()
		..()
		name = "Gas Buffer"
		desc = "Gas goes into here to be superheated to prepare for crystalization."
		icon_state = "Pumped"

	Process()
		..()

		air_contents.react()

		idle_power_usage = 0
		if( active )
			icon_state = "Pumping"
			heat_gas()
			idle_power_usage = heat_transfer

	report_ready()
		for( /obj/machinery/phoron_desublimer/M in orange(src) )
			if( istype( M, /obj/machinery/phoron_desublimer/crystalizer ))
				ready = 1

		return ready

	proc/heat_gas() // Heating the contained gas
		var/heat_transfer = air_contents.get_thermal_energy_change(set_temperature)

		heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

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

	Process()
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

		for( /obj/machinery/phoron_desublimer/M in orange(src) )
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

	Process()
		..()

		if( active )
			press()

	proc/press()
		flick("Pressing", src)
		var/obj/item/stack/sheet/mineral/phoron/P = new(get_turf(src))
		P.amount = 1
		active = 0

	report_ready()
		for( /obj/machinery/phoron_desublimer/M in orange(src) )
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
	construction_state = 0
	active = 0

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
					src.connected_parts.Add(PA)

	proc/check_parts()
		for( var/obj/machinery/phoron_desublimer/PD in orange(src) )
			if(istype(PD, type))
				if(PD.report_ready())
					src.connected_parts.Add(PA)