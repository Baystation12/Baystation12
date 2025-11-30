/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food/pizza.dmi'
	icon_state = "box1"

	/// Whether the lid is open or not
	var/open = FALSE

	/// Whether to use the clean or pizza-stained inner lid icon
	var/messy = FALSE

	/// The path of a pizza to create on init, or the current pizza
	var/obj/item/reagent_containers/food/snacks/sliceable/pizza

	/// A list? of pizza boxes in the stack this parents, if any
	var/list/obj/item/pizzabox/boxes

	/// Optional name of this box's pizza. If a list, picked at init
	var/boxtag


/obj/item/pizzabox/Destroy()
	QDEL_NULL(pizza)
	QDEL_NULL_LIST(boxes)
	return ..()


/obj/item/pizzabox/Initialize()
	. = ..()
	if (ispath(pizza))
		pizza = new pizza (src)
		queue_icon_update()
	if (islist(boxtag))
		boxtag = pick(boxtag)


/obj/item/pizzabox/on_update_icon()
	ClearOverlays()
	var/last_box = length(boxes)
	if (open && pizza)
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if (length(boxes))
		desc = "A pile of boxes suited for pizzas. There appears to be [last_box + 1] boxes in the pile."
		var/obj/item/pizzabox/topbox = boxes[last_box]
		var/toptag = topbox.boxtag
		if (toptag)
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."
		if (boxtag)
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."
	if (open)
		if (messy)
			icon_state = "box_messy"
		else
			icon_state = "box_open"
		if (pizza)
			var/image/pizza_image = image(icon, icon_state = pizza.icon_state)
			if (istype(pizza, /obj/item/reagent_containers/food/snacks/variable/pizza))
				var/image/filling = image("food_custom.dmi", icon_state = "pizza_filling")
				filling.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
				filling.color = pizza.filling_color
				pizza_image.AddOverlays(filling)
			pizza_image.pixel_y = -3
			AddOverlays(pizza_image)
		return
	var/show_tag
	if (last_box)
		var/obj/item/pizzabox/topbox = boxes[last_box]
		if (topbox.boxtag)
			show_tag = TRUE
	else if (boxtag)
		show_tag = TRUE
	if (show_tag)
		var/image/tag_image = image(icon, icon_state = "box_tag")
		tag_image.pixel_y = last_box * 3
		AddOverlays(tag_image)
	icon_state = "box[last_box + 1]"


/obj/item/pizzabox/attack_hand(mob/living/user)
	if (open && pizza)
		user.put_in_hands(pizza)
		to_chat(user, SPAN_WARNING("You take \the [pizza] out of \the [src]."))
		pizza = null
		update_icon()
		return
	if (length(boxes))
		if (user.get_inactive_hand() != src)
			..()
			return
		var/obj/item/pizzabox/box = boxes[length(boxes)]
		boxes -= box
		user.put_in_hands(box)
		to_chat(user, SPAN_WARNING("You remove the topmost [src] from your hand."))
		box.update_icon()
		update_icon()
		return
	..()


/obj/item/pizzabox/attack_self(mob/living/user)
	if (length(boxes))
		return
	open = !open
	if (open && pizza)
		messy = TRUE
	update_icon()


/obj/item/pizzabox/use_tool(obj/item/item, mob/living/user, list/click_params)
	. = TRUE
	if (istype(item, /obj/item/pizzabox))
		var/obj/item/pizzabox/box = item
		if (!box.open && !open)
			var/list/boxestoadd = list()
			boxestoadd += box
			for (var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i
			if ((length(boxes) + 1) + length(boxestoadd) <= 5)
				if (!user.unEquip(box, src))
					FEEDBACK_UNEQUIP_FAILURE(user, box)
					return
				box.boxes = list()
				boxes += boxestoadd
				box.update_icon()
				update_icon()
				to_chat(user, SPAN_WARNING("You put \the [box] ontop of \the [src]!"))
			else
				to_chat(user, SPAN_WARNING("The stack is too high!"))
		else
			to_chat(user, SPAN_WARNING("Close \the [box] first!"))
		return
	if (istype(item, /obj/item/reagent_containers/food/snacks/sliceable/pizza) || istype(item, /obj/item/reagent_containers/food/snacks/variable/pizza))
		if (!open)
			to_chat(user, SPAN_WARNING("You try to push \the [item] through the lid but it doesn't work!"))
			return
		if (pizza)
			to_chat(user, SPAN_WARNING("There is already \a [pizza] in \the [src]!"))
			return
		if (!user.unEquip(item, src))
			FEEDBACK_UNEQUIP_FAILURE(user, item)
			return
		pizza = item
		update_icon()
		to_chat(user, SPAN_WARNING("You put \the [item] in \the [src]!"))
		return
	if (istype(item, /obj/item/pen))
		if (open)
			USE_FEEDBACK_FAILURE("You need to close \the [src].")
			return
		var/new_tag = input("Enter what you want to add to the tag:", "Write") as null | text
		new_tag = sanitize(new_tag, 30)
		if (!length_char(new_tag))
			return
		if (!user.use_sanity_check(src, item))
			return
		var/obj/item/pizzabox/top_box = src
		if (length(boxes))
			top_box = boxes[length(boxes)]
		new_tag = "[top_box.boxtag][new_tag]"
		var/tag_length = length_char(new_tag)
		if (tag_length > 30)
			to_chat(user, SPAN_WARNING("Not enough space. That would be [tag_length - 30] letters too long!"))
			return
		top_box.boxtag = new_tag
		update_icon()
		return
	return ..()


/obj/item/reagent_containers/food/snacks/sliceable/pizza
	abstract_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza
	icon = 'icons/obj/food/pizza.dmi'
	filling_color = "#baa14c"
	center_of_mass = "x=16;y=11"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza
	slices_num = 6
	bitesize = 2


/obj/item/reagent_containers/food/snacks/slice/pizza
	abstract_type = /obj/item/reagent_containers/food/snacks/slice/pizza
	icon = 'icons/obj/food/pizza.dmi'
	center_of_mass = "x=18;y=13"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza
	bitesize = 2


/obj/item/pizzabox/margherita
	boxtag = "Margherita Deluxe"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita


/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "margherita"
	desc = "The golden standard of pizzas."
	icon_state = "margherita"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/margherita
	nutriment_desc = list("pizza crust" = 5, "tomato" = 10, "cheese" = 10)
	nutriment_amt = 25


/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)



/obj/item/reagent_containers/food/snacks/slice/pizza/margherita
	name = "margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "margherita_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita


/obj/item/reagent_containers/food/snacks/slice/pizza/margherita/filled
	filled = TRUE


/obj/item/pizzabox/meat
	boxtag = "Meatlover's Supreme"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meat


/obj/item/reagent_containers/food/snacks/sliceable/pizza/meat
	name = "meat pizza"
	desc = "A pizza with meat topping."
	icon_state = "meat"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/meat
	nutriment_desc = list("pizza crust" = 3, "tomato" = 3, "cheese" = 4)
	nutriment_amt = 10


/obj/item/reagent_containers/food/snacks/sliceable/pizza/meat/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 19)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)


/obj/item/reagent_containers/food/snacks/slice/pizza/meat
	name = "meat pizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meat_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meat


/obj/item/reagent_containers/food/snacks/slice/pizza/meat/filled
	filled = TRUE


/obj/item/pizzabox/mushroom
	boxtag = "Mushroom Special"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroom


/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroom
	name = "mushroom pizza"
	desc = "Very special pizza."
	icon_state = "mushroom"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/mushroom
	nutriment_desc = list("pizza crust" = 5, "tomato" = 10, "cheese" = 5, "mushroom" = 10)
	nutriment_amt = 30


/obj/item/reagent_containers/food/snacks/slice/pizza/mushroom
	name = "mushroom pizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroom_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroom


/obj/item/reagent_containers/food/snacks/slice/pizza/mushroom/filled
	filled = TRUE


/obj/item/pizzabox/vegetable
	boxtag = "Gourmet Vegatable"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetable


/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetable
	name = "vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza."
	icon_state = "veggie"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/vegetable
	nutriment_desc = list(
		"pizza crust" = 2,
		"tomato" = 4,
		"cheese" = 5,
		"eggplant" = 6,
		"carrot" = 3,
		"corn" = 5
	)
	nutriment_amt = 25


/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetable/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)
	reagents.add_reagent(/datum/reagent/imidazoline, 3)


/obj/item/reagent_containers/food/snacks/slice/pizza/vegetable
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "veggie_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetable


/obj/item/reagent_containers/food/snacks/slice/pizza/vegetable/filled
	filled = TRUE


/obj/item/pizzabox/fruit
	boxtag = "Fruit Fanatic"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/fruit


/obj/item/reagent_containers/food/snacks/sliceable/pizza/fruit
	name = "fruit pizza"
	desc = "Cream and mixed fruit on a pizza crust. Is it even legal?"
	icon_state = "fruit"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/fruit
	nutriment_desc = list("pizza crust" = 5)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/sliceable/pizza/fruit/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/pineapple, 3)
	reagents.add_reagent(/datum/reagent/drink/juice/banana, 3)
	reagents.add_reagent(/datum/reagent/drink/juice/berry, 3)
	reagents.add_reagent(/datum/reagent/drink/milk/cream, 5)
	reagents.add_reagent(/datum/reagent/sugar, 2)


/obj/item/reagent_containers/food/snacks/slice/pizza/fruit
	name = "fruit pizza slice"
	desc = "A slice of cream, fruit, and crust. How strange."
	icon_state = "fruit_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/fruit


/obj/item/reagent_containers/food/snacks/slice/pizza/fruit/filled
	filled = TRUE


/obj/item/pizzabox/choco
	boxtag = "Dreamy Dessert"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/choco


/obj/item/reagent_containers/food/snacks/sliceable/pizza/choco
	name = "chocolate pizza"
	desc = "A sinful pie of confections galore. Watch your slice count!"
	icon_state = "choco"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/choco
	nutriment_desc = list("pizza crust" = 5)
	nutriment_amt = 10


/obj/item/reagent_containers/food/snacks/sliceable/pizza/choco/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/milk/cream, 3)
	reagents.add_reagent(/datum/reagent/nutriment/sprinkles, 3)
	reagents.add_reagent(/datum/reagent/drink/syrup_chocolate, 10)
	reagents.add_reagent(/datum/reagent/drink/syrup_caramel, 3)


/obj/item/reagent_containers/food/snacks/slice/pizza/choco
	name = "chocolate pizza slice"
	desc = "A slice of soft chocolate base and candy toppings ... on pizza crust."
	icon_state = "choco_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/choco


/obj/item/reagent_containers/food/snacks/slice/pizza/choco/filled
	filled = TRUE


/obj/item/pizzabox/ham
	boxtag = "Ham Hero"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/ham


/obj/item/reagent_containers/food/snacks/sliceable/pizza/ham
	name = "ham pizza"
	desc = "A pizza topped with cheese and ham. Plain, but sometimes forbidden."
	icon_state = "ham"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/ham
	nutriment_desc = list("pizza crust" = 5, "cheese" = 5)
	nutriment_amt = 5


/obj/item/reagent_containers/food/snacks/sliceable/pizza/ham/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)


/obj/item/reagent_containers/food/snacks/slice/pizza/ham
	name = "ham pizza slice"
	desc = "A simple slice of cheese and ham. An open faced sandwich?"
	icon_state = "ham_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/ham


/obj/item/reagent_containers/food/snacks/slice/pizza/ham/filled
	filled = TRUE


/obj/item/pizzabox/hawaiian
	boxtag = "Hearty Hawaiian"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/hawaiian


/obj/item/reagent_containers/food/snacks/sliceable/pizza/hawaiian
	name = "hawaiian pizza"
	desc = "A controversial ham and pineapple pizza. Best enjoyed at aloha temperature."
	icon_state = "hawaiian"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/hawaiian
	nutriment_desc = list("pizza crust" = 3, "cheese" = 4)
	nutriment_amt = 5


/obj/item/reagent_containers/food/snacks/sliceable/pizza/ham/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)
	reagents.add_reagent(/datum/reagent/drink/juice/pineapple, 6)


/obj/item/reagent_containers/food/snacks/slice/pizza/hawaiian
	name = "hawaiian pizza slice"
	desc = "A slice of ham and pineapple pizza. Love it or hate it, it's meaty and sweet!"
	icon_state = "hawaiian_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/hawaiian


/obj/item/reagent_containers/food/snacks/slice/pizza/hawaiian/filled
	filled = TRUE


/obj/item/pizzabox/capricciosa
	boxtag = "Capricciosa Classic"
	pizza = /obj/item/reagent_containers/food/snacks/sliceable/pizza/capricciosa


/obj/item/reagent_containers/food/snacks/sliceable/pizza/capricciosa
	name = "capricciosa pizza"
	desc = "A pizza the uncultured might refer to as \"ham and mushroom\"."
	icon_state = "capricciosa"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizza/capricciosa
	nutriment_desc = list("pizza crust" = 3, "cheese" = 4, "mushroom" = 10)
	nutriment_amt = 11


/obj/item/reagent_containers/food/snacks/sliceable/pizza/capricciosa/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 3)


/obj/item/reagent_containers/food/snacks/slice/pizza/capricciosa
	name = "capricciosa pizza slice"
	desc = "A slice of pizza with bits of ham and chopped mushroom on it."
	icon_state = "capricciosa_slice"
	filling_color = "#baa14c"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/capricciosa


/obj/item/reagent_containers/food/snacks/slice/pizza/capricciosa/filled
	filled = TRUE
