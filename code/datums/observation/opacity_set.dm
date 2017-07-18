//	Observer Pattern Implementation: Opacity Set
//		Registration type: /atom
//
//		Raised when: An /atom changes opacity using the set_opacity() proc.
//
//		Arguments that the called proc should expect:
//			/atom/dir_changer: The instance that changed opacity
//			/old_opacity: The opacity before the change.
//			/new_opacity: The opacity after the change.

GLOBAL_DATUM_INIT(opacity_set_event, /decl/observ/opacity_set, new)

/decl/observ/opacity_set
	name = "Opacity Set"
	expected_type = /atom

/*******************
* Opacity Handling *
*******************/
/atom/proc/set_opacity(new_opacity)
	if(new_opacity != opacity)
		var/old_opacity = opacity
		opacity = new_opacity
		GLOB.opacity_set_event.raise_event(src, old_opacity, new_opacity)
		return TRUE
	else
		return FALSE

/turf/ChangeTurf()
	var/old_opacity = opacity
	. = ..()
	if(opacity != old_opacity)
		GLOB.opacity_set_event.raise_event(src, old_opacity, opacity)
