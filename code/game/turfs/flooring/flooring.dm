// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/singleton/flooring
	var/name
	var/desc
	var/icon
	var/icon_base
	var/color
	var/footstep_type = /singleton/footsteps/blank

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/remove_timer
	var/can_paint
	var/can_engrave = TRUE

	//How we smooth with other flooring
	var/decal_layer = DECAL_LAYER
	var/floor_smooth = SMOOTH_ALL
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_ALL
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_ALL
	//There are no lists for spaces

	var/height = 0

/singleton/flooring/proc/on_remove()
	return

/singleton/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass
	can_engrave = FALSE
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE

/singleton/flooring/grass/cut
	floor_smooth = SMOOTH_ALL

/singleton/flooring/dirt
	name = "dirt"
	desc = "Extra dirty."
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "dirt"
	has_base_range = 3
	damage_temperature = T0C+80
	can_engrave = FALSE

/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null
	can_engrave = FALSE

/singleton/flooring/carpet
	name = "brown carpet"
	desc = "Comfy and fancy carpeting."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	can_engrave = FALSE
	footstep_type = /singleton/footsteps/carpet
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/singleton/flooring/carpet/blue
	name = "blue carpet"
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpetblue

/singleton/flooring/carpet/blue2
	name = "pale blue carpet"
	icon_base = "blue2"
	build_type = /obj/item/stack/tile/carpetblue2

/singleton/flooring/carpet/blue3
	name = "sea blue carpet"
	icon_base = "blue3"
	build_type = /obj/item/stack/tile/carpetblue3

/singleton/flooring/carpet/magenta
	name = "magenta carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpetmagenta

/singleton/flooring/carpet/purple
	name = "purple carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpetpurple

/singleton/flooring/carpet/orange
	name = "orange carpet"
	icon_base = "orange"
	build_type = /obj/item/stack/tile/carpetorange

/singleton/flooring/carpet/green
	name = "green carpet"
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpetgreen

/singleton/flooring/carpet/red
	name = "red carpet"
	icon_base = "red"
	build_type = /obj/item/stack/tile/carpetred

/singleton/flooring/carpet/black
	name = "black carpet"
	icon_base = "black"
	build_type = /obj/item/stack/tile/carpetblack

/singleton/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2090's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flags = TURF_REMOVE_SCREWDRIVER
	footstep_type = /singleton/footsteps/tiles

/singleton/flooring/tiling
	name = "floor"
	desc = "A solid, heavy set of flooring plates."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "tiled"
	color = COLOR_DARK_GUNMETAL
	has_damage_range = 4
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_type = /singleton/footsteps/tiles

/singleton/flooring/tiling/mono
	icon_base = "monotile"
	build_type = /obj/item/stack/tile/mono

/singleton/flooring/tiling/mono/dark
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/mono/dark

/singleton/flooring/tiling/mono/white
	icon_base = "monotile_light"
	color = COLOR_OFF_WHITE
	build_type = /obj/item/stack/tile/mono/white

/singleton/flooring/tiling/white
	icon_base = "tiled_light"
	desc = "How sterile."
	color = COLOR_OFF_WHITE
	build_type = /obj/item/stack/tile/floor_white

/singleton/flooring/tiling/dark
	desc = "How ominous."
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/floor_dark

/singleton/flooring/tiling/dark/mono
	icon_base = "monotile"
	build_type = null

/singleton/flooring/tiling/freezer
	desc = "Don't slip."
	icon_base = "freezer"
	color = null
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_freezer

/singleton/flooring/tiling/tech
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_base = "techfloor_gray"
	build_type = /obj/item/stack/tile/techgrey
	color = null

/singleton/flooring/tiling/tech/grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/techgrid

/singleton/flooring/tiling/new_tile
	icon_base = "tile_full"
	color = null
	build_type = null

/singleton/flooring/tiling/new_tile/cargo_one
	icon_base = "cargo_one_full"
	build_type = null

/singleton/flooring/tiling/new_tile/kafel
	icon_base = "kafel_full"
	build_type = null

/singleton/flooring/tiling/stone
	icon_base = "stone"
	build_type = /obj/item/stack/tile/stone

/singleton/flooring/tiling/new_tile/techmaint
	icon_base = "techmaint"
	build_type = /obj/item/stack/tile/techmaint

/singleton/flooring/tiling/new_tile/monofloor
	icon_base = "monofloor"
	color = COLOR_GUNMETAL

/singleton/flooring/tiling/new_tile/steel_grid
	icon_base = "grid"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/grid

/singleton/flooring/tiling/new_tile/steel_ridged
	icon_base = "ridged"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/ridge

/singleton/flooring/wood
	name = "wooden floor"
	desc = "Polished wood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	footstep_type = /singleton/footsteps/wood
	color = WOOD_COLOR_GENERIC

/singleton/flooring/wood/mahogany
	color = WOOD_COLOR_RICH
	build_type = /obj/item/stack/tile/mahogany

/singleton/flooring/wood/maple
	color = WOOD_COLOR_PALE
	build_type = /obj/item/stack/tile/maple

/singleton/flooring/wood/ebony
	color = WOOD_COLOR_BLACK
	build_type = /obj/item/stack/tile/ebony

/singleton/flooring/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	build_type = /obj/item/stack/tile/walnut

/singleton/flooring/wood/bamboo
	color = WOOD_COLOR_PALE2
	build_type = /obj/item/stack/tile/bamboo

/singleton/flooring/wood/yew
	color = WOOD_COLOR_YELLOW
	build_type = /obj/item/stack/tile/yew

/singleton/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/material/steel
	build_cost = 1
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1
	footstep_type = /singleton/footsteps/plating

/singleton/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint = 1
	can_engrave = FALSE

/singleton/flooring/reinforced/circuit/green
	icon_base = "gcircuit"

/singleton/flooring/reinforced/circuit/red
	icon_base = "rcircuit"

/singleton/flooring/reinforced/circuit/selfdestruct
	icon_base = "rcircuit_off"
	flags = TURF_ACID_IMMUNE
	can_paint = FALSE

/singleton/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint = null

/singleton/flooring/reinforced/cult/on_remove()
	GLOB.cult.remove_cultiness(CULTINESS_PER_TURF)

/singleton/flooring/reinforced/shuttle
	name = "floor"
	icon = 'icons/turf/shuttle.dmi'
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1
	can_engrave = FALSE

/singleton/flooring/reinforced/shuttle/blue
	icon_base = "floor"

/singleton/flooring/reinforced/shuttle/yellow
	icon_base = "floor2"

/singleton/flooring/reinforced/shuttle/white
	icon_base = "floor3"

/singleton/flooring/reinforced/shuttle/red
	icon_base = "floor4"

/singleton/flooring/reinforced/shuttle/purple
	icon_base = "floor5"

/singleton/flooring/reinforced/shuttle/darkred
	icon_base = "floor6"

/singleton/flooring/reinforced/shuttle/black
	icon_base = "floor7"

/singleton/flooring/reinforced/shuttle/skrell
	icon = 'icons/turf/skrellturf.dmi'
	icon_base = "skrellblack"

/singleton/flooring/reinforced/shuttle/skrell/white
	icon_base = "skrellwhite"

/singleton/flooring/reinforced/shuttle/skrell/red
	icon_base = "skrellred"

/singleton/flooring/reinforced/shuttle/skrell/blue
	icon_base = "skrellblue"

/singleton/flooring/reinforced/shuttle/skrell/orange
	icon_base = "skrellorange"

/singleton/flooring/reinforced/shuttle/skrell/green
	icon_base = "skrellgreen"

/singleton/flooring/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	color = "#00ffe1"

/singleton/flooring/flesh
	name = "flesh"
	icon = 'icons/turf/flooring/flesh.dmi'
	icon_base = "flesh"
	descriptor = "flesh"
	has_base_range = 3
	damage_temperature = T0C + 100
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_REMOVE_CROWBAR
	remove_timer = 60
	can_engrave = FALSE

/singleton/flooring/pool
	name = "pool floor"
	desc = "Sunken flooring designed to hold liquids."
	icon = 'icons/turf/flooring/pool.dmi'
	icon_base = "pool"
	build_type = /obj/item/stack/tile/pool
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR
	footstep_type = /singleton/footsteps/tiles
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	height = -FLUID_OVER_MOB_HEAD * 2


/singleton/flooring/bluespace
	name = "bluespace"
	desc = "Infinite bluespace. It gives you a piercing headache if you stare at it for too long."
	icon = 'icons/turf/space.dmi'
	icon_base = "bluespace"
	flags = TURF_ACID_IMMUNE
	build_type = null
	footstep_type = /singleton/footsteps/tiles
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
