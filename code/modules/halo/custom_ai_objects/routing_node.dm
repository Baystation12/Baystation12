
/obj/structure/ai_routing_node
	name = "AI Routing Node"
	desc = "A node used to route AI control through the area."
	icon = 'code/modules/halo/icons/machinery/ai_routing_nodes.dmi'
	icon_state = "unscnode"
	anchored = 1
	var/list/ais_to_access_levels = list() // ai_ref = access level. This is held until another AI spends resources cleaning it.
	var/lockdown_until = 0

/obj/structure/ai_routing_node/ex_act()
	return

/obj/structure/ai_routing_node/attack_ai(var/mob/living/silicon/ai/ai)
	/*if(!(ai in ais_to_access_levels))
		to_chat(ai,"<span class = 'notice'>DEBUG OVERRIDE: MAXIMUM ACCESS INSTANTLY GAINED.</span>")
		add_ai_to_list(ai)
		modify_access_levels(ai,2) //DEBUG, REPLACE WITH CPU COST STUFF
		ai.nodes_accessed += src
	*/
	//If we don't have our accesses from this node, but there are some stored, Reaquire them.
	if(get_access_for_ai(ai) > 0)
		to_chat(ai,"<span class = 'notice'>Access credentials re-obtained from node.</span>")
		ai.nodes_accessed |= src
	to_chat(ai,"<span class = 'notice'>Current access level: [get_access_for_ai(ai)]</span>")

/obj/structure/ai_routing_node/proc/add_ai_to_list(var/mob/living/silicon/ai,var/access_override = ROUTING_ACCESS_MINOR)
	ais_to_access_levels[ai] = access_override

/obj/structure/ai_routing_node/proc/clear_ai_accesses(var/mob/ai)
	ais_to_access_levels -= ai

/obj/structure/ai_routing_node/proc/get_access_for_ai(var/mob/ai)
	var/ai_access = ais_to_access_levels[ai]
	if(isnull(ai_access))
		return 0
	return ai_access

/obj/structure/ai_routing_node/proc/modify_access_levels(var/mob/ai,var/modify_by = 1)
	if(world.time < lockdown_until)
		to_chat(ai,"<span class = 'notice'>Node is currently under lockdown. No access changes may occur.</span>")
		return 0
	var/curr_access = get_access_for_ai(ai)
	if(curr_access == 0)
		add_ai_to_list(ai,modify_by)
		return 1
	ais_to_access_levels[ai] = curr_access + modify_by
	return 1

/obj/structure/ai_routing_node/New() //We use New() because we want to make sure this happens before the terminal's Initialize()
	. = ..()
	var/area/a = loc.loc
	if(istype(a))
		a.ai_routing_node = src

/obj/structure/ai_routing_node/unsc
	icon_state = "unscnode"

/obj/structure/ai_routing_node/cov
	icon_state = "covnode"

/obj/structure/ai_routing_node/innie
	icon_state = "urfnode"
