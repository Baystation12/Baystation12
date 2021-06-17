//	Observer Pattern Implementation: Shuttle Moved
//		Registration type: /datum/shuttle/autodock
//
//		Raised when: A shuttle has moved to a new landmark.
//
//		Arguments that the called proc should expect:
//			/datum/shuttle/shuttle: the shuttle moving
//			/obj/effect/shuttle_landmark/old_location: the old location's shuttle landmark
//			/obj/effect/shuttle_landmark/new_location: the new location's shuttle landmark

//	Observer Pattern Implementation: Shuttle Pre Move
//		Registration type: /datum/shuttle/autodock
//
//		Raised when: A shuttle is about to move to a new landmark.
//
//		Arguments that the called proc should expect:
//			/datum/shuttle/shuttle: the shuttle moving
//			/obj/effect/shuttle_landmark/old_location: the old location's shuttle landmark
//			/obj/effect/shuttle_landmark/new_location: the new location's shuttle landmark

GLOBAL_DATUM_INIT(shuttle_moved_event, /decl/observ/shuttle_moved, new)

/decl/observ/shuttle_moved
	name = "Shuttle Moved"
	expected_type = /datum/shuttle

GLOBAL_DATUM_INIT(shuttle_pre_move_event, /decl/observ/shuttle_pre_move, new)

/decl/observ/shuttle_pre_move
	name = "Shuttle Pre Move"
	expected_type = /datum/shuttle

/*****************
* Shuttle Moved/Pre Move Handling *
*****************/

// Located in modules/shuttle/shuttle.dm
// Proc: /datum/shuttle/proc/attempt_move()