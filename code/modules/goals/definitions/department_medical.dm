/datum/department/medbay
	name = "Медицинский Отдел"
	flag = MED
	goals = list(
		/datum/goal/department/medical_fatalities
	)

/datum/goal/department/medical_fatalities
	var/max_fatalities

/datum/goal/department/medical_fatalities/New()
	max_fatalities = rand(3,6)
	..()

/datum/goal/department/medical_fatalities/update_strings()
	description = "Избежать более [max_fatalities] [max_fatalities == 1 ? "фатального" : "фатальных"] случаев в эту смену."

/datum/goal/department/medical_fatalities/get_summary_value()
	return " (Кол-во смертей: [GLOB.crew_death_count])"

/datum/goal/department/medical_fatalities/check_success()
	return GLOB.crew_death_count <= max_fatalities




// End the shift with % suit sensors set to at least trackers
// Perform an autopsy
