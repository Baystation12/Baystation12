
/mob/living/carbon/human/proc/suppression_act(var/obj/item/projectile/P)
	if(!client)
		return
	var/seconds_since_suppression = (world.time - time_last_suppressed)/10
	if(seconds_since_suppression <= 1.5)
		overlay_fullscreen("suppress",SUPPRESSION_FULLSCREEN_TYPE, SUPPRESS_LARGE)
		//severe supression effects
	else if(seconds_since_suppression <=4)
		overlay_fullscreen("suppress",SUPPRESSION_FULLSCREEN_TYPE, SUPPRESS_MID)
		//medium supression effects
	else if(seconds_since_suppression <=8)
		overlay_fullscreen("suppress",SUPPRESSION_FULLSCREEN_TYPE, SUPPRESS_SMALL)
		//low supression effects
	if(prob(SUPRESSION_SCREAM_CHANCE))
		emote("painscream",AUDIBLE_MESSAGE)
	time_last_suppressed = world.time