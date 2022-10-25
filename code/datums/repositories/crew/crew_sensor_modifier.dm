/datum/crew_sensor_modifier
	var/priority = 1
	var/atom/holder
	var/may_process_proc

/datum/crew_sensor_modifier/New(atom/holder, may_process_proc)
	..()
	src.holder = holder
	src.may_process_proc = may_process_proc

/datum/crew_sensor_modifier/Destroy()
	holder = null
	may_process_proc = null
	. = ..()

/datum/crew_sensor_modifier/proc/may_process_crew_data(mob/living/carbon/human/H, obj/item/clothing/under/C, turf/pos)
	return holder && may_process_proc ? call(holder, may_process_proc)(H, C, pos) : TRUE

/datum/crew_sensor_modifier/proc/process_crew_data(mob/living/carbon/human/H, obj/item/clothing/under/C, turf/pos, list/crew_data)
	return MOD_SUIT_SENSORS_HANDLED
