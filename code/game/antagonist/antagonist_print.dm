/datum/antagonist/proc/print_player_summary()

	if(!current_antagonists.len)
		return 0

	var/text = list()
	text += "<br><br><font size = 2><b>The [current_antagonists.len == 1 ? "[role_text] was" : "[role_text_plural] were"]:</b></font>"
	for(var/datum/mind/P in current_antagonists)
		text += print_player(P)
		text += get_special_objective_text(P)
		var/datum/goal/ambition = SSgoals.ambitions[P]
		if(ambition)
			text += "<br>Their goals for today were..."
			text += "<br><span class='notice'>[ambition.summarize()]</span>"
		if(!global_objectives.len && P.objectives && P.objectives.len)
			var/num = 1
			for(var/datum/objective/O in P.objectives)
				text += print_objective(O, num)
				num++

	if(global_objectives && global_objectives.len)
		text += "<BR><FONT size = 2>Their objectives were:</FONT>"
		var/num = 1
		for(var/datum/objective/O in global_objectives)
			text += print_objective(O, num)
			num++

	// Display the results.
	text += "<br>"
	to_world(jointext(text,null))


/datum/antagonist/proc/print_objective(var/datum/objective/O, var/num)
	return "<br><b>Objective [num]:</b> [O.explanation_text] "

/datum/antagonist/proc/print_player(var/datum/mind/ply)
	var/role = ply.assigned_role ? "\improper[ply.assigned_role]" : (ply.special_role ? "\improper[ply.special_role]" : "unknown role")
	var/text = "<br><b>[ply.name]</b> (<b>[ply.key]</b>) as \a <b>[role]</b> ("
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += "died"
		else if(isNotStationLevel(ply.current.z))
			text += "fled"
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += "body destroyed"
	text += ")"

	return text
