 /**
  * tgui state: default_state
  *
  * Checks a number of things -- mostly physical distance for humans and view for robots.
 **/

/var/global/datum/ui_state/default/tg_default_state = new()

/datum/ui_state/default/can_use_topic(src_object, mob/user)
	return user.tg_default_can_use_topic(src_object) // Call the individual mob-overriden procs.

/mob/proc/tg_default_can_use_topic(src_object)
	return UI_CLOSE // Don't allow interaction by default.

/mob/living/tg_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE && loc)
		. = min(., loc.contents_ui_distance(src_object, src)) // Check the distance...
	if(. == UI_INTERACTIVE) // Non-human living mobs can only look, not touch.
		return UI_UPDATE

/mob/living/carbon/human/tg_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE)
		. = min(., shared_living_ui_distance(src_object)) // Check the distance...
		// Derp a bit if we have brain loss.
		if(prob(getBrainLoss()))
			return UI_UPDATE

/mob/living/silicon/robot/tg_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. <= UI_DISABLED)
		return

	// Robots can interact with anything they can see.
	if(get_dist(src, src_object) <= client.view)
		return UI_INTERACTIVE
	return UI_DISABLED // Otherwise they can keep the UI open.

/mob/living/silicon/ai/tg_default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. < UI_INTERACTIVE)
		return

	// The AI can interact with anything it can see nearby, or with cameras.
	if((get_dist(src, src_object) <= client.view) || cameranet.is_turf_visible(get_turf_pixel(src_object)))
		return UI_INTERACTIVE
	return UI_CLOSE

/mob/living/silicon/pai/tg_default_can_use_topic(src_object)
	// pAIs can only use themselves and the owner's radio.
	if((src_object == src || src_object == silicon_radio) && !stat)
		return UI_INTERACTIVE
	else
		return ..()
