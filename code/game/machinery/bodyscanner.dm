// Pretty much everything here is stolen from the dna scanner FYI
/obj/machinery/bodyscanner
	var/mob/living/carbon/human/occupant
	var/locked
	name = "body scanner"
	desc = "A large full-body scanning machine that provides a complete physical assessment of a patient placed inside. Operated using an adjacent console."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "body scanner"
	machine_desc = "A full-body scanning suite that provides a complete health assessment of a patient placed inside. Requires an adjacent console to operate."

/obj/machinery/bodyscanner/examine(mob/user)
	. = ..()
	if (occupant && user.Adjacent(src))
		occupant.examine(arglist(args))

/obj/machinery/bodyscanner/relaymove(mob/user)
	..()
	go_out()
	user.visible_message(
		SPAN_NOTICE("\The [user] climbs out of \the [initial(name)]."),
		SPAN_NOTICE("You climb out of \the [initial(name)].")
	)

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.incapacitated())
		return
	usr.visible_message(
		SPAN_NOTICE("\The [usr] opens \the [src]."),
		SPAN_NOTICE("You eject \the [initial(name)]'s occupant."),
		SPAN_ITALIC("You hear a pressurized hiss, then a sound like glass creaking.")
	)
	go_out()
	add_fingerprint(usr)

/obj/machinery/bodyscanner/AltClick(mob/user)
	if (CanPhysicallyInteract(user))
		eject()
		return TRUE
	return ..()

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if (!user_can_move_target_inside(usr,usr))
		return
	usr.visible_message(
		SPAN_NOTICE("\The [usr] climbs into \the [src]."),
		SPAN_NOTICE("You climb into \the [src]."),
		SPAN_ITALIC("You hear footsteps on metal, cloth rustling, and then a pressurized hiss.")
	)
	move_target_inside(usr,usr)
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src

/obj/machinery/bodyscanner/proc/drop_contents()
	for (var/obj/O in (contents - component_parts))
		O.dropInto(loc)

/obj/machinery/bodyscanner/proc/go_out()
	if ((!( occupant ) || locked))
		return
	drop_contents()
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	occupant = null
	update_use_power(POWER_USE_IDLE)
	update_icon()
	SetName(initial(name))

/obj/machinery/bodyscanner/state_transition(singleton/machine_construction/default/new_state)
	. = ..()
	if (istype(new_state))
		updateUsrDialog()

/obj/machinery/bodyscanner/proc/move_target_inside(mob/target, mob/user)
	target.forceMove(src)
	occupant = target

	update_use_power(POWER_USE_ACTIVE)
	update_icon()
	drop_contents()
	SetName("[name] ([occupant])")
	target.remove_grabs_and_pulls()
	target.stop_pulling()
	if (user != target)
		add_fingerprint(target) //Add fingerprints of the person stuffed in.

/obj/machinery/bodyscanner/on_update_icon()
	if (!occupant)
		icon_state = "body_scanner_0"
	else if (inoperable())
		icon_state = "body_scanner_1"
	else
		icon_state = "body_scanner_2"

/obj/machinery/bodyscanner/proc/user_can_move_target_inside(mob/target, mob/user)
	if (!user.use_sanity_check(src, target))
		return FALSE
	if (!istype(target))
		to_chat(user, SPAN_WARNING("\The [src] cannot handle such a lifeform!"))
		return FALSE
	if (user.incapacitated() || !istype(user))
		return FALSE
	if (!target.simulated)
		return FALSE
	if (inoperable())
		to_chat(user, SPAN_WARNING("\The [src] is not functioning."))
		return FALSE
	if (occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied!"))
		return FALSE
	if (target.abiotic())
		to_chat(user, SPAN_WARNING("[user == target ? "You" : "[target]"] can't enter \the [src] while wearing abiotic items."))
		return FALSE
	if (target.buckled)
		to_chat(user, SPAN_WARNING("Unbuckle [user == target ? "yourself" : "\the [target]"] before attempting to [user == target ? "enter \the [src]" : "move them"]."))
		return FALSE
	if (panel_open)
		to_chat(user, SPAN_WARNING("Close the maintenance panel before attempting to place [user == target ? "yourself" : "\the [target]"] in \the [src]."))
		return FALSE
	for (var/obj/item/grab/grab in target.grabbed_by)
		if (grab.assailant == user || grab.assailant == target)
			continue
		to_chat(user, SPAN_WARNING("\The [target] is being grabbed by [grab.assailant] and can't be placed in \the [src]."))
		return FALSE
	return TRUE

/obj/machinery/bodyscanner/MouseDrop_T(mob/target, mob/user)
	if (!CanMouseDrop(target, user) || !ismob(target))
		return
	if (!user_can_move_target_inside(target, user))
		return
	if (user == target)
		user.visible_message(
			SPAN_NOTICE("\The [usr] climbs into \the [src]."),
			SPAN_NOTICE("You climb into \the [src]."),
			SPAN_ITALIC("You hear metal clanking, then a pressurized hiss.")
		)
		move_target_inside(target, user)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] begins placing \the [target] into \the [src]."),
			SPAN_NOTICE("You start placing \the [target] into \the [src].")
		)
		add_fingerprint(user)
		if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			return
		if (!user_can_move_target_inside(target, user))
			return
		move_target_inside(target,user)

/obj/machinery/bodyscanner/use_grab(obj/item/grab/grab, list/click_params)
	MouseDrop_T(grab.affecting, grab.assailant)
	return TRUE

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if (EX_ACT_DEVASTATING)
			for (var/atom/movable/A as mob|obj in src)
				A.dropInto(loc)
				A.ex_act(severity)
			qdel(src)
		if (EX_ACT_HEAVY)
			if (prob(50))
				for (var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					A.ex_act(severity)
				qdel(src)
		if (EX_ACT_LIGHT)
			if (prob(25))
				for (var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					A.ex_act(severity)
				qdel(src)


/obj/machinery/bodyscanner/Destroy()
	if (occupant)
		occupant.dropInto(loc)
		occupant = null
	. = ..()
