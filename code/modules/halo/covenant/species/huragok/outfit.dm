/decl/hierarchy/outfit/huragok_cov
	name = "Huragok"

/decl/hierarchy/outfit/huragok_cov/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	. = ..()
	var/turf/h_loc = H.loc
	var/mob/living/silicon/robot/huragok/huragok = new(h_loc)
	huragok.faction = "Covenant"
	H.mind.transfer_to(huragok)
	huragok.Login()
	qdel(H)
	return huragok
