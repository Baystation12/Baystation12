//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/in_hand = get_active_hand()
	var/obj/item/in_slot = get_equipped_item(slot)
	if (istype(in_slot))
		if (istype(in_hand))
			in_slot.attackby(in_hand, src)
		else
			in_slot.attack_hand(src)
	else
		equip_to_slot_if_possible(in_hand, slot)


/// UNSAFELY place I into this mob's inventory at slot if existentially possible. Generally, use the _if_possible version.
/mob/proc/equip_to_slot(obj/item/I, slot)
	return


/// Attempt to place I into this mob's inventory at slot. See TRYEQUIP_* flags for behavior modifiers.
/mob/proc/equip_to_slot_if_possible(obj/item/I, slot, equip_flags = TRYEQUIP_REDRAW)
	if (!slot)
		return
	if (!istype(I))
		return
	if (!I.mob_can_equip(src, slot, equip_flags & TRYEQUIP_SILENT, equip_flags & TRYEQUIP_FORCE))
		if (!(equip_flags & TRYEQUIP_SILENT))
			to_chat(src, SPAN_WARNING("You are unable to equip \the [I]."))
		if (equip_flags & TRYEQUIP_DESTROY)
			qdel(I)
		return
	if (!canUnEquip(I))
		return
	if (I.equip_delay > 0 && !(equip_flags & TRYEQUIP_INSTANT))
		I.equip_delay_before(src, slot, equip_flags)
		var/do_flags = I.equip_delay_flags
		if (equip_flags & TRYEQUIP_SILENT)
			do_flags &= ~DO_FAIL_FEEDBACK
		if (!do_after(src, I.equip_delay, I, do_flags))
			return
		I.equip_delay_after(src, slot, equip_flags)
	equip_to_slot(I, slot, equip_flags & TRYEQUIP_REDRAW)
	return TRUE


// Common pattern during roundstart, events, etc
/mob/proc/equip_to_slot_or_del(obj/item/I, slot)
	return equip_to_slot_if_possible(I, slot, TRYEQUIP_DESTROY | TRYEQUIP_SILENT | TRYEQUIP_INSTANT)


/mob/proc/put_in_any_hand_if_possible(obj/item/I, equip_flags = TRYEQUIP_REDRAW | TRYEQUIP_SILENT)
	if (equip_to_slot_if_possible(I, slot_l_hand, equip_flags))
		return TRUE
	if (equip_to_slot_if_possible(I, slot_r_hand, equip_flags))
		return TRUE


/mob/proc/equip_to_slot_or_store_or_drop(obj/item/I, slot)
	if (equip_to_slot_if_possible(I, slot, TRYEQUIP_SILENT))
		return TRUE
	if (equip_to_storage_or_drop(I))
		return TRUE


/// Place I into the first slot it fits in the order of slots_by_priority, returning the slot or falsy.
/mob/proc/equip_to_appropriate_slot(obj/item/I, skip_storage)
	var/static/list/slots_by_priority = list(
		slot_back, slot_wear_id, slot_w_uniform, slot_wear_suit,
		slot_wear_mask, slot_head, slot_shoes, slot_gloves, slot_l_ear,
		slot_r_ear, slot_glasses, slot_belt, slot_s_store, slot_tie,
		slot_l_store, slot_r_store
	)
	if (!istype(I))
		return
	for (var/slot in slots_by_priority)
		if (skip_storage && (slot == slot_s_store || slot == slot_l_store || slot == slot_r_store))
			continue
		if (equip_to_slot_if_possible(I, slot, TRYEQUIP_REDRAW | TRYEQUIP_SILENT))
			return slot //slot is truthy; we can return it for info


//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return 1


/mob/proc/equip_to_storage(obj/item/newitem)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/storage))
		var/obj/item/storage/backpack = src.back
		if(backpack.can_be_inserted(newitem, src, 1))
			newitem.forceMove(src.back)
			return backpack

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/storage/S in src.contents)
		if(S.can_be_inserted(newitem, src, 1))
			newitem.forceMove(S)
			return S

/mob/proc/equip_to_storage_or_drop(obj/item/newitem)
	var/stored = equip_to_storage(newitem)
	if(!stored && newitem)
		newitem.dropInto(loc)
	return stored

//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

//Returns the thing in our active hand
/mob/proc/get_active_hand()
	RETURN_TYPE(/obj/item)
	if(hand)	return l_hand
	else		return r_hand

//Returns the thing in our inactive hand
/mob/proc/get_inactive_hand()
	if(hand)	return r_hand
	else		return l_hand

//Puts the item into your l_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_l_hand(var/obj/item/W)
	if(lying || !istype(W))
		return 0
	return 1

//Puts the item into your r_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_r_hand(var/obj/item/W)
	if(lying || !istype(W))
		return 0
	return 1

//Puts the item into our active hand if possible. returns 1 on success.
/mob/proc/put_in_active_hand(var/obj/item/W)
	return 0 // Moved to human procs because only they need to use hands.

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/proc/put_in_inactive_hand(var/obj/item/W)
	return 0 // As above.

//Puts the item our active hand if possible. Failing that it tries our inactive hand. Returns 1 on success.
//If both fail it drops it on the floor and returns 0.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(var/obj/item/W)
	if(!W)
		return 0
	drop_from_inventory(W)
	return 0

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.
/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	if(W)
		remove_from_mob(W, target)
		if(!(W && W.loc)) return 1 // self destroying objects (tk, grabs)
		update_icons()
		return 1
	return 0

//Drops the item in our left hand
/mob/proc/drop_l_hand(atom/Target, force)
	if(force)
		return drop_from_inventory(l_hand, Target)
	return unEquip(l_hand, Target)

//Drops the item in our right hand
/mob/proc/drop_r_hand(atom/Target, force)
	if(force)
		return drop_from_inventory(r_hand, Target)
	return unEquip(r_hand, Target)

/**
 * Drops the item in our active hand. TODO: rename this to drop_active_hand or something
 * Make sure you are ABSOLUTELY CERTAIN you need to drop this and ignore unequip checks (For example, grabs can be "dropped" but only willingly)
 * Else use unequip_item
 */
/mob/proc/drop_item(atom/Target)
	if(hand)	return drop_l_hand(Target, TRUE)
	else		return drop_r_hand(Target, TRUE)

/*
	Removes the object from any slots the mob might have, calling the appropriate icon update proc.
	Does nothing else.

	*** DO NOT CALL THIS PROC DIRECTLY ***

	It is meant to be called only by other inventory procs.
	It's probably okay to use it if you are transferring the item between slots on the same mob,
	but chances are you're safer calling remove_from_mob() or drop_from_inventory() anyways.

	As far as I can tell the proc exists so that mobs with different inventory slots can override
	the search through all the slots, without having to duplicate the rest of the item dropping.
*/
/mob/proc/u_equip(obj/W as obj)
	if (W == r_hand)
		r_hand = null
		update_inv_r_hand(0)
	else if (W == l_hand)
		l_hand = null
		update_inv_l_hand(0)
	else if (W == back)
		back = null
		update_inv_back(0)
	else if (W == wear_mask)
		wear_mask = null
		update_inv_wear_mask(0)
	return

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return 0
	return get_inventory_slot(I) != 0

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return 1
	var/slot = get_inventory_slot(I)
	if(!slot && !istype(I.loc, /obj/item/rig_module))
		return 1 //already unequipped, so success
	return I.mob_can_unequip(src, slot)

/mob/proc/get_inventory_slot(obj/item/I)
	var/slot = 0
	for(var/s in slot_first to slot_last) //kind of worries me
		if(get_equipped_item(s) == I)
			slot = s
			break
	return slot

//This differs from remove_from_mob() in that it checks if the item can be unequipped first. Use drop_from_inventory if you don't want to check.
/mob/proc/unEquip(obj/item/I, var/atom/target)
	if(!canUnEquip(I))
		return
	drop_from_inventory(I, target)
	return 1

/mob/proc/unequip_item(atom/target)
	if(!canUnEquip(get_active_hand()))
		return
	drop_item(target)
	return 1

//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(var/obj/O, var/atom/target)
	if(!O) // Nothing to remove, so we succeed.
		return 1
	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
	O.reset_plane_and_layer()
	O.screen_loc = null
	if(istype(O, /obj/item))
		var/obj/item/I = O
		if(target)
			I.forceMove(target)
		else
			I.dropInto(loc)
		I.dropped(src)
	return 1


//Returns the item equipped to the specified slot, if any.
/mob/proc/get_equipped_item(var/slot)
	switch(slot)
		if(slot_l_hand) return l_hand
		if(slot_r_hand) return r_hand
		if(slot_back) return back
		if(slot_wear_mask) return wear_mask
	return null

/mob/proc/get_equipped_items(var/include_carried = 0)
	. = list()
	if(back)      . += back
	if(wear_mask) . += wear_mask

	if(include_carried)
		if(l_hand) . += l_hand
		if(r_hand) . += r_hand

/mob/proc/delete_inventory(var/include_carried = FALSE)
	for(var/entry in get_equipped_items(include_carried))
		drop_from_inventory(entry)
		qdel(entry)

// Returns all currently covered body parts
/mob/proc/get_covered_body_parts()
	. = 0
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		. |= I.body_parts_covered

// Returns the first item which covers any given body part
/mob/proc/get_covering_equipped_item(var/body_parts)
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		if(I.body_parts_covered & body_parts)
			return I

// Returns all items which covers any given body part
/mob/proc/get_covering_equipped_items(var/body_parts)
	. = list()
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		if(I.body_parts_covered & body_parts)
			. += I
