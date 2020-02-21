
GLOBAL_LIST_INIT(first_names_jiralhanae, world.file2list('code/modules/halo/species_items/first_jiralhanae.txt'))
#define JIRALHANAE_ICON_PATH_MOB 'code/modules/halo/icons/species/jiralhanae_gear.dmi'
#define JIRALHANAE_ICON_PATH_OBJ 'code/modules/halo/icons/species/jiralhanae_obj.dmi'

/mob/living/carbon/human/covenant/jiralhanae/New(var/new_loc)
	. = ..(new_loc,"Jiralhanae")

/datum/language/doisacci
	name = "Doisacci"
	desc = "The language of the Jiralhanae"
	native = 1
	colour = "jiralhanae"
	syllables = list("ung","ugh","uhh","hss","grss","grah","argh","hng","ung","uss","hoh","rog")
	key = "D"
	flags = RESTRICTED






/* BODYSUIT */




/obj/item/clothing/under/covenant/jiralhanae
	name = "Jiralhanae Bodysuit"
	desc = "A Jiralhanae body suit. Looks itchy and covered in hair."
	icon = JIRALHANAE_ICON_PATH_OBJ
	icon_state = "bodysuit"
	sprite_sheets = list("Jiralhanae" = JIRALHANAE_ICON_PATH_MOB)
	species_restricted = list("Jiralhanae")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 3, bullet = 3, laser = 3, energy = 3, bomb = 3, bio = 0, rad = 0)

/obj/item/clothing/under/covenant/jiralhanae/red
	icon_state = "bodysuit_red"
	armor = list(melee = 3, bullet = 3, laser = 3, energy = 3, bomb = 3, bio = 0, rad = 0)

/obj/item/clothing/under/covenant/jiralhanae/blue
	icon_state = "bodysuit_blue"
	armor = list(melee = 3, bullet = 3, laser = 3, energy = 3, bomb = 3, bio = 0, rad = 0)






/* HELMET */



/obj/item/clothing/head/helmet/jiralhanae
	name = "Jiralhanae Helm"
	desc = "A crude metal cap made of a heavy, alien alloy."
	icon = JIRALHANAE_ICON_PATH_OBJ
	icon_state = "helm_minor"
	sprite_sheets = list("Jiralhanae" = JIRALHANAE_ICON_PATH_MOB)
	armor = list(melee = 30, bullet = 20, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)
	species_restricted = list("Jiralhanae")

/obj/item/clothing/head/helmet/jiralhanae/major
	name = "Jiralhanae Major Helm"
	icon_state = "helm_major"
	armor = list(melee = 35, bullet = 25, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/jiralhanae/captain
	name = "Jiralhanae Captain Helm"
	icon_state = "helm_captain"
	armor = list(melee = 40, bullet = 30, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/jiralhanae/chieftain_boulder
	name = "Boulder Chieftain Helm"
	icon_state = "helm_chieftain_red"
	armor = list(melee = 40, bullet = 30, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)
	armor_thickness = 25

/obj/item/clothing/head/helmet/jiralhanae/chieftain_ram
	name = "Ram Chieftain Helm"
	icon_state = "helm_chieftain_blue"
	armor = list(melee = 40, bullet = 30, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)
	armor_thickness = 25

/obj/item/clothing/head/helmet/jiralhanae/covenant
	icon_state = "helm_covenant"
	desc = "The standard issue helmets of Jiralhanae soldiers within the covenant."
	armor = list(melee = 45,bullet = 10,laser = 30,energy = 5,bomb = 30,bio = 0,rad = 0)
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/covenant

/obj/item/clothing/head/helmet/jiralhanae/covenant/minor
	name = "Jiralhanae Helm (Minor)"
	icon_state = "helm_minor"

/obj/item/clothing/head/helmet/jiralhanae/covenant/major
	name = "Jiralhanae Helm (Major)"
	icon_state = "helm_major"

/obj/item/clothing/head/helmet/jiralhanae/covenant/captain
	name = "Jiralhanae Helm (Captain)"
	desc = "This modified helmet is of some significance to Jiralhanae clans. It is a mark of importance, however now diminished by the covenant hierarchy."
	icon_state = "helm_captain"

/obj/item/clothing/head/helmet/jiralhanae/covenant/EVA
	name = "Jiralhanae Softsuit Helmet"
	desc = "This helmet was designed to keep Jiralhanae alive during EVA activity."
	icon_state = "helm_soft"
	armor = list(melee = 0, bullet = 0, laser = 15, energy = 0, bomb = 15, bio = 100, rad = 100)
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/* ARMOUR */



/obj/item/clothing/suit/armor/jiralhanae
	name = "Jiralhanae Chest Armour"
	desc = "A mysterious alien alloy fashioned into crude metal plating for protection of vital areas."
	species_restricted = list("Jiralhanae")
	icon = JIRALHANAE_ICON_PATH_OBJ
	icon_state = "armour_minor"
	sprite_sheets = list("Jiralhanae" = JIRALHANAE_ICON_PATH_MOB)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 30, bullet = 20, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	allowed = list(\
		/obj/item/weapon/grenade/plasma,/obj/item/weapon/grenade/frag/spike,/obj/item/weapon/grenade/brute_shot,/obj/item/weapon/grenade/toxic_gas,\
		/obj/item/weapon/gun/projectile/spiker,/obj/item/weapon/gun/projectile/mauler,\
		/obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/energy/plasmarifle, /obj/item/weapon/gun/energy/plasmarifle/brute)

/obj/item/clothing/suit/armor/jiralhanae/major
	name = "Jiralhanae Major Chest Armour"
	icon_state = "armour_major"
	armor = list(melee = 35, bullet = 25, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/armor/jiralhanae/captain
	name = "Jiralhanae Captain Chest Armour"
	icon_state = "armour_captain"
	armor = list(melee = 40, bullet = 30, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS


/obj/item/clothing/suit/armor/jiralhanae/red
	icon_state = "armour_minor_red"

/obj/item/clothing/suit/armor/jiralhanae/major/red
	icon_state = "armour_major_red"

/obj/item/clothing/suit/armor/jiralhanae/captain/red
	icon_state = "armour_captain_red"

/obj/item/clothing/suit/armor/jiralhanae/chieftain_boulder
	name = "Boulder Chieftain Armour"
	icon_state = "armour_chieftain_red"
	armor = list(melee = 40, bullet = 30, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS
	armor_thickness = 25

/obj/item/clothing/suit/armor/jiralhanae/blue
	name = "Jiralhanae Ram Chest Armour"
	icon_state = "armour_minor_blue"

/obj/item/clothing/suit/armor/jiralhanae/major/blue
	name = "Jiralhanae Ram Chest Armour"
	icon_state = "armour_major_blue"

/obj/item/clothing/suit/armor/jiralhanae/captain/blue
	name = "Jiralhanae Ram Chest Armour"
	icon_state = "armour_captain_blue"

/obj/item/clothing/suit/armor/jiralhanae/chieftain_ram
	name = "Ram Chieftain Armour"
	icon_state = "armour_chieftain_blue"
	armor = list(melee = 40, bullet = 30, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS
	armor_thickness = 25

/obj/item/clothing/suit/armor/jiralhanae/covenant
	icon_state = "armour_covenant"
	desc = "The armour of Jiralhanae soldiers within the covenant."
	armor = list(melee = 90, bullet = 50, laser = 45, energy = 45, bomb = 50, bio = 25, rad = 25)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS

/obj/item/clothing/suit/armor/jiralhanae/covenant/EVA
	name = "Jiralhanae Softsuit"
	desc = "This softsuit was designed to keep Jiralhanae alive during EVA activity."
	icon_state = "armour_soft"
	armor = list(melee = 30, bullet = 10, laser = 20, energy = 10, bomb = 25, bio = 100, rad = 100)
	allowed = list(\
		/obj/item/weapon/grenade/plasma,/obj/item/weapon/grenade/frag/spike,/obj/item/weapon/grenade/brute_shot,/obj/item/weapon/grenade/toxic_gas,\
		/obj/item/weapon/gun/projectile/spiker,/obj/item/weapon/gun/projectile/mauler,\
		/obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/energy/plasmarifle, /obj/item/weapon/gun/energy/plasmarifle/brute, /obj/item/weapon/tank)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/jiralhanae/covenant/minor
	name = "Jiralhanae Armor (Minor)"
	icon_state = "armour_minor"

/obj/item/clothing/suit/armor/jiralhanae/covenant/major
	name = "Jiralhanae Armor (Major)"
	icon_state = "armour_major"

/obj/item/clothing/suit/armor/jiralhanae/covenant/captain
	name = "Jiralhanae Armor (Captain)"
	desc = "This modified armor used to be a mark of importance to a Jiralhanae clan. The Covenant hierarchy has diminished it's power."
	icon_state = "armour_captain"

/* SHOES */



/obj/item/clothing/shoes/jiralhanae
	name = "Jiralhanae greaves"
	desc = "Crude metal plates made of a mysterious alien alloy for fastening to the legs."
	species_restricted = list("Jiralhanae")
	icon = JIRALHANAE_ICON_PATH_OBJ
	icon_state = "greaves"
	sprite_sheets = list("Jiralhanae" = JIRALHANAE_ICON_PATH_MOB)
	armor = list(melee = 30, bullet = 20, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	body_parts_covered = LEGS|FEET

/obj/item/clothing/shoes/jiralhanae/covenant
	name = "Jiralhanae Greaves"
	desc = "The footwear of Jiralhanae soldiers within the covenant."
	icon_state = "greaves"
	item_flags = NOSLIP
	armor = list(melee = 50, bullet = 40, laser = 5, energy = 5, bomb = 40, bio = 0, rad = 0)






/* FLAGS */

/obj/item/clothing/jiralhanae_flag_boulder
	name = "Boulder Clan Flag"
	desc = "A flag of honour from a Jiralhanae clan."
	icon_state = "flag_red"
	item_state = "flag_back_red"
	slot_flags = SLOT_BACK
	force = 15
	w_class = ITEM_SIZE_LARGE
	species_restricted = list("Jiralhanae")
	icon = JIRALHANAE_ICON_PATH_OBJ
	icon_override = JIRALHANAE_ICON_PATH_MOB
	item_state_slots = list(
		slot_l_hand_str = "flag_red_left",
		slot_r_hand_str = "flag_red_right" )

/obj/item/clothing/jiralhanae_flag_ram
	name = "Ram Clan Flag"
	desc = "A flag of honour from a Jiralhanae clan."
	icon_state = "flag_blue"
	item_state = "flag_back_blue"
	slot_flags = SLOT_BACK
	force = 15
	w_class = ITEM_SIZE_LARGE
	species_restricted = list("Jiralhanae")
	icon = JIRALHANAE_ICON_PATH_OBJ
	icon_override = JIRALHANAE_ICON_PATH_MOB
	item_state_slots = list(
		slot_l_hand_str = "flag_blue_left",
		slot_r_hand_str = "flag_blue_right" )

/obj/item/clothing/jiralhanae_flag_random
	name = "Jiralhanae Clan Flag"
	desc = "A flag belonging to a nearly forgotten clan."
	slot_flags = SLOT_BACK
	force = 30
	w_class = ITEM_SIZE_LARGE
	species_restricted = list("Jiralhanae")
	icon = JIRALHANAE_ICON_PATH_OBJ
	icon_override = JIRALHANAE_ICON_PATH_MOB

/obj/item/clothing/jiralhanae_flag_random/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "flag_blue"
		item_state = "flag_back_blue"
		item_state_slots = list(
		slot_l_hand_str = "flag_blue_left",
		slot_r_hand_str = "flag_blue_right" )
	else
		icon_state = "flag_red"
		item_state = "flag_back_red"
		item_state_slots = list(
		slot_l_hand_str = "flag_red_left",
		slot_r_hand_str = "flag_red_right" )

#undef JIRALHANAE_ICON_PATH_MOB
#undef JIRALHANAE_ICON_PATH_OBJ
