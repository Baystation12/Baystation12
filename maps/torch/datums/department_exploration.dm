/datum/department/exploration
	name = "Exploration Team"
	flag = EXP
	goals = list(
		/datum/goal/department/planet_claim,
		/datum/goal/department/plant_samples
	)

/datum/goal/department/planet_claim
	description = "Plant the SCG banner on the surface of an exoplanet."

/datum/goal/department/planet_claim/check_success()
	return (SSstatistics.get_field("planet_flags") > 0)

/datum/goal/department/plant_samples
	var/seeds

/datum/goal/department/plant_samples/New()
	var/total_seeds = 0
	var/area/map = locate(/area/overmap)
	for(var/obj/effect/overmap/sector/exoplanet/P in map)
		total_seeds += P.seeds.len
	seeds = rand(total_seeds)
	..()

/datum/goal/department/plant_samples/update_strings()
	description = "Scan at least [seeds] different plant\s native to exoplanets."
	
/datum/goal/department/plant_samples/get_summary_value()
	var/scanned = SSstatistics.get_field("xenoplants_scanned")
	return " ([scanned ? scanned : 0 ] plant specie\s so far)"

/datum/goal/department/plant_samples/check_success()
	return (SSstatistics.get_field("xenoplants_scanned") >= seeds)