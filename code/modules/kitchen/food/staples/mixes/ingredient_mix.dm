#define MIN_NOTABLE_REAGENT 5

// Base object for procs.
/obj/item/weapon/reagent_containers/food/snacks/ingredient_mix
	icon = 'icons/obj/kitchen/staples/dough.dmi'
	icon_state = "dough"

	var/list/base_ingredients = list()
	var/list/reagent_ingredients = list()
	var/content_descriptor
	var/examined_descriptor
	var/list/global/appearance_ignores_reagents = list("sugar","nutriment","egg","milk","protein","water")

/obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/update_icon()
	return

/obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/proc/apply_name()
	name = initial(name)
	if(!isnull(content_descriptor) && content_descriptor != "")
		name = "[content_descriptor] [name]"
	desc = initial(desc)
	if(!isnull(examined_descriptor) && examined_descriptor != "")
		desc += " Tastes of [content_descriptor]."
	update_icon()

/obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/proc/update_from_ingredients()
	// Reset name-desc
	content_descriptor = ""
	// Reset desc-desc
	examined_descriptor = ""
	// Update descs from lists set in update_from_contents().
	var/i = 0
	for(var/thing in base_ingredients)
		i++
		if(i == 1)
			content_descriptor += "[thing]"
		else if(i == base_ingredients.len)
			content_descriptor += " and [thing]"
		else
			content_descriptor += ", [thing]"

	for(var/thing in reagent_ingredients)
		i++
		if(i == 1)
			examined_descriptor += "[thing]"
		else if(i == reagent_ingredients.len)
			examined_descriptor += " and [thing]"
		else
			examined_descriptor += ", [thing]"
	// Apply new descs.
	content_descriptor = lowertext(trim(content_descriptor))
	examined_descriptor = lowertext(trim(examined_descriptor))
	apply_name()
	update_icon()

/obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/proc/update_from_contents()
	// Init lists.
	if(!islist(base_ingredients))    base_ingredients = list()
	if(!islist(reagent_ingredients)) reagent_ingredients = list()
	// Grab all relevant ingredient strings.
	for(var/obj/item/O in contents)
		base_ingredients[O.name] = O.color ? O.color : 0
		if(O.reagents && O.reagents.total_volume)
			O.reagents.trans_to_obj(src,O.reagents.total_volume)
		qdel(O)
	if(reagents && reagents.reagent_list && reagents.total_volume)
		for(var/datum/reagent/R in reagents.reagent_list)
			if((R.volume < MIN_NOTABLE_REAGENT) || (R.id in appearance_ignores_reagents))
				continue
			reagent_ingredients[R.name] = R.color ? R.color : 0
	// Apply results.
	update_from_ingredients()
	apply_name()

#undef MIN_NOTABLE_REAGENT