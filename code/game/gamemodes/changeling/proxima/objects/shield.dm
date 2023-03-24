
/obj/item/shield/riot/changeling
	name = "shield-like mass"
	desc = "A mass of tough, boney tissue. You can still see the fingers as a twisted pattern in the shield."
	icon = 'proxima/icons/obj/changeling.dmi'
	icon_state = "ling_shield"
	item_state = "ling_shield"
	item_icons = list(
		slot_l_hand_str = 'proxima/icons/obj/changeling.dmi',
		slot_r_hand_str = 'proxima/icons/obj/changeling.dmi')
	item_state_slots = list(
		slot_l_hand_str = "ling_shield_lh",
		slot_r_hand_str = "ling_shield_rh")
	slot_flags = null
	siemens_coefficient = 0.1
	canremove = 0
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	max_block = 15
	can_block_lasers = TRUE
	var/mob/living/creator

/obj/item/shield/riot/changeling/dropped(var/mob/living/user)
	visible_message(SPAN_DANGER("With a sickening crunch, [user] reforms their shield into an arm!"),
	SPAN_WARNING("You hear organic matter ripping and tearing!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/shield/riot/changeling/Process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/obj/item/bone_dart
	name = "bone dart"
	desc = "A sharp piece of bone shapped as small dart."
	icon = 'proxima/icons/obj/changeling.dmi'
	icon_state = "bone_dart"
	item_state = "bolt"
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 2
