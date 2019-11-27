/decl/hierarchy/outfit/halo_ai_smart
	name = "Smart AI"

/decl/hierarchy/outfit/halo_ai_smart/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	var/mob/living/silicon/ai/new_ai = H.AIize(0)
	qdel(H)
	return 1