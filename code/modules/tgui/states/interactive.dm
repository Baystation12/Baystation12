 /**
  * tgui state: interactive_state
  *
  * Always returns interactive.
 **/

/var/global/datum/ui_state/interactive_state/tg_interactive_state = new()

/datum/ui_state/interactive_state/can_use_topic(src_object, mob/user)
	return UI_INTERACTIVE
