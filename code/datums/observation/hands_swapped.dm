//	Observer Pattern Implementation: Hands Swapped
//		Registration type: /mob
//
//		Raised when: A mob has swapped hands.
//
//		Arguments that the called proc should expect:
//			/mob/swapper: The mob that swapped hands.
//

GLOBAL_DATUM_INIT(hands_swapped_event, /singleton/observ/hands_swapped, new)

/singleton/observ/hands_swapped
	name = "Hands Swapped"
	expected_type = /mob
