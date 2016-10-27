//	Observer Pattern Implementation: Opacity Set
//		Registration type: /atom
//
//		Raised when: An /atom changes opacity using the set_opacity() proc.
//
//		Arguments that the called proc should expect:
//			/atom/dir_changer: The instance that changed opacity
//			/old_opacity: The opacity before the change.
//			/new_opacity: The opacity after the change.

var/decl/observ/opacity_set/opacity_set_event = new()

/decl/observ/opacity_set
	name = "Opacity Set"
	expected_type = /atom

/*******************
* Opacity Handling *
*******************/
/atom/set_opacity(new_opacity)
	var/old_opacity = opacity
	. = ..()
	if(opacity != old_opacity)
		opacity_set_event.raise_event(src, old_opacity, opacity)

/turf/ChangeTurf()
	var/old_opacity = opacity
	. = ..()
	if(opacity != old_opacity)
		opacity_set_event.raise_event(src, old_opacity, opacity)
