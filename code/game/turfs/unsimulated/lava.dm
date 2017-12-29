
/turf/unsimulated/floor/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/unsimulated/floor/scorched
	name = "scorched rock"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "scorched"

/turf/unsimulated/floor/scorched/New()
	. = ..()

	if(prob(2))
		if(prob(50))
			new /obj/effect/rocks(src)
		else
			new /obj/effect/rocks/small(src)
		return .

/turf/unsimulated/floor/thicksand
	name = "dense sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/unsimulated/floor/thicksand/New()
	. = ..()

	if(prob(1))
		if(prob(25))
			new /obj/effect/rocks(src)
		else
			new /obj/effect/rocks/small(src)
		return .
