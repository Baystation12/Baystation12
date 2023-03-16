/datum/gear
	var/gear_hash     // MD5 hash of display_name. Used to get item in Topic calls. See href problem with ' symbol
	var/donation_tier // Donation tier restriction


/datum/gear/New()
	gear_hash = md5(display_name)
	. = ..()

/datum/gear/proc/is_allowed_to_equip(mob/user)
	ASSERT(user && user.client)
	ASSERT(user.client.donator_info)
	if(donation_tier && !user.client.donator_info.donation_tier_available(donation_tier))
		return FALSE
	if(!is_allowed_to_display(user))
		return FALSE

	return TRUE


// used when we forbid seeing gear in menu without any messages.
/datum/gear/proc/is_allowed_to_display(mob/user)
	return TRUE

/datum/gear/spawn_on_mob(mob/living/carbon/human/H, metadata)
	var/obj/item/item = spawn_item(H, H, metadata)

	return H.equip_to_slot_if_possible(item, slot, TRYEQUIP_REDRAW | TRYEQUIP_DESTROY | TRYEQUIP_FORCE)

/datum/gear/proc/spawn_as_accessory_on_mob(mob/living/carbon/human/H, metadata)
	var/obj/item/item = spawn_item(H, H, metadata)

	if(H.equip_to_slot_or_del(item, slot_tie))
		return TRUE

	return FALSE

/datum/gear/spawn_in_storage_or_drop(mob/living/carbon/human/subject, metadata)
	var/obj/item/item = spawn_item(subject, subject, metadata)
	item.add_fingerprint(subject)
	if (istype(item, /obj/item/organ/internal/augment))
		var/obj/item/organ/internal/augment/augment = item
		var/obj/item/organ/external/parent = augment.get_valid_parent_organ(subject)
		if (!parent)
			to_chat(subject, SPAN_WARNING("Failed to find a valid organ to install \the [augment] into!"))
			qdel(augment)
			return
		var/surgery_step = GET_SINGLETON(/singleton/surgery_step/internal/replace_organ)
		if (augment.surgery_configure(subject, subject, parent, null, surgery_step))
			to_chat(subject, SPAN_WARNING("Failed to set up \the [augment] for installation in your [parent.name]!"))
			qdel(augment)
			return
		augment.forceMove(subject)
		augment.replaced(subject, parent)
		augment.onRoundstart()
		return
	var/atom/container = subject.equip_to_storage(item)
	if (container)
		to_chat(subject, SPAN_NOTICE("Placing \the [item] in your [container.name]!"))
	else if (subject.equip_to_appropriate_slot(item))
		to_chat(subject, SPAN_NOTICE("Placing \the [item] in your inventory!"))
	else if (subject.put_in_hands(item))
		to_chat(subject, SPAN_NOTICE("Placing \the [item] in your hands!"))
	else
		to_chat(subject, SPAN_WARNING("Dropping \the [item] on the ground!"))
		item.forceMove(get_turf(subject))
		item.add_fingerprint(subject)
