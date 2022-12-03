/obj/machinery/vending/coffee
	name = "\improper Hot Drinks"
	desc = "A vending machine which dispenses hot drinks and hot drinks accessories."
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	icon_deny = "coffee-deny"
	base_type = /obj/machinery/vending/coffee
	idle_power_usage = 200
	vend_power_usage = 40000
	product_ads = {"\
		Have a drink!;\
		Drink up!;\
		It's good for you!;\
		Would you like a hot joe?;\
		I'd kill for some coffee!;\
		The best beans in the galaxy.;\
		Only the finest brew for you.;\
		Mmmm. Nothing like a coffee.;\
		I like coffee, don't you?;\
		Coffee helps you work!;\
		Try some tea.;\
		We hope you like the best!;\
		Try our new chocolate!\
	"}
	prices = list(
		/obj/item/reagent_containers/food/drinks/coffee = 10,
		/obj/item/reagent_containers/food/drinks/decafcoffee = 10,
		/obj/item/reagent_containers/food/drinks/tea/black = 10,
		/obj/item/reagent_containers/food/drinks/tea/green = 10,
		/obj/item/reagent_containers/food/drinks/tea/chai = 10,
		/obj/item/reagent_containers/food/drinks/tea/decaf = 10,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 10,
		/obj/item/reagent_containers/food/condiment/small/packet/sugar = 5,
		/obj/item/reagent_containers/pill/pod/cream = 5,
		/obj/item/reagent_containers/pill/pod/cream_soy = 5,
		/obj/item/reagent_containers/pill/pod/orange = 5,
		/obj/item/reagent_containers/pill/pod/mint = 5,
		/obj/item/reagent_containers/food/drinks/ice = 5
	)
	products = list(
		/obj/item/reagent_containers/food/drinks/coffee = 15,
		/obj/item/reagent_containers/food/drinks/decafcoffee = 15,
		/obj/item/reagent_containers/food/drinks/tea/black = 15,
		/obj/item/reagent_containers/food/drinks/tea/green = 15,
		/obj/item/reagent_containers/food/drinks/tea/chai = 15,
		/obj/item/reagent_containers/food/drinks/tea/decaf = 15,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 15,
		/obj/item/reagent_containers/food/condiment/small/packet/sugar = 25,
		/obj/item/reagent_containers/pill/pod/cream = 25,
		/obj/item/reagent_containers/pill/pod/cream_soy = 25,
		/obj/item/reagent_containers/pill/pod/orange = 10,
		/obj/item/reagent_containers/pill/pod/mint = 10,
		/obj/item/reagent_containers/food/drinks/ice = 10
	)


/obj/machinery/vending/coffee/on_update_icon()
	..()
	if (MACHINE_IS_BROKEN(src) && prob(20))
		icon_state = "[initial(icon_state)]-hellfire"
	else if (is_powered())
		overlays += image(icon, "[initial(icon_state)]-screen")
