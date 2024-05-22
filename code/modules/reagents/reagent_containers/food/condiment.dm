
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "condiment container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food/condiment.dmi'
	icon_state = "condiment"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = "1;5;10"
	center_of_mass = "x=16;y=6"
	volume = 50
	var/list/starting_reagents
	var/fixed_state = FALSE

/obj/item/reagent_containers/food/condiment/Initialize()
	. = ..()
	for(var/R in starting_reagents)
		reagents.add_reagent(R, starting_reagents[R])

/obj/item/reagent_containers/food/condiment/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/label = sanitizeSafe(input(user, "Enter a label for \the [name]", "Label", label_text), MAX_NAME_LEN)
		if (!label)
			return TRUE
		AddLabel(label, user)
		return TRUE
	return ..()

/obj/item/reagent_containers/food/condiment/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/food/condiment/use_before(mob/M as mob, mob/user as mob)
	. = FALSE
	if (!istype(M))
		return FALSE
	if (standard_feed_mob(user, M))
		return TRUE

/obj/item/reagent_containers/food/condiment/use_after(obj/target, mob/living/user, click_parameters)
	if(standard_dispenser_refill(user, target) || standard_pour_into(user, target))
		return TRUE

	if(istype(target, /obj/item/reagent_containers/food/snacks)) // These are not opencontainers but we can transfer to them
		if(!reagents || !reagents.total_volume)
			to_chat(user, SPAN_NOTICE("There is no condiment left in \the [src]."))
			return TRUE
		if(!target.reagents.get_free_space())
			to_chat(user, SPAN_NOTICE("You can't add more condiment to \the [target]."))
			return TRUE

		var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You add [trans] units of the condiment to \the [target]."))
		return TRUE

/obj/item/reagent_containers/food/condiment/feed_sound(mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/condiment/self_feed_message(mob/user)
	to_chat(user, SPAN_NOTICE("You swallow some of contents of \the [src]."))


/obj/item/reagent_containers/food/condiment/on_reagent_change()
	if(fixed_state)
		return

	ClearOverlays()

	if(!reagents.total_volume)
		name = "condiment bottle"
		desc = "An empty condiment bottle."
		return

	var/datum/reagent/master = reagents.get_master_reagent()
	icon_state = master.condiment_icon_state || initial(icon_state)
	name = master.condiment_name || (length(reagents.reagent_list) == 1 ? "[lowertext(master.name)] bottle" : "condiment bottle")
	desc = master.condiment_desc || (length(reagents.reagent_list) == 1 ? master.description : "A mixture of various condiments. [master.name] is one of them.")
	if(icon_state == "condiment")
		var/image/filling = image(icon, "condiment_overlay")
		filling.color = reagents.get_color()
		AddOverlays(filling)

/obj/item/reagent_containers/food/condiment/examine(mob/user, distance)
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


/obj/item/reagent_containers/food/condiment/enzyme
	starting_reagents = list(/datum/reagent/enzyme = 50)

/obj/item/reagent_containers/food/condiment/barbecue
	starting_reagents = list(/datum/reagent/nutriment/barbecue = 50)

/obj/item/reagent_containers/food/condiment/sugar
	starting_reagents = list(/datum/reagent/sugar = 50)

/obj/item/reagent_containers/food/condiment/ketchup
	starting_reagents = list(/datum/reagent/nutriment/ketchup = 50)

/obj/item/reagent_containers/food/condiment/cornoil
	starting_reagents = list(/datum/reagent/nutriment/cornoil = 50)

/obj/item/reagent_containers/food/condiment/vinegar
	starting_reagents = list(/datum/reagent/nutriment/vinegar = 50)

/obj/item/reagent_containers/food/condiment/mayo
	starting_reagents = list(/datum/reagent/nutriment/mayo = 50)

/obj/item/reagent_containers/food/condiment/frostoil
	starting_reagents = list(/datum/reagent/frostoil = 50)

/obj/item/reagent_containers/food/condiment/capsaicin
	starting_reagents = list(/datum/reagent/capsaicin = 50)

/obj/item/reagent_containers/food/condiment/flour
	randpixel = 10
	starting_reagents = list(/datum/reagent/nutriment/flour = 50)

/obj/item/reagent_containers/food/condiment/mint
	starting_reagents = list(/datum/reagent/nutriment/mint = 15)

/obj/item/reagent_containers/food/condiment/soysauce
	starting_reagents = list(/datum/reagent/nutriment/soysauce = 50)

/obj/item/reagent_containers/food/condiment/oliveoil
	starting_reagents = list(/datum/reagent/oliveoil = 50)

/obj/item/reagent_containers/food/condiment/peanutbutter
	starting_reagents = list(/datum/reagent/nutriment/peanutbutter = 50)

/obj/item/reagent_containers/food/condiment/choconutspread
	starting_reagents = list(/datum/reagent/nutriment/choconutspread = 50)

/obj/item/reagent_containers/food/condiment/small
	possible_transfer_amounts = "1;20"
	amount_per_transfer_from_this = 1
	volume = 20
	fixed_state = TRUE

/obj/item/reagent_containers/food/condiment/small/saltshaker
	name = "salt shaker"
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshaker"
	center_of_mass = "x=16;y=9"
	starting_reagents = list(/datum/reagent/sodiumchloride = 20)

/obj/item/reagent_containers/food/condiment/small/peppermill
	name = "pepper mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermill"
	center_of_mass = "x=16;y=8"
	starting_reagents = list(/datum/reagent/blackpepper = 20)

/obj/item/reagent_containers/food/condiment/small/sugar
	name = "sugar"
	desc = "Sweetness in a bottle."
	icon_state = "sugarbottle"
	center_of_mass = "x=17;y=9"
	starting_reagents = list(/datum/reagent/sugar = 20)


/obj/item/reagent_containers/food/condiment/salt
	name = "big bag of salt"
	desc = "A nonsensically large bag of salt. Carefully refined from countless shifts."
	icon_state = "salt"
	item_state = "flour"
	randpixel = 10
	volume = 500
	w_class = ITEM_SIZE_LARGE
	starting_reagents = list(/datum/reagent/sodiumchloride = 500)
	fixed_state = TRUE


//MRE condiments and drinks.

/obj/item/reagent_containers/food/condiment/small/packet
	icon_state = "packet_small"
	w_class = ITEM_SIZE_TINY
	possible_transfer_amounts = "1;5;10"
	amount_per_transfer_from_this = 1
	volume = 10

/obj/item/reagent_containers/food/condiment/small/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon_state = "packet_small_white"
	starting_reagents = list(/datum/reagent/sodiumchloride = 5)

/obj/item/reagent_containers/food/condiment/small/packet/pepper
	name = "pepper packet"
	desc = "Contains 5u of black pepper."
	icon_state = "packet_small_black"
	starting_reagents = list(/datum/reagent/blackpepper = 5)

/obj/item/reagent_containers/food/condiment/small/packet/sugar
	name = "sugar packet"
	desc = "Contains 5u of refined sugar."
	icon_state = "packet_small_white"
	starting_reagents = list(/datum/reagent/sugar = 5)

/obj/item/reagent_containers/food/condiment/small/packet/jelly
	name = "jelly packet"
	desc = "Contains 10u of cherry jelly. Best used for spreading on crackers."
	starting_reagents = list(/datum/reagent/nutriment/cherryjelly = 10)
	icon_state = "packet_medium"

/obj/item/reagent_containers/food/condiment/small/packet/honey
	name = "honey packet"
	desc = "Contains 10u of honey."
	starting_reagents = list(/datum/reagent/sugar = 10)
	icon_state = "packet_medium"

/obj/item/reagent_containers/food/condiment/small/packet/peanutbutter
	name = "peanut butter packet"
	desc = "Contains 10u of peanut butter."
	icon_state = "packet_medium"
	starting_reagents = list(/datum/reagent/nutriment/peanutbutter = 10)

/obj/item/reagent_containers/food/condiment/small/packet/choconutspread
	name = "NTella packet"
	desc = "Contains 10u of NTella."
	icon_state = "packet_medium"
	starting_reagents = list(/datum/reagent/nutriment/choconutspread = 10)

/obj/item/reagent_containers/food/condiment/small/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 5u of hot sauce. Enjoy in moderation."
	icon_state = "packet_small_red"
	starting_reagents = list(/datum/reagent/capsaicin = 5)

/obj/item/reagent_containers/food/condiment/small/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 5u of ketchup."
	icon_state = "packet_small_red"
	starting_reagents = list(/datum/reagent/nutriment/ketchup = 5)

/obj/item/reagent_containers/food/condiment/small/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 5u of mayonnaise."
	icon_state = "packet_small_white"
	starting_reagents = list(/datum/reagent/nutriment/mayo = 5)

/obj/item/reagent_containers/food/condiment/small/packet/soy
	name = "soy sauce packet"
	desc = "Contains 5u of soy sauce."
	icon_state = "packet_small_black"
	starting_reagents = list(/datum/reagent/nutriment/soysauce = 5)

/obj/item/reagent_containers/food/condiment/small/packet/coffee
	name = "instant coffee powder packet"
	desc = "Contains 5u of instant coffee powder. Mix with 25u of water."
	starting_reagents = list(/datum/reagent/nutriment/coffee/instant = 5)

/obj/item/reagent_containers/food/condiment/small/packet/tea
	name = "instant tea powder packet"
	desc = "Contains 5u of instant black tea powder. Mix with 25u of water."
	starting_reagents = list(/datum/reagent/nutriment/tea/instant = 5)

/obj/item/reagent_containers/food/condiment/small/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 5u of cocoa powder. Mix with 25u of water and heat."
	starting_reagents = list(/datum/reagent/nutriment/coco = 5)

/obj/item/reagent_containers/food/condiment/small/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 5u of powdered grape juice. Mix with 15u of water."
	starting_reagents = list(/datum/reagent/nutriment/instantjuice/grape = 5)

/obj/item/reagent_containers/food/condiment/small/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 5u of powdered orange juice. Mix with 15u of water."
	starting_reagents = list(/datum/reagent/nutriment/instantjuice/orange = 5)

/obj/item/reagent_containers/food/condiment/small/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 5u of powdered watermelon juice. Mix with 15u of water."
	starting_reagents = list(/datum/reagent/nutriment/instantjuice/watermelon = 5)

/obj/item/reagent_containers/food/condiment/small/packet/apple
	name = "apple juice powder packet"
	desc = "Contains 5u of powdered apple juice. Mix with 15u of water."
	starting_reagents = list(/datum/reagent/nutriment/instantjuice/apple = 5)

/obj/item/reagent_containers/food/condiment/small/packet/protein
	name = "protein powder packet"
	desc = "Contains 10u of powdered protein. Mix with 20u of water."
	icon_state = "packet_medium"
	starting_reagents = list(/datum/reagent/nutriment/protein = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon
	name = "crayon powder packet"
	desc = "Contains 10u of powdered crayon. Mix with 30u of water."
	starting_reagents = list(/datum/reagent/crayon_dust = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/red
	starting_reagents = list(/datum/reagent/crayon_dust/red = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/orange
	starting_reagents = list(/datum/reagent/crayon_dust/orange = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/yellow
	starting_reagents = list(/datum/reagent/crayon_dust/yellow = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/green
	starting_reagents = list(/datum/reagent/crayon_dust/green = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/blue
	starting_reagents = list(/datum/reagent/crayon_dust/blue = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/purple
	starting_reagents = list(/datum/reagent/crayon_dust/purple = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/grey
	starting_reagents = list(/datum/reagent/crayon_dust/grey = 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/brown
	starting_reagents = list(/datum/reagent/crayon_dust/brown = 10)

//End of MRE stuff.