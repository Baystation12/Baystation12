
/obj/structure/ai_routing_node
	name = "AI Routing Node"
	desc = "A node used to route AI control through the area."
	anchored = 1
	var/area/our_area

/obj/structure/ai_routing_node/LateInitialize()
	. = ..()
	our_area = loc.loc