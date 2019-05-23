/datum/exoplanet_theme
	var/name = "Nothing Special"

/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/sector/exoplanet/E)

/datum/exoplanet_theme/mountains
	name = "Mountains"

/datum/exoplanet_theme/mountains/before_map_generation(obj/effect/overmap/sector/exoplanet/E)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, pick(E.rock_colors))

/datum/random_map/automata/cave_system/mountains
	iterations = 2
	descriptor = "space mountains"
	wall_type =  /turf/simulated/mineral
	cell_threshold = 6
	var/area/planetary_area
	var/rock_color

/datum/random_map/automata/cave_system/mountains/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0, var/_planetary_area, var/_rock_color)
	if(_rock_color)
		rock_color = _rock_color
	target_turf_type = world.turf
	floor_type = world.turf
	planetary_area = _planetary_area
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, var/turf/simulated/mineral/T)
	T.color = rock_color
	if(planetary_area)	
		planetary_area.contents.Add(T)
		if(istype(T))
			T.mined_turf = planetary_area.base_turf