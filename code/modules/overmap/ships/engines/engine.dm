//Engine component object

var/list/ship_engines = list()
/datum/ship_engine
	var/name = "ship engine"
	var/obj/machinery/space_battle/engine	//actual engine object
	var/zlevel = 0
	var/obj/machinery/space_battle/computer/engine_control/controller
	var/id_tag

/datum/ship_engine/New(var/obj/machinery/space_battle/engine/holder)
	..()
	id_tag = holder.id_tag
	engine = holder
	zlevel = holder.z
	ship_engines += src
	for(var/obj/machinery/space_battle/computer/engine_control/E in machines)
		if (zlevel in E.zlevels && E.id_tag == src.id_tag && !(src in E.engines))
			controller = E
			E.engines |= src
			break

//Tries to fire the engine. If successfull, returns 1
/datum/ship_engine/proc/burn()
	if(!engine)
		die()
	return 1

//Returns status string for this engine
/datum/ship_engine/proc/get_status()
	if(!engine)
		die()
	return "All systems nominal"

/datum/ship_engine/proc/get_thrust()
	if(!engine)
		die()
	return 100

//Sets thrust limiter, a number between 0 and 1
/datum/ship_engine/proc/set_thrust_limit(var/new_limit)
	if(!engine)
		die()
	return 1

/datum/ship_engine/proc/get_thrust_limit()
	if(!engine)
		die()
	return 1

/datum/ship_engine/proc/is_on()
	if(!engine)
		die()
	return 1

/datum/ship_engine/proc/toggle()
	if(!engine)
		die()
	return 1

/datum/ship_engine/proc/die()
	ship_engines -= src
	for(var/obj/machinery/space_battle/computer/engine_control/E in machines)
		if (E.z == zlevel && E.id_tag == src.id_tag)
			E.engines -= src
			break
	qdel(src)

/datum/ship_engine/proc/cooldown()
	return controller ? controller.cooldown() : 0