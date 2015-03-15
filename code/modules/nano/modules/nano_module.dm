/obj/nano_module/proc/can_still_topic()
	return CanUseTopic(usr, list(), default_state) == STATUS_INTERACTIVE

/obj/nano_module/proc/is_admin(var/mob/user)
	return check_rights(R_ADMIN, 0, user) != 0
