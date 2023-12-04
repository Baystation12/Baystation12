/obj/item/robot_module/research
	name = "research module"
	display_name = "Research"
	channels = list(
		"Science" = TRUE
	)
	networks = list(
		NETWORK_RESEARCH
	)
	sprites = list(
		"Droid" = "droid-science"
	)
	equipment = list(
		/obj/item/portable_destructive_analyzer,
		/obj/item/gripper/research,
		/obj/item/gripper/no_use/loader,
		/obj/item/device/robotanalyzer,
		/obj/item/card/robot,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/weldingtool/mini,
		/obj/item/wirecutters,
		/obj/item/crowbar,
		/obj/item/scalpel/laser,
		/obj/item/circular_saw,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/syringe,
		/obj/item/gripper/chemistry,
		/obj/item/stack/nanopaste
	)
	synths = list(
		/datum/matter_synth/nanite = 10000
	)
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/device/flash,
		/obj/prefab/hand_teleporter,
		/obj/item/gun/energy/decloner
	)

	skills = list(
		SKILL_BUREAUCRACY         = SKILL_EXPERIENCED,
		SKILL_FINANCE             = SKILL_EXPERIENCED,
		SKILL_COMPUTER            = SKILL_MASTER,
		SKILL_SCIENCE             = SKILL_MASTER,
		SKILL_DEVICES             = SKILL_MASTER,
		SKILL_ANATOMY             = SKILL_TRAINED,
		SKILL_CHEMISTRY           = SKILL_TRAINED,
		SKILL_BOTANY              = SKILL_EXPERIENCED,
		SKILL_ELECTRICAL          = SKILL_EXPERIENCED
	)

/obj/item/robot_module/research/finalize_equipment()
	. = ..()
	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.uses_charge = 1
	N.charge_costs = list(1000)

/obj/item/robot_module/research/finalize_synths()
	. = ..()
	var/datum/matter_synth/nanite/nanite = locate() in synths
	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.synths = list(nanite)
