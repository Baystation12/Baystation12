/obj/effect/overmap/visitable/sector/exoplanet/garbage
	name = "ruined exoplanet"
	desc = "An arid exoplanet with unnatural formations covering the surface. Hotspots of radiation detected."
	color = "#a5a18b"
	planetary_area = /area/exoplanet/garbage
	map_generators = list(/datum/random_map/city, /datum/random_map/noise/exoplanet/garbage, /datum/random_map/noise/ore/poor)
	possible_themes = list(/datum/exoplanet_theme)
	ruin_tags_whitelist = RUIN_ALIEN|RUIN_NATURAL|RUIN_WRECK
	plant_colors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#120309")
	surface_color = "#a5a18b"
	water_color = null

/obj/effect/overmap/visitable/sector/exoplanet/garbage/generate_map()
	if(prob(50))
		lightlevel = rand(5,10)/10	//deserts are usually :lit:
	..()

/obj/effect/overmap/visitable/sector/exoplanet/garbage/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(20, 100)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/garbage/update_biome()
	..()
	for(var/datum/seed/S in seeds)
		if(prob(90))
			S.set_trait(TRAIT_REQUIRES_WATER,0)
		else
			S.set_trait(TRAIT_REQUIRES_WATER,1)
			S.set_trait(TRAIT_WATER_CONSUMPTION,1)
		if(prob(40))
			S.set_trait(TRAIT_STINGS,1)

/obj/effect/overmap/visitable/sector/exoplanet/garbage/adapt_animal(var/mob/living/simple_animal/A)
	..()
	A.faction = "Guardian" //stops bots form hitting each other

/obj/effect/overmap/visitable/sector/exoplanet/garbage/get_base_image()
	var/image/I = ..()
	I.overlays += image('icons/skybox/planet.dmi', "ruins")
	return I

/datum/random_map/noise/exoplanet/garbage
	descriptor = "garbage exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/desert
	flora_prob = 1
	large_flora_prob = 0
	flora_diversity = 2
	fauna_types = list(/mob/living/simple_animal/hostile/hivebot, /mob/living/simple_animal/hostile/hivebot/range, /mob/living/simple_animal/hostile/viscerator/hive)
	fauna_prob = 4
	megafauna_types = list(/mob/living/simple_animal/hostile/hivebot/mega)
	var/fallout = 0

/datum/random_map/noise/exoplanet/garbage/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0)
	if(prob(60))
		fallout = rand(10, 37.5)
	..()

/datum/random_map/noise/exoplanet/garbage/get_additional_spawns(var/value, var/turf/T)
	..()
	if(is_edge_turf(T))
		return
	var/v = noise2value(value)
	if(v > 5 && !T.is_wall() && prob(5))
		new/obj/item/remains/xeno/charred(T)
	if(v == 4)
		new/obj/structure/rubble/house(T)
	else if(v == 6 && prob(10))
		new/obj/structure/rubble/house(T)
	else
		if(prob(2))
			new/obj/structure/rubble/war(T)
			var/datum/radiation_source/S = new(T, 2*fallout, FALSE)
			S.range = 4
			SSradiation.add_source(S)
			T.set_light(0.4, 1, 2, l_color = PIPE_COLOR_GREEN)
			for(var/turf/simulated/floor/exoplanet/crater in range(3, T))
				crater.melt()
				crater.update_icon()

/datum/random_map/noise/exoplanet/garbage/get_appropriate_path(var/value)
	var/v = noise2value(value)
	if(v == 6)
		if(prob(50))
			return /turf/simulated/floor/exoplanet/concrete/reinforced/damaged
		else
			return /turf/simulated/floor/exoplanet/concrete/reinforced
	if(v == 7)
		return /turf/simulated/floor/exoplanet/concrete/reinforced/damaged
	return land_type

/area/exoplanet/garbage
	ambience = list(
		'sound/effects/wind/desert0.ogg',
		'sound/effects/wind/desert1.ogg',
		'sound/effects/wind/desert2.ogg',
		'sound/effects/wind/desert3.ogg',
		'sound/ambience/ominous1.ogg',
		'sound/ambience/ominous2.ogg',
		'sound/ambience/ominous3.ogg'
	)
	base_turf = /turf/simulated/floor/exoplanet/desert

/turf/simulated/floor/exoplanet/concrete/reinforced
	name = "reinforced concrete"
	desc = "Stone-like artificial material. It has been reinforced with an unknown compound"
	icon_state = "hexacrete"

/turf/simulated/floor/exoplanet/concrete/reinforced/road
	icon_state = "hexacrete_dark"

/turf/simulated/floor/exoplanet/concrete/reinforced/damaged
	broken = TRUE

/obj/item/remains/xeno/charred
	color = COLOR_DARK_GRAY

#define FLOOR_VALUE 0
#define WALL_VALUE 1
#define DOOR_VALUE 3
#define ROAD_VALUE 10
#define ARTIFACT_VALUE 11

#define TRANSLATE_COORD(X,Y) ((((Y) - 1) * limit_x) + (X))

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
	for(var/i = 1 to num_blocks_x)
		blocks_x += blocks_x[i] + block_size + 1
	for(var/i = 1 to num_blocks_y)
		blocks_y += blocks_x[i] + block_size + 1
	blocks_x += limit_x - TRANSITIONEDGE - 1
	blocks_y += limit_y - TRANSITIONEDGE - 1

	//Draw roads
	for(var/x in blocks_x)
		for(var/y = 1 to limit_y)
			map[TRANSLATE_COORD(x-1,y)] = ROAD_VALUE
			map[TRANSLATE_COORD(x,y)] = ROAD_VALUE
			map[TRANSLATE_COORD(x+1,y)] = ROAD_VALUE
	for(var/y in blocks_y)
		for(var/x = 1 to limit_x)
			map[TRANSLATE_COORD(x,y-1)] = ROAD_VALUE
			map[TRANSLATE_COORD(x,y)] = ROAD_VALUE
			map[TRANSLATE_COORD(x,y+1)] = ROAD_VALUE

	//Place buildings
	for(var/i = 1 to blocks_x.len - 1)
		for(var/j = 1 to blocks_y.len - 1)
			for(var/k = 0 to buildings_number - 1)
				for(var/l = 0 to buildings_number - 1)
					var/building_x = blocks_x[i] + 2 + max_building_size * k
					var/building_y = blocks_y[j] + 2 + max_building_size * l
					var/building_size_x = pick(7,9,9,11,11,11)
					var/building_size_y = pick(7,9,9,11,11,11)
					if(building_x + building_size_x >= limit_x - TRANSITIONEDGE)
						continue
					if(building_y + building_size_y >= limit_y - TRANSITIONEDGE)
						continue
					var/building_type = pickweight(building_types)
					var/datum/random_map/building = new building_type(null, building_x, building_y, origin_z, building_size_x, building_size_y, 1, 1, 1, use_area)
					LAZYADD(building_maps, building) // They're applied later to let buildings handle their own shit
	return 1

/datum/random_map/city/get_appropriate_path(var/value)
	if(value == ROAD_VALUE)
		return /turf/simulated/floor/exoplanet/concrete/reinforced/road

/datum/random_map/city/apply_to_map()
	..()
	for(var/datum/random_map/building in building_maps)
		building.apply_to_map()

// Buildings

//Generic ruin
/datum/random_map/maze/concrete
	wall_type =  /turf/simulated/wall/concrete
	floor_type = /turf/simulated/floor/exoplanet/concrete/reinforced
	preserve_map = 0

/datum/random_map/maze/concrete/get_appropriate_path(var/value)
	if(value == WALL_VALUE)
		if(prob(80))
			return /turf/simulated/wall/concrete
		else
			return /turf/simulated/floor/exoplanet/concrete/reinforced/damaged
	return ..()

/datum/random_map/maze/concrete/get_additional_spawns(var/value, var/turf/simulated/floor/T)
	if(!istype(T))
		return
	if(prob(10))
		new/obj/item/remains/xeno/charred(T)
	if((T.broken && prob(80)) || prob(10))
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
	if(prob(10))
		artifacts_to_spawn = rand(2,3)
	..()

/datum/random_map/maze/lab/generate_map()
	..()
	for(var/x in 1 to limit_x - 1)
		for(var/y in 1 to limit_y - 1)
			var/value = map[get_map_cell(x,y)]
			if(value != FLOOR_VALUE)
				continue
			var/list/neighbors = list()
			for(var/offset in list(list(0,1), list(0,-1), list(1,0), list(-1,0)))
				var/char = map[get_map_cell(x + offset[1], y + offset[2])]
				if(char == FLOOR_VALUE || char == DOOR_VALUE)
					neighbors.Add(get_map_cell(x + offset[1], y + offset[2]))
			if(length(neighbors) > 1)
				continue

			map[neighbors[1]] = DOOR_VALUE
			if(artifacts_to_spawn)
				map[get_map_cell(x,y)] = ARTIFACT_VALUE
				artifacts_to_spawn--
	var/entrance_x = pick(rand(2,limit_x-1), 1, limit_x)
	var/entrance_y = pick(1, limit_y)
	if(entrance_x == 1 || entrance_x == limit_x)
		entrance_y = rand(2,limit_y-1)
	map[get_map_cell(entrance_x,entrance_y)] = DOOR_VALUE

/datum/random_map/maze/lab/get_appropriate_path(var/value)
	if(value == ARTIFACT_VALUE)
		return floor_type
	if(value == DOOR_VALUE)
		return floor_type
	. = ..()

/datum/random_map/maze/lab/get_additional_spawns(var/value, var/turf/simulated/floor/T)
	if(!istype(T))
		return

	if(value == DOOR_VALUE)
		new/obj/machinery/door/airlock/alien(T)
		return

	if(value == ARTIFACT_VALUE)
		var/datum/artifact_find/A = new()
		new A.artifact_find_type(T)
		qdel(A)
		return

	if(value == FLOOR_VALUE)
		if(prob(20))
			new/obj/structure/rubble/lab(T)
		if(prob(20))
			new/obj/item/remains/xeno/charred(T)
	

#undef TRANSLATE_COORD