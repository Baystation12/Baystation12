#define MODE_INIT 0
#define MODE_SCOPES 1
#define MODE_TIME 2
#define MODE_CONFIRM 3

/datum/admin_ui/bans/addban
	id = "addban"
	title = "Add Ban"
	rights = R_BAN

	var/mode
	var/primed = FALSE

	var/ckey
	var/ip
	var/cid
	var/scopes
	var/time
	var/reason

/datum/admin_ui/bans/addban/proc/reset()
	mode = MODE_INIT
	scopes = list()
	time = 0
	reason = ""
	if (primed)
		primed = FALSE
		return
	ckey = ""
	ip = ""
	cid = ""


/datum/admin_ui/bans/addban/open()
	reset()
	..()

/datum/admin_ui/bans/addban/proc/getKeyData(var/ckey)
	var/ip = ""
	var/cid = ""

	if (ckey in GLOB.ckey_directory)
		var/client/cl = GLOB.ckey_directory[ckey]
		ip = cl.address
		cid = cl.computer_id

	return list(
		"ckey" = ckey,
		"ip" = ip,
		"cid" = cid,
	)

/datum/admin_ui/bans/addban/proc/getBanLine()
	return "Banning: <b>ckey:</b> <i>[ckey]</i> <b>ip:</b> <i>[ip]</i> <b>cid:</b> <i>[cid]</i>"

/datum/admin_ui/bans/addban/proc/getScopeLine()
	var/s = jointext(scopes, ",")
	return "<b>Banning from:</b> <i>[s]</i>"

/datum/admin_ui/bans/addban/proc/getDurationLine()
	if (time > 0)
		return "<b>Duration:</b> <i>[time] minutes</i>"
	return "<b>Duration:</b> <i>PERMANENT</i>"

/datum/admin_ui/bans/addban/get_content()
	if (!SSdatabase.initialized)
		to_chat(usr, SPAN_DANGER("Database initialization not yet complete"))
		return ""
	var/list/dat = list()

	if (mode == MODE_INIT)
		dat += {"<script type='text/javascript' language='javascript'>
window.onload = function() {
	document.getElementById("find").onclick = function() {
		alert('Here');
		window.location.href = "?src=\ref[src];lookup_ckey=" + encodeURIComponent(document.getElementById("ckey").value);
	};
	document.getElementById("next").onclick = function() {
		var ckey = encodeURIComponent(document.getElementById("ckey").value);
		var ip = encodeURIComponent(document.getElementById("ip").value);
		var cid = encodeURIComponent(document.getElementById("cid").value);
		window.location.href = "?src=\ref[src];mode_scopes=1;ckey=" + ckey + ";ip=" + ip + ";cid=" + cid;
	};
};
</script>"}
		dat += "<h1>User Details</h1>"
		dat += "<p>Type a ckey and hit find. If available, current or last info will be auto-populated.</p>"
		dat += "Ckey: <input type='text' id='ckey' value='[ckey]'><a id='find' href='#'>Find</a><br>"
		dat += "IP: <input type='text' id='ip' value='[ip]'><br>"
		dat += "ClientID: <input type='text' id='cid' value='[cid]'><br>"
		dat += "<hr><a id='next' href='#'>Next</a>"
	else if (mode == MODE_SCOPES)
		dat += "<style type='text/css'>.starthidden { display: none; }</style>"
		dat += {"<script type='text/javascript' language='javascript'>
window.onload = function() {
	var elems = document.querySelectorAll(".expander");
	Array.prototype.forEach.call(elems, function (x) {
		x.onclick = function() {
			var cat = x.getAttribute("data-cat");
			var dv = document.getElementById("scopes_" + cat);
			if (!dv.style.display || dv.style.display == "none") {
				dv.style.display = "block";
			} else {
				dv.style.display = "none";
			}
			return false;
		};
	});

	document.getElementById("next").onclick = function() {
		document.getElementById("exp_Server").innerHTML = "meow";
		var selected = document.querySelectorAll("input:checked");
		var vals = \[\];
		document.getElementById("exp_Server").innerHTML = "" + selected.length;
		Array.prototype.forEach.call(selected, function(x) {
			vals.push(x.value);
		});
		document.getElementById("exp_Server").innerHTML = vals.join(",");
		window.location.href = "?src=\ref[src];mode_time=1;scopes=" + vals.join(",");
	};
};
</script>"}
		dat += "<h1>Select Scopes</h1>"
		dat += getBanLine()
		for (var/cat in SSdatabase.ban_scope_categories)
			var/scopes = SSdatabase.ban_scope_categories[cat]
			dat += "<br><a href='#' data-cat='[cat]' id='exp_[cat]' class='expander'>[cat] =></a>"
			dat += "<div id='scopes_[cat]' class='starthidden'>"
			for (var/scope in scopes)
				dat += "<div><input type='checkbox' name='scopes' value='[scope]'>[scope]</div>"
			dat += "</div>"
		dat += "<br><hr><a href='#' id='next'>Next</a>"
	else if (mode == MODE_TIME)
		dat += {"<script type='text/javascript' language='javascript'>
window.onload = function() {
	document.getElementById("next").onclick = function() {
		var mins = document.getElementById("mins").value;
		window.location.href = "?src=\ref[src];mode_confirm=1;time=" + mins;
		return false;
	};
};
</script>"}
		dat += getBanLine()
		dat += "<br>"
		dat += getScopeLine()
		dat += "<p>Enter time duration <b>in minutes</b> to use for this ban, or click a suggestion. 0 minutes is permanent.</p>"
		dat += "<div>"
		dat += "<a href='?src=\ref[src];time=1440'>1D</a>"
		dat += "<a href='?src=\ref[src];time=4320'>3D</a>"
		dat += "<a href='?src=\ref[src];time=10080'>1W</a>"
		dat += "<a href='?src=\ref[src];time=20160'>2W</a>"
		dat += "<a href='?src=\ref[src];time=43800'>1M</a>"
		dat += "<a href='?src=\ref[src];time=131400'>3M</a>"
		dat += "<a href='?src=\ref[src];time=0'>PERMA</a>"
		dat += "</div>"
		dat += "<hr>"
		dat += "<input type='text' id='mins' value='[time]'> Minutes"
		dat += "<br><a id='next' href='#'>Next</a>"
	else if (mode == MODE_CONFIRM)
		dat += {"<script type='text/javascript' language='javascript'>
window.onload = function() {
	document.getElementById("apply").onclick = function() {
		var reason = document.getElementById("reason").value;
		reason = encodeURIComponent(reason);
		window.location.href = "?src=\ref[src];apply_ban=1;reason=" + reason;
		return false;
	};
};
</script>"}
		dat += getBanLine()
		dat += "<br>"
		dat += getScopeLine()
		dat += "<br>"
		dat += getDurationLine()
		dat += "<br>"
		dat += "Please <b>confirm</b> above details and enter a reason."
		dat += "<textarea id='reason' rows='12' cols='40'></textarea>"
		dat += "<br><hr><a href='#' id='apply'>Apply</a>"
	else
		CRASH("bad mode val: [mode]")

	to_chat(usr, sanitize(jointext(dat, null)))
	return jointext(dat, null)

/datum/admin_ui/bans/addban/Topic(href, href_list)
	if(..())
		return 1
	else if (href_list["lookup_ckey"])
		ckey = href_list["lookup_ckey"]
		var/list/data = getKeyData(ckey)
		ip = data["ip"]
		cid = data["cid"]
		update()
		return 1

	else if (href_list["mode_scopes"])
		ckey = href_list["ckey"]
		ip = href_list["ip"]
		cid = href_list["cid"]
		if (!ckey || !ip || !cid)
			to_chat(usr, SPAN_WARNING("Missing parameters"))
			return 1
		mode = MODE_SCOPES
		update()
		return 1

	else if (href_list["mode_time"])
		var/textscopes = href_list["scopes"]
		if (!textscopes)
			to_chat(usr, SPAN_WARNING("Missing parameters"))
			return 1
		scopes = splittext(textscopes, ",")
		mode = MODE_TIME
		update()
		return 1

	else if (href_list["mode_confirm"])
		time = text2num(href_list["time"])
		if (!time)
			to_chat(usr, SPAN_WARNING("Missing parameters"))
			return 1
		mode = MODE_CONFIRM
		update()
		return 1

	else if (href_list["time"])
		time = text2num(href_list["time"])
		update()
		return 1

	else if (href_list["apply_ban"])
		reason = href_list["reason"]
		if (!reason)
			to_chat(usr, SPAN_WARNING("Missing parameters"))
			return 1
		if (alert(usr, "Are you sure you want to ban [ckey]/[ip]/[cid]?", "Confirmation", "Yes", "No") != "Yes")
			to_chat(usr, SPAN_WARNING("Ban cancelled"))
			return 1
		if (!SSdatabase.db.RecordBan(scopes, usr.client.ckey, reason, time, ckey, ip, cid))
			to_chat(usr, SPAN_WARNING("Ban save failed"))
			return 1
		to_chat(usr, SPAN_WARNING("Ban applied"))
		log_and_message_staff("has banned [ckey]/[ip]/[cid] for [reason]")
		for (var/client/c in GLOB.clients)
			if (c.ckey == ckey || c.address == ip || c.computer_id == cid)
				if ("server" in scopes)
					message_staff("Kicking [c.ckey] due to matching a new ban")
					qdel(c)
				else
					message_staff("Applying new ban scopes against [c.ckey]")
					c.bans |= scopes
		close()
		return 1

	return 0

#undef MODE_INIT
#undef MODE_SCOPES
#undef MODE_TIME
#undef MODE_CONFIRM

/datum/admin_ui/bans/banpanel
	id = "banpanel"
	title = "Ban Panel"
	rights = R_BAN

	width = 800

	var/ckey
	var/ip
	var/cid

	var/list/bans

/datum/admin_ui/bans/banpanel/open()
	reset()
	..()

/datum/admin_ui/bans/banpanel/proc/reset()
	ckey = ""
	ip = ""
	cid = ""
	bans = null

/datum/admin_ui/bans/banpanel/proc/searchBans()
	bans = SSdatabase.db.GetBans(ckey, ip, cid)

/datum/admin_ui/bans/banpanel/get_content()
	var/list/dat = list()

	dat += {"<script type='text/javascript' language='javascript'>
window.onload = function() {
	document.getElementById("find").onclick = function() {
		var ckey = document.getElementById("ckey").value;
		var ip = document.getElementById("ip").value;
		var cid = document.getElementById("cid").value;

		ckey = encodeURIComponent(ckey);
		ip = encodeURIComponent(ip);
		cid = encodeURIComponent(cid);

		window.location.href = "?src=\ref[src];search=1;ckey=" + ckey + ";ip=" + ip + ";cid=" + cid;
		return false;
	};
};
</script>"}
	dat += "<a href='?src=\ref[src];addban=1'>Add Ban</a><hr>"
	dat += "<b>Search ban by:</b><br>"
	dat += "Ckey: <input type='text' id='ckey' value='[ckey]'><br>"
	dat += "IP: <input type='text' id='ip' value='[ip]'><br>"
	dat += "Cid: <input type='text' id='cid' value='[cid]'><br>"
	dat += "<a href='#' id='find'>Find</a>"
	dat += "<hr>"
	if (bans && bans.len)
		dat += "<table>"
		dat += "<tr>"
		dat += "<th>ID</th>"
		dat += "<th>Ckey</th>"
		dat += "<th>IP</th>"
		dat += "<th>CID</th>"
		dat += "<th>Expiry</th>"
		dat += "<th>Scopes</th>"
		dat += "<th>Reason</th>"
		dat += "<th>Admin</th>"
		dat += "<th>X</th>"
		dat += "</tr>"
		for (var/ban in bans)
			if (ban["expired"] == 1 || ban["expired"] == "1")
				dat += "<tr style='background-color: red;'>"
			else
				dat += "<tr>"
			dat += "<td>[ban["id"]]</td>"
			dat += "<td>[ban["ckey"]]</td>"
			dat += "<td>[ban["ip"]]</td>"
			dat += "<td>[num2text(ban["computerid"], 99)]</td>"
			dat += "<td>[ban["expiry"]]</td>"
			dat += "<td>[ban["scope"]]</td>"
			dat += "<td>[ban["reason"]]</td>"
			dat += "<td>[ban["admin"]]</td>"
			dat += "<td><a href='?src=\ref[src];removeban=[ban["id"]]'>X</a></td>"
			dat += "</tr>"
		dat += "</table>"

	return jointext(dat, null)

/datum/admin_ui/bans/banpanel/Topic(href, href_list)
	if (..())
		return 1
	else if (href_list["addban"])
		usr.client.holder.ShowUI(/datum/admin_ui/bans/addban)
		return 1
	else if (href_list["removeban"])
		var/id = href_list["removeban"]
		var/list/ban = SSdatabase.db.GetBan(id)
		if (!ban)
			to_chat(usr, SPAN_WARNING("No such ban"))
			return 1
		to_chat(usr, json_encode(ban))
		if (ban["expired"] == "1" || ban["expired"] == 1)
			to_chat(usr, SPAN_WARNING("Ban expired or removed"))
			return 1
		var/ckey = ban["ckey"]
		var/ip = ban["ip"]
		var/cid = num2text(ban["computerid"], 99)
		if (alert(usr, "Are you sure you want to remove the ban for [ckey]/[ip]/[cid]?", "Confirmation", "Yes", "No") != "Yes")
			to_chat(usr, SPAN_WARNING("Unban cancelled"))
			return 1
		if (!SSdatabase.db.RemoveBan(id, usr.client.ckey))
			to_chat(usr, SPAN_WARNING("Failed to remove ban"))
			return 1
		log_and_message_admins("removed ban for [ckey]/[ip]/[cid]")
		searchBans()
		update()
		return 1
	else if (href_list["search"])
		ckey = href_list["ckey"]
		ip = href_list["ip"]
		cid = href_list["cid"]
		searchBans()
		if (!bans)
			to_chat(usr, SPAN_WARNING("No results"))
		update()
		return 1
	return 0
