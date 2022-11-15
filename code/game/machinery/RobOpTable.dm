/obj/machinery/roboptable
	name = "Robotics Operating Table"
	desc = "Used for basic robotics repair."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table1"
	density = TRUE
	anchored = TRUE
	throwpass = 1
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "robotics operating table"
	machine_desc = "A well-lit surface to conduct robotics surgery. Operating tables are the only completely safe surfaces to perform operations."

	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0

/obj/machinery/roboptable/ex_act(severity)

	switch(severity)
		if(EX_ACT_DEVASTATING)
			//SN src = null
			qdel(src)
			return
		if(EX_ACT_HEAVY)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		if(EX_ACT_LIGHT)
			if (prob(25))
				src.set_density(0)

/obj/machinery/roboptable/attackby(obj/item/O, mob/user)
	if (istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(iscarbon(G.affecting) && check_table(G.affecting))
			take_victim(G.affecting,usr)
			qdel(O)
			return
	return ..()

/obj/machinery/roboptable/state_transition(singleton/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/roboptable/physical_attack_hand(mob/user)
	if(MUTATION_HULK in user.mutations)
		visible_message(SPAN_DANGER("\The [usr] destroys \the [src]!"))
		src.set_density(0)
		qdel(src)
		return TRUE

/obj/machinery/roboptable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0


/obj/machinery/roboptable/MouseDrop_T(mob/target, mob/user)
	if (target.loc != loc)
		step(target, get_dir(target, loc))
	..()

/obj/machinery/roboptable/proc/check_victim()
	if(!victim || !victim.lying || victim.loc != loc)
		victim = null

/obj/machinery/roboptable/Process()
	check_victim()

/obj/machinery/roboptable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if (C == user)
		user.visible_message("[user] climbs on \the [src].","You climb on \the [src].")
	else
		visible_message(SPAN_NOTICE("\The [C] has been laid on \the [src] by [user]."))
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.Weaken(5)
	C.dropInto(loc)
	src.add_fingerprint(user)

/obj/machinery/roboptable/MouseDrop_T(mob/target, mob/user)
	var/mob/living/M = user
	if(user.stat || user.restrained() || !iscarbon(target) || !check_table(target))
		return
	if(istype(M))
		take_victim(target,user)
	else
		return ..()

/obj/machinery/roboptable/climb_on()
	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return

	take_victim(usr,usr)

/obj/machinery/roboptable/proc/check_table(mob/living/carbon/patient as mob)
	check_victim()
	if(src.victim && get_turf(victim) == get_turf(src) && victim.lying)
		to_chat(usr, SPAN_WARNING("\The [src] is already occupied!"))
		return 0
	if(patient.buckled)
		to_chat(usr, SPAN_NOTICE("Unbuckle \the [patient] first!"))
		return 0
	return 1