/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7d5f46"
	center_of_mass = "x=15;y=15"
	nutriment_amt = 1
	nutriment_desc = list("candy" = 1)


/obj/item/weapon/reagent_containers/food/snacks/candy/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/sugar, 3)

/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar
	name = "protein bar"
	desc = "SwoleMAX brand protein bars, guaranteed to get you feeling perfectly overconfident."
	icon_state = "proteinbar"
	trash = /obj/item/trash/candy/proteinbar
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment, 9)
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)
	reagents.add_reagent(/datum/reagent/sugar, 1)


/obj/item/weapon/reagent_containers/food/snacks/candy/donor
	name = "Donor Candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	nutriment_desc = list("candy" = 10)
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/candy/donor/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment, 10)

/obj/item/weapon/reagent_containers/food/snacks/candy/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	filling_color = "#fffcb0"
	center_of_mass = "x=14;y=10"
	nutriment_amt = 4
	nutriment_desc = list("candy corn" = 4)

/obj/item/weapon/reagent_containers/food/snacks/candy/candy_corn/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment, 4)

/obj/item/weapon/reagent_containers/food/snacks/candy/chocolatebar
	name = "Chocolate Bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7d5f46"
	center_of_mass = "x=15;y=15"
	nutriment_amt = 2
	nutriment_desc = list("chocolate" = 5)

/obj/item/weapon/reagent_containers/food/snacks/candy/chocolatebar/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/coco, 2)

/obj/item/weapon/reagent_containers/food/snacks/candy/chocolateegg
	name = "Chocolate Egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7d5f46"
	center_of_mass = "x=16;y=13"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)

/obj/item/weapon/reagent_containers/food/snacks/candy/chocolateegg/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/coco, 2)

/obj/item/weapon/reagent_containers/food/snacks/candiedapple //Debatable if candy.
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#f21873"
	center_of_mass = "x=15;y=13"
	nutriment_desc = list("apple" = 3, "caramel" = 3, "sweetness" = 2)
	nutriment_amt = 3
	bitesize = 3