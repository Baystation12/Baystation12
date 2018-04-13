//Basically anything I didn't want to categorize or otherwise didn't fit into a category.

/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5c3c11"
	center_of_mass = "x=16;y=13"
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)
	reagents.add_reagent(/datum/reagent/drink/juice/banana, 5)
	reagents.add_reagent(/datum/reagent/blackpepper, 1)
	reagents.add_reagent(/datum/reagent/sodiumchloride, 1)


/obj/item/weapon/reagent_containers/food/snacks/onionrings //Put this into its own file if we get more onion recipes.
	name = "Onion Rings"
	desc = "Like circular fries but better."
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5


/obj/item/weapon/reagent_containers/food/snacks/boiledslimecore
	name = "Boiled slime Core"
	desc = "A boiled red thing."
	icon_state = "boiledslimecore" //nonexistant?
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/boiledslimecore/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/slimejelly, 5)


/obj/item/weapon/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "it is only wafer thin."
	icon_state = "mint"
	filling_color = "#f2f2f2"
	center_of_mass = "x=16;y=14"
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/mint/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/nutriment/mint, 1)


/obj/item/weapon/reagent_containers/food/snacks/cracker
	name = "Cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#f5deb8"
	center_of_mass = "x=17;y=6"
	nutriment_desc = list("salt" = 1, "cracker" = 2)
	nutriment_amt = 1

/obj/item/weapon/reagent_containers/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754b"
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("a chorus of flavor" = 6)
	nutriment_amt = 6


/obj/item/weapon/reagent_containers/food/snacks/dionaroast/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/radium, 2)

/obj/item/weapon/reagent_containers/food/snacks/enchiladas
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#a36a1f"
	center_of_mass = "x=16;y=13"
	nutriment_desc = list("tortilla" = 3, "corn" = 3)
	nutriment_amt = 2
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/enchiladas/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	reagents.add_reagent(/datum/reagent/capsaicin, 6)


/obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant." //More like just only.
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4d2f5e"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("cheese" = 3, "eggplant" = 3)
	nutriment_amt = 6