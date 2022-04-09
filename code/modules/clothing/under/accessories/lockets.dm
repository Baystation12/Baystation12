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


/obj/item/clothing/accessory/locket/attackby(obj/item/I, mob/user)
	if (!open)
		to_chat(user, "You have to open it first.")
		return
	if (istype(I, /obj/item/paper) || istype(I, /obj/item/photo))
		if (held)
			to_chat(usr, "\The [src] already has something inside it.")
		else
			if (!user.unEquip(I, src))
				return
			to_chat(usr, "You slip [I] into [src].")
			held = I
		return
	..()
