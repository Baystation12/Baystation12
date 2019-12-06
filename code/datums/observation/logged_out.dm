//	Observer Pattern Implementation: Logged Out
//		Registration type: /mob
//
//		Raised when: A mob logs out (client either logged out or was moved to another mob)
//
//		Arguments that the called proc should expect:
//			/mob/leaver:    The mob that has logged out
//			/client/client: The mob's client

GLOBAL_DATUM_INIT(logged_out_event, /decl/observ/logged_out, new)

/decl/observ/logged_out
	name = "Logged Out"
	expected_type = /mob

/******************
* Logout Handling *
******************/

/mob/Logout()
	GLOB.logged_out_event.raise_event(src, my_client)
	..()
