//	Observer Pattern Implementation: Exited
//		Registration type: /atom
//
//		Raised when: An /atom/movable instance has exited an atom.
//
//		Arguments that the called proc should expect:
//			/atom/entered: The atom that was exited from
//			/atom/movable/enterer: The instance that exited the atom
//			/atom/new_loc: The atom the exitee is now residing in
//

GLOBAL_DATUM_INIT(exited_event, /decl/observ/exited, new)

/decl/observ/exited
	name = "Exited"
	expected_type = /atom

/******************
* Exited Handling *
******************/

/atom/Exited(atom/movable/exitee, atom/new_loc)
	. = ..()
	GLOB.exited_event.raise_event(src, exitee, new_loc)
