/obj/item/clothing/var/buttons_state
/obj/item/clothing/var/buttons_suffix
/obj/item/clothing/var/custom_icon_state


/obj/item/clothing/proc/toggle_buttons()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr
	if(usr.incapacitated())
		return
	buttons_state = !buttons_state
	icon_state = "[custom_icon_state ? custom_icon_state : initial(icon_state)][buttons_state ? buttons_suffix : ""]"
	to_chat(usr, "You [buttons_state ? "unbutton": "button up"] \the [src].")
	update_clothing_icon()


/obj/item/clothing/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	if (buttons_suffix)
		verbs |= /obj/item/clothing/proc/toggle_buttons


/obj/item/clothing/suit/storage/toggle/buttons_suffix = "_open"
/obj/item/clothing/suit/storage/toggle/valid_accessory_slots = ACCESSORY_SLOT_INSIGNIA



/obj/item/clothing/suit/storage/toggle/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if (citem.additional_data["custom_icon_state"])
		custom_icon_state = citem.additional_data["custom_icon_state"]
