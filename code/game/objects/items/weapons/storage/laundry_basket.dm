// -----------------------------
//        Laundry Basket
// -----------------------------
// An item designed for hauling the belongings of a character.
// So this cannot be abused for other uses, we make it two-handed and inable to have its storage looked into.
/obj/item/storage/laundry_basket
	name = "laundry basket"
	icon = 'icons/obj/janitor_tools.dmi'
	icon_state = "laundry-empty"
	item_state = "laundry"
	desc = "The peak of thousands of years of laundry evolution."

	w_class = ITEM_SIZE_GARGANTUAN
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE //20 for clothes + a bit of additional space for non-clothing items that were worn on body
	storage_slots = 14
	allow_quick_empty = TRUE
	allow_quick_gather = TRUE
	collection_mode = TRUE
	var/linked


/obj/item/storage/laundry_basket/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.get_organ(BP_R_HAND)
		if (user.hand)
			temp = H.get_organ(BP_L_HAND)
		if(!temp)
			to_chat(user, SPAN_WARNING("You need two hands to pick this up!"))
			return

	if(user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need your other hand to be empty"))
		return
	return ..()

/obj/item/storage/laundry_basket/attack_self(mob/user as mob)
	var/turf/T = get_turf(user)
	to_chat(user, SPAN_NOTICE("You dump the [src]'s contents onto \the [T]."))
	return ..()

/obj/item/storage/laundry_basket/pickup(mob/user)
	var/obj/item/storage/laundry_basket/offhand/O = new(user)
	O.SetName("[name] - second hand")
	O.desc = "Your second grip on the [name]."
	O.linked = src
	user.put_in_inactive_hand(O)
	linked = O
	return

/obj/item/storage/laundry_basket/on_update_icon()
	if(length(contents))
		icon_state = "laundry-full"
	else
		icon_state = "laundry-empty"
	return


/obj/item/storage/laundry_basket/MouseDrop(obj/over_object as obj)
	if(over_object == usr)
		return
	else
		return ..()

/obj/item/storage/laundry_basket/dropped(mob/user as mob)
	qdel(linked)
	return ..()

/obj/item/storage/laundry_basket/show_to(mob/user as mob)
	return

/obj/item/storage/laundry_basket/open(mob/user as mob)


//Offhand
/obj/item/storage/laundry_basket/offhand
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "offhand"
	name = "second hand"
	collection_mode = FALSE
	allow_quick_gather = FALSE

/obj/item/storage/laundry_basket/offhand/dropped(mob/user as mob)
	..()
	user.drop_from_inventory(linked)
	return
