/datum/admin_secret_item/debug/toggle_harddel
	name = "Toggle Harddelete Queue"

/datum/admin_secret_item/debug/toggle_harddel/do_execute(mob/user)
	var/choice = alert(user, "Harddeletes are currently [SSgarbage.harddel_halt ? "inactive" : "active"].","Toggle Harddelete Queue", SSgarbage.harddel_halt ? "Enable" : "Disable","Cancel")
	if(choice == "Disable")
		SSgarbage.toggle_harddel_halt(TRUE)
		log_and_message_admins("disabled harddels in SSgarbage.", user)
	else if(choice == "Enable")
		SSgarbage.toggle_harddel_halt(FALSE)
		log_and_message_admins("re-enabled harddels in SSgarbage.", user)