/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	name = "egg box"
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	key_type = /obj/item/reagent_containers/food/snacks/egg
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)


/obj/item/storage/fancy/egg_box/full
	startswith = list(/obj/item/reagent_containers/food/snacks/egg = 12)
