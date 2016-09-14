//Inverse defs.
#define SPACE_MEDIC 0
#define SPACE_RESEARCH 1
#define SPACE_FIRE_CONTROL 2
#define SPACE_MAINTENANCE 3
#define SPACE_SECURITY 4
#define SPACE_ENGINEERING 5
#define SPACE_NAVIGATION 6
#define SPACE_COMMAND 7
#define SPACE_TUBES 8
#define SPACE_COMMON 9

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


