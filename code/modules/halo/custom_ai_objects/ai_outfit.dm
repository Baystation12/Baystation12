/decl/hierarchy/outfit/halo_ai_smart
	name = "Smart AI"

/decl/hierarchy/outfit/halo_ai_smart/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	var/mob/living/silicon/ai/new_ai = new(H.loc,safety = 1)
	new_ai.faction = H.faction
	new_ai.ckey = H.ckey
	qdel(H)
	return 1