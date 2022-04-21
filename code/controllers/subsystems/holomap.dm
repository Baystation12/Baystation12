// Minimap generation system adapted from vorestation, adapted from /vg/.
// Seems to be much simpler/saner than /vg/'s implementation.

// Turfs that will be colored as HOLOMAP_ROCK
#define IS_ROCK(tile) (istype(tile, /turf/simulated/mineral) || istype(tile, /turf/simulated/floor/asteroid))

// Turfs that will be colored as HOLOMAP_OBSTACLE
#define IS_OBSTACLE(tile) (istype(tile, /turf/simulated/wall) \
					|| istype(tile, /turf/unsimulated/mineral) \
					|| (istype(tile, /turf/unsimulated/wall)) \
					|| (locate(/obj/structure/grille) in tile))

// Turfs that will be colored as HOLOMAP_PATH
#define IS_PATH(tile) ((istype(tile, /turf/simulated/floor) && !istype(tile, /turf/simulated/floor/asteroid)) \
					|| istype(tile, /turf/unsimulated/floor) || (locate(/obj/structure/catwalk) in tile))

//The structure holding a given map
/datum/holomapdata
	var/icon/holomap_base
	var/list/icon/holomap_areas = list()
	var/icon/holomap_combined
	var/icon/holomap_areas_combined
	var/icon/holomap_small

SUBSYSTEM_DEF(minimap)
	name = "Holomap"
	flags = SS_NO_FIRE
	init_order = SS_INIT_HOLOMAP

	var/list/datum/holomapdata/holomaps = list()
	var/list/station_holomaps = list()

/datum/controller/subsystem/minimap/Initialize(start_uptime)
	holomaps.len = world.maxz
	for (var/z = 1 to world.maxz)
		generateHolomap(z)

	//Update machinery if it has not been
	for(var/obj/machinery/ship_map/M in station_holomaps)
		if(istype(M) && !QDELETED(M))
			M.update_map_data()


/datum/controller/subsystem/minimap/proc/generateHolomap(zlevel)
	var/datum/holomapdata/data = new()
	data.holomap_base = generateBaseHolomap(zlevel)
	data.holomap_areas = generateHolomapAreaOverlays(zlevel)

	var/icon/combinedareas = icon(HOLOMAP_ICON, "blank")

	for(var/area/A in data.holomap_areas)
		var/icon/single = data.holomap_areas[A]
		if(A.holomap_color)
			single.Blend(A.holomap_color, ICON_MULTIPLY)
		combinedareas.Blend(single, ICON_OVERLAY)

	data.holomap_areas_combined = combinedareas

	var/icon/map_base = icon(data.holomap_base)

	// Generate the full sized map by blending the base and areas onto the backdrop
	var/icon/big_map = icon(HOLOMAP_ICON, "stationmap")
	big_map.Blend(map_base, ICON_OVERLAY)
	big_map.Blend(combinedareas, ICON_OVERLAY)
	data.holomap_combined = big_map

	// Generate the "small" map
	var/icon/small_map = icon(HOLOMAP_ICON, "blank")
	//Make it green.
	small_map.Blend(map_base, ICON_OVERLAY)
	small_map.Blend(HOLOMAP_HOLOFIER, ICON_MULTIPLY)
	small_map.Blend(combinedareas, ICON_OVERLAY)
	small_map.Scale(WORLD_ICON_SIZE, WORLD_ICON_SIZE)

	// And rotate it in every direction of course!
	var/icon/actual_small_map = icon(small_map)
	actual_small_map.Insert(new_icon = small_map, dir = SOUTH)
	actual_small_map.Insert(new_icon = turn(small_map, 90), dir = WEST)
	actual_small_map.Insert(new_icon = turn(small_map, 180), dir = NORTH)
	actual_small_map.Insert(new_icon = turn(small_map, 270), dir = EAST)
	data.holomap_small = actual_small_map

	holomaps[zlevel] = data

// Generates the "base" holomap for one z-level, showing only the physical structure of walls and paths.
/datum/controller/subsystem/minimap/proc/generateBaseHolomap(zlevel = 1)
	// Save these values now to avoid a bazillion array lookups
	var/offset_x = HOLOMAP_PIXEL_OFFSET_X
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y

	// Sanity checks - Better to generate a helpful error message now than have DrawBox() runtime
	var/icon/canvas = icon(HOLOMAP_ICON, "blank")
	if(world.maxx + offset_x > canvas.Width())
		crash_with("Minimap for z=[zlevel] : world.maxx ([world.maxx]) + holomap_offset_x ([offset_x]) must be <= [canvas.Width()]")
	if(world.maxy + offset_y > canvas.Height())
		crash_with("Minimap for z=[zlevel] : world.maxy ([world.maxy]) + holomap_offset_y ([offset_y]) must be <= [canvas.Height()]")

	for(var/x = 1 to world.maxx)
		for(var/y = 1 to world.maxy)
			var/turf/tile = locate(x, y, zlevel)
			var/area/A
			if(tile)
				A = tile.loc
				if (A.area_flags & AREA_FLAG_HIDE_FROM_HOLOMAP)
					continue
				if(IS_ROCK(tile))
					continue
				if(IS_OBSTACLE(tile))
					canvas.DrawBox(HOLOMAP_OBSTACLE, x + offset_x, y + offset_y)
				else if(IS_PATH(tile))
					canvas.DrawBox(HOLOMAP_PATH, x + offset_x, y + offset_y)

		CHECK_TICK
	return canvas


// Generate overlays based on areas
/datum/controller/subsystem/minimap/proc/generateHolomapAreaOverlays(zlevel)
	var/list/icon/areas = list()

	var/offset_x = HOLOMAP_PIXEL_OFFSET_X
	var/offset_y = HOLOMAP_PIXEL_OFFSET_Y

	for(var/x = 1 to world.maxx)
		for(var/y = 1 to world.maxy)
			var/turf/tile = locate(x, y, zlevel)
			if(tile && tile.loc)
				var/area/areaToPaint = tile.loc
				if(areaToPaint.holomap_color)
					if(!areas[areaToPaint])
						areas[areaToPaint] = icon(HOLOMAP_ICON, "blank")
					areas[areaToPaint].DrawBox(HOLOMAP_AREACOLOR_BASE, x + offset_x, y + offset_y) //We draw white because we want a generic version to use later. However if there is no colour we ignore it
	return areas
