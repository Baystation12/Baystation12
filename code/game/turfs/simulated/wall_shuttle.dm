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
	dir = NORTHWEST //Don't - ever - set this to a cardinal, it'll fuck up shuttlecode.

//DO NOT MAP THESE AS CARDINAL. EVER. EVERRRRR.
/turf/simulated/shuttle/wall/corner/Initialize()
	. = ..()
	reset_base_appearance()
	reset_overlay()
	addtimer(CALLBACK(src, .proc/underlay_turf), 1)
	if( !(dir in list(NORTHEAST, NORTHWEST, SOUTHWEST, SOUTHEAST)) )
		CRASH("A diagonal wall has been mapped in a cardinal direction at [x], [y], [z]") //So it fails Travis when people do this.

//Grabs the base turf type from our area and copies its appearance
/turf/simulated/shuttle/wall/corner/proc/reset_base_appearance()
	var/turf/base_type = get_base_turf_by_area(src)
	if(!base_type) return

	icon = initial(base_type.icon)
	icon_state = initial(base_type.icon_state)

/turf/simulated/shuttle/wall/corner/proc/underlay_turf()
	var/turf/T = get_step(src, dir)//Gets the turf normal to the diagonal.
	var/image/I = image(icon = T.icon, loc = src, icon_state = T.icon_state, dir = T.dir)
	if(iswall(T)) //Underlay a plating if that turf is a wall.
		I.icon = 'icons/turf/flooring/plating.dmi'
		I.icon_state = "plating"
		I.plane = PLATING_PLANE
	else //Otherwise, use that.
		I.plane = T.plane
		I.layer = T.layer
	underlays += I
	icon_state = "blank"

/turf/simulated/shuttle/wall/corner/proc/reset_overlay()
	if(corner_overlay)
		overlays -= corner_overlay
	else
		corner_overlay = image(icon = 'icons/turf/shuttle.dmi', icon_state = corner_overlay_state, dir = src.dir)
		corner_overlay.plane = plane
		corner_overlay.layer = layer
	overlays += corner_overlay

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