/mob/observer/eye/cult
	name = "Mask of God"
	desc = "A terrible fracture of reality coinciding into a mirror to another world."

/mob/observer/eye/cult/New()
	..()
	visualnet = new /datum/visualnet/cultnet()

/mob/observer/eye/cult/Destroy()
	QDEL_NULL(visualnet)
	return ..()
