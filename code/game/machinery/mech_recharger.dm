/obj/machinery/mech_recharger
	name = "exosuit dock"
	desc = "A exosuit recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = FALSE
	layer = ABOVE_TILE_LAYER
	anchored = TRUE
	idle_power_usage = 200	// Some electronics, passive drain.
	active_power_usage = 60 KILOWATTS // When charging
	base_type = /obj/machinery/mech_recharger
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	
	machine_name = "exosuit dock"
	machine_desc = "An industrial recharger built into the floor. Exosuits standing on top of the dock will have their power cell recharged."

	var/mob/living/exosuit/charging
	var/base_charge_rate = 80 KILOWATTS
	var/repair_power_usage = 10 KILOWATTS		// Per 1 HP of health.
	var/repair = 0

/obj/machinery/mech_recharger/Crossed(var/mob/living/exosuit/M)
	. = ..()
	if(istype(M) && charging != M)
		start_charging(M)

/obj/machinery/mech_recharger/Uncrossed(var/mob/living/exosuit/M)
	. = ..()
	if(M == charging)
		stop_charging()

/obj/machinery/mech_recharger/RefreshParts()
	..()
	// Calculates an average rating of components that affect charging rate.
	var/chargerate_multiplier = total_component_rating_of_type(/obj/item/stock_parts/capacitor)
	chargerate_multiplier += total_component_rating_of_type(/obj/item/stock_parts/scanning_module)

	var/chargerate_divisor = number_of_components(/obj/item/stock_parts/capacitor)
	chargerate_divisor += number_of_components(/obj/item/stock_parts/scanning_module)

	repair = -5
	repair += 2 * total_component_rating_of_type(/obj/item/stock_parts/manipulator)
	repair += total_component_rating_of_type(/obj/item/stock_parts/scanning_module)

	if(chargerate_multiplier)
		change_power_consumption(base_charge_rate * (chargerate_multiplier / chargerate_divisor), POWER_USE_ACTIVE)
	else
		change_power_consumption(base_charge_rate, POWER_USE_ACTIVE)

/obj/machinery/mech_recharger/Process()
	if(!charging)
		update_use_power(POWER_USE_IDLE)
		return
	if(charging.loc != loc)
		stop_charging()
		return

	if(stat & (BROKEN|NOPOWER))
		stop_charging()
		charging.show_message(SPAN_WARNING("Internal system Error - Charging aborted."))
		return

	// Cell could have been removed.
	if(!charging.get_cell(TRUE))
		stop_charging()
		return

	var/remaining_energy = active_power_usage

	if(repair && !fully_repaired())
		for(var/obj/item/mech_component/MC in charging)
			if(MC)
				MC.repair_brute_damage(repair)
				MC.repair_burn_damage(repair)
				remaining_energy -= repair * repair_power_usage
			if(remaining_energy <= 0)
				break
		charging.updatehealth()
		if(fully_repaired())
			charging.show_message(SPAN_NOTICE("Exosuit integrity has been fully restored."))

	var/obj/item/cell/cell = charging.get_cell(TRUE)
	if(cell && !cell.fully_charged() && remaining_energy > 0)
		cell.give(remaining_energy * CELLRATE)
		if(cell.fully_charged())
			charging.show_message(SPAN_NOTICE("Exosuit power reserves are at maximum."))

	if((!repair || fully_repaired()) && cell.fully_charged())
		stop_charging()

// An ugly proc, but apparently mechs don't have maxhealth var of any kind.
/obj/machinery/mech_recharger/proc/fully_repaired()
	return charging && (charging.health == charging.maxHealth)

/obj/machinery/mech_recharger/proc/start_charging(var/mob/living/exosuit/M)
	if(stat & (NOPOWER | BROKEN))
		M.show_message(SPAN_WARNING("Power port not responding. Terminating."))
		return
	if(M.get_cell(TRUE))
		M.show_message(SPAN_NOTICE("Now charging..."))
		charging = M
		update_use_power(POWER_USE_ACTIVE)

/obj/machinery/mech_recharger/proc/stop_charging()
	update_use_power(POWER_USE_IDLE)
	charging = null