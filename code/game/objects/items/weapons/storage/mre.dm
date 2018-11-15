/*
MRE Stuff
 */

/obj/item/weapon/storage/mre
	name = "meal, ready-to-eat"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 1, meat pizza."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'
	startswith = list(
	/obj/item/weapon/storage/mrebag,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/Initialize()
	. = ..()
	make_exact_fit()

/obj/item/weapon/storage/mre/on_update_icon()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"
	. = ..()

/obj/item/weapon/storage/mre/attack_self(mob/user)
	open(user)

/obj/item/weapon/storage/mre/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>You tear open the bag, breaking the vacuum seal.</span>")
	. = ..()

/obj/item/weapon/storage/mre/menu2
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 2, margherita."
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu2,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu3
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 3, vegetable pizza."
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu3,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu4
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 4, hamburger."
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu4,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu5
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 5, taco."
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu5,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu6
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 6, meatbread."
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu6,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu7
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 7, spicy enchilada."
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu7,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu8
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 8, hot chili."
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu8,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu9
	name = "meal, ready-to-eat, vegan"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 9, vegan (skrell-safe)."
	icon_state = "vegmre"
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu9,
	/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks = 2,
	/obj/item/weapon/storage/mrebag/dessert/menu9,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mre/menu10
	name = "meal, ready-to-eat, carnivore"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one is menu 10, carnivore."
	icon_state = "meatmre"
	startswith = list(
	/obj/item/weapon/storage/mrebag/menu10,
	/obj/item/weapon/storage/mrebag/side/menu10 = 3,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo
	)

/obj/item/weapon/storage/mre/random
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package. This one has a random menu."
	startswith = list(
	/obj/random/mremain,
	/obj/item/weapon/storage/mrebag/side = 2,
	/obj/item/weapon/storage/mrebag/dessert,
	/obj/item/weapon/storage/fancy/crackers = 2,
	/obj/item/weapon/material/kitchen/utensil/spoon/plastic,
	/obj/random/mrejuice = 2,
	/obj/random/mrehotdrinks,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
	/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
	/obj/random/mrespread,
	/obj/item/clothing/mask/chewable/candy/gum = 2
	)

/obj/item/weapon/storage/mrebag
	name = "main course"
	desc = "A vacuum-sealed bag containing the MRE's main course. Self-heats when opened."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch"
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/bubbles.ogg'
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/slice/meatpizza/filled)

/obj/item/weapon/storage/mrebag/Initialize()
	. = ..()
	make_exact_fit()

/obj/item/weapon/storage/mrebag/on_update_icon()
	if(opened)
		icon_state = "pouch[opened]"
	. = ..()

/obj/item/weapon/storage/mrebag/attack_self(mob/user)
	open(user)

/obj/item/weapon/storage/mrebag/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>The pouch heats up as you break the vaccum seal.</span>")
	. = ..()

/obj/item/weapon/storage/mrebag/menu2
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/slice/margherita/filled)

/obj/item/weapon/storage/mrebag/menu3
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/slice/vegetablepizza/filled)

/obj/item/weapon/storage/mrebag/menu4
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/hamburger)

/obj/item/weapon/storage/mrebag/menu5
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/taco)

/obj/item/weapon/storage/mrebag/menu6
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/slice/meatbread/filled)

/obj/item/weapon/storage/mrebag/menu7
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/enchiladas)

/obj/item/weapon/storage/mrebag/menu8
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/hotchili)

/obj/item/weapon/storage/mrebag/menu9
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/tossedsalad)

/obj/item/weapon/storage/mrebag/menu10
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/meatcube)

/obj/item/weapon/storage/mrebag/side
	name = "side dish"
	desc = "A vacuum-sealed bag containing the MRE's side dish. Self-heats when opened."
	startswith = list(/obj/random/mreside)

/obj/item/weapon/storage/mrebag/side/menu10
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/meatcube)

/obj/item/weapon/storage/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing the MRE's dessert."
	open_sound = 'sound/effects/rip1.ogg'
	startswith = list(/obj/random/mredessert)

/obj/item/weapon/storage/mrebag/dessert/menu9
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit)
