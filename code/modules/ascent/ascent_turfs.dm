/turf/simulated/wall/ascent
	color = COLOR_PURPLE

/turf/simulated/wall/r_wall/ascent
	color = COLOR_PURPLE

/turf/simulated/floor/shuttle_ceiling/ascent
	color = COLOR_PURPLE
	icon_state = "jaggy"
	icon = 'icons/turf/flooring/alium.dmi'

/turf/simulated/floor/ascent
	name = "mantid plating"
	color = COLOR_GRAY20
	initial_gas = list(GAS_METHYL_BROMIDE = MOLES_CELLSTANDARD * 0.5, GAS_OXYGEN = MOLES_CELLSTANDARD * 0.5)
	icon_state = "curvy"
	footstep_type = /decl/footsteps/tiles
	icon = 'icons/turf/flooring/alium.dmi'

/turf/simulated/floor/ascent/is_plating()
	. = TRUE

/turf/simulated/floor/ascent/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)][rand(0,6)]"

/turf/simulated/floor/ascent/tiled
	name = "floor"
	icon_state = "jaggy"
	color = COLOR_GRAY40
