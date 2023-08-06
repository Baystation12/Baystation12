/obj/structure/skele_stand
	name = "hanging skeleton model"
	density = TRUE
	anchored = FALSE
	icon = 'icons/obj/surgery_tools.dmi'
	icon_state = "hangskele"
	desc = "It's an anatomical model of a human skeletal system made of plaster."
	var/list/swag = list()
	var/cooldown

/obj/structure/skele_stand/New()
	..()
	gender = pick(MALE, FEMALE)

/obj/structure/skele_stand/proc/rattle_bones(mob/user, atom/thingy)
	if((world.time - cooldown) <= 1 SECOND)
		return //reduces spam.
	if(user)
		visible_message("\The [user] pushes on [src][thingy?" with \the [thingy]":""], giving the bones a good rattle.")
	else
		visible_message("\The [src] rattles on \his stand upon hitting [thingy?"\the [thingy]":"something"].")
	cooldown = world.time
	playsound(loc, 'sound/effects/bonerattle.ogg', 40)

/obj/structure/skele_stand/attack_hand(mob/user)
	if(length(swag))
		var/obj/item/clothing/C = input("What piece of clothing do you want to remove?", "Skeleton undressing") as null|anything in list_values(swag)
		if(C)
			swag -= get_key_by_value(swag, C)
			user.put_in_hands(C)
			to_chat(user,SPAN_NOTICE("You take \the [C] off \the [src]"))
			update_icon()
	else
		rattle_bones(user, null)

/obj/structure/skele_stand/Bumped(atom/thing)
	rattle_bones(null, thing)

/obj/structure/skele_stand/examine(mob/user)
	. = ..()
	if(length(swag))
		var/list/swagnames = list()
		for(var/slot in swag)
			var/obj/item/clothing/C = swag[slot]
			if (C)
				swagnames += C.get_examine_line()
		to_chat(user,"[gender == MALE ? "He" : "She"] is wearing [english_list(swagnames)].")


/obj/structure/skele_stand/use_weapon(obj/item/weapon, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	rattle_bones(user, weapon)
	return TRUE


/obj/structure/skele_stand/use_tool(obj/item/tool, mob/user, list/click_params)
	// Pen - Name skeleton
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What do you want to name this skeleton?", "[initial(name)] - Name", name) as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!input || input == name || !user.use_sanity_check(src, tool))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [src] renames \the [src] to '[input]' with \a [tool]."),
			SPAN_NOTICE("You rename \the [src] to '[input]' with \the [tool].")
		)
		SetName(input)
		return TRUE

	// Clothing - Add clothing
	if (istype(tool, /obj/item/clothing))
		var/slot
		if (istype(tool, /obj/item/clothing/under))
			slot = slot_w_uniform_str
		else if (istype(tool, /obj/item/clothing/suit))
			slot = slot_wear_suit_str
		else if (istype(tool, /obj/item/clothing/head))
			slot = slot_head_str
		else if (istype(tool, /obj/item/clothing/shoes))
			slot = slot_shoes_str
		else if (istype(tool, /obj/item/clothing/mask))
			slot = slot_wear_mask_str
		if (!slot)
			USE_FEEDBACK_FAILURE("\The [tool] can't be put on \the [src].")
			return TRUE
		if (swag[slot])
			USE_FEEDBACK_FAILURE("\The [src] is already wearing \a [swag[slot]].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		swag[slot] = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] on \the [src]."),
			SPAN_NOTICE("You put \the [tool] on \the [src].")
		)
		return TRUE

	return ..()


/obj/structure/skele_stand/Destroy()
	for(var/slot in swag)
		var/obj/item/I = swag[slot]
		I.forceMove(loc)
	. = ..()

/obj/structure/skele_stand/on_update_icon()
	ClearOverlays()
	for(var/slot in swag)
		var/obj/item/I = swag[slot]
		AddOverlays(I.get_mob_overlay(null, slot))

/obj/structure/skele_stand/maint
	name = "decayed skeleton model"
	icon_state = "hangskelemaint"
	desc = "It's an anatomical model of a human skeletal system made of plaster. The plaster on this one is a bit decayed, due to repeated clothing swapping."
