/datum/watchlist


/datum/watchlist/proc/Add(target_ckey, browse = 0)
	if (!target_ckey)
		var/new_ckey = ckey(input(usr, "Who would you like to add to the watchlist?", "Enter a ckey", null) as text)
		new_ckey = sanitizeSQL(new_ckey)
		if (!new_ckey)
			return
		
		var/DBQuery/query_watchfind = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ckey = '[new_ckey]'")
		if (!query_watchfind.Execute())
			var/err = query_watchfind.ErrorMsg()
			log_DB("Watchlist error: ckey can't be obtained from players table \[[err]\].", notify_admin = TRUE)
			return

		if (!query_watchfind.NextRow())
			if (alert(usr, "[new_ckey] has not been seen before, are you sure you want to add them to the watchlist?", "Unknown ckey", "Yes", "No", "Cancel") != "Yes")
				return

		target_ckey = new_ckey

	target_ckey = sanitizeSQL(target_ckey)

	if (Check(target_ckey))
		usr << "<span class='redtext'>[target_ckey] is already on the watchlist.</span>"
		return

	var/reason = sanitize(input_utf8(usr, "Please State Reason", "Reason"))
	reason = sanitizeSQL(reason)
	if (!reason)
		return

	var/adminckey = usr.ckey
	adminckey = sanitizeSQL(adminckey)
	if (!adminckey)
		return

	var/DBQuery/query_watchadd = dbcon.NewQuery("INSERT INTO erro_watch (ckey, reason, adminckey, timestamp) VALUES ('[target_ckey]', '[reason]', '[adminckey]', Now())")
	if (!query_watchadd.Execute())
		var/err = query_watchadd.ErrorMsg()
		log_DB("Watchlist error during adding new watch entry \[[err]\].", notify_admin = TRUE)
		return

	reason = utf8_to_cp1251(rhtml_decode(reason))
	log_admin("[key_name(usr)] has added [target_ckey] to the watchlist - Reason: [reason]", notify_admin = TRUE)

	for(var/client/player in GLOB.clients)
		if (player.ckey == target_ckey)
			player.watchlist_warn = reason
			break

	if (browse)
		Show(target_ckey)


/datum/watchlist/proc/Check(target_ckey)
	target_ckey = sanitizeSQL(target_ckey)

	var/DBQuery/query_watch = dbcon.NewQuery("SELECT reason FROM erro_watch WHERE ckey = '[target_ckey]'")
	if (!query_watch.Execute())
		var/err = query_watch.ErrorMsg()
		log_DB("Watchlist error: reason can't be obtained from watch table \[[err]\].", notify_admin = TRUE)
		return

	if (query_watch.NextRow())
		return utf8_to_cp1251(rhtml_decode(query_watch.item[1]))
	else
		return null


/datum/watchlist/proc/Remove(target_ckey, browse = 0)
	target_ckey = sanitizeSQL(target_ckey)

	var/DBQuery/query_watchdel = dbcon.NewQuery("DELETE FROM erro_watch WHERE ckey = '[target_ckey]'")
	if (!query_watchdel.Execute())
		var/err = query_watchdel.ErrorMsg()
		log_DB("Watchlist error during removing watch entry \[[err]\].", notify_admin = TRUE)
		return

	log_admin("[key_name(usr)] has removed [target_ckey] from the watchlist", notify_admin = TRUE)

	for(var/client/player in GLOB.clients)
		if (player.ckey == target_ckey)
			player.watchlist_warn = null
			break

	if (browse)
		Show()


/datum/watchlist/proc/Edit(target_ckey, browse = 0)
	target_ckey = sanitizeSQL(target_ckey)

	var/DBQuery/query_watchreason = dbcon.NewQuery("SELECT reason FROM erro_watch WHERE ckey = '[target_ckey]'")
	if (!query_watchreason.Execute())
		var/err = query_watchreason.ErrorMsg()
		log_DB("Watchlist error: reason can't be obtained from watch table \[[err]\].", notify_admin = TRUE)
		return

	if (query_watchreason.NextRow())
		var/watch_reason = query_watchreason.item[1]

		var/new_reason = sanitize(input_utf8(usr, "Input new reason", "New Reason", rhtml_decode(watch_reason)))
		new_reason = sanitizeSQL(new_reason)
		if (!new_reason)
			return

		var/admin_ckey = sanitizeSQL(usr.ckey)
		var/edit_text = "Edited by [admin_ckey] on [time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")] from<br>[watch_reason]<br>to<br>[new_reason]<hr>"
		edit_text = sanitizeSQL(edit_text)

		var/DBQuery/query_watchupdate = dbcon.NewQuery("UPDATE erro_watch SET reason = '[new_reason]', last_editor = '[admin_ckey]', edits = CONCAT(IFNULL(edits,''),'[edit_text]') WHERE ckey = '[target_ckey]'")
		if (!query_watchupdate.Execute())
			var/err = query_watchupdate.ErrorMsg()
			log_DB("Watchlist error: reason can't be updated \[[err]\].", notify_admin = TRUE)
			return

		watch_reason = utf8_to_cp1251(rhtml_decode(watch_reason))
		new_reason = utf8_to_cp1251(rhtml_decode(new_reason))
		log_admin("[key_name(usr)] has edited [target_ckey]'s watchlist reason from [watch_reason] to [new_reason]", notify_admin = TRUE)

		for(var/client/player in GLOB.clients)
			if (player.ckey == target_ckey)
				player.watchlist_warn = new_reason
				break

		if (browse)
			Show(target_ckey)


/datum/watchlist/proc/Show(search)
	var/output
	output += "<form method='GET' name='search' action='?'>\
	<input type='hidden' name='_src_' value='holder'>\
	<input type='text' name='watchsearch' value='[search]'>\
	<input type='submit' value='Search'></form>"
	output += "<a href='?_src_=holder;watchshow=1'>\[Clear Search\]</a> <a href='?_src_=holder;watchaddbrowse=1'>\[Add Ckey\]</a>"
	output += "<hr style='background:#000000; border:0; height:3px'>"

	if(search)
		search = "^[search]"
	else
		search = "^."
	search = sanitizeSQL(search)

	var/DBQuery/query_watchlist = dbcon.NewQuery("SELECT ckey, reason, adminckey, timestamp, last_editor FROM erro_watch WHERE ckey REGEXP '[search]' ORDER BY ckey")
	if(!query_watchlist.Execute())
		var/err = query_watchlist.ErrorMsg()
		log_DB("Watchlist error: watch table can't be obtained \[[err]\].", notify_admin = TRUE)
		return

	while(query_watchlist.NextRow())
		var/ckey = query_watchlist.item[1]
		var/reason = query_watchlist.item[2]
		var/adminckey = query_watchlist.item[3]
		var/timestamp = query_watchlist.item[4]
		var/last_editor = query_watchlist.item[5]
		output += "<b>[ckey]</b> | Added by <b>[adminckey]</b> on <b>[timestamp]</b> <a href='?_src_=holder;watchremovebrowse=[ckey]'>\[Remove\]</a> <a href='?_src_=holder;watcheditbrowse=[ckey]'>\[Edit Reason\]</a>"
		if(last_editor)
			output += " <font size='2'>Last edit by [last_editor] <a href='?_src_=holder;watcheditlog=[ckey]'>(Click here to see edit log)</a></font>"
		output += "<br>[reason]<hr style='background:#000000; border:0; height:1px'>"

	usr << browse(output, "window=watchwin;size=900x500")

/datum/watchlist/proc/OnLogin(var/client/C)
	if (!C)
		return

	C.watchlist_warn = watchlist.Check(C.ckey)
	if (C.watchlist_warn)
		message_admins("<font color='red'><B>WATCHLIST: </B></font><font color='blue'>[key_name_admin(C)] has just connected - Reason: [C.watchlist_warn]</font>")

	if (check_rights((R_ADMIN|R_MOD), 0, C))
		for(var/client/player in GLOB.clients)
			if (player.watchlist_warn)
				to_chat(C, "<span class=\"log_message\"><font color='red'><B>WATCHLIST: </B></font><font color='blue'>[key_name_admin(player)] is playing - Reason: [player.watchlist_warn]</font></span>")

/datum/watchlist/proc/AdminTopicProcess(var/datum/admins/source, var/list/href_list)
	if(href_list["watchadd"])
		var/target_ckey = locate(href_list["watchadd"])
		Add(target_ckey)
		source.show_player_panel(usr.client.mob)

	else if(href_list["watchremove"])
		var/target_ckey = href_list["watchremove"]
		Remove(target_ckey)
		source.show_player_panel(usr.client.mob)

	else if(href_list["watchedit"])
		var/target_ckey = href_list["watchedit"]
		Edit(target_ckey)
		source.show_player_panel(usr.client.mob)

	else if(href_list["watchaddbrowse"])
		Add(null, 1)

	else if(href_list["watchremovebrowse"])
		var/target_ckey = href_list["watchremovebrowse"]
		Remove(target_ckey, 1)

	else if(href_list["watcheditbrowse"])
		var/target_ckey = href_list["watcheditbrowse"]
		Edit(target_ckey, 1)

	else if(href_list["watchsearch"])
		var/target_ckey = href_list["watchsearch"]
		Show(target_ckey)

	else if(href_list["watchshow"])
		Show()

	else if(href_list["watcheditlog"])
		var/target_ckey = sanitizeSQL("[href_list["watcheditlog"]]")

		var/DBQuery/query_watchedits = dbcon.NewQuery("SELECT edits FROM erro_watch WHERE ckey = '[target_ckey]'")
		if(!query_watchedits.Execute())
			var/err = query_watchedits.ErrorMsg()
			log_game("SQL ERROR obtaining edits from watch table. Error : \[[err]\]\n")
			return

		if(query_watchedits.NextRow())
			var/edit_log = query_watchedits.item[1]
			usr << browse(edit_log,"window=watchedits")
