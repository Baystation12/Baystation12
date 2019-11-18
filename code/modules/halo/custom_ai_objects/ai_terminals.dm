
/obj/structure/ai_terminal
	var/held_ai = null
	var/allow_remote_moveto = 1
	var/inherent_networks = list() //All camera nets we can access.

	var/inherent_nodes = list()// This should only really be fully populated for roundstart terminals, aka the ones AI cores spawn.
	//Otherwise this should just contain the node in it's own area.

/obj/structure/ai_terminal/LateInitialize()
	. = ..()
	var/area_node = locate(/obj/structure/ai_routing_node) in loc.loc.contents
	if(area_node)
		inherent_nodes += area_node

/obj/structure/ai_terminal/attack_ai(var/mob/living/silicon/ai/user)
	if(istype(user))
		return
	if(user.our_terminal != src && held_user != user)
		var/obj/structure/ai_terminal/old_term = user.our_terminal
		if(check_move_to(user) && !isnull(old_term))
			old_term.ai_exit_node(user)
			pre_move_to_node(user)
	if(held_ai == user)
		held_ai.cancel_camera()

/obj/structure/ai_terminal/proc/ai_exit_node(var/mob/living/silicon/ai/ai)
	if(ai == held_ai)
		held_ai = null
		contents -= ai
		ai.loc = null

/obj/structure/ai_terminal/proc/pre_move_to_node(var/mob/living/silicon/ai/ai)
	if(!(ai.network in inherent_networks || ai.native_network in inherent_networks))
		var/confirm = alert("This network holds no relation to any of your old networks. Switching will cause loss of previous node access.","Confirm Switch","Yes","No")
		if(confirm == "No")
			return
	move_to_node(ai)

/obj/structure/ai_terminal/proc/check_move_to(var/mob/ai)
	if(!allow_remote_moveto)
		to_chat(ai,"<span class = 'danger'>External access attempt failed. Terminal does not accept external connections.</span>")
		if(held_ai)
			to_chat(held_ai,"<span class = 'danger'>External access attempt detected. Terminal halted external connection.</span>")
		return 0
	if(held_ai)
		to_chat(ai,"<span class = 'danger'>External access attempt failed. Terminal is currently occupied by an intelligence.</span>")
		to_chat(held_ai,"<span class = 'danger'>External access attempt detected. Presence has been detected in this terminal.</span>")
		return 0
	return 1

/obj/structure/ai_terminal/proc/move_to_node(var/mob/ai)
	held_ai = ai
	contents += ai

