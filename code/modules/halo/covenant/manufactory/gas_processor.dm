
/obj/machinery/portable_atmospherics/gas_processor
	name = "Gas processor"
	desc = "A machine for processing various gases into sealed packets for industrial applications."
	icon = 'code/modules/halo/covenant/manufactory/machines.dmi'
	icon_state = "dispenser"
	anchored = 1
	density = 1
	volume = 1000
	layer = OBJ_LAYER + 0.1
	var/max_pressure = TANK_LEAK_PRESSURE * 0.9
	var/list/gas_inventory = list()
	var/held_steel = 0
	var/steel_per_packet = 10
	var/moles_per_packet = 150
	var/static/list/packet_types = list(\
		"oxygen" = /obj/item/gas_packet/oxygen,\
		"watervapour" = /obj/item/gas_packet/water,\
		"argon" = /obj/item/gas_packet/noble,\
		"krypton" = /obj/item/gas_packet/noble,\
		"xenon" = /obj/item/gas_packet/noble,\
		"neon" = /obj/item/gas_packet/noble,\
		"carbonmonoxide" = /obj/item/gas_packet/carbonmonoxide,\
		"chlorine" = /obj/item/gas_packet/chlorine,\
		"sulfurdioxide" = /obj/item/gas_packet/sulfurdioxide,\
		"helium" = /obj/item/gas_packet/helium,\
		"methane" = /obj/item/gas_packet/methane,\
		"hydrogen" = /obj/item/gas_packet/hydrogen,\
		"carbondioxide" = /obj/item/gas_packet/carbondioxide,\
		"nitrogen" = /obj/item/gas_packet/nitrogen\
	)

/obj/machinery/portable_atmospherics/gas_processor/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/tank))
		if(holding)
			to_chat(user, "<span class='notice'>[src] is already holding [holding].</span>")
		else
			to_chat(user, "<span class='info'>You insert [I] into [src].</span>")
			user.drop_item()
			var/obj/item/weapon/tank/T = I
			T.loc = src
			holding = T
			overlays += "dispenser_tank"

	if(istype(I, /obj/item/stack/material/steel))
		var/obj/item/stack/material/steel/S = I
		user.drop_item()
		held_steel += S.amount
		to_chat(user, "<span class='info'>You insert [I] into [src]. It now holds [held_steel] steel sheets.</span>")
		qdel(I)

/obj/machinery/portable_atmospherics/gas_processor/proc/drain_holding()
	if(holding)
		air_contents.merge(holding.air_contents)
		qdel(holding.air_contents)
		holding.air_contents = new (holding.volume)
		return 1

	return 0

/obj/machinery/portable_atmospherics/gas_processor/proc/fill_holding(var/gasid)
	if(holding)
		//we only want to move over as much as the tank can fit before leaking

		//test the pressure of moving over all moles
		var/gas_moles = air_contents.gas[gasid]
		var/datum/gas_mixture/new_gas = new(holding.volume)
		new_gas.adjust_gas(gasid, gas_moles)
		new_gas.temperature = air_contents.temperature

		//if its too much, remove some of our fake moles
		var/excess_pressure = new_gas.return_pressure() - max_pressure
		if(excess_pressure > 0)
			var/excess_ratio = excess_pressure / max_pressure
			qdel(new_gas.remove_ratio(excess_ratio))

		//move over the calculated amount
		holding.air_contents.merge(new_gas)

		//subtract the amount from our internal storage
		air_contents.adjust_gas(gasid, -new_gas.total_moles)

		//clean up
		qdel(new_gas)

		return 1

	return 0

/obj/machinery/portable_atmospherics/gas_processor/proc/expel_gas(var/gasid, var/mob/user)
	ASSERT(user)
	. = 0

	var/amount = 0
	switch(alert(user, "How much gas should be expelled", "Expel gas", "All", "Half", "None"))
		if("All")
			amount = air_contents.gas[gasid]
		if("Half")
			amount = air_contents.gas[gasid] / 2

	if(amount)
		//remove the moles
		air_contents.adjust_gas(gasid, -amount)

		//smoke effect
		new /obj/effect/effect/smoke/chem(src.loc, 30)

		//overlay on the sprite
		overlays += "expel"
		spawn(30)
			overlays -= "expel"

		return 1

/obj/machinery/portable_atmospherics/gas_processor/proc/make_gas_packet(var/gasid, var/mob/user)
	. = 0
	if(held_steel >= steel_per_packet)
		if(air_contents.gas[gasid] >= moles_per_packet)
			var/packet_type = packet_types[gasid]
			if(!packet_type)
				packet_type = /obj/item/gas_packet
			new packet_type(src.loc, gasid)
			air_contents.adjust_gas(gasid, -moles_per_packet)
			to_chat(user,"<span class='info'>[src] compresses [gasid] into a sealed packet.</span>")
			. = 1
		else
			to_chat(user,"<span class='warning'>Insufficient [gasid], requires [moles_per_packet] moles per packet.</span>")
	else
		to_chat(user,"<span class='warning'>Insufficient steel, requires [steel_per_packet] sheets per packet.</span>")

/obj/machinery/portable_atmospherics/gas_processor/proc/update_gases_ui()
	gas_inventory = list()

	for(var/gasid in air_contents.gas)
		gas_inventory.Add(list(list("gasid" = gasid, "moles" = air_contents.gas[gasid])))
