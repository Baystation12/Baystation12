/datum/admin_secret_item/admin_secret/show_game_mode
	name = "Show Game Mode"

/datum/admin_secret_item/admin_secret/show_game_mode/can_execute(var/mob/user)
	if(!SSticker.mode)
		return 0
	return ..()

/datum/admin_secret_item/admin_secret/show_game_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	alert("The game mode is [SSticker.mode.name]")