/datum/power/changeling/space_suit
	name = "Organic Space Suit"
	desc = "We grow an organic suit to protect ourselves from space exposure."
	helptext = "To remove the suit, use the ability again."
	ability_icon_state = "ling_space_suit"
	genomecost = 1
	verbpath = /mob/proc/changeling_spacesuit

/mob/proc/changeling_spacesuit()
	set category = "Changeling"
	set name = "Organic Space Suit (20)"
	if(changeling_generic_armor(/obj/item/clothing/suit/space/changeling,/obj/item/clothing/head/helmet/space/changeling,/obj/item/clothing/shoes/magboots/changeling, 20))
		return TRUE
	return FALSE

/datum/power/changeling/armor
	name = "Chitinous Spacearmor"
	desc = "We turn our skin into tough chitin to protect us from damage and space exposure."
	helptext = "To remove the armor, use the ability again."
	ability_icon_state = "ling_armor"
	genomecost = 3
	verbpath = /mob/proc/changeling_spacearmor

/mob/proc/changeling_spacearmor()
	set category = "Changeling"
	set name = "Chitinous Spacearmor (20)"

	if(changeling_generic_armor(/obj/item/clothing/suit/space/changeling/armored,/obj/item/clothing/head/helmet/space/changeling/armored,/obj/item/clothing/shoes/magboots/changeling/armored, 20))

		return TRUE
	return FALSE

//Space suit

/obj/item/clothing/suit/space/changeling
	name = "organic suit"
	icon_state = "lingspacesuit"
	desc = "A thin, skintight mass of pressure and temperature-resistant organic tissue, evolved to facilitate space travel."
	allowed = list(/obj/item/device/flashlight, /obj/item/tank/oxygen_emergency, /obj/item/tank/oxygen_emergency_extended)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) //No armor at all.
	canremove = FALSE
	can_breach = FALSE
	flags_inv = BLOCKHAIR | HIDETAIL
	var/remove_on_respec = TRUE

/obj/item/clothing/suit/space/changeling/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 0
	START_PROCESSING(SSobj, src)
	if(ismob(loc))
		to_chat(src,SPAN_WARNING("[loc.name]\'s flesh splits and twists, forming into a thin fleshy membrane around their body!"))

/obj/item/clothing/suit/space/changeling/dropped(mob/user)
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)

/obj/item/clothing/suit/space/changeling/Destroy()

	STOP_PROCESSING(SSobj, src)

	return ..()

/obj/item/clothing/head/helmet/space/changeling
	name = "flesh mass"
	icon_state = "lingspacehelmet"
	desc = "A covering of pressure and temperature-resistant organic tissue with a translucent, glass-like front made of organic tissue."
	flags_inv = HIDEEARS|BLOCKHEADHAIR //Again, no THICKMATERIAL.
	body_parts_covered = HEAD|FACE|EYES
	var/remove_on_respec = TRUE
	canremove = 0
	flags_inv = BLOCKHAIR | HIDETAIL | HIDEFACE


/obj/item/clothing/head/helmet/space/changeling/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/shoes/magboots/changeling
	desc = "A suction cupped mass of flesh, shaped like a foot."
	name = "fleshy grippers"
	icon_state = "lingspacesuit"
	action_button_name = "Toggle Grippers"
	canremove = 0
	online_slowdown = 3
	var/remove_on_respec = TRUE

/obj/item/clothing/shoes/magboots/changeling/set_slowdown()
	slowdown_per_slot[slot_shoes] = shoes? max(0, shoes.slowdown_per_slot[slot_shoes]): 0	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown_per_slot[slot_shoes] += online_slowdown

/obj/item/clothing/shoes/magboots/changeling/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~ITEM_FLAG_NOSLIP
		magpulse = 0
		set_slowdown()
		force = 3
		to_chat(user, "We release our grip on the floor.")
	else
		item_flags |= ITEM_FLAG_NOSLIP
		magpulse = 1
		set_slowdown()
		force = 5
		to_chat(user, "We cling to the terrain below us.")


/obj/item/clothing/shoes/magboots/changeling/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

//Armor

/obj/item/clothing/suit/space/changeling/armored
	name = "chitinous mass"
	desc = "A protective shell of muscle, bone and chitin, designed for violence and violence alone."
	icon_state = "lingarmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	//It costs 3 points, so it should be very protective.
	//armor = list(melee = 75, bullet = 65, laser = 60, energy = 60, bomb = 60, bio = 0, rad = 0)
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		)
	siemens_coefficient = 0.3
	can_breach = FALSE
	flags_inv = BLOCKHAIR | HIDETAIL
	//max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	slowdown_general = 0

/obj/item/clothing/suit/space/changeling/armored/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	slowdown_per_slot[slot_wear_suit] = 0
	if(ismob(loc))
		to_chat(src,SPAN_WARNING("Our muscles twist and our bones crack with a crunching noise as we form claws, teeth and armor!"))

		/*
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh turns black, quickly transforming into a hard, chitinous mass!</span>",
		"<span class='warning'>We harden our flesh, creating a suit of armor!</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>")
		*/
/obj/item/clothing/suit/space/changeling/armored/Destroy()


	STOP_PROCESSING(SSobj, src)

	return ..()


/obj/item/clothing/head/helmet/space/changeling/armored
	name = "chitinous mass"
	desc = "An enormous eyeless maw of teeth that hungers."
	icon_state = "lingarmorhelmet"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		)
	siemens_coefficient = 0.3
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	flags_inv = BLOCKHAIR | HIDETAIL | HIDEFACE

/obj/item/clothing/shoes/magboots/changeling/armored
	desc = "A tough, hard mass of chitin, with long talons for digging into terrain."
	name = "chitinous talons"
	icon_state = "lingchameleon"
	action_button_name = "Toggle Talons"

/obj/item/clothing/gloves/combat/changeling //Combined insulated/fireproof gloves
	name = "chitinous gauntlets"
	desc = "Very resilient gauntlets made out of black chitin.  It looks very durable, and can probably resist electrical shock in addition to the elements."
	icon_state = "lingarmorgloves"
	armor = list(melee = 75, bullet = 60, laser = 60,energy = 60, bomb = 60, bio = 0, rad = 0) //No idea if glove armor gets checked
	siemens_coefficient = 0

/obj/item/clothing/shoes/boots/combat/changeling //Noslips
	name = "chitinous boots"
	desc = "Footwear made out of a hard, black chitinous material.  The bottoms of these appear to have spikes that can protrude or extract itself into and out \
	of the floor at will, granting the wearer stability."
	icon_state = "lingchameleon"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		)
	siemens_coefficient = 0.3
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
