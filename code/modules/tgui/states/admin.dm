 /**
  * tgui state: admin_state
  *
  * Checks that the user is an admin, end-of-story.
 **/

/var/global/datum/ui_state/admin_state/tg_admin_state = new()

/datum/ui_state/admin_state/can_use_topic(src_object, mob/user)
	if(check_rights(R_ADMIN, 0, user))
		return UI_INTERACTIVE
	return UI_CLOSE
