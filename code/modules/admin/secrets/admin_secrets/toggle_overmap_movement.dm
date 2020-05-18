/datum/admin_secret_item/admin_secret/toggle_overmap_movement
	name = "Toggle Overmap Halt"

/datum/admin_secret_item/admin_secret/toggle_overmap_movement/execute()
	if(!(. = ..()))
		return
	var/choice = alert("Overmap movement is currently [SSshuttle.overmap_halted ? "halted" : "allowed"].","Toggle Overmap Movement",SSshuttle.overmap_halted ? "UNHALT" : "HALT","Cancel")
	if(choice == "UNHALT")
		SSshuttle.toggle_overmap(FALSE)
	else if(choice == "HALT")
		SSshuttle.toggle_overmap(TRUE)