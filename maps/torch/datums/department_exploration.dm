/datum/department/exploration
	name = "Exploration Team"
	flag = EXP
	goals = list(
		/datum/goal/department/planet_claim,
		/datum/goal/department/plant_samples,
		/datum/goal/department/fauna_samples
	)
	max_goals = 3

/datum/goal/department/planet_claim
	description = "Plant the SCG banner on the surface of an exoplanet."

/datum/goal/department/planet_claim/check_success()
	return (SSstatistics.get_field(STAT_FLAGS_PLANTED) > 0)

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
	var/scanned = SSstatistics.get_field(STAT_XENOPLANTS_SCANNED)
	return " ([scanned ? scanned : 0 ] plant specie\s so far)"

/datum/goal/department/plant_samples/check_success()
	return (SSstatistics.get_field(STAT_XENOPLANTS_SCANNED) >= seeds)

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
	var/scanned = length(SSstatistics.get_field(STAT_XENOFAUNA_SCANNED))
	return " ([scanned ? scanned : 0 ] xenofauna specie\s so far)"

/datum/goal/department/fauna_samples/check_success()
	return (length(SSstatistics.get_field(STAT_XENOFAUNA_SCANNED)) >= species)