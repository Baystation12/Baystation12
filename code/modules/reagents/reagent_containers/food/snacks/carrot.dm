/obj/item/weapon/reagent_containers/food/snacks/carrotfries
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#faa005"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("carrot" = 3, "salt" = 1)
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/carrotfries/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/imidazoline, 3)
