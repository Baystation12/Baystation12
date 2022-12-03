/obj/machinery/vending/snix
	name = "\improper Snix"
	desc = "An old snack vending machine, how did it get here? And are the snacks still good?"
	icon_state = "snix"
	icon_vend = "snix-vend"
	icon_deny = "snix-deny"
	base_type = /obj/machinery/vending/snix
	product_slogans = {"\
		Snix!\
	"}
	products = list(
		/obj/item/reagent_containers/food/snacks/semki = 7,
		/obj/item/reagent_containers/food/snacks/canned/caviar = 7,
		/obj/item/reagent_containers/food/snacks/squid = 7,
		/obj/item/reagent_containers/food/snacks/croutons = 7,
		/obj/item/reagent_containers/food/snacks/salo = 7,
		/obj/item/reagent_containers/food/snacks/driedfish = 7,
		/obj/item/reagent_containers/food/snacks/pistachios = 7
	)
	contraband = list(
		/obj/item/reagent_containers/food/snacks/canned/caviar/true = 1
	)


/obj/machinery/vending/snix/on_update_icon()
	..()
	if (is_powered())
		overlays += image(icon, "[initial(icon_state)]-fan")
