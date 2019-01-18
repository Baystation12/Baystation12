
/datum/vote/proc/interface(var/client/C)
	if(!C)	return
	var/admin = 0
	if(C.holder)
		if(C.holder.rights & R_ADMIN)
			admin = 1
	voting |= C

	. += "<a href='?src=\ref[vote];vote_controller=1'>(return to main panel)</a>"

	. = "<html><head><title>[capitalize(name)] Voting Panel</title></head><body>"
	if(question)
		. += "<h2>[question]</h2>"
	else
		. += "<h2>Vote: '[name]'</h2>"

	. += "Time Left: [time_remaining/10] s[delayed ? " (delayed)" : ""]<hr>"

	. += "<table width = '100%'>"
	. += "<tr>"
	. += "<td align = 'center'><b>Choices</b></td>"
	. += "<td colspan='3' align = 'center'><b>Vote</b></td>"
	. += "<td align = 'center'><b>Votes</b></td>"
	//if(capitalize(mode) == "Gamemode") .+= "<td align = 'center'><b>Minimum Players</b></td></tr>"
	if(additional_text_title)
		. += "<td align = 'center'><b>[additional_text_title]</b></td>"

	. += "</tr>"

	var/totalvotes = 0
	for(var/votename in choices)
		totalvotes += choices[votename]

	for(var/i=1, i<=choices.len, i++)
		var/votename = choices[i]
		var/votes = choices[votename]
		var/votepercent
		if(totalvotes)
			votepercent = round((votes/totalvotes)*100)
		else
			votepercent = 0

		. += "<tr><td>"
		. += votename
		. += "</td><td>"

		var/list/curvotes = choices_weights[votename]

		if(curvotes.Find(C.ckey) && curvotes[C.ckey] == 3)
			. += "<b><a href='?src=\ref[src];weight=3;cast_vote=[votename]'>First</a></b>"
		else
			. += "<a href='?src=\ref[src];weight=3;cast_vote=[votename]'>First</a>"
		. += "</td><td>"
		if(curvotes.Find(C.ckey) && curvotes[C.ckey] == 2)
			. += "<b><a href='?src=\ref[src];weight=2;cast_vote=[votename]'>Second</a></b>"
		else
			. += "<a href='?src=\ref[src];weight=2;cast_vote=[votename]'>Second</a>"
		. += "</td><td>"
		if(curvotes.Find(C.ckey) && curvotes[C.ckey] == 1)
			. += "<b><a href='?src=\ref[src];weight=1;cast_vote=[votename]'>Third</a></b>"
		else
			. += "<a href='?src=\ref[src];weight=1;cast_vote=[votename]'>Third</a>"

		. += "</td><td align = 'center'>[votepercent]% ([votes])</td>"

		if(additional_text_title)
			. += additional_text[i]

		. += "</tr>"

	. += "</table><hr>"

	if(admin)
		. += "(<a href='?src=\ref[src];cancel_vote=1'>Cancel Vote</a>) "
		. += "(<a href='?src=\ref[src];end_early=1'>End Vote Early</a>) "
		. += "(<a href='?src=\ref[src];extend_vote=1'>Extend Vote</a>) "
		. += "(<a href='?src=\ref[src];delay_vote=1'>Delay Vote</a>) "

	. += "<a href='?src=\ref[src];client=\ref[C];close=1'>(Close)</a>"

/datum/vote/proc/update_clients_browsing()
	if(active)
		for(var/client/C in voting)
			show_browser(C, interface(C), "window=vote")
	else
		for(var/client/C in voting)
			show_browser(C, null, "window=vote")
		voting.Cut()
