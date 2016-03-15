/client/proc/checkAccount()
	set name = "Check multiaccounts"
	set category = "Admin"

	var/target = input(usr, "Write ckey that you want to check.", "Ckey") as text|null
	if(!target)
		return
	showAccounts(src, target)

/proc/showAccounts(var/mob/user, var/targetkey)
	var/output = "<center><table border='1'> <caption>computerID matches</caption><tr> <th width='100px' >ckey</th><th width='100px'>firstseen</th><th width='100px'>lastseen</th><th width='100px'>ip</th><th width='100px'>computerid </th></tr>"

	var/DBQuery/query = dbcon.NewQuery("SELECT ckey,firstseen,lastseen,ip,computerid FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[targetkey]')")
	query.Execute()
	while(query.NextRow())
		output+="<tr><td>[query.item[1]]</td>"
		output+="<td>[query.item[2]]</td>"
		output+="<td>[query.item[3]]</td>"
		output+="<td>[query.item[4]]</td>"
		output+="<td>[query.item[5]]</td></tr>"

	output+="</table>"

	output += "<center><table border='1'> <caption>IP matches</caption><tr> <th width='100px' >ckey</th><th width='100px'>firstseen</th><th width='100px'>lastseen</th><th width='100px'>ip</th><th width='100px'>computerid </th></tr>"

	query = dbcon.NewQuery("SELECT ckey,firstseen,lastseen,ip,computerid FROM erro_player WHERE ip IN (SELECT DISTINCT ip FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[targetkey]'))")
	query.Execute()
	while(query.NextRow())
		output+="<tr><td>[query.item[1]]</td>"
		output+="<td>[query.item[2]]</td>"
		output+="<td>[query.item[3]]</td>"
		output+="<td>[query.item[4]]</td>"
		output+="<td>[query.item[5]]</td></tr>"

	output+="</table></center>"

	user << browse(output, "window=accaunts;size=600x400")

/client/proc/checkAllAccounts()
	set name = "Check multiaccounts(All)"
	set category = "Admin"

	var/DBQuery/query
	var/t1 = ""
	var/output = "<B>IP matches</B><BR><BR>"

	for (var/client/C in clients)
		t1 =""
		query = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ip IN (SELECT DISTINCT ip FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[C.ckey]'))")
		query.Execute()
		var/c = 0

		while(query.NextRow())
			c++
			t1 +="[c]: - [query.item[1]]<BR>"
		if (c > 1)
			output+= "Ckey: [C.ckey] <A href='?_src_=holder;showmultiacc=[C.ckey]'>Show</A><BR>" + t1

	output+= "<BR><BR><B>computerID matches</B><BR><BR>"

	for (var/client/C in clients)
		t1 =""
		query = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[C.ckey]'))")
		query.Execute()
		var/c = 0
		while(query.NextRow())
			c++
			t1 +="[c]: [query.item[1]]<BR>"
		if (c > 1)
			output+= "Ckey: [C.ckey] <A href='?_src_=holder;showmultiacc=[C.ckey]'>Show</A><BR>" + t1

	usr << browse(output, "window=accauntsall;size=400x800")