/datum/admins/proc/view_persistent_data()
	set category = "Admin"
	set name = "View Persistent Data"
	set desc = "Shows a list of persistent data for this round. Allows modification by admins."

	if(!check_rights(R_MOD))
		to_chat(usr, SPAN_WARNING("You do not have sufficient rights to view the persistent data list."))
		return

	var/list/dat = list()
	var/can_modify = check_rights(R_ADMIN)
	for(var/thing in SSpersistence.persistence_datums)
		var/datum/persistent/P = SSpersistence.persistence_datums[thing]
		dat += P.GetAdminSummary(src, can_modify)

	var/datum/browser/popup = new(usr, "admin_persistence", "Persistence Data")
	popup.set_content(jointext(dat, null))
	popup.open()
