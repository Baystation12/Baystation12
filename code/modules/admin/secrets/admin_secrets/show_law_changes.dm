/datum/admin_secret_item/admin_secret/show_law_changes
	name = "Show law changes"

/datum/admin_secret_item/admin_secret/show_law_changes/name()
	return "Show Last [length(GLOB.lawchanges)] Law change\s"

/datum/admin_secret_item/admin_secret/show_law_changes/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = "<B>Showing last [length(GLOB.lawchanges)] law changes.</B><HR>"
	for(var/sig in GLOB.lawchanges)
		dat += "[sig]<BR>"
	show_browser(user, dat, "window=lawchanges;size=800x500")
