/datum/admin_secret_item/admin_secret/traitors_and_objectives
	name = "Show current traitors and objectives"

/datum/admin_secret_item/admin_secret/traitors_and_objectives/execute(var/mob/user)
	. = ..()
	if(.)
		user.client.holder.check_antagonists()
