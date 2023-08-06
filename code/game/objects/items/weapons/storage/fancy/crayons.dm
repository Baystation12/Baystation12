/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	open_sound = 'sound/effects/storage/box.ogg'
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	key_type = list(/obj/item/pen/crayon)
	startswith = list(
		/obj/item/pen/crayon/red,
		/obj/item/pen/crayon/orange,
		/obj/item/pen/crayon/yellow,
		/obj/item/pen/crayon/green,
		/obj/item/pen/crayon/blue,
		/obj/item/pen/crayon/purple
	)


/obj/item/storage/fancy/crayons/on_update_icon()
	icon_state = "[initial(icon_state)][opened ? "open" : ""]"
	ClearOverlays()
	AddOverlays(image('icons/obj/crayons.dmi', icon_state))
	for (var/obj/item/pen/crayon/crayon in contents)
		AddOverlays(image('icons/obj/crayons.dmi', crayon.colourName))
