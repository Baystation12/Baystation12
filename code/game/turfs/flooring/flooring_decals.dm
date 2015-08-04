// These are objects that destroy themselves and add themselves to the
// decal list of the floor under them. Use them rather than distinct icon_states
// when mapping in interesting floor designs.
var/list/floor_decals = list()

/obj/effect/floor_decal
	name = "floor decal"
	icon = 'icons/turf/flooring/decals.dmi'
	layer = TURF_LAYER + 0.01

/obj/effect/floor_decal/initialize()
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		var/cache_key = "[alpha]-[color]-[dir]-[icon_state]-[layer]"
		if(!floor_decals[cache_key])
			var/image/I = image(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			I.layer = T.layer + 0.01
			I.color = src.color
			I.alpha = src.alpha
			floor_decals[cache_key] = I
		if(!T.decals) T.decals = list()
		T.decals |= floor_decals[cache_key]
		T.overlays |= floor_decals[cache_key]
	qdel(src)
	return

/obj/effect/floor_decal/corner/blue
	name = "blue corner"
	icon_state = "corner_blue"

/obj/effect/floor_decal/corner/blue/diagonal
	icon_state = "corner_blue_diagonal"

/obj/effect/floor_decal/corner/blue/full
	icon_state = "corner_blue_full"

/obj/effect/floor_decal/corner/paleblue
	name = "pale blue corner"
	icon_state = "corner_paleblue"

/obj/effect/floor_decal/corner/paleblue/full
	icon_state = "corner_paleblue_full"

/obj/effect/floor_decal/corner/green
	name = "green corner"
	icon_state = "corner_green"

/obj/effect/floor_decal/corner/green/full
	icon_state = "corner_green_full"

/obj/effect/floor_decal/corner/lime
	name = "lime corner"
	icon_state = "corner_lime"

/obj/effect/floor_decal/corner/lime/full
	icon_state = "corner_lime_full"

/obj/effect/floor_decal/corner/yellow
	name = "yellow corner"
	icon_state = "corner_yellow"

/obj/effect/floor_decal/corner/yellow/full
	name = "yellow corner"
	icon_state = "corner_yellow_full"

/obj/effect/floor_decal/corner/beige
	name = "beige corner"
	icon_state = "corner_beige"

/obj/effect/floor_decal/corner/beige/full
	icon_state = "corner_beige_full"

/obj/effect/floor_decal/corner/red
	name = "red corner"
	icon_state = "corner_red"

/obj/effect/floor_decal/corner/red/diagonal
	name = "red corner"
	icon_state = "corner_red_diagonal"

/obj/effect/floor_decal/corner/red/full
	icon_state = "corner_red_full"

/obj/effect/floor_decal/corner/pink
	name = "pink corner"
	icon_state = "corner_pink"

/obj/effect/floor_decal/corner/pink/full
	icon_state = "corner_pink_full"

/obj/effect/floor_decal/corner/purple
	name = "purple corner"
	icon_state = "corner_purple"

/obj/effect/floor_decal/corner/purple/full
	name = "purple corner"
	icon_state = "corner_purple_full"

/obj/effect/floor_decal/corner/mauve
	name = "mauve corner"
	icon_state = "corner_mauve"

/obj/effect/floor_decal/corner/mauve/full
	icon_state = "corner_mauve_full"

/obj/effect/floor_decal/corner/orange
	name = "orange corner"
	icon_state = "corner_orange"

/obj/effect/floor_decal/corner/brown
	name = "brown corner"
	icon_state = "corner_brown"

/obj/effect/floor_decal/corner/brown/full
	icon_state = "corner_brown_full"

/obj/effect/floor_decal/corner/white
	name = "white corner"
	icon_state = "corner_white"

/obj/effect/floor_decal/corner/white/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/white/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/grey
	name = "grey corner"
	icon_state = "corner_grey"

/obj/effect/floor_decal/corner/grey/diagonal
	name = "grey corner"
	icon_state = "corner_grey_diagonal"

/obj/effect/floor_decal/corner/grey/full
	name = "grey corner"
	icon_state = "corner_grey_full"

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

/obj/effect/floor_decal/industrial/outline/blue
	name = "blue outline"
	icon_state = "outline_blue"

/obj/effect/floor_decal/industrial/outline/yellow
	name = "yellow outline"
	icon_state = "outline_yellow"

/obj/effect/floor_decal/industrial/outline/grey
	name = "grey outline"
	icon_state = "outline_grey"

/obj/effect/floor_decal/industrial/loading
	name = "loading area"
	icon_state = "loadingarea"

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
