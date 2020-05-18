/obj/item/weapon/robot_module/flying/cultivator
	name = "cultivator drone module"
	display_name = "Cultivator"
	channels = list(
		"Science" = TRUE,
		"Service" = TRUE
	)
	sprites = list("Drone" = "drone-hydro")

	equipment = list(
		/obj/item/weapon/storage/plants,
		/obj/item/weapon/wirecutters/clippers,
		/obj/item/weapon/material/minihoe/unbreakable,
		/obj/item/weapon/material/hatchet/unbreakable,
		/obj/item/weapon/reagent_containers/glass/bucket,
		/obj/item/weapon/scalpel/laser1,
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/extinguisher,
		/obj/item/weapon/gripper/cultivator,
		/obj/item/device/scanner/plant,
		/obj/item/weapon/robot_harvester
	)
	emag = /obj/item/weapon/melee/energy/machete
	skills = list(
		SKILL_BOTANY    = SKILL_MAX,
		SKILL_COMBAT    = SKILL_EXPERT,
		SKILL_CHEMISTRY = SKILL_EXPERT,
		SKILL_SCIENCE   = SKILL_EXPERT,
	)