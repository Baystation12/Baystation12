/obj/item/weapon/reagent_containers/food/snacks/liquidfood
	name = "\improper LiquidFood MRE"
	desc = "A prepackaged grey slurry for all of the essential nutrients a soldier requires to survive. No expiration date is visible..."
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#a8a8a8"
	center_of_mass = "x=16;y=15"
	nutriment_desc = list("chalk" = 6)
	nutriment_amt = 20
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/liquidfood/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/iron, 3)
