/obj/item/robot_module/medical
	name = "medical robot module"
	channels = list(
		"Medical" = TRUE
	)
	networks = list(
		NETWORK_MEDICAL
	)
	subsystems = list(
		/datum/nano_module/crew_monitor
	)
	can_be_pushed = 0
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray/chemsprayer,
		/obj/item/gun/launcher/syringe/rapid/sleepy
	)


/obj/item/robot_module/medical/build_equipment()
	. = ..()
	equipment += new /obj/item/robot_rack/roller_bed(src, 1)


/obj/item/robot_module/medical/finalize_emag()
	. = ..()

	var/obj/item/reagent_containers/spray/chemsprayer/acid = locate() in equipment
	if (acid)
		acid.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
		acid.SetName("Polyacid Spray")

	var/obj/item/shockpaddles/robot/shock = locate() in equipment
	if (shock)
		shock.safety = FALSE


/obj/item/robot_module/medical/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	if (R.emagged)
		var/obj/item/reagent_containers/spray/chemsprayer/acid = locate() in equipment
		if (acid)
			acid.reagents.add_reagent(/datum/reagent/acid/polyacid, 40 * amount)

		var/obj/item/gun/launcher/syringe/rapid/sleepy = locate() in equipment
		if (sleepy?.max_darts > length(sleepy?.darts))
			sleepy.darts += new /obj/item/syringe_cartridge/sleepy(src)


/obj/item/robot_module/medical/surgeon
	name = "surgeon robot module"
	display_name = "Surgeon"
	sprites = list(
		"Basic" = "Medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot"
		)
	equipment = list(
		/obj/item/borg/sight/hud/med,
		/obj/item/device/scanner/health,
		/obj/item/reagent_containers/borghypo/surgeon,
		/obj/item/scalpel/ims,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/bonesetter,
		/obj/item/circular_saw,
		/obj/item/surgicaldrill,
		/obj/item/gripper/organ,
		/obj/item/shockpaddles/robot,
		/obj/item/reagent_containers/syringe,
		/obj/item/crowbar,
		/obj/item/stack/nanopaste,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/spray/cleaner/drone,
		/obj/item/reagent_containers/spray/sterilizine
	)
	synths = list(
		/datum/matter_synth/medicine = 10000,
	)

	skills = list(
		SKILL_ANATOMY     = SKILL_MASTER,
		SKILL_MEDICAL     = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY   = SKILL_TRAINED,
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_DEVICES     = SKILL_EXPERIENCED
	)

/obj/item/robot_module/medical/surgeon/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/bruise_pack
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)


/obj/item/robot_module/medical/surgeon/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/bruise_pack
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)


/obj/item/robot_module/medical/surgeon/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	var/obj/item/reagent_containers/spray/sterilizine/S = locate() in equipment
	if (S)
		S.reagents.add_reagent(/datum/reagent/sterilizine, 10 * amount)


/obj/item/robot_module/medical/crisis
	name = "crisis robot module"
	display_name = "Crisis"
	sprites = list(
		"Basic" = "Medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot"
	)
	equipment = list(
		/obj/item/crowbar,
		/obj/item/borg/sight/hud/med,
		/obj/item/device/scanner/health,
		/obj/item/device/scanner/reagent/adv,
		/obj/item/robot_rack/body_bag,
		/obj/item/reagent_containers/borghypo/crisis,
		/obj/item/robot_rack/bottle,
		/obj/item/shockpaddles/robot,
		/obj/item/reagent_containers/dropper/industrial,
		/obj/item/reagent_containers/syringe,
		/obj/item/gripper/chemistry,
		/obj/item/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/splint,
		/obj/item/reagent_containers/spray/cleaner/drone
	)
	synths = list(
		/datum/matter_synth/medicine = 15000
	)
	skills = list(
		SKILL_ANATOMY     = SKILL_BASIC,
		SKILL_MEDICAL     = SKILL_MASTER,
		SKILL_CHEMISTRY   = SKILL_TRAINED,
		SKILL_BUREAUCRACY = SKILL_TRAINED,
		SKILL_EVA         = SKILL_EXPERIENCED
	)

/obj/item/robot_module/medical/crisis/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)


/obj/item/robot_module/medical/crisis/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/robot_module/medical/crisis/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	var/obj/item/reagent_containers/syringe/S = locate() in equipment
	if (S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
