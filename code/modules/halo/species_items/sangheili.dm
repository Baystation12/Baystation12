
GLOBAL_LIST_INIT(first_names_sangheili, world.file2list('code/modules/halo/species_items/first_sangheili.txt'))
GLOBAL_LIST_INIT(last_names_sangheili, world.file2list('code/modules/halo/species_items/last_sangheili.txt'))

/mob/living/carbon/human/covenant/sangheili/New(var/new_loc) //Species definition in code/modules/mob/living/human/species/outsider.
	..(new_loc,"Sangheili")							//Code breaks if not placed in species folder,
	name = pick(GLOB.first_names_sangheili)
	name += " "
	name += pick(GLOB.last_names_sangheili)
	real_name = name
	faction = "Covenant"

/datum/language/sangheili
	name = "Sangheili"
	desc = "The language of the Sangheili"
	native = 1
	syllables = list("ree","wortwortwort","wort","nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "S"

/obj/item/clothing/under/covenant/sangheili
	name = "Sangheili Body-suit"
	desc = "A sealed, airtight bodysuit. Meant to be worn underneath combat harnesses."
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "sangheili_bodysuit_s"
	item_state = "sangheili_bodysuit"
	worn_state = "sangheili_bodysuit"
	sprite_sheets = list("Sangheili" = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi')
	species_restricted = list("Sangheili")
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS

/obj/item/clothing/head/sangheili/minor
	name = "Sangheili Minor Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "minor_helm"
	sprite_sheets = list("Sangheili" = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi')
	species_restricted = list("Sangheili")
	body_parts_covered = HEAD | FACE
	item_flags = THICKMATERIAL
	armor = list(melee = 40,bullet = 20,laser = 40,energy = 5,bomb = 25,bio = 0,rad = 0) //Slightly higher bullet resist than Spartan helmets. Lower laser, energy and melee.

/obj/item/clothing/shoes/sangheili/minor
	name = "Sanghelli Minor Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "minor_legs"
	sprite_sheets = list("Sangheili" = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi')
	species_restricted = list("Sangheili")
	item_flags = NOSLIP // Because marines get it.
	body_parts_covered = LEGS
	armor = list(melee = 40, bullet = 60, laser = 5, energy = 4, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/special/combatharness
	name = "Sangheili Combat Harness"
	desc = "A Sangheili Combat Harness."
	species_restricted = list("Sangheili")
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = null
	sprite_sheets = list("Sangheili" = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi')
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
//	armor = list(melee = 95, bullet = 80, laser = 30, energy = 30, bomb = 60, bio = 25, rad = 25) //Close to spartan armour. Lower bullet,higher melee. Lower energy.

/obj/item/clothing/head/sangheili/eva
	name = "Sangheili EVA Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "ranger_helm"
	sprite_sheets = list("Sangheili" = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi')
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
	name = "Sangheili EVA Harness"
	desc = "A sealed. airtight Sangheili Combat Harness."
	icon_state = "ranger_chest"
	specials = list(/datum/armourspecials/shields)
	totalshields = 150
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/sangheili/eva
	name = "Sanghelli EVA Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "ranger_legs"
	sprite_sheets = list("Sangheili" = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi')
	species_restricted = list("Sangheili")
	item_flags = NOSLIP
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = LEGS|FEET
	cold_protection = LEGS|FEET
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 60, laser = 5, energy = 4, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/special/combatharness/minor
	icon_state = "minor_chest"
	totalshields = 100
	specials = list(/datum/armourspecials/shields)

/obj/item/organ/heart_secondary
	name = "Secondary Heart"
	parent_organ = "chest"
	icon_state = "heart-on"
	min_broken_damage = 30

/obj/item/organ/heart_secondary/process()
	if(is_broken())
		return
	var/obj/item/organ/internal/heart = owner.internal_organs_by_name["heart"]
	var/mob/living/carbon/human/m = owner
	if(heart && heart.is_broken())
		var/useheart = world.time + 50
		if(world.time >= useheart) //They still feel the effect.
			damage = heart.damage;heart.damage = 0
		return
	m.vessel.add_reagent("blood",30) // 30 blood should be enough to resist a shallow cut at max damage for that type.

/obj/effect/armoursets/SangheiliMinorSet/New()
	new /obj/item/clothing/suit/armor/special/combatharness/minor (src.loc)
	new /obj/item/clothing/shoes/sangheili/minor (src.loc)
	new /obj/item/clothing/head/sangheili/minor (src.loc)
	qdel(src)

