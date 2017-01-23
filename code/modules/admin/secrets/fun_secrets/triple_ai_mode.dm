/datum/admin_secret_item/fun_secret/triple_ai_mode
	name = "Triple AI Mode"

/datum/admin_secret_item/fun_secret/triple_ai_mode/can_execute(var/mob/user)
	if(ticker && ticker.current_state > GAME_STATE_PREGAME)
		return 0

	return ..()

/datum/admin_secret_item/admin_secret/triple_ai_mode/execute(var/mob/user)
	. = ..()
	if(.)
		user.client.triple_ai()
