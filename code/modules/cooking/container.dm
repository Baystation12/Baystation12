//Cooking containers are used in ovens and fryers, to hold multiple ingredients for a recipe.
//They work fairly similar to the microwave - acting as a container for objects and reagents,
//which can be checked against recipe requirements in order to cook recipes that require several things

/obj/item/reagent_containers/cooking_container
	icon = 'icons/obj/cooking_container.dmi'
	var/shortname
	var/place_verb = "into"
	var/max_space = 20 //Maximum sum of w-classes of foods in this container at once
	force = 5
	throw_speed = 1
	throw_range = 5
	volume = 80 //Maximum units of reagents
	w_class = ITEM_SIZE_NORMAL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
	matter = list(MATERIAL_ALUMINIUM = 3000)
	var/list/insertable = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/holder,
		/obj/item/paper,
		/obj/item/stack/material/rods,
		/obj/item/organ/internal/brain,
		/obj/item/stack/nanopaste
		)
	var/appliancetype // Bitfield, uses the same as appliances
	var/show_food_items = TRUE
	w_class = ITEM_SIZE_NORMAL
	var/cook_type // optional string to influence the appliance cook_type

/obj/item/reagent_containers/cooking_container/on_update_icon()
	..()
	ClearOverlays()
	if (show_food_items)
		for (var/obj/item/I in contents)
			var/image/food = overlay_image(I.icon, I.icon_state, I.color)
			food.pixel_x = rand(-3, 3)
			food.pixel_y = rand(-3, 3)
			var/matrix/M = matrix()
			M.Scale(0.5)
			food.transform = M
			AddOverlays(food)
	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]_filling_overlay")
		filling.color = reagents.get_color()
		AddOverlays(filling)

/obj/item/reagent_containers/cooking_container/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/attack_hand()
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(length(contents))
			to_chat(user, SPAN_NOTICE(get_content_info()))
		if(reagents.total_volume)
			to_chat(user, SPAN_NOTICE(get_reagent_info()))

/obj/item/reagent_containers/cooking_container/throw_impact(atom/hit_atom)
	if (QDELETED(src))
		return
	if (length(reagents.reagent_list) > 0 || length(contents))
		visible_message(
			SPAN_DANGER("[src] bounces and spills all its contents!"),
			SPAN_WARNING("You hear the sound of something hitting something.")
		)
	if (length(reagents.reagent_list) > 0)
		reagents.splash(hit_atom, reagents.total_volume)
	for(var/obj/item/I in contents)
		I.dropInto(get_turf(hit_atom))
		step(I, pick(NORTH, SOUTH, EAST, WEST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST))
	update_icon()

// When hitting people with the container, drop all its items everywhere. You jerk.
/obj/item/reagent_containers/cooking_container/use_before(mob/living/M, mob/living/user)
	. = FALSE
	if (user.a_intent != I_HURT)
		return FALSE

	// Drop all the things. All of them.
	for(var/obj/item/I in contents)
		I.dropInto(get_turf(M))
		step(I, pick(NORTH, SOUTH, EAST, WEST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST))

	update_icon()
	return TRUE

/obj/item/reagent_containers/cooking_container/use_before(atom/target, mob/living/user, click_parameters)
	var/intent_check = ishuman(user) ? I_GRAB : I_HELP
	if (user.a_intent != intent_check || istype(target, /obj/item/storage) || istype(target, /obj/screen/item_relayed/storage))
		return ..()

	var/turf/turf = get_turf(target)
	if (LAZYLEN(contents))
		// Table - Dump contents
		if (istype(target, /obj/structure/table))
			ClearOverlays()
			for (var/obj/item/carried in contents)
				carried.dropInto(turf)
			user.visible_message(
				SPAN_NOTICE("\The [user] dumps \a [src]'s contents onto \the [target]."),
				SPAN_NOTICE("You dump \the [src]'s contents onto \the [target].")
			)
			update_icon()
			return TRUE

		// Fridge - Load fridge
		if (istype(target, /obj/machinery/smartfridge))
			var/obj/machinery/smartfridge/fridge = target
			var/fed_in = 0
			ClearOverlays()
			for (var/obj/item/carried in contents)
				if (!fridge.accept_check(carried))
					continue
				carried.dropInto(fridge)
				fridge.stock_item(carried)
				fed_in++
			if (!fed_in)
				USE_FEEDBACK_FAILURE("Nothing in \the [src] is valid for \the [target].")
				return TRUE
			var/some_of = LAZYLEN(contents) ? "some of " : ""
			user.visible_message(
				SPAN_NOTICE("\The [user] fills \the [target] with [some_of]\a [src]'s contents."),
				SPAN_NOTICE("You fill \the [target] with [some_of]\the [src]'s contents.")
			)
			update_icon()
			return TRUE

	// Attempt to load items
	var/obj/item/target_item = target
	if (target_item && istype(target_item))
		if (is_type_in_list(target_item, insertable))
			if (!can_fit(target_item))
				to_chat(user, SPAN_WARNING("There's no more space in [src] for that!"))
				return
			if (istype(target_item, /obj/item/reagent_containers/food/snacks/egg) && user.a_intent != I_HELP) // Really annoying edge case
				target_item.use_after(src, user)
			else
				target_item.forceMove(src)
				to_chat(user, SPAN_NOTICE("You put [target_item] [place_verb] [src]."))
			update_icon()
			return TRUE
		else if (istype(target_item, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/reagent_container = target_item
			reagent_container.standard_pour_into(user, src)
			return TRUE

	var/added_items = 0
	for (var/obj/item/item in turf)
		if (can_fit(item))
			item.forceMove(src)
			added_items++
	if (!added_items)
		USE_FEEDBACK_FAILURE("\The [target] doesn't have anything to pick up with \the [src].")
		return TRUE
	user.visible_message(
		SPAN_NOTICE("\The [user] scoops some things up from \the [target] with \a [src]."),
		SPAN_NOTICE("You scoop some things up from \the [target] with \the [src].")
	)
	update_icon()
	return TRUE

/obj/item/reagent_containers/cooking_container/use_after(obj/target, mob/living/user, click_parameters)
	if (standard_dispenser_refill(user, target) || standard_pour_into(user, target))
		return TRUE
	splashtarget(target, user)
	return TRUE

/obj/item/reagent_containers/cooking_container/proc/get_content_info()
	var/string = "It contains:</br><ul><li>"
	string += jointext(contents, "</li><li>") + "</li></ul>"
	return string

/obj/item/reagent_containers/cooking_container/proc/get_reagent_info()
	return "It contains [reagents.total_volume] units of reagents."

/obj/item/reagent_containers/cooking_container/MouseEntered(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(modifiers[MOUSE_SHIFT] && get_dist(usr, src) <= 2)
		params = replacetext(params, "shift=1;", "") // tooltip doesn't appear unless this is stripped
		var/description
		if(length(contents))
			description = get_content_info()
		if(reagents.total_volume)
			if(!description)
				description = ""
			description += get_reagent_info()
		openToolTip(usr, src, params, name, description)

/obj/item/reagent_containers/cooking_container/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/reagent_containers/cooking_container/use_tool(obj/item/tool, mob/user, list/click_params)
	if(is_type_in_list(tool, insertable))
		if (!can_fit(tool))
			to_chat(user, SPAN_WARNING("There's no more space in [src] for that!"))
			return TRUE

		if (istype(tool, /obj/item/reagent_containers/food/snacks/egg) && user.a_intent != I_HELP) // Really annoying edge case
			tool.use_after(src, user)
		else
			if(!user.unEquip(tool))
				return TRUE
			tool.forceMove(src)
			to_chat(user, SPAN_NOTICE("You put [tool] [place_verb] [src]."))
		update_icon()
		return TRUE
	return ..()

/obj/item/reagent_containers/cooking_container/verb/empty()
	set src in oview(1)
	set name = "Empty Container"
	set category = "Object"
	set desc = "Removes items from the container, excluding reagents."

	do_empty(usr, get_turf(src))

/obj/item/reagent_containers/cooking_container/proc/do_empty(mob/user, new_loc)
	if (use_check_and_message(user))
		return

	if (!length(contents))
		to_chat(user, SPAN_WARNING("There's nothing in [src] you can remove!"))
		return

	for (var/contained in contents)
		var/atom/movable/AM = contained
		AM.forceMove(new_loc)

	to_chat(user, SPAN_NOTICE("You remove all the solid items from [src]."))
	update_icon()

/obj/item/reagent_containers/cooking_container/proc/check_contents()
	if (!length(contents))
		if (!reagents?.total_volume)
			return COOKING_CONTAINER_EMPTY
	else if (length(contents) == 1)
		if (!reagents?.total_volume)
			return COOKING_CONTAINER_SINGLE
	return COOKING_CONTAINER_MANY

/obj/item/reagent_containers/cooking_container/AltClick(mob/user)
	do_empty(user, get_turf(src))
	return TRUE

//Deletes contents of container.
//Used when food is burned, before replacing it with a burned mess
/obj/item/reagent_containers/cooking_container/proc/clear()
	QDEL_CONTENTS
	reagents.clear_reagents()

/obj/item/reagent_containers/cooking_container/proc/label(number, CT = null)
	//This returns something like "Fryer basket 1 - empty"
	//The latter part is a brief reminder of contents
	//This is used in the removal menu
	. = shortname
	if (!isnull(number))
		.+= " [number]"
	.+= " - "
	if (CT)
		return . + CT
	else if (LAZYLEN(contents))
		var/obj/O = locate() in contents
		return . + O.name //Just append the name of the first object
	else if (reagents.total_volume > 0)
		return . + reagents.get_master_reagent_name()//Append name of most voluminous reagent
	return . + "empty"

/obj/item/reagent_containers/cooking_container/proc/can_fit(obj/item/I)
	var/total = 0
	for (var/contained in contents)
		var/obj/item/J = contained
		total += J.w_class

	if((max_space - total) >= I.w_class && !I.anchored && I.canremove)
		return TRUE
	return FALSE

//Takes a reagent holder as input and distributes its contents among the items in the container
//Distribution is weighted based on the volume already present in each item
/obj/item/reagent_containers/cooking_container/proc/soak_reagent(datum/reagents/holder)
	var/total = 0
	var/list/weights = list()
	for (var/contained in contents)
		var/obj/item/I = contained
		if (I.reagents && I.reagents.total_volume)
			total += I.reagents.total_volume
			weights[I] = I.reagents.total_volume

	if (total > 0)
		for (var/contained in contents)
			var/obj/item/I = contained
			if (weights[I])
				holder.trans_to(I, weights[I] / total)

/obj/item/reagent_containers/cooking_container/tray
	name = "tray"
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	hitsound = "tray_hit"
	volume = 0
	var/bash_cooldown = 0 // You can bash a rolling pin against a tray to make a shield bash sound! Based on world.time

// Bash a rolling pin against a tray like a true knight!
/obj/item/reagent_containers/cooking_container/tray/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/material/rollingpin))
		if(bash_cooldown < world.time)
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			bash_cooldown = world.time + 25
		return TRUE
	return ..()

/obj/item/reagent_containers/cooking_container/oven
	name = "oven dish"
	shortname = "shelf"
	desc = "Put ingredients in this; designed for use with an oven. Warranty void if used."
	icon_state = "ovendish"
	max_space = 30
	volume = 120
	appliancetype = COOKING_APPLIANCE_OVEN

/obj/item/reagent_containers/cooking_container/skillet
	name = "skillet"
	shortname = "skillet"
	desc = "Chuck ingredients in this to fry something on the stove."
	icon_state = "skillet"
	volume = 30
	force = 16
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	appliancetype = COOKING_APPLIANCE_SKILLET
	show_food_items = FALSE
	cook_type = "pan-fried"

/obj/item/reagent_containers/cooking_container/skillet/Initialize(mapload, new_material)
	. = ..(mapload)
	var/material/material = SSmaterials.get_material_by_name(new_material || MATERIAL_STEEL)
	if(!material)
		return
	if(material.name != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/saucepan
	name = "saucepan"
	shortname = "saucepan"
	desc = "Is it a pot? Is it a pan? It's a saucepan!"
	icon_state = "pan"
	volume = 90
	force = 18
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	appliancetype = COOKING_APPLIANCE_SAUCEPAN
	show_food_items = FALSE
	cook_type = "sauteed"

/obj/item/reagent_containers/cooking_container/saucepan/Initialize(mapload, new_material)
	. = ..(mapload)
	var/material/material = SSmaterials.get_material_by_name(new_material || MATERIAL_STEEL)
	if(!material)
		return
	if(material.name != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/pot
	name = "cooking pot"
	shortname = "pot"
	desc = "Boil things with this. Maybe even stick 'em in a stew."
	icon_state = "pot"
	max_space = 50
	volume = 180
	force = 18
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	appliancetype = COOKING_APPLIANCE_POT
	w_class = ITEM_SIZE_LARGE
	show_food_items = FALSE
	cook_type = "boiled"

/obj/item/reagent_containers/cooking_container/pot/Initialize(mapload, new_material)
	. = ..(mapload)
	var/material/material = SSmaterials.get_material_by_name(new_material || MATERIAL_STEEL)
	if(!material)
		return
	if(new_material && new_material != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/fryer
	name = "fryer basket"
	shortname = "basket"
	desc = "Put ingredients in this; designed for use with a deep fryer. Warranty void if used."
	icon_state = "basket"
	appliancetype = COOKING_APPLIANCE_FRYER
	show_food_items = FALSE

/obj/item/reagent_containers/cooking_container/grill_grate
	name = "grill grate"
	shortname = "grate"
	place_verb = "onto"
	desc = "Primarily used to grill meat, place this on a grill and grab a can of energy drink."
	icon_state = "grill_grate"
	appliancetype = COOKING_APPLIANCE_GRILL
	insertable = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)

/obj/item/reagent_containers/cooking_container/grill_grate/can_fit()
	if(length(contents) >= 3)
		return FALSE
	return TRUE

/obj/item/reagent_containers/cooking_container/microwave_plate
	name = "microwave plate"
	shortname = "plate"
	desc = "Put ingredients on this; designed for use with a microwave."
	icon_state = "microwave_plate"
	appliancetype = COOKING_APPLIANCE_MICROWAVE
	max_space = 30
	volume = 90
	force = 18

/obj/item/reagent_containers/cooking_container/board
	name = "chopping board"
	shortname = "board"
	place_verb = "onto"
	desc = "A food preparation surface that allows you to combine food more easily."
	icon_state = "board"
	appliancetype = COOKING_APPLIANCE_MIX
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	volume = 15 // for things like jelly sandwiches etc
	max_space = 25

/obj/item/reagent_containers/cooking_container/board/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && (length(contents) || reagents?.total_volume))
		to_chat(user, SPAN_NOTICE("To attempt cooking: click and hold, then drag this onto your character."))

/obj/item/reagent_containers/cooking_container/board/MouseDrop(atom/over_atom, atom/source_loc)
	if(over_atom != usr || use_check(usr))
		return ..()
	if(!(length(contents) || reagents?.total_volume))
		return ..()
	var/singleton/cooking_recipe/recipe = select_recipe(src, appliance = appliancetype)

	if(!recipe && length(contents))
		var/obj/item/reagent_containers/food/snacks/source = contents[1]
		var/obj/item/reagent_containers/food/snacks/variable/result = new (get_turf(src))
		if (source.reagents?.total_volume)
			source.reagents.trans_to(result, source.reagents.total_volume)
		for (var/hint in source.nutriment_desc)
			result.nutriment_desc[hint] = source.nutriment_desc[hint]
		result.combined_names = source.combined_names?.Copy()
		result.cooked = source.cooked
		result.icon = source.icon
		result.icon_state = source.icon_state
		result.color = source.color
		result.CopyOverlays(source)
		result.name = source.name
		result.desc = source.desc
		qdel(source)
		for (var/obj/item/reagent_containers/food/snacks/extra_ingredient in contents)
			result.combine(extra_ingredient, usr, FALSE)
		to_chat(usr, SPAN_NOTICE("You made [result.name]!"))
		return
	else if (!recipe)
		return ..()

	var/list/obj/results = recipe.CreateResult(src)
	var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes
	for (var/result in results)
		var/atom/movable/AM = result
		AM.forceMove(temp)

	//making multiple copies of a recipe from one container. For example, tons of fries
	while (select_recipe(src, appliance = appliancetype) == recipe)
		var/list/TR = list()
		TR += recipe.CreateResult(src)
		for (var/result in TR) //Move results to buffer
			var/atom/movable/AM = result
			AM.forceMove(temp)
		results += TR

	var/total_remaining_reagents = reagents.total_volume
	for (var/result in results)
		var/obj/item/reagent_containers/food/snacks/food_result = result
		reagents.trans_to_obj(food_result, total_remaining_reagents / length(results))
		food_result.forceMove(src) //Move everything from the buffer back to the container

	var/l = length(results)
	if (l && usr)
		var/name = results[1].name
		if (l > 1)
			to_chat(usr, SPAN_NOTICE("You made a batch of [name]!"))
		else
			to_chat(usr, SPAN_NOTICE("You made [name]!"))
	QDEL_NULL(temp) //delete buffer object
	do_empty(usr, get_turf(src))
	update_icon()

/obj/item/reagent_containers/cooking_container/board/bowl
	name = "mixing bowl"
	desc = "A large mixing bowl."
	desc = "A bowl. You bowl foods... wait, what?"
	icon_state = "mixingbowl"
	center_of_mass = "x=17;y=7"
	matter = list(MATERIAL_STEEL = 300)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60;180"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = FALSE
	show_food_items = FALSE

/obj/item/reagent_containers/cooking_container/board/bowl/Initialize()
	. = ..()
	desc += " It can hold up to [volume] units."

/obj/item/reagent_containers/cooking_container/board/bowl/on_update_icon()
	ClearOverlays()
	if (reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if (0 to 9)
				filling.icon_state = "[icon_state]-10"
			if (10 to 24)
				filling.icon_state = "[icon_state]10"
			if (25 to 49)
				filling.icon_state = "[icon_state]25"
			if (50 to 74)
				filling.icon_state = "[icon_state]50"
			if (75 to 79)
				filling.icon_state = "[icon_state]75"
			if (80 to 90)
				filling.icon_state = "[icon_state]80"
			if (91 to INFINITY)
				filling.icon_state = "[icon_state]100"
		filling.color = reagents.get_color()
		AddOverlays(filling)
