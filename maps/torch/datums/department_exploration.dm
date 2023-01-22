/datum/department/exploration
	name = "Экспедиционный Отдел"
	flag = EXP
	goals = list(
		/datum/goal/department/planet_claim,
		/datum/goal/department/plant_samples,
		/datum/goal/department/fauna_samples
	)
	max_goals = 3

/datum/goal/department/planet_claim
	description = "Установите знамя ЦПСС на поверхности экзопланеты."

/datum/goal/department/planet_claim/check_success()
	return GLOB.stat_flags_planted > 0

/datum/goal/department/plant_samples
	var/seeds

/datum/goal/department/plant_samples/New()
	var/total_seeds = 0
	var/area/map = locate(/area/overmap)
	for(var/obj/effect/overmap/visitable/sector/exoplanet/P in map)
		total_seeds += P.seeds.len
	if(total_seeds)
		seeds = max(1, round(0.5 * total_seeds))
	..()

/datum/goal/department/plant_samples/is_valid()
	return seeds > 0

/datum/goal/department/plant_samples/update_strings()
	description = "Scan at least [seeds] different plant\s native to exoplanets."

/datum/goal/department/plant_samples/get_summary_value()
	return " ([GLOB.stat_flora_scanned] plant specie\s so far)"

/datum/goal/department/plant_samples/check_success()
	return GLOB.stat_flora_scanned >= seeds

/datum/goal/department/fauna_samples
	var/species

/datum/goal/department/fauna_samples/New()
	var/list/total_species = list()
	var/area/map = locate(/area/overmap)
	for(var/obj/effect/overmap/visitable/sector/exoplanet/P in map)
		for(var/mob/living/simple_animal/A in P.animals)
			total_species |= A.type
	species = rand(length(total_species))
	..()

/datum/goal/department/fauna_samples/is_valid()
	return species > 0

/datum/goal/department/fauna_samples/update_strings()
	description = "Scan at least [species] different creature\s native to exoplanets."

/datum/goal/department/fauna_samples/get_summary_value()
	return " ([GLOB.stat_fauna_scanned.len] xenofauna specie\s so far)"

/datum/goal/department/fauna_samples/check_success()
	return GLOB.stat_fauna_scanned.len >= species
