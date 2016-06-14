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
	priority = 5

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

/*********
* Random *
*********/

/crew_sensor_modifier/vital/jamming/random
	var/min_diff = -10
	var/max_diff = 50
	var/next_shift = 0
	var/list/harm_diffs
	var/static/list/harms

/crew_sensor_modifier/vital/jamming/random/New()
	..()
	if(!harms)
		harms = list("brute", "fire", "oxy", "tox")
	harm_diffs = list()

/crew_sensor_modifier/vital/jamming/random/moderate
	min_diff = -15
	max_diff = 100

/crew_sensor_modifier/vital/jamming/random/major
	min_diff = -20
	max_diff = 200

/crew_sensor_modifier/vital/jamming/random/proc/update_diff_range()
	if(world.time < next_shift)
		return
	next_shift = world.time + rand(30 SECONDS, 2 MINUTES)
	for(var/harm in harms)
		harm_diffs[harm] = rand(min_diff, max_diff)

/crew_sensor_modifier/vital/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	..()
	update_diff_range()
	for(var/harm in harms)
		if(crew_data[harm] == 0 && harm_diffs[harm] < 0) // Making sure jamming(almost) always has an effect
			crew_data[harm] = crew_data[harm] - harm_diffs[harm]
		else
			crew_data[harm] = max(0, crew_data[harm] + harm_diffs[harm])
	return MOD_SUIT_SENSORS_HANDLED
