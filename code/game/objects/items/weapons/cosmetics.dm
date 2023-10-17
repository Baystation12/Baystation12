/obj/item/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/lipsticks.dmi'
	icon_state = "lipstick"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/colour = "red"
	var/open = 0

/obj/item/lipstick/purple
	name = "purple lipstick"
	colour = "purple"

/obj/item/lipstick/jade
	name = "jade lipstick"
	colour = "jade"

/obj/item/lipstick/black
	name = "black lipstick"
	colour = "black"

/obj/item/lipstick/random
	name = "lipstick"

/obj/item/lipstick/random/Initialize()
	. = ..()
	colour = pick("red","purple","jade","black")
	name = "[colour] lipstick"

/obj/item/lipstick/attack_self(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You twist \the [src] [open ? "closed" : "open"]."))
	open = !open
	if(open)
		icon_state = "[initial(icon_state)]_[colour]"
	else
		icon_state = initial(icon_state)

/obj/item/lipstick/use_before(atom/A, mob/living/user as mob)
	. = FALSE
	if (!open)
		to_chat(user, SPAN_NOTICE("You need to uncap \the [src] first!"))
		return TRUE

	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/head/head = H.organs_by_name[BP_HEAD]

		if (!istype(head))
			return TRUE

		if (user.zone_sel.selecting == BP_HEAD)
			head.write_on(user, name)
			return TRUE

		if (head.has_lips && user.zone_sel.selecting == BP_MOUTH)
			if (H.makeup_style)	//if they already have lipstick on
				to_chat(user, SPAN_NOTICE("You need to wipe off the old lipstick first!"))
				return TRUE

			if (H == user)
				user.visible_message(SPAN_NOTICE("\The [user] does their lips with \the [src]."), \
									 SPAN_NOTICE("You take a moment to apply \the [src]. Perfect!"))
				H.makeup_style = colour
				H.update_body()
				return TRUE
			else
				user.visible_message(SPAN_WARNING("\The [user] begins to do \the [H]'s lips with \the [src]."), \
									 SPAN_NOTICE("You begin to apply \the [src] on \the [H]'s lips."))
				if (do_after(user, 4 SECONDS, H, DO_EQUIP))
					user.visible_message(SPAN_NOTICE("\The [user] does \the [H]'s lips with \the [src]."), \
										 SPAN_NOTICE("You apply \the [src] on \the [H]'s lips."))
					H.makeup_style = colour
					H.update_body()
				return TRUE

	if(istype(A, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = A
		head.write_on(user, name)
		return TRUE


//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/use_before()


/obj/item/haircomb //sparklysheep's comb
	name = "plastic comb"
	desc = "A pristine comb made from flexible plastic."
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/lavatory.dmi'
	icon_state = "comb"
	item_state = "comb"

/obj/item/haircomb/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

/obj/item/haircomb/attack_self(mob/living/carbon/human/user)
	if(!user.incapacitated())
		user.visible_message(SPAN_NOTICE("\The [user] uses \the [src] to comb their hair with incredible style and sophistication. What a [user.gender == FEMALE ? "lady" : "guy"]."))

/obj/item/haircomb/brush
	name = "hairbrush"
	desc = "A surprisingly decent hairbrush with a false wood handle and semi-soft bristles."
	w_class = ITEM_SIZE_SMALL
	slot_flags = null
	icon_state = "brush"
	item_state = "brush"

/obj/item/haircomb/brush/attack_self(mob/living/carbon/human/user)
	if(!user.incapacitated())
		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[user.head_hair_style]
		if(hair_style.flags & VERY_SHORT)
			user.visible_message(SPAN_NOTICE("\The [user] just sort of runs \the [src] over their scalp."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] meticulously brushes their hair with \the [src]."))
