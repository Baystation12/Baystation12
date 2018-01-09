
/turf/unsimulated/floor/grass
	name = "grass"
	icon = 'code/modules/halo/icons/turfs/natureicons.dmi'
	icon_state = "grass"

/turf/unsimulated/floor/grass2
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"

/turf/unsimulated/floor/grass2/New()
	. = ..()
	icon_state = "grass[rand(0,3)]"

/turf/unsimulated/floor/grass3
	name = "grass"
	icon = 'code/modules/halo/icons/turfs/seafloor.dmi'
	icon_state = "grass1"

/turf/unsimulated/floor/grass3/New()
	. = ..()
	icon_state = "grass[rand(1,2)]"

/turf/unsimulated/floor/grass4
	name = "grass"
	icon = 'code/modules/halo/icons/turfs/seafloor.dmi'
	icon_state = "grass-dark1"

/turf/unsimulated/floor/grass4/New()
	. = ..()
	icon_state = "grass-dark[rand(1,2)]"

/turf/unsimulated/floor/grass5
	name = "grass"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "grass1"

/turf/unsimulated/floor/grass6
	name = "grass"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "grass2"

/turf/unsimulated/floor/grass7
	name = "grass"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "grass3"

/turf/unsimulated/floor/grass8
	name = "grass"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "grass4"
