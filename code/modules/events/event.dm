/datum/event	//NOTE: Times are measured in master controller ticks!
	var/startWhen		= 0	//When in the lifetime to call start().
	var/announceWhen	= 0	//When in the lifetime to call announce().
	var/endWhen			= 0	//When in the lifetime the event should end.
	var/oneShot			= 0	//If true, then the event removes itself from the list of potential events on creation.

	var/activeFor		= 0	//How long the event has existed. You don't need to change this.

//Called first before processing.
//Allows you to setup your event, such as randomly
//setting the startWhen and or announceWhen variables.
//Only called once.
/datum/event/proc/setup()
	return

//Called when the tick is equal to the startWhen variable.
//Allows you to start before announcing or vice versa.
//Only called once.
/datum/event/proc/start()
	return

//Called when the tick is equal to the announceWhen variable.
//Allows you to announce before starting or vice versa.
//Only called once.
/datum/event/proc/announce()
	return

//Called on or after the tick counter is equal to startWhen.
//You can include code related to your event or add your own
//time stamped events.
//Called more than once.
/datum/event/proc/tick()
	return

//Called on or after the tick is equal or more than endWhen
//You can include code related to the event ending.
//Do not place spawn() in here, instead use tick() to check for
//the activeFor variable.
//For example: if(activeFor == myOwnVariable + 30) doStuff()
//Only called once.
/datum/event/proc/end()
	return



//Do not override this proc, instead use the appropiate procs.
//This proc will handle the calls to the appropiate procs.
/datum/event/proc/process()

	if(activeFor > startWhen && activeFor < endWhen)
		tick()

	if(activeFor == startWhen)
		start()

	if(activeFor == announceWhen)
		announce()

	if(activeFor == endWhen)
		end()

	// Everything is done, let's clean up.
	if(activeFor >= endWhen && activeFor >= announceWhen && activeFor >= startWhen)
		kill()

	activeFor++


//Garbage collects the event by removing it from the global events list,
//which should be the only place it's referenced.
//Called when start(), announce() and end() has all been called.
/datum/event/proc/kill()
	events.Remove(src)


//Adds the event to the global events list, and removes it from the list
//of potential events.
/datum/event/New()
	setup()
	events.Add(src)
	/*if(oneShot)
		potentialRandomEvents.Remove(type)*/
	..()

/datum/event/proc/findEventArea() //Here's a nice proc to use to find an area for your event to land in!
	var/list/safe_areas = list(
	/area/turret_protected/ai,
	/area/turret_protected/ai_upload,
	/area/engine,
	/area/solar,
	/area/holodeck,
	/area/shuttle/arrival,
	/area/shuttle/escape/station,
	/area/shuttle/escape_pod1/station,
	/area/shuttle/escape_pod2/station,
	/area/shuttle/escape_pod3/station,
	/area/shuttle/escape_pod5/station,
	/area/shuttle/mining/station,
	/area/shuttle/transport1/station,
	/area/shuttle/specops/station)

	//These are needed because /area/engine has to be removed from the list, but we still want these areas to get fucked up.
	var/list/danger_areas = list(
	/area/engine/break_room,
	/area/engine/chiefs_office)

	//Need to locate() as it's just a list of paths.
	return locate(pick((the_station_areas - safe_areas) + danger_areas))