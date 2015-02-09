#define ALARM_ORIGIN_LOST "Origin Lost"

/datum/alarm_handler
	var/category = ""
	var/list/datum/alarm/alarms = new			// All alarms, to handle cases when origin has been deleted with one or more active alarms
	var/list/datum/alarm/alarms_assoc = new		// Associative list of alarms, to efficiently acquire them based on origin.

/datum/alarm_handler/proc/process()
	/*
	for(var/datum/alarm/A in alarms)
		var/datum/alarm_source/AS = A.source
		// Alarm owner has been deleted. Clean up in at most 15 seconds
		if(!AS.owner && !AS.end_time)
			AS.end_time = world.time + SecondsToTicks(15)
		if(AS.duration || AS.end_time)
			if(world.time > (AS.start_time + AS.duration) || world.time > AS.end_time)
				//Somethingthing..
	*/

/datum/alarm_handler/proc/triggerAlarm(var/atom/origin, var/atom/source, var/duration = 0)
	//Proper origin and source mandatory
	if(!origin || !source)
		return

	//see if there is already an alarm of this origin
	var/alarm_key = origin.get_alarm_key()
	var/datum/alarm/existing = alarms_assoc[alarm_key]
	if(existing)
		existing.set_duration(source, duration)
	else
		existing = new/datum/alarm(origin, source, duration)

	alarms |= existing
	alarms_assoc[alarm_key] = existing

/datum/alarm_handler/proc/cancelAlarm(var/atom/origin, var/source)
	//Proper origin and source mandatory
	if(!origin || !source)
		return

	var/alarm_key = origin.get_alarm_key()

	var/datum/alarm/existing = alarms_assoc[alarm_key]
	if(existing)
		existing.clear(source)
		if (!existing.sources.len)
			alarms -= existing
			alarms_assoc -= alarm_key

/atom/proc/get_alarm_key()
	return src

/turf/get_alarm_key()
	return get_area(src)

/obj/item/device/alarm_debug
	name = "An alarm debug tool - Self"
	desc = "Alarm Up. Alarm Reset."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"

/obj/item/device/alarm_debug/loc
	name = "An alarm debug tool - Loc"

/obj/item/device/alarm_debug/verb/alarm()
	set name = "Alarm"
	set category = "Debug"
	usr << "Raising alarm"
	camera_alarm.triggerAlarm(src, src)

/obj/item/device/alarm_debug/verb/reset()
	set name = "Reset"
	set category = "Debug"
	usr << "Raising alarm"
	camera_alarm.triggerAlarm(src, src)

/obj/item/device/alarm_debug/verb/tell_me()
	set name = "Tell"
	set category = "Debug"
	usr << "Telling about alarms"

	var/list/datum/alarm/alarms = camera_alarm.alarms
	var/list/datum/alarm/alarms_assoc = camera_alarm.alarms_assoc

	world << "List"
	for(var/datum/alarm/A in alarms)
		world << "Origin: [A.origin ? A.origin : ALARM_ORIGIN_LOST]"
		world << "Alarm area: [A.alarm_area()]"
		for(var/source in A.sources)
			world << "Source: [source]"

	world << "Assoc"

	for(var/atom/origin in alarms_assoc)
		world << "Origin: [origin ? origin : ALARM_ORIGIN_LOST]"
		var/datum/alarm/A = alarms_assoc[origin]
		world << "Alarm area: [A.alarm_area()]"
		for(var/source in A.sources)
			world << "Source: [source]"

/obj/item/device/alarm_debug/loc/alarm()
	set name = "Alarm"
	set category = "Debug"
	usr << "Raising alarm"
	camera_alarm.triggerAlarm(src.loc, src)

/obj/item/device/alarm_debug/loc/reset()
	set name = "Reset"
	set category = "Debug"
	usr << "Clearing alarm"
	camera_alarm.cancelAlarm(src.loc, src)
