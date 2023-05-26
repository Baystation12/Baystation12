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
		/obj/item/device/flash,
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
	emag = /obj/item/reagent_containers/spray
	skills = list(
		SKILL_ANATOMY      = SKILL_BASIC,
		SKILL_MEDICAL      = SKILL_MASTER,
		SKILL_EVA          = SKILL_EXPERIENCED,
		SKILL_CONSTRUCTION = SKILL_EXPERIENCED,
		SKILL_ELECTRICAL   = SKILL_EXPERIENCED
	)

/obj/item/robot_module/flying/emergency/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

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

/obj/item/robot_module/flying/emergency/respawn_consumable(mob/living/silicon/robot/R, amount)
	var/obj/item/reagent_containers/spray/PS = emag
	if(PS && PS.reagents.total_volume < PS.volume)
		var/adding = min(PS.volume-PS.reagents.total_volume, 2*amount)
		if(adding > 0)
			PS.reagents.add_reagent(/datum/reagent/acid/polyacid, adding)
	..()
