
/turf/unsimulated/floor/alien_jaggy
	name = "alien plating"
	icon = 'icons/turf/flooring/alium.dmi'
	icon_state = "jaggy"

/turf/unsimulated/floor/alien_jaggy/New()
	. = ..()
	if(prob(85))
		icon_state = "jaggy[rand(0,6)]"

/turf/unsimulated/floor/alien_curved
	name = "alien plating"
	icon = 'icons/turf/flooring/alium.dmi'
	icon_state = "curvy"

/turf/unsimulated/floor/alien_curved/New()
	. = ..()
	if(prob(85))
		icon_state = "curvy[rand(0,6)]"
