/crew_sensor_modifier
	var/priority = 1
	var/atom/holder
	var/may_process_proc

/crew_sensor_modifier/New(var/atom/holder, var/may_process_proc)
	..()
	src.holder = holder
	src.may_process_proc = may_process_proc

/crew_sensor_modifier/Destroy()
	holder = null
	may_process_proc = null
	. = ..()

/crew_sensor_modifier/proc/may_process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos)
	return holder && may_process_proc ? call(holder, may_process_proc)(H, C, pos) : TRUE

/crew_sensor_modifier/proc/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	return MOD_SUIT_SENSORS_HANDLED
