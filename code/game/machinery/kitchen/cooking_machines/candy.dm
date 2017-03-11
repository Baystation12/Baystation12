/obj/machinery/cooker/candy
	name = "candy machine"
	desc = "A machine used to produce various confectioneries."
	icon_state = "mixer_off"
	off_icon = "mixer_off"
	on_icon = "mixer_on"
	cook_type = "candied"

	output_options = list(
		"Jawbreaker" = /obj/item/weapon/reagent_containers/food/snacks/variable/jawbreaker,
		"Candy Bar" = /obj/item/weapon/reagent_containers/food/snacks/variable/candybar,
		"Sucker" = /obj/item/weapon/reagent_containers/food/snacks/variable/sucker,
		"Jelly" = /obj/item/weapon/reagent_containers/food/snacks/variable/jelly
		)

/obj/machinery/cooker/candy/change_product_appearance(var/obj/item/weapon/reagent_containers/food/snacks/cooked/product)
	food_color = get_random_colour(1)
	. = ..()
