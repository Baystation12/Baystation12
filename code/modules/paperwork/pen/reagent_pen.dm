/obj/item/pen/reagent
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ESOTERIC = 5)

/obj/item/pen/reagent/New()
	..()
	create_reagents(30)

/obj/item/pen/reagent/use_before(mob/living/M, mob/user)
	. = FALSE
	if (!istype(M))
		return FALSE
	if (!reagents.total_volume)
		return FALSE

	var/target_zone = user.zone_sel.selecting
	var/allow = M.can_inject(user, target_zone)
	if (!allow)
		return TRUE

	if (allow == INJECTION_PORT)
		if (M != user)
			to_chat(user, SPAN_WARNING("You begin hunting for an injection port on \the [M]'s suit!"))
		else
			to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))

		if (!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M, do_flags = DO_MEDICAL))
			return TRUE

	if (M.reagents)
		var/should_admin_log = reagents.should_admin_log()
		var/contained_reagents = reagents.get_reagents()
		var/trans = reagents.trans_to_mob(M, 30, CHEM_BLOOD)
		if (should_admin_log)
			admin_inject_log(user, M, src, contained_reagents, trans)

	if (user.a_intent == I_HURT && allow != INJECTION_PORT)
		return M.use_weapon(src, user)
	else
		to_chat(user, SPAN_WARNING("You prick \the [M] with \the [src]."))
		to_chat(M, SPAN_NOTICE("You feel a tiny prick."))
		return TRUE

/*
 * Sleepy Pens
 */
/obj/item/pen/reagent/sleepy
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\"."
	origin_tech = list(TECH_MATERIAL = 2, TECH_ESOTERIC = 5)

/obj/item/pen/reagent/sleepy/New()
	..()
	reagents.add_reagent(/datum/reagent/vecuronium_bromide, 15)
