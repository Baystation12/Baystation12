/obj/structure/bed/roller/ironingboard
	name = "ironing board"
	desc = "An ironing board to unwrinkle your wrinkled clothing."
	icon = 'icons/obj/ironing.dmi'

	var/obj/item/clothing/cloth // the clothing on the ironing board
	var/obj/item/weapon/ironingiron/holding // ironing iron on the board
	var/image/cloth_overlay // overlay for the clothing
	var/list/move_sounds = list( // some nasty sounds to make when moving the board
		'sound/effects/metalscrape1.ogg',
		'sound/effects/metalscrape2.ogg',
		'sound/effects/metalscrape3.ogg'
	)

// make a screeching noise to drive people mad
/obj/structure/bed/roller/ironingboard/Move()
	if(!isspace(src.loc) && !istype(src.loc, /turf/simulated/floor/carpet))
		playsound(src.loc, pick(move_sounds), 75, 1)
	. = ..()

/obj/structure/bed/roller/ironingboard/examine(var/mob/user)
	. = ..()
	if(cloth)
		to_chat(user, "<span class='notice'>\The \icon[cloth] [cloth] lies on it.</span>")

/obj/structure/bed/roller/ironingboard/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W,/obj/item/roller_holder))
		if(buckled_mob)
			user_unbuckle_mob(user)
			return
		if(holding && user.put_in_hands(holding))
			holding = null
			icon_state = "up"
			return
		if(cloth && user.put_in_hands(cloth))
			overlays -= cloth_overlay
			src.cloth_overlay = null
			src.cloth = null
			return

		visible_message("[user] collapses [src].")
		new/obj/item/roller/ironingboard(get_turf(src))
		QDEL_IN(src, 0)
		return

	if(!density)
		if(istype(W,/obj/item/clothing) || istype(W,/obj/item/weapon/ironingiron))
			to_chat(user, "<span class='notice'>[src] isn't deployed!</span>")
			return
		return ..()

	if(istype(W,/obj/item/clothing))
		if(cloth)
			to_chat(user, "<span class='notice'>[cloth] is already on the ironing table!</span>")
			return
		if(buckled_mob)
			to_chat(user, "<span class='notice'>[buckled_mob] is already on the ironing table!</span>")
			return

		if(user.drop_item())
			cloth = W
			cloth_overlay = new /icon(W.icon, W.icon_state)
			overlays += cloth_overlay

			W.forceMove(src)
		return
	else if(istype(W,/obj/item/weapon/ironingiron))
		var/obj/item/weapon/ironingiron/I = W

		if(!I.enabled && user.drop_item())
			holding = I
			I.forceMove(src)
			icon_state = "holding"
			return

		// anti-wrinkle "massage"
		if(buckled_mob && ishuman(buckled_mob))
			var/mob/living/carbon/human/H = buckled_mob
			var/zone = user.zone_sel.selecting
			var/parsed = parse_zone(zone)
		
			visible_message("<span class='danger'>[user] begins ironing [src.buckled_mob]'s [parsed]!</span>", "<span class='danger'>You begin ironing [buckled_mob]'s [parsed]!</span>")
			if(!do_after(user, 40, src))
				return
			visible_message("<span class='danger'>[user] irons [src.buckled_mob]'s [parsed]!</span>", "<span class='danger'>You iron [buckled_mob]'s [parsed]!</span>")

			var/obj/item/organ/external/affecting = H.get_organ(zone)
			affecting.take_damage(0, 15, used_weapon = "Hot metal")

			return

		if(!cloth)
			to_chat(user, "<span class='notice'>There isn't anything on the ironing board.</span>")
			return

		visible_message("[user] begins ironing [cloth].")
		if(!do_after(user, 40, src))
			return

		visible_message("[user] finishes ironing [cloth].")
		cloth.ironed_state = WRINKLES_NONE

		return

	..()

/obj/structure/bed/roller/ironingboard/attack_hand(var/mob/user)
	if(density) // check if it's deployed
		if(buckled_mob)
			user_unbuckle_mob(user)
			return
		if(holding && user.put_in_hands(holding))
			holding = null
			icon_state = "up"
			return
		if(cloth && user.put_in_hands(cloth))
			overlays -= cloth_overlay
			src.cloth_overlay = null
			src.cloth = null
			return

		to_chat(user, "You fold the ironing table down.")
		density = 0
		icon_state = "down"
	else
		to_chat(user, "You deploy the ironing table.")
		density = 1
		icon_state = "up"

	..()

/obj/structure/bed/roller/ironingboard/MouseDrop(var/over_object, var/src_location, var/over_location)
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		if(cloth)
			cloth.forceMove(get_turf(src))
		if(holding)
			holding.forceMove(get_turf(src))

		visible_message("[usr] collapses [src].")
		new/obj/item/roller/ironingboard(get_turf(src))
		QDEL_IN(src, 0)
		return

/obj/item/roller/ironingboard
	name = "ironing board"
	desc = "A collapsed ironing board that can be carried around."
	icon = 'icons/obj/ironing.dmi'

/obj/item/roller/ironingboard/attack_self(var/mob/user)
		var/obj/structure/bed/roller/ironingboard/R = new /obj/structure/bed/roller/ironingboard(user.loc)
		R.add_fingerprint(user)
		qdel(src)