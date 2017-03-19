/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/New()
	..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break
//	spawn(100) //Wont the MC just call this process() before and at the 10 second mark anyway?
//		process()

/obj/machinery/optable/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				src.set_density(0)
		else
	return

/obj/machinery/optable/attack_hand(mob/user as mob)
	if (HULK in usr.mutations)
		visible_message("<span class='danger'>\The [usr] destroys \the [src]!</span>")
		src.set_density(0)
		qdel(src)
	return

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0


/obj/machinery/optable/MouseDrop_T(obj/O as obj, mob/user as mob)

	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.lying)
			src.victim = M
			icon_state = M.pulse() ? "table2-active" : "table2-idle"
			return 1
	src.victim = null
	icon_state = "table2-idle"
	return 0

/obj/machinery/optable/process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if (C == user)
		user.visible_message("[user] climbs on \the [src].","You climb on \the [src].")
	else
		visible_message("<span class='notice'>\The [C] has been laid on \the [src] by [user].</span>", 3)
	C.resting = 1
	C.dropInto(loc)
	for(var/obj/O in src)
		O.dropInto(loc)
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
		icon_state = H.pulse() ? "table2-active" : "table2-idle"
	else
		icon_state = "table2-idle"

/obj/machinery/optable/MouseDrop_T(mob/target, mob/user)

	var/mob/living/M = user
	if(user.stat || user.restrained() || !check_table(user) || !iscarbon(target))
		return
	if(istype(M))
		take_victim(target,user)
	else
		return ..()

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return

	take_victim(usr,usr)

/obj/machinery/optable/attackby(obj/item/weapon/W as obj, mob/living/carbon/user as mob)
	if (istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(iscarbon(G.affecting) && check_table(G.affecting))
			take_victim(G.affecting,usr)
			qdel(W)
			return

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient as mob)
	check_victim()
	if(src.victim && get_turf(victim) == get_turf(src) && victim.lying)
		to_chat(usr, "<span class='warning'>\The [src] is already occupied!</span>")
		return 0
	if(patient.buckled)
		to_chat(usr, "<span class='notice'>Unbuckle \the [patient] first!</span>")
		return 0
	return 1
