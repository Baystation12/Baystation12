//	Observer Pattern Implementation: Density Set
//		Registration type: /atom
//
//		Raised when: An /atom changes density using the set_density() proc.
//
//		Arguments that the called proc should expect:
//			/atom/density_changer: The instance that changed density.
//			/old_density: The density before the change.
//			/new_density: The density after the change.

GLOBAL_DATUM_INIT(density_set_event, /singleton/observ/density_set, new)

/singleton/observ/density_set
	name = "Density Set"
	expected_type = /atom
