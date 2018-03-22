// These are objects that destroy themselves and add themselves to the
// decal list of the floor under them. Use them rather than distinct icon_states
// when mapping in interesting floor designs.
var/list/floor_decals = list()

/obj/effect/floor_decal
	name = "floor decal"
	icon = 'icons/turf/flooring/decals.dmi'
	plane = ABOVE_TURF_PLANE
	layer = DECAL_LAYER
	appearance_flags = RESET_COLOR
	var/supplied_dir

/obj/effect/floor_decal/New(var/newloc, var/newdir, var/newcolour)
	supplied_dir = newdir
	if(newcolour) color = newcolour
	..(newloc)

/obj/effect/floor_decal/Initialize()
	if(supplied_dir) set_dir(supplied_dir)
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		plane = T.is_plating() ? ABOVE_PLATING_PLANE : ABOVE_TURF_PLANE
		var/cache_key = "[alpha]-[color]-[dir]-[icon_state]-[plane]-[layer]"
		if(!floor_decals[cache_key])
			var/image/I = image(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			I.plane = plane
			I.layer = layer
			I.appearance_flags = appearance_flags
			I.color = src.color
			I.alpha = src.alpha
			floor_decals[cache_key] = I
		if(!T.decals) T.decals = list()
		T.decals |= floor_decals[cache_key]
		T.overlays |= floor_decals[cache_key]
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

/obj/effect/floor_decal/reset
	name = "reset marker"

/obj/effect/floor_decal/reset/Initialize()
	var/turf/T = get_turf(src)
	T.remove_decals()
	T.update_icon()
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

/obj/effect/floor_decal/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown_edges"

/obj/effect/floor_decal/carpet/blue
	name = "blue carpet"
	icon_state = "blue1_edges"

/obj/effect/floor_decal/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2_edges"

/obj/effect/floor_decal/carpet/purple
	name = "orange carpet"
	icon_state = "purple_edges"

/obj/effect/floor_decal/carpet/orange
	name = "orange carpet"
	icon_state = "orange_edges"

/obj/effect/floor_decal/carpet/green
	name = "green carpet"
	icon_state = "green_edges"

/obj/effect/floor_decal/carpet/red
	name = "red carpet"
	icon_state = "red_edges"

/obj/effect/floor_decal/carpet/corners
	name = "brown carpet"
	icon_state = "brown_corners"

/obj/effect/floor_decal/carpet/blue/corners
	name = "blue carpet"
	icon_state = "blue1_corners"

/obj/effect/floor_decal/carpet/blue2/corners
	name = "pale blue carpet"
	icon_state = "blue2_corners"

/obj/effect/floor_decal/carpet/purple/corners
	name = "purple carpet"
	icon_state = "purple_corners"

/obj/effect/floor_decal/carpet/orange/corners
	name = "orange carpet"
	icon_state = "orange_corners"

/obj/effect/floor_decal/carpet/green/corners
	name = "green carpet"
	icon_state = "green_corners"

/obj/effect/floor_decal/carpet/red/corners
	name = "red carpet"
	icon_state = "red_corners"

/obj/effect/floor_decal/corner
	icon_state = "corner_white"
	alpha = 229

/obj/effect/floor_decal/corner/black
	name = "black corner"
	color = "#333333"

/obj/effect/floor_decal/corner/black/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/black/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/blue
	name = "blue corner"
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/corner/blue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/blue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/paleblue
	name = "pale blue corner"
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/floor_decal/corner/paleblue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/paleblue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/green
	name = "green corner"
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/corner/green/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/green/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/lime
	name = "lime corner"
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/corner/lime/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/lime/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/yellow
	name = "yellow corner"
	color = COLOR_BROWN

/obj/effect/floor_decal/corner/yellow/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/yellow/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/yellow/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/beige
	name = "beige corner"
	color = COLOR_BEIGE

/obj/effect/floor_decal/corner/beige/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/beige/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/red
	name = "red corner"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/corner/red/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/red/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/red/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/pink
	name = "pink corner"
	color = COLOR_PALE_RED_GRAY

/obj/effect/floor_decal/corner/pink/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/pink/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/purple
	name = "purple corner"
	color = COLOR_PURPLE_GRAY

/obj/effect/floor_decal/corner/purple/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/purple/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/mauve
	name = "mauve corner"
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/corner/mauve/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/mauve/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/orange
	name = "orange corner"
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/corner/orange/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/orange/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/brown
	name = "brown corner"
	color = COLOR_DARK_BROWN

/obj/effect/floor_decal/corner/brown/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/brown/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/white
	name = "white corner"
	icon_state = "corner_white"

/obj/effect/floor_decal/corner/white/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/white/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/grey
	name = "grey corner"
	color = "#8d8c8c"

/obj/effect/floor_decal/corner/grey/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/grey/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/spline/plain
	name = "spline - plain"
	icon_state = "spline_plain"
	alpha = 229

/obj/effect/floor_decal/spline/plain/black
	color = "#333333"

/obj/effect/floor_decal/spline/plain/blue
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/spline/plain/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/floor_decal/spline/plain/green
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/spline/plain/lime
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/spline/plain/yellow
	color = COLOR_BROWN

/obj/effect/floor_decal/spline/plain/beige
	color = COLOR_BEIGE

/obj/effect/floor_decal/spline/plain/red
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/spline/plain/pink
	color = COLOR_PALE_RED_GRAY

/obj/effect/floor_decal/spline/plain/purple
	color = COLOR_PURPLE_GRAY

/obj/effect/floor_decal/spline/plain/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/spline/plain/orange
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/spline/plain/brown
	color = COLOR_DARK_BROWN

/obj/effect/floor_decal/spline/plain/white
	color = COLOR_WHITE

/obj/effect/floor_decal/spline/plain/grey
	color = "#8d8c8c"

/obj/effect/floor_decal/spline/fancy
	name = "spline - fancy"
	icon_state = "spline_fancy"

/obj/effect/floor_decal/spline/fancy/wood
	name = "spline - wood"
	color = "#cb9e04"

/obj/effect/floor_decal/spline/fancy/wood/corner
	icon_state = "spline_fancy_corner"

/obj/effect/floor_decal/spline/fancy/wood/cee
	icon_state = "spline_fancy_cee"

/obj/effect/floor_decal/spline/fancy/wood/three_quarters
	icon_state = "spline_fancy_full"

/obj/effect/floor_decal/industrial/warning
	name = "hazard stripes"
	icon_state = "warning"

/obj/effect/floor_decal/industrial/warning/corner
	icon_state = "warningcorner"

/obj/effect/floor_decal/industrial/warning/full
	icon_state = "warningfull"

/obj/effect/floor_decal/industrial/warning/cee
	icon_state = "warningcee"

/obj/effect/floor_decal/industrial/warning/dust
	name = "hazard stripes"
	icon_state = "warning_dust"

/obj/effect/floor_decal/industrial/warning/dust/corner
	name = "hazard stripes"
	icon_state = "warningcorner_dust"

/obj/effect/floor_decal/industrial/hatch
	name = "hatched marking"
	icon_state = "delivery"
	alpha = 229

/obj/effect/floor_decal/industrial/hatch/yellow
	color = "#cfcf55"

/obj/effect/floor_decal/industrial/hatch/red
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/industrial/hatch/orange
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/industrial/hatch/blue
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/industrial/shutoff
	name = "shutoff valve marker"
	icon_state = "shutoff"

/obj/effect/floor_decal/industrial/outline
	name = "white outline"
	icon_state = "outline"
	alpha = 229

/obj/effect/floor_decal/industrial/outline/blue
	name = "blue outline"
	color = "#00b8b2"

/obj/effect/floor_decal/industrial/outline/yellow
	name = "yellow outline"
	color = "#cfcf55"

/obj/effect/floor_decal/industrial/outline/grey
	name = "grey outline"
	color = "#808080"

/obj/effect/floor_decal/industrial/outline/red
	name = "red outline"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/industrial/outline/orange
	name = "orange outline"
	color = COLOR_DARK_ORANGE

/obj/effect/floor_decal/industrial/loading
	name = "loading area"
	icon_state = "loadingarea"
	alpha = 229

/obj/effect/floor_decal/plaque
	name = "plaque"
	icon_state = "plaque"

/obj/effect/floor_decal/asteroid
	name = "random asteroid rubble"
	icon_state = "asteroid0"

/obj/effect/floor_decal/asteroid/New()
	icon_state = "asteroid[rand(0,9)]"
	..()

/obj/effect/floor_decal/chapel
	name = "chapel"
	icon_state = "chapel"

/obj/effect/floor_decal/ss13/l1
	name = "L1"
	icon_state = "L1"

/obj/effect/floor_decal/ss13/l2
	name = "L2"
	icon_state = "L2"

/obj/effect/floor_decal/ss13/l3
	name = "L3"
	icon_state = "L3"

/obj/effect/floor_decal/ss13/l4
	name = "L4"
	icon_state = "L4"

/obj/effect/floor_decal/ss13/l5
	name = "L5"
	icon_state = "L5"

/obj/effect/floor_decal/ss13/l6
	name = "L6"
	icon_state = "L6"

/obj/effect/floor_decal/ss13/l7
	name = "L7"
	icon_state = "L7"

/obj/effect/floor_decal/ss13/l8
	name = "L8"
	icon_state = "L8"

/obj/effect/floor_decal/ss13/l9
	name = "L9"
	icon_state = "L9"

/obj/effect/floor_decal/ss13/l10
	name = "L10"
	icon_state = "L10"

/obj/effect/floor_decal/ss13/l11
	name = "L11"
	icon_state = "L11"

/obj/effect/floor_decal/ss13/l12
	name = "L12"
	icon_state = "L12"

/obj/effect/floor_decal/ss13/l13
	name = "L13"
	icon_state = "L13"

/obj/effect/floor_decal/ss13/l14
	name = "L14"
	icon_state = "L14"

/obj/effect/floor_decal/ss13/l15
	name = "L15"
	icon_state = "L15"

/obj/effect/floor_decal/ss13/l16
	name = "L16"
	icon_state = "L16"

/obj/effect/floor_decal/sign
	name = "floor sign"
	icon_state = "white_1"

/obj/effect/floor_decal/sign/two
	icon_state = "white_2"

/obj/effect/floor_decal/sign/a
	icon_state = "white_a"

/obj/effect/floor_decal/sign/b
	icon_state = "white_b"

/obj/effect/floor_decal/sign/c
	icon_state = "white_c"

/obj/effect/floor_decal/sign/d
	icon_state = "white_d"

/obj/effect/floor_decal/sign/ex
	icon_state = "white_ex"

/obj/effect/floor_decal/sign/m
	icon_state = "white_m"

/obj/effect/floor_decal/sign/cmo
	icon_state = "white_cmo"

/obj/effect/floor_decal/sign/v
	icon_state = "white_v"

/obj/effect/floor_decal/sign/p
	icon_state = "white_p"

/obj/effect/floor_decal/solarpanel
	icon_state = "solarpanel"

/obj/effect/floor_decal/snow
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snowfloor"

/obj/effect/floor_decal/floordetail
	plane = TURF_PLANE
	layer = TURF_DETAIL_LAYER
	color = COLOR_GUNMETAL
	icon_state = "manydot"
	appearance_flags = 0

/obj/effect/floor_decal/floordetail/New(var/newloc, var/newdir, var/newcolour)
	color = null //color is here just for map preview, if left it applies both our and tile colors.
	..()

/obj/effect/floor_decal/floordetail/tiled
	icon_state = "manydot_tiled"

/obj/effect/floor_decal/floordetail/pryhole
	icon_state = "pryhole"

/obj/effect/floor_decal/floordetail/edgedrain
	icon_state = "edge"

/obj/effect/floor_decal/floordetail/traction
	icon_state = "traction"

/obj/effect/floor_decal/ntlogo
	icon_state = "ntlogo"
