/obj/item/serving_bowl
	name = "serving bowl"
	desc = "A portion-sized bowl for serving hungry customers."
	icon = 'icons/obj/food/food_custom.dmi'
	icon_state = "serving_bowl"
	center_of_mass = "x=16;y=10"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 300)


/obj/item/serving_bowl/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (!istype(item, /obj/item/reagent_containers/food/snacks))
		return ..()
	if (is_path_in_list(item.type, list(/obj/item/reagent_containers/food/snacks/custombowl, /obj/item/reagent_containers/food/snacks/csandwich)))
		return ..()
	var/allowed = isturf(loc) | SHIFTL(src == user.l_hand, 1) | SHIFTL(src == user.r_hand, 2)
	if (!allowed)
		to_chat(user, SPAN_WARNING("Put down or hold the bowl first."))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/custombowl/bowl = new (get_turf(src), item)
	bowl.pixel_x = pixel_x
	bowl.pixel_y = pixel_y
	qdel(src)
	switch (allowed)
		if (2)
			user.put_in_l_hand(bowl)
		if (4)
			user.put_in_r_hand(bowl)
	return TRUE


/obj/item/reagent_containers/food/snacks/custombowl
	name = "serving bowl"
	desc = "A delicious bowl of food."
	icon = 'icons/obj/food/food_custom.dmi'
	icon_state = "serving_bowl"
	filling_color = null
	trash = /obj/item/serving_bowl
	bitesize = 2
	can_use_cooker = FALSE
	var/list/ingredients = list()
	var/ingredients_left = 4
	var/fullname
	var/renamed


/obj/item/reagent_containers/food/snacks/custombowl/Destroy()
	ingredients.Cut()
	return ..()


/obj/item/reagent_containers/food/snacks/custombowl/Initialize(mapload, ingredients)
	. = ..()
	if (islist(ingredients))
		for (var/ingredient in ingredients)
			UpdateIngredients(ingredient)
	else if (isobj(ingredients))
		UpdateIngredients(ingredients)


/obj/item/reagent_containers/food/snacks/custombowl/verb/rename_bowl()
	set name = "Rename Bowl"
	set category = "Object"
	if (renamed)
		return
	var/response = sanitizeSafe(input(usr, "Enter a new name for \the [src]."), 32)
	if (!response)
		return
	to_chat(usr, SPAN_ITALIC("You rename \the [src] to \"[response]\"."))
	SetName("\improper [response]")
	verbs -= /obj/item/reagent_containers/food/snacks/custombowl/verb/rename_bowl
	renamed = TRUE


/obj/item/reagent_containers/food/snacks/custombowl/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (!istype(item, /obj/item/reagent_containers/food/snacks))
		return ..()
	if (is_path_in_list(item.type, list(/obj/item/reagent_containers/food/snacks/custombowl, /obj/item/reagent_containers/food/snacks/csandwich)))
		return ..()
	if (ingredients_left < 1)
		to_chat(user, SPAN_WARNING("There's no room for any more ingredients in \the [src]."))
		return TRUE
	if (!user.unEquip(item, src))
		FEEDBACK_UNEQUIP_FAILURE(user, item)
		return TRUE
	user.visible_message(
		SPAN_ITALIC("\The [user] adds \a [item] to \the [src]."),
		SPAN_NOTICE("You add \the [item] to \the [src]."),
		range = 3
	)
	UpdateIngredients(item, user)
	return TRUE

/obj/item/reagent_containers/food/snacks/custombowl/proc/UpdateIngredients(obj/item/reagent_containers/food/snacks/snack)
	snack.reagents.trans_to_obj(src, snack.reagents.total_volume)
	if (isnull(filling_color))
		filling_color = snack.filling_color
	ingredients |= snack.name
	var/image/image = new (icon, "serving_bowl_[ingredients_left]")
	image.color = snack.filling_color
	AddOverlays(image)
	fullname = english_list(ingredients)
	SetName(lowertext("[fullname] bowl"))
	--ingredients_left
	if (renamed)
		verbs += /obj/item/reagent_containers/food/snacks/custombowl/verb/rename_bowl
		renamed = FALSE
	qdel(snack)


/obj/item/reagent_containers/food/snacks/custombowl/examine(mob/user, distance)
	. = ..(user)
	if (distance < 2)
		to_chat(user, SPAN_ITALIC("This one contains [fullname]."))
