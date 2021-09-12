/obj/item/organ/internal/augment/active/simple/circuit
	name = "integrated circuit frame"
	action_button_name = "Activate Circuit"
	icon_state = "circuit"
	allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	augment_flags = AUGMENT_MECHANICAL
	desc = "A DIY modular assembly, courtesy of Xion Industrial. Circuitry not included."


/obj/item/organ/internal/augment/active/simple/circuit/attackby(obj/item/I, mob/user)
	if (isCrowbar(I))
		if (holding)
			holding.canremove = TRUE
			holding.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You take out \the [holding]."))
			holding = null
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		else
			to_chat(user, SPAN_WARNING("The augment is empty!"))
		return
	if (istype(I, /obj/item/device/electronic_assembly/augment))
		if (holding)
			to_chat(user, SPAN_WARNING("There's already an assembly in there."))
		else if (user.unEquip(I, src))
			holding = I
			holding.canremove = FALSE
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		return
	..()
