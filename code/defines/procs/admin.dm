proc/log_and_message_admins(var/message as text)
	log_admin(usr ? "[key_name(usr)] [message]" : "EVENT [message]")
	message_admins(usr ? "[key_name(usr)] [message]" : "EVENT [message]")

proc/log_and_message_admins_many(var/list/mob/users, var/message)
	if(!users || !users.len)
		return

	var/list/user_keys = list()
	for(var/mob/user in users)
		user_keys += key_name(user)

	log_admin("[english_list(user_keys)] [message]")
	message_admins("[english_list(user_keys)] [message]")

proc/admin_log_and_message_admins(var/message as text)
	log_admin(usr ? "[key_name_admin(usr)] [message]" : "EVENT [message]")
	message_admins(usr ? "[key_name_admin(usr)] [message]" : "EVENT [message]", 1)

proc/admin_attack_log(var/mob/attacker, var/mob/victim, var/attacker_message, var/victim_message, var/admin_message)
	victim.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(attacker)] - [victim_message]</font>")
	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>[key_name(victim)] - [attacker_message]</font>")

	msg_admin_attack("[key_name(attacker)] [admin_message] [key_name(victim)] (INTENT: [uppertext(attacker.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[attacker.x];Y=[attacker.y];Z=[attacker.z]'>JMP</a>)")

proc/admin_attacker_log_many_victims(var/mob/attacker, var/list/mob/victims, var/attacker_message, var/victim_message, var/admin_message)
	if(!victims || !victims.len)
		return

	for(var/mob/victim in victims)
		admin_attack_log(attacker, victim, attacker_message, victim_message, admin_message)
