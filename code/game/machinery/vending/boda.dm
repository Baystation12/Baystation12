/obj/machinery/vending/sovietsoda
	name = "\improper BODA"
	desc = "An old soda vending machine. How could this have got here?"
	icon_state = "sovietsoda"
	icon_vend = "sovietsoda-vend"
	icon_deny = "sovietsoda-deny"
	base_type = /obj/machinery/vending/sovietsoda
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/reagent_containers/food/drinks/cans/syndicola = 50,
					/obj/item/reagent_containers/food/drinks/cans/syndicolax = 30,
					/obj/item/reagent_containers/food/drinks/cans/artbru = 20,
					/obj/item/reagent_containers/food/drinks/glass2/square/boda = 20,
					/obj/item/reagent_containers/food/drinks/glass2/square/bodaplus = 20)
	contraband = list(/obj/item/reagent_containers/food/drinks/bottle/space_up = 300) // TODO Russian cola can
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
