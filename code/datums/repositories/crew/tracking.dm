/*********
 *Vital *
*********/

/crew_sensor_modifier/tracking/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	if(pos)
		var/area/A = get_area(pos)
		crew_data["area"] = sanitize(A.name)
		crew_data["x"] = pos.x
		crew_data["y"] = pos.y
		crew_data["z"] = pos.z
	return ..()

/**********
 *Jamming *
**********/

/crew_sensor_modifier/tracking/jamming
	priority = 10

/crew_sensor_modifier/tracking/jamming/localize/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	return ..(H, C, get_turf(holder), crew_data)

/crew_sensor_modifier/tracking/jamming/random
	var/x_shift
	var/y_shift
	var/next_shift_change

/crew_sensor_modifier/tracking/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	if(world.time > next_shift_change)
		next_shift_change = world.time + rand(1 MINUTE, 3 MINUTES)
		x_shift = rand(-world.view, world.view)
		y_shift = rand(-world.view, world.view)
	if(pos)
		pos = locate(Clamp(pos.x + x_shift, 1, world.maxx), Clamp(pos.y + y_shift, 1, world.maxy), pos.z)
	return ..(H, C, get_turf(holder), crew_data)
