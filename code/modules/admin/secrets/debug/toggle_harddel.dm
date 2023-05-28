/datum/admin_secret_item/debug/toggle_harddel
	name = "Toggle Harddelete Queue"

/datum/admin_secret_item/debug/toggle_harddel/do_execute(mob/user)
	SSgarbage.pause_deletion_queue = !SSgarbage.pause_deletion_queue
	log_and_message_admins("deletion queue [SSgarbage.pause_deletion_queue ? "paused" : "enabled"]", user)
