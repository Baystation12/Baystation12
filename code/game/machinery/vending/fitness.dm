/obj/machinery/vending/fitness
	name = "\improper SweatMAX"
	desc = "An exercise aid and nutrition supplement vendor that preys on your inadequacy."
	icon_state = "fitness"
	icon_vend = "fitness-vend"
	icon_deny = "fitness-deny"
	base_type = /obj/machinery/vending/fitness
	product_slogans = {"\
		SweatMAX, get robust!\
	"}
	product_ads = {"\
		Pain is just weakness leaving the body!;\
		Run! Your fat is catching up to you!;\
		Never forget leg day!;\
		Push out!;\
		This is the only break you get today.;\
		Don't cry, sweat!;\
		Healthy is an outfit that looks good on everybody.\
	"}
	prices = list(
		/obj/item/reagent_containers/food/drinks/small_milk = 3,
		/obj/item/reagent_containers/food/drinks/small_milk_choc = 3,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 20,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 5,
		/obj/item/reagent_containers/food/snacks/proteinbar = 5,
		/obj/item/reagent_containers/food/snacks/meatcube = 10,
		/obj/item/reagent_containers/pill/diet = 25,
		/obj/item/towel/random = 40
	)
	products = list(
		/obj/item/reagent_containers/food/drinks/small_milk = 8,
		/obj/item/reagent_containers/food/drinks/small_milk_choc = 8,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 8,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 8,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 8,
		/obj/item/reagent_containers/food/snacks/proteinbar = 8,
		/obj/item/reagent_containers/food/snacks/meatcube = 8,
		/obj/item/reagent_containers/pill/diet = 8,
		/obj/item/towel/random = 8
	)
	contraband = list(
		/obj/item/reagent_containers/syringe/steroid = 4
	)


/obj/machinery/vending/fitness/on_update_icon()
	..()
	if (is_powered())
		overlays += image(icon, "[initial(icon_state)]-overlay")
