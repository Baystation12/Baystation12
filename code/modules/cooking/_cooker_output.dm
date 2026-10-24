/obj/item/reagent_containers/food/snacks/var/list/combined_names

// Wrapper obj for cooked food. Appearance is set in the cooking code, not on spawn.
/obj/item/reagent_containers/food/snacks/variable
	name = "cooked food"
	icon = 'icons/obj/food/food_custom.dmi'
	desc = "If you can see this description then something is wrong. Please report the bug on the tracker."
	bitesize = 2
	w_class = ITEM_SIZE_SMALL

	var/size = 5 //The quantity of reagents which is considered "normal" for this kind of food
	//These objects will change size depending on the ratio of reagents to this value
	var/min_scale = 0.5
	var/max_scale = 2
	var/scale = 1
	var/prefix

/obj/item/reagent_containers/food/snacks/variable/Initialize()
	. = ..()
	if (reagents)
		reagents.maximum_volume = size * 8 + 10
	else
		create_reagents(size * 8 + 10)
	update_icon()

/obj/item/reagent_containers/food/snacks/variable/on_reagent_change()
	return

/obj/item/reagent_containers/food/snacks/variable/proc/update_prefix()
	switch(scale)
		if (0 to 0.8)
			prefix = "small"
		if (0.8 to 1.2)
			prefix = "large"
		if (1.2 to 1.4)
			prefix = "extra large"
		if (1.4 to 1.6)
			prefix = "huge"
		if (1.6 to INFINITY)
			prefix = "massive"
	if(scale == min_scale)
		prefix = "tiny"

	name = "[prefix] [name]"

/obj/item/reagent_containers/food/snacks/proc/get_name_sans_prefix()
	return name

/obj/item/reagent_containers/food/snacks/variable/get_name_sans_prefix()
	return jointext(splittext(..(), " ") - prefix, " ")

/obj/item/reagent_containers/food/snacks/variable/proc/update_scale()
	if (reagents && reagents.total_volume)
		var/ratio = reagents.total_volume / size
		scale = sqrt(ratio) //Scaling factor is square root of desired area
		scale = clamp(scale, min_scale, max_scale)
	else
		scale = min_scale
	w_class = round(initial(w_class) * scale)

/obj/item/reagent_containers/food/snacks/variable/on_update_icon(overwrite = FALSE)
	..()
	if(!scale || overwrite)
		update_scale()

	var/matrix/M = matrix()
	M.Scale(scale)
	transform = M

	if (!prefix || overwrite)
		update_prefix()

/obj/item/reagent_containers/food/snacks/variable/use_tool(obj/item/I, mob/living/user, list/click_params)
	if (istype(I, /obj/item/reagent_containers/food/snacks))
		combine(I, user)
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/variable/proc/combine(obj/item/reagent_containers/food/snacks/other, mob/user, request_input = TRUE)
	var/combined_count = length(combined_names)
	var/other_combined_count = length(other.combined_names)
	if (combined_count + other_combined_count > 4)
		to_chat(user, SPAN_WARNING("This food combination is too large."))
	if (request_input)
		var/response
		if (bitecount || other.bitecount)
			if (user.a_intent == I_HELP)
				to_chat(user, SPAN_WARNING("This food is partially eaten. Combining it would be disgusting."))
				return FALSE
			if (user.a_intent == I_HURT)
				to_chat(user, SPAN_WARNING("This food is partially eaten.") + SPAN_NOTICE(" You combine it anyway."))
			else
				response = alert(user, "Combine Food Scraps?", "Combine Food", "Yes", "No") == "Yes"
				if (!response || !user.use_sanity_check(src, other))
					return FALSE
		if (!response && user.a_intent == I_HELP)
			response = alert(user, "Combine Food?", "Combine Food", "Yes", "No") == "Yes"
			if (!response || !user.use_sanity_check(src, other))
				return FALSE
		if (!user.unEquip(other, src))
			return FALSE
	if (!combined_count)
		combined_names = list(name)
		name = "[name] meal"
	if (other_combined_count)
		combined_names += other.combined_names
	else
		combined_names += other.name
	desc = "\A [combined_names[1]] with [english_list(combined_names.Copy(2))]"
	var/other_volume = other.reagents?.total_volume
	if (other_volume)
		var/volume = reagents.total_volume + other_volume
		if (reagents.maximum_volume < volume)
			reagents.maximum_volume = volume
		other.reagents.trans_to(src, volume)
	for (var/hint in other.nutriment_desc)
		if (!nutriment_desc[hint])
			nutriment_desc[hint] = 0
		nutriment_desc[hint] += other.nutriment_desc[hint]
	bitesize += (other.bitesize - other.bitecount)
	var/image/I = image(other.icon, other.icon_state)
	I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	I.pixel_x = rand(-8, 8)
	I.pixel_y = rand(-8, 8)
	I.color = other.color
	I.CopyOverlays(other)
	I.SetTransform(scale = 0.8)
	AddOverlays(I)
	qdel(other)
	return TRUE

/obj/item/reagent_containers/food/snacks/variable/pizza
	name = "pizza"
	desc = "A tasty oven pizza meant to be shared."
	icon_state = "pizza"
	size = 40
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/variable/pizzaslice
	w_class = ITEM_SIZE_NORMAL

/obj/item/reagent_containers/food/snacks/variable/pizzaslice
	name = "pizza slice"
	desc = "A tasty slice of pizza."
	icon_state = "pizza_slice"
	w_class = ITEM_SIZE_SMALL

/obj/item/reagent_containers/food/snacks/variable/pizzaslice/on_update_icon()
	. = ..()
	//Filling overlay
	var/image/I = image(icon, "[icon_state]_filling")
	I.color = filling_color
	AddOverlays(I)

/obj/item/reagent_containers/food/snacks/variable/bread
	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"
	size = 40
	w_class = ITEM_SIZE_NORMAL

/obj/item/reagent_containers/food/snacks/variable/pie
	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"
	size = 25

/obj/item/reagent_containers/food/snacks/variable/cake
	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"
	slices_num = 5
	slice_path = /obj/item/reagent_containers/food/snacks/variable/cakeslice
	size = 40
	w_class = ITEM_SIZE_NORMAL

/obj/item/reagent_containers/food/snacks/variable/cakeslice
	name = "cake slice"
	desc = "A slice of cake"
	icon_state = "cakeslicecustom"
	trash = /obj/item/trash/plate
	w_class = ITEM_SIZE_SMALL
	size = 8

/obj/item/reagent_containers/food/snacks/variable/cakeslice/on_update_icon()
	. = ..()
	//Filling overlay
	var/image/I = image(icon, "[icon_state]_filling")
	I.color = filling_color
	AddOverlays(I)

/obj/item/reagent_containers/food/snacks/variable/pocket
	name = "hot pocket"
	desc = "You wanna put a bangin- oh, nevermind."
	icon_state = "donk"
	size = 8
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/kebab
	name = "kebab"
	desc = "Remove this!"
	icon_state = "kabob"
	size = 10

/obj/item/reagent_containers/food/snacks/variable/waffles
	name = "waffles"
	desc = "Made with love."
	icon_state = "waffles"
	size = 12

/obj/item/reagent_containers/food/snacks/variable/cookie
	name = "cookie"
	desc = "Sugar snap!"
	icon_state = "cookie"
	size = 6
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/donut
	name = "filled donut"
	desc = "Donut steal."
	icon_state = "donut"
	size = 8
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/jawbreaker
	name = "flavored jawbreaker"
	desc = "It's like cracking a molar on a rainbow."
	icon_state = "jawbreaker"
	size = 4
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/candybar
	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "bar"
	size = 6
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/sucker
	name = "flavored sucker"
	desc = "Suck, suck, suck."
	icon_state = "sucker"
	size = 4
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/softcandy
	name = "flavored soft taffy"
	desc = "It's so soft and sticky."
	icon_state = "softcandy"
	size = 3
	w_class = ITEM_SIZE_TINY


/obj/item/reagent_containers/food/snacks/variable/jelly
	name = "jelly"
	desc = "All your friends will be jelly."
	icon_state = "jellycustom"
	size = 8

/obj/item/reagent_containers/food/snacks/variable/stuffing
	name = "stuffing"
	desc = "Get stuffed."
	icon_state = "stuffing"
	nutriment_amt = 3
	nutriment_desc = list("stuffing" = 3)

/obj/item/reagent_containers/food/snacks/variable/shreds
	name = "shreds"
	desc = "Gnarly."
	icon_state = "shreds" //NB: there is no base icon state and that is intentional

/obj/item/reagent_containers/food/snacks/variable/cereal
	name = "cereal"
	desc = "Crispy and flaky"
	icon_state = "cereal_box"
	size = 30
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/cereal/Initialize()
	. =..()
	name = pick(list("flakes", "krispies", "crunch", "pops", "O's", "crisp", "loops", "jacks", "clusters"))

/obj/item/reagent_containers/food/snacks/variable/stew
	name = "stew"
	desc = "A hearty classic."
	icon_state = "stew"
	nutriment_amt = 4
	nutriment_desc = list("stew" = 3)
	trash = /obj/item/trash/pot

/obj/item/reagent_containers/food/snacks/variable/mob
	desc = "Poor little thing."
	size = 5
	w_class = ITEM_SIZE_TINY
	var/kitchen_tag = "animal"
