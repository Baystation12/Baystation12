/obj/item/storage/fancy/egg_box
	name = "egg box"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "eggbox"
	open_sound = 'sound/effects/storage/smallbox.ogg'
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	key_type = list(/obj/item/reagent_containers/food/snacks/egg)
	contents_allowed = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)


/obj/item/storage/fancy/egg_box/full
	startswith = list(/obj/item/reagent_containers/food/snacks/egg = 12)
