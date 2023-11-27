/obj/machinery/barrier
	name = "deployable barrier"
	desc = "A deployable barrier."
	icon = 'icons/obj/security_barriers.dmi'
	icon_state = "barrier0"
	req_access = list(access_brig)
	density = TRUE
	health_max = 200
	health_min_damage = 7

	var/locked = FALSE

/obj/machinery/barrier/on_update_icon()
	icon_state = "barrier[locked]"

/obj/machinery/barrier/examine(mob/user, distance)
	. = ..()
	if (locked)
		var/message = "The lights show it is locked onto \the [get_turf(src)]."
		if (emagged && distance < 3)
			message += SPAN_WARNING(" The locking clamps have other ideas.")
		to_chat(user, message)

/obj/machinery/barrier/attackby(obj/item/I, mob/user)
	if (isid(I))
		var/success = allowed(user)
		var/message = " to no effect"
		if (success)
			if (locked)
				message = ", unlocking it from \the [get_turf(src)]"
			else
				message = ", locking it onto \the [get_turf(src)]"
		user.visible_message(
			"\The [user] swipes \an [I] against \the [src].",
			"You swipe \the [I] against \the [src][message].",
			"You hear metal sliding and creaking.",
			range = 5
		)
		if (success)
			locked = !locked
			anchored = emagged ? FALSE : locked
			update_icon()
		return TRUE
	if (user.a_intent == I_HURT)
		return ..()
	if (isWelder(I))
		var/obj/item/weldingtool/W = I
		if (!W.welding)
			to_chat(user, SPAN_WARNING("\The [I] isn't turned on."))
			return TRUE
		if (!emagged)
			to_chat(user, SPAN_WARNING("\The [src]'s locking clamps are not damaged."))
			return TRUE
		user.visible_message(
			"\The [user] starts to repair \the [src]'s locking clamps with \an [I].",
			"You start to repair \the [src]'s locking clamps with \the [I].",
			"You hear a hissing flame."
		)
		if (do_after(user, (I.toolspeed * 15) SECONDS, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, SPAN_NOTICE("There - Good as new."))
			emagged = FALSE
			if (locked)
				visible_message(
					"\The [src]'s clamps engage, locking onto \the [get_turf(src)].",
					"You hear metal sliding and creaking.",
					range = 5
				)
				anchored = TRUE
			update_icon()
		return TRUE
	to_chat(user, SPAN_WARNING("You can't think of a way to use \the [I] on \the [src]."))
	return TRUE

/obj/machinery/barrier/emag_act(remaining_charges, mob/user, emag_source)
	if (user)
		var/message = emagged ? "achieving nothing new" : "fusing the locking clamps open"
		user.visible_message(
			"\The [user] swipes \an [emag_source] against \the [src].",
			"You swipe \the [emag_source] against \the [src], [message].",
			range = 5
		)
	if (emagged)
		return
	anchored = FALSE
	emagged = TRUE
	return 1

/obj/machinery/barrier/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if (severity > EMP_ACT_LIGHT)
		return
	locked = FALSE
	anchored = emagged ? FALSE : locked
	update_icon()
	if (severity > EMP_ACT_HEAVY)
		return
	sparks(3, 1, src)
	GLOB.empd_event.raise_event(src, severity)
	emag_act()

/obj/machinery/barrier/on_death()
	if (QDELETED(src))
		return
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/item/stack/material/rods(T, rand(1, 4))
	new /obj/item/stack/material/steel(T, rand(1, 4))
	explosion(T, 2, EX_ACT_LIGHT)
	sparks(3, 1, T)
