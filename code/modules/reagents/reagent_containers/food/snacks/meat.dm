/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	filling_color = "#ff1c1c"
	center_of_mass = "x=16;y=14"
	bitesize = 3


/obj/item/reagent_containers/food/snacks/meat/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 9)


/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A slab of flesh synthetized from reconstituted biomass or artificially grown from chemicals."

// Separate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/meat/human
/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/meat/beef
	name = "beef steak"
	desc = "The classic red meat."

/obj/item/reagent_containers/food/snacks/meat/goat
	name = "chevon steak"
	desc = "Goat meat, to the uncultured."

/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "chicken piece"
	desc = "It tastes like you'd expect."
	icon_state = "birdmeat"

/obj/item/reagent_containers/food/snacks/meat/chicken/game
	name = "game bird piece"
	desc = "Fresh game meat, harvested from some wild bird."

/obj/item/reagent_containers/food/snacks/meat/thoom
	name = "reptile steak"
	desc = "The most expensive steak you've ever laid eyes on."
	icon_state = "xenomeat"
