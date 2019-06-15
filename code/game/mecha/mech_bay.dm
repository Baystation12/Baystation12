/obj/machinery/mech_recharger
	name = "mech recharger"
	desc = "A mech recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = 0
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	anchored = 1
	idle_power_usage = 200	// Some electronics, passive drain.
	active_power_usage = 60 KILOWATTS // When charging
	base_type = /obj/machinery/mech_recharger

	var/obj/mecha/charging = null
	var/base_charge_rate = 60 KILOWATTS
	var/repair_power_usage = 10 KILOWATTS		// Per 1 HP of health.
	var/repair = 0

/obj/machinery/mech_recharger/Crossed(var/obj/mecha/M)
	. = ..()
	if(istype(M) && charging != M)
		start_charging(M)

/obj/machinery/mech_recharger/Uncrossed(var/obj/mecha/M)
	. = ..()
	if(M == charging)
		stop_charging()

/obj/machinery/mech_recharger/RefreshParts()
	..()
	// Calculates an average rating of components that affect charging rate.
	var/chargerate_multiplier = total_component_rating_of_type(/obj/item/weapon/stock_parts/capacitor)
	chargerate_multiplier += total_component_rating_of_type(/obj/item/weapon/stock_parts/scanning_module)

	var/chargerate_divisor = number_of_components(/obj/item/weapon/stock_parts/capacitor)
	chargerate_divisor += number_of_components(/obj/item/weapon/stock_parts/scanning_module)

	repair = -5
	repair += 2 * total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator)
	repair += total_component_rating_of_type(/obj/item/weapon/stock_parts/scanning_module)

	if(chargerate_multiplier)
		change_power_consumption(base_charge_rate * (chargerate_multiplier / chargerate_divisor), POWER_USE_ACTIVE)
	else
		change_power_consumption(base_charge_rate, POWER_USE_ACTIVE)

/obj/machinery/mech_recharger/Process()
	..()
	if(!charging)
		update_use_power(POWER_USE_IDLE)
		return
	if(charging.loc != loc)
		stop_charging()
		return

	if(stat & (BROKEN|NOPOWER))
		stop_charging()
		charging.occupant_message("<span class='warning'>Internal System Error - Charging aborted.</span>")
		return

	// Cell could have been removed.
	if(!charging.cell)
		stop_charging()
		return

	var/remaining_energy = active_power_usage

	if(repair && !fully_repaired())
		charging.health = min(charging.health + repair, initial(charging.health))
		remaining_energy -= repair * repair_power_usage
		if(fully_repaired())
			charging.occupant_message("<span class='notice'>Fully repaired.</span>")

	if(!charging.cell.fully_charged() && remaining_energy)
		charging.give_power(remaining_energy)
		if(charging.cell.fully_charged())
			charging.occupant_message("<span class='notice'>Fully charged.</span>")

	if((!repair || fully_repaired()) && charging.cell.fully_charged())
		stop_charging()

// An ugly proc, but apparently mechs don't have maxhealth var of any kind.
/obj/machinery/mech_recharger/proc/fully_repaired()
	return charging && (charging.health == initial(charging.health))

/obj/machinery/mech_recharger/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

/obj/machinery/mech_recharger/proc/start_charging(var/obj/mecha/M)
	if(stat & (NOPOWER | BROKEN))
		M.occupant_message("<span class='warning'>Power port not responding. Terminating.</span>")
		return

	if(M.cell)
		M.occupant_message("<span class='notice'>Now charging...</span>")
		charging = M
		update_use_power(POWER_USE_ACTIVE)

/obj/machinery/mech_recharger/proc/stop_charging()
	update_use_power(POWER_USE_IDLE)
	charging = null
