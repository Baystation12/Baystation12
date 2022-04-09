/mob/observer/eye/cult
	name = "Mask of God"
	desc = "A terrible fracture of reality coinciding into a mirror to another world."

/mob/observer/eye/cult/New(var/loc, var/net)
	..()
	visualnet = net

/mob/observer/eye/cult/Destroy()
	visualnet = null
	return ..()