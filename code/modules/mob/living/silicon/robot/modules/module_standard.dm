/obj/item/robot_module/standard
	name = "standard robot module"
	display_name = "Standard"
	sprites = list(
		"Basic" = "robot_old",
		"Android" = "droid",
		"Default" = "robot"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/extinguisher,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/device/scanner/health
	)
	emag = /obj/item/melee/energy/sword
	skills = list(
		SKILL_COMBAT       = SKILL_TRAINED,
		SKILL_MEDICAL      = SKILL_TRAINED,
		SKILL_CONSTRUCTION = SKILL_TRAINED,
		SKILL_BUREAUCRACY  = SKILL_TRAINED
	)
