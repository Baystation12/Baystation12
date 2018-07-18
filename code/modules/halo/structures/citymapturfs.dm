/datum/map/geminus_city
	base_turf_by_z = list("1" = /turf/simulated/floor/planet/dirt)

//Tech Floors

/turf/simulated/floor/tech
	icon = 'maps/geminus_city/citymap_icons/floors.dmi'
	icon_state = "techfloor_grid"

/turf/simulated/floor/tech/white
	icon_state = "techfloor_white"

/turf/simulated/floor/tech/orange
	icon_state = "techfloor_orangefulltwogrid"

/turf/simulated/floor/tech/gray
	icon_state = "techfloor_gray"


/turf/simulated/floor/light/tech_neon
	icon = 'maps/geminus_city/citymap_icons/floors.dmi'
	icon_state = "techfloor_neon"
	luminosity = 2
	New()
		..()
		update_icon()

/turf/simulated/floor/light/tech_neon/tech_white
	icon_state = "techfloor_neonwhte"

/turf/simulated/floor/light/tech_neon/side
	icon_state = "techfloor_lightedcorner"

/turf/simulated/floor/light/tech_neon/side_grid
	icon_state = "techfloor_lightedcorner_grid"





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

// Walls
/material/chrome
	name = "chrome"
	display_name = "Chrome"
	icon_base = "hospital"
	..()

/material/blackchrome
	name = "blackchrome"
	display_name = "Black Chrome"
	icon_base = "tech"
	..()

/turf/simulated/wall/chrome
	icon = 'maps/geminus_city/citymap_icons/walls.dmi'
	icon_state = "hospital"

/turf/simulated/wall/chrome/New(var/newloc)
	..(newloc,"chrome")


/turf/simulated/wall/tech
	icon = 'maps/geminus_city/citymap_icons/walls.dmi'
	icon_state = "tech"

/turf/simulated/wall/tech/New(var/newloc)
	..(newloc,"blackchrome")
