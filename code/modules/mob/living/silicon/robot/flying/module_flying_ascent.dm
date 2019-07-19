/obj/item/weapon/robot_module/flying/ascent
	name = "\improper Ascent drone module"
	display_name = "Ascent"
	upgrade_locked = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Drone" = "drone-ascent"
	)
	// The duplicate clustertools in this list are so that they can set up to 
	// hack doors, windows etc. without having to constantly cycle through tools.
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/gun/energy/particle/small,
		/obj/item/device/multitool/mantid,
		/obj/item/clustertool,
		/obj/item/clustertool, 
		/obj/item/clustertool,
		/obj/item/weapon/weldingtool/electric/mantid,
		/obj/item/stack/cable_coil/fabricator,
		/obj/item/weapon/extinguisher,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/device/scanner/health,
		/obj/item/device/geiger,
		/obj/item/weapon/gripper,
		/obj/item/weapon/gripper/no_use/loader,
		/obj/item/inducer/borg,
		/obj/item/stack/medical/resin,
		/obj/item/weapon/surgicaldrill,
		/obj/item/weapon/hemostat,
		/obj/item/weapon/bonesetter,
		/obj/item/weapon/circular_saw,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/aluminium,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel,
		/obj/item/device/plunger/robot
	)
	synths = list(
		/datum/matter_synth/metal = 	30000,
		/datum/matter_synth/glass = 	20000,
		/datum/matter_synth/plasteel = 	10000
	)

	languages = list(
		LANGUAGE_MANTID_VOCAL     = TRUE,
		LANGUAGE_MANTID_NONVOCAL  = TRUE,
		LANGUAGE_MANTID_BROADCAST = TRUE,
		LANGUAGE_SKRELLIAN        = TRUE,
		LANGUAGE_NABBER           = TRUE
	)

/obj/item/weapon/robot_module/flying/ascent/Initialize()
	for(var/decl/hierarchy/skill/skill in GLOB.skills)
		skills[skill.type] = SKILL_EXPERT
	. = ..()

/obj/item/weapon/robot_module/flying/ascent/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/stack/medical/resin/drone/resin = locate() in equipment
	if(!resin)
		resin = new(src, amount = 1)
		equipment += resin
	if(resin.get_amount() < resin.get_max_amount())
		resin.add(1)
	..()