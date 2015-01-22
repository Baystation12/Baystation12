#define RULES_FILE "config/rules.html"

/client/proc/fules(mob/living/M as mob in mob_list)
	set category = "Admin"
	set name = "Force rules"
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(!mob)
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				M << browse(file(RULES_FILE), "window=rules;size=480x320")

				M << "<b><font color= red>You have been forced to read the rules by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
				message_admins("\blue [key_name_admin(usr)] forced [M.name]/[M.ckey] to read our rules!")
				log_admin("[key_name(usr)] forced [M.name]/[M.ckey] to read our rules!")



#undef RULES_FILE