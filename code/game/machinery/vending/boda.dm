/obj/machinery/vending/sovietsoda
	name = "\improper BODA"
	desc = "An old soda vending machine. How could this have got here?"
	icon_state = "sovietsoda"
	icon_vend = "sovietsoda-vend"
	icon_deny = "sovietsoda-deny"
	base_type = /obj/machinery/vending/sovietsoda
	idle_power_usage = 200
	product_ads = {"\
		For Tsar and Country.;\
		Have you fulfilled your nutrition quota today?;\
		Very nice!;\
		We are simple people, for this is all we eat.;\
		If there is a person, there is a problem. If there is no person, then there is no problem.\
	"}
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/syndicola = 10,
		/obj/item/reagent_containers/food/drinks/cans/syndicolax = 10,
		/obj/item/reagent_containers/food/drinks/cans/artbru = 10,
		/obj/item/reagent_containers/food/drinks/glass2/square/boda = 10,
		/obj/item/reagent_containers/food/drinks/glass2/square/bodaplus = 10
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/bottle/space_up = 5
	)
