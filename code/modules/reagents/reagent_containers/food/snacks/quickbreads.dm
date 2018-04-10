//Consolidated quickbread file. Look up what a quickbread is before you add to this file.
/obj/item/weapon/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles."
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#e6deb5"
	center_of_mass = "x=15;y=11"
	nutriment_desc = list("waffle" = 8)
	nutriment_amt = 8

/obj/item/weapon/reagent_containers/food/snacks/pancakesblu
	name = "blueberry pancakes"
	desc = "Pancakes with blueberries, delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = "x=15;y=11"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8


/obj/item/weapon/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Pancakes without blueberries, still delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = "x=15;y=11"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8


obj/item/weapon/reagent_containers/food/snacks/rofflewaffles //Could go in mushroom, but let's face it, it's a quickbread.
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#ff00f7"
	center_of_mass = "x=15;y=11"
	nutriment_desc = list("waffle" = 7, "sweetness" = 1)
	nutriment_amt = 8
	bitesize = 4

obj/item/weapon/reagent_containers/food/snacks/rofflewaffles/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/psilocybin, 8)
