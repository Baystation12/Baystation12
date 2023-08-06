/obj/machinery/vending/weeb
	name = "\improper Nippon-tan!"
	desc = "A distressingly ethnic vending machine loaded with high sucrose low calorie for lack of better words snacks."
	icon_state = "weeb"
	icon_vend = "weeb-vend"
	icon_deny = "weeb-deny"
	product_slogans = {"\
		Konnichiwa gaijin senpai!;\
		Notice me senpai!;\
		Kawaii-desu!\
	"}
	prices = list(
		/obj/item/reagent_containers/food/snacks/weebonuts = 80,
		/obj/item/reagent_containers/food/snacks/ricecake = 80,
		/obj/item/reagent_containers/food/snacks/dango = 80,
		/obj/item/reagent_containers/food/snacks/pokey = 80,
		/obj/item/reagent_containers/food/snacks/chocobanana = 80
	)
	products = list(
		/obj/item/reagent_containers/food/snacks/weebonuts = 8,
		/obj/item/reagent_containers/food/snacks/ricecake = 8,
		/obj/item/reagent_containers/food/snacks/dango = 8,
		/obj/item/reagent_containers/food/snacks/pokey = 8,
		/obj/item/reagent_containers/food/snacks/chocobanana = 8
	)


/obj/machinery/vending/weeb/on_update_icon()
	..()
	if (is_powered())
		AddOverlays(image(icon, "[initial(icon_state)]-fan"))
