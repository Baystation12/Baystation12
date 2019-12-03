/obj/item/weapon/watch
	name           = "fob watch"
	desc           = "A fob watch for those who prefer their wrist unencumbered."
	icon           = 'icons/obj/clothing/obj_watches.dmi'
	icon_state     = "face"
	w_class        = ITEM_SIZE_TINY
	attack_verb    = list("clocked")
	var/digital    = FALSE
	var/hour24     = FALSE
	var/inaccuracy = 5 MINUTES

/obj/item/weapon/watch/Initialize()
	. = ..()
	set_extension(src, /datum/extension/clock, digital, hour24, inaccuracy)

/obj/item/weapon/watch/examine(mob/user)
	. = ..()
	var/datum/extension/clock/C = get_extension(src, /datum/extension/clock)
	C.check(user)

/obj/item/weapon/watch/verb/Check_Watch(mob/user)
	set src in usr
	var/datum/extension/clock/C = get_extension(src, /datum/extension/clock)
	C.check_verb(user)

/obj/item/weapon/watch/verb/Calibrate_Watch(mob/user)
	set src in usr
	var/datum/extension/clock/C = get_extension(src, /datum/extension/clock)
	C.calibrate_verb(user)

/obj/item/weapon/watch/digital
	name       = "digital fob watch"
	desc       = "A digital watch on a fob for those who don't like to put on the strap."
	icon_state = "face-digital"
	digital    = TRUE
	inaccuracy = 3 MINUTES

/obj/item/weapon/watch/spaceman
	name       = "Spaceman fob watch"
	desc       = "A 24-hour automatic watch in an alloy case. The phosphorescent dial and hands \
		keep time even when pulling G's. Preferred by many infantry and many more posers. This one \
		is on a fob for those whose high-speed wrists simply cannot be encumbered."
	icon_state = "face-spaceman"
	hour24     = TRUE
	inaccuracy = 2 MINUTES

/obj/item/weapon/watch/fancy
	name       = "pocketwatch"
	desc       = "A fancy pocketwatch to spare those delicate rich wrists."
	inaccuracy = 1 MINUTES