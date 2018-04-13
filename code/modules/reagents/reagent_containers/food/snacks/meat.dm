//Consolidated file for "meaty" foods.

/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "meat"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	health = 180
	filling_color = "#ff1c1c"
	center_of_mass = "x=16;y=14"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/meat/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 9)

/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A slab of flesh synthetized from reconstituted biomass or artificially grown from chemicals."
	icon = 'icons/obj/food.dmi'

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/weapon/reagent_containers/food/snacks/meat/human
/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/weapon/reagent_containers/food/snacks/meat/beef
	name = "beef slab"
	desc = "The classic red meat."

/obj/item/weapon/reagent_containers/food/snacks/meat/goat
	name = "chevon slab"
	desc = "Goat meat, to the uncultured."

/obj/item/weapon/reagent_containers/food/snacks/meat/chicken
	name = "chicken piece"
	desc = "It tastes like you'd expect."

//Technically part of the above group (it comes from the gibber), but.. Also inexplicably not.
/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of space carp meat."
	icon_state = "fishfillet"
	filling_color = "#ffdefe"
	center_of_mass = "x=17;y=13"
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/carpmeat/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)
	reagents.add_reagent(/datum/reagent/toxin/carpotoxin, 6)


/obj/item/weapon/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	filling_color = "#db0000"
	center_of_mass = "x=17;y=16"
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=10"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/bearmeat/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 12)
	reagents.add_reagent(/datum/reagent/hyperzine, 5)

/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43de18"
	center_of_mass = "x=16;y=10"
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/xenomeat/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	reagents.add_reagent(/datum/reagent/acid/polyacid,6)

/obj/item/weapon/reagent_containers/food/snacks/human //Why?
	var/hname = ""
	var/job = null
	filling_color = "#d63c3c"
	nutriment_desc = list("fresh veal" = 1, "sweet beef" = 1, "bitter pork" = 1)

//Meaty foods.

/obj/item/weapon/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"

/obj/item/weapon/reagent_containers/food/snacks/meatball/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)

/obj/item/weapon/reagent_containers/food/snacks/sausage
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"

/obj/item/weapon/reagent_containers/food/snacks/sausage/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)


/obj/item/weapon/reagent_containers/food/snacks/fatsausage
	name = "Fat Sausage"
	desc = "A piece of mixed, long meat with some bite to it."
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"

/obj/item/weapon/reagent_containers/food/snacks/fatsausage/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)

/obj/item/weapon/reagent_containers/food/snacks/meatkabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#a85340"
	center_of_mass = "x=17;y=15"

/obj/item/weapon/reagent_containers/food/snacks/meatkabob/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)

/obj/item/weapon/reagent_containers/food/snacks/plainsteak
	name = "Plain steak"
	desc = "A piece of unseasoned cooked meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "steak"
	filling_color = "#7a3d11"
	center_of_mass = "x=16;y=13"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/plainsteak/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)


/obj/item/weapon/reagent_containers/food/snacks/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7a3d11"
	center_of_mass = "x=16;y=13"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/meatsteak/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)
	reagents.add_reagent(/datum/reagent/sodiumchloride, 1)
	reagents.add_reagent(/datum/reagent/blackpepper, 1)

/obj/item/weapon/reagent_containers/food/snacks/loadedsteak
	name = "Loaded steak"
	desc = "A steak slathered in sauce with sauteed onions and mushrooms."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7a3d11"
	center_of_mass = "x=16;y=13"

	nutriment_desc = list("onion" = 2, "mushroom" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/loadedsteak/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)
	reagents.add_reagent(/datum/reagent/nutriment/garlicsauce, 2)