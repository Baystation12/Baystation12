/obj/effect/decal/point
	name = "arrow"
	desc = "It's an arrow hanging in mid-air. There may be a wizard about."
	icon = 'icons/mob/screen1.dmi'
	icon_state = "arrow"
	layer = POINTER_LAYER
	anchored = 1
	mouse_opacity = 0

// Used for spray that you spray at walls, tables, hydrovats etc
/obj/effect/decal/spraystill
	density = 0
	anchored = 1
	layer = PROJECTILE_LAYER

/obj/effect/turf_decal/weather
	name = "sandy floor"
	icon_state = "sandyfloor"

/obj/effect/turf_decal/weather/snow
	name = "snowy floor"
	icon_state = "snowyfloor"

/obj/effect/turf_decal/weather/snow/corner
	name = "snow corner piece"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow_corner"

/obj/effect/turf_decal/weather/dirt
	name = "dirt siding"
	icon = 'icons/turf/flooring/decals.dmi'
	icon_state = "dirt_side"

/obj/effect/turf_decal/weather/sand
	name = "sand siding"
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand_side"

/obj/effect/turf_decal/weather/sand/light
	icon_state = "lightsand_side"