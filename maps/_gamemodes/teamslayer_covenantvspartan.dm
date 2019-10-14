
/datum/game_mode/slayer/elites_spartans
	name = "Covenant v Spartans - Team Slayer"
	round_description = "Eliminate the enemy team."
	config_tag = "Team Slayer - Covenant"
	mode_teams = list("Team Elites","Team Spartans")	//jobs are used to represent "teams"
	species_included = list("Spartan" = list("Spartans"),"Sangheili" = list("Elites")) //This has to be an exact name taken from the datum
	disabled_jobs = list(/datum/job/team_slayer_red, /datum/job/team_slayer_blue,/datum/job/slayer_ffa)
