/obj/item/robot_module/flying/emergency
	name = "emergency response drone module"
	display_name = "Emergency Response"
	channels = list("Medical" = TRUE)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/datum/nano_module/crew_monitor)
	sprites = list(
		"Drone" = "drone-medical",
		"Eyebot" = "eyebot-medical"
	)
	equipment = list(
		/obj/item/borg/sight/hud/med,
		/obj/item/device/scanner/health,
		/obj/item/device/scanner/reagent/adv,
		/obj/item/reagent_containers/borghypo/crisis,
		/obj/item/robot_rack/bottle,
		/obj/item/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/weldingtool/mini,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/device/multitool,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/splint,
		/obj/item/robot_rack/roller_bed,
		/obj/item/gripper/auto_cpr,
		/obj/item/gripper/ivbag,
		/obj/item/reagent_containers/spray/cleaner/drone
	)
	synths = list(/datum/matter_synth/medicine = 15000)
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/device/flash,
		/obj/item/gun/energy/gun,
		/obj/item/reagent_containers/spray,
		/obj/item/gun/launcher/syringe/rapid/sleepy,
		/obj/item/shockpaddles/robot
	)
	skills = list(
		SKILL_ANATOMY      = SKILL_BASIC,
		SKILL_MEDICAL      = SKILL_MASTER,
		SKILL_EVA          = SKILL_EXPERIENCED,
		SKILL_CONSTRUCTION = SKILL_EXPERIENCED,
		SKILL_ELECTRICAL   = SKILL_EXPERIENCED
	)

/obj/item/robot_module/medical/finalize_emag()
	. = ..()

	var/obj/item/reagent_containers/spray/acid = locate() in equipment
	acid.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	acid.SetName("Polyacid spray")

	var/obj/item/shockpaddles/robot/shock = locate() in equipment
	shock.safety = FALSE


/obj/item/robot_module/medical/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	if (R.emagged)
		var/obj/item/reagent_containers/spray/acid = locate() in equipment
		acid.reagents.add_reagent(/datum/reagent/acid/polyacid, 2 * amount)

		var/obj/item/gun/launcher/syringe/rapid/sleepy = locate() in equipment
		if (sleepy.darts < sleepy.max_darts)
			sleepy.darts += new /obj/item/syringe_cartridge/sleepy(src)


/obj/item/robot_module/flying/emergency/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)
	// Start out equipped with a roller bed
	var/obj/item/robot_rack/roller_bed/roller_rack = locate() in equipment
	roller_rack.held += new /obj/item/roller_bed()
	// and an auto-compressor
	var/obj/item/gripper/auto_cpr/cpr_gripper = locate() in equipment
	cpr_gripper.wrapped = new /obj/item/auto_cpr()
	cpr_gripper.update_icon()

/obj/item/robot_module/flying/emergency/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)
