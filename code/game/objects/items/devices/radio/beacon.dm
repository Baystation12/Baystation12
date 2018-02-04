/obj/item/device/radio/beacon
	name = "tracking beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaler"
	var/code = "electronic"
	origin_tech = list(TECH_BLUESPACE = 1)

/obj/item/device/radio/beacon/hear_talk()
	return

/obj/item/device/radio/beacon/send_hear()
	return null

/obj/item/device/radio/beacon/verb/alter_signal(newcode as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	if (!user.incapacitated())
		code = newcode
		add_fingerprint(user)


/obj/item/device/radio/beacon/anchored
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_magnet"
	anchored = TRUE
	randpixel = 0

/obj/item/device/radio/beacon/anchored/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	hide(hides_under_flooring() && !T.is_plating())