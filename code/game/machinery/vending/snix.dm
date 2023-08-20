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
	antag_slogans = {"\
		Delicious food designed to bend the feeble Solarians to your will!;\
		Snix! A silly brand name worth invading Sol over.;\
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
	rare_products = list(
		/obj/item/storage/box/syndie_kit/imp_imprinting = 50
	)
	contraband = list(
		/obj/item/reagent_containers/food/snacks/canned/caviar/true = 1
	)
	antag = list(
		/obj/item/storage/box/syndie_kit/toxin = 1,
		/obj/item/storage/box/syndie_kit/imp_imprinting = 0
	)


/obj/machinery/vending/snix/on_update_icon()
	..()
	if (is_powered())
		AddOverlays(image(icon, "[initial(icon_state)]-fan"))
