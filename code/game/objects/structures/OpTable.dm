/obj/structure/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "optable"
	density = 1
	anchored = 1
	var/mob/living/carbon/human/patient = null
	var/obj/machinery/computer/operating/computer = null


/obj/structure/optable/New()
	for(var/dir in cardinal)
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if(computer)
			computer.table = src
			break


/obj/structure/optable/proc/check_patient()
	var/mob/M = locate(/mob/living/carbon/human, loc)
	if(M)
		if(M.resting)
			patient = M
			return 1
	else
		patient = null
		return 0


/obj/structure/optable/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(ismob(G.affecting))
			var/mob/M = G.affecting
			M.resting = 1
			M.loc = loc
			visible_message("<span class='notice'>[M] has been laid on [src] by [user].</span>")
			patient = M
			check_patient()
			del(W)
			return