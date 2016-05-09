//	Observer Pattern Implementation: Logged in
//		Registration type: /mob
//
//		Raised when: A mob logs in (not client)
//
//		Arguments that the called proc should expect:
//			/mob/joiner: The mob that has logged in

var/decl/observ/logged_in/logged_in_event = new()

/decl/observ/logged_in
	name = "Logged In"
	expected_type = /mob

/*****************
* Login Handling *
*****************/

/mob/Login()
	..()
	logged_in_event.raise_event(src)
