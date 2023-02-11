//	Observer Pattern Implementation: Sight Set
//		Registration type: /mob
//
//		Raised when: A mob's sight value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its sight set
//			/old_sight: sight before the change
//			/new_sight: sight after the change

GLOBAL_DATUM_INIT(sight_set_event, /singleton/observ/sight_set, new)

/singleton/observ/sight_set
	name = "Sight Set"
	expected_type = /mob

/*********************
* Sight Set Handling *
*********************/

/mob
	var/see_black = FALSE

/mob/proc/set_sight(new_sight)
	var/old_sight = sight
	if(see_black)
		new_sight |= SEE_BLACKNESS // Avoids pixel bleed from atoms overlapping completely dark turfs, but conflicts with other flags.
	else
		new_sight &= ~SEE_BLACKNESS
	if(old_sight != new_sight)
		sight = new_sight
		GLOB.sight_set_event.raise_event(src, old_sight, new_sight)
