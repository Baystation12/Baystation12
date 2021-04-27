/*
MRE Stuff
 */

/obj/item/storage/mre
	name = "MRE, Menu 1"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'
	var/main_meal = /obj/item/storage/mrebag
	var/meal_desc = "This one is menu 1, meat pizza."
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
		/obj/item/material/kitchen/utensil/fork/plastic
	)

/obj/item/storage/mre/Initialize()
	create_objects_in_loc(src, main_meal)
	. = ..()
	make_exact_fit()

/obj/item/storage/mre/examine(mob/user)
	. = ..()
	to_chat(user, meal_desc)

/obj/item/storage/mre/on_update_icon()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"
	. = ..()

/obj/item/storage/mre/attack_self(mob/user)
	open(user)

/obj/item/storage/mre/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>You tear open the bag, breaking the vacuum seal.</span>")
	. = ..()

/obj/item/storage/mre/menu2
	name = "MRE, Menu 2"
	meal_desc = "This one is menu 2, margherita."
	main_meal = /obj/item/storage/mrebag/menu2
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/salt,
		/obj/item/material/kitchen/utensil/fork/plastic
	)

/obj/item/storage/mre/menu3
	name = "MRE, Menu 3"
	meal_desc = "This one is menu 3, vegetable pizza."
	main_meal = /obj/item/storage/mrebag/menu3
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/pepper,
		/obj/item/material/kitchen/utensil/fork/plastic
	)

/obj/item/storage/mre/menu4
	name = "MRE, Menu 4"
	meal_desc = "This one is menu 4, hamburger."
	main_meal = /obj/item/storage/mrebag/menu4
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/mayo,
		/obj/item/material/kitchen/utensil/spork/plastic
	)

/obj/item/storage/mre/menu5
	name = "MRE, Menu 5"
	meal_desc = "This one is menu 5, taco."
	main_meal = /obj/item/storage/mrebag/menu5
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/ketchup,
		/obj/item/material/kitchen/utensil/spork/plastic
	)

/obj/item/storage/mre/menu6
	name = "MRE, Menu 6"
	meal_desc = "This one is menu 6, meatbread."
	main_meal = /obj/item/storage/mrebag/menu6
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/random/mre/sauce/sugarfree,
		/obj/item/material/kitchen/utensil/fork/plastic
	)

/obj/item/storage/mre/menu7
	name = "MRE, Menu 7"
	meal_desc = "This one is menu 7, salad."
	main_meal = /obj/item/storage/mrebag/menu7
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/soy,
		/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu8
	name = "MRE, Menu 8"
	meal_desc = " This one is menu 8, hot chili."
	main_meal = /obj/item/storage/mrebag/menu8
	startswith = list(
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
		/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu9
	name = "vegan MRE"
	meal_desc = "This one is menu 9, boiled rice (skrell-safe)."
	icon_state = "vegmre"
	main_meal = /obj/item/storage/mrebag/menu9
	startswith = list(
		/obj/item/storage/mrebag/dessert/menu9,
		/obj/item/storage/fancy/crackers,
		/obj/random/mre/spread/vegan,
		/obj/random/mre/drink,
		/obj/item/reagent_containers/food/condiment/small/packet/soy,
		/obj/item/material/kitchen/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu10
	name = "protein MRE"
	meal_desc = "This one is menu 10, protein."
	icon_state = "meatmre"
	main_meal = /obj/item/storage/mrebag/menu10
	startswith = list(
		/obj/item/reagent_containers/food/snacks/proteinbar,
		/obj/item/reagent_containers/food/condiment/small/packet/protein,
		/obj/random/mre/sauce/sugarfree,
		/obj/item/material/kitchen/utensil/fork/plastic
	)

/obj/item/storage/mre/menu11
	name = "crayon MRE"
	meal_desc = "This one doesn't have a menu listing. How very odd."
	icon_state = "crayonmre"
	main_meal = /obj/item/storage/fancy/crayons
	startswith = list(
		/obj/item/storage/mrebag/dessert/menu11,
		/obj/random/mre/sauce/crayon,
		/obj/random/mre/sauce/crayon,
		/obj/random/mre/sauce/crayon
	)

/obj/item/storage/mre/menu11/special
	meal_desc = "This one doesn't have a menu listing. How odd. It has the initials \"A.B.\" written on the back."

/obj/item/storage/mre/random
	meal_desc = "The menu label is faded out."
	main_meal = /obj/random/mre/main

/obj/item/storage/mrebag
	name = "main course"
	desc = "A vacuum-sealed bag containing the MRE's main course. Self-heats when opened."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch_medium"
	storage_slots = 1
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/bubbles.ogg'
	startswith = list(/obj/item/reagent_containers/food/snacks/slice/meatpizza/filled)

/obj/item/storage/mrebag/Initialize()
	. = ..()

/obj/item/storage/mrebag/on_update_icon()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"
	. = ..()

/obj/item/storage/mrebag/attack_self(mob/user)
	open(user)

/obj/item/storage/mrebag/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>The pouch heats up as you break the vaccum seal.</span>")
	. = ..()

/obj/item/storage/mrebag/menu2
	startswith = list(/obj/item/reagent_containers/food/snacks/slice/margherita/filled)

/obj/item/storage/mrebag/menu3
	startswith = list(/obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled)

/obj/item/storage/mrebag/menu4
	startswith = list(/obj/item/reagent_containers/food/snacks/hamburger)

/obj/item/storage/mrebag/menu5
	startswith = list(/obj/item/reagent_containers/food/snacks/taco)

/obj/item/storage/mrebag/menu6
	startswith = list(/obj/item/reagent_containers/food/snacks/slice/meatbread/filled)

/obj/item/storage/mrebag/menu7
	startswith = list(/obj/item/reagent_containers/food/snacks/tossedsalad)

/obj/item/storage/mrebag/menu8
	startswith = list(/obj/item/reagent_containers/food/snacks/hotchili)

/obj/item/storage/mrebag/menu9
	startswith = list(/obj/item/reagent_containers/food/snacks/boiledrice)

/obj/item/storage/mrebag/menu10
	startswith = list(/obj/item/reagent_containers/food/snacks/meatcube)

/obj/item/storage/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing the MRE's dessert."
	icon_state = "pouch_small"
	open_sound = 'sound/effects/rip1.ogg'
	startswith = list(/obj/random/mre/dessert)

/obj/item/storage/mrebag/dessert/menu9
	startswith = list(/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/item/storage/mrebag/dessert/menu11
	startswith = list(/obj/item/pen/crayon/rainbow)
