/obj/machinery/atmospherics/miner
	name = "gas miner"
	desc = "Gasses mined from the gas giant below (above?) flow out through this massive vent."
	icon = 'icons/obj/atmospherics/miner.dmi'
	icon_state = "miner"

	density = 1
	anchored = 1

	w_class = ITEM_SIZE_LARGE

	power_channel = ENVIRON
	use_power = 150
	idle_power_usage = 500

	var/on = 1
	var/air_type = "oxygen"

/obj/machinery/atmospherics/miner/oxygen
	air_type = "oxygen"

/obj/machinery/atmospherics/miner/nitrogen
	air_type = "nitrogen"

/obj/machinery/atmospherics/miner/carbon_dioxide
	air_type = "carbon_dioxide"

/obj/machinery/atmospherics/miner/sleeping_agent
	air_type = "sleeping_agent"

/obj/machinery/atmospherics/miner/phoron
	air_type = "phoron"

/obj/machinery/atmospherics/miner/process()
	..()
	update_icon()
	if(!on)
		return
	if(!anchored)
		return
	if(!istype(loc,/turf/simulated))
		return

	var/datum/gas_mixture/environment = loc.return_air()
	var/pressure_delta = 10000 - environment.return_pressure()
	var/output_volume = environment.volume * environment.group_multiplier
	var/air_temperature = environment.temperature
	var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)
	environment.adjust_gas(air_type, min(transfer_moles, 300))

/obj/machinery/atmospherics/miner/Click()
	if(istype(usr, /mob/living/silicon/ai))
		usr.examinate(src)
		return 1

	return ..()

/obj/machinery/atmospherics/miner/attack_hand(mob/user)
	on = !on

/obj/machinery/atmospherics/miner/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
			if (do_after(user, 40, src))
				user.visible_message( \
					"<span class='notice'>\The [user] unfastens \the [src].</span>", \
					"<span class='notice'>You have unfastened \the [src].</span>", \
					"You hear ratcheting.")
		else
			to_chat(user, "<span class='notice'>You begin to fasten \the [src]...</span>")
			if (do_after(user, 40, src))
				user.visible_message( \
					"<span class='notice'>\The [user] fastens \the [src].</span>", \
					"<span class='notice'>You have fastened \the [src].</span>", \
					"You hear ratcheting.")