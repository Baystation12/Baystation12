/obj/item/reagent_containers/food/snacks/meat
	abstract_type = /obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	icon = 'icons/obj/meat.dmi'
	icon_state = "meat"
	desc = "A slab of meat."
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	filling_color = "#ff1c1c"
	center_of_mass = "x=16;y=14"
	bitesize = 3


/obj/item/reagent_containers/food/snacks/meat/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 9)


// intentionally identical to base meat
/obj/item/reagent_containers/food/snacks/meat/human


// intentionally identical to base meat
/obj/item/reagent_containers/food/snacks/meat/monkey


/obj/item/reagent_containers/food/snacks/meat/synthmeat
	name = "synthetic meat"
	icon_state = "synthmeat"
	desc = "A slab of flesh synthetized from reconstituted biomass or artificially grown from chemicals."


/obj/item/reagent_containers/food/snacks/meat/beef
	name = "beef slab"
	desc = "The classic red meat."


/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."


/obj/item/reagent_containers/food/snacks/meat/goat
	name = "chevon slab"
	desc = "Goat meat, to the uncultured."
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet/goat


/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "chicken piece"
	desc = "It tastes like you'd expect."
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet/chicken


/obj/item/reagent_containers/food/snacks/meat/gamebird
	name = "game bird piece"
	desc = "Fresh game meat, harvested from some wild bird."
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet/gamebird


/obj/item/reagent_containers/food/snacks/meat/thoom
	name = "reptile steak"
	desc = "The most expensive steak you've ever laid eyes on."
