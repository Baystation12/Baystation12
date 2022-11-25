/obj/machinery/vending/soda
	name = "\improper Radical Renard"
	desc = "A softdrink vendor promoted by Radical Renard."
	icon_state = "Soda_Machine"
	icon_vend = "Soda_Machine-vend"
	icon_deny = "Soda_Machine-deny"
	vend_delay = 11
	base_type = /obj/machinery/vending/soda
	product_slogans = "Not applicable!"
	product_ads = "Not applicable."
	products = list(/obj/item/reagent_containers/food/drinks/cans/cola_diet = 10,/obj/item/reagent_containers/food/drinks/cans/rootbeer = 10,
					/obj/item/reagent_containers/food/drinks/cans/cola_apple = 10,/obj/item/reagent_containers/food/drinks/cans/cola_orange = 10,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10,/obj/item/reagent_containers/food/drinks/cans/cola_grape = 10,
					/obj/item/reagent_containers/food/drinks/cans/cola_lemonlime = 10, /obj/item/reagent_containers/food/drinks/cans/cola_strawberry = 10)
	contraband = list(/obj/item/reagent_containers/food/drinks/cans/cola_pork = 10)
	prices = list(/obj/item/reagent_containers/food/drinks/cans/cola_diet = 1,/obj/item/reagent_containers/food/drinks/cans/rootbeer = 1,
					/obj/item/reagent_containers/food/drinks/cans/cola_apple = 1,/obj/item/reagent_containers/food/drinks/cans/cola_orange = 1,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 1,/obj/item/reagent_containers/food/drinks/cans/cola_grape = 1,
					/obj/item/reagent_containers/food/drinks/cans/cola_lemonlime = 1,/obj/item/reagent_containers/food/drinks/cans/cola_strawberry = 1)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
