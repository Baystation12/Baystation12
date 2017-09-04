/mob
	var/datum/mob_lite/last_attacker_ = null
	var/datum/mob_lite/last_attacked_ = null
	var/mob/attack_logs_ = list()

/proc/log_and_message_admins(var/message as text, var/mob/user = usr, var/turf/location)
	var/turf/T = location ? location : (user ? get_turf(user) : null)
	message = append_admin_tools(message, user, T)

	log_admin(user ? "[key_name(user)] [message]" : "EVENT [message]")
	message_admins(user ? "[key_name_admin(user)] [message]" : "EVENT [message]")

/proc/log_and_message_staff(var/message as text, var/mob/user = usr, var/turf/location)
	var/turf/T = location ? location : (user ? get_turf(user) : null)
	message = append_admin_tools(message, user, T)

	log_admin(user ? "[key_name(user)] [message]" : "EVENT [message]")
	message_staff(user ? "[key_name_admin(user)] [message]" : "EVENT [message]")

/proc/log_and_message_admins_many(var/list/mob/users, var/message)
	if(!users || !users.len)
		return

	var/list/user_keys = list()
	for(var/mob/user in users)
		user_keys += key_name(user)

	log_admin("[english_list(user_keys)] [message]")
	message_admins("[english_list(user_keys)] [message]")

/proc/admin_attacker_log(var/mob/attacker, var/attacker_message)
	if(!attacker)
		EXCEPTION("No attacker was supplied.")
	admin_attack_log(attacker, null, attacker_message, null, attacker_message)

/proc/admin_victim_log(var/mob/victim, var/victim_message)
	if(!victim)
		EXCEPTION("No victim was supplied.")
	admin_attack_log(null, victim, null, victim_message, victim_message)

/proc/admin_attack_log(var/mob/attacker, var/mob/victim, var/attacker_message, var/victim_message, var/admin_message)
	if(!(attacker || victim))
		EXCEPTION("Neither attacker or victim was supplied.")
	if(!store_admin_attack_log(attacker, victim))
		return

	var/turf/attack_location
	var/intent = "(INTENT: N/A)"
	if(attacker)
		intent = "(INTENT: [uppertext(attacker.a_intent)])"
		if(victim)
			attacker.attack_logs_ += text("\[[time_stamp()]\] <font color='red'>[key_name(victim)] - [attacker_message] [intent]</font>")
		else
			attacker.attack_logs_ += text("\[[time_stamp()]\] <font color='red'>[attacker_message] [intent]</font>")
		attacker.last_attacked_ = mob_repository.get_lite_mob(victim)
		attack_location = get_turf(attacker)
	if(victim)
		if(attacker)
			victim.attack_logs_ += text("\[[time_stamp()]\] <font color='orange'>[key_name(attacker)] - [victim_message] [intent]</font>")
		else
			victim.attack_logs_ += text("\[[time_stamp()]\] <font color='orange'>[victim_message]</font>")
		victim.last_attacker_ = mob_repository.get_lite_mob(attacker)
		if(!attack_location)
			attack_location = get_turf(victim)

	attack_log_repository.store_attack_log(attacker, victim, admin_message)

	if(!notify_about_admin_attack_log(attacker, victim))
		return

	var/full_admin_message
	if(attacker && victim)
		full_admin_message = "[key_name(attacker)] [admin_message] [key_name(victim)] (INTENT: [attacker? uppertext(attacker.a_intent) : "N/A"])"
	else if(attacker)
		full_admin_message = "[key_name(attacker)] [admin_message] (INTENT: [attacker? uppertext(attacker.a_intent) : "N/A"])"
	else
		full_admin_message = "[key_name(victim)] [admin_message]"
	full_admin_message = append_admin_tools(full_admin_message, attacker||victim, attack_location)
	msg_admin_attack(full_admin_message)

// Only store attack logs if any of the involved subjects have (had) a client
/proc/store_admin_attack_log(var/mob/attacker, var/mob/victim)
	if(attacker && attacker.ckey)
		return TRUE
	if(victim && victim.ckey)
		return TRUE
	return FALSE

// Only notify admins if all involved subjects have (had) a client
/proc/notify_about_admin_attack_log(var/mob/attacker, var/mob/victim)
	if(attacker && victim)
		return attacker.ckey && victim.ckey
	if(attacker)
		return attacker.ckey
	if(victim)
		return victim.ckey
	return FALSE

/proc/admin_attacker_log_many_victims(var/mob/attacker, var/list/mob/victims, var/attacker_message, var/victim_message, var/admin_message)
	if(!victims || !victims.len)
		return

	for(var/mob/victim in victims)
		admin_attack_log(attacker, victim, attacker_message, victim_message, admin_message)

/proc/admin_inject_log(mob/attacker, mob/victim, obj/item/weapon, reagents, amount_transferred, violent=0)
	if(violent)
		violent = "violently "
	else
		violent = ""
	admin_attack_log(attacker,
	                 victim,
	                 "used \the [weapon] to [violent]inject - [reagents] - [amount_transferred]u transferred",
	                 "was [violent]injected with \the [weapon] - [reagents] - [amount_transferred]u transferred",
	                 "used \the [weapon] to [violent]inject [reagents] ([amount_transferred]u transferred) into")

/proc/append_admin_tools(var/message, var/mob, var/turf/location)
	if(location)
		message = message + " (<a HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>LOC</a>)"
	if(mob)
		message = message + " (<a HREF='?_src_=holder;adminplayerobservefollow=\ref[mob]'>MOB</a>)"
	return message
