/datum/uplink_item/item/deity
	antag_roles = list()
	var/list/required_feats //is a list of TYPES

/datum/uplink_item/item/deity/can_view(obj/item/device/uplink/U)
	if(!..() || !U || !U.uplink_owner || !istype(U.uplink_owner.current, /mob/living/deity))
		return 0
	var/mob/living/deity/D = U.uplink_owner.current
	if(required_feats)
		for(var/feat in required_feats)
			if(!(feat in D.feats))
				return 0
	return 1

/datum/uplink_item/item/deity/boon/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.set_boon(.)

/datum/uplink_item/item/deity/feat/can_view(obj/item/device/uplink/U)
	if(!..())
		return 0

	var/mob/living/deity/D = U.uplink_owner.current
	if(src.name in D.feats)
		return 0
	return 1

/datum/uplink_item/item/deity/feat/get_goods()
	return 1

/datum/uplink_item/item/deity/feat/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.feats |= src.name