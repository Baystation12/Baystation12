//	Observer Pattern Implementation: Hands Swapped
//		Registration type: /mob
//
//		Raised when: A mob has swapped hands.
//
//		Arguments that the called proc should expect:
//			/mob/swapper: The mob that swapped hands.
//

GLOBAL_DATUM_INIT(hands_swapped_event, /decl/observ/hands_swapped, new)

/decl/observ/hands_swapped
	name = "Hands Swapped"
	expected_type = /mob

/*******************
* Hands Swapped Handling *
*******************/

/mob/swap_hand()
	. = ..()
	GLOB.hands_swapped_event.raise_event(src)