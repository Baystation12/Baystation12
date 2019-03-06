/obj/item/weapon/robot_module/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE

/obj/item/weapon/robot_module/flying/filing
	name = "filing drone module"
	display_name = "Filing"
	channels = list("Service" = 1, "Supply" = 1)
	languages = list(
		LANGUAGE_SOL_COMMON	=  TRUE,
		LANGUAGE_UNATHI =      TRUE,
		LANGUAGE_SKRELLIAN =   TRUE,
		LANGUAGE_LUNAR =       TRUE,
		LANGUAGE_GUTTER     =  TRUE,
		LANGUAGE_INDEPENDENT = TRUE,
		LANGUAGE_SPACER =      TRUE
	)
	sprites = list(
		"Drone" = "drone-service"
	)

/obj/item/weapon/robot_module/flying/filing/New()
	modules = list(
		new /obj/item/device/flash(src),
		new /obj/item/weapon/pen/robopen(src),
		new /obj/item/weapon/form_printer(src),
		new /obj/item/weapon/gripper/clerical(src),
		new /obj/item/weapon/hand_labeler(src),
		new /obj/item/weapon/stamp(src),
		new /obj/item/weapon/stamp/denied(src),
		new /obj/item/device/destTagger(src),
		new /obj/item/weapon/crowbar(src),
		new /obj/item/device/megaphone(src)
	)
	emag = new /obj/item/weapon/stamp/chameleon(src)
	var/datum/matter_synth/package_wrap = new /datum/matter_synth/package_wrap()
	synths += package_wrap
	var/obj/item/stack/package_wrap/cyborg/PW = new /obj/item/stack/package_wrap/cyborg(src)
	PW.synths = list(package_wrap)
	modules += PW
	..()

/obj/item/weapon/robot_module/flying/emergency
	name = "emergency response drone module"
	display_name = "Emergency Response"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/datum/nano_module/crew_monitor)
	sprites = list(
		"Drone" = "drone-medical",
		"Eyebot" = "eyebot-medical"
	)

/obj/item/weapon/robot_module/flying/emergency/New()
	modules = list(
		new /obj/item/device/flash(src),
		new /obj/item/borg/sight/hud/med(src),
		new /obj/item/device/healthanalyzer(src),
		new /obj/item/device/reagent_scanner/adv(src),
		new /obj/item/weapon/reagent_containers/borghypo/crisis(src),
		new /obj/item/weapon/extinguisher/mini(src),
		new /obj/item/taperoll/medical(src),
		new /obj/item/weapon/inflatable_dispenser/robot(src),
		new /obj/item/weapon/weldingtool/mini(src),
		new /obj/item/weapon/screwdriver(src),
		new /obj/item/weapon/wrench(src),
		new /obj/item/weapon/crowbar(src),
		new /obj/item/weapon/wirecutters(src),
		new /obj/item/device/multitool(src)
	)

	emag = new /obj/item/weapon/reagent_containers/spray(src)
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000)
	synths += medicine

	var/obj/item/stack/medical/ointment/O = new /obj/item/stack/medical/ointment(src)
	var/obj/item/stack/medical/bruise_pack/B = new /obj/item/stack/medical/bruise_pack(src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	modules += list(O, B, S)
	..()

/obj/item/weapon/robot_module/flying/emergency/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/spray/PS = emag
	if(PS && PS.reagents.total_volume < PS.volume)
		var/adding = min(PS.volume-PS.reagents.total_volume, 2*amount)
		if(adding > 0)
			PS.reagents.add_reagent(/datum/reagent/acid/polyacid, adding)
	..()
