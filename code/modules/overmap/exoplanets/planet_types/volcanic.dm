/obj/effect/overmap/visitable/sector/exoplanet/volcanic
	name = "volcanic exoplanet"
	desc = "A tectonically unstable planet, extremely rich in minerals."
	color = "#9c2020"
	planetary_area = /area/exoplanet/volcanic
	rock_colors = list(COLOR_DARK_GRAY)
	plant_colors = list("#a23c05","#3f1f0d","#662929","#ba6222","#7a5b3a","#120309")
	possible_themes = list()
	map_generators = list(/datum/random_map/automata/cave_system/mountains/volcanic, /datum/random_map/noise/exoplanet/volcanic, /datum/random_map/noise/ore/filthy_rich)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	surface_color = "#261e19"
	water_color = "#c74d00"

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/get_atmosphere_color()
	return COLOR_GRAY20

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(220, 800)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/adapt_seed(var/datum/seed/S)
	..()
	S.set_trait(TRAIT_REQUIRES_WATER,0)
	S.set_trait(TRAIT_HEAT_TOLERANCE, 1000 + S.get_trait(TRAIT_HEAT_TOLERANCE))

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/adapt_animal(var/mob/living/simple_animal/A)
	..()
	A.heat_damage_per_tick = 0 //animals not hot, no burning in lava

/datum/random_map/noise/exoplanet/volcanic
	descriptor = "volcanic exoplanet"
	smoothing_iterations = 5
	land_type = /turf/simulated/floor/exoplanet/volcanic
	water_type = /turf/simulated/floor/exoplanet/lava
	water_level_min = 5
	water_level_max = 6

	fauna_prob = 1
	flora_prob = 3
	large_flora_prob = 0
	flora_diversity = 3
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/hostile/retaliate/beast/shantak/lava, /mob/living/simple_animal/hostile/retaliate/beast/charbaby)
	megafauna_types = list(/mob/living/simple_animal/hostile/drake)

//Squashing most of 1 tile lava puddles
/datum/random_map/noise/exoplanet/volcanic/cleanup()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(noise2value(map[current_cell]) < water_level)
				continue
			var/frendos
			for(var/dx in list(-1,0,1))
				for(var/dy in list(-1,0,1))
					var/tmp_cell = get_map_cell(x+dx,y+dy)
					if(tmp_cell && tmp_cell != current_cell && noise2value(map[tmp_cell]) >= water_level)
						frendos = 1
						break
			if(!frendos)
				map[current_cell] = 1

/area/exoplanet/volcanic
	forced_ambience = list('sound/ambience/magma.ogg')
	base_turf = /turf/simulated/floor/exoplanet/volcanic

/turf/simulated/floor/exoplanet/volcanic
	name = "volcanic floor"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "cold"
	dirt_color = COLOR_GRAY20

/datum/random_map/automata/cave_system/mountains/volcanic
	iterations = 2
	descriptor = "space volcanic mountains"
	wall_type =  /turf/simulated/mineral/volcanic
	mineral_turf =  /turf/simulated/mineral/random/volcanic
	rock_color = COLOR_DARK_GRAY

/datum/random_map/automata/cave_system/mountains/volcanic/get_additional_spawns(value, var/turf/simulated/mineral/T)
	..()
	if(use_area && istype(T))
		T.mined_turf = prob(90) ? use_area.base_turf : /turf/simulated/floor/exoplanet/lava

/turf/simulated/floor/exoplanet/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	movement_delay = 4
	dirt_color = COLOR_GRAY20
	var/list/victims

/turf/simulated/floor/exoplanet/lava/on_update_icon()
	return

/turf/simulated/floor/exoplanet/lava/Initialize()
	. = ..()
	set_light(0.95, 0.5, 2, l_color = COLOR_ORANGE)

/turf/simulated/floor/exoplanet/lava/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/simulated/floor/exoplanet/lava/Entered(atom/movable/AM)
	..()
	if(locate(/obj/structure/catwalk/) in src)
		return
	var/mob/living/L = AM
	if (istype(L) && L.can_overcome_gravity())
		return
	if(AM.is_burnable())
		LAZYADD(victims, weakref(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/exoplanet/lava/Exited(atom/movable/AM)
	. = ..()
	LAZYREMOVE(victims, weakref(AM))

/turf/simulated/floor/exoplanet/lava/Process()
	if(locate(/obj/structure/catwalk/) in src)
		victims = null
		return PROCESS_KILL
	for(var/weakref/W in victims)
		var/atom/movable/AM = W.resolve()
		if (AM == null || get_turf(AM) != src || AM.is_burnable() == FALSE)
			victims -= W
			continue
		var/datum/gas_mixture/environment = return_air()
		var/pressure = environment.return_pressure()
		var/destroyed = AM.lava_act(environment, 5000 + environment.temperature, pressure)
		if(destroyed == TRUE)
			victims -= W
	if(!LAZYLEN(victims))
		return PROCESS_KILL

/turf/simulated/floor/exoplanet/lava/get_footstep_sound(var/mob/caller)
	return get_footstep(/decl/footsteps/lava, caller)

/turf/simulated/mineral/volcanic
	name = "volcanic rock"
	color = COLOR_DARK_GRAY

/turf/simulated/mineral/random/volcanic
	name = "volcanic rock"
	color = COLOR_DARK_GRAY

/turf/simulated/mineral/random/high_chance/volcanic
	name = "volcanic rock"
	color = COLOR_DARK_GRAY
