//Simple toggleabse module. Just put holding in hands or get it back
/obj/item/organ/internal/augment/active/simple
	var/obj/item/holding = null
	var/holding_type = null
	var/deploy_sound
	var/retract_sound

/obj/item/organ/internal/augment/active/simple/Initialize()
	. = ..()
	if(holding_type)
		holding = new holding_type(src)
		holding.canremove = 0

/obj/item/organ/internal/augment/active/simple/Destroy()
	if(holding)
		GLOB.item_unequipped_event.unregister(holding, src)
		if(holding.loc == src)
			qdel(holding)
		holding = null
	return ..()

/obj/item/organ/internal/augment/active/simple/proc/holding_dropped()

	//Stop caring
	GLOB.item_unequipped_event.unregister(holding, src)

	if(holding.loc != src) //something went wrong and is no longer attached/ it broke
		holding.canremove = 1
		holding = null     //We no longer hold this, you will have to get a replacement module or fix it somehow

/obj/item/organ/internal/augment/active/simple/proc/deploy()

	var/slot = null
	if(limb.organ_tag in list(BP_L_ARM, BP_L_HAND))
		slot = slot_l_hand
	else if(limb.organ_tag in list(BP_R_ARM, BP_R_HAND))
		slot = slot_r_hand
	if(owner.equip_to_slot_if_possible(holding, slot))
		GLOB.item_unequipped_event.register(holding, src, /obj/item/organ/internal/augment/active/simple/proc/holding_dropped )
		owner.visible_message(
			SPAN_WARNING("\The [owner] extends \his [holding.name] from \his [limb.name]."),
			SPAN_NOTICE("You extend your [holding.name] from your [limb.name].")
		)
		if (deploy_sound)
			playsound(owner, deploy_sound, 30)
		return TRUE

/obj/item/organ/internal/augment/active/simple/proc/retract()
	if(holding.loc == src)
		return

	if(ismob(holding.loc) && holding.loc == owner)
		var/mob/M = holding.loc
		if(!M.drop_from_inventory(holding, src))
			to_chat(owner, "\The [holding.name] fails to retract.")
			return
		M.visible_message(
			SPAN_WARNING("\The [M] retracts \his [holding.name] into \his [limb.name]."),
			SPAN_NOTICE("You retract your [holding.name] into your [limb.name].")
		)
		if (retract_sound)
			playsound(owner, retract_sound, 30)
		return TRUE



/obj/item/organ/internal/augment/active/simple/activate()
	if(!can_activate())
		return

	if(holding.loc == src) //item not in hands
		deploy()
	else //retract item
		retract()
	owner.update_action_buttons()

/obj/item/organ/internal/augment/active/simple/can_activate()
	if(..())
		if(!holding)
			to_chat(owner, SPAN_WARNING("The device is damaged and fails to deploy"))
			return FALSE
		return TRUE
	return FALSE
