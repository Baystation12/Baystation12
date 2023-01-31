/datum/antagonist/proc/get_panel_entry(datum/mind/player)

	var/dat = "<tr><td><b>[role_text]:</b>"
	var/extra = get_extra_panel_options(player)
	if(is_antagonist(player))
		dat += "<a href='?src=\ref[player];remove_antagonist=[id]'>\[-\]</a>"
		dat += "<a href='?src=\ref[player];equip_antagonist=[id]'>\[equip\]</a>"
		if(starting_locations && length(starting_locations))
			dat += "<a href='?src=\ref[player];move_antag_to_spawn=[id]'>\[move to spawn\]</a>"
		if(extra) dat += "[extra]"
	else
		dat += "<a href='?src=\ref[player];add_antagonist=[id]'>\[+\]</a>"
	dat += "</td></tr>"

	return dat

/datum/antagonist/proc/get_extra_panel_options()
	return

/datum/antagonist/proc/get_check_antag_output(datum/admins/caller)

	if(!current_antagonists || !length(current_antagonists))
		return ""

	var/dat = "<br><table cellspacing=5><tr><td><B>[role_text_plural]</B></td><td></td></tr>"
	for(var/datum/mind/player in current_antagonists)
		var/mob/M = player.current
		dat += "<tr>"
		if(M)
			dat += "<td><a href='?_src_=holder;adminplayeropts=\ref[M]'>[M.real_name]/([player.key])</a>"
			if(!M.client)      dat += " <i>(logged out)</i>"
			if(M.stat == DEAD) dat += " <b>[SPAN_COLOR("red", "(DEAD)")]</b>"
			dat += "</td>"
			dat += "<td>\[<A href='?src=\ref[caller];priv_msg=\ref[M]'>PM</A>\]\[<A href='?src=\ref[caller];traitor=\ref[M]'>TP</A>\]</td>"
		else
			dat += "<td><i>Mob not found/([player.key])!</i></td>"
		dat += "</tr>"
	dat += "</table>"

	dat += get_additional_check_antag_output(caller)
	dat += "<hr>"
	return dat

//Overridden elsewhere.
/datum/antagonist/proc/get_additional_check_antag_output(datum/admins/caller)
	return ""
