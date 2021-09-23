/**
* Toggleable physical equipment augment
* Specify a path on item to create on Initialize
* Specify a slot or leave null to discover on install
*/
/obj/item/organ/internal/augment/active/item
	var/deploy_sound = 'sound/items/helmet_close.ogg'
	var/retract_sound = 'sound/items/helmet_open.ogg'
	var/obj/item/item
	var/slot


/obj/item/organ/internal/augment/active/item/Initialize()
	. = ..()
	if (ispath(item))
		item = new item (src)
		item.canremove = FALSE


/obj/item/organ/internal/augment/active/item/onInstall()
	. = ..()
	if (!slot)
		switch (parent_organ)
			if (BP_L_ARM, BP_L_HAND)
				slot = slot_l_hand
			if (BP_R_ARM, BP_R_HAND)
				slot = slot_r_hand
			if (BP_HEAD)
				slot = slot_glasses
			if (BP_CHEST)
				slot = slot_wear_suit
			if (BP_GROIN)
				slot = slot_belt


/obj/item/organ/internal/augment/active/item/onRemove()
	retract(FALSE)
	slot = initial(slot)
	..()


/obj/item/organ/internal/augment/active/item/Destroy()
	if (item)
		GLOB.item_unequipped_event.unregister(item, src)
		if (item.loc == src)
			qdel(item)
		else
			item.canremove = TRUE
		item = null
	return ..()


/obj/item/organ/internal/augment/active/item/proc/item_dropped()
	GLOB.item_unequipped_event.unregister(item, src)
	if (item.loc != src) // It fell off!
		item.canremove = TRUE
		item = null


/obj/item/organ/internal/augment/active/item/proc/deploy(as_owner = TRUE)
	if (!slot)
		return
	if (!item)
		return
	if (!owner.equip_to_slot_if_possible(item, slot))
		return
	GLOB.item_unequipped_event.register(item, src, /obj/item/organ/internal/augment/active/item/proc/item_dropped)
	if (deploy_sound)
		playsound(owner, deploy_sound, 30)
	if (as_owner)
		owner.visible_message(
			SPAN_WARNING("\The [owner] extends \his [item.name] from \his [limb.name]."),
			SPAN_NOTICE("You extend your [item.name] from your [limb.name].")
		)
	else
		visible_message(SPAN_WARNING("\The [item.name] extend\s."))
	return TRUE


/obj/item/organ/internal/augment/active/item/proc/retract(as_owner = TRUE)
	if (!item)
		return
	if (item.loc == src)
		return
	if (item.loc != owner)
		return
	var/mob/M = item.loc
	if (!M.drop_from_inventory(item, src))
		to_chat(owner, "\The [item.name] fails to retract.")
		return
	if (retract_sound)
		playsound(owner, retract_sound, 30)
	if (as_owner)
		M.visible_message(
			SPAN_WARNING("\The [M] retracts \his [item.name] into \his [limb.name]."),
			SPAN_NOTICE("You retract your [item.name] into your [limb.name].")
		)
	else
		visible_message(SPAN_WARNING("\The [item.name] retract\s."))
	return TRUE


/obj/item/organ/internal/augment/active/item/activate()
	if (!can_activate())
		return
	if (item.loc == src)
		deploy()
	else
		retract()
	owner.update_action_buttons()


/obj/item/organ/internal/augment/active/item/can_activate()
	if (!..())
		return FALSE
	if (!item)
		to_chat(owner, SPAN_WARNING("The device is damaged and fails to deploy."))
		return FALSE
	return TRUE
