/obj/item/organ/internal/augment/active/item/circuit
	name = "integrated circuit frame"
	action_button_name = "Activate Circuit"
	icon_state = "circuit"
	augment_slots = AUGMENT_ARM
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_SCANNABLE
	desc = "A DIY modular assembly, courtesy of Xion Industrial. Circuitry not included."


/obj/item/organ/internal/augment/active/item/circuit/attackby(obj/item/I, mob/user)
	if (isCrowbar(I))
		if (item)
			item.canremove = TRUE
			item.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You take out \the [item]."))
			item = null
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		else
			to_chat(user, SPAN_WARNING("The augment is empty!"))
		return
	if (istype(I, /obj/item/device/electronic_assembly/augment))
		if (item)
			to_chat(user, SPAN_WARNING("There's already an assembly in there."))
		else if (user.unEquip(I, src))
			item = I
			item.canremove = FALSE
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		return
	..()
