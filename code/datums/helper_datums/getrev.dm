var/global/datum/getrev/revdata = new()

/datum/getrev
	var/branch
	var/revision
	var/date
	var/showinfo

/datum/getrev/New()
	var/list/head_branch = file2list(".git/HEAD", "\n")
	if(length(head_branch))
		branch = copytext(head_branch[1], 17)

	// [SIERRA-REMOVE] - RUST_G
	/*
	var/list/head_log = file2list(".git/logs/HEAD", "\n")
	for(var/line=length(head_log), line>=1, line--)
		if(head_log[line])
			var/list/last_entry = splittext(head_log[line], " ")
			if(length(last_entry) < 2)	continue
			revision = last_entry[2]
			// Get date/time
			if(length(last_entry) >= 5)
				var/unix_time = text2num(last_entry[5])
				if(unix_time)
					date = unix2date(unix_time)
			break
	*/
	// [/SIERRA-REMOVE]
	// [SIERRA-ADD] - RUST_G
	revision = rustg_git_revparse("HEAD")
	date = rustg_git_commit_date("HEAD")
	// [/SIERRA-ADD]

	to_world_log("Running revision:")
	to_world_log(branch)
	to_world_log(date)
	to_world_log(revision)

/client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	to_chat(src, "<b>Client Version:</b> [byond_version]")
	if(revdata.revision)
		var/server_revision = revdata.revision
		if(config.source_url)
			server_revision = "<a href='[config.source_url]/commit/[server_revision]'>[server_revision]</a>"
		to_chat(src, "<b>Server Revision:</b> [server_revision] - [revdata.branch] - [revdata.date]")
	else
		to_chat(src, "<b>Server Revision:</b> Revision Unknown")
	to_chat(src, "Game ID: <b>[game_id]</b>")
	to_chat(src, "Current map: [GLOB.using_map.full_name]")
