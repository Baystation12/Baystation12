
/var/list/chemical_reaction_logs = list()

/proc/log_chemical_reaction(atom/A, datum/chemical_reaction/R, multiplier)
	if(!A || !R)
		return

	var/turf/T = get_turf(A)
	var/logstr = "[usr ? key_name(usr) : "EVENT"] mixed [R.name] ([R.result]) (x[multiplier]) in \the [A] at [T ? "[T.x],[T.y],[T.z]" : "*null*"]"

	chemical_reaction_logs += "\[[time_stamp()]\] [logstr]"

	if(R.log_is_important)
		message_admins(logstr)
	log_admin(logstr)

/client/proc/view_chemical_reaction_logs()
	set name = "Show Chemical Reactions"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return

	var/html = ""
	for(var/entry in chemical_reaction_logs)
		html += "[entry]<br>"

	show_browser(usr, html, "window=chemlogs")
