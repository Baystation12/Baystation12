/*
 * Trays - initially by Agouri
 */

/obj/item/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
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
		overlays.Cut()
		for (var/obj/item/carried in carrying)
			carried.dropInto(T)
			LAZYREMOVE(carrying, carried)
		user.visible_message(SPAN_NOTICE("[user] dumps out \the [src]."), SPAN_NOTICE("You empty out \the [src]."))
		return TRUE
	. = ..()

// When hitting people with the tray, drop all its items everywhere. You jerk.
/obj/item/tray/attack(mob/living/M, mob/living/user)
	if (user.a_intent != I_HURT)
		return FALSE
	. = ..()
	// Drop all the things. All of them.
	overlays.Cut()
	for(var/obj/item/I in carrying)
		I.dropInto(get_turf(M))
		carrying.Remove(I)
		step(I, pick(NORTH, SOUTH, EAST, WEST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST))


// Bash a rolling pin against a tray like a true knight!
/obj/item/tray/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/material/kitchen/rollingpin) && user.a_intent == I_HURT)
		if(bash_cooldown < world.time)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			bash_cooldown = world.time + 25
		return TRUE
	else if (user.a_intent != I_HURT && !istype(W, /obj/item/projectile) && !istype(W, /obj/item/clothing))
		if (calc_carry() + storage_cost_for_item(W) > max_carry)
			to_chat(user, SPAN_WARNING("\The [src] can't fit \the [W]!"))
		else if (!can_add_item(W))
			to_chat(user, SPAN_WARNING("\The [src] can't hold \the [W]!"))
		else
			to_chat(user, SPAN_NOTICE("You add \the [W] to \the [src]."))
			user.drop_item()
			pickup_item(W)
		return TRUE
	else
		. = ..()


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


// Intercepts hits against atoms in order to pick up items or dump stuff out as required.
/obj/item/tray/resolve_attackby(atom/A, mob/user)
	var/grab_intent = ishuman(user) ? I_GRAB : I_HELP
	if (user.a_intent != grab_intent || istype(A, /obj/item/storage) || istype(A, /obj/screen/storage))
		return ..()
	
	var/turf/T = get_turf(A)

	if (LAZYLEN(carrying))
		if (istype(A, /obj/structure/table)) // If we're a table, prioritize dumping stuff out
			overlays.Cut()
			for (var/obj/item/carried in carrying)
				carried.dropInto(T)
				LAZYREMOVE(carrying, carried)
			user.visible_message(SPAN_NOTICE("[user] dumps \the [src] onto \the [A]."), SPAN_NOTICE("You empty \the [src] onto \the [A]."))
			return FALSE
		else if (istype(A, /obj/machinery/smartfridge))
			var/obj/machinery/smartfridge/fridge = A
			var/fed_in = 0
			overlays.Cut()
			for (var/obj/item/carried in carrying)
				if (fridge.accept_check(carried))
					carried.dropInto(fridge)
					fridge.stock_item(carried)
					LAZYREMOVE(carrying, carried)
					fed_in++
				else
					add_item_overlay(carried) // Re-add overlays for items we're keeping on the tray, since we fully cut overlays earlier
			if (!fed_in)
				to_chat(user, SPAN_WARNING("Nothing in \the [src] is valid for \the [A]!"))
			else if (LAZYLEN(carrying))
				user.visible_message(SPAN_NOTICE("[user] fills \the [A] with \the [src]."), SPAN_NOTICE("You fill \the [A] with some of \the [src]'s contents."))
			else
				user.visible_message(SPAN_NOTICE("[user] fills \the [A] with \the [src]."), SPAN_NOTICE("You fill \the [A] with \the [src]."))

			return FALSE

	var/obj/item/I = locate() in T

	if (!isnull(I))
		var/added_items = 0
		for(var/obj/item/item in T)
			if (can_add_item(I))
				pickup_item(item)
				added_items++
	
		if (!added_items)
			to_chat(user, SPAN_WARNING("You fail to pick anything up with \the [src]."))
		else
			user.visible_message(SPAN_NOTICE("[user] scoops up some things with \the [src]."), SPAN_NOTICE("You put everything you could onto \the [src]."))
		
		return FALSE


// Adds a visible overlay on the tray with the item's icon, state, and overlays, to display them on the tray itself
/obj/item/tray/proc/add_item_overlay(obj/item/I)
	if (isnull(I) || !istype(I))
		return
	var/image/item_image = image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer, "pixel_x" = rand(-3, 3), "pixel_y" = rand(-3, 3)) // this line terrifies me
	item_image.color = I.color
	item_image.overlays = I.overlays // Inherit the color and overlays of stored items to make sure they render accurately on the tray
	overlays += item_image
