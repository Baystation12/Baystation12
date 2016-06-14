/*********
 *Vital *
*********/

/crew_sensor_modifier/vital/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["oxy"] = round(H.getOxyLoss(), 1)
	crew_data["tox"] = round(H.getToxLoss(), 1)
	crew_data["fire"] = round(H.getFireLoss(), 1)
	crew_data["brute"] = round(H.getBruteLoss(), 1)
	return ..()

/**********
 *Jamming *
**********/

/crew_sensor_modifier/vital/jamming
	priority = 10

/crew_sensor_modifier/vital/jamming/healthy/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["oxy"] = 0
	crew_data["tox"] = 0
	crew_data["fire"] = 0
	crew_data["brute"] = 0
	return MOD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/vital/jamming/oxy/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["oxy"] = max(200, crew_data["oxy"])

/crew_sensor_modifier/vital/jamming/tox/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["tox"] = max(200, crew_data["tox"])

/crew_sensor_modifier/vital/jamming/fire/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["fire"] = max(200, crew_data["fire"])

/crew_sensor_modifier/vital/jamming/brute/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	crew_data["brute"] = max(200, crew_data["brute"])

/crew_sensor_modifier/vital/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["oxy"] = rand(0,250)
	crew_data["tox"] = rand(0,250)
	crew_data["fire"] = rand(0,250)
	crew_data["brute"] = rand(0,250)
	return MOD_SUIT_SENSORS_HANDLED
