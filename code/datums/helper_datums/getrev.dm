var/global/datum/getrev/revdata = new()

/datum/getrev
	var/revision
	var/date
	var/showinfo

/datum/getrev/New()
	var/list/head_log = file2list(".git/logs/HEAD", "\n")
	for(var/line=head_log.len, line>=1, line--)
		if(head_log[line])
			var/list/last_entry = text2list(head_log[line], " ")
			if(last_entry.len < 2)	continue
			revision = last_entry[2]
			// Get date/time
			if(last_entry.len >= 5)
				var/unix_time = text2num(last_entry[5])
				if(unix_time)
					date = unix2date(unix_time)
			break
	world.log << "Running revision:"
	world.log << date
	world.log << revision
	return

client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	if(revdata.revision)
		src << "<b>Server revision:</b> [revdata.date]"
		if(config.githuburl)
			src << "<a href='[config.githuburl]/commit/[revdata.revision]'>[revdata.revision]</a>"
		else
			src << revdata.revision
	else
		src << "Revision unknown"
	return
