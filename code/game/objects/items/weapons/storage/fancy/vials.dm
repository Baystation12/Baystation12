/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox"
	name = "vial storage box"
	open_sound = 'sound/effects/storage/pillbottle.ogg'
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12

	key_type = /obj/item/reagent_containers/glass/beaker/vial
	startswith = list(/obj/item/reagent_containers/glass/beaker/vial = 12)

/obj/item/storage/fancy/vials/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)][floor(key_type_count / 2)]"

/obj/item/storage/fancy/vials/on_update_icon()
	overlays.Cut()
	if (!opened)
		overlays += image('icons/obj/vialbox.dmi', "cover")
	icon_state = "[initial(icon_state)][floor(key_type_count / 2)]"
