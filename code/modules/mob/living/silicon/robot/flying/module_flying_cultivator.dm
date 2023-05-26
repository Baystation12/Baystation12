/obj/item/robot_module/flying/cultivator
	name = "cultivator drone module"
	display_name = "Cultivator"
	channels = list(
		"Science" = TRUE,
		"Service" = TRUE
	)
	sprites = list("Drone" = "drone-hydro")

	equipment = list(
		/obj/item/storage/plants,
		/obj/item/wirecutters/clippers,
		/obj/item/material/minihoe/unbreakable,
		/obj/item/material/hatchet/unbreakable,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/scalpel/laser,
		/obj/item/circular_saw,
		/obj/item/extinguisher,
		/obj/item/gripper/cultivator,
		/obj/item/device/scanner/plant,
		/obj/item/robot_harvester
	)
	emag = /obj/item/melee/energy/machete
	skills = list(
		SKILL_BOTANY    = SKILL_MAX,
		SKILL_COMBAT    = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY = SKILL_EXPERIENCED,
		SKILL_SCIENCE   = SKILL_EXPERIENCED,
	)
