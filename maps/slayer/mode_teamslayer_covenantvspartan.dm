
/datum/game_mode/slayer
	name = "Covenant v Spartans - Team Slayer"
	round_description = "Eliminate the enemy team."
	extended_round_description = ""
	config_tag = "Team Slayer - Covenant"
	votable = 1
	probability = 0
	mode_teams = list("Spartans","Elites")	//jobs are used to represent "teams"
	species_included = list("Spartan" = list("Spartans"),"Sangheili" = list("Elites")) //This has to be an exact name taken from the datum

	disabled_jobs = list(/datum/job/team_slayer_red, /datum/job/team_slayer_blue,/datum/job/slayer_ffa)
