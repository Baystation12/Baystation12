/obj/item/robot_module/engineering
	name = "engineering robot module"
	display_name = "Engineering"
	channels = list(
		"Engineering" = 1
	)
	networks = list(
		NETWORK_ENGINEERING
	)
	subsystems = list(
		/datum/nano_module/power_monitor,
		/datum/nano_module/supermatter_monitor
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/rcd
	)
	sprites = list(
		"Basic" = "Engineering",
		"Antique" = "engineerrobot",
		"Landmate" = "landmate",
		"Landmate - Treaded" = "engiborg+tread"
	)
	no_slip = 1
	equipment = list(
		/obj/item/borg/sight/meson,
		/obj/item/extinguisher,
		/obj/item/weldingtool/hugetank,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/device/multitool,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/device/geiger,
		/obj/item/taperoll/engineering,
		/obj/item/taperoll/atmos,
		/obj/item/gripper,
		/obj/item/gripper,
		/obj/item/gripper/no_use/loader,
		/obj/item/device/lightreplacer,
		/obj/item/device/paint_sprayer,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/reagent_containers/spray/cleaner/drone,
		/obj/item/inducer/borg,
		/obj/item/device/plunger/robot,
		/obj/item/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/aluminium,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/wood,
		/obj/item/stack/tile/wood/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel
	)
	synths = list(
		/datum/matter_synth/metal =    60000,
		/datum/matter_synth/glass =    40000,
		/datum/matter_synth/wood =     30000,
		/datum/matter_synth/plasteel = 20000,
		/datum/matter_synth/wire =     50
	)
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/device/flash,
		/obj/item/rcd/borg,
		/obj/item/flamethrower/full/loaded,
		/obj/item/shield_diffuser,
		/obj/item/gun/launcher/grenade/foam
	)

	skills = list(
		SKILL_ATMOS        = SKILL_MASTER,
		SKILL_ENGINES      = SKILL_MASTER,
		SKILL_CONSTRUCTION = SKILL_MASTER,
		SKILL_ELECTRICAL   = SKILL_MASTER,
		SKILL_COMPUTER     = SKILL_EXPERIENCED
	)

	var/flamethrower_recharge_modifier = 8

/obj/item/robot_module/engineering/finalize_synths()

	var/datum/matter_synth/metal/metal =       locate() in synths
	var/datum/matter_synth/glass/glass =       locate() in synths
	var/datum/matter_synth/wood/wood =         locate() in synths
	var/datum/matter_synth/plasteel/plasteel = locate() in synths
	var/datum/matter_synth/wire/wire =         locate() in synths

	var/obj/item/matter_decompiler/MD = locate() in equipment
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/steel,
		 /obj/item/stack/material/cyborg/aluminium,
		 /obj/item/stack/material/rods/cyborg,
		 /obj/item/stack/tile/floor/cyborg,
		 /obj/item/stack/material/cyborg/glass/reinforced
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, metal)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass/reinforced,
		 /obj/item/stack/material/cyborg/glass
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, glass)

	for(var/thing in list(
		 /obj/item/stack/tile/wood/cyborg,
		 /obj/item/stack/material/cyborg/wood
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, wood)

	var/obj/item/stack/cable_coil/cyborg/C = locate() in equipment
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plasteel/PL = locate() in equipment
	PL.synths = list(plasteel)

/obj/item/robot_module/engineering/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	if (LR)
		LR.Charge(R, amount)

	if (R.emagged)
		var/obj/item/flamethrower/full/loaded/flamethrower = locate() in equipment
		if (flamethrower)
			flamethrower.beaker.reagents.add_reagent(/datum/reagent/napalm, flamethrower_recharge_modifier * amount)

		var/obj/item/shield_diffuser/diff = locate() in equipment
		if (diff)
			diff.cell.charge += amount

		var/obj/item/gun/launcher/grenade/foam/foam = locate() in equipment
		if (foam?.max_grenades > length(foam?.grenades))
			foam.grenades += new /obj/item/grenade/chem_grenade/metalfoam(src)
