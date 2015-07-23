// These are objects that destroy themselves and add themselves to the
// decal list of the floor under them. Use them rather than distinct icon_states
// when mapping in interesting floor designs.
var/list/floor_decals = list()

/obj/effect/floor_decal
	name = "floor decal"
	icon = 'icons/turf/flooring/decals.dmi'

/obj/effect/floor_decal/initialize()
	var/turf/simulated/floor/F = get_turf(src)
	if(istype(F))
		var/cache_key = "[icon_state]-[color]-[alpha]"
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

/obj/effect/floor_decal/corner
	name = "blue corner"
	icon_state = "corner_blue"

/obj/effect/floor_decal/corner/green
	name = "green corner"
	icon_state = "corner_green"

/obj/effect/floor_decal/corner/yellow
	name = "yellow corner"
	icon_state = "corner_yellow"

/obj/effect/floor_decal/corner/red
	name = "red corner"
	icon_state = "corner_red"

/obj/effect/floor_decal/corner/pink
	name = "pink corner"
	icon_state = "corner_pink"

/obj/effect/floor_decal/corner/purple
	name = "purple corner"
	icon_state = "corner_purple"

/obj/effect/floor_decal/corner/orange
	name = "orange corner"
	icon_state = "corner_orange"

/obj/effect/floor_decal/corner/brown
	name = "brown corner"
	icon_state = "corner_brown"

/obj/effect/floor_decal/corner/white
	name = "white corner"
	icon_state = "corner_white"