/obj/item/clothing/head/helmet/space/rig/merc
	light_overlay = "helmet_light_dual_green"
	camera = /obj/machinery/camera/network/mercenary

/obj/item/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit module with heavy armour plates."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/merc
	glove_type = /obj/item/clothing/gloves/rig/merc
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)

	initial_modules = list(
		/obj/item/rig_module/mounted/lcannon,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/gloves/rig/merc
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	siemens_coefficient = 0

//Has most of the modules removed
/obj/item/rig/merc/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/merc/heavy
	name = "crimson EOD hardsuit control module"
	desc = "A blood-red hardsuit with heavy armoured plates. Judging by the abnormally thick plates, this one is for working with explosives."
	icon_state = "merc_rig_heavy"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_SHIELDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	online_slowdown = 3
	offline_slowdown = 4
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/rig/merc/heavy/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)
