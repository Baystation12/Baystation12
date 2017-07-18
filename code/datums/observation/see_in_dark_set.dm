//	Observer Pattern Implementation: See In Dark Set
//		Registration type: /mob
//
//		Raised when: A mob's see_in_dark value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its see_in_dark set
//			/old_see_in_dark: see_in_dark before the change
//			/new_see_in_dark: see_in_dark after the change
var/decl/observ/see_in_dark_set/see_in_dark_set_event = new()

/decl/observ/see_in_dark_set
	name = "See In Dark Set"
	expected_type = /mob

/***************************
* See In Dark Set Handling *
***************************/

/mob/proc/set_see_in_dark(var/new_see_in_dark)
	var/old_see_in_dark = sight
	if(old_see_in_dark != new_see_in_dark)
		see_in_dark  = new_see_in_dark
		see_in_dark_set_event.raise_event(src, old_see_in_dark, new_see_in_dark)
