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

/obj/item/weapon/robot_module/flying/filing/Initialize()
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
	. = ..()

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

/obj/item/weapon/robot_module/flying/emergency/Initialize()
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
	. = ..()

/obj/item/weapon/robot_module/flying/emergency/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/spray/PS = emag
	if(PS && PS.reagents.total_volume < PS.volume)
		var/adding = min(PS.volume-PS.reagents.total_volume, 2*amount)
		if(adding > 0)
			PS.reagents.add_reagent(/datum/reagent/acid/polyacid, adding)
	..()

/obj/item/weapon/robot_module/flying/repair
	name = "repair drone module"
	channels = list("Engineering" = 1)
	display_name = "Repair"
	sprites = list(
		"Drone" = "drone-engineer",
		"Eyebot" = "eyebot-engineering"
	)

/obj/item/weapon/robot_module/flying/repair/Initialize()
	modules = list(
		new /obj/item/borg/sight/meson(src),
		new /obj/item/weapon/extinguisher(src),
		new /obj/item/weapon/weldingtool/largetank(src),
		new /obj/item/weapon/screwdriver(src),
		new /obj/item/weapon/wrench(src),
		new /obj/item/weapon/crowbar(src),
		new /obj/item/weapon/wirecutters(src),
		new /obj/item/device/multitool(src),
		new /obj/item/device/t_scanner(src),
		new /obj/item/device/analyzer(src),
		new /obj/item/device/geiger(src),
		new /obj/item/taperoll/engineering(src),
		new /obj/item/taperoll/atmos(src),
		new /obj/item/weapon/gripper(src),
		new /obj/item/weapon/gripper/no_use/loader(src),
		new /obj/item/device/lightreplacer(src),
		new /obj/item/device/pipe_painter(src),
		new /obj/item/device/floor_painter(src),
		new /obj/item/weapon/inflatable_dispenser/robot(src),
		new /obj/item/inducer/borg(src),
		new /obj/item/device/plunger/robot(src)
	)

	emag = new /obj/item/weapon/melee/baton/robot/electrified_arm(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(60000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += metal
	synths += glass
	synths += plasteel
	synths += wire

	var/obj/item/weapon/matter_decompiler/MD = new /obj/item/weapon/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	modules += M

	var/obj/item/stack/material/cyborg/aluminium/AL = new (src)
	M.synths = list(metal)
	modules += AL

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	modules += G

	var/obj/item/stack/material/rods/cyborg/R = new /obj/item/stack/material/rods/cyborg(src)
	R.synths = list(metal)
	modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	modules += RG

	var/obj/item/stack/material/cyborg/plasteel/PL = new (src)
	PL.synths = list(plasteel)
	modules += PL

	. = ..()

/obj/item/weapon/robot_module/flying/repair/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in modules
	if(LR)
		LR.Charge(R, amount)
	..()

/obj/item/weapon/robot_module/flying/cultivator
	name = "cultivator drone module"
	display_name = "Cultivator"
	channels = list("Science" = 1, "Service" = 1)
	sprites = list(
		"Drone" = "drone-hydro"
	)

/obj/item/weapon/robot_module/flying/cultivator/Initialize()
	modules = list(
		new /obj/item/weapon/storage/plants(src),
		new /obj/item/weapon/wirecutters/clippers(src),
		new /obj/item/weapon/material/minihoe/unbreakable(src),
		new /obj/item/weapon/material/hatchet/unbreakable(src),
		new /obj/item/weapon/reagent_containers/glass/bucket(src),
		new /obj/item/weapon/scalpel/laser1(src),
		new /obj/item/weapon/circular_saw(src),
		new /obj/item/weapon/extinguisher(src),
		new /obj/item/weapon/gripper/cultivator(src)
	)

/obj/item/weapon/robot_module/flying/surveyor
	name = "survey drone module"
	display_name = "Surveyor"
	channels = list(
		"Science" = TRUE,
		"Exploration" = TRUE
	)
	sprites = list(
		"Drone"  = "drone-science",
		"Eyebot" = "eyebot-science"
	)
	var/list/flag_types = list(
		/obj/item/stack/flag/yellow,
		/obj/item/stack/flag/green,
		/obj/item/stack/flag/red
	)

/obj/item/weapon/robot_module/flying/surveyor/Initialize()
	modules = list(
		new /obj/item/weapon/material/hatchet/machete/unbreakable(src),
		new /obj/item/inducer/borg(src),
		new /obj/item/device/analyzer(src),
		new /obj/item/weapon/storage/plants(src),
		new /obj/item/weapon/wirecutters/clippers(src),
		new /obj/item/weapon/mining_scanner(src),
		new /obj/item/weapon/extinguisher(src),
		new /obj/item/weapon/gun/launcher/net/borg(src),
		new /obj/item/weapon/weldingtool/largetank(src),
		new /obj/item/weapon/screwdriver(src),
		new /obj/item/weapon/wrench(src),
		new /obj/item/weapon/crowbar(src),
		new /obj/item/weapon/wirecutters(src),
		new /obj/item/device/multitool(src),
		new /obj/item/bioreactor(src)
	)
	for(var/flag_type in flag_types)
		modules += new flag_type(src)
	. = ..()

/obj/item/weapon/robot_module/flying/surveyor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/gun/launcher/net/borg/gun = locate() in modules
	if(!gun)
		gun = new(src)
		modules += gun
	if(gun.shells < gun.max_shells)
		gun.load(new /obj/item/weapon/net_shell)

	for(var/flagtype in flag_types)
		var/obj/item/stack/flag/flag = locate(flagtype) in modules
		if(!flag)
			flag = new flagtype
			modules += flag
		if(flag.amount < flag.max_amount)
			flag.add(1)
	..()

/obj/item/weapon/robot_module/flying/forensics
	name = "forensic drone module"
	display_name = "Forensics"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/datum/nano_module/crew_monitor, /datum/nano_module/digitalwarrant)
	sprites = list(
		"Drone" = "drone-sec",
		"Eyebot" = "eyebot-security"
	)

/obj/item/weapon/robot_module/flying/forensics/Initialize()
	modules = list(
		new /obj/item/swabber(src),
		new /obj/item/weapon/storage/evidence(src),
		new /obj/item/weapon/forensics/sample_kit(src),
		new /obj/item/weapon/forensics/sample_kit/powder(src),
		new /obj/item/device/flash(src),
		new /obj/item/borg/sight/hud/sec(src),
		new /obj/item/weapon/gun/energy/gun/secure/mounted(src),
		new /obj/item/taperoll/police(src),
		new /obj/item/weapon/scalpel/laser1(src),
		new /obj/item/weapon/autopsy_scanner(src),
		new /obj/item/weapon/reagent_containers/spray/luminol(src),
		new /obj/item/device/uv_light(src),
		new /obj/item/weapon/crowbar(src)
	)
	emag = new /obj/item/weapon/gun/energy/laser/mounted(src)
	. = ..()

/obj/item/weapon/robot_module/flying/forensics/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/spray/luminol/luminol = locate() in modules
	if(!luminol)
		luminol = new(src)
		modules += luminol
	if(luminol.reagents.total_volume < luminol.volume)
		var/adding = min(luminol.volume-luminol.reagents.total_volume, 2*amount)
		if(adding > 0)
			luminol.reagents.add_reagent(/datum/reagent/luminol, adding)
	..()

/obj/item/weapon/robot_module/flying/surveyor
	networks = list(NETWORK_EXPEDITION)