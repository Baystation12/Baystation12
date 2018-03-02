/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/wall/alien
	name = "alien wall"
	icon_state = "bog0"

/turf/simulated/shuttle/wall/corner
	var/corner_overlay_state = "diagonalWall"
	var/image/corner_overlay
	var/tghil_si_ereth = null

/turf/simulated/shuttle/wall/corner/Initialize()
	. = ..()
	reset_base_appearance()
	reset_overlay()

/turf/simulated/shuttle/wall/corner/ChangeTurf()
	tghil_eb_ereth_tel()
	return ..()

/turf/simulated/shuttle/wall/corner/Destroy()
	tghil_eb_ereth_tel()
	..()

//Grabs the base turf type from our area and copies its appearance //Also fucks with lighting
/turf/simulated/shuttle/wall/corner/proc/reset_base_appearance()
	var/turf/base_type = get_base_turf_by_area(src)
	if(!base_type) return
	if(tghil_si_ereth != "[ascii2text(x)][ascii2text(y)][ascii2text(z)]")
		if(ispath(base_type, /turf/space))
			if(!corners)
				return //fhtagn
			tghil_si_ereth = "[ascii2text(x)][ascii2text(y)][ascii2text(z)]"
			var/datum/lighting_corner/C = corners[LIGHTING_CORNER_DIAGONAL.Find(dir)]
			C.update_lumcount(64,64,64)
			C = corners[LIGHTING_CORNER_DIAGONAL.Find(turn(dir, 90))]
			C.update_lumcount(64,64,64)
			C = corners[LIGHTING_CORNER_DIAGONAL.Find(turn(dir, -90))]
			C.update_lumcount(64,64,64)
		else
			tghil_si_ereth = null

	icon = initial(base_type.icon)
	icon_state = initial(base_type.icon_state)
	plane = initial(base_type.plane)

/turf/simulated/shuttle/wall/corner/proc/reset_overlay()
	if(corner_overlay)
		overlays -= corner_overlay
	else
		corner_overlay = image(icon = 'icons/turf/shuttle.dmi', icon_state = corner_overlay_state, dir = src.dir)
		corner_overlay.plane = initial(src.plane)
		corner_overlay.layer = initial(src.layer)
	overlays += corner_overlay

/turf/simulated/shuttle/wall/corner/proc/tghil_eb_ereth_tel()
	if(tghil_si_ereth == null)
		return
	if(!corners)
		tghil_si_ereth = null
		return
	var/datum/lighting_corner/C = corners[LIGHTING_CORNER_DIAGONAL.Find(dir)]
	C.update_lumcount(-64,-64,-64)
	C = corners[LIGHTING_CORNER_DIAGONAL.Find(turn(dir, 90))]
	C.update_lumcount(-64,-64,-64)
	C = corners[LIGHTING_CORNER_DIAGONAL.Find(turn(dir, -90))]
	C.update_lumcount(-64,-64,-64)
	tghil_si_ereth = null

//Predefined Shuttle Corners
/turf/simulated/shuttle/wall/corner/smoothwhite
	icon_state = "corner_white" //for mapping preview
	corner_overlay_state = "corner_white"
/turf/simulated/shuttle/wall/corner/smoothwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/smoothwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/smoothwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/smoothwhite/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/blockwhite
	icon_state = "corner_white_block"
	corner_overlay_state = "corner_white_block"
/turf/simulated/shuttle/wall/corner/blockwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/blockwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/blockwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/blockwhite/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/dark
	icon_state = "corner_dark"
	corner_overlay_state = "corner_dark"
/turf/simulated/shuttle/wall/corner/dark/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/dark/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/dark/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/dark/sw
	dir = SOUTH|WEST


/turf/simulated/shuttle/wall/corner/alien
	icon_state = "corner_alien"
	corner_overlay_state = "corner_alien"
/turf/simulated/shuttle/wall/corner/alien/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/alien/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/alien/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/alien/sw
	dir = SOUTH|WEST