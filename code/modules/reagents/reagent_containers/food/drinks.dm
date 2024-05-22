////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "Yummy!"
	icon = 'icons/obj/food/drinks/misc.dmi'
	icon_state = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	amount_per_transfer_from_this = 5
	volume = 50
	var/filling_states   // List of percentages full that have icons
	var/base_name = null // Name to put in front of drinks, i.e. "[base_name] of [contents]"
	var/base_icon = null // Base icon name for fill states
	var/drink_offset_x = 0
	var/drink_offset_y = 0
	var/shaken = FALSE

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/food/drinks/on_color_transfer_reagent_change()
	return


/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		if(user.a_intent == I_HURT)
			shaken = TRUE
			user.visible_message("\The [user] shakes \the [src]!", "You shake \the [src]!")
			playsound(loc,'sound/items/soda_shaking.ogg', rand(10,50), 1)
			shake_animation(20)
			return
		if(shaken)
			for(var/datum/reagent/R in reagents.reagent_list)
				if("fizz" in R.glass_special)
					boom(user)
					return
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user)
	playsound(loc,'sound/effects/canopen.ogg', rand(10,50), 1)
	to_chat(user, SPAN_NOTICE("You open \the [src] with an audible pop!"))

/obj/item/reagent_containers/food/drinks/proc/boom(mob/user as mob)
	user.visible_message(
				SPAN_DANGER("\The [src] explodes all over \the [user] as they open it!"),
				SPAN_DANGER("\The [src] explodes all over you as you open it!")
			)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	make_froth(drink_offset_x, drink_offset_y, 2)
	playsound(loc,'sound/items/soda_burst.ogg', rand(20,50), 1)
	reagents.splash(user, reagents.total_volume)
	shaken = FALSE


/obj/item/reagent_containers/food/drinks/proc/make_froth(intensity)
	if(!intensity)
		return

	if(!reagents.total_volume)
		return

	var/intensity_state = null
	switch(intensity)
		if(1)
			intensity_state = "low"
		if(2)
			intensity_state = "medium"
		if(3)
			intensity_state = "high"
	var/mutable_appearance/froth = mutable_appearance('icons/obj/food/drinks/drink_effects.dmi', "froth_[intensity_state]")
	froth.pixel_x = drink_offset_x
	froth.pixel_y = drink_offset_y
	AddOverlays(froth)
	spawn(2 SECONDS)
	CutOverlays(froth)


/obj/item/reagent_containers/food/drinks/proc/boom(mob/user as mob)
	user.visible_message(
				SPAN_DANGER("\The [src] explodes all over \the [user] as they open it!"),
				SPAN_DANGER("\The [src] explodes all over you as you open it!")
			)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/food/drinks/use_before(mob/M as mob, mob/user as mob)
	. = FALSE
	if (!istype(M))
		return FALSE
	if(force && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.a_intent == I_HURT)
		return FALSE

	if(standard_feed_mob(user, M))
		return TRUE

/obj/item/reagent_containers/food/drinks/use_after(obj/target, mob/living/user, click_parameters)
	if (standard_dispenser_refill(user, target) || standard_pour_into(user, target))
		return TRUE

/obj/item/reagent_containers/food/drinks/standard_feed_mob(mob/user, mob/target)
	if(!is_open_container())
		to_chat(user, SPAN_NOTICE("You need to open \the [src]!"))
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_dispenser_refill(mob/user, obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		to_chat(user, SPAN_NOTICE("You need to open \the [src]!"))
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_pour_into(mob/user, atom/target)
	if(!is_open_container())
		to_chat(user, SPAN_NOTICE("You need to open \the [src]!"))
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/self_feed_message(mob/user)
	to_chat(user, SPAN_NOTICE("You swallow a gulp from \the [src]."))
	if(user.has_personal_goal(/datum/goal/achievement/specific_object/drink))
		for(var/datum/reagent/R in reagents.reagent_list)
			user.update_personal_goal(/datum/goal/achievement/specific_object/drink, R.type)

/obj/item/reagent_containers/food/drinks/feed_sound(mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/drinks/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if(!reagents || reagents.total_volume == 0)
		to_chat(user, SPAN_NOTICE("\The [src] is empty!"))
	else if (reagents.total_volume <= volume * 0.25)
		to_chat(user, SPAN_NOTICE("\The [src] is almost empty!"))
	else if (reagents.total_volume <= volume * 0.66)
		to_chat(user, SPAN_NOTICE("\The [src] is half full!"))
	else if (reagents.total_volume <= volume * 0.90)
		to_chat(user, SPAN_NOTICE("\The [src] is almost full!"))
	else
		to_chat(user, SPAN_NOTICE("\The [src] is full!"))

/obj/item/reagent_containers/food/drinks/proc/get_filling_state()
	var/percent = round((reagents.total_volume / volume) * 100)
	for(var/k in cached_number_list_decode(filling_states))
		if(percent <= k)
			return k

/obj/item/reagent_containers/food/drinks/on_update_icon()
	ClearOverlays()
	if(length(reagents.reagent_list) > 0)
		if(base_name)
			var/datum/reagent/R = reagents.get_master_reagent()
			SetName("[base_name] of [R.glass_name ? R.glass_name : "something"]")
			desc = R.glass_desc ? R.glass_desc : initial(desc)
		if(filling_states)
			var/image/filling = image(icon, src, "[base_icon][get_filling_state()]")
			filling.color = reagents.get_color()
			AddOverlays(filling)
	else
		SetName(initial(name))
		desc = initial(desc)


///////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup."
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = ITEM_SIZE_HUGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTIBLE

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/reagent_containers/food/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"

/obj/item/reagent_containers/food/drinks/milk/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/milk, 50)


/obj/item/reagent_containers/food/drinks/bottle/thoom
	name = "th'oom juice carton"
	desc = "It's th'oom juice. Strangely sweet and savory!"
	icon_state = "thoom"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/thoom/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/thoom, 50)


/obj/item/reagent_containers/food/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"

/obj/item/reagent_containers/food/drinks/soymilk/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/milk/soymilk, 50)

/obj/item/reagent_containers/food/drinks/small_milk
	name = "small milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "mini-milk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"
	volume = 30

/obj/item/reagent_containers/food/drinks/small_milk/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/milk, 30)

/obj/item/reagent_containers/food/drinks/small_milk_choc
	name = "small chocolate milk carton"
	desc = "It's milk! This one is in delicious chocolate flavour."
	icon_state = "mini-milk_choco"
	item_state = "carton"
	center_of_mass = "x=16;y=9"
	volume = 30

/obj/item/reagent_containers/food/drinks/small_milk_choc/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/milk/chocolate, 30)


/obj/item/reagent_containers/food/drinks/coffee
	name = "\improper Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = "x=15;y=10"

/obj/item/reagent_containers/food/drinks/coffee/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/coffee, 30)

/obj/item/reagent_containers/food/drinks/ice
	name = "cup of ice"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	center_of_mass = "x=15;y=10"
	filling_states = "100"
	base_name = "cup"
	base_icon = "cup"

/obj/item/reagent_containers/food/drinks/ice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/ice, 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "cup of hot cocoa"
	desc = "A tall plastic cup of creamy hot chocolate."
	icon_state = "coffee"
	item_state = "coffee"
	center_of_mass = "x=15;y=13"
	filling_states = "100"
	base_name = "cup"
	base_icon = "cup"

/obj/item/reagent_containers/food/drinks/h_chocolate/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/hot_coco, 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "cup ramen"
	gender = PLURAL
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = "x=16;y=11"
	atom_flags = 0 //starts closed
	filling_states = "100"
	base_icon = "cup"

/obj/item/reagent_containers/food/drinks/dry_ramen/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/dry_ramen, 30)

/obj/item/reagent_containers/food/drinks/dry_ramen/on_update_icon()
	ClearOverlays()
	if(length(reagents.reagent_list) > 0)
		if(filling_states && HAS_FLAGS(atom_flags, ATOM_FLAG_OPEN_CONTAINER))
			var/image/filling = image(icon, src, "[base_icon][get_filling_state()]")
			filling.color = reagents.get_color()
			AddOverlays(filling)

/obj/item/reagent_containers/food/drinks/dry_ramen/open(mob/user)
	playsound(loc,'sound/effects/rip1.ogg', rand(10,50), 1)
	to_chat(user, SPAN_NOTICE("You tear open \the [src], breaking the seal."))
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	icon_state = "ramen_open"
	update_icon()

/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = "x=16;y=12"
	filling_states = "100"
	base_icon = "water_cup"


//////////////////////////pitchers, pots, flasks and cups //
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = "x=17;y=7"

/obj/item/reagent_containers/food/drinks/pitcher
	name = "insulated pitcher"
	desc = "A stainless steel insulated pitcher. Everyone's best friend in the morning."
	icon_state = "pitcher"
	volume = 120
	amount_per_transfer_from_this = 10
	center_of_mass = "x=16;y=9"
	filling_states = "15;30;50;70;85;100"
	base_icon = "pitcher"

/obj/item/reagent_containers/food/drinks/flask
	name = "\improper Captain's flask"
	desc = "A metal flask belonging to the captain."
	icon = 'icons/obj/food/drinks/flasks.dmi'
	icon_state = "flask"
	volume = 60
	center_of_mass = "x=17;y=7"

/obj/item/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/reagent_containers/food/drinks/flask/detflask
	name = "\improper Detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = "x=17;y=8"

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = "x=17;y=7"

/obj/item/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = "x=15;y=4"
	var/obj/item/reagent_containers/food/drinks/flask/flask_cup/cup = /obj/item/reagent_containers/food/drinks/flask/flask_cup

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/Initialize()
	. = ..()
	cup = new cup(src)
	atom_flags ^= ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/attack_self(mob/user)
	if(cup)
		to_chat(user, SPAN_NOTICE("You remove \the [src]'s cap."))
		user.put_in_hands(cup)
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		cup = null
		update_icon()

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/use_tool(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/food/drinks/flask/flask_cup))
		if(cup)
			to_chat(user, SPAN_WARNING("\The [src] already has a cap."))
			return TRUE
		if(attacking_item.reagents.total_volume + reagents.total_volume > volume)
			to_chat(user, SPAN_WARNING("There's too much fluid in both the cap and \the [src]!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You put the cap onto \the [src]."))
		user.unEquip(attacking_item, src)
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
		cup = attacking_item
		cup.reagents.trans_to_holder(reagents, cup.reagents.total_volume)
		update_icon()
		return TRUE
	return ..()

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/on_update_icon()
	icon_state = cup ? initial(icon_state) : "[initial(icon_state)]-nobrim"

/obj/item/reagent_containers/food/drinks/flask/flask_cup
	name = "vacuum flask cup"
	desc = "The cup that appears in your hands after you unscrew the cap of the flask and turn it over. Magic!"
	icon_state = "vacuumflask-brim"
	volume = 10
	center_of_mass = "x=16;y=6"


//tea and tea accessories
/obj/item/reagent_containers/food/drinks/tea
	name = "cup of tea master item"
	desc = "A tall plastic cup full of the concept and ideal of tea."
	icon_state = "coffee"
	item_state = "coffee"
	center_of_mass = "x=16;y=14"
	filling_states = "100"
	base_name = "cup"
	base_icon = "cup"

/obj/item/reagent_containers/food/drinks/tea/black
	name = "cup of black tea"
	desc = "A tall plastic cup of hot black tea."

/obj/item/reagent_containers/food/drinks/tea/black/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/tea, 30)

/obj/item/reagent_containers/food/drinks/tea/green
	name = "cup of green tea"
	desc = "A tall plastic cup of hot green tea."

/obj/item/reagent_containers/food/drinks/tea/green/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/tea/green, 30)

/obj/item/reagent_containers/food/drinks/tea/chai
	name = "cup of chai tea"
	desc = "A tall plastic cup of hot chai tea."

/obj/item/reagent_containers/food/drinks/tea/chai/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/tea/chai, 30)

/obj/item/reagent_containers/food/drinks/decafcoffee
	name = "cup of decaf coffee"
	desc = "A tall plastic cup of hot decaffeinated coffee."
	icon_state = "coffee"
	item_state = "coffee"
	center_of_mass = "x=16;y=14"
	filling_states = "100"
	base_name = "cup"
	base_icon = "cup"

/obj/item/reagent_containers/food/drinks/decafcoffee/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/decafcoffee, 30)

/obj/item/reagent_containers/food/drinks/tea/decaf
	name = "cup of decaf tea"
	desc = "A tall plastic cup of hot decaffeinated tea."

/obj/item/reagent_containers/food/drinks/tea/decaf/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/tea/decaf, 30)
