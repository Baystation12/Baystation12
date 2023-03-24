//everything below and other files from infinity //PRX
/obj/item/melee/arm_blade
	name = "armblade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon = 'proxima/icons/obj/changeling.dmi'
	icon_state = "arm_blade"
	item_state = "arm_blade"
	item_icons = list(
		slot_l_hand_str = 'proxima/icons/obj/changeling.dmi',
		slot_r_hand_str = 'proxima/icons/obj/changeling.dmi')
	item_state_slots = list(
		slot_l_hand_str = "arm_blade_lh",
		slot_r_hand_str = "arm_blade_rh")
	hitsound = 'proxima/sound/weapons/bloodyslice.ogg'
	w_class = 4
	force = 23
	siemens_coefficient = 0.4
	base_parry_chance = 40
	canremove = 0
	sharp = 1
	edge = 1
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator

/obj/item/melee/arm_blade/dropped(var/mob/living/user)
	visible_message(SPAN_DANGER("With a sickening crunch, [user] reforms their armblade into an arm!"),
	SPAN_WARNING("You hear organic matter ripping and tearing!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/melee/arm_blade/Process()
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

/obj/item/melee/arm_blade/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/D = target

		if(D.allowed(user) || !D.requiresID())
			return

		else if(D.locked)
			to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from being forced."))
			return

	else if(istype(target, /obj/structure/table))
		var/obj/structure/table/T = target
		T.break_to_parts()
