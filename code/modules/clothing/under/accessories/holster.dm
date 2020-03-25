/obj/item/clothing/accessory/storage/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	slot = ACCESSORY_SLOT_HOLSTER
	slots = 1
	max_w_class = ITEM_SIZE_NORMAL
	var/list/can_holster = null
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'

/obj/item/clothing/accessory/storage/holster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/holster, hold, sound_in, sound_out, can_holster)

/obj/item/clothing/accessory/storage/holster/attackby(obj/item/W as obj, mob/user as mob)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.holster(W, user))
		return
	else
		. = ..(W, user)

/obj/item/clothing/accessory/storage/holster/attack_hand(mob/user as mob)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.unholster(user))
		return
	else
		. = ..(user)

/obj/item/clothing/accessory/storage/holster/examine(mob/user)
	. = ..(user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	H.examine_holster(user)

/obj/item/clothing/accessory/storage/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /atom/proc/holster_verb

/obj/item/clothing/accessory/storage/holster/on_removed(mob/user as mob)
	if(has_suit)
		var/remove_verb = TRUE
		if(has_extension(has_suit, /datum/extension/holster))
			remove_verb = FALSE

		for(var/obj/accessory in has_suit.accessories)
			if(accessory == src)
				continue
			if(has_extension(accessory, /datum/extension/holster))
				remove_verb = FALSE

		if(remove_verb)
			has_suit.verbs -= /atom/proc/holster_verb
	..()

/obj/item/clothing/accessory/storage/holster/armpit
	name = "armpit holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry."
	icon_state = "holster"

/obj/item/clothing/accessory/storage/holster/waist
	name = "waist holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	overlay_state = "holster_low"

/obj/item/clothing/accessory/storage/holster/hip
	name = "hip holster"
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon_state = "holster_hip"

/obj/item/clothing/accessory/storage/holster/thigh
	name = "thigh holster"
	desc = "A drop leg holster made of a durable synthetic fiber."
	icon_state = "holster_thigh"
	sound_in = 'sound/effects/holster/tactiholsterin.ogg'
	sound_out = 'sound/effects/holster/tactiholsterout.ogg'

/obj/item/clothing/accessory/storage/holster/machete
	name = "machete sheath"
	desc = "A handsome synthetic leather sheath with matching belt."
	icon_state = "holster_machete"
	can_holster = list(/obj/item/weapon/material/hatchet/machete)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/clothing/accessory/storage/holster/knife
	name = "leather knife sheath"
	desc = "A synthetic leather knife sheath which you can strap on your leg."
	icon_state = "sheath_leather"
	can_holster = list(/obj/item/weapon/material/knife)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/clothing/accessory/storage/holster/knife/polymer
	name = "polymer knife sheath"
	desc = "A rigid polymer sheath which you can strap on your leg."
	icon_state = "sheath_polymer"