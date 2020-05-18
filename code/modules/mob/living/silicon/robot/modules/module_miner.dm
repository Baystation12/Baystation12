/obj/item/weapon/robot_module/miner
	name = "miner robot module"
	display_name = "Miner"
	subsystems = list(
		/datum/nano_module/supply
	)
	channels = list(
		"Supply" = TRUE,
		"Science" = TRUE
	)
	networks = list(
		NETWORK_MINE
	)
	sprites = list(
		"Basic" = "Miner_old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "Miner"
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/jetpack
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/meson,
		/obj/item/weapon/wrench,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/storage/ore,
		/obj/item/weapon/pickaxe/borgdrill,
		/obj/item/weapon/storage/sheetsnatcher/borg,
		/obj/item/weapon/gripper/miner,
		/obj/item/device/scanner/mining,
		/obj/item/weapon/crowbar
	)
	emag = /obj/item/weapon/gun/energy/plasmacutter
	skills = list(
		SKILL_PILOT        = SKILL_EXPERT,
		SKILL_EVA          = SKILL_PROF,
		SKILL_MECH         = HAS_PERK,
		SKILL_CONSTRUCTION = SKILL_EXPERT
	)

/obj/item/weapon/robot_module/miner/handle_emagged()
	var/obj/item/weapon/pickaxe/D = locate(/obj/item/weapon/pickaxe/borgdrill) in equipment
	if(D)
		equipment -= D
		qdel(D)
	D = new /obj/item/weapon/pickaxe/diamonddrill(src)
	D.canremove = FALSE
	equipment += D
