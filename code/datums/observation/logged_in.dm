//	Observer Pattern Implementation: Logged in
//		Registration type: /mob
//
//		Raised when: A mob logs in (not client)
//
//		Arguments that the called proc should expect:
//			/mob/joiner: The mob that has logged in

GLOBAL_DATUM_INIT(logged_in_event, /decl/observ/logged_in, new)

/decl/observ/logged_in
	name = "Logged In"
	expected_type = /mob

/*****************
* Login Handling *
*****************/

/mob/Login()
	..()
	l_plane = new()
	l_general = new()
	client.screen += l_plane
	client.screen += l_general
	GLOB.logged_in_event.raise_event(src)
