
/obj/structure/ai_routing_node
	name = "AI Routing Node"
	desc = "A node used to route AI control through the area."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bspacerelay"
	anchored = 1
	var/list/ais_to_access_levels = list() // ai_ref = access level. This is held until another AI spends resources cleaning it.

/obj/structure/ai_routing_node/attack_ai(var/mob/ai) //TODO: CPU COSTS FOR THIS STUFF
	if(!(ai in ais_to_access_levels))
		add_ai_to_list(ai)
		modify_access_levels(ai,2) //DEBUG, REPLACE WITH CPU COST STUFF.

/obj/structure/ai_routing_node/proc/add_ai_to_list(var/mob/living/silicon/ai,var/access_override = ROUTING_ACCESS_MINOR)
	ais_to_access_levels[ai] = access_override

/obj/structure/ai_routing_node/proc/clear_ai_accesses(var/mob/ai)
	ais_to_access_levels -= ai

/obj/structure/ai_routing_node/proc/modify_access_levels(var/mob/ai,var/modify_by = 1)
	var/curr_access = ais_to_access_levels[ai]
	if(isnull(curr_access))
		add_ai_to_list(ai,modify_by)
		return
	ais_to_access_levels[ai] = curr_access + modify_by

/obj/structure/ai_routing_node/Initialize()
	. = ..()
	var/area/a = loc.loc
	if(istype(a))
		a.ai_routing_node = src