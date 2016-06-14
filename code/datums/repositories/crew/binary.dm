/*********
 *Binary *
*********/

/crew_sensor_modifier/binary/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["dead"] = H.stat > UNCONSCIOUS
	return ..()

/**********
 *Jamming *
**********/

/crew_sensor_modifier/binary/jamming
	priority = 10

/crew_sensor_modifier/binary/jamming/alive/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["dead"] = FALSE
	return MOD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/binary/jamming/dead/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["dead"] = TRUE
	return MOD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/binary/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["dead"] = pick(TRUE, FALSE)
	return MOD_SUIT_SENSORS_HANDLED
