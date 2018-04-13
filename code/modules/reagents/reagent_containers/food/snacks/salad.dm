/obj/item/weapon/reagent_containers/food/snacks/aesirsalad
	name = "Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468c00"
	center_of_mass = "x=17;y=11"
	nutriment_amt = 8
	nutriment_desc = list("apples" = 3,"salad" = 5)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/aesirsalad/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/doctor_delight, 8)
	reagents.add_reagent(/datum/reagent/tricordrazine, 8)

/obj/item/weapon/reagent_containers/food/snacks/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = "x=17;y=11"
	nutriment_desc = list("salad" = 2, "tomato" = 2, "carrot" = 2, "apple" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it." //Ambrosia isn't illegal.
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = "x=17;y=11"
	nutriment_desc = list("100% real salad")
	nutriment_amt = 6
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/validsalad/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/weapon/reagent_containers/food/snacks/spesslaw
	name = "Spesslaw"
	desc = "A lawyers favourite."
	icon_state = "spesslaw"
	filling_color = "#de4545"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/spesslaw/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)
