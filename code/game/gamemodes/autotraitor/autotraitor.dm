//This is a beta game mode to test ways to implement an "infinite" traitor round in which more traitors are automatically added in as needed.
//Automatic traitor adding is complete pending the inevitable bug fixes.  Need to add a respawn system to let dead people respawn after 30 minutes or so.


/datum/game_mode/traitor/autotraitor
	name = "AutoTraitor"
	config_tag = "extend-a-traitormongous"

	var/list/possible_traitors
	var/num_players = 0

/datum/game_mode/traitor/autotraitor/announce()
	..()
	world << "<B>Game mode is AutoTraitor. Traitors will be added to the round automagically as needed.</B>"

/datum/game_mode/traitor/autotraitor/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	possible_traitors = get_players_for_role(BE_TRAITOR)

	for(var/datum/mind/player in possible_traitors)
		for(var/job in restricted_jobs)
			if(player.assigned_role == job)
				possible_traitors -= player


	for(var/mob/new_player/P in world)
		if(P.client && P.ready)
			num_players++

	//var/r = rand(5)
	var/num_traitors = 1
	var/max_traitors = 1
	var/traitor_prob = 0
	max_traitors = round(num_players / 10) + 1
	traitor_prob = (num_players - (max_traitors - 1) * 10) * 10

	// Stop setup if no possible traitors
	if(!possible_traitors.len)
		return 0

	if(config.traitor_scaling)
		num_traitors = max_traitors - 1 + prob(traitor_prob)
		log_game("Number of traitors: [num_traitors]")
		message_admins("Players counted: [num_players]  Number of traitors chosen: [num_traitors]")
	else
		num_traitors = max(1, min(num_players(), traitors_possible))


	for(var/i = 0, i < num_traitors, i++)
		var/datum/mind/traitor = pick(possible_traitors)
		traitors += traitor
		possible_traitors.Remove(traitor)

	for(var/datum/mind/traitor in traitors)
		if(!traitor || !istype(traitor))
			traitors.Remove(traitor)
			continue
		if(istype(traitor))
			traitor.special_role = "traitor"

//	if(!traitors.len)
//		return 0
	return 1




/datum/game_mode/traitor/autotraitor/post_setup()
	..()
	abandon_allowed = 1
	traitorcheckloop()

/datum/game_mode/traitor/autotraitor/proc/traitorcheckloop()
	spawn(9000)
		if(emergency_shuttle.departed)
			return
		//message_admins("Performing AutoTraitor Check")
		var/playercount = 0
		var/traitorcount = 0
		var/possible_traitors[0]
		for(var/mob/living/player in mob_list)

			if (player.client && player.stat != 2)
				playercount += 1
			if (player.client && player.mind && player.mind.special_role && player.stat != 2)
				traitorcount += 1
			if (player.client && player.mind && !player.mind.special_role && player.stat != 2 && (player.client && player.client.prefs.be_special & BE_TRAITOR) && !jobban_isbanned(player, "Syndicate"))
				possible_traitors += player
		for(var/datum/mind/player in possible_traitors)
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					possible_traitors -= player

		//message_admins("Live Players: [playercount]")
		//message_admins("Live Traitors: [traitorcount]")
//		message_admins("Potential Traitors:")
//		for(var/mob/living/traitorlist in possible_traitors)
//			message_admins("[traitorlist.real_name]")

//		var/r = rand(5)
//		var/target_traitors = 1
		var/max_traitors = 1
		var/traitor_prob = 0
		max_traitors = round(playercount / 10) + 1
		traitor_prob = (playercount - (max_traitors - 1) * 10) * 5
		if(traitorcount < max_traitors - 1)
			traitor_prob += 50


		if(traitorcount < max_traitors)
			//message_admins("Number of Traitors is below maximum.  Rolling for new Traitor.")
			//message_admins("The probability of a new traitor is [traitor_prob]%")

			if(prob(traitor_prob))
				message_admins("Making a new Traitor.")
				if(!possible_traitors.len)
					message_admins("No potential traitors.  Cancelling new traitor.")
					traitorcheckloop()
					return
				var/mob/living/newtraitor = pick(possible_traitors)
				//message_admins("[newtraitor.real_name] is the new Traitor.")

				if (!config.objectives_disabled)
					forge_traitor_objectives(newtraitor.mind)

				if(istype(newtraitor, /mob/living/silicon))
					add_law_zero(newtraitor)
				else
					equip_traitor(newtraitor)

				traitors += newtraitor.mind
				newtraitor << "\red <B>ATTENTION:</B> \black It is time to pay your debt to the Syndicate..."
				newtraitor << "<B>You are now a traitor.</B>"
				newtraitor.mind.special_role = "traitor"
				newtraitor.hud_updateflag |= 1 << SPECIALROLE_HUD
				newtraitor << "<i>You have been selected this round as an antagonist!</i>"
				show_objectives(newtraitor.mind)

			//else
				//message_admins("No new traitor being added.")
		//else
			//message_admins("Number of Traitors is at maximum.  Not making a new Traitor.")

		traitorcheckloop()



/datum/game_mode/traitor/autotraitor/latespawn(mob/living/carbon/human/character)
	..()
	if(emergency_shuttle.departed)
		return
	//message_admins("Late Join Check")
	if((character.client && character.client.prefs.be_special & BE_TRAITOR) && !jobban_isbanned(character, "Syndicate"))
		//message_admins("Late Joiner has Be Syndicate")
		//message_admins("Checking number of players")
		var/playercount = 0
		var/traitorcount = 0
		for(var/mob/living/player in mob_list)

			if (player.client && player.stat != 2)
				playercount += 1
			if (player.client && player.mind && player.mind.special_role && player.stat != 2)
				traitorcount += 1
		//message_admins("Live Players: [playercount]")
		//message_admins("Live Traitors: [traitorcount]")

		//var/r = rand(5)
		//var/target_traitors = 1
		var/max_traitors = 2
		var/traitor_prob = 0
		max_traitors = round(playercount / 10) + 1
		traitor_prob = (playercount - (max_traitors - 1) * 10) * 5
		if(traitorcount < max_traitors - 1)
			traitor_prob += 50

		//target_traitors = max(1, min(round((playercount + r) / 10, 1), traitors_possible))
		//message_admins("Target Traitor Count is: [target_traitors]")
		if (traitorcount < max_traitors)
			//message_admins("Number of Traitors is below maximum.  Rolling for New Arrival Traitor.")
			//message_admins("The probability of a new traitor is [traitor_prob]%")
			if(prob(traitor_prob))
				message_admins("New traitor roll passed.  Making a new Traitor.")
				if (!config.objectives_disabled)
					forge_traitor_objectives(character.mind)
				equip_traitor(character)
				traitors += character.mind
				character << "\red <B>You are the traitor.</B>"
				character.mind.special_role = "traitor"
				character << "<i>You have been selected this round as an antagonist</i>!"
				show_objectives(character.mind)

			//else
				//message_admins("New traitor roll failed.  No new traitor.")
	//else
		//message_admins("Late Joiner does not have Be Syndicate")


