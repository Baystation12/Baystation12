
/*
See code/procs/announce.dm
*/

/datum/faction
	var/datum/announcement/priority/announce_command
	var/datum/announcement/announce_update

/datum/faction/proc/AnnounceCommand(var/announce_text, var/announce_source, var/new_sound)
	if(!announce_command)
		var/error_msg = "FACTION ERROR: uninitialised AnnounceCommand() \'[announce_text]\' faction \'[src.name]\' \
		announce_text \'[announce_text]\' announce_source \'[announce_source]\'"
		log_and_message_admins(error_msg)
		return

	//set some temporary values
	announce_command.announcer = announce_source
	if(new_sound)
		announce_command.sound = new_sound

	//make the announcement
	announce_command.Announce(announce_text)

	//reset these values
	announce_command.announcer = null
	announce_command.sound = initial(announce_update.sound)

/datum/faction/proc/AnnounceUpdate(var/announce_text, var/announce_source, var/new_sound)
	if(!announce_update)
		var/error_msg = "FACTION ERROR: uninitialised AnnounceUpdate() \'[announce_text]\' faction \'[src.name]\' \
		announce_text \'[announce_text]\' announce_source \'[announce_source]\'"
		log_and_message_admins(error_msg)
		return

	//set some temporary values
	announce_update.announcer = announce_source
	if(new_sound)
		announce_update.sound = new_sound

	//make the announcement
	announce_update.Announce(announce_text)

	//reset these values
	announce_update.announcer = null
	announce_update.sound = initial(announce_update.sound)

/datum/faction/proc/setup_announcement()
	announce_command = new()
	announce_command.sound = 'sound/AI/commandreport.ogg'

	announce_update = new()
	announce_update.sound = 'sound/misc/notice2.ogg'

/datum/faction/human_civ/setup_announcement()
	. = ..()

	announce_command.species_restrict = SPECIES_HUMAN
	announce_command.newscast = 1
	announce_command.title = "UEG Priority Announcement"

	announce_update.species_restrict = SPECIES_HUMAN
	announce_update.newscast = 1
	announce_update.title = "UEG Media Update"

/datum/faction/unsc/setup_announcement()
	. = ..()

	announce_command.faction_restrict = "UNSC"
	announce_command.title = "HIGHCOM Priority Transmission"

	announce_update.faction_restrict = "UNSC"
	announce_update.title = "UNSC Update"

/datum/faction/covenant/setup_announcement()
	. = ..()

	announce_command.faction_restrict = "Covenant"
	announce_command.title = "Commandment from the Prophets"

	announce_update.faction_restrict = "Covenant"
	announce_update.title = "Communique from the Ministry"

/datum/faction/insurrection/setup_announcement()
	. = ..()

	announce_command.faction_restrict = "Insurrection"
	announce_command.title = "URF Command Dispatch"

	announce_update.faction_restrict = "Insurrection"
	announce_update.title = "Insurrection Update"

/datum/faction/flood/setup_announcement()
	. = ..()

	announce_command.faction_restrict = "Flood"
	announce_command.title = "Gravemind Command"

	announce_update.faction_restrict = "Flood"
	announce_update.title = "Gravemind Update"



//admin verbs to make custom faction announcements

/client/proc/custom_faction_announcement(var/datum/faction/announce_faction)
	var/is_command = alert("1/3 Should this be a command or update?","Announcement type","Command","Update")
	var/announcer = input("2/3 Enter your announcer's name or leave blank for a generic announcement.",\
		"[announce_faction.name] Player Faction Announcement") as text | null
	var/text = input("3/3 Enter your announcement text or leave blank to cancel.",\
		"Announcement text") as text | null
	if(!text)
		return

	if(is_command == "Command")
		announce_faction.AnnounceCommand(text, announcer)
	else
		announce_faction.AnnounceUpdate(text, announcer)

	message_admins("[key_name_admin(src)] has made a [announce_faction.name] admin announcement")

/client/proc/covenant_announcement()
	set category = "Fun"
	set name = "Announcement (Covenant)"
	if(!check_rights(R_FUN))
		return

	custom_faction_announcement(GLOB.COVENANT)

/client/proc/unsc_announcement()
	set category = "Fun"
	set name = "Announcement (UNSC)"
	if(!check_rights(R_FUN))
		return

	custom_faction_announcement(GLOB.UNSC)

/client/proc/innie_announcement()
	set category = "Fun"
	set name = "Announcement (Insurrection)"
	if(!check_rights(R_FUN))
		return

	custom_faction_announcement(GLOB.INSURRECTION)

/client/proc/human_announcement()
	set category = "Fun"
	set name = "Announcement (All-Human)"
	if(!check_rights(R_FUN))
		return

	custom_faction_announcement(GLOB.HUMAN_CIV)

/client/proc/flood_announcement()
	set category = "Fun"
	set name = "Announcement (Flood)"
	if(!check_rights(R_FUN))
		return

	custom_faction_announcement(GLOB.FLOOD)



// secrets panel entry for player faction announcements

/datum/admin_secret_item/fun_secret/custom_announcement
	name = "Custom Faction Announcement"

/datum/admin_secret_item/fun_secret/custom_announcement/execute(var/mob/user)
	var/list/options = list(\
		"UNSC" = /client/proc/unsc_announcement,\
		"Covenant" = /client/proc/covenant_announcement,\
		"Insurrection" = /client/proc/innie_announcement,\
		"All-Human" = /client/proc/human_announcement,\
		"Flood" = /client/proc/flood_announcement\
		)

	var/choice = input("What faction should recieve the announcement?","Custom Announcement") as null|anything in options
	var/proc_call = options[choice]
	if(proc_call)
		call(user.client, proc_call)()
