/*
 * Trays - initially by Agouri
 */

/obj/item/tray
	name = "tray"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	force = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	matter = list(MATERIAL_ALUMINIUM = 3000)
	hitsound = "tray_hit"
	var/bash_cooldown = 0 // You can bash a rolling pin against a tray to make a shield bash sound! Based on world.time
	var/list/carrying = list() // List of things on the tray. - Doohl
	var/max_carry = 2 * BASE_STORAGE_COST(ITEM_SIZE_NORMAL)


// Use the tray in-hand to dump out all its items.
/obj/item/tray/attack_self(mob/living/user)
	if (LAZYLEN(carrying))
		var/turf/T = get_turf(user)
		ClearOverlays()
		for (var/obj/item/carried in carrying)
			carried.dropInto(T)
			LAZYREMOVE(carrying, carried)
		user.visible_message(SPAN_NOTICE("[user] dumps out \the [src]."), SPAN_NOTICE("You empty out \the [src]."))
		return TRUE
	. = ..()

// When hitting people with the tray, drop all its items everywhere. You jerk.
/obj/item/tray/use_before(mob/living/M, mob/living/user)
	. = FALSE
	if (user.a_intent != I_HURT)
		return FALSE

	// Drop all the things. All of them.
	ClearOverlays()
	for(var/obj/item/I in carrying)
		I.dropInto(get_turf(M))
		carrying.Remove(I)
		step(I, pick(NORTH, SOUTH, EAST, WEST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST))
	return TRUE


// Bash a rolling pin against a tray like a true knight!
/obj/item/tray/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/material/kitchen/rollingpin))
		if(bash_cooldown < world.time)
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			bash_cooldown = world.time + 25
		return TRUE
	if (!istype(W, /obj/item/projectile) && !istype(W, /obj/item/clothing))
		if (calc_carry() + storage_cost_for_item(W) > max_carry)
			to_chat(user, SPAN_WARNING("\The [src] can't fit \the [W]!"))
		else if (!can_add_item(W))
			to_chat(user, SPAN_WARNING("\The [src] can't hold \the [W]!"))
		else
			to_chat(user, SPAN_NOTICE("You add \the [W] to \the [src]."))
			user.drop_item()
			pickup_item(W)
		return TRUE

	return ..()


// Returns the space an object takes up on the tray. Non-food takes up double!
/obj/item/tray/proc/storage_cost_for_item(obj/item/I)
	var/effective_cost = I.get_storage_cost()
	return istype(I, /obj/item/reagent_containers/food) ? effective_cost : effective_cost * 2


// Returns TRUE if the tray can hold an item, and FALSE otherwise.
/obj/item/tray/proc/can_add_item(obj/item/I)
	var/cost = storage_cost_for_item(I)
	return !I.anchored && I.canremove && \
		!istype(I, /obj/item/projectile) && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/storage) && \
		calc_carry() + cost <= max_carry


// Calculates the total storage cost being used by the tray.
/obj/item/tray/proc/calc_carry()
	. = 0
	for(var/obj/item/I in carrying)
		. += storage_cost_for_item(I)


// Puts an item onto the tray and displays it visually.
/obj/item/tray/proc/pickup_item(obj/item/I)
	I.forceMove(src)
	LAZYADD(carrying, I)
	add_item_overlay(I)


/obj/item/tray/use_before(atom/target, mob/living/user, click_parameters)
	var/intent_check = ishuman(user) ? I_GRAB : I_HELP
	if (user.a_intent != intent_check || istype(target, /obj/item/storage) || istype(target, /obj/screen/storage))
		return ..()

	var/turf/turf = get_turf(target)
	if (LAZYLEN(carrying))
		// Table - Dump contents
		if (istype(target, /obj/structure/table))
			ClearOverlays()
			for (var/obj/item/carried in carrying)
				carried.dropInto(turf)
			LAZYCLEARLIST(carrying)
			user.visible_message(
				SPAN_NOTICE("\The [user] dumps \a [src]'s contents onto \the [target]."),
				SPAN_NOTICE("You dump \the [src]'s contents onto \the [target].")
			)
			return TRUE

		// Fridge - Load fridge
		if (istype(target, /obj/machinery/smartfridge))
			var/obj/machinery/smartfridge/fridge = target
			var/fed_in = 0
			ClearOverlays()
			for (var/obj/item/carried in carrying)
				if (!fridge.accept_check(carried))
					add_item_overlay(carried)
					continue
				carried.dropInto(fridge)
				fridge.stock_item(carried)
				LAZYREMOVE(carrying, carried)
				fed_in++
			if (!fed_in)
				USE_FEEDBACK_FAILURE("Nothing in \the [src] is valid for \the [target].")
				return TRUE
			var/some_of = LAZYLEN(carrying) ? "some of " : ""
			user.visible_message(
				SPAN_NOTICE("\The [user] fills \the [target] with [some_of]\a [src]'s contents."),
				SPAN_NOTICE("You fill \the [target] with [some_of]\the [src]'s contents.")
			)
			return TRUE

	// Attempt to load items
	var/added_items = 0
	for (var/obj/item/item in turf)
		if (can_add_item(item))
			pickup_item(item)
			added_items++
	if (!added_items)
		USE_FEEDBACK_FAILURE("\The [target] doesn't have anything to pick up with \the [src].")
		return TRUE
	user.visible_message(
		SPAN_NOTICE("\The [user] scoops some things up from \the [target] with \a [src]."),
		SPAN_NOTICE("You scoop some things up from \the [target] with \the [src].")
	)
	return TRUE


// Adds a visible overlay on the tray with the item's icon, state, and overlays, to display them on the tray itself
/obj/item/tray/proc/add_item_overlay(obj/item/I)
	if (isnull(I) || !istype(I))
		return
	var/image/item_image = image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer, "pixel_x" = rand(-3, 3), "pixel_y" = rand(-3, 3)) // this line terrifies me
	item_image.color = I.color
	item_image.CopyOverlays(I)
	AddOverlays(item_image)
