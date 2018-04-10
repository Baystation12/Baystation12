//Bread file. We have a lot of weird bread things.

/obj/item/weapon/reagent_containers/food/snacks/twobread
	name = "Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#dbcc9a"
	center_of_mass = "x=15;y=12"
	nutriment_desc = list("sourness" = 2, "bread" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/threebread
	name = "Three Bread"
	desc = "Is such a thing even possible?"
	icon_state = "threebread"
	filling_color = "#dbcc9a"
	center_of_mass = "x=15;y=12"
	nutriment_desc = list("sourness" = 2, "bread" = 3)
	nutriment_amt = 3
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast
	name = "Jellied Toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#b572ab"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("toasted bread" = 2)
	nutriment_amt = 1
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/cherry/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/cherryjelly, 5)

/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/slime/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/slimejelly, 5)

/obj/item/weapon/reagent_containers/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#e3d796"
	center_of_mass = "x=18;y=12"
	nutriment_desc = list("french bread" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/baguette/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/blackpepper, 1)
	reagents.add_reagent(/datum/reagent/sodiumchloride, 1)

/obj/item/weapon/reagent_containers/food/snacks/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#c9ac83"
	center_of_mass = "x=16;y=10"
	nutriment_amt = 3
	nutriment_desc = list("dryness" = 2, "bread" = 2)
	bitesize = 1