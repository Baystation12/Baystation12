/turf/simulated/floor/disrupts_psionics()
	return (flooring && flooring.is_psi_null()) ? src : ..()

/turf/simulated/floor/tiled/nullglass
	name = "nullglass floor"
	icon_state = "nullglass"
	initial_flooring = /decl/flooring/tiling/nullglass
