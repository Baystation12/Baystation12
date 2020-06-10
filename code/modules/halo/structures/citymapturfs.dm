/datum/map/geminus_city
	base_turf_by_z = list("1" = /turf/simulated/floor/planet/dirt)





//| Stairs
	// - default is South, in terms of being at the top of the stairs looking down.
/turf/simulated/floor/stairs/
	name = "stairs"
	icon = 'maps/geminus_city/citymap_icons/ramps.dmi'
	icon_state = "ramptop"
/turf/simulated/floor/stairs/north
	dir = 1
	icon_state = "ramptop"
/turf/simulated/floor/stairs/east
	dir = 4
	icon_state = "ramptop"
/turf/simulated/floor/stairs/west
	dir = 8
	icon_state = "ramptop"

/turf/simulated/floor/stairs/stairsdark/
	icon_state = "rampbottom"
/turf/simulated/floor/stairs/stairsdark/north
	dir = 1
	icon_state = "rampbottom"
/turf/simulated/floor/stairs/stairsdark/east
	dir = 4
	icon_state = "rampbottom"
/turf/simulated/floor/stairs/stairsdark/west
	dir = 8
	icon_state = "rampbottom"

//Disco Lights

/turf/simulated/floor/light
	name = "Light floor"
	light_range = 4
	icon = 'maps/geminus_city/citymap_icons/floorlights.dmi'
	icon_state = "light_on"



//|| Pre-set colored lights for easier mapping
/turf/simulated/floor/light/white
	icon_state = "light_on-w"

/turf/simulated/floor/light/red
	icon_state = "light_on-r"
	light_color = "#feebeb"

/turf/simulated/floor/light/green
	icon_state = "light_on-g"
	light_color = "#ebfeec"

/turf/simulated/floor/light/yellow
	icon_state = "light_on-y"
	light_color = "#fefbeb"

/turf/simulated/floor/light/blue
	icon_state = "light_on-b"
	light_color = "#ebf7fe"

/turf/simulated/floor/light/purple
	icon_state = "light_on-p"
	light_color = "#fcebfe"

// Floors: Can easily merge this into regular floor and add icon states into your main file later.

/turf/simulated/floor/decor
	name = "floor"
	icon = 'maps/geminus_city/citymap_icons/floors.dmi'

/turf/simulated/floor/planet/dirt
	name = "dirt"
	icon_state = "dirt"
	base_desc = "Soft moist, crumbly dirt... was the word moist just used?"
	icon = 'maps/geminus_city/citymap_icons/floors.dmi'
