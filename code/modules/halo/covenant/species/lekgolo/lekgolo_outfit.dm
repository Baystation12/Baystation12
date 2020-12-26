/decl/hierarchy/outfit/mgalekgolo_cov
	name = "Mgalekgolo"

/decl/hierarchy/outfit/mgalekgolo_cov/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	. = ..()
	var/turf/h_loc = H.loc
	var/mob/living/simple_animal/mgalekgolo/mgalekgolo = new(h_loc)
	mgalekgolo.faction = "Covenant"
	mgalekgolo.ckey = H.ckey
	mgalekgolo.Login()
	qdel(H)
	return mgalekgolo
