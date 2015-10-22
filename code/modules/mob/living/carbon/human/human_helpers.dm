/mob/living/carbon/human/proc/can_eat(var/food, var/feedback = 1)
	if(!check_has_mouth())
		if(feedback)
			src << "Where do you intend to put \the [food]? You don't have a mouth!"
		return 0
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		if(feedback)
			src << "<span class='warning'>\The [blocked] is in the way!</span>"
		return 0
	return 1
