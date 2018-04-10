/obj/item/weapon/reagent_containers/food/snacks/fishfingers
	name = "fish fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#ffdefe"
	center_of_mass = "x=16;y=13"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/fishfingers/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)


/obj/item/weapon/reagent_containers/food/snacks/fishandchips
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	filling_color = "#e3d796"
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("salt" = 1, "chips" = 3)
	nutriment_amt = 3
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/fishandchips/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)

