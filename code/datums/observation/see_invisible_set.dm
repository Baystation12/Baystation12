//	Observer Pattern Implementation: See Invisible Set
//		Registration type: /mob
//
//		Raised when: A mob's see_invisible value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its sight set
//			/old_see_invisible: see_invisible before the change
//			/new_see_invisible: see_invisible after the change

GLOBAL_DATUM_INIT(see_invisible_set_event, /decl/observ/see_invisible_set, new)

/decl/observ/see_invisible_set
	name = "See Invisible Set"
	expected_type = /mob

/*****************************
* See Invisible Set Handling *
*****************************/

/mob/proc/set_see_invisible(var/new_see_invisible)
	var/old_see_invisible = see_invisible
	if(old_see_invisible != new_see_invisible)
		see_invisible = new_see_invisible
		GLOB.see_invisible_set_event.raise_event(src, old_see_invisible, new_see_invisible)
