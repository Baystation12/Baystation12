////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "Yummy!"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	amount_per_transfer_from_this = 5
	volume = 50
	var/filling_states   // List of percentages full that have icons
	var/base_name = null // Name to put in front of drinks, i.e. "[base_name] of [contents]"
	var/base_icon = null // Base icon name for fill states

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/food/drinks/on_color_transfer_reagent_change()
	return

/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user)
	playsound(loc,'sound/effects/canopen.ogg', rand(10,50), 1)
	to_chat(user, "<span class='notice'>You open \the [src] with an audible pop!</span>")
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	return ..()

/obj/item/reagent_containers/food/drinks/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_pour_into(var/mob/user, var/atom/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")
	if(user.has_personal_goal(/datum/goal/achievement/specific_object/drink))
		for(var/datum/reagent/R in reagents.reagent_list)
			user.update_personal_goal(/datum/goal/achievement/specific_object/drink, R.type)

/obj/item/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/drinks/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if(!reagents || reagents.total_volume == 0)
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
	else if (reagents.total_volume <= volume * 0.25)
		to_chat(user, "<span class='notice'>\The [src] is almost empty!</span>")
	else if (reagents.total_volume <= volume * 0.66)
		to_chat(user, "<span class='notice'>\The [src] is half full!</span>")
	else if (reagents.total_volume <= volume * 0.90)
		to_chat(user, "<span class='notice'>\The [src] is almost full!</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] is full!</span>")

/obj/item/reagent_containers/food/drinks/proc/get_filling_state()
	var/percent = round((reagents.total_volume / volume) * 100)
	for(var/k in cached_number_list_decode(filling_states))
		if(percent <= k)
			return k

/obj/item/reagent_containers/food/drinks/on_update_icon()
	overlays.Cut()
	if(reagents.reagent_list.len > 0)
		if(base_name)
			var/datum/reagent/R = reagents.get_master_reagent()
			SetName("[base_name] of [R.glass_name ? R.glass_name : "something"]")
			desc = R.glass_desc ? R.glass_desc : initial(desc)
		if(filling_states)
			var/image/filling = image(icon, src, "[base_icon][get_filling_state()]")
			filling.color = reagents.get_color()
			overlays += filling
	else
		SetName(initial(name))
		desc = initial(desc)


////////////////////////////////////////////////////////////////////////////////
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
	icon_state = "mini-milk"
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

/obj/item/reagent_containers/food/drinks/ice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/ice, 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "cup of hot cocoa"
	desc = "A tall plastic cup of creamy hot chocolate."
	icon_state = "coffee"
	item_state = "coffee"
	center_of_mass = "x=15;y=13"

/obj/item/reagent_containers/food/drinks/h_chocolate/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/hot_coco, 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "cup ramen"
	gender = PLURAL
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = "x=16;y=11"

/obj/item/reagent_containers/food/drinks/dry_ramen/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/dry_ramen, 30)


/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = "x=16;y=12"

/obj/item/reagent_containers/food/drinks/sillycup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"


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
	icon_state = "flask"
	volume = 60
	center_of_mass = "x=17;y=7"

/obj/item/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/reagent_containers/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

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