/datum/power/changeling/arm_blade
	name = "Arm Blade"
	desc = "We reform one of our arms into a deadly blade."
	helptext = "We may retract our armblade by dropping it. Cannot be used while in lesser form."
	enhancedtext = "The blade will have armor peneratration."
	genomecost = 2
	verbpath = /mob/proc/changeling_arm_blade

//Grows a scary, and powerful arm blade.
/mob/proc/changeling_arm_blade()
	set category = "Changeling"
	set name = "Arm Blade (20)"

	if(src.mind.changeling.recursive_enhancement)
		if(changeling_generic_weapon(/obj/item/weapon/melee/arm_blade/greater))
			src << "<span class='notice'>We prepare an extra sharp blade.</span>"
			src.mind.changeling.recursive_enhancement = 0
			return 1

	else
		if(changeling_generic_weapon(/obj/item/weapon/melee/arm_blade))
			return 1
		return 0

/obj/item/weapon/melee/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon = 'icons/mob/items/changeling.dmi'
	icon_state = "arm_blade"
	w_class = 5.0
	force = 40
	sharp = 1
	edge = 1
	anchored = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator //This is just like ninja swords, needed to make sure dumb shit that removes the sword doesn't make it stay around.

/obj/item/weapon/melee/arm_blade/greater
	name = "arm greatblade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people and armor as a hot knife through butter."
	armor_penetration = 30

/obj/item/weapon/melee/arm_blade/New(location)
	..()
	//TODO item appearance datum or something
	item_icons[slot_l_hand_str] = 'icons/mob/items/changeling.dmi'
	item_icons[slot_r_hand_str] = 'icons/mob/items/changeling.dmi'
	item_state_slots[slot_l_hand_str] = "arm_blade_l_hand"
	item_state_slots[slot_r_hand_str] = "arm_blade_r_hand"
	processing_objects |= src
	if(ismob(loc))
		src.creator = loc
		src.creator.visible_message(
			"<span class='warning'>A grotesque blade forms around [loc.name]\'s arm!</span>",
			"<span class='warning'>Our arm twists and mutates, transforming it into a deadly blade.</span>",
			"<span class='italics'>You hear organic matter ripping and tearing!</span>"
			)

/obj/item/weapon/melee/arm_blade/dropped(mob/user)
	user.visible_message(
		"<span class='warning'>With a sickening crunch, [creator] reforms their arm blade into an arm!</span>",
		"<span class='notice'>We assimilate the weapon back into our body.</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>"
		)
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	spawn(1)
		if(src)
			qdel(src)

/obj/item/weapon/melee/arm_blade/Destroy()
	processing_objects -= src
	creator = null
	. = ..()

//TODO ensure embedded objects call dropped, ensure items unembed themselves when deleted
/obj/item/weapon/melee/arm_blade/process()  //Stolen from ninja swords.
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
		spawn(1)
			if(src)
				qdel(src)
