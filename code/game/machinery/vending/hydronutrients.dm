/obj/machinery/vending/hydronutrients
	name = "\improper NutriMax"
	desc = "A plant nutrients vendor."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	icon_vend = "nutri-vend"
	base_type = /obj/machinery/vending/hydronutrients
	idle_power_usage = 200
	product_slogans = {"\
		Aren't you glad you don't have to fertilize the natural way?;\
		Now with 50% less stink!;\
		Plants are people too!\
	"}
	product_ads = {"\
		We like plants!;\
		Don't you want some?;\
		The greenest thumbs ever.;\
		We like big plants.;\
		Soft soil...\
	"}
	antag_slogans = {"\
		How about a nice kudzu plant for your significant Solar other?;\
		Nothing good ever grows out of Solarian soil!;\
		Remember O Solarian that you are dust, and to dust you shall return.;\
		Congratulations, you’re finally touching grass!\
	"}
	products = list(
		/obj/item/reagent_containers/glass/bottle/eznutrient = 6,
		/obj/item/reagent_containers/glass/bottle/left4zed = 4,
		/obj/item/reagent_containers/glass/bottle/robustharvest = 3,
		/obj/item/plantspray/pests = 20,
		/obj/item/reagent_containers/syringe = 5,
		/obj/item/storage/plants = 5
	)
	rare_products = list(
		/obj/item/seeds/deathnettleseed = 50,
		/obj/item/rig_module/fabricator/energy_net = 40,
		/obj/item/reagent_containers/glass/bottle/mutagen = 15
	)
	premium = list(
		/obj/item/reagent_containers/glass/bottle/ammonia = 10,
		/obj/item/reagent_containers/glass/bottle/diethylamine = 5
	)
	antag = list(
		/obj/item/seeds/kudzuseed = 1,
		/obj/item/seeds/ambrosiadeusseed = 1,
		/obj/item/rig_module/fabricator/energy_net = 0,
		/obj/item/seeds/deathnettleseed = 0,
		/obj/item/reagent_containers/glass/bottle/mutagen = 0
	)


/obj/machinery/vending/hydronutrients/generic
	icon_state = "nutri_generic"
	icon_vend = "nutri_generic-vend"
	icon_deny = "nutri_generic-deny"
