
/*
 * This file handles all parallax-related business once the parallax itself is initialized with the rest of the HUD
 */
#define PARALLAX_IMAGE_WIDTH 8
#define PARALLAX_IMAGE_TILES (PARALLAX_IMAGE_WIDTH**2)
#define GRID_WIDTH 3

var/list/parallax_on_clients = list()
var/parallax_initialized = 0
var/space_color = "#050505"
var/list/parallax_icon[(GRID_WIDTH**2)*3]

/obj/screen/parallax
	var/base_offset_x = 0
	var/base_offset_y = 0
	mouse_opacity = 0
	icon = 'icons/turf/space.dmi'
	icon_state = "blank"
	name = "space parallax"
	screen_loc = "CENTER,CENTER"
	blend_mode = BLEND_ADD
	layer = AREA_LAYER
	plane = PLANE_SPACE_PARALLAX
	var/parallax_speed = 0

/obj/screen/plane_master
	appearance_flags = PLANE_MASTER
	screen_loc = "CENTER,CENTER"

/obj/screen/plane_master/parallax_master
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	color = list(
	1,0,0,0,
	0,1,0,0,
	0,0,1,0,
	0,0,0,0,
	0,0,0,1)

/obj/screen/plane_master/parallax_spacemaster //Turns space white, causing the parallax to only show in areas with opacity. Somehow
	plane = SPACE_PLANE
	color = list(
	0,0,0,0,
	0,0,0,0,
	0,0,0,0,
	1,1,1,1)

/obj/screen/plane_master/parallax_spacemaster/New()
	..()
	overlays += image(icon = 'icons/mob/screen1.dmi', icon_state = "blank")
	if(universe)
		universe.convert_parallax(src)

/obj/screen/plane_master/parallax_dustmaster
	plane = PLANE_SPACE_DUST
	color = list(0,0,0,0)

/datum/hud/proc/update_parallax_existence()
	if(!parallax_initialized)
		return
	initialize_parallax()
	update_parallax()
	update_parallax_values()

/datum/hud/proc/initialize_parallax()
	var/client/C = mymob.client

	if(!C.parallax_master)
		C.parallax_master = new /obj/screen/plane_master/parallax_master
	if(!C.parallax_spacemaster)
		C.parallax_spacemaster = new /obj/screen/plane_master/parallax_spacemaster
	if(!C.parallax_dustmaster)
		C.parallax_dustmaster = new /obj/screen/plane_master/parallax_dustmaster

	if(!C.parallax.len)
		for(var/obj/screen/parallax/bgobj in parallax_icon)
			var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax
			parallax_layer.appearance = bgobj.appearance
			parallax_layer.base_offset_x = bgobj.base_offset_x
			parallax_layer.base_offset_y = bgobj.base_offset_y
			parallax_layer.parallax_speed = bgobj.parallax_speed
			parallax_layer.screen_loc = bgobj.screen_loc
			C.parallax += parallax_layer
			if(bgobj.parallax_speed)
				C.parallax_movable += parallax_layer

	if(!C.parallax_offset.len)
		C.parallax_offset["horizontal"] = 0
		C.parallax_offset["vertical"] = 0

	C.screen |= C.parallax_dustmaster

/datum/hud/proc/update_parallax()
	var/client/C = mymob.client

	parallax_on_clients |= C
	for(var/obj/screen/parallax/bgobj in C.parallax)
		C.screen |= bgobj
	C.screen |= C.parallax_master
	C.screen |= C.parallax_spacemaster
	C.parallax_dustmaster.color = list(
	1,0,0,0,
	0,1,0,0,
	0,0,1,0,
	0,0,0,1)


/datum/hud/proc/update_parallax_values()
	var/client/C = mymob.client
	if(!parallax_initialized)
		return

	if(!(locate(/turf/space) in trange(C.view,get_turf(C.eye))))
		return

	//ACTUALLY MOVING THE PARALLAX
	var/turf/posobj = get_turf(C.eye)

	if(!C.previous_turf || (C.previous_turf.z != posobj.z))
		C.previous_turf = posobj

	//Doing it this way prevents parallax layers from "jumping" when you change Z-Levels.
	var/offsetx = C.parallax_offset["horizontal"] + posobj.x - C.previous_turf.x
	var/offsety = C.parallax_offset["vertical"] + posobj.y - C.previous_turf.y
	C.parallax_offset["horizontal"] = offsetx
	C.parallax_offset["vertical"] = offsety

	C.previous_turf = posobj

	var/parallax_acceleration = 2 //How much 'drift' do you want the parallax to have per movement? This could be used for overmap \
	schenannigans, just make sure to call /datum/hud/update_parallax() somewhere near the end. Was originally held in the player prefs, but frankly that was just stupidand restrictive - so we moved it here.~ Chaoko99

	for(var/obj/screen/parallax/bgobj in C.parallax_movable)
		var/accumulated_offset_x = bgobj.base_offset_x - round(offsetx * bgobj.parallax_speed * parallax_acceleration)
		var/accumulated_offset_y = bgobj.base_offset_y - round(offsety * bgobj.parallax_speed * parallax_acceleration)

		if(accumulated_offset_x > PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE)
			accumulated_offset_x -= PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE*GRID_WIDTH //3x3 grid, 15 tiles * 64 icon_size * 3 grid size
		if(accumulated_offset_x < -(PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE*2))
			accumulated_offset_x += PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE*GRID_WIDTH

		if(accumulated_offset_y > PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE)
			accumulated_offset_y -= PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE*GRID_WIDTH
		if(accumulated_offset_y < -(PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE*2))
			accumulated_offset_y += PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE*GRID_WIDTH

		bgobj.screen_loc = "CENTER:[accumulated_offset_x],CENTER:[accumulated_offset_y]"

//Parallax generation code below

#define PARALLAX4_ICON_NUMBER 20
#define PARALLAX3_ICON_NUMBER 14
#define PARALLAX2_ICON_NUMBER 10

/proc/create_global_parallax_icons()
	var/list/plane1 = list()
	var/list/plane2 = list()
	var/list/plane3 = list()
	var/list/pixel_x = list()
	var/list/pixel_y = list()
	var/index = 1
	for(var/i = 0 to (PARALLAX_IMAGE_TILES-1))
		for(var/j = 1 to GRID_WIDTH**2)
			plane1 += rand(1,26)
			plane2 += rand(1,26)
			plane3 += rand(1,26)
		pixel_x += WORLD_ICON_SIZE * (i%PARALLAX_IMAGE_WIDTH)
		pixel_y += WORLD_ICON_SIZE * round(i/PARALLAX_IMAGE_WIDTH)

	for(var/i in 0 to ((GRID_WIDTH**2)-1))
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax

		var/list/L = list()
		for(var/j in 1 to PARALLAX_IMAGE_TILES)
			if(plane1[j+i*PARALLAX_IMAGE_TILES] <= PARALLAX4_ICON_NUMBER)
				var/image/I = image('icons/turf/space_parallax4.dmi',"[plane1[j+i*PARALLAX_IMAGE_TILES]]")
				I.pixel_x = pixel_x[j]
				I.pixel_y = pixel_y[j]
				L += I

		parallax_layer.overlays = L
		parallax_layer.parallax_speed = 0
		parallax_layer.calibrate_parallax(i+1)
		parallax_icon[index] = parallax_layer
		index++

	for(var/i in 0 to ((GRID_WIDTH**2)-1))
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax

		var/list/L = list()
		for(var/j in 1 to PARALLAX_IMAGE_TILES)
			if(plane2[j+i*PARALLAX_IMAGE_TILES] <= PARALLAX3_ICON_NUMBER)
				var/image/I = image('icons/turf/space_parallax3.dmi',"[plane2[j+i*PARALLAX_IMAGE_TILES]]")
				I.pixel_x = pixel_x[j]
				I.pixel_y = pixel_y[j]
				L += I

		parallax_layer.overlays = L
		parallax_layer.parallax_speed = 0.5
		parallax_layer.calibrate_parallax(i+1)
		parallax_icon[index] = parallax_layer
		index++

	for(var/i in 0 to ((GRID_WIDTH**2)-1))
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax
		var/list/L = list()
		for(var/j in 1 to PARALLAX_IMAGE_TILES)
			if(plane3[j+i*PARALLAX_IMAGE_TILES] <= PARALLAX2_ICON_NUMBER)
				var/image/I = image('icons/turf/space_parallax2.dmi',"[plane3[j+i*PARALLAX_IMAGE_TILES]]")
				I.pixel_x = pixel_x[j]
				I.pixel_y = pixel_y[j]
				L += I

		parallax_layer.overlays = L
		parallax_layer.parallax_speed = 1
		parallax_layer.calibrate_parallax(i+1)
		parallax_icon[index] = parallax_layer
		index++

	parallax_initialized = 1

/obj/screen/parallax/proc/calibrate_parallax(var/i)
	if(!i)
		return

	/* Placement of screen objects
	1	2	3
	4	5	6
	7	8	9
	*/

	base_offset_x = -PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE/2
	base_offset_y = -PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE/2

//TODO: switch to grid size defines... somehow
	switch(i)
		if(1,4,7) //1 mod grid_size
			base_offset_x -= WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH
		if(3,6,9) //0 mod grid_size
			base_offset_x += WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH
	switch(i)
		if(1,2,3) //round(i/grid_size) = 0
			base_offset_y += WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH
		if(7,8,9) //round(i/grid_size) = 2
			base_offset_y -= WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH

	screen_loc = "CENTER:[base_offset_x],CENTER:[base_offset_y]"

#undef PARALLAX4_ICON_NUMBER
#undef PARALLAX3_ICON_NUMBER
#undef PARALLAX2_ICON_NUMBER
#undef PARALLAX_IMAGE_WIDTH
#undef PARALLAX_IMAGE_TILES
