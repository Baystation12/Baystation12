//	Observer Pattern Implementation: Name Set
//		Registration type: /atom
//
//		Raised when: An atom's name changes.
//
//		Arguments that the called proc should expect:
//			/atom/namee:  The atom that had its name set
//			/old_name: name before the change
//			/new_name: name after the change

GLOBAL_DATUM_INIT(name_set_event, /decl/observ/name_set, new)

/decl/observ/name_set
	name = "Name Set"
	expected_type = /atom

/*********************
* Name Set Handling *
*********************/

// Sets the atom's name as well as adjusts the name extension if such exists
/atom/proc/SetName(new_name, update_icon = TRUE)
	var/old_name = name
	if(old_name == new_name)
		return FALSE
	name = new_name
	var/datum/extension/base_name/bn = get_extension(src, /datum/extension/base_name)
	if(bn)
		bn.base_name = new_name
		if(update_icon)
			update_icon()
	OnNameChange()
	// Event raised separately to ensure it always happens after OnNameChange() is done
	GLOB.name_set_event.raise_event(src, old_name, new_name)
	return TRUE

// Should generally ONLY be called by instances that utilize the name extension referenced above
/atom/proc/ChangeName(new_name)
	var/old_name = name
	if(old_name == new_name)
		return FALSE
	name = new_name
	OnNameChange()
	GLOB.name_set_event.raise_event(src, old_name, new_name)
	return TRUE

/atom/proc/OnNameChange()
	var/datum/extension/labels/L = get_extension(src, /datum/extension/labels)
	if(L)
		name = L.AppendLabelsToName(name)
