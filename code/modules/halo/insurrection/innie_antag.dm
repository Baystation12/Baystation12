
//setup fake "antag" profiles for the jobs, in order to give them an inbuilt automatic HUD with minimal extra coding

/datum/antagonist/geminus_insurrectionist
	id = "Geminus Insurrectionist"
	role_text = "Geminus Insurrectionist"
	role_text_plural = "Geminus Insurrectionists"
	antag_indicator = "hudinsurrectionist"

//see code/game/antagoninst/antagonist_helpers.dm
//this is in place so jobbans cant fuck with the hud code
/datum/antagonist/geminus_insurrectionist/can_become_antag(var/datum/mind/player, var/ignore_role)
	return list()

//see code/game/antagoninst/antagonist_update.dm
/datum/antagonist/geminus_insurrectionist/get_indicator(var/datum/mind/recipient, var/datum/mind/other)
	if(!other.current || !recipient.current)
		return
	var/antag_indicator = "hudinsurrectionist"
	if(other.assigned_role == "Insurrectionist Officer")
		antag_indicator = "hudinsurrectionistofficer"
	else if(other.assigned_role == "Insurrectionist Commander")
		antag_indicator = "hudinsurrectionistcommander"

	return image('icons/mob/hud.dmi', loc = other.current, icon_state = antag_indicator, layer = LIGHTING_LAYER+0.1)

/datum/antagonist/geminus_insurrectionist/draft_antagonist(var/datum/mind/player)
	player.special_role = null
