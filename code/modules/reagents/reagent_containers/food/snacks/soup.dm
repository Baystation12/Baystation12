/obj/item/weapon/reagent_containers/food/snacks/stew
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9e673a"
	center_of_mass = "x=16;y=5"
	nutriment_desc = list("tomato" = 2, "potato" = 2, "carrot" = 2, "eggplant" = 2, "mushroom" = 2)
	nutriment_amt = 6
	bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/stew/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 5)
	reagents.add_reagent(/datum/reagent/imidazoline, 5)
	reagents.add_reagent(/datum/reagent/water, 5)


/obj/item/weapon/reagent_containers/food/snacks/milosoup
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("soy" = 8)
	nutriment_amt = 8
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/milosoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 5)

/obj/item/weapon/reagent_containers/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#e386bf"
	center_of_mass = "x=17;y=10"
	nutriment_desc = list("mushroom" = 8, "milk" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fac9ff"
	center_of_mass = "x=15;y=8"
	nutriment_desc = list("tomato" = 4, "beet" = 4)
	nutriment_amt = 8


/obj/item/weapon/reagent_containers/food/snacks/beetsoup/Initialize()
		. = ..()
		name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht", "beet soup"))

/obj/item/weapon/reagent_containers/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"
	center_of_mass = "x=16;y=8"
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/meatballsoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)
	reagents.add_reagent(/datum/reagent/water, 5)


/obj/item/weapon/reagent_containers/food/snacks/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup" //nonexistant?
	filling_color = "#c4dba0"
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/slimesoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/slimejelly, 5)
	reagents.add_reagent(/datum/reagent/water, 10)

/obj/item/weapon/reagent_containers/food/snacks/bloodsoup
	name = "Tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#ff0000"
	center_of_mass = "x=16;y=7"
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/bloodsoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)
	reagents.add_reagent(/datum/reagent/blood, 10)
	reagents.add_reagent(/datum/reagent/water, 5)


/obj/item/weapon/reagent_containers/food/snacks/clownstears
	name = "Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#c4fbff"
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("salt" = 1, "the worst joke" = 3)
	nutriment_amt = 4
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/clownstears/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/banana, 5)
	reagents.add_reagent(/datum/reagent/water, 10)


/obj/item/weapon/reagent_containers/food/snacks/vegetablesoup
	name = "Vegetable soup"
	desc = "A highly nutritious blend of vegetative goodness. Guaranteed to leave you with a, er, \"souped-up\" sense of wellbeing."
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("carrot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2)
	nutriment_amt = 8
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/vegetablesoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 5)


/obj/item/weapon/reagent_containers/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "A mean, green, calorically lean dish derived from a poisonous plant. It has a rather acidic bite to its taste."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("salad" = 4, "egg" = 2, "potato" = 2)
	nutriment_amt = 8
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/nettlesoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 5)
	reagents.add_reagent(/datum/reagent/tricordrazine, 5)


/obj/item/weapon/reagent_containers/food/snacks/mysterysoup
	name = "Mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f082ff"
	center_of_mass = "x=16;y=6"
	nutriment_desc = list("backwash" = 1)
	nutriment_amt = 1
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/mysterysoup/Initialize()
	. = ..()
	var/mysteryselect = pick(1,2,3,4,5,6,7,8,9,10)
	switch(mysteryselect)
		if(1)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/capsaicin, 3)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 2)
		if(2)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/frostoil, 3)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 2)
		if(3)
			reagents.add_reagent(/datum/reagent/nutriment, 5)
			reagents.add_reagent(/datum/reagent/water, 5)
			reagents.add_reagent(/datum/reagent/tricordrazine, 5)
		if(4)
			reagents.add_reagent(/datum/reagent/nutriment, 5)
			reagents.add_reagent(/datum/reagent/water, 10)
		if(5)
			reagents.add_reagent(/datum/reagent/nutriment, 2)
			reagents.add_reagent(/datum/reagent/drink/juice/banana, 10)
		if(6)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/blood, 10)
		if(7)
			reagents.add_reagent(/datum/reagent/slimejelly, 10)
			reagents.add_reagent(/datum/reagent/water, 10)
		if(8)
			reagents.add_reagent(/datum/reagent/carbon, 10)
			reagents.add_reagent(/datum/reagent/toxin, 10)
		if(9)
			reagents.add_reagent(/datum/reagent/nutriment, 5)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 10)
		if(10)
			reagents.add_reagent(/datum/reagent/nutriment, 6)
			reagents.add_reagent(/datum/reagent/drink/juice/tomato, 5)
			reagents.add_reagent(/datum/reagent/imidazoline, 5)

/obj/item/weapon/reagent_containers/food/snacks/wishsoup
	name = "Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d1f4ff"
	center_of_mass = "x=16;y=11"
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/wishsoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 10)

	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent(/datum/reagent/nutriment, 8, list("something good" = 8))

/obj/item/weapon/reagent_containers/food/snacks/hotchili
	name = "Hot Chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ff3c00"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("chilli peppers" = 3)
	nutriment_amt = 3
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/hotchili/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)
	reagents.add_reagent(/datum/reagent/capsaicin, 3)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 2)



/obj/item/weapon/reagent_containers/food/snacks/coldchili
	name = "Cold Chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2b00ff"
	center_of_mass = "x=15;y=9"
	nutriment_desc = list("ice peppers" = 3)
	nutriment_amt = 3
	trash = /obj/item/trash/snack_bowl
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/coldchili/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)
	reagents.add_reagent(/datum/reagent/frostoil, 3)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 2)

/obj/item/weapon/reagent_containers/food/snacks/tomatosoup
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d92929"
	center_of_mass = "x=16;y=7"
	nutriment_desc = list("soup" = 5)
	nutriment_amt = 5
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/tomatosoup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 10)
