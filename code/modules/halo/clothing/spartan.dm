
/obj/item/clothing/head/helmet/spartan
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV"
	desc = "Ave, Imperator, morituri te salutant."
	icon = 'code/modules/halo/clothing/spartan.dmi'
	icon_state = "markIVhelm"
	icon_override = 'code/modules/halo/clothing/mob_spartanhelm.dmi'
	item_state_slots = list(
		slot_l_hand_str = "spartan5_l",
		slot_r_hand_str = "spartan5_r",
		)
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	armor = list(melee = 50,bullet = 15,laser = 50,energy = 10,bomb = 25,bio = 0,rad = 0)
	sprite_sheets = list("Spartan" = 'code/modules/halo/clothing/spartan.dmi')
	species_restricted = list("Spartan")

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/clothing/head/helmet/spartan/blue
	icon_state = "markIVhelmB"

/obj/item/clothing/head/helmet/spartan/red
	icon_state = "markIVhelmR"

/obj/item/clothing/suit/armor/special/spartan
	name = "MJOLNIR Powered Assault Armor Mark IV"
	desc = "a technologically-advanced combat exoskeleton system designed to vastly improve the strength, speed, agility, reflexes and durability of a SPARTAN-II, supersoldier in the field of combat."
	icon = 'code/modules/halo/clothing/spartan.dmi'
	icon_state = "markIVmale"
	icon_override = 'code/modules/halo/clothing/mob_spartansuit.dmi'
	item_state_slots = list(
		slot_l_hand_str = "spartan5_l",
		slot_r_hand_str = "spartan5_r",
		)
	blood_overlay_type = "armor"
	armor = list(melee = 80, bullet = 95, laser = 70, energy = 70, bomb = 60, bio = 25, rad = 25)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	specials = list(/datum/armourspecials/internal_jumpsuit/spartan)
	sprite_sheets = list("Spartan" = 'code/modules/halo/clothing/spartan.dmi')
	species_restricted = list("Spartan")

/obj/item/clothing/suit/armor/special/spartan/red
	icon_state = "markIVmaleR"
	armor = list(melee = 60, bullet = 75, laser = 40, energy = 40, bomb = 60, bio = 25, rad = 25) //lowered armour values for slayer.
	specials = list(/datum/armourspecials/internal_jumpsuit/spartan,/datum/armourspecials/shields/spartan,/datum/armourspecials/dispenseitems/spartanmeds,/datum/armourspecials/shieldmonitor)
	totalshields = 100
	canremove = 0 //To disallow stripping of armour for impersonation in slayer.
	action_button_name = "Dispense Medicine"

/obj/item/clothing/suit/armor/special/spartan/blue
	icon_state = "markIVmaleB"
	armor = list(melee = 60, bullet = 75, laser = 40, energy = 40, bomb = 60, bio = 25, rad = 25) //lowered armour values for slayer.
	specials = list(/datum/armourspecials/internal_jumpsuit/spartan,/datum/armourspecials/shields/spartan,/datum/armourspecials/dispenseitems/spartanmeds,/datum/armourspecials/shieldmonitor)
	totalshields = 100
	canremove = 0
	action_button_name = "Dispense Medicine"

/obj/item/clothing/suit/armor/special/spartan/slayer
	armor = list(melee = 60, bullet = 75, laser = 40, energy = 40, bomb = 60, bio = 25, rad = 25) //lowered armour values for slayer.
	specials = list(/datum/armourspecials/internal_jumpsuit/spartan,/datum/armourspecials/shields/spartan,/datum/armourspecials/shieldmonitor)
	totalshields = 100

/obj/item/clothing/under/spartan_internal
	name = "Spartan Undersuit"
	desc = ""
	icon_state = "blackutility"
	item_state = "blackutility"
	worn_state = null
	canremove = 0



//*** SUIT VARIANTS ***//

/obj/item/clothing/suit/armor/special/spartan/mkv
	name = "MJOLNIR Powered Assault Armor Mark V"
	icon_state = "Mjolnir Powered Assault Armor/Mark V Male"

/obj/item/clothing/suit/armor/special/spartan/mkv/gungnir
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir variant"
	icon_state = "gungirmale"

/obj/item/clothing/suit/armor/special/spartan/mkv/gungnir/blue
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir variant"
	icon_state = "gungirbluemale"

/obj/item/clothing/suit/armor/special/spartan/mkv/mistermann
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir variant (customised)"
	icon_state = "Mjolnir Powered Assault Armor/Mark V Male MisterMann"

/obj/item/clothing/suit/armor/special/spartan/mkvi_grenadier
	name = "MJOLNIR Powered Assault Armor Mark VI Grenadier variant (customised)"
	icon_state = "Mjolnir Powered Assault Armor/Mark VI grenadier"



//*** HELMET VARIANTS ***//

/obj/item/clothing/head/helmet/spartan/mkv
	name = "MJOLNIR Powered Assault Armor Helmet Mark V"
	icon_state = "Mjolnir Powered Assault Helmet/Mark V"

/obj/item/clothing/head/helmet/spartan/mkv/gungnir
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir variant"
	icon_state = "gungirhelm"

/obj/item/clothing/head/helmet/spartan/mkv/gungnir/blue
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir variant"
	icon_state = "gungirbluehelm"

/obj/item/clothing/head/helmet/spartan/mkv/mistermann
	name = "MJOLNIR Powered Assault Armor Helmet Mark V (customised)"
	icon_state = "Mjolnir Powered Assault Helmet/Mark V MisterMann"

/obj/item/clothing/head/helmet/spartan/mkv/mistermann_gungnir
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir variant (customised)"
	icon_state = "Mjolnir Powered Assault Helmet/Mark V Gungir MisterMann"

/obj/item/clothing/head/helmet/spartan/mkv/airassault
	name = "MJOLNIR Powered Assault Armor Mark V Air Assault variant"
	icon_state = "Mjolnir Powered Assault Helmet/Mark V Airassault"

/obj/item/clothing/head/helmet/spartan/mkv/eva
	name = "MJOLNIR Powered Assault Armor Mark V EVA variant"
	icon_state = "Mjolnir Powered Assault Helmet/Mark V EVA"

/obj/item/clothing/head/helmet/spartan/mkv/commando
	name = "MJOLNIR Powered Assault Armor Mark V Commando variant"
	icon_state = "Mjolnir Powered Assault Helmet/Mark V Commando"

/obj/item/clothing/head/helmet/spartan/mkv/noble
	name = "MJOLNIR Powered Assault Armor Mark V Noble variant"
	icon_state = "Mjolnir Powered Assault Helmet/Mark V Noble"

/obj/item/clothing/head/helmet/spartan/mkvi_eva
	name = "MJOLNIR Powered Assault Helmet Mark VI EVA variant"
	icon_state = "Mjolnir Powered Assault Helmet/Mark VI EVA"
