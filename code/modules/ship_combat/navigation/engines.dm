//Engine component object

var/list/ship_engines = list()
/datum/ship_engine
	var/name = "ship engine"
	var/obj/machinery/engine	//actual engine object
	var/zlevel = 0
	var/engine_id = null
	var/obj/machinery/space_battle/engine_control/controller

/datum/ship_engine/New(var/obj/machinery/holder, var/id)
	engine = holder
	zlevel = holder.z
	engine_id = id
	for(var/obj/machinery/space_battle/engine_control/E in machines)
		if (zlevel in E.zlevels && E.engine_id == src.engine_id && !(src in E.engines))
			E.engines += src
			controller = E
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
	for(var/obj/machinery/space_battle/engine_control/E in machines)
		if (E.z == zlevel && src in E.engines)
			E.engines -= src
	qdel(src)

/datum/ship_engine/proc/cooldown()
	return controller ? controller.cooldown() : 0