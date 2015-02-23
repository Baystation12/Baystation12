#define ALARM_RAISED 1
#define ALARM_CLEARED 0

/datum/alarm_handler
	var/category = ""
	var/list/datum/alarm/alarms = new		// All alarms, to handle cases when an origin has been deleted with one or more active alarms
	var/list/datum/alarm/alarms_assoc = new	// Associative list of alarms, to efficiently acquire them based on origin.
	var/list/listeners = new				// A list of all objects interested in alarm changes.

/datum/alarm_handler/proc/process()
	for(var/datum/alarm/A in alarms)
		A.process()
		check_alarm_cleared(A)

/datum/alarm_handler/proc/triggerAlarm(var/atom/origin, var/atom/source, var/duration = 0)
	var/new_alarm
	//Proper origin and source mandatory
	if(!(origin && source))
		return
	origin = origin.get_alarm_origin()

	new_alarm = 0
	//see if there is already an alarm of this origin
	var/datum/alarm/existing = alarms_assoc[origin]
	if(existing)
		existing.set_duration(source, duration)
	else
		existing = new/datum/alarm(origin, source, duration)
		new_alarm = 1

	alarms |= existing
	alarms_assoc[origin] = existing
	if(new_alarm)
		alarms = dd_sortedObjectList(alarms)
		notify_listeners(existing, ALARM_RAISED)

	return new_alarm

/datum/alarm_handler/proc/clearAlarm(var/atom/origin, var/source)
	//Proper origin and source mandatory
	if(!(origin && source))
		return
	origin = origin.get_alarm_origin()

	var/datum/alarm/existing = alarms_assoc[origin]
	if(existing)
		existing.clear(source)
		return check_alarm_cleared(existing)

/datum/alarm_handler/proc/check_alarm_cleared(var/datum/alarm/alarm)
	if ((alarm.end_time && world.time > alarm.end_time) || !alarm.sources.len)
		alarms -= alarm
		alarms_assoc -= alarm.origin
		notify_listeners(alarm, ALARM_CLEARED)
		return 1
	return 0

/atom/proc/get_alarm_origin()
	return src

/turf/get_alarm_origin()
	var/area/area = get_area(src)
	return area.master	// Very important to get area.master, as dynamic lightning can and will split areas.

/datum/alarm_handler/proc/register(var/object, var/procName)
	listeners[object] = procName

/datum/alarm_handler/proc/unregister(var/object)
	listeners -= object

/datum/alarm_handler/proc/notify_listeners(var/alarm, var/was_raised)
	for(var/listener in listeners)
		call(listener, listeners[listener])(src, alarm, was_raised)

/********
* DEBUG *
********/
/obj/item/device/alarm_debug
	name = "An alarm debug tool - Self"
	desc = "Alarm Up. Alarm Reset."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"
	var/obj/nano_module/alarm_monitor/ai/alarm_monitor

/obj/item/device/alarm_debug/New()
	..()
	alarm_monitor = new(src)

/obj/item/device/alarm_debug/loc
	name = "An alarm debug tool - Loc"

/obj/item/device/alarm_debug/verb/alarm()
	set name = "Alarm"
	set category = "Debug"
	usr << "Raising alarm"
	fire_alarm.triggerAlarm(src, src)

/obj/item/device/alarm_debug/verb/reset()
	set name = "Reset"
	set category = "Debug"
	usr << "Clearing alarm"
	fire_alarm.clearAlarm(src, src)

/obj/item/device/alarm_debug/loc/alarm()
	set name = "Alarm"
	set category = "Debug"
	usr << "Raising alarm"
	fire_alarm.triggerAlarm(src.loc, src)

/obj/item/device/alarm_debug/loc/reset()
	set name = "Reset"
	set category = "Debug"
	usr << "Clearing alarm"
	fire_alarm.clearAlarm(src.loc, src)

/obj/item/device/alarm_debug/verb/nano()
	set name = "Nano"
	set category = "Debug"
	alarm_monitor.ui_interact(usr)

/obj/item/device/alarm_debug/attack_self(var/mob/user)
	alarm_monitor.ui_interact(user)

#undef ALARM_RAISED
#undef ALARM_CLEARED
