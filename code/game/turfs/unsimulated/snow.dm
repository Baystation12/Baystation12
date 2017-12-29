
/turf/unsimulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow0"

/turf/unsimulated/floor/snow/New()
	. = ..()
	icon_state = "snow[rand(0,12)]"

	if(prob(0.5))
		new /obj/structure/tree/snow_pine(src)
		return .

	if(prob(0.25))
		new /obj/structure/tree/snow_pine_giant(src)
		return .

	if(prob(1))
		new /obj/structure/tree/snow_dead(src)
		return .

	if(prob(2))
		new /obj/effect/flora/snow(src)
		return .

	if(prob(2))
		if(prob(50))
			new /obj/effect/rocks(src)
		else
			new /obj/effect/rocks/small(src)
		return .

/turf/unsimulated/floor/snow2
	name = "snow"
	icon = 'code/modules/halo/icons/turfs/Ground2.dmi'
	icon_state = "ground_frozen"

/turf/unsimulated/floor/snow3
	name = "snow"
	icon = 'code/modules/halo/icons/turfs/landscape.dmi'
	icon_state = "snow1"

/turf/unsimulated/floor/snow3/New()
	. = ..()
	icon_state = "snow[rand(1,6)]"

/turf/unsimulated/floor/snow4
	name = "snow"
	icon = 'code/modules/halo/icons/turfs/snow.dmi'
	icon_state = "snow1"

/turf/unsimulated/floor/snow4/New()
	. = ..()
	icon_state = "snow[rand(1,7)]"

/turf/unsimulated/floor/snow5
	name = "snow"
	icon = 'code/modules/halo/icons/turfs/snow.dmi'
	icon_state = "gravsnow"

/turf/unsimulated/floor/snow6
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
