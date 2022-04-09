/obj/item/organ/internal/augment/active/polytool
	name = "Polytool embedded module"
	action_button_name = "Deploy Tool"
	icon_state = "multitool"
	augment_slots = AUGMENT_HAND
	var/list/items = list()
	var/list/paths = list() //We may lose them
	augment_flags = AUGMENT_MECHANICAL


/obj/item/organ/internal/augment/active/polytool/Initialize()
	. = ..()
	for (var/path in paths)
		var/obj/item/I = new path (src)
		I.canremove = FALSE
		items += I


/obj/item/organ/internal/augment/active/polytool/Destroy()
	QDEL_NULL_LIST(items)
	. = ..()


/obj/item/organ/internal/augment/active/polytool/proc/holding_dropped(obj/item/I)
	GLOB.item_unequipped_event.unregister(I, src)
	if (I.loc != src)
		I.canremove = TRUE


/obj/item/organ/internal/augment/active/polytool/activate()
	if (!can_activate())
		return
	var/slot = null
	if (limb.organ_tag in list(BP_L_ARM, BP_L_HAND))
		slot = slot_l_hand
	else if (limb.organ_tag in list(BP_R_ARM, BP_R_HAND))
		slot = slot_r_hand
	var/obj/I = slot == slot_l_hand ? owner.l_hand : owner.r_hand
	if (I)
		if (is_type_in_list(I,paths) && !(I.type in items)) //We don't want several of same but you can replace parts whenever
			if (!owner.drop_from_inventory(I, src))
				to_chat(owner, "\the [I] fails to retract.")
				return
			items += I
			owner.visible_message(
				SPAN_WARNING("[owner] retracts \his [I] into [limb]."),
				SPAN_NOTICE("You retract your [I] into [limb].")
			)
		else
			to_chat(owner, SPAN_WARNING("You must drop [I] before tool can be extend."))
	else
		var/obj/item = input(owner, "Select item for deploy") as null|anything in src
		if (!item || !(src in owner.internal_organs))
			return
		if (owner.equip_to_slot_if_possible(item, slot))
			items -= item
			//Keep track of it, make sure it returns
			GLOB.item_unequipped_event.register(item, src, /obj/item/organ/internal/augment/active/polytool/proc/holding_dropped)
			owner.visible_message(
				SPAN_WARNING("[owner] extends \his [item.name] from [limb]."),
				SPAN_NOTICE("You extend your [item.name] from [limb].")
			)
