/obj/item/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawmeatball"
	filling_color = "#ce3711"
	bitesize = 2
	center_of_mass = "x=16;y=15"


/obj/item/reagent_containers/food/snacks/rawmeatball/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)


/datum/chemical_reaction/rawmeatball
	name = "Raw Meatball"
	result = null
	required_reagents = list(
		/datum/reagent/nutriment/protein = 3,
		/datum/reagent/nutriment/flour = 5
	)
	result_amount = 3
	mix_message = "The flour thickens the processed meat until it clumps."


/datum/chemical_reaction/rawmeatball/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1 to created_volume)
		new /obj/item/reagent_containers/food/snacks/rawmeatball (location)


/obj/item/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"
	bitesize = 2


/obj/item/reagent_containers/food/snacks/meatball/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)


/datum/recipe/meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatball


/obj/item/reagent_containers/food/snacks/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"
	bitesize = 2


/obj/item/reagent_containers/food/snacks/sausage/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)


/datum/recipe/sausage
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/sausage


/obj/item/reagent_containers/food/snacks/fatsausage
	name = "fat sausage"
	desc = "A piece of mixed, long meat, with some bite to it."
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=16"
	bitesize = 2


/obj/item/reagent_containers/food/snacks/fatsausage/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)


/datum/recipe/fatsausage
	reagents = list(
		/datum/reagent/blackpepper = 2
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/fatsausage


/obj/item/storage/fancy/bugmeat
	name = "box of insect protein"
	desc = "What a horrible idea. Who funded this?"
	icon = 'packs/event_2022jul30/bugmeat.dmi'
	icon_state = "box"
	storage_slots = 6
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat,
		/obj/item/reagent_containers/food/snacks/cutlet/bugmeat
	)
	startswith = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat = 6
	)


/obj/item/storage/fancy/bugmeat/on_update_icon()
	if (opened)
		icon_state = "box-open"
	else
		icon_state = "box"


/decl/hierarchy/supply_pack/galley/bugmeat
	name = "Perishables - Insect Protein"
	contains = list(/obj/item/storage/fancy/bugmeat = 2)
	containertype = /obj/item/storage/backpack/dufflebag
	containername = "insect protein dufflebag"
	cost = 20
