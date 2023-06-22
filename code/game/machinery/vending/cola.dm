/obj/machinery/vending/cola
	name = "\improper Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	icon_vend = "Cola_Machine-vend"
	icon_deny = "Cola_Machine-deny"
	base_type = /obj/machinery/vending/cola
	idle_power_usage = 200
	product_slogans = {"\
		Robust Softdrinks: More robust than a toolbox to the head!\
	"}
	product_ads = {"
		Refreshing!;\
		Hope you're thirsty!;\
		Over 1 million drinks sold!;\
		Thirsty? Why not cola?;\
		Please, have a drink!;\
		Drink up!;\
		The best drinks in space.\
	"}
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 1,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1,
		/obj/item/reagent_containers/food/drinks/cans/ionbru = 1,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 1,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 1,
		/obj/item/reagent_containers/food/drinks/cans/cola_pork = 10,
		/obj/item/reagent_containers/food/drinks/cans/syndicola = 5
	)
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 0,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 0,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 0,
		/obj/item/reagent_containers/food/drinks/cans/ionbru = 0,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 0,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 0,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 0,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 0,
		/obj/item/reagent_containers/food/drinks/cans/cola_pork = 0,
		/obj/item/reagent_containers/food/drinks/cans/syndicola = 0
	)
	rare_products = list(
		/obj/item/reagent_containers/food/drinks/cans/cola_pork = 75,
		/obj/item/reagent_containers/food/drinks/cans/syndicola = 30

	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5,
		/obj/item/reagent_containers/food/snacks/liquidfood = 6
	)
