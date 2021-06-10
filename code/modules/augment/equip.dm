/// Subtype of equipment modules that attempts to equip its item to a specified clothing slot.
/obj/item/organ/internal/augment/active/simple/equip
	var/equip_slot
	deploy_sound = 'sound/items/helmet_close.ogg'
	retract_sound = 'sound/items/helmet_open.ogg'

/obj/item/organ/internal/augment/active/simple/equip/deploy()
	if(owner.equip_to_slot_if_possible(holding, equip_slot))
		GLOB.item_unequipped_event.register(holding, src, /obj/item/organ/internal/augment/active/simple/proc/holding_dropped )
		owner.visible_message(
			SPAN_WARNING("\The [owner] extends \his [holding.name] from \his [limb.name]."),
			SPAN_NOTICE("You extend your [holding.name] from your [limb.name].")
		)
		if (deploy_sound)
			playsound(owner, deploy_sound, 30)
		return TRUE
	else
		to_chat(owner, SPAN_WARNING("Your [holding.name] fails to deploy."))
