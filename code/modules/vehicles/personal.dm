/**
 * Vehicle subtype to allow registering vehicles to owners via name/ID card.
 */
/obj/vehicle/personal
	name = "personal vehicle"

	locked = FALSE
	var/registered_name = null // For access checking stuff. Wheelchair is registered via ID similar to personal lockers.


/**
 * Allows toggling the lock state based on ID card access
 */
/obj/vehicle/personal/proc/toggle_lock(mob/user, obj/item/weapon/card/id/id_card = null)
	if (!istype(user) || !CanPhysicallyInteract(user))
		return FALSE

	add_fingerprint(user)

	if (!user.IsAdvancedToolUser())
		to_chat(user, FEEDBACK_YOU_LACK_DEXTERITY)
		return FALSE

	if (!has_power())
		to_chat(user, SPAN_WARNING("\The [src] is not powered and doesn't respond."))
		return FALSE

	if (!id_card)
		id_card = user.GetIdCard()

	if (can_toggle_lock(id_card))
		if (!registered_name)
			return register_name(id_card, user, TRUE)

		locked = !locked
		visible_message(SPAN_NOTICE("\The [src] has been [locked ? "locked" : "unlocked"] by \the [user]."), range = 3)
		return TRUE
	else
		to_chat(user, FEEDBACK_ACCESS_DENIED)
		return FALSE


/obj/vehicle/personal/proc/toggle_lock_verb()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Vehicle Lock (\The [src])"

	return toggle_lock(usr)


/**
 * Checks if the ID card can toggle the lock
 */
/obj/vehicle/personal/proc/can_toggle_lock(obj/item/weapon/card/id/id_card)
	if (emagged)
		return FALSE
	return istype(id_card) && id_card.registered_name && (!registered_name || (registered_name == id_card.registered_name))


/**
 * Handles registration of the vehicle
 */
/obj/vehicle/personal/proc/register_name(obj/item/weapon/card/id/id_card, mob/user = null, feedback = FALSE)
	if (!istype(id_card))
		return FALSE

	if (emagged)
		if (feedback)
			to_chat(user, FEEDBACK_ACCESS_DENIED)
		return FALSE

	if (registered_name)
		if (feedback)
			to_chat(user, SPAN_WARNING("\The [src] is already registered to the name '[registered_name]'."))
		return FALSE

	registered_name = id_card.registered_name
	if (feedback)
		to_chat(user, SPAN_NOTICE("You register \the [src] to the name '[registered_name]'"))
	name = "[initial(name)] ([registered_name])"
	visible_message(SPAN_NOTICE("\The [src] chimes as it registers itself to a new user."))
	return TRUE


/**
 * Handles de-registration of the vehicle
 */
/obj/vehicle/personal/proc/unregister_name(mob/user = null, feedback = FALSE)
	if (emagged)
		if (user && feedback)
			to_chat(user, FEEDBACK_ACCESS_DENIED)
		return FALSE

	if (!registered_name)
		if (user && feedback)
			to_chat(user, SPAN_WARNING("\The [src] is not currently registered."))
		return FALSE

	registered_name = null
	locked = FALSE
	name = initial(name)
	visible_message(SPAN_NOTICE("\The [src] chimes as its registration is reset and its panel unlocks."))
	return TRUE



/obj/vehicle/personal/attackby(obj/item/weapon/W, mob/user)
	if (istype(W, /obj/item/weapon/card/id))
		toggle_lock(user, W)
		return

	..()


/obj/vehicle/personal/emag_act(remaining_charges, mob/user)
	if (!emagged)
		if (registered_name || locked)
			unregister_name()
		to_chat(user, SPAN_WARNING("You reset and bypass \the [src]'s registration system, permanently unlocking it, and override the collision safety mechanisms."))
		emagged = TRUE
		return TRUE


/obj/vehicle/personal/Bump(atom/A)
	if (load && istype(load, /mob/living/carbon/human) && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		D.Bumped(load)

	if (emagged && istype(A, /mob/living))
		apply_impact_damage(A)

	..()


/obj/vehicle/personal/RunOver(mob/living/carbon/human/H)
	if (emagged)
		apply_impact_damage(H)

		if (istype(load, /mob/living))
			var/mob/living/L = load
			L.visible_message(
				SPAN_DANGER("\The [L] drives \the [src] over \the [H]!"),
				SPAN_DANGER("You drive \the [src] over \the [H]!")
			)
			admin_attack_log(L, H,
				"Ran over with \the [src]",
				"Was run over with \the [src]",
				"Ran over with \the [src]"
			)
		else
			visible_message(SPAN_DANGER("\The [src] drives over \the [H]!"))
			admin_attack_log(
				victim = H,
				victim_message = "Was run over with \the [src]",
				admin_message = "Was run over with \the [src]"
			)


/obj/vehicle/personal/proc/apply_impact_damage(mob/living/L)
	var/list/parts = list(BP_HEAD, BP_CHEST, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	if (L.incapacitated(INCAPACITATION_KNOCKDOWN))
		L.apply_effects(2, 2)

	for(var/i = 0, i < rand(1,5), i++)
		var/def_zone = pick(parts)
		L.apply_damage(rand(5,10), BRUTE, def_zone)
