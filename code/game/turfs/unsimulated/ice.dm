
/turf/unsimulated/floor/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/unsimulated/floor/ice2
	name = "snow"
	icon = 'code/modules/halo/icons/turfs/landscape.dmi'
	icon_state = "ice1"

/turf/unsimulated/floor/ice2/New()
	. = ..()
	icon_state = "ice[rand(1,7)]"

/turf/unsimulated/floor/ice3
	name = "snow"
	icon = 'code/modules/halo/icons/turfs/Ground2.dmi'
	icon_state = "ground_frozen"
