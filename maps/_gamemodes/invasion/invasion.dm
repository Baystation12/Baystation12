
#include "objectives.dm"
#include "oni_cryopod.dm"

/datum/game_mode/invasion
	name = "Invasion"
	config_tag = "invasion"
	round_description = "In an outer colony on the edge of human space, an insurrection is brewing. Meanwhile an alien threat lurks in the void."
	extended_round_description = "In an outer colony on the edge of human space, an insurrection is brewing. Meanwhile an alien threat lurks in the void."

	//uncomment this later
	//required_players = 10
	factions = list(/datum/faction/unsc, /datum/faction/insurrection, /datum/faction/covenant)
	var/covenant_ship_area_parent
	var/list/covenant_ship_areas = list()
	var/list/unsc_base_areas = list()
	var/faction_safe_time = 10 MINUTES
	var/faction_safe_duration = 10 MINUTES

	var/obj/effect/overmap/cov_ship
	var/obj/effect/overmap/unsc_ship
	var/obj/effect/overmap/human_colony

	var/list/objectives_specific_target = list()

	var/covenant_ship_slipspaced = 0

/datum/game_mode/invasion/New()
	. = ..()

	//setup factions
	for(var/faction_type in factions)
		if(ispath(faction_type))
			factions -= faction_type
			var/datum/faction/new_faction = new faction_type()
			factions.Add(new_faction)
			factions_by_name[new_faction.name] = new_faction

	//setup covenant objectives
	var/datum/faction/covenant/C = locate() in factions
	if(C)
		var/list/objective_types = list(\
			/datum/objective/protect_cov_ship,\
			/datum/objective/protect/protect_cov_leader,\
			/datum/objective/glass_colony,\
			/datum/objective/steal_ai,\
			/datum/objective/steal_nav_data,\
			/datum/objective/destroy_unsc_ship,\
			/datum/objective/retrieve_artifact)
		setup_faction_objectives(C, objective_types)

	//setup unsc objectives
	var/datum/faction/unsc/U = locate() in factions
	if(U)
		var/list/objective_types = list(\
			/datum/objective/protect_unsc_ship,\
			/datum/objective/retrieve_artifact/unsc,\
			/datum/objective/protect/protect_unsc_leader,\
			/datum/objective/capture_innies,\
			/datum/objective/steal_ai/cole_protocol,\
			/datum/objective/steal_nav_data/cole_protocol,\
			/datum/objective/destroy_cov_ship,\
			/datum/objective/protect_colony)
		setup_faction_objectives(U, objective_types)

	//setup innie objectives
	var/datum/faction/insurrection/I = locate() in factions
	if(I)
		var/list/objective_types = list(\
			/datum/objective/protect/protect_innie_leader,\
			/datum/objective/destroy_unsc_ship/innie,\
			/datum/objective/assassinate/kill_unsc_leader,\
			/datum/objective/recruit_pirates,\
			/datum/objective/recruit_scientists,\
			/datum/objective/protect_colony/innie,\
			/datum/objective/destroy_cov_ship/innie,\
			/datum/objective/takeover_colony)
		setup_faction_objectives(I, objective_types)

/datum/game_mode/invasion/pre_setup()
	. = ..()
	//**** hard code some values which we will locate dynamically later ****//
	unsc_base_areas = list(/area/faction_base/unsc_upperlevel, /area/faction_base/unsc_lowerlevel)
	covenant_ship_area_parent = /area/covenant_corvette
	cov_ship = locate(/obj/effect/overmap/ship/covenant_corvette) in world
	unsc_ship = locate(/obj/effect/overmap/ship/unsc_frigate) in world
	human_colony = locate(/obj/effect/overmap/sector/exo_depot) in world
	//**** finish hard codes. remove these later ****//

	//find the covenant ship for objective purposes
	//note: this will not work here if the cov ship is loaded in by lobby vote, it must be called later
	locate_cov_ship_areas()

	//setup a couple of other objectives
	for(var/datum/objective/objective in objectives_specific_target)
		if(objective.find_target_specific())
			objectives_specific_target -= objective

/datum/game_mode/invasion/handle_latejoin(var/mob/living/carbon/human/character)
	var/list/successful = list()
	for(var/datum/objective/objective in objectives_specific_target)
		if(objective.find_target_specific(character.mind))
			objectives_specific_target -= objective
			successful += objective
	objectives_specific_target -= successful
	return 1

/datum/game_mode/invasion/proc/locate_cov_ship_areas()
	if(covenant_ship_area_parent && !covenant_ship_areas.len)
		for(var/area_type in typesof(covenant_ship_area_parent))
			var/area/cur_area = locate(area_type) in world
			covenant_ship_areas.Add(cur_area)

/datum/game_mode/invasion/proc/setup_faction_objectives(var/datum/faction/faction, var/list/objective_types)
	for(var/objective_type in objective_types)
		var/datum/objective/objective = new objective_type()
		faction.other_objectives.Add(objective)
		faction.all_objectives.Add(objective)
		faction.max_points += objective.get_award_points()
		if(objective.find_specific_target)
			objectives_specific_target.Add(objective)

/datum/game_mode/invasion/post_setup()
	. = ..()
	faction_safe_time = world.time + faction_safe_duration

/datum/game_mode/invasion/check_finished()

	//if 2 of these are true, end the game:
	var/end_conditions = 0

	//the cov ship has been destroyed or gone to slipspace
	if(covenant_ship_slipspaced || !cov_ship)
		end_conditions += 1

	//the UNSC ship has been destroyed
	if(!unsc_ship)
		end_conditions += 1

	//the colony has been destroyed (nuked/glassed)
	if(human_colony && (human_colony.nuked || human_colony.glassed))
		end_conditions += 1

	//all innie players have been killed/captured
	if(world.time > faction_safe_time)
		for(var/datum/faction/F in factions)
			if(!F.players_alive())
				end_conditions += 1

	return end_conditions >= 2

/datum/game_mode/invasion/declare_completion()
	//work out survivors
	var/clients = 0
	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0
	//var/escaped_humans = 0
	//var/escaped_total = 0

	for(var/mob/M in GLOB.player_list)
		if(M.client)
			clients++
			if(M.stat != DEAD)
				surviving_total++
				if(ishuman(M))
					surviving_humans++
				/*var/area/A = get_area(M)
				if(A && is_type_in_list(A, GLOB.using_map.post_round_safe_areas))
					escaped_total++
					if(ishuman(M))
						escaped_humans++*/
			else if(isghost(M))
				ghosts++

	var/text = ""
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]"
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."

	text += "<br><br>"

	//work out faction points
	var/datum/faction/winning_faction
	var/datum/faction/second_faction
	var/all_points = 0
	for(var/datum/faction/faction in factions)
		text += "<h3>[faction.name] Objectives</h3>"
		if(!winning_faction)
			winning_faction = faction
		else if(!second_faction)
			second_faction = faction
		for(var/datum/objective/objective in faction.all_objectives)
			if(objective.check_completion())
				text += "<span class='good'>Completed (+[objective.win_points]): [objective.short_text]</span><br>"
				faction.points += objective.win_points
			else if(objective.lose_points)
				text += "<span class='bad'>Failed (-[objective.lose_points]): [objective.short_text]</span><br>"
				faction.points -= objective.lose_points
			else
				text += "<span class='prefix'>Not Completed: [objective.short_text]</span><br>"

		if(faction.points > 0)
			all_points += faction.points
		if(faction.points >= winning_faction.points)		//<= is necessary to correctly track second place
			second_faction = winning_faction
			winning_faction = faction
		text += "<h4>Total [faction.name] Score: [faction.points] points</h4><br>"

	//these victory tiers will need balancing depending on objectives and points
	if(second_faction.points == winning_faction.points)
		text += "<h2>Tie! [winning_faction.name] and [winning_faction.name] ([winning_faction.points] points)</h2>"
	else if(all_points <= 0)
		text += "<h2>Stalemate! All factions failed in their objectives.</h2>"
	else
		//check if only the winning faction scored, then treat them slightly differently
		if(all_points == winning_faction.points)
			all_points = winning_faction.max_points

		var/win_type = "Pyrrhic"
		if(winning_faction.points/all_points <= 0.34)
			//this should never or rarely happen
			win_type = "Pyrrhic"
		else if(winning_faction.points/all_points < 0.66)
			win_type = "Minor"
		else if(winning_faction.points/all_points < 0.9)
			win_type = "Moderate"
		else if(winning_faction.points/all_points != 1)
			win_type = "Major"
		else
			win_type = "Supreme"

		text += "<h2>[win_type] [winning_faction.name] Victory!</h2>"
	to_world(text)

	if(clients > 0)
		feedback_set("round_end_clients",clients)
	if(ghosts > 0)
		feedback_set("round_end_ghosts",ghosts)
	if(surviving_humans > 0)
		feedback_set("survived_human",surviving_humans)
	if(surviving_total > 0)
		feedback_set("survived_total",surviving_total)
	/*if(escaped_humans > 0)
		feedback_set("escaped_human",escaped_humans)
	if(escaped_total > 0)
		feedback_set("escaped_total",escaped_total)*/

	send2mainirc("A round of [src.name] has ended - [surviving_total] survivor\s, [ghosts] ghost\s.")

	return 0

/datum/game_mode/invasion/handle_mob_death(var/mob/M, var/unsc_capture = 0)
	. = ..()

	if(M.mind.assigned_role in list("Insurrectionist","Insurrectionist Commander") || M.mind.faction == "Insurrectionist")
		var/datum/faction/unsc/unsc = locate() in factions
		if(unsc)
			var/datum/objective/capture_innies/capture_innies = locate() in unsc.all_objectives
			if(capture_innies)
				if(unsc_capture)
					capture_innies.minds_captured.Add(M.mind)
				else
					capture_innies.minds_killed.Add(M.mind)

