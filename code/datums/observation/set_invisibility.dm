//	Observer Pattern Implementation: Invisibility Set
//		Registration type: /atom
//
//		Raised when: An atom's invisiblity value is changed.
//
//		Arguments that the called proc should expect:
//			/atom/invisibilee:  The atom that had its invisibility set
//			/old_invisibility: invisibility before the change
//			/new_invisibility: invisibility after the change

GLOBAL_DATUM_INIT(invisibility_set_event, /singleton/observ/invisibility_set, new)

/singleton/observ/invisibility_set
	name = "Invisibility Set"
	expected_type = /atom

/*****************************
* Invisibility Set Handling *
*****************************/

/**
 * Sets the atom's invisibility and raises the invisibility set event.
 *
 * **Parameters**:
 * - `new_invisibility` integer (Default `0`) - The new invisibility to set.
 */
/atom/proc/set_invisibility(new_invisibility = 0)
	var/old_invisibility = invisibility
	if(old_invisibility != new_invisibility)
		invisibility = new_invisibility
		GLOB.invisibility_set_event.raise_event(src, old_invisibility, new_invisibility)
