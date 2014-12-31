/datum/vips/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the vip panel without authorization.")
		message_admins("[usr.key] has attempted to override the vip panel!")
		return


