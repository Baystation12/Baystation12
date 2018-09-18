//	Observer Pattern Implementation: Shuttle Moved
//		Registration type: /datum/shuttle/autodock
//
//		Raised when: A shuttle has moved to a new landmark.
//
//		Arguments that the called proc should expect:
//			/datum/shuttle/shuttle: the shuttle moving
//			/obj/effect/shuttle_landmark/old_location: the old location's shuttle landmark
//			/obj/effect/shuttle_landmark/new_location: the new location's shuttle landmark

GLOBAL_DATUM_INIT(shuttle_moved_event, /decl/observ/shuttle_moved, new)

/decl/observ/shuttle_moved
	name = "Shuttle Moved"
	expected_type = /datum/shuttle

/*****************
* Shuttle Moved Handling *
*****************/

// Located in modules/shuttle/shuttle.dm
// Proc: /datum/shuttle/proc/attempt_move()