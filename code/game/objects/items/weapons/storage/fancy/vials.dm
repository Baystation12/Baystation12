/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox"
	name = "vial storage box"
	open_sound = 'sound/effects/storage/pillbottle.ogg'
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12

	key_type = list(/obj/item/reagent_containers/glass/beaker/vial)
	startswith = list(/obj/item/reagent_containers/glass/beaker/vial = 12)

/obj/item/storage/fancy/vials/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)][floor(total_keys / 2)]"

/obj/item/storage/fancy/vials/on_update_icon()
	ClearOverlays()
	if (!opened)
		AddOverlays(image('icons/obj/vialbox.dmi', "cover"))
	icon_state = "[initial(icon_state)][floor(total_keys / 2)]"
