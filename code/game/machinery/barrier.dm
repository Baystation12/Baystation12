/obj/machinery/barrier
	name = "deployable barrier"
	desc = "A deployable barrier."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrier0"
	req_access = list(access_brig)
	density = TRUE

	var/locked = FALSE
	var/health = 200

/obj/machinery/barrier/on_update_icon()
	icon_state = "barrier[locked]"

/obj/machinery/barrier/examine(mob/user, distance)
	. = ..()
	if (distance < 5)
		var/message
		switch (PERCENT(health, initial(health), 0))
			if (99 to INFINITY) message = "is in perfect condition"
			if (67 to 99) message = "has seen some wear"
			if (33 to 67) message = "is quite badly damaged"
			else message = "is almost destroyed"
		to_chat(user, "It [message].")
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
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if (I.force < 7 || (I.damtype != BRUTE && I.damtype != BURN))
			user.visible_message(
				SPAN_WARNING("\The [user] bonks \an [I] against \the [src]."),
				SPAN_WARNING("You whack \the [I] against \the [src]. Nothing happens."),
				SPAN_WARNING("You hear a soft impact!")
			)
			playsound(src, 'sound/weapons/tablehit1.ogg', 50, TRUE)
			return
		user.visible_message(
			SPAN_DANGER("\The [user] slams \an [I] against \the [src]!"),
			SPAN_DANGER("You slam \the [I] against \the [src]!"),
			SPAN_WARNING("You hear a violent impact!")
		)
		playsound(src, 'sound/weapons/smash.ogg', 50, TRUE)
		if (I.damtype == BRUTE)
			modify_health(-I.force * 0.75)
		else if (I.damtype == BURN)
			modify_health(-I.force * 0.5)
		return TRUE
	if (isWrench(I))
		if (health >= initial(health))
			to_chat(user, SPAN_WARNING("The [src]'s plating is not damaged."))
			return TRUE
		user.visible_message(
			"\The [user] starts to repair \the [src]'s plating with \an [I].",
			"You start to repair \the [src]'s plating with \the [I].",
			"You hear creaking metal."
		)
		if (do_after(user, 15 SECONDS, src, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			to_chat(user, SPAN_NOTICE("There - Good as new."))
			modify_health(initial(health) - health)
		return TRUE
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
		if (do_after(user, 15 SECONDS, src, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
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

/obj/machinery/barrier/ex_act(severity)
	if (QDELETED(src))
		return
	if (severity == 1)
		explode()
	else if (severity == 2)
		modify_health(-25)

/obj/machinery/barrier/emp_act(severity)
	if (severity > 2)
		return
	locked = FALSE
	anchored = emagged ? FALSE : locked
	update_icon()
	if (severity > 1)
		return
	sparks(3, 1, src)
	emag_act()

/obj/machinery/barrier/proc/modify_health(amount)
	health += amount
	if (health <= 0)
		explode()

/obj/machinery/barrier/proc/explode()
	if (QDELETED(src))
		return
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/item/stack/material/rods(T, rand(1, 4))
	new /obj/item/stack/material/steel(T, rand(1, 4))
	explosion(T, -1, -1, 0)
	sparks(3, 1, T)
