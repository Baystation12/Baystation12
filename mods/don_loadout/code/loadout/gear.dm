/datum/gear
	/// Donation tier restriction
	var/donation_tier

/datum/gear/proc/is_allowed_to_equip(mob/user)
	ASSERT(user && user.client)
	ASSERT(user.client.donator_info)
	if(donation_tier && !user.client.donator_info.donation_tier_available(donation_tier))
		return FALSE

	return TRUE

/datum/gear/proc/spawn_as_accessory_on_mob(mob/living/carbon/human/H, metadata)
	var/obj/item/item = spawn_item(H, H, metadata)

	if(H.equip_to_slot_or_del(item, slot_tie))
		return TRUE

	return FALSE
