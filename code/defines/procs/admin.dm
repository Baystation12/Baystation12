proc/log_and_message_admins(var/message as text)
	log_admin(usr ? "[key_name(usr)] [message]" : "EVENT [message]")
	message_admins(usr ? "[key_name(usr)] [message]" : "EVENT [message]")

proc/admin_log_and_message_admins(var/message as text)
	log_admin(usr ? "[key_name_admin(usr)] [message]" : "EVENT [message]")
	message_admins(usr ? "[key_name_admin(usr)] [message]" : "EVENT [message]", 1)

proc/admin_attack_log(var/mob/attacker, var/mob/victim, var/attacker_message, var/victim_message, var/admin_message)
	victim.attack_log += text("\[[time_stamp()]\] <font color='orange'>[victim_message] [key_name(attacker)]</font>")
	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>[attacker_message] [key_name(victim)]</font>")

	msg_admin_attack("[key_name(attacker)] [admin_message] [key_name(victim)] (INTENT: [uppertext(attacker.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[attacker.x];Y=[attacker.y];Z=[attacker.z]'>JMP</a>)")
