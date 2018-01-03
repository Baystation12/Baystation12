#include "../~objs/snow.dm"
#include "../~objs/rocks.dm"

/turf/unsimulated/floor/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow0"

/turf/unsimulated/floor/snow/New()
	. = ..()
	icon_state = "snow[rand(0,12)]"

	if(prob(0.5))
		new /obj/structure/tree/pine(src)
		return .

	if(prob(1))
		new /obj/structure/tree/dead(src)
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


/turf/unsimulated/floor/ice
	name = "ice"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "ice"
