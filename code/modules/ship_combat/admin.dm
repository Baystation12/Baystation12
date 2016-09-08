/datum/admins/proc/force_team()
	set category = "Server"
	set name = "Force Team"
	set desc="Forces a team into play."
	if (!usr.client.holder)
		return
	if(ticker)
		var/inp = input(usr, "What team?") in list("Team One", "Team Two", "Team Three", "Team Four")
		ticker.forced_teams.Add(inp)
		message_admins("[key_name_admin(usr)] forced [inp] into play.", 1)


