/obj/machinery/appliance/mixer/candy
	name = "candy machine"
	desc = "Get yer candied cheese wheels here!"
	icon_state = "mixer_off"
	off_icon = "mixer_off"
	on_icon = "mixer_on"
	cook_type = "candied"
	cooking_coeff = 1.0

	output_options = list(
		"Jawbreaker" = /obj/item/reagent_containers/food/snacks/variable/jawbreaker,
		"Candy Bar" = /obj/item/reagent_containers/food/snacks/variable/candybar,
		"Sucker" = /obj/item/reagent_containers/food/snacks/variable/sucker,
		"Jelly" = /obj/item/reagent_containers/food/snacks/variable/jelly,
		"Soft Candy" = /obj/item/reagent_containers/food/snacks/variable/softcandy
	)

/obj/machinery/appliance/mixer/candy/change_product_appearance(obj/item/reagent_containers/food/snacks/product)
	food_color = get_random_colour(1)
	. = ..()
