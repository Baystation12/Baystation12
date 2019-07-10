/datum/admin_ui/permissions/ranks
	id = "adminranks"
	title = "Admin Ranks"
	rights = R_PERMISSIONS

	var/list/ranks
	var/list/admin_rights = list(
		"BUILDMODE",
		"ADMIN",
		"BAN",
		"FUN",
		"SERVER",
		"DEBUG",
		"POSSESS",
		"PERMISSIONS",
		"STEALTH",
		"REJUVINATE",
		"VAREDIT",
		"SOUNDS",
		"SPAWN",
		"MOD",
		"HOST",
	)
	var/list/admin_flags = list(
		"NEEDSGRANT",
	)

/datum/admin_ui/permissions/ranks/get_content()
	ranks = SSdatabase.db.GetAdminRanks()

	var/list/dat = list()

	dat += "<style>.dowrap { white-space: normal !important; }</style><table style=\"width:100%\"><tr><th>Name</th><th>Permissions</th><th>Flags</th><th></th></tr>"
	for (var/i = 1, i <= ranks.len, i++)
		var/rank = ranks[i]
		var/name = rank["name"]
		var/permissions = rights2text(rank["permissions"], " ")
		var/flags = adminflags2text(rank["flags"], " ")
		dat += "<tr class=\"candystripe\">"
		dat += "<td><a href='?src=\ref[src];change_name=[i]'>[name]</a></td>"
		dat += "<td><a class='dowrap' href='?src=\ref[src];change_permissions=[i]'>[permissions]</a></td>"
		dat += "<td><a class='dowrap' href='?src=\ref[src];change_flags=[i]'>[flags]</a></td>"
		dat += "<td><a href='?src=\ref[src];delete_rank=[i]'>X</a></td>"
		dat += "</tr>"
	dat += "</table>"

	return jointext(dat, null)

/datum/admin_ui/permissions/proc/flagEdit(var/current, var/list/possible, var/name)
	var/list/addable = list()
	var/list/removable = list()

	for (var/I in 1 to possible.len)
		if (current & (1 << (I - 1)))
			removable += possible[I]
		else
			addable += possible[I]

	var/list/choices = list()
	for (var/choice in addable)
		choices += "+[choice]"
	for (var/choice in removable)
		choices += "-[choice]"

	var/delta = input(usr, "[name] to Change", "Edit [name]", null) as null | anything in choices
	if (!delta)
		to_chat(usr, SPAN_WARNING("Change cancelled"))
		return null

	var/flagname = copytext(delta, 2, 0)
	var/fidx = possible.Find(flagname)
	var/flagval = 1 << (fidx - 1)

	var/newval = current
	var/what
	if (delta[1] == "+")
		newval |= flagval
		what = "added"
	else
		newval &= ~flagval
		what = "removed"
	log_and_message_admins("has [what] [flagname] [name]")

	return newval

/datum/admin_ui/permissions/ranks/Topic(href, href_list)
	if (..())
		return 1
	else if (!ranks)
		return 1
	else if (href_list["change_name"])
		var/editrank = ranks[text2num(href_list["change_name"])]
		if (!editrank)
			to_chat(usr, SPAN_WARNING("Invalid entry"))
			return 1
		var/oldname = editrank["name"]
		var/newname = input(usr, "New Name for [oldname]", "Rename Rank", oldname)
		if (!newname || newname == oldname)
			to_chat(usr, SPAN_WARNING("Change cancelled"))
		else
			if (SSdatabase.db.UpdateAdminRank(oldname, newname, editrank["permissions"], editrank["flags"]))
				log_and_message_admins("has renamed admin rank '[oldname]' to '[newname]'")
			else
				to_chat(usr, SPAN_WARNING("Change failed"))
			update()
		return 1
	else if (href_list["change_permissions"])
		var/editrank = ranks[text2num(href_list["change_permissions"])]
		if (!editrank)
			to_chat(usr, SPAN_WARNING("Invalid entry"))
			return 1
		var/name = editrank["name"]
		var/oldpermissions = editrank["permissions"]
		var/newpermissions = flagEdit(oldpermissions, admin_rights, "Permission for [name]")

		if (!SSdatabase.db.UpdateAdminRank(name, name, newpermissions, editrank["flags"]))
			to_chat(usr, SPAN_WARNING("Change failed"))
		update()
		return 1
	else if (href_list["change_flags"])
		var/editrank = ranks[text2num(href_list["change_flags"])]
		if (!editrank)
			to_chat(usr, SPAN_WARNING("Invalid entry"))
			return 1
		var/name = editrank["name"]
		var/oldflags = editrank["flags"]
		var/newflags = flagEdit(oldflags, admin_flags, "Flags for [name]")

		if (!SSdatabase.db.UpdateAdminRank(name, name, editrank["permissions"], newflags))
			to_chat(usr, SPAN_WARNING("Change failed"))
		update()
		return 1
	else if (href_list["delete_rank"])
		var/editrank = ranks[text2num(href_list["delete_rank"])]
		if (!editrank)
			to_chat(usr, SPAN_WARNING("Invalid entry"))
			return 1
		var/name = editrank["name"]
		if(alert(usr, "Are you sure you want to delete rank '[name]'?", "Confirmation", "Yes", "No")  != "Yes")
			to_chat(usr, SPAN_WARNING("Change cancelled"))
			return 1
		if (SSdatabase.db.RemoveAdminRank(name))
			log_and_message_admins("has deleted the rank [name]")
		else
			to_chat(usr, SPAN_WARNING("Change failed"))
		update()
		return 1

	return 0

/datum/admin_ui/permissions/users
	id = "adminusers"
	title = "Admin Users"
	rights = R_PERMISSIONS
	var/list/admins

/datum/admin_ui/permissions/users/get_content()
	admins = SSdatabase.db.GetAdmins()

	var/list/dat = list()

	dat += "<table style=\"width:100%\"><tr><th>Name</th><th>Rank</th><th></th></tr>"
	for (var/i = 1, i <= admins.len, i++)
		var/admin = admins[i]
		var/ckey = admin["ckey"]
		var/rank = admin["name"]
		dat += "<tr class=\"candystripe\">"
		dat += "<td>[ckey]</td>"
		dat += "<td><a href='?src=\ref[src];change_rank=[i]'>[rank]</a></td>"
		dat += "<td><a href='?src=\ref[src];delete_admin=[i]'>X</a></td>"
		dat += "</tr>"
	return jointext(dat, null)

/datum/admin_ui/permissions/users/Topic(href, href_list)
	if (..())
		return 1
	else if (!admins)
		return 1
	else if (href_list["change_rank"])
		var/editadmin = admins[text2num(href_list["change_rank"])]
		if (!editadmin)
			to_chat(usr, SPAN_WARNING("Invalid entry"))
			return 1
		var/ckey = editadmin["ckey"]
		var/oldrank = editadmin["name"]

		var/list/ranks = SSdatabase.db.GetAdminRanks()
		var/list/choices = new

		for (var/rank in ranks)
			choices += rank["name"]

		var/newrank = input(usr, "Select new rank for [ckey]", "New Rank", null) as null | anything in choices
		if (!newrank)
			to_chat(usr, SPAN_WARNING("Change cancelled"))
			return 1
		if (SSdatabase.db.SetAdminRank(ckey, newrank))
			log_and_message_admins("changed the rank of [ckey] from [oldrank] to [newrank]")
		else
			to_chat(usr, SPAN_WARNING("Change failed"))
		update()
		return 1
	else if (href_list["delete_admin"])
		var/editadmin = admins[text2num(href_list["delete_admin"])]
		if (!editadmin)
			to_chat(usr, SPAN_WARNING("Invalid entry"))
			return 1
		var/ckey = editadmin["ckey"]

		if (alert(usr, "Are you sure you want to remove rank from '[ckey]'?", "Confirmation", "Yes", "No") != "Yes")
			to_chat(usr, SPAN_WARNING("Change cancelled"))
			return 1
		if (SSdatabase.db.RemoveAdmin(ckey))
			log_and_message_admins("has removed the rank from [ckey]")
		else
			to_chat(usr, SPAN_WARNING("Change failed"))
		update()
		return 1
