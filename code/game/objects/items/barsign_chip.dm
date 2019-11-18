/obj/item/barsign_chip
	name = "Barsign Datachip"
	desc = "A special chip for uploading images to the bar's holosign."
	icon = 'icons/obj/card.dmi' // TODO Find icon for generic computer chip
	icon_state = "robot_base"
	item_state = "electronic"
	w_class = ITEM_SIZE_TINY

	var/barsign_icon = CUSTOM_ITEM_OBJ
	var/barsign_icon_state // Icon state for the barsign icon
	var/barsign_icon_name // Displayed name for the barsign icon, used in the sign's name field and description
	var/barsign_icon_desc // Description text when examining the barsign


/obj/item/barsign_chip/resolve_attackby(atom/A, mob/user, click_params)
	if (!istype(A, /obj/structure/sign/double/barsign))
		return ..()

	if (!barsign_icon_state)
		to_chat(user, SPAN_WARNING("Nothing happens. Unsurprising, considering this datachip is blank."))
		return TRUE

	var/obj/structure/sign/double/barsign/barsign = A
	if (barsign.icon_state == barsign_icon_state)
		to_chat(user, SPAN_WARNING("The barsign is already using this image."))
		return TRUE

	barsign.set_barsign_icon(barsign_icon_state, barsign_icon_name, barsign_icon, barsign_icon_desc)
	to_chat(user, SPAN_NOTICE("You upload the datachip and set the barsign's image."))
	return TRUE



/obj/item/barsign_chip/examine(mob/user, distance)
	. = ..()
	if (barsign_icon_state && barsign_icon_name)
		to_chat(user, SPAN_NOTICE("This datachip contains holosign data titled '[barsign_icon_name]'. [barsign_icon_desc]"))
	else
		to_chat(user, SPAN_NOTICE("This datachip contains no data."))


/obj/item/barsign_chip/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if (citem.item_name)
		SetName("Barsign Datachip - [citem.item_name]")
		barsign_icon_name = citem.item_name
	if (citem.item_desc)
		barsign_icon_desc = citem.item_desc
	if(citem.additional_data["barsign_icon_state"])
		barsign_icon_state = citem.additional_data["barsign_icon_state"]
