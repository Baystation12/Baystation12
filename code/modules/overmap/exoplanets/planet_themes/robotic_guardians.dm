/datum/exoplanet_theme/robotic_guardians
	name = "Robotic Guardians"
	var/list/guardian_types = list(
		/mob/living/simple_animal/hostile/hivebot,
		/mob/living/simple_animal/hostile/hivebot/range,
		/mob/living/simple_animal/hostile/viscerator/hive
	)
	var/list/mega_guardian_types = list(
		/mob/living/simple_animal/hostile/hivebot/mega
	)

/datum/exoplanet_theme/robotic_guardians/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	E.ruin_tags_whitelist |= RUIN_ALIEN
	E.fauna_types |= guardian_types
	E.megafauna_types |= mega_guardian_types

/datum/exoplanet_theme/robotic_guardians/adapt_animal(obj/effect/overmap/visitable/sector/exoplanet/E, mob/A)
	// Stopping robots from fighting each other
	if (is_type_in_list(A, guardian_types | mega_guardian_types))
		A.faction = "Ancient Guardian"

/datum/exoplanet_theme/robotic_guardians/get_sensor_data()
	return "Movement without corresponding lifesigns detected on the surface."