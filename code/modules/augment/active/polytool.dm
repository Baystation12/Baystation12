/obj/item/organ/internal/augment/active/polytool
	name = "Polytool embedded module"
	action_button_name = "Deploy tool"
	icon_state = "multitool"
	allowed_organs = list(BP_R_ARM, BP_L_ARM)
	var/list/items = list()
	var/list/paths = list() //We may lose them
	augment_flags = AUGMENTATION_MECHANIC

/obj/item/organ/internal/augment/active/polytool/New()
	..()
	for(var/path in paths)
		var/obj/item/I = new path (src)
		I.canremove = FALSE
		items += I
/obj/item/organ/internal/augment/active/polytool/Destroy()
	QDEL_NULL_LIST(items)

/obj/item/organ/internal/augment/active/polytool/proc/holding_dropped(var/obj/item/I)

	//Stop caring
	GLOB.item_unequipped_event.unregister(I, src)

	if(I.loc != src) //something went wrong and is no longer attached/ it broke
		I.canremove = 1

/obj/item/organ/internal/augment/active/polytool/activate()
	var/target_hand = parent_organ == BP_L_ARM ? slot_l_hand : slot_r_hand
	var/obj/I = owner.get_active_hand()
	var/mob/living/carbon/human/H = owner
	if(I)
		if(is_type_in_list(I,paths) && !(I.type in items)) //We don't want several of same but you can replace parts whenever
			H.drop_from_inventory(I, src)
			items += I
			H.visible_message(
				SPAN_WARNING("[H] retracts \his [I] into [limb]."),
				SPAN_NOTICE("You retract your [I] into [limb].")
			)
		else
			to_chat(H, SPAN_WARNING("You must drop [I] before tool can be extend."))
	else
		var/obj/item = input(H, "Select item for deploy") as null|anything in src
		if(!item || !src.loc in H.organs || H.incapacitated())
			return
		if(H.equip_to_slot_if_possible(item, target_hand))
			items -= item
			//Keep track of it, make sure it returns
			GLOB.item_unequipped_event.register(item, src, /obj/item/organ/internal/augment/active/simple/proc/holding_dropped )
			H.visible_message(
				SPAN_WARNING("[H] extend \his [item] from [limb]."),
				SPAN_NOTICE("You extend your [item] from [limb].")
			)