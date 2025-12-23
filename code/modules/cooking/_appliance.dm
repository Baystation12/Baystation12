// This folder contains code that was originally ported from Apollo Station and then refactored/optimized/changed.


/obj/item/reagent_containers/food/snacks/var/cooked // Tracks precooked food to stop deep fried baked grilled grilled grilled diona nymph cereal.
/obj/item/storage/box/fancy/food/var/cooked 		//similar process for food containers that you can create via a cooking process

// Root type for cooking machines. See following files for specific implementations.
/obj/machinery/appliance
	name = "cooker"
	desc = "A cooking appliance used to prepare many types of food."
	// desc_info = "Control-click this to change its temperature."
	icon = 'icons/obj/machines/cooking_machines.dmi'
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT | ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CAN_TABLE | OBJ_FLAG_ANCHORABLE
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "cooker"
	machine_desc = "Required for preparing any dish more complicated than a slice of bread."

	var/appliancetype = 0

	use_power = POWER_USE_OFF
	idle_power_usage = 5			// Power used when turned on, but not processing anything
	active_power_usage = 1000		// Power used when turned on and actively cooking something

	var/operating = FALSE 							// Is it on?
	var/cooking_power = 0							// Effectiveness/speed at cooking
	var/cooking_coeff = 0							// Part-based cooking power multiplier
	var/heating_power = 1000						// Effectiveness at heating up; not used for mixers, should be equal to active_power_usage
	var/max_contents = 1							// Maximum number of things this appliance can simultaneously cook
	var/on_icon										// Icon state used when cooking.
	var/off_icon									// Icon state used when not cooking.
	var/cooking										// Whether or not the machine is currently operating.
	var/cook_type									// A string value used to track what kind of food this machine makes.
	var/use_container_cook_type						// Whether to allow a container to override cook_type
	var/can_cook_mobs								// Whether or not this machine accepts grabbed mobs.
	var/mobdamagetype = DAMAGE_BRUTE				// Burn damage for cooking appliances, brute for cereal/candy
	var/food_color									// Colour of resulting food item.
	var/cooked_sound = 'sound/machines/ding.ogg'	// Sound played when cooking completes.
	var/can_burn_food								// Can the object burn food that is left inside?
	var/burn_chance = 10							// How likely is the food to burn?
	var/list/cooking_objs = list()					// List of things being cooked
	var/particles/particle_holder
	var/particle_type = /particles/cooking_smoke
	var/smoke_percent = 0

	// If the machine has multiple output modes, define them here.
	var/selected_option
	// var/static/list/default_outputs = list("Default" = mutable_appearance('icons/screen/radial.dmi', "radial_power"))
	var/list/output_options = list()
	var/finish_verb = "pings!"
	var/place_verb = "into"

	//If true, this appliance will do combination cooking before checking recipes
	var/combine_first = FALSE

/obj/machinery/appliance/Initialize()
	. = ..()
	if(length(output_options))
		verbs += /obj/machinery/appliance/proc/choose_output
	particle_holder = new particle_type

/obj/machinery/appliance/dismantle()
	for (var/datum/cooking_item/cooking_item in cooking_objs)
		cooking_item.container.dropInto(get_turf(src))
	. = ..()

/obj/machinery/appliance/Destroy()
	for (var/a in cooking_objs)
		var/datum/cooking_item/cooking_item = a
		qdel(cooking_item.container)//Food is fragile, it probably doesnt survive the destruction of the machine
		cooking_objs -= cooking_item
		qdel(cooking_item)
	return ..()

/obj/machinery/appliance/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, list_contents(user))

/obj/machinery/appliance/proc/list_contents(mob/user)
	. = list()
	if (!length(cooking_objs))
		. = SPAN_NOTICE("It is empty.")
		return
	. = "Contains...<ul>"
	for (var/datum/cooking_item/cooking_item in cooking_objs)
		. += "<br>\a [cooking_item.container.label(null, cooking_item.combine_target)][cooking_item.max_cookwork ? ", " : ""][report_progress(cooking_item)]</li>"
	. += "</ul>"

/obj/machinery/appliance/proc/report_progress(datum/cooking_item/cooking_item)
	if (!cooking_item || !cooking_item.max_cookwork)
		return null

	if (!cooking_item.cookwork)
		return "It is cold."
	var/progress = cooking_item.cookwork / cooking_item.max_cookwork
	var/half_overcook = (cooking_item.overcook_mult - 1)*0.5
	switch(progress)
		if (0 to 0.25)
			return "It's barely started cooking."
		if (0.25 to 0.75)
			return SPAN_NOTICE("It's cooking away nicely.")
		if (0.75 to 1)
			return SPAN_NOTICE("<b>It's almost ready!</b>")
	if (progress < 1+half_overcook)
		return SPAN_GOOD("<b>It is done!</b>")
	if (progress < cooking_item.overcook_mult)
		return SPAN_WARNING("It looks overcooked, get it out!")
	return SPAN_DANGER("It is burning!")

/obj/machinery/appliance/proc/get_cooking_item_from_container(obj/item/reagent_containers/cooking_container/cooking_container)
	for(var/cooking_object in cooking_objs)
		var/datum/cooking_item/item = cooking_object
		if(item.container == cooking_container)
			return item

/obj/machinery/appliance/on_update_icon()
	if (operating)
		icon_state = on_icon
	else
		icon_state = off_icon

/obj/machinery/appliance/proc/attempt_toggle_power(mob/user)
	if (use_check_and_message(user, issilicon(user) ? USE_ALLOW_NON_ADJACENT : 0))
		return
	var/list/missing = missing_parts()
	if(missing || !anchored)
		return
	operating = !operating
	update_use_power(operating ? POWER_USE_ACTIVE : POWER_USE_OFF)
	if(user)
		user.visible_message("[user] turns [src] [operating ? "on" : "off"].", "You turn [operating ? "on" : "off"] [src].")
	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()

/obj/machinery/appliance/proc/choose_output()
	set src in view()
	set name = "Choose Output"
	set category = "Object"

	if (use_check_and_message(usr, issilicon(usr) ? USE_ALLOW_NON_ADJACENT : 0))
		return
	var/choice = input("What specific food do you wish to make with [src]?", "Choose Output") as null|anything in (output_options + "Default")
	if(!choice)
		return
	selected_option = (choice == "Default") ? null : choice
	to_chat(usr, SPAN_NOTICE("You decide to make [choice == "Default" ? "nothing specific" : choice] with [src]."))

/obj/machinery/appliance/proc/can_insert(obj/item/item, mob/user)
	var/obj/item/grab/grabbed = item
	if(istype(grabbed))
		if(!can_cook_mobs)
			to_chat(user, SPAN_WARNING("That's not going to fit."))
			return COOKING_CANNOT_INSERT

		if(!isliving(grabbed.affecting))
			to_chat(user, SPAN_WARNING("You can't cook that."))
			return COOKING_CANNOT_INSERT

		return COOKING_INSERT_GRABBED

	if (!has_space(item))
		to_chat(user, SPAN_WARNING("There's no room in [src] for that!"))
		return COOKING_CANNOT_INSERT

	if (istype(item, /obj/item/reagent_containers/cooking_container))
		var/obj/item/reagent_containers/cooking_container/cooking_container = item
		if(cooking_container.appliancetype & appliancetype)
			return COOKING_CAN_INSERT

	// We're trying to cook something else. Check if it's valid.
	var/obj/item/reagent_containers/food/snacks/check = item
	if(istype(check) && check.cooked && (check.cooked == cook_type))
		to_chat(user, SPAN_WARNING("[check] has already been [check.cooked]."))
		return COOKING_CANNOT_INSERT
	else if(istype(item, /obj/item/reagent_containers/glass))
		to_chat(user, SPAN_WARNING("That would probably break [item]."))
		return COOKING_CANNOT_INSERT
	else if(item.IsCrowbar() || item.IsScrewdriver() || istype(item, /obj/item/storage/part_replacer))
		return COOKING_CANNOT_INSERT
	else if(!istype(check) && !istype(item, /obj/item/holder))
		to_chat(user, SPAN_WARNING("That's not edible."))
		return COOKING_CANNOT_INSERT
	return COOKING_CAN_INSERT

//This function is overridden by cookers that do stuff with containers
/obj/machinery/appliance/proc/has_space(obj/item/item)
	if (length(cooking_objs) >= max_contents)
		return FALSE
	return TRUE

/obj/machinery/appliance/use_tool(obj/item/item, mob/living/user, list/click_params)
	. = ..()
	if(.)
		return .

	if(!cook_type || inoperable())
		to_chat(user, SPAN_WARNING("[src] is not working."))

	var/result = can_insert(item, user)
	if(result == COOKING_CANNOT_INSERT)
		return FALSE

	if(result == COOKING_INSERT_GRABBED)
		var/obj/item/grab/G = item
		if (G && istype(G) && G.affecting)
			cook_mob(G.affecting, user)
			return TRUE

	//From here we can start cooking food
	add_content(item, user)
	update_icon()
	return TRUE

/obj/machinery/appliance/proc/add_content(obj/item/item, mob/user)
	if(!user.unEquip(item))
		return

	var/datum/cooking_item/cooking_item = has_space(item)
	if (istype(item, /obj/item/reagent_containers/cooking_container) && cooking_item)
		var/obj/item/reagent_containers/cooking_container/cooking_container = item
		cooking_item = new /datum/cooking_item/(cooking_container)
		item.forceMove(src)
		cooking_objs.Add(cooking_item)
		if (cooking_container.check_contents() == COOKING_CONTAINER_EMPTY)//If we're just putting an empty container in, then dont start any processing.
			user.visible_message("<b>[user]</b> puts [item] [place_verb] [src].")
			return
	else
		if (cooking_item && istype(cooking_item))
			if (istype(item, /obj/item/reagent_containers/food/snacks/egg) && user.a_intent != I_HELP)
				item.use_after(cooking_item.container, user)
			else
				item.forceMove(cooking_item.container)

		else //Something went wrong
			return

	if (selected_option)
		cooking_item.combine_target = selected_option

	// We can actually start cooking now.
	user.visible_message("<b>[user]</b> puts [item] [place_verb] [src].")
	if(selected_option || length(cooking_item.container.contents) || select_recipe(cooking_item.container || src, appliance = cooking_item.container.appliancetype)) // we're doing combo cooking, we're not just heating reagents, OR we have a valid reagent-only recipe
		// this is to stop reagents from burning when you're heating stuff
		get_cooking_work(cooking_item)
		cooking = TRUE

	return cooking_item

/obj/machinery/appliance/proc/get_cooking_work(datum/cooking_item/cooking_item)
	for (var/obj/item/J in cooking_item.container)
		oilwork(J, cooking_item)

	for (var/datum/reagent/reagent in cooking_item.container.reagents.reagent_list)
		if (istype(reagent, /datum/reagent/nutriment))
			cooking_item.max_cookwork += reagent.volume * 2 //Added reagents contribute less than those in food items due to granular form

			//Nonfat reagents will soak oil
			if (!istype(reagent, /datum/reagent/nutriment/cornoil))
				cooking_item.max_oil += reagent.volume * 0.25
		else
			cooking_item.max_cookwork += reagent.volume
			cooking_item.max_oil += reagent.volume * 0.10

	//Rescaling cooking work to avoid insanely long times for large things
	var/brackets = cooking_item.max_cookwork / 4
	cooking_item.max_cookwork = 4 * (1-0.95**brackets) / 0.05

//Just a helper to save code duplication in the above
/obj/machinery/appliance/proc/oilwork(obj/item/item, datum/cooking_item/cooking_item)
	var/obj/item/reagent_containers/food/snacks/food = item
	var/work = 0
	if (istype(food) && food.reagents)
		for (var/datum/reagent/reagent in food.reagents.reagent_list)
			if (istype(reagent, /datum/reagent/nutriment))
				work += reagent.volume * 3 //Core nutrients contribute much more than peripheral chemicals
				//Nonfat reagents will soak oil
				if (!istype(reagent, /datum/reagent/nutriment/cornoil))
					cooking_item.max_oil += reagent.volume * 0.35
			else
				work += reagent.volume
				cooking_item.max_oil += reagent.volume * 0.15


	else if(istype(item, /obj/item/holder))
		var/obj/item/holder/holder = item
		for (var/mob/living/mob in holder)
			if (mob)
				work += (mob.mob_size * mob.mob_size * 2) + 2

	cooking_item.max_cookwork += work

//Called every tick while we're cooking something
/obj/machinery/appliance/proc/do_cooking_tick(datum/cooking_item/cooking_item)
	if (!cooking_item.max_cookwork)
		return FALSE

	var/was_done = (cooking_item.cookwork >= cooking_item.max_cookwork)

	cooking_item.cookwork += cooking_power

	if (!was_done && cooking_item.cookwork >= cooking_item.max_cookwork)
		//If cookwork has gone from above to below 0, then this item finished cooking
		finish_cooking(cooking_item)

	else if (can_burn_food && !cooking_item.burned && cooking_item.cookwork > cooking_item.max_cookwork * cooking_item.overcook_mult)
		burn_food(cooking_item)

	// Gotta hurt.
	for(var/obj/item/holder/holder in cooking_item.container.contents)
		for (var/mob/living/mob in holder)
			if (mob)
				mob.apply_damage(rand(1,3), mobdamagetype, BP_CHEST)

	return TRUE

/obj/machinery/appliance/proc/get_smoke_percent()
	if(can_burn_food == FALSE)
		return 0
	var/closest_to_burn = 0
	for (var/datum/cooking_item/i in cooking_objs)
		if(i.burned | !i.max_cookwork)
			continue
		var/progress = i.cookwork / i.max_cookwork
		var/half_overcook = (i.overcook_mult - 1)*0.5
		var/normalized_burn = (progress - half_overcook)/(i.overcook_mult - half_overcook)
		if(progress < 1+half_overcook)
			continue
		if(normalized_burn > closest_to_burn)
			closest_to_burn = normalized_burn
	return closest_to_burn

/obj/machinery/appliance/proc/adjust_smoke()
	smoke_percent = get_smoke_percent()
	particle_holder.spawning = 3 * smoke_percent
	if(smoke_percent > 0)
		particles = particle_holder
	else
		particles = null

/obj/machinery/appliance/Process()
	..()
	if (inoperable() && operating)
		operating = FALSE
		update_use_power(operating ? POWER_USE_ACTIVE : POWER_USE_OFF)
		update_icon()
	if (cooking_power > 0 && cooking)
		for (var/i in cooking_objs)
			do_cooking_tick(i)
	if (can_burn_food)
		adjust_smoke()

/obj/machinery/appliance/proc/finish_cooking(datum/cooking_item/cooking_item)
	if(finish_verb)
		audible_message(SPAN_NOTICE("<b>[src]</b> [finish_verb]"))
	if(cooked_sound)
		playsound(get_turf(src), cooked_sound, 50, 1)
	//Check recipes first, a valid recipe overrides other options
	var/singleton/cooking_recipe/recipe = null
	var/atom/container = null
	var/appliance
	if (cooking_item.container && cooking_item.container.appliancetype)
		container = cooking_item.container
		appliance = cooking_item.container.appliancetype
	else if(appliancetype)
		container = src
		appliance = appliancetype
	if(appliance)
		recipe = select_recipe(container, appliance = appliance)

	if (recipe)
		var/list/results = list()
		results += recipe.CreateResult(container)

		var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes

		for (var/atom/movable/AM in results)
			AM.forceMove(temp)

		//making multiple copies of a recipe from one container. For example, tons of fries
		while (select_recipe(container, appliance = appliance) == recipe)
			var/list/TR = list()
			TR += recipe.CreateResult(container)
			for (var/atom/movable/AM in TR) //Move results to buffer
				AM.forceMove(temp)
			results += TR

		var/list/reagents_to_transfer = list()
		for (var/datum/reagent/reagent_left in container.reagents.reagent_list)
			reagents_to_transfer[reagent_left] = reagent_left.volume / length(results)

		var/total_remaining_reagents = container.reagents.total_volume
		for (var/result in results)
			var/obj/item/reagent_containers/food/snacks/food_result = result
			container.reagents.trans_to_obj(food_result, total_remaining_reagents / length(results))
			food_result.forceMove(container) //Move everything from the buffer back to the container

		QDEL_NULL(temp) //delete buffer object
		. = TRUE //None of the rest of this function is relevant for recipe cooking

	else if(cooking_item.combine_target)
		. = combination_cook(cooking_item)

	else
		//Otherwise, we're just doing standard modification cooking. change a color + name
		for (var/obj/item/i in cooking_item.container)
			modify_cook(i, cooking_item)
	update_icon()

//Combination cooking involves combining the names and reagents of ingredients into a predefined output object
//The ingredients represent flavours or fillings. EG: donut pizza, cheese bread
/obj/machinery/appliance/proc/combination_cook(datum/cooking_item/cooking_item)
	if(!cooking_item.combine_target)
		return
	var/cook_path = output_options[cooking_item.combine_target]

	var/list/words = list()
	var/list/cooktypes = list()
	var/datum/reagents/buffer = new /datum/reagents(1000, GLOB.temp_reagents_holder)
	var/totalcolour

	for (var/obj/item/I in cooking_item.container)
		var/obj/item/reagent_containers/food/snacks/S
		if (istype(I, /obj/item/reagent_containers/food/snacks))
			S = I

		if (!S)
			continue

		words |= splittext(S.name," ")
		cooktypes |= S.cooked

		if (S.reagents && S.reagents.total_volume > 0)
			if (S.filling_color)
				if (!totalcolour || !buffer.total_volume)
					totalcolour = S.filling_color
				else
					var/t = buffer.total_volume + S.reagents.total_volume
					t = buffer.total_volume / y
					totalcolour = BlendRGB(totalcolour, S.filling_color, t)
					//Blend colours in order to find a good filling color


			S.reagents.trans_to_holder(buffer, S.reagents.total_volume)
		//Cleanup these empty husk ingredients now
		if (I)
			qdel(I)
		if (S)
			qdel(S)

	cooking_item.container.reagents.trans_to_holder(buffer, cooking_item.container.reagents.total_volume)

	var/obj/item/reagent_containers/food/snacks/variable/result = new cook_path(cooking_item.container)
	buffer.trans_to(result, buffer.total_volume)

	//Filling overlay
	var/image/I = image(result.icon, "[result.icon_state]_filling")
	I.color = totalcolour
	result.AddOverlays(I)
	result.filling_color = totalcolour

	//Set the name.
	words -= list("and", "the", "in", "is", "bar", "raw", "sticks", "deep", "-o-", "warm", "two", "flavored", "boiled", "small", "large", "tiny", "huge", "massive", "extra")
	//Remove common connecting words and unsuitable ones from the list. Unsuitable words include those describing
	//the shape, cooked-ness/temperature or other state of an ingredient which doesn't apply to the finished product
	words.Remove(result.name)
	shuffle(words)
	var/num = 6 //Maximum number of words
	result.name = result.get_name_sans_prefix()
	while (num > 0)
		num--
		if (!length(words))
			break
		//Add prefixes from the ingredients in a random order until we run out or hit limit
		result.name = "[pop(words)] [result.name]"

	//This proc sets the size of the output result
	result.update_prefix()
	return result

//Helper proc for standard modification cooking
/obj/machinery/appliance/proc/modify_cook(obj/item/input, datum/cooking_item/cooking_item)
	var/obj/item/reagent_containers/food/snacks/result
	if (istype(input, /obj/item/reagent_containers/food/snacks))
		result = input
	else
		//Nonviable item
		return

	if (!result)
		return

	result.cooked = cook_type

	if (use_container_cook_type)
		var/obj/item/reagent_containers/cooking_container/cooking_container = cooking_item.container
		if (istype(cooking_container) && cooking_container.cook_type)
			result.cooked = cooking_container.cook_type

	// Set icon and appearance.
	change_product_appearance(result, cooking_item)

	// Update strings.
	change_product_strings(result, cooking_item, result.cooked)

/obj/machinery/appliance/proc/burn_food(datum/cooking_item/cooking_item)
	// You dun goofed.
	cooking_item.burned = TRUE
	cooking_item.container.clear()
	var/obj/item/reagent_containers/food/snacks/badrecipe/burned = new /obj/item/reagent_containers/food/snacks/badrecipe(cooking_item.container)
	set_extension(burned, /datum/extension/scent/food/burning)

	var/datum/effect/smoke_spread/bad/smoke = new /datum/effect/smoke_spread/bad
	smoke.attach(src)
	smoke.set_up(10, 0, get_turf(src), 300)
	smoke.start()
	if (prob(10))
		visible_message(SPAN_WARNING("[src] sets on fire!"))
		var/turf/adjacent = get_step(src, dir)
		adjacent.IgniteTurf(20)
		smoke_percent -= 25
	else
		visible_message(SPAN_DANGER("[src] vomits a gout of rancid smoke!"))

/obj/machinery/appliance/CtrlClick(mob/user)
	if(use_check(user))
		return FALSE
	attempt_toggle_power(user)
	return TRUE

/obj/machinery/appliance/attack_hand(mob/user)
	if (!length(cooking_objs))
		return
	if (removal_menu(user))
		return
	. = ..()

/obj/machinery/appliance/proc/removal_menu(mob/user)
	if (!can_remove_items(user))
		return FALSE
	var/list/choices = list()
	var/list/menuoptions = list()
	for (var/a in cooking_objs)
		var/datum/cooking_item/cooking_item = a
		if (cooking_item.container)
			var/current_iteration_len = length(menuoptions) + 1
			menuoptions[cooking_item.container.label(current_iteration_len)] = cooking_item
			var/obj/item/icon_to_use = cooking_item.container
			if(length(cooking_item.container.contents) == 1)
				var/obj/item/I = locate() in cooking_item.container.contents
				icon_to_use = I
			choices[cooking_item.container.label(current_iteration_len)] = icon_to_use

	var/selection = show_radial_menu(user, src, choices, require_near = TRUE, tooltips = TRUE, no_repeat_close = TRUE)
	if (selection)
		var/datum/cooking_item/cooking_item = menuoptions[selection]
		eject(cooking_item, user)
		update_icon()
	return TRUE

/obj/machinery/appliance/proc/can_remove_items(mob/user)
	return !use_check_and_message(user)

/obj/machinery/appliance/proc/eject(datum/cooking_item/cooking_item, mob/user = null)
	var/obj/item/thing
	var/delete = TRUE
	var/status = cooking_item.container.check_contents()
	if (status == COOKING_CONTAINER_SINGLE)//If theres only one object in a container then we extract that
		thing = locate(/obj/item) in cooking_item.container
		delete = FALSE
	else//If the container is empty OR contains more than one thing, then we must extract the container
		thing = cooking_item.container
		cooking_objs -= cooking_item
	if (!user || !user.put_in_hands(thing))
		thing.forceMove(get_turf(src))

	if (delete)
		qdel(cooking_item)
	else
		cooking_item.reset()//reset instead of deleting if the container is left inside

/obj/machinery/appliance/proc/cook_mob(mob/living/victim, mob/user)
	return

/obj/machinery/appliance/proc/change_product_strings(obj/item/reagent_containers/food/snacks/product, datum/cooking_item/cooking_item, cook_type)
	product.name = "[cook_type] [product.name]"
	product.desc = "[product.desc]\nIt has been [cook_type]."


/obj/machinery/appliance/proc/change_product_appearance(obj/item/reagent_containers/food/snacks/product, datum/cooking_item/cooking_item)
	product.color = food_color
	product.filling_color = food_color

/datum/cooking_item
	var/max_cookwork = 0
	var/cookwork
	var/overcook_mult = 5
	var/obj/item/reagent_containers/cooking_container/container = null
	var/combine_target = null
	var/burned = FALSE

	var/oil = 0
	var/max_oil = 0//Used for fryers.

/datum/cooking_item/New(obj/item/I)
	container = I

//This is called for containers whose contents are ejected without removing the container
/datum/cooking_item/proc/reset()
	max_cookwork = 0
	cookwork = 0
	burned = FALSE
	max_oil = 0
	oil = 0
	combine_target = null
	//Container is not reset

/obj/machinery/appliance/proc/update_cooking_power()
	cooking_power = cooking_coeff

/obj/machinery/appliance/RefreshParts()
	..()
	var/scan_rating = total_component_rating_of_type(/obj/item/stock_parts/scanning_module)
	var/cap_rating = total_component_rating_of_type(/obj/item/stock_parts/capacitor)

	change_power_consumption(initial(active_power_usage) - scan_rating * 25, POWER_USE_ACTIVE)
	heating_power = initial(heating_power) + cap_rating * 50 // + 50W per tier
	cooking_coeff = (1 + (scan_rating + cap_rating) / 20) // +20% per tier
