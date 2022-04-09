//Engine component object

var/list/ship_engines = list()
/datum/ship_engine
	var/name = "ship engine"
	var/obj/machinery/holder	//actual engine object

/datum/ship_engine/New(var/obj/machinery/_holder)
	..()
	holder = _holder
	ship_engines += src

/datum/ship_engine/proc/can_burn()
	return 0

//Tries to fire the engine. Returns thrust
/datum/ship_engine/proc/burn()
	return 0

//Returns status string for this engine
/datum/ship_engine/proc/get_status()
	return "All systems nominal"

/datum/ship_engine/proc/get_thrust()
	return 1

//Sets thrust limiter, a number between 0 and 1
/datum/ship_engine/proc/set_thrust_limit(var/new_limit)
	return 1

/datum/ship_engine/proc/get_thrust_limit()
	return 1

/datum/ship_engine/proc/is_on()
	return 1

/datum/ship_engine/proc/toggle()
	return 1

/datum/ship_engine/Destroy()
	ship_engines -= src
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.ships)
		S.engines -= src
	holder = null
	. = ..()