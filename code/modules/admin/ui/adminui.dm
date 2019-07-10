/datum/admin_ui
	var/datum/admins/holder
	var/id
	var/title
	var/width = 400
	var/height = 400
	var/rights = 0
	var/datum/browser/popup

/datum/admin_ui/New(datum/admins/holder)
	..()
	src.holder = holder

/datum/admin_ui/proc/get_content()
	return ""

/datum/admin_ui/proc/open()
	if (!popup)
		popup = new(usr, id, title, width, height)
	popup.set_content(get_content())
	if (popup.content)
		popup.open()

/datum/admin_ui/proc/close()
	if (popup)
		popup.close()

/datum/admin_ui/proc/update()
	if (popup)
		popup.set_content(get_content())
		popup.update()

/datum/admin_ui/Topic(href, href_list)
	. = ..()
	if (.)
		return
	if (!check_rights(rights))
		return 1

/datum/admins/proc/ShowUI(var/type)
	if (!ispath(type, /datum/admin_ui))
		CRASH("ShowUI for non-admin_ui: [type]")
	if (!(type in adminuis))
		adminuis[type] = new type(src)
	adminuis[type].open()

/datum/admins/proc/GetUI(var/type)
	if (!ispath(type, /datum/admin_ui))
		CRASH("GetUI for non-admin_ui: [type]")
	if (!(type in adminuis))
		adminuis[type] = new type(src)
	return adminuis[type]
