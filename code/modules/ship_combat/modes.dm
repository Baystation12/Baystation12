/datum/game_mode/ship_battles
	name = "Standard Ship Battles"
	round_description = "Enemy ships have been spotted! All crew to battle stations!"
	extended_round_description = ""
	config_tag = null
	votable = 0
	probability = 0

	required_players = 2                 // Minimum players for round to start if voted in.

	shuttle_delay = 1                    // Shuttle transit time is multiplied by this.
	auto_recall_shuttle = 1              // Will the shuttle automatically be recalled?

	event_delay_mod_moderate = 100             // Modifies the timing of random events.
	event_delay_mod_major = 100               // As above.

	allowed_factions = list()
	var/list/teams = list()
	var/team_count

	proc/generate_statistics()
		var/client/first_death
		var/client/most_karma
		var/client/most_missiles_fired
		var/client/most_repairs
		for(var/mob/M in world)
			if(!M.client) continue
			var/client/C = M.client
			if(C.karma > 0)
				if(!most_karma || C.karma > most_karma.karma)
					most_karma = C
			if(C.missiles_fired > 0)
				if(!most_missiles_fired || C.missiles_fired > most_missiles_fired.missiles_fired)
					most_missiles_fired = C
			if(C.repairs_made > 0)
				if(!most_repairs || C.repairs_made > most_repairs.repairs_made)
					most_repairs = C
			if(C.timeofdeath)
				if(!first_death || C.timeofdeath < first_death.timeofdeath)
					first_death = C
		if(first_death)
			world <<"<b>[first_death]</b> was the first brave soldier lost, etching their memory into the world with their last words of, \
			          \"[first_death.last_words ? "[first_death.last_words]" : "[pick("Man am I hungry", "Oh my god!", "Does anyone smell that?", "I can't wait to return home.")]"]\""
		if(most_karma)
			world << "<b>[most_karma]</b> had the most karma, with [most_karma.karma]"
		if(most_missiles_fired)
			world << "<b>[most_missiles_fired]</b> was like a [pick("machine gun", "rabid chipmunk", "machine", "crazed walrus")], firing a total of [most_missiles_fired.missiles_fired] missiles!"
		if(most_repairs)
			world << "<b>[most_repairs]</b> was the handiest sailor, making a total of [most_repairs.repairs_made] repairs!"

	check_finished()
		var/list/active_starts = list()
		for(var/obj/missile_start/S in world)
			if(S.active)
				active_starts += S
		if(active_starts.len <= 1)
			return 1
		return 0

	declare_completion()
		spawn(10)
			world << sound('sound/music/cheeki.ogg')
			var/team = 0
			for(var/obj/missile_start/S in world)
				team = S.team
			world << "<span class='notice'><b>Team [team] is victorious! All heil the new masters of the galaxy!</b></span>"
			spawn(20)
				var/text = "<b>And it's crew, </b>"
				for(var/mob/living/carbon/M in world)
					if(M.mind && M.mind.team == team)
						text += "<b>[M.name]</b>[M.mind.role_alt_title ? ", \the [M.mind.role_alt_title], " : ", "]"
				text += "aswell as all those who died in the field of battle!"
				world << text
			spawn(50)
				world << "<b>The statistics for the round were:</b>"
				generate_statistics()
		return 1

	send_intercept()
		world << sound('sound/effects/siren.ogg')
		return 1

	force_setup()
		allowed_factions.Cut()
		do
			var/faction_to_add = pick("Team One", "Team Two", "Team Three", "Team Four")
			if(faction_to_add in allowed_factions) continue
			allowed_factions.Add(faction_to_add)
		while(allowed_factions.len < team_count)
		for(var/I in allowed_factions)
			switch(I)
				if("Team One")
					teams.Add("1")
				if("Team Two")
					teams.Add("2")
				if("Team Three")
					teams.Add("3")
				if("Team Four")
					teams.Add("4")
		var/list/protected_cores = list()
		for(var/i=1,i<=teams.len,i++)
			var/list/team_cores = list()
			for(var/obj/machinery/space_battle/ship_core/core in world)
				if(core.team && core.team == text2num(teams[i]))
					team_cores.Add(core)

			var/obj/machinery/space_battle/ship_core/chosen = pick(team_cores)
			message_admins("Team [(teams[i])] has [team_cores.len] cores. [chosen && istype(chosen) ? "Successfully picked" : "Not picked"]")
			if(chosen) protected_cores.Add(chosen)
		for(var/obj/machinery/space_battle/ship_core/not_chosen in world)
			if(not_chosen in protected_cores) continue
			qdel(not_chosen)

	post_setup()
		..()

/datum/game_mode/ship_battles/two
	name = "two team combat"
	round_description = "An enemy ship been spotted! All crew to battle stations!"
	extended_round_description = ""
	config_tag = "two team combat"
	votable = 1
	probability = 33

	required_players = 1
	team_count = 2


/datum/game_mode/ship_battles/three
	name = "three team combat"
	round_description = "Two enemy ships have been spotted! All crew to battle stations!"
	extended_round_description = ""
	config_tag = "three team combat"
	votable = 1
	probability = 33

	required_players = 3
	team_count = 3

/datum/game_mode/ship_battles/four
	name = "four team combat"
	round_description = "Three enemy ships have been spotted! All crew to battle stations!"
	extended_round_description = ""
	config_tag = null
	votable = 1
	probability = 34
	config_tag = "four team combat"

	required_players = 4
	team_count = 4

/datum/game_mode/ship_battles/boss
	name = "Boss Ship Combat"
	round_description = "A very large craft has been spotted! All crew to battle stations!"
	extended_round_description = ""
	config_tag = null
	votable = 0
	probability = 0
	config_tag = "Boss Ship Combat"

	required_players = 2
	team_count = 1

	force_setup()
		allowed_factions.Cut()
		do
			var/faction_to_add = pick("Team One", "Team Two", "Team Three")
			if(faction_to_add in allowed_factions) continue
			allowed_factions.Add(faction_to_add)
		while(allowed_factions.len < team_count)
		for(var/I in allowed_factions)
			switch(I)
				if("Team One")
					teams.Add("1")
				if("Team Two")
					teams.Add("2")
				if("Team Three")
					teams.Add("3")
		var/list/protected_cores = list()
		allowed_factions.Add("Team Four")
		teams.Add("5")
		for(var/i=1,i<=teams.len,i++)
			var/list/team_cores = list()
			for(var/obj/machinery/space_battle/ship_core/core in world)
				if(core.team && core.team == text2num(teams[i]))
					team_cores.Add(core)

			var/obj/machinery/space_battle/ship_core/chosen = pick(team_cores)
			message_admins("Team [(teams[i])] has [team_cores.len] cores. [chosen && istype(chosen) ? "Successfully picked" : "Not picked"]")
			if(chosen) protected_cores.Add(chosen)
		for(var/obj/machinery/space_battle/ship_core/not_chosen in world)
			if(not_chosen in protected_cores) continue
			qdel(not_chosen)


	post_setup()
		..()

