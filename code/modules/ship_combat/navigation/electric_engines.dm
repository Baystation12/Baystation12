/datum/ship_engine/electric
	name = "electric engine"

/datum/ship_engine/electric/get_status()
	..()
	var/obj/machinery/space_battle/engine/electric/E = engine
	var/avail = E.get_power()
	return "Electrical Current: [avail]w"

/datum/ship_engine/electric/get_thrust()
	..()
	var/obj/machinery/space_battle/engine/electric/E = engine
	if(!is_on())
		return 0
	return round(E.thrust_limit * E.nominal_thrust * E.component_efficiency())

/datum/ship_engine/electric/burn()
	..()
	var/obj/machinery/space_battle/engine/electric/E = engine
	return E.burn()

/datum/ship_engine/electric/set_thrust_limit(var/new_limit)
	..()
	var/obj/machinery/space_battle/engine/electric/E = engine
	E.thrust_limit = new_limit

/datum/ship_engine/electric/get_thrust_limit()
	..()
	var/obj/machinery/space_battle/engine/electric/E = engine
	return E.thrust_limit

/datum/ship_engine/electric/is_on()
	..()
	var/obj/machinery/space_battle/engine/electric/E = engine
	return E.on

/datum/ship_engine/electric/toggle()
	..()
	var/obj/machinery/space_battle/engine/electric/E = engine
	E.on = !E.on

//Engine
/obj/machinery/space_battle/engine/electric
	name = "electric engine"
	component_type = /obj/item/weapon/component/engine/ion
	var/datum/ship_engine/electric/controller

/obj/machinery/space_battle/engine/electric/initialize()
	..()
	controller = new(src, engine_id)

/obj/machinery/space_battle/engine/electric/Destroy()
	..()
	controller.die()

/obj/machinery/space_battle/engine/electric/proc/get_power()
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	return C && C.powernet ? C.powernet.avail : 0

/obj/machinery/space_battle/engine/electric/proc/component_efficiency()
	var/obj/item/weapon/component/engine/ion/C = component
	return C.mod

/obj/machinery/space_battle/engine/electric/proc/burn()
	if(stat & (BROKEN|NOPOWER|EMPED|MAINT) || !controller.cooldown())
		on = 0
	if (!on)
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)	PN = C.powernet		// find the powernet of the connected cable
	if(!PN)
		on = 0
		return 0
	var/efficiency = get_efficiency(-1,1)
	var/load = 5000*efficiency*thrust_limit
	var/charged = PN.draw_power(load) //what we actually get
	if(!charged)
		on = 0
		return 0
	if(charged < load)
		var/percent = round(load / charged, 0.1)
		thrust_limit = min(thrust_limit, percent)
	return 1