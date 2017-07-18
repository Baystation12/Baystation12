//	Observer Pattern Implementation: Density Set
//		Registration type: /atom
//
//		Raised when: An /atom changes density using the set_density() proc.
//
//		Arguments that the called proc should expect:
//			/atom/density_changer: The instance that changed density.
//			/old_density: The density before the change.
//			/new_density: The density after the change.

var/decl/observ/density_set/density_set_event = new()

/decl/observ/density_set
	name = "Density Set"
	expected_type = /atom

/*******************
* Density Handling *
*******************/
/atom/set_density(new_density)
	var/old_density = density
	. = ..()
	if(density != old_density)
		density_set_event.raise_event(src, old_density, density)

/turf/ChangeTurf()
	var/old_density = opacity
	. = ..()
	if(density != old_density)
		density_set_event.raise_event(src, old_density, density)
