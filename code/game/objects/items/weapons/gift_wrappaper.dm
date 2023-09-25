/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/gifts.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	randpixel = 10

/obj/item/a_gift/New()
	..()
	if(w_class > 0 && w_class < ITEM_SIZE_HUGE)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/a_gift/ex_act()
	qdel(src)
	return

/obj/effect/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	to_chat(user, SPAN_WARNING("You can't move."))


/obj/effect/spresent/use_tool(obj/item/tool, mob/user, list/click_params)
	// Wirecutters - Open the present
	if (isWirecutter(tool))
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts open \the [src] with \a [tool]."),
			SPAN_NOTICE("You cut open \the [src] with \the [tool].")
		)
		for (var/mob/M in src) //Should only be one but whatever.
			M.dropInto(loc)
			if (M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
		qdel(src)
		return TRUE

	return ..()


/obj/item/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/storage/wallet,
		/obj/item/storage/photo_album,
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/backpack/holding,
		/obj/item/storage/belt/champion,
		/obj/item/pickaxe/silver,
		/obj/item/pen/invisible,
		/obj/item/lipstick/random,
		/obj/item/grenade/smokebomb,
		/obj/item/carvable/corncob,
		/obj/item/contraband/poster,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/bikehorn,
		/obj/item/beach_ball,
		/obj/item/beach_ball/holoball,
		/obj/item/toy/water_balloon,
		/obj/item/toy/blink,
		/obj/item/toy/crossbow,
		/obj/item/gun/projectile/revolver/capgun,
		/obj/item/toy/katana,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/powerloader,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/device/paicard,
		/obj/item/device/synthesized_instrument/violin,
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/accessory/horrible,
		/obj/item/storage/box/large/foam_gun,
		/obj/item/storage/box/large/foam_gun/burst,
		/obj/item/storage/box/large/foam_gun/revolver)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)

/*
 * Wrapping Paper and Gifts
 */

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/gifts.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = ITEM_SIZE_HUGE

/obj/item/gift/New(newloc, obj/item/wrapped = null)
	..(newloc)

	if(istype(wrapped))
		gift = wrapped
		w_class = gift.w_class
		gift.forceMove(src)

		//a good example of where we don't want to use the w_class defines
		switch(gift.w_class)
			if(1) icon_state = "gift1"
			if(2) icon_state = "gift1"
			if(3) icon_state = "gift2"
			if(4) icon_state = "gift2"
			if(5) icon_state = "gift3"

/obj/item/gift/attack_self(mob/user as mob)
	user.drop_item()
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		to_chat(user, SPAN_WARNING("The gift was empty!"))
	qdel(src)
	return

/obj/item/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/gifts.dmi'
	icon_state = "wrap_paper"
	var/amount = 2.5*BASE_STORAGE_COST(ITEM_SIZE_HUGE)
	item_flags = ITEM_FLAG_TRY_ATTACK

/obj/item/wrapping_paper/use_tool(obj/item/tool, mob/user)
	if (!istype(tool))
		return FALSE
	if (!isturf(loc))
		to_chat(user, SPAN_WARNING("You must put \the [src] on a surface in order to wrap \the [tool]!"))
		return TRUE
	if (tool.w_class > ITEM_SIZE_LARGE)
		to_chat(user, SPAN_WARNING("\The [tool] is far too large!"))
		return TRUE
	if (!is_sharp(user.get_inactive_hand()))
		to_chat(user, SPAN_WARNING("You need a sharp object in your other hand to cut \the [src]!"))
		return TRUE

	var/a_used = tool.get_storage_cost()
	if (a_used == ITEM_SIZE_NO_CONTAINER)
		to_chat(user, SPAN_WARNING("You can't wrap that!"))
		return TRUE
	if (amount < a_used)
		to_chat(user, SPAN_WARNING("You need more paper!"))
		return TRUE
	if (istype(tool, /obj/item/smallDelivery) || istype(tool, /obj/item/gift)) //No gift wrapping gifts!
		to_chat(user, SPAN_WARNING("\The [tool] is already wrapped!"))
		return TRUE
	if (!do_after(user, tool.w_class SECONDS, tool, DO_PUBLIC_UNIQUE))
		return TRUE

	if (user.unEquip(tool))
		var/obj/item/gift/G = new /obj/item/gift(loc, tool)
		G.add_fingerprint(user)
		tool.add_fingerprint(user)
		amount -= a_used

	if (amount <= 0)
		new /obj/item/c_tube(loc)
		qdel(src)
	return TRUE

/obj/item/wrapping_paper/use_on(obj/item/target, mob/user)
	if (!isitem(target))
		return FALSE
	if (!isturf(loc))
		to_chat(user, SPAN_WARNING("You must put \the [src] on a surface in order to wrap \the [target]!"))
		return TRUE

/obj/item/wrapping_paper/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, text("There is about [] square units of paper left!", src.amount))

/obj/item/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = target
	var/a_used = BASE_STORAGE_COST(ITEM_SIZE_LARGE) //get_storage_cost() does not work on mobs, will reproduce same logic here.

	if (amount < a_used)
		to_chat(user, SPAN_WARNING("You need more paper."))
		return TRUE

	if (!H.has_danger_grab(user))
		to_chat(user, "You need to have a firm grip on \the [target] in order to wrap them.")
		return TRUE

	if (!do_after(user, ITEM_SIZE_LARGE SECONDS, target, DO_PUBLIC_UNIQUE) || !H.has_danger_grab(user))
		return TRUE

	var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
	amount -= a_used

	if (H.client)
		H.client.perspective = EYE_PERSPECTIVE
		H.client.eye = present

	if (user == target)
		user.visible_message(SPAN_DANGER("\The [user] has gift-wrapped themselves!"))
	else
		user.visible_message(SPAN_DANGER("\The [user] has gift-wrapped \the [target]!"))

	H.forceMove(present)
	H.remove_grabs_and_pulls()
	admin_attack_log(user, H, "Used \a [src] to wrap their victim", "Was wrapepd with \a [src]", "used \the [src] to wrap")
	return TRUE
