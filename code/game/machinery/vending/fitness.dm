/obj/machinery/vending/fitness
	name = "\improper SweatMAX"
	desc = "An exercise aid and nutrition supplement vendor that preys on your inadequacy."
	icon_state = "fitness"
	icon_vend = "fitness-vend"
	icon_deny = "fitness-deny"
	base_type = /obj/machinery/vending/fitness
	maxrandom = 8
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
	antag_slogans = {"\
		Don't believe the rumors. SweatMAX absolutely employs sweatshop workers.;\
		The only reason to build muscle is to use them against the capitalist SCG scum!;\
		Want to hide from the Solarian authorities? Don't worry, they don't know what the inside of a gym looks like.\
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
		/obj/item/towel/random = 40,
		/obj/item/reagent_containers/food/condiment/small/packet/protein = 100
	)
	products = list(
		/obj/item/reagent_containers/food/drinks/small_milk = 0,
		/obj/item/reagent_containers/food/drinks/small_milk_choc = 0,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 0,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 0,
		/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 0,
		/obj/item/reagent_containers/food/snacks/proteinbar = 0,
		/obj/item/reagent_containers/food/snacks/meatcube = 0,
		/obj/item/reagent_containers/pill/diet = 0,
		/obj/item/towel/random = 0,
		/obj/item/reagent_containers/food/condiment/small/packet/protein = 0
	)
	rare_products = list(
		/obj/item/reagent_containers/food/condiment/small/packet/protein = 30,
		/obj/item/device/augment_implanter/iatric_monitor = 50,
		/obj/item/device/augment_implanter/internal_air_system = 25
	)
	contraband = list(
		/obj/item/reagent_containers/syringe/steroid = 4
	)
	antag = list(
		/obj/item/reagent_containers/hypospray/autoinjector/combatpain = 2,
		/obj/item/device/augment_implanter/iatric_monitor = 0,
		/obj/item/device/augment_implanter/internal_air_system = 0
	)

/obj/machinery/vending/fitness/on_update_icon()
	..()
	if (is_powered())
		AddOverlays(image(icon, "[initial(icon_state)]-overlay"))
