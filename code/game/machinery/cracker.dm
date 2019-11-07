/obj/machinery/portable_atmospherics/cracker
	name = "molecular cracking unit"
	desc = "An integrated catalytic water cracking system used to break H2O down into H and O. An advanced molecular extractor also allows it to isolate liquid deuterium from seawater."
	icon = 'icons/obj/machines/cracker.dmi'
	icon_state = "cracker"
	density = 1
	anchored = 1
	waterproof = TRUE
	volume = 5000
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 10000

	var/list/reagent_buffer = list()
	var/tmp/fluid_consumption_per_tick = 100
	var/tmp/gas_generated_per_tick = 1
	var/tmp/max_reagents = 100
	var/tmp/deuterium_generation_chance = 10
	var/tmp/deuterium_generation_amount = 1

/obj/machinery/portable_atmospherics/cracker/on_update_icon()
	icon_state = (use_power == POWER_USE_ACTIVE) ? "cracker_on" : "cracker"

/obj/machinery/portable_atmospherics/cracker/interface_interact(mob/user)
	if(use_power == POWER_USE_IDLE)
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)
	user.visible_message(SPAN_NOTICE("\The [user] [use_power == POWER_USE_ACTIVE ? "engages" : "disengages"] \the [src]."))
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/cracker/attackby(var/obj/item/thing, var/mob/user)
	// remove deuterium as a reagent
	if(thing.is_open_container() && thing.reagents)
		if(!reagent_buffer[MATERIAL_DEUTERIUM] || reagent_buffer[MATERIAL_DEUTERIUM] <= 0)
			to_chat(user, SPAN_WARNING("There is no deuterium stored in \the [src]."))
			return
		var/transfer_amt = min(thing.reagents.maximum_volume, reagent_buffer[MATERIAL_DEUTERIUM])
		thing.reagents.add_reagent(MATERIAL_DEUTERIUM, transfer_amt)
		thing.update_icon()
		reagent_buffer[MATERIAL_DEUTERIUM] -= transfer_amt
		user.visible_message(SPAN_NOTICE("\The [user] siphons [transfer_amt] unit\s of deuterium from \the [src] into \the [thing]."))
		return
	. = ..()

/obj/machinery/portable_atmospherics/cracker/power_change()
	. = ..()
	if(. && (stat & NOPOWER))
		update_use_power(POWER_USE_IDLE)
		update_icon()

/obj/machinery/portable_atmospherics/cracker/set_broken(new_state)
	. = ..()
	if(. && (stat & BROKEN))
		update_use_power(POWER_USE_IDLE)
		update_icon()

/obj/machinery/portable_atmospherics/cracker/Process()
	..()
	if(use_power == POWER_USE_IDLE)
		return

	// Produce materials.
	var/turf/T = get_turf(src)
	if(istype(T))
		var/obj/effect/fluid/F = T.return_fluid()
		if(istype(F))

			// Drink more water!
			var/consuming = min(F.fluid_amount, fluid_consumption_per_tick)
			LOSE_FLUID(F, consuming)
			T.show_bubbles()

			// Gas production.
			var/datum/gas_mixture/produced = new
			var/gen_amt = min(1, (gas_generated_per_tick * (consuming/fluid_consumption_per_tick)))
			produced.adjust_gas(GAS_OXYGEN,  gen_amt)
			produced.adjust_gas(GAS_HYDROGEN, gen_amt * 2)
			produced.temperature = T20C //todo water temperature
			air_contents.merge(produced)

			// Deuterium extraction.
			if(prob(deuterium_generation_chance) && (!reagent_buffer[MATERIAL_DEUTERIUM] || reagent_buffer[MATERIAL_DEUTERIUM] <= max_reagents))
				if(!reagent_buffer[MATERIAL_DEUTERIUM])
					reagent_buffer[MATERIAL_DEUTERIUM] = 0
				reagent_buffer[MATERIAL_DEUTERIUM] += deuterium_generation_amount