/mob/living/carbon/alien/diona/get_scooped(var/mob/living/carbon/grabber)
	if(grabber.species.name == SPECIES_DIONA && do_merge(grabber))
		return
	else return ..()

/mob/living/carbon/alien/diona/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object

	if(istype(H) && Adjacent(H) && (usr == H) && (H.a_intent == "grab") && hat && !(H.l_hand && H.r_hand))
		H.put_in_hands(hat)
		H.visible_message("<span class='danger'>\The [H] removes \the [src]'s [hat].</span>")
		hat = null
		update_icons()
		return

	return ..()

/mob/living/carbon/alien/diona/attackby(var/obj/item/weapon/W, var/mob/user)
	if(user.a_intent == I_HELP && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, "<span class='warning'>\The [src] is already wearing \the [hat].</span>")
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message("<span class='notice'>\The [user] puts \the [W] on \the [src].</span>")
		return
	return ..()

/mob/living/carbon/alien/diona/UnarmedAttack(var/atom/A)

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
			visible_message("<span class='danger'>\The [src] headbutts \the [A]!</span>")
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
					G.visible_message("<span class='notice'>\A [S] falls out!</span>")
			return
		// End superhacky stuff.

	if(a_intent == I_DISARM || a_intent == I_HELP)
		if(!wear_hat(A) && can_collect(A))
			collect(A)
			return

	if(istype(A, /mob))
		if(src != A && !gestalt_with(A))
			visible_message("<span class='notice'>\The [src] butts its head into \the [A].</span>")
		return

	. = ..()

/mob/living/carbon/alien/diona/RangedAttack(atom/A, var/params)
	if((a_intent == I_HURT || a_intent == I_GRAB) && holding_item)
		setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		visible_message("<span class='danger'>\The [src] spits \a [holding_item] at \the [A]!</span>")
		var/atom/movable/temp = holding_item
		unEquip(holding_item)
		if(temp)
			temp.throw_at(A, 10, rand(3,5), src)
		return TRUE
	. = ..()

/mob/living/carbon/alien/diona/proc/handle_tray_interaction(var/obj/machinery/portable_atmospherics/hydroponics/tray)

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
			visible_message("<span class='notice'><b>\The [src]</b> chews up the dead plant, clearing \the [tray] out.</span>", "<span class='notice'>You devour the dead plant, clearing \the [tray].</span>")
		return

	if(tray.harvest)
		if(tray.harvest(src))
			visible_message("<span class='notice'><b>\The [src]</b> harvests from \the [tray].</span>", "<span class='notice'>You harvest the contents of \the [tray].</span>")
		return

	if(tray.weedlevel || tray.pestlevel)
		reagents.add_reagent(/datum/reagent/nutriment/glucose, (tray.weedlevel + tray.pestlevel))
		tray.weedlevel = 0
		tray.pestlevel = 0
		visible_message("<span class='notice'><b>\The [src]</b> begins rooting through \the [tray], ripping out pests and weeds, and eating them noisily.</span>","<span class='notice'>You begin rooting through \the [tray], ripping out pests and weeds, and eating them noisily.</span>")
		return

	if(tray.nutrilevel < 10)
		var/nutrition_cost = (10-tray.nutrilevel) * 5
		if(nutrition >= nutrition_cost)
			visible_message("<span class='notice'><b>\The [src]</b> secretes a trickle of green liquid, refilling [tray].</span>","<span class='notice'>You secrete some nutrients into \the [tray].</span>")
			tray.nutrilevel = 10
			adjust_nutrition(-((10-tray.nutrilevel) * 5))
		else
			to_chat(src, "<span class='notice'>You haven't eaten enough to refill \the [tray]'s nutrients.</span>")
		return

	if(tray.waterlevel < 100)
		var/nutrition_cost = Floor((100-tray.nutrilevel)/10) * 5
		if(nutrition >= nutrition_cost)
			visible_message("<span class='notice'><b>\The [src]</b> secretes a trickle of clear liquid, refilling [tray].</span>","<span class='notice'>You secrete some water into \the [tray].</span>")
			tray.waterlevel = 100
		else
			to_chat(src, "<span class='notice'>You haven't eaten enough to refill \the [tray]'s water.</span>")
		return

	visible_message("<span class='notice'><b>\The [src]</b> rolls around in \the [tray] for a bit.</span>","<span class='notice'>You roll around in \the [tray] for a bit.</span>")
