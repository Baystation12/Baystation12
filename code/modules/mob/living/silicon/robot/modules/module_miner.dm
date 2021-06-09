/obj/item/robot_module/miner
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
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/storage/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/sheetsnatcher/borg,
		/obj/item/gripper/miner,
		/obj/item/device/scanner/mining,
		/obj/item/crowbar
	)
	emag = /obj/item/gun/energy/plasmacutter
	skills = list(
		SKILL_PILOT        = SKILL_EXPERT,
		SKILL_EVA          = SKILL_PROF,
		SKILL_CONSTRUCTION = SKILL_EXPERT
	)
	no_slip = 1
	access = list(
		access_eva,
		access_expedition_shuttle,
		access_guppy,
		access_hangar,
		access_mining,
		access_mining_office,
		access_mining_station,
		access_radio_exp,
		access_radio_sup
	)

/obj/item/robot_module/miner/handle_emagged()
	var/obj/item/pickaxe/D = locate(/obj/item/pickaxe/borgdrill) in equipment
	if(D)
		equipment -= D
		qdel(D)
	D = new /obj/item/pickaxe/diamonddrill(src)
	D.canremove = FALSE
	equipment += D
