/obj/item/weapon/robot_module/flying/emergency
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
		/obj/item/weapon/reagent_containers/borghypo/crisis,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/weapon/inflatable_dispenser/robot,
		/obj/item/weapon/weldingtool/mini,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wrench,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/wirecutters,
		/obj/item/device/multitool,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint
	)
	synths = list(/datum/matter_synth/medicine = 15000)
	emag = /obj/item/weapon/reagent_containers/spray
	skills = list(
		SKILL_ANATOMY      = SKILL_BASIC,
		SKILL_MEDICAL      = SKILL_PROF,
		SKILL_EVA          = SKILL_EXPERT,
		SKILL_MECH         = HAS_PERK,
		SKILL_CONSTRUCTION = SKILL_EXPERT,
		SKILL_ELECTRICAL   = SKILL_EXPERT
	)

/obj/item/weapon/robot_module/flying/emergency/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/weapon/robot_module/flying/emergency/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/weapon/robot_module/flying/emergency/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/weapon/robot_module/flying/emergency/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/spray/PS = emag
	if(PS && PS.reagents.total_volume < PS.volume)
		var/adding = min(PS.volume-PS.reagents.total_volume, 2*amount)
		if(adding > 0)
			PS.reagents.add_reagent(/datum/reagent/acid/polyacid, adding)
	..()
