
/obj/structure/geyser
	name = "steam geyser"
	desc = "Heated gases venting out from under the surface."
	icon = 'gas_geyser.dmi'
	icon_state = "idle"
	anchored = 1
	var/gas_colour = "white"
	var/venting = 0
	var/datum/gas_mixture/gas_output
	var/time_last_vent = 0
	var/time_between_vent = 60
	var/duration_of_vent = 60
	var/maingas = "watervapour"
	var/list/optional_gases = list("hydrogen","carbon_dioxide")
	var/list/smoke_reagent_types = list(/datum/reagent/water)
	var/emit_temperature = 313
	layer = TURF_LAYER + 0.5

/obj/structure/geyser/New()
	. = ..()
	GLOB.processing_objects.Add(src)
	time_between_vent = rand(30,200)
	duration_of_vent = rand(10, 100)
	time_last_vent = world.time - rand(0, time_between_vent)
	emit_temperature += rand() * 100

	//setup the gas template
	gas_output = new(100, rand(40,120))
	setup_gases()

/obj/structure/geyser/proc/setup_gases()
	var/percent_left = 1
	var/main_gas_percent = 0.5 + rand() * 0.5
	gas_output.adjust_gas(maingas, 0.1 * MOLES_CELLSTANDARD * main_gas_percent)

	while(optional_gases.len && percent_left > 0)
		var/cur_gas = pick(optional_gases)
		optional_gases -= cur_gas

		var/cur_gas_percent = rand() *  percent_left
		percent_left -= cur_gas_percent

		gas_output.adjust_gas(cur_gas, 0.1 * MOLES_CELLSTANDARD * cur_gas_percent)

/obj/structure/geyser/ex_act()
	return

/obj/structure/geyser/process()
	if(venting)
		vent_gases()
		if(world.time > time_last_vent + duration_of_vent)
			venting = 0
			overlays.Cut()
	else
		if(world.time > time_last_vent + time_between_vent + duration_of_vent)
			venting = 1
			time_last_vent = world.time
			overlays.Add(gas_colour)
			vent_gases()

			//create a smoke effect
			var/obj/machinery/portable_atmospherics/gas_collector/collector = locate() in src.loc
			if(!collector || !collector.anchored)
				spawn_smoke(src.loc)
				var/smokenum = rand(3,5)
				var/list/dirsleft = GLOB.alldirs.Copy()
				for(var/i=0,i<smokenum,i++)
					var/pickdir = pick_n_take(dirsleft)
					var/turf/target_tur = get_step(src, pickdir)
					spawn_smoke(target_tur)

/obj/structure/geyser/proc/spawn_smoke(var/turf/target_turf)

	var/obj/effect/effect/smoke/chem/smoke = new (src.loc, duration_of_vent, target_turf)

	var/datum/reagents/carry = smoke.reagents
	for(var/reagent_type in smoke_reagent_types)
		carry.add_reagent(reagent_type, 100)

/obj/structure/geyser/proc/vent_gases()
	//fill up any attached gas collectors
	var/obj/machinery/portable_atmospherics/gas_collector/collector = locate() in src.loc

	if(collector && collector.anchored)
		//create some new gas
		var/datum/gas_mixture/new_gas = new(100, gas_output.temperature)
		for(var/cur_gas in gas_output.gas)
			new_gas.adjust_gas(cur_gas, gas_output.gas[cur_gas])
		new_gas.temperature = emit_temperature

		//send it over
		return collector.recieve_gas(new_gas)

	return 0



/obj/structure/geyser/natural_gas
	name = "gas geyser"
	gas_colour = "cream"
	maingas = "methane"
	optional_gases = list("nitrogen","hydrogen","helium")

/obj/structure/geyser/noble_gas
	name = "gas geyser"
	gas_colour = "green"
	maingas = "methane"
	optional_gases = list("neon","xenon","krypton","argon")

/obj/structure/geyser/volcanic_gas
	name = "volcanic gas geyser"
	gas_colour = "black"
	maingas = "hydrogen"
	optional_gases = list("carbon_dioxide","watervapour")
	smoke_reagent_types = list(/datum/reagent/toxin/phoron)

/obj/structure/geyser/toxic_gas
	name = "toxic gas geyser"
	gas_colour = "red"
	maingas = "carbonmonoxide"
	optional_gases = list("sulfurdioxide","chlorine","watervapour","hydrogen")
	smoke_reagent_types = list(/datum/reagent/toxin/phoron)
