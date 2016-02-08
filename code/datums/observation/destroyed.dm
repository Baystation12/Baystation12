var/datum/observ/destroyed/destroyed_event = new()

/datum/observ/destroyed
	name = "Destroyed"

/datum/Destroy()
	destroyed_event.raise_event(list(src))
	. = ..()
