/obj/item/storage/fancy/pencilcase
	name = "pencil case"
	desc = "A pencil case for all those schoolboys to carry."
	icon = 'icons/obj/pencil_case.dmi'
	icon_state = "pencil_case"
	open_sound = 'sound/effects/storage/unzip.ogg'
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6 * ITEM_SIZE_TINY
	key_type = list(/obj/item/pen)
	startswith = list(
		/obj/item/pen,
		/obj/item/pen/blue,
		/obj/item/pen/red,
		/obj/item/pen/green,
		/obj/item/pen/crayon/yellow,
		/obj/item/pen/crayon/purple
	)


/obj/item/storage/fancy/pencilcase/on_update_icon()
	if (!opened)
		icon_state = initial(icon_state)
	else if (key_type_count)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"
