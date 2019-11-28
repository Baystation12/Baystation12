/decl/hierarchy/outfit/halo_ai_smart
	name = "Smart AI"

/decl/hierarchy/outfit/halo_ai_smart/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	var/turf/h_loc = H.loc
	var/mob/living/silicon/ai/new_ai = H.AIize(0)
	var/obj/structure/ai_terminal/terminal = locate(/obj/structure/ai_terminal) in h_loc.contents
	if(terminal)
		terminal.pre_move_to_node(new_ai,1)
		new_ai.switch_to_net_by_name(terminal.inherent_network)
		terminal.apply_radio_channels(new_ai)
		new_ai.native_network = terminal.inherent_network
		new_ai.faction = terminal.spawn_faction
	new_ai.Login()
	qdel(H)
	return 1