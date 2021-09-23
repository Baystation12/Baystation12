/obj/item/robot_module/flying/repair
	name = "repair drone module"
	display_name = "Repair"
	channels = list ("Engineering" = TRUE)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(
		/datum/nano_module/power_monitor,
		/datum/nano_module/supermatter_monitor
	)
	sprites = list(
		"Drone" = "drone-engineer",
		"Eyebot" = "eyebot-engineering"
	)
	equipment = list(
		/obj/item/borg/sight/meson,
		/obj/item/extinguisher,
		/obj/item/weldingtool/largetank,
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
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel
	)
	synths = list(
		/datum/matter_synth/metal = 	30000,
		/datum/matter_synth/glass = 	20000,
		/datum/matter_synth/plasteel = 	10000,
		/datum/matter_synth/wire = 		40
	)
	emag = /obj/item/melee/baton/robot/electrified_arm
	skills = list(
		SKILL_ATMOS        = SKILL_PROF,
		SKILL_ENGINES      = SKILL_PROF,
		SKILL_CONSTRUCTION = SKILL_PROF,
		SKILL_ELECTRICAL   = SKILL_PROF
	)

/obj/item/robot_module/flying/repair/finalize_synths()
	. = ..()
	var/datum/matter_synth/metal/metal =       locate() in synths
	var/datum/matter_synth/glass/glass =       locate() in synths
	var/datum/matter_synth/plasteel/plasteel = locate() in synths
	var/datum/matter_synth/wire/wire =         locate() in synths

	var/obj/item/matter_decompiler/MD = locate() in equipment
	MD.metal = metal
	MD.glass = glass

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

	var/obj/item/stack/cable_coil/cyborg/C = locate() in equipment
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plasteel/PL = locate() in equipment
	PL.synths = list(plasteel)
	. = ..()

/obj/item/robot_module/flying/repair/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	if(LR)
		LR.Charge(R, amount)
	..()
