/datum/power/changeling/space_suit
	name = "Organic Space Suit"
	desc = "We grow an organic suit to protect ourselves from space exposure."
	helptext = "To remove the suit, use the ability again."
	genomecost = 1
	verbpath = /mob/proc/changeling_spacesuit

/mob/proc/changeling_spacesuit()
	set category = "Changeling"
	set name = "Organic Space Suit (20)"

	if(changeling_generic_armor(/obj/item/clothing/suit/space/changeling,/obj/item/clothing/head/helmet/space/changeling))
		return 1
	return 0

/datum/power/changeling/armor
	name = "Chitinous Spacearmor"
	desc = "We turn our skin into tough chitin to protect us from damage and space exposure."
	helptext = "To remove the armor, use the ability again."
	genomecost = 3
	verbpath = /mob/proc/changeling_spacearmor

/mob/proc/changeling_spacearmor()
	set category = "Changeling"
	set name = "Organic Spacearmor (20)"

	if(changeling_generic_armor(/obj/item/clothing/suit/space/changeling/armored,/obj/item/clothing/head/helmet/space/changeling/armored))
		return 1
	return 0

//Space suit

/obj/item/clothing/suit/space/changeling
	name = "flesh mass"
	icon_state = "lingspacesuit"
	item_state = "lingspacehelmet"
	desc = "A huge, bulky mass of pressure and temperature-resistant organic tissue, evolved to facilitate space travel."
	flags = STOPPRESSUREDAMAGE			 //Not THICKMATERIAL because it's organic tissue, so if somebody tries to inject something into it,
										//it still ends up in your blood. (also balance but muh fluff)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) //No armor at all.
	canremove = 0

/obj/item/clothing/suit/space/changeling/New()
	..()
	item_icons[slot_wear_suit_str] = 'icons/mob/items/changeling.dmi'
	if(ismob(loc))
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh rapidly inflates, forming a bloated mass around their body!</span>",
		"<span class='warning'>We inflate our flesh, creating a spaceproof suit!</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>")

/obj/item/clothing/suit/space/changeling/dropped()
	qdel(src)

/obj/item/clothing/head/helmet/space/changeling
	name = "flesh mass"
	icon = 'icons/mob/items/changeling.dmi'
	icon_state = "lingspacehelmet"
	desc = "A covering of pressure and temperature-resistant organic tissue with a glass-like chitin front."
	flags = BLOCKHAIR | STOPPRESSUREDAMAGE //Again, no THICKMATERIAL.
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = HEAD|FACE|EYES
	canremove = 0

/obj/item/clothing/head/helmet/space/changeling/New()
	..()
	item_icons[slot_head_str] = 'icons/mob/items/changeling.dmi'


/obj/item/clothing/head/helmet/space/changeling/dropped()
	qdel(src)

//Armor

/obj/item/clothing/suit/space/changeling/armored
	name = "chitinous mass"
	desc = "A tough, hard covering of black chitin."
	icon = 'icons/mob/items/changeling.dmi'
	icon_state = "lingarmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 75, bullet = 60, laser = 60, energy = 60, bomb = 60, bio = 0, rad = 0) //It costs 3 points, so it should be very protective.
	siemens_coefficient = 0.3
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/changeling/armored/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 3
	item_icons[slot_wear_suit_str] = 'icons/mob/items/changeling.dmi'
	if(ismob(loc))
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh turns black, quickly transforming into a hard, chitinous mass!</span>",
		"<span class='warning'>We harden our flesh, creating a suit of armor!</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>")

/obj/item/clothing/suit/space/changeling/armored/dropped()
	qdel(src)

/obj/item/clothing/head/helmet/space/changeling/armored
	name = "chitinous mass"
	desc = "A tough, hard covering of black chitin with transparent chitin in front."
	icon = 'icons/mob/items/changeling.dmi'
	icon_state = "lingarmorhelmet"
	armor = list(melee = 75, bullet = 60, laser = 60,energy = 60, bomb = 60, bio = 0, rad = 0)
	siemens_coefficient = 0.3
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/space/changeling/armored/New()
	item_icons[slot_head_str] = 'icons/mob/items/changeling.dmi'
	..()

/obj/item/clothing/head/helmet/space/changeling/armored/dropped()
	qdel(src)

/obj/item/clothing/gloves/combat/changeling //Combined insulated/fireproof gloves
	name = "chitinous gauntlets"
	desc = "Very resilient gauntlets made out of black chitin.  It looks very durable, and can probably resist electrical shock in addition to the elements."
	icon_state = "lingarmorgloves"
	armor = list(melee = 75, bullet = 60, laser = 60,energy = 60, bomb = 60, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/gloves/combat/changeling/New()
	item_icons[slot_gloves_str] = 'icons/mob/items/changeling.dmi'
	..()

/obj/item/clothing/shoes/combat/changeling //Noslips
	desc = "chitinous boots"
	name = "Footwear made out of a hard, black chitinous material.  The bottoms of these appear to have spikes that can protrude or extract itself into and out \
	of the floor at will, granting the wearer stability."
	//icon_state = "lingboots" //No sprites, it seems
	armor = list(melee = 75, bullet = 60, laser = 70,energy = 60, bomb = 60, bio = 0, rad = 0)
	sharp = 1 //spikes
	siemens_coefficient = 0.3
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
