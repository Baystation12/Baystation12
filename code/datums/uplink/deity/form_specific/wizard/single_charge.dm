/datum/uplink_item/item/deity/boon/single_charge/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(istype(., /spell))
		var/spell/S = .
		if(S.spell_flags & NEEDSCLOTHES)
			S.spell_flags &= ~NEEDSCLOTHES

		S.charge_max = 1
		S.charge_counter = 1
		S.charge_type = Sp_CHARGES

/datum/uplink_item/item/deity/boon/single_charge/description()
	return "[..()] <b>This ability is single charge only.</b>"