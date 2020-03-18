
GLOBAL_LIST_INIT(first_names_kig_yar, world.file2list('code/modules/halo/species_items/first_kig-yar.txt'))

/mob/living/carbon/human/covenant/kigyar/New(var/new_loc)
	. = ..(new_loc,"Kig-Yar")

/datum/language/ruuhti
	name = "Ruuhti"
	desc = "The language of the Ruuhtian KigYar"
	native = 1
	colour = "ruutian"
	syllables = list("hss","rar","hrar","har","rah","huss","hee","ha","schra","skraw","skree","skrss","hos","hosk")
	key = "R"
	flags = RESTRICTED

/mob/living/carbon/human/covenant/tvoan/New(var/new_loc)
	. = ..(new_loc,"Tvaoan Kig-Yar")
	faction = "Covenant"

/datum/language/tvoai
	name = "Tvoai"
	desc = "The language of the Tvaoan KigYar"
	native = 1
	colour = "tvaoan"
	syllables = list("hss","rar","hrar","har","rah","huss","hee","ha","schra","skraw","skree","skrss","hos","hosk")
	key = "T"
	flags = RESTRICTED

/obj/item/clothing/head/helmet/kigyar
	name = "Kig-Yar Scout Helmet"
	desc = "A Kig-Yar scout helmet with inbuilt night vision."
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "scouthelm"
	sprite_sheets = list("Kig-Yar" = 'code/modules/halo/icons/species/jackalclothing.dmi',"Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')
	armor = list(melee = 50, bullet = 55, laser = 40,energy = 40, bomb = 20, bio = 0, rad = 0)
	species_restricted = list("Kig-Yar")
	action_button_name = "Toggle Night Vision"
	flags_inv = null

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/kigyar_nv

/obj/item/clothing/glasses/hud/tactical/kigyar_nv
	name = "Kig-Yar Scout Helmet Night Vision"
	desc = "Scout Helmet night vision active."
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "inbuilt_nv"
	icon_override = ""//So nothing appears on the glasses layer.
	darkness_view = 7
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	canremove = 0

/obj/item/clothing/under/kigyar
	name = "Kig-Yar Body-Suit"
	desc = "A Kig-Yar body suit. Meant to be worn underneath a combat harness"
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "jackal_bodysuit_s"
	worn_state = "jackal_bodysuit"
	sprite_sheets = list("Default" = 'code/modules/halo/icons/species/jackalclothing.dmi',\
		"Kig-Yar" = 'code/modules/halo/icons/species/jackalclothing.dmi',\
		"Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')
	species_restricted = list("Kig-Yar","Tvaoan Kig-Yar")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/kigyar/armless
	icon_state = "jackal_bodysuit_armless_s"
	worn_state = "jackal_bodysuit_armless"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	species_restricted = list("Kig-Yar")

/obj/item/clothing/suit/armor/kigyar
	name = "Kig-Yar Combat Harness"
	desc = "A protective harness for use during combat."
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "scout"
	item_state = "scout"
	sprite_sheets = list("Default" = 'code/modules/halo/icons/species/jackalclothing.dmi',\
		"Kig-Yar" = 'code/modules/halo/icons/species/jackalclothing.dmi',\
		"Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')
	species_restricted = list("Kig-Yar","Tvaoan Kig-Yar")
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 50, bomb = 40, bio = 25, rad = 25) //A bit better than odsts
	armor_thickness_modifiers = list()
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/organ/external/arm/hollow_bones
	min_broken_damage = 20 //Needs 10 less damage to break

/obj/item/organ/external/arm/right/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/leg/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/leg/right/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/hand/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/hand/right/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/foot/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/foot/right/hollow_bones
	min_broken_damage = 20