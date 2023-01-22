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

GLOBAL_DATUM_INIT(turf_changed_event, /decl/observ/turf_changed, new)

/decl/observ/turf_changed
	name = "Turf Changed"
	expected_type = /turf
