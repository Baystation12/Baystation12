/obj/machinery/vending/hotfood
	name = "\improper Hot Foods"
	desc = "An old vending machine promising 'hot foods'. You doubt any of its contents are still edible."
	vend_delay = 40
	base_type = /obj/machinery/vending/hotfood

	icon_state = "hotfood"
	icon_deny = "hotfood-deny"
	icon_vend = "hotfood-vend"
	products = list(/obj/item/reagent_containers/food/snacks/old/pizza = 1,
					/obj/item/reagent_containers/food/snacks/old/burger = 1,
					/obj/item/reagent_containers/food/snacks/old/hamburger = 1,
					/obj/item/reagent_containers/food/snacks/old/fries = 1,
					/obj/item/reagent_containers/food/snacks/old/hotdog = 1,
					/obj/item/reagent_containers/food/snacks/old/taco = 1
					)

/obj/machinery/vending/hotfood/on_update_icon()
	..()
	if(is_powered())
		overlays += image(icon, "[initial(icon_state)]-heater")
