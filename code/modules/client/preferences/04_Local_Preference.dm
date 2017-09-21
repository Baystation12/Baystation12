datum/preferences/proc/contentLocalPreference()
	var/data = {"

		<html><body>

		<nav class='vNav'>
		<ul>
		<li><a href='?src=\ref[src];page=1'>Character</a>
		<li><a href='?src=\ref[src];page=2'>Occupation</a>
		<li><a href='?src=\ref[src];page=3'>Loadout</a>
		<li><a class='active' href='?src=\ref[src];page=4'>Local Preferences</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=9'>Records</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=8'>Global Preferences</a>
		</ul>
		</nav>

		<nav class='hNav'>
		<ul>
		<li><a href='?src=\ref[src];save=1'>Save</a>
		<li><a href='?src=\ref[src];load=1'>Load</a>
		<li><a href='?src=\ref[src];delete=1'>Reset</a>
		<li><a href='?src=\ref[src];lock=1'>Lock</a>
		</ul>
		</nav>

		<div class='main' style='width:650px; font-size: small;'>

		"}
	data += "<b>Special Role Availability:</b><br>"
	data += "<table>"
	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		data += "<tr><td>[antag.role_text]: </td><td>"
		if(jobban_isbanned(preference_mob(), antag.id) || (antag.id == MODE_MALFUNCTION && jobban_isbanned(preference_mob(), "AI")))
			data += "<span class='danger'>\[BANNED\]</span><br>"
		else if(antag.role_type in be_special_role)
			data += "<span class='linkOn'>High</span> <a href='?src=\ref[src];del_special=[antag.role_type]'>Low</a> <a href='?src=\ref[src];add_never=[antag.role_type]'>Never</a></br>"
		else if(antag.role_type in sometimes_be_special_role)
			data += "<a href='?src=\ref[src];add_special=[antag.role_type]'>High</a> <span class='linkOn'>Low</span> <a href='?src=\ref[src];add_never=[antag.role_type]'>Never</a></br>"
		else
			data += "<a href='?src=\ref[src];add_special=[antag.role_type]'>High</a> <a href='?src=\ref[src];del_special=[antag.role_type]'>Low</a> <span class='linkOn'>Never</span></br>"
		data += "</td></tr>"

	var/list/ghost_traps = get_ghost_traps()
	for(var/ghost_trap_key in ghost_traps)
		var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
		if(!ghost_trap.list_as_special_role)
			continue

		data += "<tr><td>[(ghost_trap.ghost_trap_role)]: </td><td>"
		if(banned_from_ghost_role(preference_mob(), ghost_trap))
			data += "<span class='danger'>\[BANNED\]</span><br>"
		else if(ghost_trap.pref_check in be_special_role)
			data += "<span class='linkOn'>High</span> <a href='?src=\ref[src];del_special=[ghost_trap.pref_check]'>Low</a> <a href='?src=\ref[src];add_never=[ghost_trap.pref_check]'>Never</a></br>"
		else if(ghost_trap.pref_check in sometimes_be_special_role)
			data += "<a href='?src=\ref[src];add_special=[ghost_trap.pref_check]'>High</a> <span class='linkOn'>Low</span> <a href='?src=\ref[src];add_never=[ghost_trap.pref_check]'>Never</a></br>"
		else
			data += "<a href='?src=\ref[src];add_special=[ghost_trap.pref_check]'>High</a> <a href='?src=\ref[src];del_special=[ghost_trap.pref_check]'>Low</a> <span class='linkOn'>Never</span></br>"
		data += "</td></tr>"
	data += "</table>"

	data += {"

		</div>

		<div class='secondary'>
		<b>Antag Setup:</b><br>
		Uplink Type: <a href='?src=\ref[src];antagtask=1'>[uplinklocation]</a><br>
		Exploitable information:<br>

		"}
	if(jobban_isbanned(user, "Records"))
		data += "<b>You are banned from using character records.</b><br>"
	else
		data +="<a href='?src=\ref[src];exploitable_record=1'>[TextPreview(exploit_record,40)]</a><br>"
	data += {"

		</div>

		<div class='background'>
		</div>

		</body></html>

		"}

	return data

/datum/preferences/proc/Topic4(var/href, var/list/href_list)

	if(href_list["page"])
		selected_menu = text2num(href_list["page"])

	else if(href_list["add_special"])
		if(!(href_list["add_special"] in valid_special_roles()))
			return
		be_special_role |= href_list["add_special"]
		sometimes_be_special_role -= href_list["add_special"]
		never_be_special_role -= href_list["add_special"]


	else if(href_list["del_special"])
		if(!(href_list["del_special"] in valid_special_roles()))
			return
		be_special_role -= href_list["del_special"]
		sometimes_be_special_role |= href_list["del_special"]
		never_be_special_role -= href_list["del_special"]

	else if(href_list["add_never"])
		be_special_role -= href_list["add_never"]
		sometimes_be_special_role -= href_list["add_never"]
		never_be_special_role |= href_list["add_never"]

	else if (href_list["antagtask"])
		uplinklocation = next_in_list(uplinklocation, uplink_locations)
		return

	else if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(input(user,"Set exploitable information about you here.","Exploitable Information", html_decode(exploit_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			exploit_record = exploitmsg
			return
	return
