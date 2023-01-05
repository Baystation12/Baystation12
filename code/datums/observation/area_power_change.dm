//	Observer Pattern Implementation: Destroyed
//		Registration type: /area
//
//		Raised when: An /area's power state changes.
//
//		Arguments that the called proc should expect:
//			/area/power_changed: The instance that had a power change.

GLOBAL_DATUM_INIT(area_power_change, /singleton/observ/area_power_change, new)

/singleton/observ/area_power_change
	name = "Area Power Change"
	expected_type = /area
