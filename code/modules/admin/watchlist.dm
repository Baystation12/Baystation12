/client/proc/watchlist_add(target_ckey, browse = 0)
	if(!target_ckey)
		var/new_ckey = ckey(input(usr,"Who would you like to add to the watchlist?","Enter a ckey",null) as text)
		if(!new_ckey)
			return
		new_ckey = sanitizeSQL(new_ckey)
		var/DBQuery/query_watchfind = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ckey = '[new_ckey]'")
		if(!query_watchfind.Execute())
			var/err = query_watchfind.ErrorMsg()
			log_game("SQL ERROR obtaining ckey from player table. Error : \[[err]\]\n")
			return
		if(!query_watchfind.NextRow())
			if(alert(usr, "[new_ckey] has not been seen before, are you sure you want to add them to the watchlist?", "Unknown ckey", "Yes", "No", "Cancel") != "Yes")
				return
		target_ckey = new_ckey
	var/target_sql_ckey = sanitizeSQL(target_ckey)
	if(watchlist_check(target_sql_ckey))
		usr << "<span class='redtext'>[target_sql_ckey] is already on the watchlist.</span>"
		return
	var/reason = input(usr,"Please State Reason","Reason") as message
	if(!reason)
		return
	reason = sanitizeSQL(reason)
	var/adminckey = usr.ckey
	if(!adminckey)
		return
	var/admin_sql_ckey = sanitizeSQL(adminckey)
	var/DBQuery/query_watchadd = dbcon.NewQuery("INSERT INTO erro_watch (ckey, reason, adminckey, timestamp) VALUES ('[target_sql_ckey]', '[reason]', '[admin_sql_ckey]', Now())")
	if(!query_watchadd.Execute())
		var/err = query_watchadd.ErrorMsg()
		log_game("SQL ERROR during adding new watch entry. Error : \[[err]\]\n")
		return
	log_admin("[key_name(usr)] has added [target_ckey] to the watchlist - Reason: [reason]")
	if(browse)
		watchlist_show(target_sql_ckey)

/client/proc/watchlist_remove(target_ckey, browse = 0)
	var/target_sql_ckey = sanitizeSQL(target_ckey)
	var/DBQuery/query_watchdel = dbcon.NewQuery("DELETE FROM erro_watch WHERE ckey = '[target_sql_ckey]'")
	if(!query_watchdel.Execute())
		var/err = query_watchdel.ErrorMsg()
		log_game("SQL ERROR during removing watch entry. Error : \[[err]\]\n")
		return
	log_admin("[key_name(usr)] has removed [target_ckey] from the watchlist")
	if(browse)
		watchlist_show()

/client/proc/watchlist_edit(target_ckey, browse = 0)
	var/target_sql_ckey = sanitizeSQL(target_ckey)
	var/DBQuery/query_watchreason = dbcon.NewQuery("SELECT reason FROM erro_watch WHERE ckey = '[target_sql_ckey]'")
	if(!query_watchreason.Execute())
		var/err = query_watchreason.ErrorMsg()
		log_game("SQL ERROR obtaining reason from watch table. Error : \[[err]\]\n")
		return
	if(query_watchreason.NextRow())
		var/watch_reason = query_watchreason.item[1]
		var/new_reason = input("Input new reason", "New Reason", "[watch_reason]") as message
		new_reason = sanitizeSQL(new_reason)
		if(!new_reason)
			return
		var/sql_ckey = sanitizeSQL(usr.ckey)
		var/edit_text = "Edited by [sql_ckey] on [time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")] from<br>[watch_reason]<br>to<br>[new_reason]<hr>"
		edit_text = sanitizeSQL(edit_text)
		var/DBQuery/query_watchupdate = dbcon.NewQuery("UPDATE erro_watch SET reason = '[new_reason]', last_editor = '[sql_ckey]', edits = CONCAT(IFNULL(edits,''),'[edit_text]') WHERE ckey = '[target_sql_ckey]'")
		if(!query_watchupdate.Execute())
			var/err = query_watchupdate.ErrorMsg()
			log_game("SQL ERROR editing watchlist reason. Error : \[[err]\]\n")
			return
		log_admin("[key_name(usr)] has edited [target_ckey]'s watchlist reason from [watch_reason] to [new_reason]")
		if(browse)
			watchlist_show(target_sql_ckey)

/client/proc/watchlist_show(search)
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
		log_game("SQL ERROR obtaining ckey, reason, adminckey, timestamp, last_editor from watch table. Error : \[[err]\]\n")
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

/client/proc/watchlist_check(target_ckey)
	var/target_sql_ckey = sanitizeSQL(target_ckey)
	var/DBQuery/query_watch = dbcon.NewQuery("SELECT reason FROM erro_watch WHERE ckey = '[target_sql_ckey]'")
	if(!query_watch.Execute())
		var/err = query_watch.ErrorMsg()
		log_game("SQL ERROR obtaining reason from watch table. Error : \[[err]\]\n")
		return
	if(query_watch.NextRow())
		return query_watch.item[1]
	else
		return 0

/proc/Watchlist_AdminTopicProcess(var/datum/admins/source, var/list/href_list)
	if(href_list["watchadd"])
		var/target_ckey = locate(href_list["watchadd"])
		usr.client.watchlist_add(target_ckey)
		source.show_player_panel(usr.client.mob)

	else if(href_list["watchremove"])
		var/target_ckey = href_list["watchremove"]
		usr.client.watchlist_remove(target_ckey)
		source.show_player_panel(usr.client.mob)

	else if(href_list["watchedit"])
		var/target_ckey = href_list["watchedit"]
		usr.client.watchlist_edit(target_ckey)
		source.show_player_panel(usr.client.mob)

	else if(href_list["watchaddbrowse"])
		usr.client.watchlist_add(null, 1)

	else if(href_list["watchremovebrowse"])
		var/target_ckey = href_list["watchremovebrowse"]
		usr.client.watchlist_remove(target_ckey, 1)

	else if(href_list["watcheditbrowse"])
		var/target_ckey = href_list["watcheditbrowse"]
		usr.client.watchlist_edit(target_ckey, 1)

	else if(href_list["watchsearch"])
		var/target_ckey = href_list["watchsearch"]
		usr.client.watchlist_show(target_ckey)

	else if(href_list["watchshow"])
		usr.client.watchlist_show()

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
	else
		return