/**********
 *General *
**********/

/crew_sensor_modifier/general/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["name"] = H.get_authentification_name(if_no_id="Unknown")
	crew_data["rank"] = H.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
	crew_data["assignment"] = H.get_assignment(if_no_id="Unknown", if_no_job="No Job")
	return ..()

/**********
 *Jamming *
**********/

/crew_sensor_modifier/general/jamming
	priority = 10

/crew_sensor_modifier/general/jamming/off/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	// This works only because general is checked first and crew_data["sensor_type"] is used to check if whether any additional data should be included.
	crew_data["sensor_type"] = SUIT_SENSOR_OFF

/crew_sensor_modifier/general/jamming/binary/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["sensor_type"] = SUIT_SENSOR_BINARY

/crew_sensor_modifier/general/jamming/vital/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["sensor_type"] = SUIT_SENSOR_VITAL

/crew_sensor_modifier/general/jamming/tracking/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["sensor_type"] = SUIT_SENSOR_TRACKING

/crew_sensor_modifier/general/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["sensor_type"] = pick(SUIT_SENSOR_OFF, SUIT_SENSOR_BINARY, SUIT_SENSOR_VITAL, SUIT_SENSOR_TRACKING)
