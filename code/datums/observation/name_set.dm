//	Observer Pattern Implementation: Name Set
//		Registration type: /atom
//
//		Raised when: An atom's name changes.
//
//		Arguments that the called proc should expect:
//			/atom/namee:  The atom that had its name set
//			/old_name: name before the change
//			/new_name: name after the change

GLOBAL_DATUM_INIT(name_set_event, /singleton/observ/name_set, new)

/singleton/observ/name_set
	name = "Name Set"
	expected_type = /atom

/*********************
* Name Set Handling *
*********************/

/**
 * Sets the atom's name to the provided value, allowing for any additional processing required that `name = new_value` alone cannot perform. It is preferred to use this over modifying the `name` var directly.
 *
 * This proc will also raise `name_set_event`.
 *
 * **Parameters**:
 * - `new_name` (string) - The new name to set.
 */
/atom/proc/SetName(new_name)
	var/old_name = name
	if(old_name != new_name)
		name = new_name
		if(has_extension(src, /datum/extension/labels))
			var/datum/extension/labels/L = get_extension(src, /datum/extension/labels)
			name = L.AppendLabelsToName(name)
		GLOB.name_set_event.raise_event(src, old_name, new_name)
