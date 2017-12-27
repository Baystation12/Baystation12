
/turf/unsimulated/floor/jungle
	name = "thick vegetation"
	icon = 'icons/turf/flooring/jungle.dmi'
	icon_state = "grass1"

/turf/unsimulated/floor/jungle/New()
	. = ..()
	icon_state = "snow[rand(1,4)]"

	if(prob(2))
		if(prob(33))
			new /obj/effect/rocks(src)
		else
			new /obj/effect/rocks/small(src)
		return .

	if(prob(25))
		new /obj/effect/flora(src)
		return .
