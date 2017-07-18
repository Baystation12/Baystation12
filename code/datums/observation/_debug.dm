/****************
* Debug Support *
****************/
var/datum/all_observable_events/all_observable_events = new()

/datum/all_observable_events
	var/list/events

/datum/all_observable_events/New()
	events = list()
	..()
