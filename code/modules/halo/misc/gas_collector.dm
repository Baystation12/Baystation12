
/obj/machinery/portable_atmospherics/gas_collector
	name = "gas collector"
	desc = "A device for mounting over natural gas geysers and harvesting the gas."
	icon = 'gas_collector.dmi'
	icon_state = "collector_human"
	volume = 1000
	use_power = 0
	density = 1
	anchored = 0
	interact_offline = 1
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP
	var/release_pressure = ONE_ATMOSPHERE
	var/max_pressure = TANK_LEAK_PRESSURE
	var/faction = "human"
	var/venting = 0
	var/obj/structure/geyser/secured_geyser
	var/list/gases_to_expel = list()
	var/list/gas_inventory = list()
	var/hitpoints = 300
	var/hitpoints_max = 300

/obj/machinery/portable_atmospherics/gas_collector/New()
	. = ..()
	update_gases_ui()

	//10% margin of safety here
	max_pressure = TANK_LEAK_PRESSURE * 0.9

/obj/machinery/portable_atmospherics/gas_collector/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	..()

	if(hitpoints < hitpoints_max)
		to_chat(user, "<span class='info'>It is [100 - round(100*hitpoints/hitpoints_max)]% damaged. It needs steel sheets to be repaired.</span>")

/obj/machinery/portable_atmospherics/gas_collector/bullet_act(var/obj/item/projectile/P)
	take_damage(P.damage)
	. = ..()

/obj/machinery/portable_atmospherics/gas_collector/ex_act()
	take_damage(75)
	. = ..()

/obj/machinery/portable_atmospherics/gas_collector/covenant
	icon_state = "collector_cov"
	faction = "cov"

/obj/machinery/portable_atmospherics/gas_collector/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/tank))
		if(holding)
			to_chat(user, "<span class='notice'>[src] is already holding [holding].</span>")
		else
			to_chat(user, "<span class='info'>You insert [I] into [src].</span>")
			user.drop_item()
			var/obj/item/weapon/tank/T = I
			T.loc = src
			holding = T
	else if(istype(I, /obj/item/weapon/wrench))
		anchored = !anchored
		if(anchored)
			visible_message("<span class='info'>[user] extends [src]'s stabilising legs into the ground. It will now harvest gas.</span>")
			secured_geyser = locate() in src.loc
		else
			visible_message("<span class='info'>[user] retracts [src]'s stabilising legs. It can now be moved</span>")
			secured_geyser = null

	else if(istype(I, /obj/item/stack/material/steel))
		to_chat(user,"\icon[src] <span class='info'>You begin repairing [src] with [I].</span>")
		if(do_after(user, 30, src))
			var/obj/item/stack/material/steel/old_stack = I
			var/obj/item/stack/material/steel/new_stack = old_stack.split(10)
			if(new_stack)
				hitpoints += new_stack.amount * 10
				hitpoints = min(hitpoints, hitpoints_max)
				qdel(new_stack)

	else
		take_damage(I.force)
		. = ..()

/obj/machinery/portable_atmospherics/gas_collector/proc/take_damage(var/amount)
	hitpoints -= amount
	if(hitpoints <= 0)
		qdel(src)
		var/turf/T = get_turf(src)
		spawn(0)
			explosion(T, 1, 3, 5, 7)

/obj/machinery/portable_atmospherics/gas_collector/proc/recieve_gas(var/datum/gas_mixture/new_gas)

	if(anchored)
		//add in the new gas
		air_contents.merge(new_gas)
		qdel(new_gas)

		var/do_expel = 0

		//expel any stuff we dont want
		var/datum/gas_mixture/expelled = new()
		for(var/curgas in gases_to_expel)
			var/moles = air_contents.get_gas(curgas)
			if(moles > 0)
				air_contents.adjust_gas(curgas, -moles)
				expelled.adjust_gas(curgas, moles)
				do_expel = 1

		//expel any excess pressure so we dont burst
		var/excess_pressure = air_contents.return_pressure() - max_pressure
		if(excess_pressure > 0)
			var/expel_ratio = excess_pressure / max_pressure
			var/datum/gas_mixture/expelled2 = air_contents.remove_ratio(expel_ratio)
			expelled.merge(expelled2)
			qdel(expelled2)
			do_expel = 1

		if(do_expel)
			expel_gas(expelled)

		update_gases_ui()
		return !do_expel

	return 0

/obj/machinery/portable_atmospherics/gas_collector/proc/expel_gas(var/datum/gas_mixture/vent_gas)
	var/datum/gas_mixture/environment = loc.return_air()
	environment.merge(vent_gas)
	qdel(vent_gas)

	if(venting <= 0)
		venting += 1
		//src.visible_message("<span class='notice'>[src] expels excess gas!</span>")
		overlays += "expel"

	venting += 1

/obj/machinery/portable_atmospherics/gas_collector/process()
	..()

	if(venting > 0)
		venting -= 1
		if(venting <= 0)
			overlays -= "expel"

	if(anchored && !secured_geyser)
		var/datum/gas_mixture/local = loc.return_air()
		var/datum/gas_mixture/newgas = local.remove_volume(CELL_VOLUME * 0.005)
		recieve_gas(newgas)

	/*
	if(holding)
		//copied from process() in code/game/machinery/atmoalter/canister.dm
		var/datum/gas_mixture/environment = holding.air_contents

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = air_contents.return_pressure() - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				update_gases_ui()
				*/

/obj/machinery/portable_atmospherics/gas_collector/proc/update_gases_ui()
	gas_inventory = list()

	for(var/gasid in air_contents.gas)
		gas_inventory.Add(list(list("gasid" = gasid, "moles" = air_contents.gas[gasid], "venting" = gases_to_expel.Find(gasid))))

	for(var/gasid in gases_to_expel)
		gas_inventory.Add(list(list("gasid" = gasid, "moles" = 0, "venting" = 1)))
