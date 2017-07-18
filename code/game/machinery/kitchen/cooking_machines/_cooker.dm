// This folder contains code that was originally ported from Apollo Station and then refactored/optimized/changed.

// Tracks precooked food to stop deep fried baked grilled grilled grilled diona nymph cereal.
/obj/item/weapon/reagent_containers/food/snacks/var/list/cooked

// Root type for cooking machines. See following files for specific implementations.
/obj/machinery/cooker
	name = "cooker"
	desc = "You shouldn't be seeing this!"
	icon = 'icons/obj/cooking_machines.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5

	var/on_icon						// Icon state used when cooking.
	var/off_icon					// Icon state used when not cooking.
	var/cooking						// Whether or not the machine is currently operating.
	var/cook_type					// A string value used to track what kind of food this machine makes.
	var/cook_time = 200				// How many ticks the cooking will take.
	var/can_cook_mobs				// Whether or not this machine accepts grabbed mobs.
	var/food_color					// Colour of resulting food item.
	var/cooked_sound				// Sound played when cooking completes.
	var/can_burn_food				// Can the object burn food that is left inside?
	var/burn_chance = 10			// How likely is the food to burn?
	var/obj/item/cooking_obj		// Holder for the currently cooking object.

	// If the machine has multiple output modes, define them here.
	var/selected_option
	var/list/output_options = list()

/obj/machinery/cooker/Destroy()
	if(cooking_obj)
		qdel(cooking_obj)
		cooking_obj = null
	return ..()

/obj/machinery/cooker/examine()
	. = ..()
	if(cooking_obj && Adjacent(usr))
		to_chat(usr, "You can see \a [cooking_obj] inside.")

/obj/machinery/cooker/attackby(var/obj/item/I, var/mob/user)

	if(!cook_type || (stat & (NOPOWER|BROKEN)))
		to_chat(user, "<span class='warning'>\The [src] is not working.</span>")
		return

	if(cooking)
		to_chat(user, "<span class='warning'>\The [src] is running!</span>")
		return

	// We are trying to cook a grabbed mob.
	var/obj/item/weapon/grab/G = I
	if(istype(G))

		if(!can_cook_mobs)
			to_chat(user, "<span class='warning'>That's not going to fit.</span>")
			return

		if(!isliving(G.affecting))
			to_chat(user, "<span class='warning'>You can't cook that.</span>")
			return

		cook_mob(G.affecting, user)
		return

	// We're trying to cook something else. Check if it's valid.
	var/obj/item/weapon/reagent_containers/food/snacks/check = I
	if(istype(check) && islist(check.cooked) && (cook_type in check.cooked))
		to_chat(user, "<span class='warning'>\The [check] has already been [cook_type].</span>")
		return 0
	else if(istype(check, /obj/item/weapon/reagent_containers/glass))
		to_chat(user, "<span class='warning'>That would probably break [src].</span>")
		return 0
	else if(istype(check, /obj/item/weapon/disk/nuclear))
		to_chat(user, "Central Command would kill you if you [cook_type] that.")
		return 0
	else if(!istype(check) && !istype(check, /obj/item/weapon/holder))
		to_chat(user, "<span class='warning'>That's not edible.</span>")
		return 0

	// Gotta hurt.
	if(istype(cooking_obj, /obj/item/weapon/holder))
		for(var/mob/living/M in cooking_obj.contents)
			M.apply_damage(rand(30,40), BURN, BP_CHEST)

	// Not sure why a food item that passed the previous checks would fail to drop, but safety first.
	if(!user.unEquip(I))
		return

	// We can actually start cooking now.
	user.visible_message("<span class='notice'>\The [user] puts \the [I] into \the [src].</span>")
	cooking_obj = I
	cooking_obj.forceMove(src)
	cooking = 1
	icon_state = on_icon

	// Doop de doo. Jeopardy theme goes here.
	sleep(cook_time)

	// Sanity checks.
	check_cooking_obj()

	// RIP slow-moving held mobs.
	if(istype(cooking_obj, /obj/item/weapon/holder))
		for(var/mob/living/M in cooking_obj.contents)
			M.death()

	// Cook the food.
	var/cook_path
	if(selected_option && output_options.len)
		cook_path = output_options[selected_option]
	if(!cook_path)
		cook_path = /obj/item/weapon/reagent_containers/food/snacks/variable
	var/obj/item/weapon/reagent_containers/food/snacks/result = new cook_path(src) //Holy typepaths, Batman.

	if(cooking_obj.reagents && cooking_obj.reagents.total_volume)
		cooking_obj.reagents.trans_to(result, cooking_obj.reagents.total_volume)

	// Set icon and appearance.
	change_product_appearance(result)

	// Update strings.
	change_product_strings(result)

	// Set cooked data.
	var/obj/item/weapon/reagent_containers/food/snacks/food_item = cooking_obj
	if(istype(food_item) && islist(food_item.cooked))
		result.cooked = food_item.cooked.Copy()
	else
		result.cooked = list()
	result.cooked |= cook_type

	// Reset relevant variables.
	qdel(cooking_obj)
	src.visible_message("<span class='notice'>\The [src] pings!</span>")
	if(cooked_sound)
		playsound(get_turf(src), cooked_sound, 50, 1)

	if(!can_burn_food)
		icon_state = off_icon
		cooking = 0
		result.forceMove(get_turf(src))
		cooking_obj = null
	else
		var/failed
		var/overcook_period = max(Floor(cook_time/5),1)
		cooking_obj = result
		while(1)
			sleep(overcook_period)
			if(!cooking || !result || result.loc != src)
				failed = 1
			else if(prob(burn_chance))
				// You dun goofed.
				qdel(cooking_obj)
				cooking_obj = new /obj/item/weapon/reagent_containers/food/snacks/badrecipe(src)
				// Produce nasty smoke.
				visible_message("<span class='danger'>\The [src] vomits a gout of rancid smoke!</span>")
				var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad()
				smoke.attach(src)
				smoke.set_up(10, 0, usr.loc)
				smoke.start()
				failed = 1

			if(failed)
				cooking = 0
				icon_state = off_icon
				break

/obj/machinery/cooker/proc/check_cooking_obj()
	if(!cooking_obj || cooking_obj.loc != src)
		cooking_obj = null
		icon_state = off_icon
		cooking = 0
		return

/obj/machinery/cooker/attack_hand(var/mob/user)

	if(cooking_obj)
		to_chat(user, "<span class='notice'>You grab \the [cooking_obj] from \the [src].</span>")
		user.put_in_hands(cooking_obj)
		cooking = 0
		cooking_obj = null
		icon_state = off_icon
		return

	if(output_options.len)

		if(cooking)
			to_chat(user, "<span class='warning'>\The [src] is in use!</span>")
			return

		var/choice = input("What specific food do you wish to make with \the [src]?") as null|anything in output_options+"Default"
		if(!choice)
			return
		if(choice == "Default")
			selected_option = null
			to_chat(user, "<span class='notice'>You decide not to make anything specific with \the [src].</span>")
		else
			selected_option = choice
			to_chat(user, "<span class='notice'>You prepare \the [src] to make \a [selected_option].</span>")

	..()

/obj/machinery/cooker/proc/cook_mob(var/mob/living/victim, var/mob/user)
	return

/obj/machinery/cooker/proc/change_product_strings(var/obj/item/weapon/reagent_containers/food/snacks/product)
	if(product.type == /obj/item/weapon/reagent_containers/food/snacks/variable) // Base type, generic.
		product.name = "[cook_type] [cooking_obj.name]"
		product.desc = "[cooking_obj.desc] It has been [cook_type]."
	else
		product.name = "[cooking_obj.name] [product.name]"

/obj/machinery/cooker/proc/change_product_appearance(var/obj/item/weapon/reagent_containers/food/snacks/product)
	if(product.type == /obj/item/weapon/reagent_containers/food/snacks/variable) // Base type, generic.
		product.appearance = cooking_obj
		product.color = food_color
		product.filling_color = food_color

		// Make 'em into a corpse.
		if(istype(cooking_obj, /obj/item/weapon/holder))
			var/matrix/M = matrix()
			M.Turn(90)
			M.Translate(1,-6)
			product.transform = M
	else
		var/image/I = image(product.icon, "[product.icon_state]_filling")
		if(istype(cooking_obj, /obj/item/weapon/reagent_containers/food/snacks))
			var/obj/item/weapon/reagent_containers/food/snacks/S = cooking_obj
			I.color = S.filling_color
		if(!I.color)
			I.color = food_color
		product.overlays += I

