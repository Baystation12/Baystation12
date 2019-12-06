//	Observer Pattern Implementation: Zone Selected
//		Registration type: /obj/screen/zone_sel
//
//		Raised when: A /obj/screen/zone_sel had its selected zone modified.
//
//		Arguments that the called proc should expect:
//			/obj/screen/zone_sel: the
//			old_zone: the previously selected zone
//          new_zone: the newly selected zone
//

GLOBAL_DATUM_INIT(zone_selected_event, /decl/observ/zone_selected, new)

/decl/observ/zone_selected
	name = "Zone Selected"
	expected_type = /obj/screen/zone_sel

/*******************
* Zone Selected Handling *
*******************/

/obj/screen/zone_sel/set_selected_zone(bodypart)
	var/old_selecting = selecting
	if((. = ..()))
		GLOB.zone_selected_event.raise_event(src, old_selecting, selecting)