/obj/item/storage/bar_fruit_jar
	name = "Fruit jar"
	desc = "Jar with fresh fruit. They are definitely edible and never plastic."
	icon = 'packs/sierra-tweaks/icons/obj/storage.dmi'
	icon_state = "fruitjar"
	max_storage_space = 20
	startswith = list(
		/obj/item/reagent_containers/food/snacks/grown/apple = 2,
		/obj/item/reagent_containers/food/snacks/grown/orange = 2,
		/obj/item/reagent_containers/food/snacks/grown/lime = 2,
		/obj/item/reagent_containers/food/snacks/grown/lemon = 2
	)

/obj/item/storage/bar_fruit_jar/on_update_icon()
	. = ..()
	if(length(contents))
		icon_state = "fruitjar"
	else
		icon_state = "fruitjar_empty"
