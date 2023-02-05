/obj/item/organ/internal/augment/active/item/circuit
	name = "integrated circuit frame"
	action_button_name = "Activate Circuit"
	icon_state = "circuit"
	augment_slots = AUGMENT_ARM
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_SCANNABLE
	desc = "A DIY modular assembly, courtesy of Xion Industrial. Circuitry not included."


/obj/item/organ/internal/augment/active/item/circuit/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_CROWBAR] = "<p>Removes the attached assembly.</p>"
	.["Electronic Assembly (Agument)"] = "<p>Attaches the assembly. Only one assembly can be attached at a time.</p>"


/obj/item/organ/internal/augment/active/item/circuit/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Remove augment
	if (isCrowbar(tool))
		if (!item)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an assembly to remove."))
			return TRUE
		if (!item.canremove)
			to_chat(user, SPAN_WARNING("\The [item] can't be removed from \the [src]."))
			return TRUE
		item.dropInto(loc)
		item = null
		playsound(loc, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [item] from \the [src] with \a [tool]."),
			SPAN_NOTICE("You remove \the [item] from \the [src] with \the [tool].")
		)
		return TRUE

	// Electronic Assembly (Augment) - Add augment
	if (istype(tool, /obj/item/device/electronic_assembly/augment))
		if (item)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [item] installed."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		item = tool
		item.canremove = FALSE
		playsound(loc, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		return TRUE

	return ..()
