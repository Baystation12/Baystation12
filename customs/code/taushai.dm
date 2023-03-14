/obj/item/rig/taushai
	name = "outdated Hel-Quo HCM"
	desc = "A suit control module designed by the Hel-Quo for for engineering operations. The best of the best, albeit outdated now."
	icon = 'customs/icons/obj/custom_items_obj.dmi'
	icon_state = "tup2_rig"
	suit_type = "outdated Hel-Quo"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_SHIELDED
		)
	online_slowdown = 1
	offline_slowdown = 2.5
	allowed = list(/obj/item/device/flashlight, /obj/item/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/handcuffs,/obj/item/device/t_scanner, /obj/item/rcd, /obj/item/crowbar, \
	/obj/item/screwdriver, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/scanner/gas,/obj/item/storage/briefcase/inflatable, /obj/item/melee/baton, /obj/item/gun, \
	/obj/item/storage/firstaid, /obj/item/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit, /obj/item/storage/backpack)
	sprite_sheets = list(
		SPECIES_SKRELL = 'customs/icons/mob/custom_items_mob.dmi'
	)

	helm_type = /obj/item/clothing/head/helmet/space/rig/taushai
	chest_type = /obj/item/clothing/suit/space/rig/taushai
	boot_type = /obj/item/clothing/shoes/magboots/rig/taushai
	glove_type = /obj/item/clothing/gloves/rig/taushai
	air_type = null
	cell_type = null

/obj/item/clothing/suit/space/rig/taushai
	name = "HCM chestpiece"
	desc = "A powerful hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	species_restricted = list(SPECIES_SKRELL)
	icon = 'customs/icons/obj/custom_items_suit.dmi'
	icon_state = "tup2_rig"
	sprite_sheets = list(
		SPECIES_SKRELL = 'customs/icons/mob/custom_items_onsuit.dmi'
	)

/obj/item/clothing/head/helmet/space/rig/taushai
	name = "HCM helmet"
	desc = "A powerful hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	light_overlay = "tup2_rig_helmetlight"
	icon = 'customs/icons/obj/custom_items_head.dmi'
	icon_state = "tup2_rig"
	brightness_on = 0.8
	species_restricted = list(SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_SKRELL = 'customs/icons/mob/custom_items_onhead.dmi'
	)

/obj/item/clothing/shoes/magboots/rig/taushai
	name = "HCM boots"
	desc = "A powerful hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	species_restricted = list(SPECIES_SKRELL)
	icon = 'customs/icons/obj/custom_items_shoes.dmi'
	icon_state = "tup2_rig"
	sprite_sheets = list(
		SPECIES_SKRELL = 'customs/icons/mob/custom_items_onshoes.dmi'
	)

/obj/item/clothing/gloves/rig/taushai
	name = "HCM gloves"
	desc = "A powerful hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	siemens_coefficient = 0
	icon = 'customs/icons/obj/custom_items_gloves.dmi'
	icon_state = "tup2_rig"
	species_restricted = list(SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_SKRELL = 'customs/icons/mob/custom_items_ongloves.dmi'
	)
