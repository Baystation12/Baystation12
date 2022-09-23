

/datum/department/science
	name = "Научно-Исследовательский Отдел"
	flag = SCI
	goals = list(/datum/goal/department/extract_slime_cores)

/datum/goal/department/extract_slime_cores
	var/min_cores

/datum/goal/department/extract_slime_cores/New()
	min_cores = rand(7,20)
	..()

/datum/goal/department/extract_slime_cores/update_strings()
	description = "Извлеките по крайней мере [min_cores] ядер слизи в этой смене."

/datum/goal/department/extract_slime_cores/get_summary_value()
	return " (Кол-во извлечённых ядер: [GLOB.extracted_slime_cores_amount])"

/datum/goal/department/extract_slime_cores/check_success()
	return (GLOB.extracted_slime_cores_amount >= min_cores)

// Personal:
	// xenobio: finish a round without being attacked by a slime
	// explorer: name an alien species, plant a flag on an undiscovered world

/datum/goal/achievement/notslimefodder
	success = TRUE
	failable = TRUE
	description = "Сегодня ты чувствуешь себя особенно осторожным. Не позволь слизи перекусить тобой."
	failure_message = "Вы чувствуете себя липким и несчастным."
