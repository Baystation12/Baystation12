//	Observer Pattern Implementation: Icon Updated
//		Registration type: /atom
//
//		Raised when: An atom's `update_icon()` proc is called, after `on_update_icon()` is handled.
//
//		Arguments that the called proc should expect:
//			/atom: The atom that had its icon update proc called.

GLOBAL_DATUM_INIT(icon_updated_event, /decl/observ/icon_updated, new)

/decl/observ/icon_updated
	name = "Icon Updated"
	expected_type = /atom

/atom/update_icon()
	. = ..()
	GLOB.icon_updated_event.raise_event(src)
