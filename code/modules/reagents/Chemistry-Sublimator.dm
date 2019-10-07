/proc/create_gas_data_for_reagent(var/datum/reagent/reagent)

	var/kill_later
	if(ispath(reagent))
		kill_later = TRUE
		reagent = new reagent

	if(!istype(reagent))
		return

	var/gas_id = lowertext(reagent.name)
	if(gas_id in gas_data.gases)
		return

	gas_data.gases +=                   gas_id
	gas_data.name[gas_id] =             reagent.name
	gas_data.specific_heat[gas_id] =    reagent.gas_specific_heat
	gas_data.molar_mass[gas_id] =       reagent.gas_molar_mass
	gas_data.overlay_limit[gas_id] =    reagent.gas_overlay_limit
	gas_data.flags[gas_id] =            reagent.gas_flags
	gas_data.burn_product[gas_id] =     reagent.gas_burn_product
	gas_data.breathed_product[gas_id] = reagent.type

	if(reagent.gas_overlay)
		var/obj/effect/gas_overlay/I = new()
		I.icon_state = reagent.gas_overlay
		I.color = initial(reagent.color)
		gas_data.tile_overlay[gas_id] = I
		gas_data.tile_overlay_color[gas_id] = reagent.color

	if(kill_later)
		qdel(reagent)

/obj/machinery/portable_atmospherics/reagent_sublimator
	name = "reagent sublimator"
	desc = "An advanced machine that converts liquid or solid reagents into gasses."
	icon = 'icons/obj/subliminator.dmi'
	icon_state = "sublimator-off-unloaded-notank"
	density = TRUE
	use_power = POWER_USE_IDLE

	var/icon_set = "subliminator"
	var/sublimated_units_per_tick = 20
	var/obj/item/weapon/reagent_containers/container
	var/list/reagent_whitelist //if this is set, the subliminator will only work with the listed reagents
	var/output_temperature = T20C

/obj/machinery/portable_atmospherics/reagent_sublimator/New()
	. = ..()
	if(holding)   verbs |= /obj/machinery/portable_atmospherics/reagent_sublimator/proc/remove_tank
	if(container) verbs |= /obj/machinery/portable_atmospherics/reagent_sublimator/proc/remove_container
	update_icon()

// Coded this before realizing base type didn't support tank mixing, leaving it in just in case someone decides to add it.
/obj/machinery/portable_atmospherics/reagent_sublimator/proc/remove_tank()

	set name = "Remove Gas Tank"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	if(holding)
		user.put_in_hands(holding)
		user.visible_message("<span class='notice'>\The [user] removes \the [holding] from \the [src].</span>")
		holding = null
		verbs -= /obj/machinery/portable_atmospherics/reagent_sublimator/proc/remove_tank
		update_icon()
	else
		to_chat(user, "<span class='warning'>\The [src] has no gas tank loaded.</span>")

/obj/machinery/portable_atmospherics/reagent_sublimator/proc/remove_container()

	set name = "Remove Reagent Container"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	if(container)
		user.put_in_hands(container)
		user.visible_message("<span class='notice'>\The [user] removes \the [container] from \the [src].</span>")
		container = null
		verbs -= /obj/machinery/portable_atmospherics/reagent_sublimator/proc/remove_container
		if(use_power >= POWER_USE_ACTIVE)
			update_use_power(POWER_USE_IDLE)
		update_icon()
	else
		to_chat(user, "<span class='warning'>\The [src] has no reagent container loaded.</span>")

/obj/machinery/portable_atmospherics/reagent_sublimator/physical_attack_hand(var/mob/user)
	update_use_power(use_power == POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
	user.visible_message("<span class='notice'>\The [user] switches \the [src] [use_power == 2 ? "on" : "off"].</span>")
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/reagent_sublimator/attackby(var/obj/item/weapon/thing, var/mob/user)
	if(istype(thing, /obj/item/weapon/tank))
		to_chat(user, "<span class='warning'>\The [src] has no socket for a gas tank.</span>")
	else if(istype(thing, /obj/item/weapon/reagent_containers))
		if(container)
			to_chat(user, "<span class='warning'>\The [src] is already loaded with \the [container].</span>")
		else if(user.unEquip(thing, src))
			container = thing
			user.visible_message("<span class='notice'>\The [user] loads \the [thing] into \the [src].</span>")
			verbs |= /obj/machinery/portable_atmospherics/reagent_sublimator/proc/remove_container
		update_icon()
	else
		. = ..()

/obj/machinery/portable_atmospherics/reagent_sublimator/Process()

	. = ..()

	if(. == PROCESS_KILL)
		return

	if(stat & (BROKEN|NOPOWER))
		if(use_power)
			update_use_power(POWER_USE_OFF)
			update_icon()
		return

	if(use_power >= POWER_USE_ACTIVE && container && container.reagents)
		if(reagent_whitelist)
			for(var/datum/reagent/R in container.reagents.reagent_list)
				if(!is_type_in_list(R, reagent_whitelist))
					audible_message(SPAN_NOTICE("\The [src] pings rapidly and powers down, refusing to process the contents of \the [container]."))
					update_use_power(POWER_USE_OFF)
					update_icon()
					return

		var/datum/gas_mixture/produced = new
		var/added_gas = FALSE
		for(var/datum/reagent/R in container.reagents.reagent_list)
			var/gas_id = lowertext(R.name)
			if(!(gas_id in gas_data.gases))
				create_gas_data_for_reagent(R)
			var/sublimate_this_tick = min(sublimated_units_per_tick, R.volume)
			container.reagents.remove_reagent(R.type, sublimate_this_tick)
			produced.adjust_gas(gas_id, sublimate_this_tick / REAGENT_GAS_EXCHANGE_FACTOR)
			added_gas = TRUE
			if(produced.total_moles >= sublimated_units_per_tick)
				break
		if(added_gas)
			produced.temperature = output_temperature
			air_contents.merge(produced)
		else
			visible_message("<span class='notice'>\The [src] pings as it finishes processing the contents of \the [container].</span>")
			update_use_power(POWER_USE_IDLE)
			update_icon()

/obj/machinery/portable_atmospherics/reagent_sublimator/on_update_icon()
	icon_state = "[icon_set]-[use_power == POWER_USE_ACTIVE ? "on" : "off"]-[container ? "loaded" : "unloaded"]-[holding ? "tank" : "notank"]"

/obj/machinery/portable_atmospherics/reagent_sublimator/examine(mob/user)
	. = ..()
	if(container)
		if(container.reagents && container.reagents.total_volume)
			to_chat(user, "\The [src] has \a [container] loaded. It contains [container.reagents.total_volume]u of reagents.")
		else
			to_chat(user, "\The [src] has \a [container] loaded. It is empty.")
	if(holding)
		to_chat(user, "\The [src] has \a [holding] connected.")
	if(reagent_whitelist)
		to_chat(user, "\The [src]'s safety light is on.")

/obj/machinery/portable_atmospherics/reagent_sublimator/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged && length(reagent_whitelist))
		emagged = TRUE
		reagent_whitelist.Cut()
		to_chat(user, "\The [src]'s safety light turns off.")
		return 1

/obj/machinery/portable_atmospherics/reagent_sublimator/sauna
	name = "sauna heater"
	desc = "A top of the line electric sauna heater - it accepts water, and produces steam. Wow!"
	icon_state = "sauna-off-unloaded-notank"
	icon_set = "sauna"
	reagent_whitelist = list(/datum/reagent/water)
	output_temperature = T0C+40
