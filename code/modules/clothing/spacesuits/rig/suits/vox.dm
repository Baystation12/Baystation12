/obj/item/weapon/rig/vox
	name = "alien rig control module"
	desc = "A strange rig. Parts of it writhe and squirm as if alive. The visor looks more like a thick membrane."
	suit_type = "alien rig"
	icon_state = "vox_rig"
	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_HANDGUNS, 
		energy = ARMOR_ENERGY_RESISTANT, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SHIELDED
		)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	air_type =   /obj/item/weapon/tank/nitrogen

	initial_modules = list(
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/cooling_unit
		)
/obj/item/clothing/head/helmet/space/rig/vox_rig
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/suit/space/rig/vox_rig
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/shoes/magboots/rig/vox_rig
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/gloves/rig/vox_rig
	species_restricted = list(SPECIES_VOX)
