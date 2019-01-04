/datum/department/medbay
	name = "Medbay"
	flag = MED
	goals = list(
		/datum/goal/medical_fatalities
	)

/datum/goal/medical_fatalities
	var/max_fatalities

/datum/goal/medical_fatalities/New()
	max_fatalities = rand(3,5)
	..()

/datum/goal/medical_fatalities/update_strings()
	description = "Avoid having more than [max_fatalities] [max_fatalities == 1 ? "fatality" : "fatalities"] this shift."

/datum/goal/medical_fatalities/get_summary_value()
	var/deaths = SSstatistics.get_field(FEEDBACK_CREW_DEATHS)
	if(isnull(deaths)) 
		deaths = 0
	return " ([deaths] death\s so far)"

/datum/goal/medical_fatalities/check_success()
	return (SSstatistics.get_field(FEEDBACK_CREW_DEATHS) <= max_fatalities)

// End the shift with % suit sensors set to at least trackers
// Perform an autopsy