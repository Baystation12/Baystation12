/mob/living/carbon/alien/diona/get_scooped(mob/living/carbon/grabber)
	if(grabber.species.name == SPECIES_DIONA && do_merge(grabber))
		return
	else return ..()

/mob/living/carbon/alien/diona/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object

	if(istype(H) && Adjacent(H) && (usr == H) && (H.a_intent == "grab") && hat && H.HasFreeHand())
		H.put_in_hands(hat)
		H.visible_message(SPAN_DANGER("\The [H] removes \the [src]'s [hat]."))
		hat = null
		update_icons()
		return

	return ..()


/mob/living/carbon/alien/diona/use_tool(obj/item/tool, mob/user, list/click_params)
	// Hat - Equip hat
	if (istype(tool, /obj/item/clothing/head))
		if (hat)
			USE_FEEDBACK_FAILURE("\The [src] is already wearing \a [hat].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		wear_hat(tool)
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] on \the [src]."),
			SPAN_NOTICE("You put \the [tool] on \the [src].")
		)
		return TRUE

	return ..()


/mob/living/carbon/alien/diona/UnarmedAttack(atom/A)

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(istype(loc, /obj/structure/diona_gestalt))
		var/obj/structure/diona_gestalt/gestalt = loc
		return gestalt.handle_member_click(src, A)
	else

		if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
			return handle_tray_interaction(A)

		// This is super hacky. Not sure if I will leave this in for a final merge.
		// Reporting back from the future: keeping this because trying to refactor
		// seed storage to handle this cleanly would be a pain in the ass and I
		// don't want to touch that pile.

		if(istype(A, /obj/machinery/seed_storage))
			visible_message(SPAN_DANGER("\The [src] headbutts \the [A]!"))
			var/obj/machinery/seed_storage/G = A
			if(LAZYLEN(G.piles))
				var/datum/seed_pile/pile = pick(G.piles)
				var/obj/item/seeds/S = pick(pile.seeds)
				if(S)
					pile.amount -= 1
					pile.seeds  -= S
					if(pile.amount <= 0 || LAZYLEN(pile.seeds) <= 0)
						G.piles -= pile
						qdel(pile)
					S.forceMove(get_turf(G))
					G.visible_message(SPAN_NOTICE("\A [S] falls out!"))
			return
		// End superhacky stuff.

	if(a_intent == I_DISARM || a_intent == I_HELP)
		if(!wear_hat(A) && can_collect(A))
			collect(A)
			return

	if(istype(A, /mob))
		if(src != A && !gestalt_with(A))
			visible_message(SPAN_NOTICE("\The [src] butts its head into \the [A]."))
		return

	. = ..()

/mob/living/carbon/alien/diona/RangedAttack(atom/A, params)
	if((a_intent == I_HURT || a_intent == I_GRAB) && holding_item)
		setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		visible_message(SPAN_DANGER("\The [src] spits \a [holding_item] at \the [A]!"))
		var/atom/movable/temp = holding_item
		unEquip(holding_item)
		if(temp)
			temp.throw_at(A, 10, rand(3,5), src)
		return TRUE
	. = ..()

/mob/living/carbon/alien/diona/proc/handle_tray_interaction(obj/machinery/portable_atmospherics/hydroponics/tray)

	if(incapacitated())
		return

	if(!tray.seed && istype(holding_item, /obj/item/seeds))
		var/atom/movable/temp = holding_item
		unEquip(temp)
		if(temp)
			tray.plant_seed(src, temp)
		return

	if(tray.dead)
		if(tray.remove_dead(src, silent = TRUE))
			reagents.add_reagent(/datum/reagent/nutriment/glucose, rand(10,20))
			visible_message(SPAN_NOTICE("<b>\The [src]</b> chews up the dead plant, clearing \the [tray] out."), SPAN_NOTICE("You devour the dead plant, clearing \the [tray]."))
		return

	if(tray.harvest)
		if(tray.harvest(src))
			visible_message(SPAN_NOTICE("<b>\The [src]</b> harvests from \the [tray]."), SPAN_NOTICE("You harvest the contents of \the [tray]."))
		return

	if(tray.weedlevel || tray.pestlevel)
		reagents.add_reagent(/datum/reagent/nutriment/glucose, (tray.weedlevel + tray.pestlevel))
		tray.weedlevel = 0
		tray.pestlevel = 0
		visible_message(SPAN_NOTICE("<b>\The [src]</b> begins rooting through \the [tray], ripping out pests and weeds, and eating them noisily."),SPAN_NOTICE("You begin rooting through \the [tray], ripping out pests and weeds, and eating them noisily."))
		return

	if(tray.nutrilevel < 10)
		var/nutrition_cost = (10-tray.nutrilevel) * 5
		if(nutrition >= nutrition_cost)
			visible_message(SPAN_NOTICE("<b>\The [src]</b> secretes a trickle of green liquid, refilling [tray]."),SPAN_NOTICE("You secrete some nutrients into \the [tray]."))
			tray.nutrilevel = 10
			adjust_nutrition(-((10-tray.nutrilevel) * 5))
		else
			to_chat(src, SPAN_NOTICE("You haven't eaten enough to refill \the [tray]'s nutrients."))
		return

	if(tray.waterlevel < 100)
		var/nutrition_cost = Floor((100-tray.nutrilevel)/10) * 5
		if(nutrition >= nutrition_cost)
			visible_message(SPAN_NOTICE("<b>\The [src]</b> secretes a trickle of clear liquid, refilling [tray]."),SPAN_NOTICE("You secrete some water into \the [tray]."))
			tray.waterlevel = 100
		else
			to_chat(src, SPAN_NOTICE("You haven't eaten enough to refill \the [tray]'s water."))
		return

	visible_message(SPAN_NOTICE("<b>\The [src]</b> rolls around in \the [tray] for a bit."),SPAN_NOTICE("You roll around in \the [tray] for a bit."))
