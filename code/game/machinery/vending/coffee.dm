/obj/machinery/vending/coffee
	name = "\improper Hot Drinks"
	desc = "A vending machine which dispenses hot drinks and hot drinks accessories."
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	icon_deny = "coffee-deny"
	base_type = /obj/machinery/vending/coffee
	maxrandom = 20
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
	antag_slogans = {"\
		I love Sol!  Ha ha, just kidding.;\
		Sol woke up and chose violence!;\
		The worst joe for the average Joe.;\
		Capitalism tiring you out? The boss tell you to perk up or ship out?;\
		Tired of working for the man? Try a coffee. It won't help and it won't make you feel better either.\
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
		/obj/item/reagent_containers/food/drinks/coffee = 0,
		/obj/item/reagent_containers/food/drinks/decafcoffee = 0,
		/obj/item/reagent_containers/food/drinks/tea/black = 0,
		/obj/item/reagent_containers/food/drinks/tea/green = 0,
		/obj/item/reagent_containers/food/drinks/tea/chai = 0,
		/obj/item/reagent_containers/food/drinks/tea/decaf = 0,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 0,
		/obj/item/reagent_containers/food/condiment/small/packet/sugar = 0,
		/obj/item/reagent_containers/pill/pod/cream = 0,
		/obj/item/reagent_containers/pill/pod/cream_soy = 0,
		/obj/item/reagent_containers/pill/pod/orange = 0,
		/obj/item/reagent_containers/pill/pod/mint = 0,
		/obj/item/reagent_containers/food/drinks/ice = 0
	)
	rare_products = list(
		/obj/item/reagent_containers/hypospray/autoinjector/combatstim = 70
	)
	antag = list(
		/obj/item/reagent_containers/food/snacks/donkpocket/premium = 1,
		/obj/item/reagent_containers/syringe/steroid = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/combatstim = 0
	)

/obj/machinery/vending/coffee/on_update_icon()
	..()
	if (is_powered())
		AddOverlays(image(icon, "[initial(icon_state)]-screen"))
