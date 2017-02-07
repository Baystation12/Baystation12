var/datum/controller/vote/vote = new()

datum/controller/vote
	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	var/list/choices = list()
	var/list/gamemode_names = list()
	var/list/voted = list()
	var/list/voting = list()
	var/list/current_high_votes = list()
	var/list/current_med_votes = list()
	var/list/current_low_votes = list()
	var/list/additional_text = list()
	var/auto_muted = 0
	var/auto_add_antag = 0

	New()
		if(vote != src)
			if(istype(vote))
				del(vote)
			vote = src

	proc/process()	//called by master_controller
		if(mode)
			// No more change mode votes after the game has started.
			// 3 is GAME_STATE_PLAYING, but that #define is undefined for some reason
			if(mode == "gamemode" && ticker.current_state >= GAME_STATE_SETTING_UP)
				to_world("<b>Voting aborted due to game start.</b>")

				src.reset()
				return

			// Calculate how much time is remaining by comparing current time, to time of vote start,
			// plus vote duration
			time_remaining = round((started_time + config.vote_period - world.time)/10)

			if(time_remaining < 0)
				result()
				for(var/client/C in voting)
					if(C)
						C << browse(null,"window=vote")
				reset()
			else
				for(var/client/C in voting)
					if(C)
						C << browse(vote.interface(C),"window=vote")

				voting.Cut()

	proc/autotransfer()
		initiate_vote("crew_transfer","the server", 1)
		log_debug("The server has called a crew transfer vote")

	proc/autogamemode()
		initiate_vote("gamemode","the server", 1)
		log_debug("The server has called a gamemode vote")

	proc/automap()
		initiate_vote("map","the server", 1)
		log_debug("The server has called a map vote")

	proc/autoaddantag()
		auto_add_antag = 1
		initiate_vote("add_antagonist","the server", 1)
		log_debug("The server has called an add antag vote.")

	proc/reset()
		initiator = null
		time_remaining = 0
		mode = null
		question = null
		choices.Cut()
		voted.Cut()
		voting.Cut()
		current_high_votes.Cut()
		current_med_votes.Cut()
		current_low_votes.Cut()
		additional_text.Cut()

	proc/get_result()
		//get the highest number of votes
		var/greatest_votes = 0
		var/second_greatest_votes = 0
		var/third_greatest_votes = 0
		var/total_votes = 0

		//default-vote for everyone who didn't vote
		if(!config.vote_no_default && choices.len)
			var/non_voters = (clients.len - total_votes)
			if(non_voters > 0)
				if(mode == "restart")
					choices["Continue Playing"] += non_voters
				else if(mode == "gamemode")
					if(master_mode in choices)
						choices[master_mode] += non_voters
				else if(mode == "crew_transfer")
					var/factor = 0.5
					switch(world.time / (10 * 60)) // minutes
						if(0 to 60)
							factor = 0.5
						if(61 to 120)
							factor = 0.8
						if(121 to 240)
							factor = 1
						if(241 to 300)
							factor = 1.2
						else
							factor = 1.4
					choices["Initiate Crew Transfer"] = round(choices["Initiate Crew Transfer"] * factor)
					to_world("<font color='purple'>Crew Transfer Factor: [factor]</font>")


		for(var/option in choices)
			var/votes = choices[option]
			total_votes += votes
			if(votes > greatest_votes)
				third_greatest_votes = second_greatest_votes
				second_greatest_votes = greatest_votes
				greatest_votes = votes
			else if(votes > second_greatest_votes)
				third_greatest_votes = second_greatest_votes
				second_greatest_votes = votes
			else if(votes > third_greatest_votes)
				third_greatest_votes = votes

		//get all options with that many votes and return them in a list
		var/first = list()
		var/second = list()
		var/third = list()
		for(var/option in choices)
			if(choices[option] == greatest_votes && greatest_votes)
				first += option
			else if(choices[option] == second_greatest_votes && second_greatest_votes)
				second += option
			else if(choices[option] == third_greatest_votes && third_greatest_votes)
				third += option
		return list(first, second, third)

	proc/announce_result()
		var/list/winners = get_result()
		var/text
		var/firstChoice
		var/secondChoice
		var/thirdChoice
		if(length(winners[1]) > 0)
			if(length(winners[1]) > 1)
				if(mode != "gamemode" || ticker.hide_mode == 0) // Here we are making sure we don't announce potential game modes
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

			if(mode != "gamemode" || (firstChoice == "Extended" || ticker.hide_mode == 0)) // Announce unhidden gamemodes or other results, but not other gamemodes
				text += "<b>Vote Result: [firstChoice]</b>"
				if(secondChoice)
					text += "\nSecond place: [secondChoice]"
				if(thirdChoice)
					text += ", third place: [thirdChoice]"
			else
				text += "<b>The vote has ended.</b>" // What will be shown if it is a gamemode vote that was hidden

		else
			text += "<b>Vote Result: Inconclusive - No Votes!</b>"
			if(mode == "add_antagonist")
				antag_add_finished = 1
		log_vote(text)
		to_world("<font color='purple'>[text]</font>")

		return list(firstChoice, secondChoice, thirdChoice)

	proc/result()
		. = announce_result()
		var/restart = 0
		if(.)
			switch(mode)
				if("restart")
					if(.[1] == "Restart Round")
						restart = 1
				if("gamemode")
					if(master_mode != .[1])
						world.save_mode(.[1])
						if(ticker && ticker.mode)
							restart = 1
						else
							master_mode = .[1]
					secondary_mode = .[2]
					tertiary_mode = .[3]
				if("crew_transfer")
					if(.[1] == "Initiate Crew Transfer")
						init_shift_change(null, 1)
					else if(.[1] == "Add Antagonist")
						spawn(10)
							autoaddantag()
				if("add_antagonist")
					if(isnull(.[1]) || .[1] == "None")
						antag_add_finished = 1
					else
						choices -= "Random"
						if(!auto_add_antag)
							choices -= "None"
						for(var/i = 1, i <= length(.), i++)
							if(.[i] == "Random")
								.[i] = pick(choices)
								to_world("The random antag in [i]\th place is [.[i]].")

						var/antag_type = antag_names_to_ids[.[1]]
						if(ticker.current_state < GAME_STATE_SETTING_UP)
							additional_antag_types |= antag_type
						else
							spawn(0) // break off so we don't hang the vote process
								var/list/antag_choices = list(all_antag_types[antag_type], all_antag_types[antag_names_to_ids[.[2]]], all_antag_types[antag_names_to_ids[.[3]]])
								if(ticker.attempt_late_antag_spawn(antag_choices))
									antag_add_finished = 1
									if(auto_add_antag)
										auto_add_antag = 0
										// the buffer will already have an hour added to it, so we'll give it one more
										transfer_controller.timerbuffer = transfer_controller.timerbuffer + config.vote_autotransfer_interval
								else
									to_world("<b>No antags were added.</b>")

									if(auto_add_antag)
										auto_add_antag = 0
										spawn(10)
											autotransfer()
				if("map")
					var/datum/map/M = all_maps[.[1]]
					fdel("use_map")
					text2file(M.path, "use_map")

		if(mode == "gamemode") //fire this even if the vote fails.
			if(!round_progressing)
				round_progressing = 1
				to_world("<font color='red'><b>The round will start soon.</b></font>")


		if(restart)
			to_world("World restarting due to vote...")

			feedback_set_details("end_error","restart vote")
			if(blackbox)	blackbox.save_all_data_to_sql()
			sleep(50)
			log_game("Rebooting due to restart vote")
			world.Reboot()

		return .

	proc/submit_vote(var/ckey, var/vote, var/weight)
		if(mode)
			if(config.vote_no_dead && usr.stat == DEAD && !usr.client.holder)
				return 0
			if(vote && vote >= 1 && vote <= choices.len)
				if(current_high_votes[ckey] && (current_high_votes[ckey] == vote || weight == 3))
					choices[choices[current_high_votes[ckey]]] -= 3
					current_high_votes -= ckey
				if(current_med_votes[ckey] && (current_med_votes[ckey] == vote || weight == 2))
					choices[choices[current_med_votes[ckey]]] -= 2
					current_med_votes -= ckey
				if(current_low_votes[ckey] && (current_low_votes[ckey] == vote || weight == 1))
					choices[choices[current_low_votes[ckey]]]--
					current_low_votes -= ckey
				voted += usr.ckey
				switch(weight)
					if(3)
						current_high_votes[ckey] = vote
						choices[choices[vote]] += 3
					if(2)
						current_med_votes[ckey] = vote
						choices[choices[vote]] += 2
					if(1)
						current_low_votes[ckey] = vote
						choices[choices[vote]] += 1
				return vote
		return 0

	proc/initiate_vote(var/vote_type, var/initiator_key, var/automatic = 0)
		if(!mode)
			if(started_time != null && !(check_rights(R_ADMIN) || automatic))
				var/next_allowed_time = (started_time + config.vote_delay)
				if(next_allowed_time > world.time)
					return 0

			reset()
			switch(vote_type)
				if("restart")
					choices.Add("Restart Round","Continue Playing")
				if("gamemode")
					if(ticker.current_state >= GAME_STATE_SETTING_UP)
						return 0
					choices.Add(config.votable_modes)
					for (var/F in choices)
						var/datum/game_mode/M = gamemode_cache[F]
						if(!M)
							continue
						gamemode_names[M.config_tag] = capitalize(M.name) //It's ugly to put this here but it works
						additional_text.Add("<td align = 'center'>[M.required_players]</td>")
					gamemode_names["secret"] = "Secret"
				if("crew_transfer")
					if(check_rights(R_ADMIN|R_MOD, 0))
						question = "End the shift?"
						choices.Add("Initiate Crew Transfer", "Continue The Round")
						if (config.allow_extra_antags && !antag_add_finished)
							choices.Add("Add Antagonist")
					else
						if (get_security_level() == "red" || get_security_level() == "delta")
							to_chat(initiator_key, "The current alert status is too high to call for a crew transfer!")
							return 0
						if(ticker.current_state <= GAME_STATE_SETTING_UP)
							return 0
							to_chat(initiator_key, "The crew transfer button has been disabled!")
						question = "End the shift?"
						choices.Add("Initiate Crew Transfer", "Continue The Round")
						if (config.allow_extra_antags && is_addantag_allowed(1))
							choices.Add("Add Antagonist")
				if("add_antagonist")
					if(!is_addantag_allowed(automatic == 1, automatic == 2))
						if(!automatic)
							to_chat(usr, "The add antagonist vote is unavailable at this time. The game may not have started yet, the game mode may disallow adding antagonists, or you don't have required permissions.")
						return 0

					if(!config.allow_extra_antags)
						return 0
					for(var/antag_type in all_antag_types)
						var/datum/antagonist/antag = all_antag_types[antag_type]
						if(!(antag.id in additional_antag_types) && antag.is_votable())
							choices.Add(antag.role_text)
					choices.Add("Random")
					if(!auto_add_antag)
						choices.Add("None")
				if("map")
					if(!config.allow_map_switching)
						return 0
					for(var/name in all_maps)
						choices.Add(name)
				if("custom")
					question = sanitizeSafe(input(usr,"What is the vote for?") as text|null)
					if(!question)	return 0
					for(var/i=1,i<=10,i++)
						var/option = capitalize(sanitize(input(usr,"Please enter an option or hit cancel to finish") as text|null))
						if(!option || mode || !usr.client)	break
						choices.Add(option)
				else
					return 0
			mode = vote_type
			initiator = initiator_key
			started_time = world.time
			var/text = "[capitalize(mode)] vote started by [initiator]."
			if(mode == "custom")
				text += "\n[question]"

			log_vote(text)
			to_world("<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=\ref[src]'>here</a> to place your votes.\nYou have [config.vote_period/10] seconds to vote.</font>")

			to_world(sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = 3))

			if(mode == "gamemode" && round_progressing)
				round_progressing = 0
				to_world("<font color='red'><b>Round start has been delayed.</b></font>")


			time_remaining = round(config.vote_period/10)
			return 1
		return 0

	proc/interface(var/client/C)
		if(!C)	return
		var/admin = 0
		var/trialmin = 0
		if(C.holder)
			if(C.holder.rights & R_ADMIN)
				admin = 1
				trialmin = 1 // don't know why we use both of these it's really weird, but I'm 2 lasy to refactor this all to use just admin.
		voting |= C

		. = "<html><head><title>Voting Panel</title></head><body>"
		if(mode)
			if(question)	. += "<h2>Vote: '[question]'</h2>"
			else			. += "<h2>Vote: [capitalize(mode)]</h2>"
			. += "Time Left: [time_remaining] s<hr>"
			. += "<table width = '100%'><tr><td align = 'center'><b>Choices</b></td><td colspan='3' align = 'center'><b>Vote</b></td><td align = 'center'><b>Votes</b></td>"
			if(capitalize(mode) == "Gamemode") .+= "<td align = 'center'><b>Minimum Players</b></td></tr>"

			var/totalvotes = 0
			for(var/i = 1, i <= choices.len, i++)
				totalvotes += choices[choices[i]]

			for(var/i = 1, i <= choices.len, i++)
				var/votes = choices[choices[i]]
				var/votepercent
				if(totalvotes)
					votepercent = round((votes/totalvotes)*100)
				else
					votepercent = 0
				if(!votes)	votes = 0
				. += "<tr><td>"
				if(mode == "gamemode")
					. += "[gamemode_names[choices[i]]]"
				else
					. += "[choices[i]]"
				. += "</td><td>"
				if(current_high_votes[C.ckey] == i)
					. += "<b><a href='?src=\ref[src];high_vote=[i]'>First</a></b>"
				else
					. += "<a href='?src=\ref[src];high_vote=[i]'>First</a>"
				. += "</td><td>"
				if(current_med_votes[C.ckey] == i)
					. += "<b><a href='?src=\ref[src];med_vote=[i]'>Second</a></b>"
				else
					. += "<a href='?src=\ref[src];med_vote=[i]'>Second</a>"
				. += "</td><td>"
				if(current_low_votes[C.ckey] == i)
					. += "<b><a href='?src=\ref[src];low_vote=[i]'>Third</a></b>"
				else
					. += "<a href='?src=\ref[src];low_vote=[i]'>Third</a>"
				. += "</td><td align = 'center'>[votepercent]%</td>"
				if (additional_text.len >= i)
					. += additional_text[i]
				. += "</tr>"

			. += "</table><hr>"
			if(admin)
				. += "(<a href='?src=\ref[src];vote=cancel'>Cancel Vote</a>) "
		else
			. += "<h2>Start a vote:</h2><hr><ul><li>"
			//restart
			if(trialmin || config.allow_vote_restart)
				. += "<a href='?src=\ref[src];vote=restart'>Restart</a>"
			else
				. += "<font color='grey'>Restart (Disallowed)</font>"
			. += "</li><li>"
			if(trialmin || config.allow_vote_restart)
				. += "<a href='?src=\ref[src];vote=crew_transfer'>Crew Transfer</a>"
			else
				. += "<font color='grey'>Crew Transfer (Disallowed)</font>"
			if(trialmin)
				. += "\t(<a href='?src=\ref[src];vote=toggle_restart'>[config.allow_vote_restart?"Allowed":"Disallowed"]</a>)"
			. += "</li><li>"
			//gamemode
			if(trialmin || config.allow_vote_mode)
				. += "<a href='?src=\ref[src];vote=gamemode'>GameMode</a>"
			else
				. += "<font color='grey'>GameMode (Disallowed)</font>"
			if(trialmin)
				. += "\t(<a href='?src=\ref[src];vote=toggle_gamemode'>[config.allow_vote_mode?"Allowed":"Disallowed"]</a>)"
			. += "</li><li>"
			//map!
			if(trialmin && config.allow_map_switching)
				. += "<a href='?src=\ref[src];vote=map'>Map</a>"
			else
				. += "<font color='grey'>Map (Disallowed)</font>"
			. += "</li><li>"
			//extra antagonists
			if(config.allow_extra_antags && is_addantag_allowed(0))
				. += "<a href='?src=\ref[src];vote=add_antagonist'>Add Antagonist Type</a>"
			else
				. += "<font color='grey'>Add Antagonist (Disallowed)</font>"
			. += "</li>"
			//custom
			if(trialmin)
				. += "<li><a href='?src=\ref[src];vote=custom'>Custom</a></li>"
			. += "</ul><hr>"
		. += "<a href='?src=\ref[src];vote=close' style='position:absolute;right:50px'>Close</a></body></html>"
		return .


	Topic(href,href_list[],hsrc)
		if(!usr || !usr.client)	return	//not necessary but meh...just in-case somebody does something stupid
		if(href_list["vote"])
			switch(href_list["vote"])
				if("close")
					voting -= usr.client
					usr << browse(null, "window=vote")
					return
				if("cancel")
					if(usr.client.holder)
						reset()
				if("toggle_restart")
					if(usr.client.holder)
						config.allow_vote_restart = !config.allow_vote_restart
				if("toggle_gamemode")
					if(usr.client.holder)
						config.allow_vote_mode = !config.allow_vote_mode
				if("restart")
					if(config.allow_vote_restart || usr.client.holder)
						initiate_vote("restart",usr.key)
				if("gamemode")
					if(config.allow_vote_mode || usr.client.holder)
						initiate_vote("gamemode",usr.key)
				if("crew_transfer")
					if(config.allow_vote_restart || usr.client.holder)
						initiate_vote("crew_transfer",usr.key)
				if("add_antagonist")
					if(config.allow_extra_antags)
						initiate_vote("add_antagonist",usr.key)
				if("map")
					if(config.allow_map_switching && usr.client.holder)
						initiate_vote("map", usr.key)
				if("custom")
					if(usr.client.holder)
						initiate_vote("custom",usr.key)
		else
			var/weight = 1
			var/t
			if(href_list["high_vote"])
				t = round(text2num(href_list["high_vote"]))
				weight = 3
			else if(href_list["med_vote"])
				t = round(text2num(href_list["med_vote"]))
				weight = 2
			else if(href_list["low_vote"])
				t = round(text2num(href_list["low_vote"]))
			if(t) // it starts from 1, so there's no problem
				submit_vote(usr.ckey, t, weight)
		usr.vote()

// Helper proc for determining whether addantag vote can be called.
datum/controller/vote/proc/is_addantag_allowed(var/automatic = 0, var/event = 0)
	// Gamemode has to be determined before we can add antagonists, so we can respect gamemode's add antag vote settings.
	if((ticker.current_state <= 2) || !ticker.mode)
		return 0
	if(event)
		return (ticker.mode.addantag_allowed & ADDANTAG_EVENT) && !antag_add_finished
	if(automatic)
		return (ticker.mode.addantag_allowed & ADDANTAG_AUTO) && !antag_add_finished
	if(check_rights(R_ADMIN, 0))
		return ticker.mode.addantag_allowed & (ADDANTAG_ADMIN|ADDANTAG_PLAYER)
	else
		return (ticker.mode.addantag_allowed & ADDANTAG_PLAYER) && !antag_add_finished



/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	if(vote)
		src << browse(vote.interface(client),"window=vote")
