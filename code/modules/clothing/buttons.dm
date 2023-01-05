/obj/item/clothing/var/buttons_state
/obj/item/clothing/var/buttons_suffix
/obj/item/clothing/var/custom_icon_state


/obj/item/clothing/suit/storage/toggle
	var/icon_open
	var/icon_closed

/obj/item/clothing/suit/storage/toggle/verb/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr
	if(!CanPhysicallyInteract(usr))
		return 0

	if(icon_state == icon_open) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
		icon_state = icon_closed
		to_chat(usr, "You button up the coat.")
	else if(icon_state == icon_closed)
		icon_state = icon_open
		to_chat(usr, "You unbutton the coat.")
	else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
		to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how silly you are.")
		return
	update_clothing_icon()	//so our overlays update

/obj/item/clothing/suit/storage/toggle/inherit_custom_item_data(var/datum/custom_item/citem)
	. = ..()
	if(citem.additional_data["icon_open"])
		icon_open = citem.additional_data["icon_open"]
	if(citem.additional_data["icon_closed"])
		icon_closed = citem.additional_data["icon_closed"]
