/obj/item/tape_roll
	name = "duct tape"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	w_class = ITEM_SIZE_SMALL

/obj/item/tape_roll/use_before(mob/living/carbon/human/H, mob/user)
	. = FALSE
	if (istype(H))
		if (user.zone_sel.selecting == BP_EYES)
			if (!H.organs_by_name[BP_HEAD])
				to_chat(user, SPAN_WARNING("\The [H] doesn't have a head."))
				return TRUE
			if (!H.has_eyes())
				to_chat(user, SPAN_WARNING("\The [H] doesn't have any eyes."))
				return TRUE
			if (H.glasses)
				to_chat(user, SPAN_WARNING("\The [H] is already wearing something on their eyes."))
				return TRUE
			if (H.head && (H.head.body_parts_covered & FACE))
				to_chat(user, SPAN_WARNING("Remove their [H.head] first."))
				return TRUE
			user.visible_message(SPAN_DANGER("\The [user] begins taping over \the [H]'s eyes!"))

			if (!do_after(user, 3 SECONDS, H, DO_PUBLIC_UNIQUE))
				return TRUE

			// Repeat failure checks.
			if (!H || !src || !H.organs_by_name[BP_HEAD] || !H.has_eyes() || H.glasses || (H.head && (H.head.body_parts_covered & FACE)))
				return TRUE

			playsound(src, 'sound/effects/tape.ogg',25)
			user.visible_message(SPAN_DANGER("\The [user] has taped up \the [H]'s eyes!"))
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/blindfold/tape(H), slot_glasses)
			return TRUE

		else if (user.zone_sel.selecting == BP_MOUTH || user.zone_sel.selecting == BP_HEAD)
			if (!H.organs_by_name[BP_HEAD])
				to_chat(user, SPAN_WARNING("\The [H] doesn't have a head."))
				return TRUE
			if (!H.check_has_mouth())
				to_chat(user, SPAN_WARNING("\The [H] doesn't have a mouth."))
				return TRUE
			if (H.wear_mask)
				to_chat(user, SPAN_WARNING("\The [H] is already wearing a mask."))
				return TRUE
			if (H.head && (H.head.body_parts_covered & FACE))
				to_chat(user, SPAN_WARNING("Remove their [H.head] first."))
				return TRUE
			playsound(src, 'sound/effects/tape.ogg',25)
			user.visible_message(SPAN_DANGER("\The [user] begins taping up \the [H]'s mouth!"))

			if (!do_after(user, 3 SECONDS, H, DO_PUBLIC_UNIQUE))
				return TRUE

			// Repeat failure checks.
			if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.check_has_mouth() || H.wear_mask || (H.head && (H.head.body_parts_covered & FACE)))
				return TRUE
			playsound(src, 'sound/effects/tape.ogg',25)
			user.visible_message(SPAN_DANGER("\The [user] has taped up \the [H]'s mouth!"))
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask)
			return TRUE

		else if(user.zone_sel.selecting == BP_R_HAND || user.zone_sel.selecting == BP_L_HAND)
			playsound(src, 'sound/effects/tape.ogg',25)
			var/obj/item/handcuffs/cable/tape/T = new(user)
			if (!T.place_handcuffs(H, user))
				qdel(T)
			return TRUE

		else if (user.zone_sel.selecting == BP_CHEST)
			if (H.wear_suit && istype(H.wear_suit, /obj/item/clothing/suit/space))
				H.wear_suit.attackby(src, user)//everything is handled by attackby
			else
				to_chat(user, SPAN_WARNING("\The [H] isn't wearing a spacesuit for you to reseal."))
			return TRUE

/obj/item/tape_roll/proc/stick(obj/item/W, mob/user)
	if(!istype(W, /obj/item/paper) || istype(W, /obj/item/paper/sticky) || !user.unEquip(W))
		return
	var/obj/item/ducttape/tape = new(get_turf(src))
	tape.attach(W)
	user.put_in_hands(tape)

/obj/item/ducttape
	name = "piece of tape"
	desc = "A piece of sticky tape."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	w_class = ITEM_SIZE_TINY
	layer = ABOVE_OBJ_LAYER

	var/obj/item/stuck = null

/obj/item/ducttape/attack_hand(mob/user)
	anchored = FALSE // Unattach it from whereever it's on, if anything.
	return ..()

/obj/item/ducttape/Initialize()
	. = ..()
	item_flags |= ITEM_FLAG_NO_BLUDGEON

/obj/item/ducttape/examine()
	return stuck ? stuck.examine(arglist(args)) : ..()

/obj/item/ducttape/proc/attach(obj/item/W)
	stuck = W
	anchored = TRUE
	W.forceMove(src)
	icon_state = W.icon_state + "_taped"
	name = W.name + " (taped)"
	CopyOverlays(W)

/obj/item/ducttape/attack_self(mob/user)
	if(!stuck)
		return

	to_chat(user, "You remove \the [initial(name)] from [stuck].")
	user.put_in_hands(stuck)
	stuck = null
	qdel(src)

/obj/item/ducttape/afterattack(A, mob/user, flag, params)

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

	if(!user.unEquip(src, source_turf))
		return
	playsound(src, 'sound/effects/tape.ogg',25)

	layer = ABOVE_WINDOW_LAYER

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
