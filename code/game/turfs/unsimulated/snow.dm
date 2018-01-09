
/turf/unsimulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow0"

/turf/unsimulated/floor/snow/New()
	. = ..()
	icon_state = "snow[rand(0,12)]"

/turf/unsimulated/floor/snow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

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
