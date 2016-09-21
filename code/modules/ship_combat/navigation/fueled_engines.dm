/datum/ship_engine/fueled
	name = "fueled engine"

/datum/ship_engine/fueled/get_status()
	..()
	var/obj/machinery/space_battle/engine/fuelled/E = engine
	var/fuel = E.get_fuel()
	return "Fuel pressure: [fuel]ml"

/datum/ship_engine/fueled/get_thrust()
	..()
	var/obj/machinery/space_battle/engine/fuelled/E = engine
	if(!is_on())
		return 0
	return round(E.thrust_limit * E.nominal_thrust * E.component_efficiency())

/datum/ship_engine/fueled/burn()
	..()
	var/obj/machinery/space_battle/engine/fuelled/E = engine
	return E.burn()

/datum/ship_engine/fueled/set_thrust_limit(var/new_limit)
	..()
	var/obj/machinery/space_battle/engine/fuelled/E = engine
	E.thrust_limit = new_limit

/datum/ship_engine/fueled/get_thrust_limit()
	..()
	var/obj/machinery/space_battle/engine/fuelled/E = engine
	return E.thrust_limit

/datum/ship_engine/fueled/is_on()
	..()
	var/obj/machinery/space_battle/engine/fuelled/E = engine
	return E.on

/datum/ship_engine/fueled/toggle()
	..()
	var/obj/machinery/space_battle/engine/fuelled/E = engine
	E.on = !E.on

/datum/reagent/fuel/rocket
	name = "Rocket fuel"
	id = "rocketfuel"
	description = "A mixture of oxygen and liquid fuel."
	taste_description = "gross metal"
	reagent_state = LIQUID
	color = "#660000"
	touch_met = 5

	glass_name = "rocket fuel"
	glass_desc = "Often used to propel space rockets."

/obj/structure/reagent_dispensers/fueltank/rocketfuel
	name = "rocket fuel tank"
	desc = "Used to power rockets."

	New()
		..()
		reagents.clear_reagents()
		spawn(0)
			reagents.add_reagent("rocketfuel",2500)

/obj/structure/reagent_dispensers/fueltank/rocketfuel/ex_act(var/severity = 0)
	if(prob(60/severity))
		..()
	return 0
//	examine(var/mob/user)
//		..()
//		user << "<span class='notice'>Upon inspection, you notice it has [reagents.get_reagent_amount("rocketfuel")]ml remaining!</span>"

/obj/machinery/fuel_port
	name = "fuel port"
	desc = "A fuel port. Put a fuel container on here."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "fuelport"
	var/id = null
	layer = 2.9

/obj/machinery/fuel_port/proc/get_fuel()
	var/obj/structure/reagent_dispensers/fueltank/rocketfuel/tank = locate() in get_turf(src)
	if(tank && istype(tank))
		return tank.reagents.get_reagent_amount("rocketfuel")

/obj/machinery/fuel_port/proc/use_fuel(var/amount = 0)
	if(!amount) return 0
	var/obj/structure/reagent_dispensers/fueltank/rocketfuel/tank = locate() in get_turf(src)
	if(tank && istype(tank))
		return tank.reagents.remove_reagent("rocketfuel", amount)

/obj/machinery/space_battle/engine
	name = "engine nozzle"
	desc = "An engine nozzle, used to propel things through space."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	var/on = 0
	var/thrust_limit = 1
	var/nominal_thrust = 3000
	component_type = /obj/item/weapon/component/engine
	idle_power_usage = 50

/obj/machinery/space_battle/engine/fuelled/attack_hand(var/mob/user)
	if(controller)
		controller.toggle()
	user << "<span class='notice'>\The [src] is now [on ? "on" : "off"]!</span>"

/obj/machinery/space_battle/engine/fuelled/initialize()
	..()
	controller = new(src, id_tag)

/obj/machinery/space_battle/engine/fuelled/Destroy()
	..()
	controller.die()

/obj/machinery/space_battle/engine/fuelled
	var/list/fuel_ports = list()
	var/datum/ship_engine/fueled/controller

/obj/machinery/space_battle/engine/fuelled/initialize()
	..()
	for(var/obj/machinery/fuel_port/F in world)
		if(id_tag && F.id == src.id_tag && F.z == src.z)
			fuel_ports.Add(F)

/obj/machinery/space_battle/engine/fuelled/proc/get_fuel()
	var/amount = 0
	for(var/obj/machinery/fuel_port/F in fuel_ports)
		amount += F.get_fuel()
	return amount

/obj/machinery/space_battle/engine/fuelled/proc/component_efficiency()
	var/obj/item/weapon/component/engine/fuel/C = component
	return C.mod

/obj/machinery/space_battle/engine/fuelled/proc/burn()
	if(stat & (BROKEN|NOPOWER|EMPED|MAINT) || !controller.cooldown())
		on = 0
	if (!on)
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)	PN = C.powernet		// find the powernet of the connected cable
	if(!PN) return 0
	var/efficiency = get_efficiency(-1,1)

	var/load = 1000*efficiency*thrust_limit
	if(prob(1 * get_efficiency(0,1)))
		src.visible_message("<span class='warning'>\The [src] stutters violently!</span>")
		if(prob(80))
			load *= 2
		else
			circuit_board.emp_act(3)
	var/charged = PN.draw_power(load) //what we actually get
	if(!charged) return 0
	if(charged < load)
		var/percent = round(load / charged, 0.1)
		thrust_limit = min(thrust_limit, percent)
	var/used_fuel = round(3 * efficiency, 0.5)
	var/fueled = 0
	for(var/obj/machinery/fuel_port/port in fuel_ports)
		if(port.use_fuel(used_fuel))
			fueled = 1
			break
	if(!fueled)
		on = 0
		return 0
	var/exhaust_dir = reverse_direction(dir)
	var/turf/E = get_step(src,exhaust_dir)
	if(E)
		new/obj/effect/engine_exhaust(E,exhaust_dir,1000)
	return 1

/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "exhaust"
	anchored = 1

	New(var/turf/nloc, var/ndir, var/temp)
		set_dir(ndir)
		..(nloc)

		if(nloc)
			nloc.hotspot_expose(temp,125)

		spawn(20)
			loc = null
