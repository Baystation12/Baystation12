/obj/item/weapon/robot_module/standard
	name = "standard robot module"
	display_name = "Standard"
	sprites = list(
		"Basic" = "robot_old",
		"Android" = "droid",
		"Default" = "robot"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/extinguisher,
		/obj/item/weapon/wrench,
		/obj/item/weapon/crowbar,
		/obj/item/device/scanner/health
	)
	emag = /obj/item/weapon/melee/energy/sword
	skills = list(
		SKILL_COMBAT       = SKILL_ADEPT,
		SKILL_MEDICAL      = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_BUREAUCRACY  = SKILL_ADEPT
	)
