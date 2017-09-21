//How far from the edge of overmap zlevel could randomly placed objects spawn
#define OVERMAP_EDGE 2
//Dimension of overmap (squares 4 lyfe)
var/global/list/map_sectors = list()

/area/overmap/
	name = "System Map"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	dynamic_lighting = 0
	base_turf = /turf/unsimulated/map

/turf/unsimulated/map
	icon = 'icons/turf/space.dmi'
	icon_state = "map"
	dynamic_lighting = 0

/turf/unsimulated/map/edge
	opacity = 1
	density = 1

/turf/unsimulated/map/New()
	..()
	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == GLOB.using_map.overmap_size)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == GLOB.using_map.overmap_size)
			numbers += "-"
	if(y == 1 || y == GLOB.using_map.overmap_size)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == GLOB.using_map.overmap_size)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == GLOB.using_map.overmap_size)
			I.pixel_x = 5*i + 2
		overlays += I

//list used to track which zlevels are being 'moved' by the proc below
var/list/moving_levels = list()
//Proc to 'move' stars in spess
//yes it looks ugly, but it should only fire when state actually change.
//null direction stops movement
proc/toggle_move_stars(zlevel, direction)
	if(!zlevel)
		return

	var/gen_dir = null
	if(direction & (NORTH|SOUTH))
		gen_dir += "ns"
	else if(direction & (EAST|WEST))
		gen_dir += "ew"
	if(!direction)
		gen_dir = null

	if (moving_levels["[zlevel]"] != gen_dir)
		moving_levels["[zlevel]"] = gen_dir
		for(var/x = 1 to world.maxx)
			for(var/y = 1 to world.maxy)
				var/turf/space/T = locate(x,y,zlevel)
				if (istype(T))
					if(!gen_dir)
						T.icon_state = "[((T.x + T.y) ^ ~(T.x * T.y)) % 25]"
					else
						T.icon_state = "speedspace_[gen_dir]_[rand(1,15)]"
						for(var/atom/movable/AM in T)
							if (!AM.anchored)
								AM.throw_at(get_step(T,reverse_direction(direction)), 5, 1)