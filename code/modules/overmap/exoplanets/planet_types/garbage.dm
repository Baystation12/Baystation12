/obj/effect/overmap/visitable/sector/exoplanet/garbage
	name = "ruined exoplanet"
	desc = "An arid exoplanet with unnatural formations covering the surface. Hotspots of radiation detected."
	color = "#a5a18b"
	planetary_area = /area/exoplanet/garbage
	map_generators = list(/datum/random_map/noise/exoplanet/garbage, /datum/random_map/noise/ore/poor)
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
	flora_prob = 0.5
	large_flora_prob = 0
	flora_diversity = 2
	fauna_types = list(/mob/living/simple_animal/hostile/hivebot, /mob/living/simple_animal/hostile/hivebot/range, /mob/living/simple_animal/hostile/viscerator/hive)
	fauna_prob = 1
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
	if(v > 5)
		new/obj/structure/rubble/house(T)
	else
		if(prob(2))
			new/obj/structure/rubble/war(T)
			var/datum/radiation_source/S = new(T, 2*fallout, FALSE)
			S.range = 4
			SSradiation.add_source(S)
			T.set_light(0.4, 1, 2, l_color = PIPE_COLOR_GREEN)
		if(prob(0.02))
			var/datum/artifact_find/A = new()
			new A.artifact_find_type(T)
			qdel(A)

/datum/random_map/noise/exoplanet/garbage/apply_to_map()
	..()
	var/turf/T = locate(origin_x,origin_y,origin_z)
	if(T)
		var/datum/radiation_source/S = new(T, fallout, FALSE)
		S.range = limit_x
		SSradiation.add_source(S)

/datum/random_map/noise/exoplanet/garbage/get_appropriate_path(var/value)
	var/v = noise2value(value)
	if(v > 6)
		return /turf/simulated/floor/exoplanet/concrete
	return land_type

/area/exoplanet/garbage
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/turf/simulated/floor/exoplanet/concrete
	name = "concrete"
	desc = "Stone-like artificial material."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "concrete"

/turf/simulated/floor/exoplanet/concrete/on_update_icon()
	return