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


/obj/item/clothing/accessory/locket/get_interactions_info()
	. = ..()
	.["Paper"] = "<p>Inserts the paper into the locket. The locket must be open. There can only be one item inserted at a time.</p>"
	.["Photo"] = "<p>Inserts the photo into the locket. The locket must be open. There can only be one item inserted at a time.</p>"


/obj/item/clothing/accessory/locket/use_tool(obj/item/tool, mob/user, list/click_params)
	// Paper, Photo - Add to locket
	if (is_type_in_list(tool, list(/obj/item/paper, /obj/item/photo)))
		if (!open)
			to_chat(user, SPAN_WARNING("\The [src] needs to be open before you can insert \the [tool]."))
			return TRUE
		if (held)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [held] inside it."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		held = tool
		user.visible_message(
			SPAN_NOTICE("\The [user] slips \a [tool] into \the [src]."),
			SPAN_NOTICE("You slip \a [tool] into \the [src]."),
			range = 1
		)
		return TRUE

	return ..()
