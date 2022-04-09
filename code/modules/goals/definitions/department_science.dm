

/datum/department/science
	name = "Science"
	flag = SCI
	goals = list(/datum/goal/department/extract_slime_cores)

/datum/goal/department/extract_slime_cores
	var/min_cores

/datum/goal/department/extract_slime_cores/New()
	min_cores = rand(7,20)
	..()

/datum/goal/department/extract_slime_cores/update_strings()
	description = "Extract at least [min_cores] slime core\s this shift."

/datum/goal/department/extract_slime_cores/get_summary_value()
	return " ([GLOB.extracted_slime_cores_amount] core\s extracted so far)"

/datum/goal/department/extract_slime_cores/check_success()
	return (GLOB.extracted_slime_cores_amount >= min_cores)

// Personal:
	// xenobio: finish a round without being attacked by a slime
	// explorer: name an alien species, plant a flag on an undiscovered world

/datum/goal/achievement/notslimefodder
	success = TRUE
	failable = TRUE
	description = "You're feeling extra careful today. Don't let a slime snack on you."
	failure_message = "You feel sticky and miserable."
