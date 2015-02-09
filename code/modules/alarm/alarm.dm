/datum/alarm_source
	var/source		= null	// The source trigger
	var/source_name = ""	// The name of the source should it be lost (for example a destroyed camera)
	var/duration	= 0		// How long this source will be alarming, 0 for indefinetely.
	var/start_time	= 0		// When this source began alarming.
	var/end_time	= 0		// Use to set when this trigger should clear, in case the source is lost.

/datum/alarm_source/New(var/atom/source)
	src.source = source
	source_name = source.name
	start_time = world.time

/datum/alarm
	var/atom/origin					//Used to identify the alarm area.
	var/list/sources = new()		//List of sources triggering the alarm. Used to determine when the alarm should be cleared.
	var/list/sources_assoc = new()	//Associative list of source triggers. Used to efficiently acquire the alarm source.
	var/list/cameras				//List of cameras that can be switched to, if the player has that capability.
	var/area/last_area				//The last acquired area, used should origin be lost (for example a destroyed borg containing an alarming camera).

/datum/alarm/New(var/atom/origin, var/atom/source, var/duration)
	src.origin = origin
	last_area = alarm_area()
	set_duration(source, duration)

/datum/alarm/proc/set_duration(var/atom/source, var/duration)
	var/datum/alarm_source/AS = sources[source]
	if(!AS)
		AS = new/datum/alarm_source(source)
		sources += AS
		sources_assoc[source] = AS
	// Currently only non-0 durations can be altered (normal alarms VS EMP blasts)
	if(AS.duration)
		AS.duration = duration

/datum/alarm/proc/clear(var/source)
	var/datum/alarm_source/AS = sources[source]
	sources -= AS
	sources_assoc -= source

/datum/alarm/proc/alarm_area()
	if(!origin)
		return last_area

	last_area = origin.get_alarm_area()
	return last_area

/datum/alarm/proc/cameras()
	if(!origin)
		return list()

	if(!cameras)
		cameras = origin.get_alarm_cameras()

	return cameras


/atom/proc/get_alarm_area()
	return get_area(src)

/area/get_alarm_area()
	return src

/atom/proc/get_alarm_cameras()
	var/area/A = get_area(src)
	return A.get_cameras()

/area/get_alarm_cameras()
	return get_cameras()

/mob/living/silicon/robot/get_alarm_cameras()
	var/list/cameras = ..()
	if(camera)
		cameras += camera

	return cameras

/mob/living/silicon/robot/syndicate/get_alarm_cameras()
	return list()
