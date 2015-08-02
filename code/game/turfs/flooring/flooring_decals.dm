// These are objects that destroy themselves and add themselves to the
// decal list of the floor under them. Use them rather than distinct icon_states
// when mapping in interesting floor designs.
var/list/floor_decals = list()

/obj/effect/floor_decal
	name = "floor decal"
	icon = 'icons/turf/flooring/decals.dmi'
	layer = TURF_LAYER + 0.1

/obj/effect/floor_decal/initialize()
	var/turf/simulated/floor/F = get_turf(src)
	if(istype(F))
		var/cache_key = "[alpha]-[color]-[dir]-[icon_state]-[layer]"
		if(!floor_decals[cache_key])
			var/image/I = image(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			I.layer = F.layer + 0.1
			I.color = src.color
			I.alpha = src.alpha
			floor_decals[cache_key] = I
		if(!F.decals) F.decals = list()
		F.decals |= floor_decals[cache_key]
		F.overlays |= floor_decals[cache_key]
	qdel(src)
	return

/obj/effect/floor_decal/corner/blue
	name = "blue corner"
	icon_state = "corner_blue"

/obj/effect/floor_decal/corner/blue/diagonal
	icon_state = "corner_blue_diagonal"

/obj/effect/floor_decal/corner/blue/full
	icon_state = "corner_blue_full"

/obj/effect/floor_decal/corner/green
	name = "green corner"
	icon_state = "corner_green"

/obj/effect/floor_decal/corner/green/full
	icon_state = "corner_green_full"

/obj/effect/floor_decal/corner/yellow
	name = "yellow corner"
	icon_state = "corner_yellow"

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

