//	Observer Pattern Implementation: Turf Changed
//		Registration type: /turf
//
//		Raised when: A turf has been changed using the ChangeTurf proc.
//
//		Arguments that the called proc should expect:
//			/turf/affected:  The turf that has changed
//			/old_density: Density before the change
//			/new_density: Density after the change
//			/old_opacity: Opacity before the change
//			/new_opacity: Opacity after the change

var/decl/observ/turf_changed/turf_changed_event = new()

/decl/observ/turf_changed
	name = "Turf Changed"
	expected_type = /turf

/************************
* Turf Changed Handling *
************************/

/turf/ChangeTurf()
	var/old_density = density
	var/old_opacity = opacity
	. = ..()
	if(.)
		turf_changed_event.raise_event(src, old_density, density, old_opacity, opacity)
