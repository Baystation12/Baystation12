/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/weapon/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	randpixel = 10

/obj/item/weapon/a_gift/New()
	..()
	if(w_class > 0 && w_class < ITEM_SIZE_HUGE)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/weapon/a_gift/ex_act()
	qdel(src)
	return

/obj/effect/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	to_chat(user, "<span class='warning'>You can't move.</span>")

/obj/effect/spresent/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if(!isWirecutter(W))
		to_chat(user, "<span class='warning'>I need wirecutters for that.</span>")
		return

	to_chat(user, "<span class='notice'>You cut open the present.</span>")

	for(var/mob/M in src) //Should only be one but whatever.
		M.dropInto(loc)
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	qdel(src)

/obj/item/weapon/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/weapon/storage/wallet,
		/obj/item/weapon/storage/photo_album,
		/obj/item/weapon/storage/box/snappops,
		/obj/item/weapon/storage/fancy/crayons,
		/obj/item/weapon/storage/backpack/holding,
		/obj/item/weapon/storage/belt/champion,
		/obj/item/weapon/pickaxe/silver,
		/obj/item/weapon/pen/invisible,
		/obj/item/weapon/lipstick/random,
		/obj/item/weapon/grenade/smokebomb,
		/obj/item/weapon/carvable/corncob,
		/obj/item/weapon/contraband/poster,
		/obj/item/weapon/book/manual/barman_recipes,
		/obj/item/weapon/book/manual/chef_recipes,
		/obj/item/weapon/bikehorn,
		/obj/item/weapon/beach_ball,
		/obj/item/weapon/beach_ball/holoball,
		/obj/item/toy/water_balloon,
		/obj/item/toy/blink,
		/obj/item/toy/crossbow,
		/obj/item/weapon/gun/projectile/revolver/capgun,
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
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/device/paicard,
		/obj/item/device/synthesized_instrument/violin,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/clothing/accessory/horrible,
		/obj/item/weapon/storage/box/large/foam_gun,
		/obj/item/weapon/storage/box/large/foam_gun/burst,
		/obj/item/weapon/storage/box/large/foam_gun/revolver)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)

/*
 * Wrapping Paper and Gifts
 */

/obj/item/weapon/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = ITEM_SIZE_HUGE

/obj/item/weapon/gift/New(newloc, obj/item/wrapped = null)
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

/obj/item/weapon/gift/attack_self(mob/user as mob)
	user.drop_item()
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		to_chat(user, "<span class='warning'>The gift was empty!</span>")
	qdel(src)
	return

/obj/item/weapon/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	var/amount = 2.5*BASE_STORAGE_COST(ITEM_SIZE_HUGE)

/obj/item/weapon/wrapping_paper/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (!( locate(/obj/structure/table, src.loc) ))
		to_chat(user, "<span class='warning'>You MUST put the paper on a table!</span>")
	if (W.w_class < ITEM_SIZE_HUGE)
		if(isWirecutter(user.l_hand) || isWirecutter(user.r_hand))
			var/a_used = W.get_storage_cost()
			if (a_used == ITEM_SIZE_NO_CONTAINER)
				to_chat(user, "<span class='warning'>You can't wrap that!</span>")//no gift-wrapping lit welders

				return
			if (src.amount < a_used)
				to_chat(user, "<span class='warning'>You need more paper!</span>")
				return
			else
				if(istype(W, /obj/item/smallDelivery) || istype(W, /obj/item/weapon/gift)) //No gift wrapping gifts!
					return

				if(user.unEquip(W))
					var/obj/item/weapon/gift/G = new /obj/item/weapon/gift( src.loc, W )
					G.add_fingerprint(user)
					W.add_fingerprint(user)
					src.amount -= a_used

			if (src.amount <= 0)
				new /obj/item/weapon/c_tube( src.loc )
				qdel(src)
				return
		else
			to_chat(user, "<span class='warning'>You need scissors!</span>")
	else
		to_chat(user, "<span class='warning'>The object is FAR too large!</span>")
	return


/obj/item/weapon/wrapping_paper/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, text("There is about [] square units of paper left!", src.amount))

/obj/item/weapon/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			if (H.client)
				H.client.perspective = EYE_PERSPECTIVE
				H.client.eye = present

			H.forceMove(present)
			admin_attack_log(user, H, "Used \a [src] to wrap their victim", "Was wrapepd with \a [src]", "used \the [src] to wrap")

		else
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else
		to_chat(user, "They are moving around too much. A straightjacket would help.")
