
/datum/game_mode/slayer
	name = "Free For All Slayer"
	round_description = "Fight to the death with everyone you come across."
	extended_round_description = "No-one has scored a point yet."
	config_tag = "FFA Slayer"
	votable = 1
	probability = 0
	var/list/mode_teams = list("Spartan Slayer")		//jobs are used to represent "teams"
	var/list/team_scores_unsorted = list()
	var/round_end_time = 0
	var/round_length = 6000
	disabled_jobs = list(/datum/job/team_slayer_red, /datum/job/team_slayer_blue)

/datum/game_mode/slayer/pre_setup()
	..()
	round_end_time = world.time + round_length
	to_world("<h1>Round duration: [round_length/600] minutes. Get the highest score by the end.</h1>")
	GLOB.using_map.allowed_jobs -= disabled_jobs

/datum/game_mode/slayer/check_finished()
	if(world.time > round_end_time)
		return 1
	return 0

/datum/game_mode/slayer/declare_completion()
	var/out_message = "<h1>The round is over! The scores were:</h1>"
	out_message += get_formatted_scores()
	to_world(out_message)

/datum/game_mode/slayer/proc/get_formatted_scores()
	var/return_message = ""
	for(var/team_name in team_scores_unsorted)
		return_message += "[team_name]: [team_scores_unsorted[team_name]]</br>"

	return return_message

/datum/game_mode/slayer/proc/get_team_name(var/datum/mob_lite/team_member)
	return team_member.name

//this is a bit hacky (it uses admin attack logging) but the alternative is writing a new system to do exactly the same thing
/datum/game_mode/slayer/handle_mob_death(var/mob/victim, var/list/args = list())
	var/datum/mob_lite/killer = victim.last_attacker_
	if(killer && killer.assigned_role in mode_teams && killer.name != victim.name)
		var/team_name = get_team_name(killer)
		if(!team_scores_unsorted[team_name])
			team_scores_unsorted[team_name] = 0
		team_scores_unsorted[team_name] += 1
		to_world("<h1>[victim.real_name] has been killed by [killer.name]: [team_name] ([team_scores_unsorted[team_name]] kills)</h1>")
