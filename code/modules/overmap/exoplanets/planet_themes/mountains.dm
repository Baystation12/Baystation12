/datum/exoplanet_theme/mountains
	name = "Mountains"
	var/rock_color

/datum/exoplanet_theme/mountains/get_sensor_data()
	return "Extensive cave systems and mountain regions detected."

/datum/exoplanet_theme/mountains/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, rock_color)

/datum/exoplanet_theme/mountains/get_planet_image_extra()
	var/image/res = image('icons/skybox/planet.dmi', "mountains")
	res.color = rock_color
	return res

/datum/random_map/automata/cave_system/mountains
	iterations = 2
	descriptor = "space mountains"
	wall_type =  /turf/simulated/mineral
	cell_threshold = 6
	target_turf_type = null
	floor_type = null
	var/rock_color

/datum/random_map/automata/cave_system/mountains/New(seed, tx, ty, tz, tlx, tly, do_not_apply, do_not_announce, never_be_priority = 0, used_area, _rock_color)
	if (_rock_color)
		rock_color = _rock_color
	if (target_turf_type == null)
		target_turf_type = world.turf
	if (floor_type == null)
		floor_type = world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, turf/simulated/mineral/T)
	if (istype(T))
		T.queue_icon_update()
