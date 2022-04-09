
#define FLOOR_VALUE 0
#define WALL_VALUE 1
#define DOOR_VALUE 3
#define ROAD_VALUE 10
#define ARTIFACT_VALUE 11

#define TRANSLATE_COORD(X,Y) ((((Y) - 1) * limit_x) + (X))

/datum/exoplanet_theme/ruined_city
	name = "Ruined City"
	ruin_tags_whitelist = RUIN_ALIEN|RUIN_NATURAL|RUIN_WRECK
	sub_themes = list(/datum/exoplanet_theme/robotic_guardians)
	var/spooky_ambience = list(
		'sound/ambience/ominous1.ogg',
		'sound/ambience/ominous2.ogg',
		'sound/ambience/ominous3.ogg'
		)

/datum/exoplanet_theme/ruined_city/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	E.ruin_tags_whitelist |= RUIN_ALIEN
	for (var/zlevel in E.map_z)
		new /datum/random_map/city(null,1,1,zlevel,E.maxx,E.maxy,0,1,1, E.planetary_area)

	if (prob(50))
		E.lightlevel = rand(5,10)/10	//deserts are usually :lit:

	if (prob(50))
		var/datum/exoplanet_theme/robotic_guardians/T = new /datum/exoplanet_theme/robotic_guardians
		E.themes += T
		E.possible_themes -= /datum/exoplanet_theme/robotic_guardians/

		T.before_map_generation(E)

/datum/exoplanet_theme/ruined_city/after_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	var/area/A = E.planetary_area
	LAZYDISTINCTADD(A.ambience, spooky_ambience)

/datum/exoplanet_theme/ruined_city/get_sensor_data()
	return "Extensive artificial structures detected on the surface."

/datum/exoplanet_theme/ruined_city/get_planet_image_extra()
	return image('icons/skybox/planet.dmi', "ruins")

/datum/random_map/city
	descriptor = "ruined city"
	initial_wall_cell = 0
	initial_cell_char = -1
	var/max_building_size = 11	//Size of buildings in tiles. Must be odd number for building generation to work properly.
	var/buildings_number = 4	//Buildings per block
	var/list/blocks_x = list(TRANSITIONEDGE + 1)	//coordinates for start of blocs
	var/list/blocks_y = list(TRANSITIONEDGE + 1)
	var/list/building_types = list(
		/datum/random_map/maze/concrete = 90,
		/datum/random_map/maze/lab
		)
	var/list/building_maps

/datum/random_map/city/generate_map()
	var/block_size = buildings_number * max_building_size + 2
	var/num_blocks_x = round((limit_x - 2*TRANSITIONEDGE)/block_size)
	var/num_blocks_y = round((limit_y - 2*TRANSITIONEDGE)/block_size)

	//Get blocks borders coordinates
	for (var/i = 1 to num_blocks_x)
		blocks_x += blocks_x[i] + block_size + 1
	for (var/i = 1 to num_blocks_y)
		blocks_y += blocks_x[i] + block_size + 1
	blocks_x += limit_x - TRANSITIONEDGE - 1
	blocks_y += limit_y - TRANSITIONEDGE - 1

	//Draw roads
	for (var/x in blocks_x)
		for (var/y = 1 to limit_y)
			map[TRANSLATE_COORD(x-1,y)] = ROAD_VALUE
			map[TRANSLATE_COORD(x,y)] = ROAD_VALUE
			map[TRANSLATE_COORD(x+1,y)] = ROAD_VALUE
	for (var/y in blocks_y)
		for (var/x = 1 to limit_x)
			map[TRANSLATE_COORD(x,y-1)] = ROAD_VALUE
			map[TRANSLATE_COORD(x,y)] = ROAD_VALUE
			map[TRANSLATE_COORD(x,y+1)] = ROAD_VALUE

	//Place buildings
	for (var/i = 1 to blocks_x.len - 1)
		for (var/j = 1 to blocks_y.len - 1)
			for (var/k = 0 to buildings_number - 1)
				for (var/l = 0 to buildings_number - 1)
					var/building_x = blocks_x[i] + 2 + max_building_size * k
					var/building_y = blocks_y[j] + 2 + max_building_size * l
					var/building_size_x = pick(7,9,9,11,11,11)
					var/building_size_y = pick(7,9,9,11,11,11)
					if (building_x + building_size_x >= limit_x - TRANSITIONEDGE)
						continue
					if (building_y + building_size_y >= limit_y - TRANSITIONEDGE)
						continue
					var/building_type = pickweight(building_types)
					var/datum/random_map/building = new building_type(null, building_x, building_y, origin_z, building_size_x, building_size_y, 1, 1, 1, use_area)
					LAZYADD(building_maps, building) // They're applied later to let buildings handle their own shit
	return 1

/datum/random_map/city/get_appropriate_path(var/value)
	if (value == ROAD_VALUE)
		return /turf/simulated/floor/exoplanet/concrete/reinforced/road

/datum/random_map/city/apply_to_map()
	..()
	for (var/datum/random_map/building in building_maps)
		building.apply_to_map()

// Buildings

//Generic ruin
/datum/random_map/maze/concrete
	wall_type =  /turf/simulated/wall/concrete
	floor_type = /turf/simulated/floor/exoplanet/concrete/reinforced
	preserve_map = 0

/datum/random_map/maze/concrete/get_appropriate_path(var/value)
	if (value == WALL_VALUE)
		if (prob(80))
			return /turf/simulated/wall/concrete
		else
			return /turf/simulated/floor/exoplanet/concrete/reinforced/damaged
	return ..()

/datum/random_map/maze/concrete/get_additional_spawns(var/value, var/turf/simulated/floor/T)
	if (!istype(T))
		return
	if (prob(10))
		new/obj/item/remains/xeno/charred(T)
	if ((T.broken && prob(80)) || prob(10))
		new/obj/structure/rubble/house(T)

//Artifact containment lab
/turf/simulated/wall/containment
	paint_color = COLOR_GRAY20

/turf/simulated/wall/containment/New(var/newloc)
	..(newloc,MATERIAL_CONCRETE, MATERIAL_ALIENALLOY)

/datum/random_map/maze/lab
	wall_type =  /turf/simulated/wall/containment
	floor_type = /turf/simulated/floor/fixed/alium/airless
	preserve_map = 0
	var/artifacts_to_spawn = 1

/datum/random_map/maze/lab/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0)
	if (prob(10))
		artifacts_to_spawn = rand(2,3)
	..()

/datum/random_map/maze/lab/generate_map()
	..()
	for (var/x in 1 to limit_x - 1)
		for (var/y in 1 to limit_y - 1)
			var/value = map[get_map_cell(x,y)]
			if (value != FLOOR_VALUE)
				continue
			var/list/neighbors = list()
			for (var/offset in list(list(0,1), list(0,-1), list(1,0), list(-1,0)))
				var/char = map[get_map_cell(x + offset[1], y + offset[2])]
				if (char == FLOOR_VALUE || char == DOOR_VALUE)
					neighbors.Add(get_map_cell(x + offset[1], y + offset[2]))
			if (length(neighbors) > 1)
				continue

			map[neighbors[1]] = DOOR_VALUE
			if (artifacts_to_spawn)
				map[get_map_cell(x,y)] = ARTIFACT_VALUE
				artifacts_to_spawn--
	var/entrance_x = pick(rand(2,limit_x-1), 1, limit_x)
	var/entrance_y = pick(1, limit_y)
	if (entrance_x == 1 || entrance_x == limit_x)
		entrance_y = rand(2,limit_y-1)
	map[get_map_cell(entrance_x,entrance_y)] = DOOR_VALUE

/datum/random_map/maze/lab/get_appropriate_path(var/value)
	if (value == ARTIFACT_VALUE)
		return floor_type
	if (value == DOOR_VALUE)
		return floor_type
	. = ..()

/datum/random_map/maze/lab/get_additional_spawns(var/value, var/turf/simulated/floor/T)
	if (!istype(T))
		return

	if (value == DOOR_VALUE)
		new/obj/machinery/door/airlock/alien(T)
		return

	if (value == ARTIFACT_VALUE)
		var/datum/artifact_find/A = new()
		new A.artifact_find_type(T)
		qdel(A)
		return

	if (value == FLOOR_VALUE)
		if (prob(20))
			new/obj/structure/rubble/lab(T)
		if (prob(20))
			new/obj/item/remains/xeno/charred(T)


#undef TRANSLATE_COORD

/turf/simulated/floor/exoplanet/concrete/reinforced
	name = "reinforced concrete"
	desc = "Stone-like artificial material. It has been reinforced with an unknown compound."
	icon_state = "hexacrete"

/turf/simulated/floor/exoplanet/concrete/reinforced/road
	icon_state = "hexacrete_dark"

/turf/simulated/floor/exoplanet/concrete/reinforced/damaged
	broken = TRUE

/obj/item/remains/xeno/charred
	color = COLOR_DARK_GRAY