 /**
  * tgui states
  *
  * Base state and helpers for states. Just does some sanity checks, implement a state for in-depth checks.
 **/

 /**
  * public
  *
  * Checks the UI state for a mob.
  *
  * required user mob The mob who opened/is using the UI.
  * required state datum/ui_state The state to check.
  *
  * return UI_state The state of the UI.
 **/
/datum/proc/ui_status(mob/user, datum/ui_state/state)
	var/datum/src_object = ui_host()
	if(src_object != src)
		return src_object.ui_status(user, state)

	if(isghost(user)) // Special-case ghosts.
		if(user.can_admin_interact())
			return UI_INTERACTIVE // If they turn it on, admins can interact.
		if(get_dist(src_object, src) < user.client.view)
			return UI_UPDATE // Regular ghosts can only view.
		return UI_CLOSE // To keep too many UIs from being opened.
	return state.can_use_topic(src_object, user) // Check if the state allows interaction.

 /**
  * private
  *
  * Checks if a user can use src_object's UI, and returns the state.
  * Can call a mob proc, which allows overrides for each mob.
  *
  * required src_object datum The object/datum which owns the UI.
  * required user mob The mob who opened/is using the UI.
  *
  * return UI_state The state of the UI.
 **/
/datum/ui_state/proc/can_use_topic(src_object, mob/user)
	return UI_CLOSE // Don't allow interaction by default.

 /**
  * public
  *
  * Standard interaction/sanity checks. Different mob types may have overrides.
  *
  * return UI_state The state of the UI.
 **/
/mob/proc/shared_ui_interaction(src_object)
	if(!client) // Close UIs if mindless.
		return UI_CLOSE
	else if(stat) // Disable UIs if unconcious.
		return UI_DISABLED
	else if(incapacitated() || lying) // Update UIs if incapicitated but concious.
		return UI_UPDATE
	return UI_INTERACTIVE

/mob/living/silicon/ai/shared_ui_interaction(src_object)
	if(!has_power()) // Disable UIs if the AI is unpowered.
		return UI_DISABLED
	return ..()

/mob/living/silicon/robot/shared_ui_interaction(src_object)
	if(cell.charge <= 0 || lockcharge) // Disable UIs if the Borg is unpowered or locked.
		return UI_DISABLED
	return ..()

/**
  * public
  *
  * Check the distance for a living mob.
  * Really only used for checks outside the context of a mob.
  * Otherwise, use shared_living_ui_distance().
  *
  * required src_object The object which owns the UI.
  * required user mob The mob who opened/is using the UI.
  *
  * return UI_state The state of the UI.
 **/
/atom/proc/contents_ui_distance(src_object, mob/living/user)
	return user.shared_living_ui_distance(src_object) // Just call this mob's check.

 /**
  * public
  *
  * Distance versus interaction check.
  *
  * required src_object atom/movable The object which owns the UI.
  *
  * return UI_state The state of the UI.
 **/
/mob/living/proc/shared_living_ui_distance(atom/movable/src_object)
	if(!(src_object in view(src))) // If the object is obscured, close it.
		return UI_CLOSE

	var/dist = get_dist(src_object, src)
	if(dist <= 1) // Open and interact if 1-0 tiles away.
		return UI_INTERACTIVE
	else if(dist <= 2) // View only if 2-3 tiles away.
		return UI_UPDATE
	else if(dist <= 5) // Disable if 5 tiles away.
		return UI_DISABLED
	return UI_CLOSE // Otherwise, we got nothing.

/mob/living/carbon/human/shared_living_ui_distance(atom/movable/src_object)
	if((TK in mutations))
		return UI_INTERACTIVE
	return ..()
