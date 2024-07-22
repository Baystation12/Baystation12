/obj/item/clothing/accessory/locket
	name = "silver locket"
	desc = "A silver locket that seems to have space for a photo within."
	icon_state = "locket"
	item_state = "locket"
	slot_flags = 0
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_MASK | SLOT_TIE
	var/base_icon
	var/open
	var/obj/item/held
	var/static/list/locket_allowed = list(
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/phototrinket
	)


/obj/item/clothing/accessory/locket/attack_self(mob/user)
	if (!base_icon)
		base_icon = icon_state
	if (!("[base_icon]_open" in icon_states(icon)))
		to_chat(user, "\The [src] doesn't seem to open.")
		return

	open = !open
	to_chat(user, "You flip \the [src] [open?"open":"closed"].")
	if (open)
		icon_state = "[base_icon]_open"
		if (held)
			to_chat(user, "\The [held] falls out!")
			held.dropInto(user.loc)
			held = null
	else
		icon_state = "[base_icon]"


/obj/item/clothing/accessory/locket/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (!is_type_in_list(item, locket_allowed))
		return ..()
	if (!open)
		to_chat(user, SPAN_WARNING("You have to open \the [src] before modifying it."))
	else if (held)
		to_chat(user, SPAN_WARNING("\The [src] already holds \a [held]."))
	else if (!user.unEquip(item, src))
		FEEDBACK_UNEQUIP_FAILURE(user, item)
	else
		to_chat(usr, SPAN_NOTICE("You slip \the [item] into \the [src]."))
		held = item
	return TRUE
