//	Observer Pattern Implementation: Clicked On
//		Registration type: /atom
//
//		Raised when: A mob clicks on the object
//
//		Arguments that the called proc should expect:
//			/mob/user: mob that is clicking
//			/atom/clickee: atom that is being clicked on
//			/obj/item: item that the mob is holding (will be null if they are not holding anything)

GLOBAL_DATUM_INIT(clicked_on_event, /decl/observ/clicked_on, new)

/decl/observ/clicked_on
	name = "Clicked On"
	expected_type = /atom

/mob/ClickOn(var/atom/A, var/params)
	. = ..()
	if(.)
		GLOB.clicked_on_event.raise_event(src, A, get_active_hand())