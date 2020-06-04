
/client/proc/npc_difficulty()
	set category = "Fun"
	set name = "Change Difficulty Level"
	if(!check_rights(R_FUN))
		return

	var/list/options = list("Easy","Normal","Heroic","Legendary")
	var/difficulty_string = input("Choose new server difficulty level (applies to simple mobs only)",\
		"Server difficulty level: [options[GLOB.difficulty_level]]")\
		as null|anything in options

	var/newdiff = options.Find(difficulty_string)
	if(newdiff)
		minor_announcement.Announce("Difficulty level: [difficulty_string]")
		GLOB.difficulty_level = newdiff
		message_admins("[key_name_admin(src)] has set server difficulty: [difficulty_string] ([GLOB.difficulty_level])")
