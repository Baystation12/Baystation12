#define HUMAN_EATING_NO_ISSUE		0
#define HUMAN_EATING_NO_MOUTH		1
#define HUMAN_EATING_BLOCKED_MOUTH	2

/mob/living/carbon/human/can_eat(var/food, var/feedback = 1)
	var/status = can_eat_status()
	if(status == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status == HUMAN_EATING_NO_MOUTH)
			src << "Where do you intend to put \the [food]? You don't have a mouth!"
		else if(status == HUMAN_EATING_BLOCKED_MOUTH)
			src << "<span class='warning'>\The [blocked] is in the way!</span>"
	return 0

/mob/living/carbon/human/can_force_feed(var/feeder, var/food, var/feedback = 1)
	var/status = can_eat_status()
	if(status == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status == HUMAN_EATING_NO_MOUTH)
			feeder << "Where do you intend to put \the [food]? \The [src] doesn't have a mouth!"
		else if(status == HUMAN_EATING_BLOCKED_MOUTH)
			feeder << "<span class='warning'>\The [blocked] is in the way!</span>"
	return 0

/mob/living/carbon/human/proc/can_eat_status()
	if(!check_has_mouth())
		return HUMAN_EATING_NO_MOUTH
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return HUMAN_EATING_BLOCKED_MOUTH
	return HUMAN_EATING_NO_ISSUE

#undef HUMAN_EATING_NO_ISSUE
#undef HUMAN_EATING_NO_MOUTH
#undef HUMAN_EATING_BLOCKED_MOUTH
