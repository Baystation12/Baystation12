
GLOBAL_LIST_INIT(first_names_sangheili, world.file2list('code/modules/halo/species_items/first_sangheili.txt'))
GLOBAL_LIST_INIT(last_names_sangheili, world.file2list('code/modules/halo/species_items/last_sangheili.txt'))

#define SANGHEILI_ARMOUR_ICON 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'

/mob/living/carbon/human/covenant/sangheili/New(var/new_loc) //Species definition in code/modules/mob/living/human/species/outsider.
	..(new_loc,"Sangheili")							//Code breaks if not placed in species folder,
	name = pick(GLOB.first_names_sangheili)
	name += " "
	name += pick(GLOB.last_names_sangheili)
	real_name = name
	faction = "Covenant"

/datum/language/sangheili
	name = LANGUAGE_SANGHEILI
	desc = "The language of the Sangheili"
	native = 1
	syllables = list("ree","wortwortwort","wort","nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "S"
	flags = RESTRICTED

/obj/item/clothing/under/covenant/sangheili
	name = "Sangheili Body-suit"
	desc = "A sealed, airtight bodysuit. Meant to be worn underneath combat harnesses."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "sangheili_bodysuit_s"
	item_state = "sangheili_bodysuit"
	worn_state = "sangheili_bodysuit"
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS

/obj/item/clothing/head/helmet/sangheili
	name = "Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = HEAD | FACE
	item_flags = THICKMATERIAL
	armor = list(melee = 40,bullet = 20,laser = 40,energy = 5,bomb = 25,bio = 0,rad = 0) //Slightly higher bullet resist than Spartan helmets. Lower laser, energy and melee.

/obj/item/clothing/suit/armor/special/combatharness
	name = "Sangheili Combat Harness"
	desc = "A Sangheili Combat Harness."
	species_restricted = list("Sangheili")
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	specials = list(/datum/armourspecials/shields,/datum/armourspecials/shieldmonitor/sangheili)
	armor = list(melee = 95, bullet = 80, laser = 60, energy = 60, bomb = 60, bio = 25, rad = 25) //Close to spartan armour. Lower bullet,higher melee. Lower energy.
	armor_thickness_modifiers = list()

/obj/item/clothing/shoes/sangheili
	name = "Sanghelli Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	item_flags = NOSLIP // Because marines get it.
	body_parts_covered = LEGS
	armor = list(melee = 40, bullet = 60, laser = 5, energy = 5, bomb = 40, bio = 0, rad = 0)

//Sangheili Armour Subtype Defines//

/obj/item/clothing/head/helmet/sangheili/minor
	name = "Sangheili Helmet (Minor)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "minor_helm"

/obj/item/clothing/suit/armor/special/combatharness/minor
	name = "Sangheili Combat Harness (Minor)"
	icon_state = "minor_chest"
	totalshields = 100

/obj/item/clothing/shoes/sangheili/minor
	name = "Sanghelli Leg Armour (Minor)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "minor_legs"

/obj/item/clothing/head/helmet/sangheili/major
	name = "Sangheili Helmet (Major)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "major_helm"

/obj/item/clothing/suit/armor/special/combatharness/major
	name = "Sangheili Combat Harness (Major)"
	icon_state = "major_chest"
	totalshields = 125

/obj/item/clothing/shoes/sangheili/major
	name = "Sanghelli Leg Armour (Major)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "major_legs"

/obj/item/clothing/head/helmet/sangheili/ultra
	name = "Sangheili Helmet (Ultra)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "ultra_helm"

/obj/item/clothing/suit/armor/special/combatharness/ultra
	name = "Sangheili Combat Harness (Ultra)"
	icon_state = "ultra_chest"
	totalshields = 150

/obj/item/clothing/shoes/sangheili/ultra
	name = "Sanghelli Leg Armour (Ultra)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "ultra_legs"

/obj/item/clothing/head/helmet/sangheili/zealot
	name = "Sangheili Helmet (Zealot)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "zealot_helm"

/obj/item/clothing/suit/armor/special/combatharness/zealot
	name = "Sangheili Combat Harness (Zealot)"
	icon_state = "zealot_chest"
	totalshields = 200

/obj/item/clothing/shoes/sangheili/zealot
	name = "Sanghelli Leg Armour (Zealot)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "zealot_legs"

/obj/item/clothing/head/helmet/sangheili/specops
	name = "Sangheili Helmet (Spec-Ops)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "specops_helm"

/obj/item/clothing/suit/armor/special/combatharness/specops
	name = "Sangheili Combat Harness (Spec-Ops)"
	icon_state = "specops_chest"
	totalshields = 175
	specials = list(/datum/armourspecials/shields,/datum/armourspecials/shieldmonitor/sangheili,/datum/armourspecials/cloaking)
	action_button_name = "Toggle Active Camoflage"

/obj/item/clothing/shoes/sangheili/specops
	name = "Sanghelli Leg Armour (Spec-Ops)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "specops_legs"

/obj/item/clothing/head/helmet/sangheili/eva
	name = "Sangheili Helmet (EVA)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "ranger_helm"
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = HEAD | FACE
	item_flags = THICKMATERIAL
	armor = list(melee = 40,bullet = 20,laser = 40,energy = 5,bomb = 25,bio = 0,rad = 0)
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/special/combatharness/eva
	name = "Sangheili Combat Harness (EVA)"
	desc = "A sealed. airtight Sangheili Combat Harness."
	icon_state = "ranger_chest"
	totalshields = 150
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/sangheili/eva
	name = "Sanghelli Leg Armour (EVA)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "ranger_legs"
	item_flags = NOSLIP
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = LEGS|FEET
	cold_protection = LEGS|FEET
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

//Organ Defines + misc//

/obj/item/organ/heart_secondary
	name = "Secondary Heart"
	parent_organ = "chest"
	icon_state = "heart-on"
	min_broken_damage = 30

/obj/item/organ/heart_secondary/process()
	if(is_broken())
		return
	var/obj/item/organ/internal/heart = owner.internal_organs_by_name["heart"]
	if(heart && heart.is_broken())
		var/useheart = world.time + 50
		if(world.time >= useheart) //They still feel the effect.
			damage = heart.damage;heart.damage = 0
		return
	if(prob(5)) //The original implementation of adding blood now causes runtimes.
		for(var/obj/item/organ/external/e in owner.bad_external_organs)
			for(var/datum/wound/w in e.wounds)
				w.damage -= rand(0.10)
				if(!w.bandaged)
					w.bandage()//Only helps agains brute wounds, burn isn't autobandaged by the secondary heart.

/obj/effect/armoursets/SangheiliMinorSet/New()
	new /obj/item/clothing/under/covenant/sangheili (src.loc)
	new /obj/item/clothing/suit/armor/special/combatharness/minor (src.loc)
	new /obj/item/clothing/shoes/sangheili/minor (src.loc)
	new /obj/item/clothing/head/helmet/sangheili/minor (src.loc)
	qdel(src)

#undef SANGHEILI_ARMOUR_ICON