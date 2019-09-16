/obj/item/clothing/glasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	action_button_name = "Adjust Blindfold"
	icon_state = "blindfold"
	item_state = "blindfold"
	tint = TINT_BLIND
	flash_protection = FLASH_PROTECTION_MAJOR
	darkness_view = -1
	var/up = FALSE

/obj/item/clothing/glasses/blindfold/attack_self()
	toggle()


/obj/item/clothing/glasses/blindfold/verb/toggle()
	set category = "Object"
	set name = "Adjust blindfold"
	set src in usr

	if(!usr.incapacitated())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip \the [src] down to blind yourself.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You push \the [src] up out of your face.")
		update_clothing_icon()
		update_vision()
		usr.update_action_buttons()

/obj/item/clothing/glasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	action_button_name = null
	icon_state = "tape_cross"
	item_state = null
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/glasses/blindfold/tape/toggle()
	to_chat(usr, SPAN_WARNING("You can't adjust \the [src]!"))
	return