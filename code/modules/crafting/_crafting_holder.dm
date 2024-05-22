/obj/item/crafting_holder
	/// Path. The current crafting stage this holder is at.
	var/singleton/crafting_stage/current_crafting_stage
	/// String. Label name set by a user using a pen.
	var/label_name

/obj/item/crafting_holder/Initialize(ml, singleton/crafting_stage/initial_stage, obj/item/target, obj/item/tool, mob/user)
	. = ..()
	name = "[target.name] assembly"

	// Handle various holders
	// Mob - Drop from inventory and put the crafting holder in place.
	if(ismob(target.loc))
		var/mob/M = target.loc
		M.drop_from_inventory(target, src)
		M.put_in_hands(src)
	// Storage - Remove from storage and insert the crafting holder, if possible.
	else if (istype(target.loc, /obj/item/storage))
		var/obj/item/storage/storage = target.loc
		storage.remove_from_storage(target, src)
		if (storage.can_be_inserted(src))
			storage.handle_item_insertion(src, TRUE)
	// If none of the above moved the target, move it now.
	if (target.loc != src)
		target.forceMove(src)

	current_crafting_stage = initial_stage
	update_icon()
	update_strings()

/obj/item/crafting_holder/Destroy()
	for(var/thing in contents)
		qdel(thing)
	. = ..()

/obj/item/crafting_holder/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/pen))
		var/new_label = sanitizeSafe(input(user, "What do you wish to label this assembly?", "Assembly Labelling", label_name), MAX_NAME_LEN)
		if(new_label && !user.incapacitated() && W.loc == user && user.Adjacent(src) && !QDELETED(src))
			to_chat(user, SPAN_NOTICE("You label \the [src] with '[new_label]'."))
			label_name = new_label
		return TRUE

	if(current_crafting_stage)
		var/singleton/crafting_stage/next_stage = current_crafting_stage.get_next_stage(W)
		if(next_stage && next_stage.progress_to(W, user, src))
			advance_to(next_stage, user, W)
			return TRUE

	return ..()


/**
 * Handles advancing to the next crafting stage. Does not perform any checks to ensure the advancement is valid or
 * normally possible.
 *
 * **Parameters**:
 * - `next_stage` - The crafting stage to advance to.
 * - `user` - The mov performing the interaction.
 * - `tool` - The item being used to advance the stage.
 *
 * Has no return value.
 */
/obj/item/crafting_holder/proc/advance_to(singleton/crafting_stage/next_stage, mob/user, obj/item/tool)
	var/obj/item/product = next_stage && next_stage.get_product(src)
	if(product)
		if(ismob(product) && label_name)
			var/mob/M = product
			M.SetName(label_name)

		// Handle various holders
		// Mob - Drop from inventory and put the product in place
		if (ismob(loc))
			var/mob/M = loc
			M.drop_from_inventory(src)
			if(isitem(product))
				M.put_in_hands(product)
		// Storage - Remove from storage and insert the product, if possible
		else if (istype(loc, /obj/item/storage))
			var/obj/item/storage/storage = loc
			storage.remove_from_storage(src)
			if (storage.can_be_inserted(product))
				storage.handle_item_insertion(product)
		qdel_self()
	else
		current_crafting_stage = next_stage
		update_icon()
		update_strings()

/obj/item/crafting_holder/on_update_icon()
	icon = current_crafting_stage.item_icon
	icon_state = current_crafting_stage.item_icon_state


/**
 * Handles updating the holder's description from the crafting stage.
 *
 * Has no parameters or return value.
 */
/obj/item/crafting_holder/proc/update_strings()
	if(current_crafting_stage.item_desc)
		desc = current_crafting_stage.item_desc
