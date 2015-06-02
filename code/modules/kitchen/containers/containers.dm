/*
 * Containers
 */

// Each container is specialized to make a specific 'type' of food, such as pizza, cake, pie, etc.
// Depending on the contents of the container, you can make different kinds of pizza/cake/whatever, with just one path
// For example, if a majority of the contents are apple, and there's also some banana in, you'd get a pie named 'apple banana pie'.
// When cooking, and at prolonged amounts of heat, the contents of the container are converted into the finished food,
// and for simplicity's sake, the heat of the pan is reset, as processing the pan cooling down is unneccessary.

/obj/item/weapon/reagent_containers/kitchen
	icon = 'icons/obj/kitchen/inedible/tools.dmi'
	force = 3
	throwforce = 3
	w_class = 2
	flags = CONDUCT | OPENCONTAINER

	var/cooking_method = METHOD_BOILING
	var/warning_cook_time = 100            // Time before being warned about burning.
	var/max_cook_time = 200                // Time before burning.

	var/current_heat = 0                   // Current heat that the object is holding.
	var/max_heat_capacity = 500            // Heat cap.
	var/recieved_heat                      // If not set, object will cool to ambient each tick.
	var/cool_amount = 5                    // Amount that the container will cool per tick.

	var/max_items = 3                      // Number of items that can be held at once.
	var/max_w_class = 3                    // Max size of held items.
	var/list/will_accept = list(/obj/item) // Acceptable item types.

	var/list/cooking_objects = list()      // Assoc list by item ref with current cooking time.
	var/list/item_conversion = list()      // Objects of these types in attackby() will be converted
	var/processes = 1                      // into new objects inside the container. Dough > pie base etc.

/obj/item/weapon/reagent_containers/kitchen/New()
	..()
	if(processes) processing_objects |= src
	create_reagents(80)

/obj/item/weapon/reagent_containers/kitchen/proc/recieve_heat(var/temperature)
	current_heat = min(max_heat_capacity,max(0,current_heat+temperature))
	recieved_heat = 1

/obj/item/weapon/reagent_containers/kitchen/process()
	if(current_heat <= 0)
		return

	// Process heat.
	if(!recieved_heat)
		current_heat = max(0,current_heat-cool_amount)
	recieved_heat = 0

	if(!contents.len)
		return

	// Process food output.
	var/turf/T = get_turf(src)

	// Try and make anything that the container specifically creates when heated.
	if(attempt_inherent_product())
		return

	for(var/obj/item/I in contents)
		// Apply heat and track progress for this item.
		var/objref = "\ref[I]"
		if(!cooking_objects[objref])
			cooking_objects[objref] = current_heat
		else
			cooking_objects[objref] += current_heat

		// See if there is a valid food transition for this item.
		var/datum/food_transition/F = get_food_transition(I, cooking_method, cooking_objects[objref], reagents, src)
		if(F)
			cooking_objects[objref] = null

			// Clear out the reagent list if they were used up by something being cooked.
			for(var/reagent_tag in F.req_reagents)
				reagents.remove_reagent(reagent_tag,F.req_reagents[reagent_tag])

			// Make the food object.
			var/obj/item/food = F.get_output_product(I)
			food.loc = src
			for(var/obj/item/subitem in I)
				if(subitem.reagents && subitem.reagents.total_volume)
					subitem.reagents.trans_to_obj(food,subitem.reagents.total_volume)
					qdel(subitem)
			qdel(I)
			T.visible_message("\The [food] in \the [src] [F.cooking_message ? F.cooking_message : "is ready"].")
			continue

		// Might be burning it or overcooking it, noob.
		if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/badrecipe))
			make_smoke() // Gross.
		else if(cooking_objects[objref] >= max_cook_time)
			// Ya dun goofed.
			reagents.reagent_list.Cut()
			cooking_objects[objref] = null
			for(var/obj/item/subitem in I)
				qdel(subitem)
			qdel(I)
			// Delicious carbon.
			new /obj/item/weapon/reagent_containers/food/snacks/badrecipe(src)
			T.visible_message("<span class='danger'>\The [I] in \the [src] is a charred mess!</span>")
		else if(cooking_objects[objref] >= warning_cook_time && prob(30))
			T.visible_message("<span class='danger'>\The [I] in \the [src] starts to smoke...</span>")
			make_smoke()

/obj/item/weapon/reagent_containers/kitchen/proc/make_smoke()
	return

/obj/item/weapon/reagent_containers/kitchen/examine(var/user as mob)
	..()
	user << "You can see [english_list(src.contents, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )] inside."

/obj/item/weapon/reagent_containers/kitchen/proc/update_overlays()
	return

/obj/item/weapon/reagent_containers/kitchen/proc/can_accept(var/obj/item/O)
	if(O.w_class > max_w_class)
		return 0
	if(will_accept.len)
		for(var/checktype in will_accept)
			if(istype(O, checktype))
				return 1
	else
		return 1
	return 0

/obj/item/weapon/reagent_containers/kitchen/attackby(var/obj/item/O, var/mob/user) //Put things inside
	if(O.is_open_container())
		return ..(O, user)

	if(contents.len >= max_items)
		user << "<span class='notice'>\The [src] can't fit anymore!</span>"
		return

	if(!can_accept(O))
		user << "<span class='notice'>\The [O] can't go into \the [src]!</span>"

	user.drop_from_inventory(O)

	var/replaced_obj
	for(var/datum/ingredient_conversion/C in item_conversion)
		if(istype(O,C.input_type))
			var/obj/item/new_food = new C.output_type(src)
			replaced_obj = 1
			user.visible_message("\The [user] [C.conversion_message].")
			O.reagents.trans_to_obj(new_food,O.reagents.total_volume)
			qdel(O)
			break
	if(!replaced_obj)
		O.loc = src
		user.visible_message("\The [user] puts \the [O] into \the [src].")

/obj/item/weapon/reagent_containers/kitchen/attack_self(var/mob/user as mob) //Take things out
	for(var/obj/O in contents)
		O.loc = get_turf(src)
	reagents.clear_reagents()
	user << "<span class='notice'>You tip the [src] upside-down.</span>"
	cooking_objects.Cut()
	update_overlays()
	..()

/obj/item/weapon/reagent_containers/kitchen/proc/attempt_inherent_product()
	return