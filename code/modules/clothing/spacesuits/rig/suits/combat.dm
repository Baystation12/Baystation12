/obj/item/weapon/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/scanner/gas,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit)

	chest_type = /obj/item/clothing/suit/space/rig/combat
	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	boot_type = /obj/item/clothing/shoes/magboots/rig/combat
	glove_type = /obj/item/clothing/gloves/rig/combat

/obj/item/clothing/head/helmet/space/rig/combat
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_head_unathi.dmi'
		)

/obj/item/clothing/suit/space/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_suit_unathi.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_feet_unathi.dmi'
		)

/obj/item/clothing/gloves/rig/combat
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_hands_unathi.dmi'
		)

/obj/item/weapon/rig/combat/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit
		)

//Extremely OP, hardly standard issue equipment
//Now a little less OP
/obj/item/weapon/rig/military
	name = "military hardsuit control module"
	desc = "An austere hardsuit used by paramilitary groups and real soldiers alike."
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/scanner/gas,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit)

	chest_type = /obj/item/clothing/suit/space/rig/military
	helm_type = /obj/item/clothing/head/helmet/space/rig/military
	boot_type = /obj/item/clothing/shoes/magboots/rig/military
	glove_type = /obj/item/clothing/gloves/rig/military

/obj/item/clothing/head/helmet/space/rig/military
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_helmet_unathi.dmi'
		)

/obj/item/clothing/suit/space/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_suit_unathi.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_feet_unathi.dmi'
		)

/obj/item/clothing/gloves/rig/military
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_hands_unathi.dmi'
		)

/obj/item/weapon/rig/military/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit
		)
