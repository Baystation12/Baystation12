/obj/machinery/vending/hotfood
	name = "\improper Hot Foods"
	desc = "An old vending machine promising 'hot foods'. You doubt any of its contents are still edible."
	icon_state = "hotfood"
	icon_deny = "hotfood-deny"
	icon_vend = "hotfood-vend"
	base_type = /obj/machinery/vending/hotfood
	antag_slogans = {"\
		Get your stale, crumbling food here! Sol's national dish has never tasted better!;\
		If this is the food waiting for you at home, it's no wonder you're hiding here.;\
		Solarian food products, served with a side of diarrhea as always!;\
		Revenge is a dish best served warm.\
	"}
	products = list(
		/obj/item/reagent_containers/food/snacks/old/pizza = 1,
		/obj/item/reagent_containers/food/snacks/old/burger = 1,
		/obj/item/reagent_containers/food/snacks/old/hamburger = 1,
		/obj/item/reagent_containers/food/snacks/old/fries = 1,
		/obj/item/reagent_containers/food/snacks/old/hotdog = 1,
		/obj/item/reagent_containers/food/snacks/old/taco = 1
	)
	rare_products = list(
		/obj/item/storage/box/syndie_kit/corpse_cube = 50
	)
	antag = list(
		/obj/item/storage/box/donkpocket_premium = 1,
		/obj/item/storage/box/syndie_kit/corpse_cube = 0
	)


/obj/machinery/vending/hotfood/on_update_icon()
	..()
	if (is_powered())
		AddOverlays(image(icon, "[initial(icon_state)]-heater"))
