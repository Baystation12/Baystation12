/obj/machinery/barrier
	name = "deployable barrier"
	desc = "A deployable barrier."
	icon = 'icons/obj/objects.dmi'
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


/obj/machinery/barrier/use_tool(obj/item/tool, mob/user, list/click_params)
	// ID Card - Toggle barrier lock and anchoring
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		var/id_name = GET_ID_CARD_NAME(tool, id)
		if (!check_access(id) || emagged)
			to_chat(user, SPAN_WARNING("\The [src] refuses [id_name]."))
			return TRUE
		locked = !locked
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [locked ? "locks" : "unlocks"] \the [src] with \a [tool]."),
			SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src] with [id_name]."),
			SPAN_ITALIC("You hear metal sliding and creaking."),
			5
		)
		return TRUE

	// Welding Tool - Repair emag damage
	if (isWelder(tool))
		if (!emagged)
			to_chat(user, SPAN_WARNING("\The [src]'s locking clamps are not damaged."))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(user, 5))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts repairing \the [src]'s locking clamps with \a [tool]."),
			SPAN_NOTICE("You start repairing \the [src]'s locking clamps with \the [tool].")
		)
		if (!do_after(user, 15 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!emagged)
			to_chat(user, SPAN_WARNING("\The [src]'s locking clamps are not damaged."))
			return TRUE
		if (!welder.remove_fuel(5, user))
			return TRUE
		emagged = FALSE
		if (locked)
			anchored = TRUE
			visible_message(
				SPAN_WARNING("\The [src]'s clamps engage, locking onto \the [get_turf(src)]."),
				SPAN_ITALIC("You hear metal sliding and creaking."),
				5
			)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs \the [src]'s locking clamps with \a [tool]."),
			SPAN_NOTICE("You repair \the [src]'s locking clamps with \the [tool], using 5 units of fuel.")
		)
		return TRUE

	return ..()


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
	if (severity > EMP_ACT_LIGHT)
		return
	locked = FALSE
	anchored = emagged ? FALSE : locked
	update_icon()
	if (severity > EMP_ACT_HEAVY)
		return
	sparks(3, 1, src)
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
