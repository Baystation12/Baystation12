// Pretty much everything here is stolen from the dna scanner FYI
/obj/machinery/bodyscanner
	var/mob/living/carbon/human/occupant
	var/locked
	name = "Body Scanner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

/obj/machinery/bodyscanner/examine(mob/user)
	. = ..()
	if (occupant && user.Adjacent(src))
		occupant.examine(arglist(args))

/obj/machinery/bodyscanner/relaymove(mob/user as mob)
	..()
	src.go_out()

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.incapacitated())
		return
	src.go_out()
	add_fingerprint(usr)

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if(!user_can_move_target_inside(usr,usr))
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src

/obj/machinery/bodyscanner/proc/drop_contents()
	for(var/obj/O in (contents - component_parts))
		O.dropInto(loc)

/obj/machinery/bodyscanner/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	drop_contents()
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.dropInto(loc)
	src.occupant = null
	update_use_power(POWER_USE_IDLE)
	update_icon()
	SetName(initial(name))

/obj/machinery/bodyscanner/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/bodyscanner/attackby(obj/item/grab/normal/G, user as mob)
	if(istype(G))
		var/mob/M = G.affecting
		if(!user_can_move_target_inside(M, user))
			return
		qdel(G)
		return TRUE
	return ..()

/obj/machinery/bodyscanner/proc/user_can_move_target_inside(var/mob/target, var/mob/user)
	if(!istype(user) || !istype(target))
		return FALSE
	if(occupant)
		to_chat(user, "<span class='warning'>The scanner is already occupied!</span>")
		return FALSE
	if(target.abiotic())
		to_chat(user, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return FALSE
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return FALSE

	target.forceMove(src)
	src.occupant = target

	update_use_power(POWER_USE_ACTIVE)
	update_icon()
	drop_contents()
	SetName("[name] ([occupant])")

	src.add_fingerprint(user)
	return TRUE

/obj/machinery/bodyscanner/on_update_icon()
	if(!occupant)
		icon_state = "body_scanner_0"
	else if(stat & (BROKEN|NOPOWER))
		icon_state = "body_scanner_1"
	else
		icon_state = "body_scanner_2"

//Like grap-put, but for mouse-drop.
/obj/machinery/bodyscanner/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user) || !istype(target))
		return FALSE
	user.visible_message("<span class='notice'>\The [user] begins placing \the [target] into \the [src].</span>", "<span class='notice'>You start placing \the [target] into \the [src].</span>")
	if(!do_after(user, 30, src))
		return
	if(!user_can_move_target_inside(target, user))
		return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.dropInto(loc)
				A.ex_act(severity)
			qdel(src)
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					A.ex_act(severity)
				qdel(src)
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					A.ex_act(severity)
				qdel(src)


/obj/machinery/bodyscanner/Destroy()
	if(occupant)
		occupant.dropInto(loc)
		occupant = null
	. = ..()