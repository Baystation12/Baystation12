/obj/item/weapon/robot_module/medical
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

/obj/item/weapon/robot_module/medical/build_equipment()
	. = ..()
	equipment += new /obj/item/robot_rack/roller(src, 1)

/obj/item/weapon/robot_module/medical/surgeon
	name = "surgeon robot module"
	display_name = "Surgeon"
	sprites = list(
		"Basic" = "Medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot"
		)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/device/scanner/health,
		/obj/item/weapon/reagent_containers/borghypo/surgeon,
		/obj/item/weapon/scalpel/manager,
		/obj/item/weapon/hemostat,
		/obj/item/weapon/retractor,
		/obj/item/weapon/cautery,
		/obj/item/weapon/bonegel,
		/obj/item/weapon/FixOVein,
		/obj/item/weapon/bonesetter,
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/surgicaldrill,
		/obj/item/weapon/gripper/organ,
		/obj/item/weapon/shockpaddles/robot,
		/obj/item/weapon/crowbar,
		/obj/item/stack/nanopaste,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/weapon/reagent_containers/dropper/
	)
	synths = list(
		/datum/matter_synth/medicine = 10000,
	)
	emag = /obj/item/weapon/reagent_containers/spray
	skills = list(
		SKILL_ANATOMY     = SKILL_PROF,
		SKILL_MEDICAL     = SKILL_EXPERT,
		SKILL_CHEMISTRY   = SKILL_ADEPT,
		SKILL_BUREAUCRACY = SKILL_ADEPT,
		SKILL_DEVICES     = SKILL_EXPERT
	)

/obj/item/weapon/robot_module/medical/surgeon/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/bruise_pack
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/weapon/robot_module/medical/surgeon/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/weapon/robot_module/medical/surgeon/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths 
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/bruise_pack
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/weapon/robot_module/medical/surgeon/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	if(emag)
		var/obj/item/weapon/reagent_containers/spray/PS = emag
		PS.reagents.add_reagent(/datum/reagent/acid/polyacid, 2 * amount)
	..()

/obj/item/weapon/robot_module/medical/crisis
	name = "crisis robot module"
	display_name = "Crisis"
	sprites = list(
		"Basic" = "Medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot"
	)
	equipment = list(
		/obj/item/weapon/crowbar,
		/obj/item/device/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/device/scanner/health,
		/obj/item/device/scanner/reagent/adv,
		/obj/item/robot_rack/body_bag,
		/obj/item/weapon/reagent_containers/borghypo/crisis,
		/obj/item/weapon/shockpaddles/robot,
		/obj/item/weapon/reagent_containers/dropper/industrial,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/gripper/chemistry,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/weapon/inflatable_dispenser/robot,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint
	)
	synths = list(
		/datum/matter_synth/medicine = 15000
	)
	emag = /obj/item/weapon/reagent_containers/spray
	skills = list(
		SKILL_ANATOMY     = SKILL_BASIC,
		SKILL_MEDICAL     = SKILL_PROF,
		SKILL_CHEMISTRY   = SKILL_ADEPT,
		SKILL_BUREAUCRACY = SKILL_ADEPT,
		SKILL_EVA         = SKILL_EXPERT,
		SKILL_MECH        = HAS_PERK
	)

/obj/item/weapon/robot_module/medical/crisis/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/weapon/robot_module/medical/crisis/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/weapon/robot_module/medical/crisis/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/weapon/robot_module/medical/crisis/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/syringe/S = locate() in equipment
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/weapon/reagent_containers/spray/PS = emag
		PS.reagents.add_reagent(/datum/reagent/acid/polyacid, 2 * amount)
	..()
