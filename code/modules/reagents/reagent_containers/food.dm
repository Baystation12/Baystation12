////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food
	randpixel = 6
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/filling_color = "#ffffff" //Used by sandwiches.
	var/datum/extension/scent/scent_extension


/obj/item/reagent_containers/food/Initialize()
	. = ..()
	if (ispath(scent_extension))
		set_extension(src, scent_extension)


/obj/item/reagent_containers/food/on_color_transfer_reagent_change()
	for(var/datum/reagent/R in reagents.reagent_list)
		if (!R.color_foods)
			continue
		color = R.color //Possible todo: Mixing of food-coloring reagents for final result?
