/obj/machinery/phoron_sheeter
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 0
	delay = 60

/obj/machinery/phoron_sheeter/gas_intake
	name = "Gas Buffer"
	desc = "Gas goes into here to be superheated to prepare for crystalization."
	icon_state = "Pumped"
	var/datum/gas_mixture/air_contents = new
	var/heating_power = 500000

	New()
		..()
		name = "Gas Buffer"
		desc = "Gas goes into here to be superheated to prepare for crystalization."
		icon_state = "Pumped"

	Process()
		..()

		air_contents.react()

		idle_power_usage = 0
		if( operating )
			icon_state = "Pumping"
			heat_gas()
			idle_power_usage = heat_transfer

	heat_gas() // Heating the contained gas
		var/heat_transfer = air_contents.get_thermal_energy_change(set_temperature)

		heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

		air_contents.add_thermal_energy(heat_transfer)


/obj/machinery/phoron_sheeter/crystalizer
	name = "Phoron Crystalizer"
	desc = "Superheated"
	icon_state = "ProcessorEmpty"
	var/datum/gas_mixture/air_contents = new

	New()
		..()
		name = "Phoron Crystalizer"
		desc = "Superheated"
		icon_state = "ProcessorEmpty"

	Process()
		..()
		if( operating )
			icon_state = "ProcessorFull"


	start_fill()
		flick("ProcessorFill", src)
		idle_power_usage = 10000
		operating = 1

	crystalize()
		flick("ProcessorCrystalize", src)
		idle_power_usage = 0
		operating = 0


/obj/machinery/phoron_sheeter/compressor
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

		if( operating )
			icon_state = "Pressing"

	press()
		flick("Pressing", src)



/obj/machinery/computer/phoron_sheeter_control
	name = "Phoron Sheeter"
	desc = "Gas goes in one end, sheet comes out the other."
	icon = 'icons/obj/machines/phoron_compressor.dmi'
	icon_state = "Ready"