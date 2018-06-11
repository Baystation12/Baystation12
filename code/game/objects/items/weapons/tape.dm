/obj/item/weapon/tape_roll
	name = "duct tape"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	w_class = ITEM_SIZE_SMALL
	var/dirtiness = 0 //For seeing if you might get infected from using it as a bandage. Who knows where they keep this stuff?
	//If you use it for just a small boo-boo, probably fine. Using it to clot major bleeding, not a good plan.

/obj/item/weapon/tape_roll/New()
	..()
	dirtiness = rand(10, 50)

/obj/item/weapon/tape_roll/attack(var/mob/living/carbon/human/H, var/mob/user)
	if(istype(H))
		var/hostile = 0
		if(user.a_intent == I_DISARM || user.a_intent == I_HURT || user.a_intent == I_GRAB)
			hostile = 1
		if(user.zone_sel.selecting == BP_EYES)
			if(hostile == 0)
				return
			if(!H.organs_by_name[BP_HEAD])
				to_chat(user, "<span class='warning'>\The [H] doesn't have a head.</span>")
				return
			if(!H.has_eyes())
				to_chat(user, "<span class='warning'>\The [H] doesn't have any eyes.</span>")
				return
			if(H.glasses)
				to_chat(user, "<span class='warning'>\The [H] is already wearing somethign on their eyes.</span>")
				return
			if(H.head && (H.head.body_parts_covered & FACE))
				to_chat(user, "<span class='warning'>Remove their [H.head] first.</span>")
				return
			user.visible_message("<span class='danger'>\The [user] begins taping over \the [H]'s eyes!</span>")

			if(!do_mob(user, H, 30))
				return

			// Repeat failure checks.
			if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.has_eyes() || H.glasses || (H.head && (H.head.body_parts_covered & FACE)))
				return

			playsound(src, 'sound/effects/tape.ogg',25)
			user.visible_message("<span class='danger'>\The [user] has taped up \the [H]'s eyes!</span>")
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/blindfold/tape(H), slot_glasses)

		else if(user.zone_sel.selecting == BP_MOUTH)
			if(hostile == 0)
				return
			if(!H.organs_by_name[BP_HEAD])
				to_chat(user, "<span class='warning'>\The [H] doesn't have a head.</span>")
				return
			if(!H.check_has_mouth())
				to_chat(user, "<span class='warning'>\The [H] doesn't have a mouth.</span>")
				return
			if(H.wear_mask)
				to_chat(user, "<span class='warning'>\The [H] is already wearing a mask.</span>")
				return
			if(H.head && (H.head.body_parts_covered & FACE))
				to_chat(user, "<span class='warning'>Remove their [H.head] first.</span>")
				return
			playsound(src, 'sound/effects/tape.ogg',25)
			user.visible_message("<span class='danger'>\The [user] begins taping up \the [H]'s mouth!</span>")

			if(!do_mob(user, H, 30))
				return

			// Repeat failure checks.
			if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.check_has_mouth() || H.wear_mask || (H.head && (H.head.body_parts_covered & FACE)))
				return
			playsound(src, 'sound/effects/tape.ogg',25)
			user.visible_message("<span class='danger'>\The [user] has taped up \the [H]'s mouth!</span>")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask)

		else if(user.zone_sel.selecting == BP_R_HAND || user.zone_sel.selecting == BP_L_HAND)
			if(hostile == 1)
				if(!H.has_organ_for_slot(slot_handcuffed))
					to_chat(user, "<span class='danger'>\The [H] needs at least two wrists before you can tape them together!</span>")
					return
				playsound(src, 'sound/effects/tape.ogg',25)
				var/obj/item/weapon/handcuffs/cable/tape/T = new(user)
				if(!T.place_handcuffs(H, user))
					user.unEquip(T)
					qdel(T)
			else if(hostile == 0)
				tape_bandage(H, user)

		else if(user.zone_sel.selecting == BP_CHEST)
			if(H.wear_suit && istype(H.wear_suit, /obj/item/clothing/suit/space))
				if(H == user || do_mob(user, H, 10))	//Skip the time-check if patching your own suit, that's handled in attackby()
					playsound(src, 'sound/effects/tape.ogg',25)
					H.wear_suit.attackby(src, user)
			else
				tape_bandage(H, user)

		else if(hostile == 0)
			tape_bandage(H, user)
		else
			return ..()
		return 1

/obj/item/weapon/tape_roll/proc/stick(var/obj/item/weapon/W, mob/user)
	if(!istype(W, /obj/item/weapon/paper))
		return
	user.drop_from_inventory(W)
	var/obj/item/weapon/ducttape/tape = new(get_turf(src))
	tape.attach(W)
	user.put_in_hands(tape)

/obj/item/weapon/tape_roll/proc/tape_bandage(var/mob/living/carbon/human/H, var/mob/user)
	if(!H.get_organ(user.zone_sel.selecting))
		return
	var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
	if(!affecting.wounds.len)
		to_chat(user, "<span class='warning'>[H]'s [affecting.name] has no wounds.</span>")
		return
	if(affecting.is_bandaged())
		to_chat(user, "<span class='warning'>The wounds on [H]'s [affecting.name] have already been bandaged.</span>")
		return
	else
		user.visible_message("<span class='notice'>\The [user] starts applying tape to [H]'s [affecting.name].</span>", \
				             "<span class='notice'>You start applying tape to [H]'s [affecting.name].</span>" )
		for (var/datum/wound/W in affecting.wounds)
			if(W.bandaged)
				continue
			if(!do_mob(user, H, W.damage/5))
				to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
				break
			if (W.current_stage <= W.max_bleeding_stage)
				user.visible_message("<span class='notice'>\The [user] puts tape over \a [W.desc] on [H]'s [affecting.name].</span>", \
				                              "<span class='notice'>You put tape over \a [W.desc] on [H]'s [affecting.name].</span>" )
			else if (W.damage_type == BRUISE)
				user.visible_message("<span class='notice'>\The [user] places a patch of tape over \a [W.desc] on [H]'s [affecting.name].</span>", \
				                              "<span class='notice'>You place a patch of tape over \a [W.desc] on [H]'s [affecting.name].</span>" )
			else
				user.visible_message("<span class='notice'>\The [user] places some tape over \a [W.desc] on [H]'s [affecting.name].</span>", \
					                              "<span class='notice'>You place some tape over \a [W.desc] on [H]'s [affecting.name].</span>" )
			W.bandage()
			playsound(src, 'sound/effects/tape.ogg',25)
			W.germ_level += dirtiness


/obj/item/weapon/ducttape
	name = "piece of tape"
	desc = "A piece of sticky tape."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	w_class = ITEM_SIZE_TINY
	layer = ABOVE_OBJ_LAYER

	var/obj/item/weapon/stuck = null

/obj/item/weapon/ducttape/attack_hand(var/mob/user)
	anchored = FALSE // Unattach it from whereever it's on, if anything.
	return ..()

/obj/item/weapon/ducttape/Initialize()
	. = ..()
	item_flags |= ITEM_FLAG_NO_BLUDGEON

/obj/item/weapon/ducttape/examine(mob/user)
	return stuck ? stuck.examine(user) : ..()

/obj/item/weapon/ducttape/proc/attach(var/obj/item/weapon/W)
	stuck = W
	anchored = TRUE
	W.forceMove(src)
	icon_state = W.icon_state + "_taped"
	name = W.name + " (taped)"
	overlays = W.overlays

/obj/item/weapon/ducttape/attack_self(mob/user)
	if(!stuck)
		return

	to_chat(user, "You remove \the [initial(name)] from [stuck].")
	user.drop_from_inventory(src)
	stuck.forceMove(get_turf(src))
	user.put_in_hands(stuck)
	stuck = null
	overlays = null
	qdel(src)

/obj/item/weapon/ducttape/afterattack(var/A, mob/user, flag, params)

	if(!in_range(user, A) || istype(A, /obj/machinery/door) || !stuck)
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in GLOB.cardinal))
			to_chat(user, "You cannot reach that from here.")// can only place stuck papers in cardinal directions, to
			return											// reduce papers around corners issue.

	user.drop_from_inventory(src)
	playsound(src, 'sound/effects/tape.ogg',25)
	forceMove(source_turf)

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			pixel_x = text2num(mouse_control["icon-x"]) - 16
			if(dir_offset & EAST)
				pixel_x += 32
			else if(dir_offset & WEST)
				pixel_x -= 32
		if(mouse_control["icon-y"])
			pixel_y = text2num(mouse_control["icon-y"]) - 16
			if(dir_offset & NORTH)
				pixel_y += 32
			else if(dir_offset & SOUTH)
				pixel_y -= 32
