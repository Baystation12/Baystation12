//	Observer Pattern Implementation: Logged in
//		Registration type: /mob
//
//		Raised when: A mob logs in (not client)
//
//		Arguments that the called proc should expect:
//			/mob/joiner: The mob that has logged in

GLOBAL_DATUM_INIT(logged_in_event, /singleton/observ/logged_in, new)

/singleton/observ/logged_in
	name = "Logged In"
	expected_type = /mob
