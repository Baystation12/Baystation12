
//Reactor machine

/obj/machinery/power/fusion_drive
	name = "Mark II Hanley-Messer Fusion Drive"
	desc = "A soon to be obselete fusion reactor for powering starships."
	icon = 'fusion_drive.dmi'
	icon_state = "reactor0"

	density = 1
	anchored = 1

	var/obj/item/fusion_fuel/held_fuel

	var/fuel_consumption_rate = 1
	var/power_per_fuel = 200000			//how much power per tick
	var/heat_per_fuel = 2000	//2 degrees C at 1000 heat capacity

	var/heat_energy = T20C * 1000	//20 degrees C at 1000 heat capacity
	var/max_heat_energy = 1273000	//1.2 million or 1000 degrees C at 1000 heat capacity
	var/internal_heat_capacity = 1000
	var/cooled_last_cycle = 0
	var/ambient_cooling = 1000		//1 degree C at 1000 heat capacity

	var/icon/heat_overlay
	var/icon/fuel_overlay

/obj/machinery/power/fusion_drive/New()
	..()
	heat_energy = T20C * internal_heat_capacity

/obj/machinery/power/fusion_drive/Initialize()
	update_overlays()
	connect_to_network()

	//connect any exhaust manifolds within range
	/*for(var/obj/machinery/atmospherics/binary/fusion_cooling/M in range(1))
		M.target_reactor = locate() in get_step(M, turn(M.dir, -90))*/

/obj/machinery/power/fusion_drive/proc/update_overlays()
	if(heat_overlay)
		overlays -= heat_overlay
	var/heatval = min(round(6 * heat_energy / max_heat_energy), 6)
	heat_overlay = new('fusion_drive.dmi', "heat[heatval]")
	overlays += heat_overlay

	if(fuel_overlay)
		overlays -= fuel_overlay
	var/fuelval = 0
	if(held_fuel)
		fuelval = min(round(8 * held_fuel.fuel_left / held_fuel.max_fuel), 8)
	fuel_overlay = new('fusion_drive.dmi', "fuel[fuelval]")
	overlays += fuel_overlay

/obj/machinery/power/fusion_drive/process()
	//if coolant isn't working properly, lose a little bit of heat naturally
	if(cooled_last_cycle < ambient_cooling)
		heat_energy -= (ambient_cooling - cooled_last_cycle)
		heat_energy = max(heat_energy, 0)
		cooled_last_cycle = ambient_cooling

	//process power production
	if(held_fuel && held_fuel.fuel_left > 0)
		held_fuel.fuel_left -= fuel_consumption_rate
		held_fuel.fuel_left = max(held_fuel.fuel_left, 0)

		add_avail(fuel_consumption_rate * power_per_fuel)
		heat_energy += fuel_consumption_rate * heat_per_fuel

		update_overlays()

		//blow up if cooling isn't good enough
		if(heat_energy > max_heat_energy)
			overload_reactor()

/obj/machinery/power/fusion_drive/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/fusion_fuel))
		if(held_fuel)
			to_chat(user,"<span class='warning'>There is already a fuel packet in there.</span>")
		else
			user.drop_item()
			I.loc = src
			held_fuel = I
			icon_state = "reactor1"
			update_overlays()

/obj/machinery/power/fusion_drive/proc/can_use(var/mob/M)
	if(M.stat || M.restrained() || M.lying || !istype(M, /mob/living) || get_dist(M, src) > 1)
		return 0
	return 1

/obj/machinery/power/fusion_drive/attack_hand(var/mob/living/user)
	add_fingerprint(user)
	if(can_use(user))
		user.set_machine(src)
		ui_interact(user)

/obj/machinery/power/fusion_drive/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!can_use(user))
		if(ui)
			ui.close()
		return

	var/data[0]
	data["powerprod"] = fuel_consumption_rate * power_per_fuel
	data["coretemp"] = heat_energy / internal_heat_capacity
	data["coreoverload"] = 100 * heat_energy / max_heat_energy
	data["held_fuel"] = held_fuel ? 1 : 0
	data["fuelunits"] = held_fuel ? held_fuel.fuel_left : 0
	data["fuelremain"] = held_fuel ? 100 * held_fuel.fuel_left / held_fuel.max_fuel : 0

	data["fuel_rate"] = fuel_consumption_rate
	data["fuel_rate_max"] = round(max_heat_energy / (60 * heat_per_fuel))

	/*
	var/text = "<b>Mark II Hanley-Messer Deuterium Fusion Drive</b><br>"
	text += "<br>"
	text += "Power production: [fuel_consumption_rate * power_per_fuel] W"
	text += "<br>"
	text += "Core temperature: [heat_energy / internal_heat_capacity] K ([100 * heat_energy / max_heat_energy]%)<BR>"
	text += "Warning! Do not let core exceed 1000 degrees or a potentially catastrophic meltdown will occur.<BR>"
	text += "<br>"
	if(held_fuel)
		text += "Fuel remaining: [held_fuel.fuel_left] units ([round(100 * held_fuel.fuel_left / held_fuel.max_fuel)]%) <a href='?src=\ref[src];eject_fuel=1'>\[Eject\]<br></a>"
	else
		text += "No fuel packet inserted.<br>"
	text += "Fuel consumption rate: [fuel_consumption_rate] units/sec <a href='?src=\ref[src];modify_fuel_use=1'>\[Modify\]</a><br>"
	text += "Warning! Recommended not to exceed [round(max_heat_energy / (60 * heat_per_fuel))] due to excessive heat production.<br>"

	to_chat(user,browse(text, "window=fusion_drive;size=450x300;can_resize=1;can_close=1;can_minimize=1"))
	onclose(user, "window=fusion_drive", src)
	*/

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fusion_reactor.tmpl", "Fusion Reactor", 550, 550)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/fusion_drive/Topic(href, href_list)
	if(href_list["modify_fuel_use"])
		fuel_consumption_rate = input("Choose a new fuel consumption rate per second", "Fuel usage", 0.5)
		fuel_consumption_rate = min(fuel_consumption_rate, round(max_heat_energy / (10 * heat_per_fuel)))

	if(href_list["eject_fuel"])
		eject_fuel()

/obj/machinery/power/fusion_drive/proc/eject_fuel()
	if(held_fuel)
		visible_message("\icon[src] [src] ejects it's fuel packet.")
		held_fuel.loc = src.loc
		held_fuel = null
		icon_state = "reactor0"
		update_overlays()

/obj/machinery/power/fusion_drive/ex_act(severity)
	switch(severity)
		if(1)
			if(prob(50))
				overload_reactor()
			else if(prob(50))
				disconnect_from_network()

				var/obj/item/stack/material/glass/reinforced/G = new(src.loc)
				G.amount = 5
				var/obj/item/stack/material/plasteel/S = new(src.loc)
				S.amount = 5
				qdel(src)
		if(2)
			if(prob(75))
				overload_reactor()
			else
				disconnect_from_network()

				var/obj/item/stack/material/glass/reinforced/G = new(src.loc)
				G.amount = 5
				var/obj/item/stack/material/plasteel/S = new(src.loc)
				S.amount = 5
				qdel(src)
		if(3)
			overload_reactor()

/obj/machinery/power/fusion_drive/proc/overload_reactor()
	var/max_damage = 6// * heat_energy / max_heat_energy
	if(held_fuel)
		max_damage += pick(1,2)// * held_fuel.fuel_left / held_fuel.max_fuel

	log_admin("A fusion reactor overloaded at [src.x], [src.y], [src.z] with max damage [max_damage]")

	disconnect_from_network()
	spawn(0)
		explosion(get_turf(src), max_damage - 6, max_damage - 3, max_damage - 1, max_damage + 1)
