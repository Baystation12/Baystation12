/datum/antagonist/proc/create_global_objectives(var/override=0)
	if(config.objectives_disabled != CONFIG_OBJECTIVE_ALL && !override)
		return 0
	if(global_objectives && global_objectives.len)
		return 0
	return 1

/datum/antagonist/proc/create_objectives(var/datum/mind/player, var/override=0)
	if(config.objectives_disabled != CONFIG_OBJECTIVE_ALL && !override)
		return 0
	if(create_global_objectives(override) || global_objectives.len)
		player.objectives |= global_objectives
	return 1

/datum/antagonist/proc/get_special_objective_text()
	return ""

/datum/antagonist/proc/check_victory()
	var/result = 1
	if(config.objectives_disabled == CONFIG_OBJECTIVE_NONE)
		return 1
	if(global_objectives && global_objectives.len)
		for(var/datum/objective/O in global_objectives)
			if(!O.completed && !O.check_completion())
				result = 0
		if(result && victory_text)
			world << "<span class='danger'><font size = 3>[victory_text]</font></span>"
			if(victory_feedback_tag) feedback_set_details("round_end_result","[victory_feedback_tag]")
		else if(loss_text)
			world << "<span class='danger'><font size = 3>[loss_text]</font></span>"
			if(loss_feedback_tag) feedback_set_details("round_end_result","[loss_feedback_tag]")


/mob/proc/add_objectives()
	set name = "Get Objectives"
	set desc = "Recieve optional objectives."
	set category = "OOC"

	src.verbs -= /mob/proc/add_objectives

	if(!src.mind)
		return

	for(var/tag in all_antag_types) //we do all of them in case an admin adds an antagonist via the PP. Those do not show up in gamemode.
		var/datum/antagonist/antagonist = all_antag_types[tag]
		if(antagonist && antagonist.is_antagonist(src.mind))
			antagonist.create_objectives(src.mind,1)

	src << "<b><font size=3>These objectives are completely voluntary. You are not required to complete them.</font></b>"


	show_objectives(src.mind)