/obj/machinery/seed_splicer
	name = "seed splicer"
	desc = "Splices together seeds."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "splicer"
	density = 1
	anchored = 1
	var/savedreagent // The saved reagent.


/obj/machinery/seed_splicer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/seeds))
		if(savedreagent)
			user << "The [src] splices the chemicals in the buffer with [O]'s DNA."
			var/obj/item/seeds/S = O
			S.splicedreagent = savedreagent
		else
			user << "There is no saved reagent in the buffer."
	if(istype(O, /obj/item/weapon/reagent_containers/))
		var/obj/item/weapon/reagent_containers/R = O
		if(savedreagent)
			user << "You overwrite the reagent data saved in the buffer of [src]."
			savedreagent = R.reagents.get_master_reagent_id()
		else
			user << "You enter the master reagent into the buffer of [src]."
			savedreagent = R.reagents.get_master_reagent_id()