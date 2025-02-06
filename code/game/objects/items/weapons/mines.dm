/obj/item/mine
	name = "template mine package"
	desc = "A T-47 universal template munition. Manufactured by independent explosive arms foundries with old designs, \
			and famously used during the Gaia Conflict by all sides. Currently still in circulation due to its robustness and flexibility. \
			Often used by inserting a grenade, and then deploying the mine within the package."

	w_class = ITEM_SIZE_LARGE
	icon = 'icons/obj/weapons/mines.dmi'
	icon_state = "mine"
	item_state = "syringe_kit"

	/// Grenade object that's fit into the template.
	var/obj/item/grenade/grenade = null
	/// Object to keep a track of items used to keep the pressure on a mine.
	var/obj/item/pressure_item = null
	/// Boolean. If set, the mine is ready to blow. Naturally, can only be set if anchored.
	var/armed = FALSE
	/// Boolean. If set, when something unoverlaps. It will call activate().
	var/primed = FALSE
	/// Boolean. If set, the mine is already triggered and won't trigger again. Used for both preventing duplicate activations, for mines which have a delayed or ongoing effect, or for uselessness.
	var/activated = FALSE


/obj/item/mine/use_tool(obj/item/I, mob/user)
	if (activated)
		FEEDBACK_FAILURE(user, "\The [src] is useless, now.")
		return TRUE // Oops, too late.

	if (istype(I, /obj/item/grenade))
		if (!grenade)
			if(!user.unEquip(I, src))
				FEEDBACK_UNEQUIP_FAILURE(user, I)
				return TRUE
			playsound(src, 'sound/items/breaker_flip.ogg', 50)
			grenade = I
			update_icon()
			return TRUE
		FEEDBACK_FAILURE(user, "\The [grenade] is attached to \the [src], already.")
		return TRUE

	if (isMultitool(I))
		var/turf/u_location = get_turf(user)
		var/turf/location = get_turf(src)
		if (armed)
			if (location == u_location)
				if (!user.skill_check(SKILL_ELECTRICAL, SKILL_MASTER))
					FEEDBACK_FAILURE(user, "You need to keep the pressure on \the [src]!")
					return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] begins to disarm \the [src]."),
				SPAN_NOTICE("You begin to disarm \the [src]. Let's hope you know what you're doing.")
			)
			if (!user.do_skilled(2 SECONDS, SKILL_ELECTRICAL, src, 0.2, DO_DEFAULT))
				return TRUE
			if (!(prob(20 * user.get_skill_value(SKILL_ELECTRICAL)) || prob(40 * user.get_skill_value(SKILL_DEVICES))))
				user.visible_message(
					SPAN_DANGER("\The [user] fucked up!"),
					SPAN_DANGER("You fucked up!")
				)
				activate(user)
				return TRUE
			toggle_arm(user)
			return TRUE
		else
			if (!location || !u_location)
				return TRUE
			if (!isturf(loc))
				FEEDBACK_FAILURE(user, "You need to put \the [src] down to plant it!")
				return TRUE
			if (isspaceturf(location))
				FEEDBACK_FAILURE(user, "You can't plant \the [src] in space!")
				return TRUE
			if (location == u_location)
				FEEDBACK_FAILURE(user, "You need to step off of \the [src] to arm it!")
				return TRUE
			user.visible_message(
			SPAN_NOTICE("\The [user] begins to arm \the [src]."),
			SPAN_NOTICE("You begin to arm \the [src].")
			)
			if (!user.do_skilled(2 SECONDS, SKILL_ELECTRICAL, src, 0.3, DO_DEFAULT))
				return TRUE
			toggle_arm(user)
			return TRUE

	return ..()


/obj/item/mine/attack_hand(mob/user)
	if (armed)
		return ..()

	if (activated)
		return ..()

	if (grenade)
		playsound(src, 'sound/items/breaker_flip.ogg', 50)

		user.put_in_hands(grenade)
		grenade = null
		update_icon()

		return TRUE

	return ..()


/obj/item/mine/proc/toggle_arm(mob/user)
	armed = !armed

	if (armed)
		visible_message(
			SPAN_WARNING("\The [src] is armed!")
		)
	else
		visible_message(
			SPAN_NOTICE("\The [src] is disarmed.")
		)

	name = armed ? "template mine" : initial(name)
	anchored = armed ? TRUE : FALSE
	armed = armed ? TRUE : FALSE

	playsound(loc, 'sound/items/scrape_clunk.ogg', 60)
	update_icon()


/obj/item/mine/Crossed(atom/movable/AM)
	if (!ismob(AM) && !isitem(AM))
		return

	if (isghost(AM))
		return

	if (primed)
		return

	if (!armed)
		return

	playsound(loc, 'sound/items/metal_clicking_14.ogg', 75)

	if (activated)
		return

	if (isitem(AM))
		var/obj/item/I = AM
		if (I.w_class > ITEM_SIZE_SMALL)
			visible_message(
				SPAN_NOTICE("\The [I] is keeping the pressure on \the [src].")
			)
			pressure_item = I

	if (ismob(AM))
		var/mob/M = AM
		visible_message(
			SPAN_WARNING("[M.name] steps on \the [src], keeping the pressure on!")
		)

	primed = TRUE
	update_icon()


/obj/item/mine/Uncrossed(atom/movable/AM)
	if (!ismob(AM) && !isitem(AM))
		return

	if (isghost(AM))
		return

	if (!primed)
		return

	if (!armed)
		return

	if (pressure_item)
		if (AM != pressure_item)
			return

		visible_message(
			SPAN_NOTICE("\The [pressure_item] is no longer keeping the pressure on \the [src].")
		)

		pressure_item = null

	playsound(loc, 'sound/items/metal_clicking_12.ogg', 75)

	if (!activated)
		activate(AM)


/obj/item/mine/bullet_act(obj/item/projectile/P, def_zone)
	if (!armed)
		return FALSE

	if (prob(P.original == src ? 30 : 10)) // Small target, hard to hit on purpose, even harder to hit on accident
		if (!activated)
			activate()
		return FALSE
	return TRUE


/obj/item/mine/ex_act(severity, turf_breaker)
	if (!armed)
		return

	if (!activated)
		activate()


/obj/item/mine/emp_act(severity)
	. = ..()

	if (!activated)
		visible_message(
			SPAN_WARNING("\The [src] quietly fizzles away!")
		)

		activated = TRUE
		update_icon()


/obj/item/mine/use_weapon(obj/item/weapon, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)

	if (!armed)
		return FALSE

	user.visible_message(
		SPAN_WARNING("\The [user] hits \the [src] with \a [weapon]!"),
		SPAN_WARNING("You hit \the [src] with \the [weapon]. This was a bad idea.")
	)
	if (!activated)
		activate(user)
	return TRUE


/obj/item/mine/proc/activate(mob/victim)
	if (victim)
		if (ismob(victim))
			msg_admin_attack("[victim.name] ([victim.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[victim.x];Y=[victim.y];Z=[victim.z]'>JMP</a>)")
		else
			victim = null

	visible_message(
		SPAN_DANGER("\The [src] activates!")
	)

	primed = FALSE

	if (grenade)
		activated = TRUE

		grenade.det_time = 1
		grenade.activate(victim)

	update_icon()


/obj/item/mine/examine(mob/user)
	. = ..()

	if (!user.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
		return

	to_chat(user, SPAN_NOTICE("It clearly operates on an electronic pressure-sensor mechanism. Once the circuit is complete, lifting the pressure will cause activation."))
	to_chat(user, SPAN_NOTICE("The wire-panel is open, exposing the wires."))
	if (activated)
		to_chat(user, SPAN_NOTICE("It looks useless."))

	if (grenade)
		to_chat(user, SPAN_NOTICE("It has \a [grenade] attached to it."))

		if (armed)
			to_chat(user, SPAN_WARNING("It is armed!"))

		if (primed)
			to_chat(user, SPAN_WARNING("It is primed!"))


/obj/item/mine/on_update_icon()
	. = ..()

	ClearOverlays()

	if (armed)
		icon_state = "[initial(icon_state)]-armed"

		if (primed)
			AddOverlays("[initial(icon_state)]-primed")
		else
			CutOverlays("[initial(icon_state)]-primed")
		if (activated)
			AddOverlays("[initial(icon_state)]-activated")
		else
			CutOverlays("[initial(icon_state)]-activated")

		return

	icon_state = "[initial(icon_state)]"

	if (grenade)
		AddOverlays("[initial(icon_state)]-grenade")
	else
		CutOverlays("[initial(icon_state)]-grenade")


/obj/item/mine/preset
	abstract_type = /obj/item/mine/preset

	/// Type of grenade the template mine comes preset with.
	var/grenade_type = null
	armed = TRUE


/obj/item/mine/preset/Initialize()
	. = ..()

	name = "template mine"

	if (ispath(grenade_type))
		grenade = new grenade_type
		contents += grenade

	update_icon()


/obj/item/mine/preset/frag
	grenade_type = /obj/item/grenade/frag


/obj/item/mine/preset/hy
	grenade_type = /obj/item/grenade/frag/high_yield


/obj/item/mine/preset/makeshift
	grenade_type = /obj/item/grenade/frag/makeshift


/obj/item/mine/preset/smoke
	grenade_type = /obj/item/grenade/smokebomb


/obj/item/mine/preset/emp
	grenade_type = /obj/item/grenade/empgrenade


/obj/item/mine/preset/sm
	grenade_type = /obj/item/grenade/supermatter
