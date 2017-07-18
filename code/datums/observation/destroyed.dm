//	Observer Pattern Implementation: Destroyed
//		Registration type: /datum
//
//		Raised when: A /datum instance is destroyed.
//
//		Arguments that the called proc should expect:
//			/datum/destroyed_instance: The instance that was destroyed.
var/decl/observ/destroyed/destroyed_event = new()

/decl/observ/destroyed
	name = "Destroyed"

/datum/Destroy()
	destroyed_event.raise_event(src)
	. = ..()
	cleanup_events(src)
