/obj/effect/overmap/sector/exoplanet/rocks
	name = "Rocky Exoplanet"
	desc = "A planet with rocky formations on the surface, exposing minerals. Rest of terrain varies."

/obj/effect/overmap/sector/exoplanet/rocks/generate_map()
	for(var/zlevel in map_z)
		new /datum/random_map/automata/cave_system/mountains(md5(world.time + rand(-100,1000)),1,1,zlevel,world.maxx,world.maxx)
		var/datum/random_map/noise/exoplanet/M = pick(subtypesof(/datum/random_map/noise/exoplanet))
		M = new M(md5(world.time + rand(-100,1000)),1,1,zlevel,world.maxx,world.maxx)
		get_biostuff(M)
		var/area/A = M.planetary_area
		for(var/_x = 1 to world.maxx)
			for(var/_y = 1 to world.maxy)
				var/turf/T = locate(_x,_y,zlevel)
				A.contents.Add(T)
				if(istype(T,/turf/simulated/mineral))
					var/turf/simulated/mineral/MT = T
					MT.mined_turf = A.base_turf

/obj/effect/overmap/sector/exoplanet/rocks/generate_landing()
	. = ..()
	if(.)
		explosion(., 10, adminlog = 0)

/datum/random_map/automata/cave_system/mountains
	iterations = 2
	descriptor = "space mountains"
	wall_type =  /turf/simulated/mineral
	cell_threshold = 6
	var/colorshift

/datum/random_map/automata/cave_system/mountains/New()
	colorshift = round(rand(0,360),20)
	target_turf_type = world.turf
	floor_type = world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(var/value, var/turf/T)
	..()
	T.color = color_rotation(colorshift)