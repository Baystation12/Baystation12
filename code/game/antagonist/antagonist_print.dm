/datum/antagonist/proc/print_player_summary()

	if(!current_antagonists.len)
		return 0

	var/text = "<br><br><font size = 2><b>The [current_antagonists.len == 1 ? "[role_text] was" : "[role_text_plural] were"]:</b></font>"
	for(var/datum/mind/P in current_antagonists)
		text += print_player_full(P)
		text += get_special_objective_text(P)
		if(!global_objectives.len && P.objectives && P.objectives.len)
			var/failed
			var/num = 1
			for(var/datum/objective/O in P.objectives)
				text += print_objective(O, num)
				if(O.check_completion())
					text += "<font color='green'><B>Success!</B></font>"
					feedback_add_details(feedback_tag,"[O.type]|SUCCESS")
				else
					text += "<font color='red'>Fail.</font>"
					feedback_add_details(feedback_tag,"[O.type]|FAIL")
					failed = 1
				num++
				if(failed)
					text += "<br><font color='red'><B>The [role_text] has failed.</B></font>"
				else
					text += "<br><font color='green'><B>The [role_text] was successful!</B></font>"

	if(global_objectives && global_objectives.len)
		text += "<BR><FONT size = 2>Their objectives were:</FONT>"
		var/num = 1
		for(var/datum/objective/O in global_objectives)
			text += print_objective(O, num, 1)
			num++

	// Display the results.
	world << text

/datum/antagonist/proc/print_objective(var/datum/objective/O, var/num, var/append_success)
	var/text = "<br><b>Objective [num]:</b> [O.explanation_text] "
	if(append_success)
		if(O.check_completion())
			text += "<font color='green'><B>Success!</B></font>"
		else
			text += "<font color='red'>Fail.</font>"
	return text

/datum/antagonist/proc/print_player_lite(var/datum/mind/ply)
	var/role = ply.assigned_role ? "\improper[ply.assigned_role]" : "\improper[ply.special_role]"
	var/text = "<br><b>[ply.name]</b> (<b>[ply.key]</b>) as \a <b>[role]</b> ("
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += "died"
		else if(isNotStationLevel(ply.current.z))
			text += "fled the station"
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += "body destroyed"
	text += ")"

	return text

/datum/antagonist/proc/print_player_full(var/datum/mind/ply)
	var/text = print_player_lite(ply)

	var/TC_uses = 0
	var/uplink_true = 0
	var/purchases = ""
	for(var/obj/item/device/uplink/H in world_uplinks)
		if(H && H.uplink_owner && H.uplink_owner == ply)
			TC_uses += H.used_TC
			uplink_true = 1
			purchases += get_uplink_purchases(H)
	if(uplink_true)
		text += " (used [TC_uses] TC)"
		if(purchases)
			text += "<br>[purchases]"

	return text

/proc/print_ownerless_uplinks()
	var/has_printed = 0
	for(var/obj/item/device/uplink/H in world_uplinks)
		if(isnull(H.uplink_owner) && H.used_TC)
			if(!has_printed)
				has_printed = 1
				world << "<b>Ownerless Uplinks</b>"
			world << "[H.loc] (used [H.used_TC] TC)"
			world << get_uplink_purchases(H)

/proc/get_uplink_purchases(var/obj/item/device/uplink/H)
	var/list/refined_log = new()
	for(var/datum/uplink_item/UI in H.purchase_log)
		refined_log.Add("[H.purchase_log[UI]]x[UI.log_icon()][UI.name]")
	. = english_list(refined_log, nothing_text = "")
