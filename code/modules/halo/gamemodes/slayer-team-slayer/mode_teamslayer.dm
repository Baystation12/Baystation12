
/datum/game_mode/slayer/team
	name = "Team Slayer"
	round_description = "Fight to the death alongside your team."
	config_tag = "Team Slayer"
	mode_teams = list("Red Team Spartan","Blue Team Spartan")
	disabled_jobs = list(/datum/job/slayer_ffa)

/datum/game_mode/slayer/team/get_team_name(var/datum/mob_lite/team_member)
	return team_member.assigned_role
