/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	explosion_resistance = 5

	atmos_canpass = CANPASS_PROC

	var/list/mobs_can_pass = list(
		/mob/living/bot,
		/mob/living/carbon/slime,
		/mob/living/simple_animal/passive/mouse,
		/mob/living/silicon/robot/drone
		)
	var/airtight = FALSE

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASS_FLAG_GLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	var/mob/living/M = A
	if(istype(M))
		if(M.lying)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(A, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/attackby(obj/item/W, mob/user)
	if (isCrowbar(W))
		if (anchored)
			to_chat(user, "You have to unwrench \the [src] before before deconstruction.")
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] begins deconstructing \the [src]."),
			SPAN_NOTICE("You start deconstructing \the [src].")
			)
		if(user.do_skilled(3 SECONDS, SKILL_CONSTRUCTION, src))
			user.visible_message(
				SPAN_WARNING("\The [user] deconstructs \the [src]."),
				SPAN_WARNING("You deconstruct \the [src].")
				)
			new /obj/item/stack/material/plastic(loc, 30)
			qdel(src)
		return
	if (isScrewdriver(W))
		if (!anchored)
			to_chat(user, "You have to secure \the [src] before before adjusting the airflow.")
			return
		user.visible_message(
			SPAN_WARNING("\The [user] adjusts \the [src], [airtight ? "allowing" : "preventing"] air flow.")
			)
		if (airtight)
			clear_airtight()
			return
		become_airtight()
		return
	if (isWrench(W))
		if (airtight)
			to_chat(user,"You have to readjust the airflow before unwrenching \the [src].")
			return
		wrench_floor_bolts(user)

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (EX_ACT_DEVASTATING)
			qdel(src)
		if (EX_ACT_HEAVY)
			if (prob(50))
				qdel(src)
		if (EX_ACT_LIGHT)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/Destroy()
	if (airtight)
		clear_airtight()
	. = ..()

/obj/structure/plasticflaps/c_airblock()
	if (airtight == TRUE)
		return AIR_BLOCKED
	return FALSE

/obj/structure/plasticflaps/proc/become_airtight()
	airtight = TRUE
	var/turf/simulated/floor/T = get_turf(loc)
	if (istype(T))
		update_nearby_tiles()

/obj/structure/plasticflaps/proc/clear_airtight()
	airtight = FALSE
	var/turf/simulated/floor/T = get_turf(loc)
	if (istype(T))
		update_nearby_tiles()

/obj/structure/plasticflaps/airtight // airtight defaults to on
	airtight = TRUE

/obj/structure/plasticflaps/airtight/Initialize()
	. = ..()
	update_nearby_tiles()
