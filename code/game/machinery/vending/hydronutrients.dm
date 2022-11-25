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
	products = list(
		/obj/item/reagent_containers/glass/bottle/eznutrient = 6,
		/obj/item/reagent_containers/glass/bottle/left4zed = 4,
		/obj/item/reagent_containers/glass/bottle/robustharvest = 3,
		/obj/item/plantspray/pests = 20,
		/obj/item/reagent_containers/syringe = 5,
		/obj/item/storage/plants = 5
	)
	premium = list(
		/obj/item/reagent_containers/glass/bottle/ammonia = 10,
		/obj/item/reagent_containers/glass/bottle/diethylamine = 5
	)


/obj/machinery/vending/hydronutrients/generic
	icon_state = "nutri_generic"
	icon_vend = "nutri_generic-vend"
	icon_deny = "nutri_generic-deny"
