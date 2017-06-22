/datum/uplink_item/deity
	antag_roles = list()
	var/list/required_feats //is a list of the feat names
	var/path

/datum/uplink_item/deity/can_view(obj/item/device/uplink/U)
	if(!..() || !U || !U.uplink_owner || !istype(U.uplink_owner.current, /mob/living/deity))
		return 0
	var/mob/living/deity/D = U.uplink_owner.current
	if(required_feats)
		for(var/feat in required_feats)
			if(!(feat in D.feats) || (required_feats[feat] && required_feats[feat] > D.feats[feat]))
				return 0
	return 1

/datum/uplink_item/deity/get_goods(var/obj/item/device/uplink/U, var/loc)
	if(!path) //Prolly a feat or activator.
		return 1
	return new path(null)

/datum/uplink_item/deity/boon/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.set_boon(.)

/datum/uplink_item/deity/feat/can_view(obj/item/device/uplink/U)
	if(!..())
		return 0

	var/mob/living/deity/D = U.uplink_owner.current
	if(src.name in D.feats)
		return 0
	return 1

/datum/uplink_item/deity/feat/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.feats |= src.name

/datum/uplink_item/deity/feat/phenomena/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.add_phenomena(path)

/datum/uplink_item/deity/leveled
	var/max_level = 0

/datum/uplink_item/deity/leveled/proc/get_level(var/mob/living/deity/user)
	if(user.feats[src.name])
		return user.feats[src.name]
	return 0

/datum/uplink_item/deity/leveled/can_view(obj/item/device/uplink/U)
	if(!..())
		return 0
	return get_level(U.uplink_owner.current) < max_level

/datum/uplink_item/deity/leveled/description()
	return "<b>This feat can be leveled [max_level] times.</b> [..()]"

/datum/uplink_item/deity/leveled/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		if(!user.feats[src.name])
			user.feats[src.name] = 1
		else
			user.feats[src.name]++