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
	seeds = rand(3,5)
	..()

/datum/goal/department/plant_samples/update_strings()
	description = "Scan at least [seeds] different plant\s while on the expeditions."

/datum/goal/department/plant_samples/get_summary_value()
	var/scanned = SSstatistics.get_field("xenoplants_scanned")
	return " ([scanned ? scanned : 0 ] plant specie\s so far)"

/datum/goal/department/plant_samples/check_success()
	return (SSstatistics.get_field("xenoplants_scanned") >= seeds)