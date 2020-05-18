//	Observer Pattern Implementation: Dismembered
//		Registration type: /mob/living
//
//		Raised when: A /mob/living instance had an organ removed.
//
//		Arguments that the called proc should expect:
//			/mob/living: The mob being dismembered.
//			/obj/item/organ: The organ removed.
//
//		This is called immediately, before the organ is actually moved or deleted.

GLOBAL_DATUM_INIT(dismembered_event, /decl/observ/dismembered, new)

/decl/observ/dismembered
	name = "Dismembered"
	expected_type = /mob/living

/*******************
* Dismembered Handling *
*******************/

// Called from the base of /obj/item/organ/proc/removed
// In modules/organs/organ.dm