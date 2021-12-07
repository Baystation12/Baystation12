
/datum/vote/proc/announce_result()
	var/list/winners = calculate_result()
	var/text
	var/firstChoice
	var/secondChoice
	var/thirdChoice
	if(length(winners[1]) > 0)
		if(length(winners[1]) > 1)
			//if(mode != "gamemode" || ticker.hide_mode == 0) // Here we are making sure we don't announce potential game modes
			text = "<b>Vote Tied Between:</b>\n"
			for(var/option in winners[1])
				text += "\t[option]\n"
		firstChoice = pick(winners[1])
		winners[1] -= firstChoice

		var/i = 1
		while(isnull(secondChoice))
			if(length(winners[i]) > 0)
				secondChoice = pick(winners[i])
				winners[i] -= secondChoice
			else if(i == 3)
				break
			else
				i++
		while(isnull(thirdChoice))
			if(length(winners[i]) > 0)
				thirdChoice = pick(winners[i])
				winners[i] -= thirdChoice
			else if(i == 3)
				break
			else
				i++

		//if(mode != "gamemode" || (firstChoice == "Extended" || ticker.hide_mode == 0)) // Announce unhidden gamemodes or other results, but not other gamemodes
		text += "<b>Vote Result: [firstChoice]</b>"
		if(secondChoice)
			text += "\nSecond place: [secondChoice]"
		if(thirdChoice)
			text += ", third place: [thirdChoice]"
		//else
			//text += "<b>The vote has ended.</b>" // What will be shown if it is a gamemode vote that was hidden

	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
		if (status_quo)
			firstChoice = status_quo
	log_vote(text)
	to_world("<font color='purple'>[text]</font>")

	return list(firstChoice, secondChoice, thirdChoice)
