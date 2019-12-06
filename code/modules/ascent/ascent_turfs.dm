/decl/flooring/tiling_ascent
	name = "floor"
	desc = "An odd jigsaw puzzle of alloy plates."
	icon = 'icons/turf/flooring/alium.dmi'
	icon_base = "jaggy"
	has_base_range = 6
	color = COLOR_GRAY40
	flags = TURF_CAN_BREAK | TURF_CAN_BURN
	footstep_type = /decl/footsteps/tiles

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
	icon = 'icons/turf/flooring/alium.dmi'

/turf/simulated/floor/ascent/Initialize()
	. = ..()
	icon_state = "curvy[rand(0,6)]"

/turf/simulated/floor/tiled/ascent
	name = "mantid tiling"
	icon_state = "jaggy"
	icon = 'icons/turf/flooring/alium.dmi'
	color = COLOR_GRAY40
	initial_gas = list(GAS_METHYL_BROMIDE = MOLES_CELLSTANDARD * 0.5, GAS_OXYGEN = MOLES_CELLSTANDARD * 0.5)
	initial_flooring = /decl/flooring/tiling_ascent
